SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	init_order = SS_INIT_TICKER
	priority = SS_PRIORITY_TICKER
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME

	var/current_state = GAME_STATE_STARTUP //State of current round used by process()
	var/force_ending = FALSE //Round was ended by admin intervention
	var/bypass_checks = FALSE //Bypass mode init checks
	var/setup_failed = FALSE //If the setup has failed at any point
	var/setup_started = FALSE

	var/datum/game_mode/mode = null
	var/datum/authority/branch/role/role_authority = null

	var/list/login_music = null //Music played in pregame lobby

	var/delay_end = FALSE //If set true, the round will not restart on it's own
	var/delay_start = FALSE
	var/admin_delay_notice = "" //A message to display to anyone who tries to restart the world after a delay

	var/time_left //Pre-game timer
	var/start_at

	var/roundend_check_paused = FALSE

	var/round_start_time = 0
	var/list/round_start_events
	var/list/round_end_events

	var/graceful = FALSE //Will this server gracefully shut down?

	var/queue_delay = 0
	var/list/queued_players = list() //used for join queues when the server exceeds the hard population cap

	var/list/minds = list()

	var/automatic_delay_end = FALSE

	///If we have already done tip of the round.
	var/tipped

	var/totalPlayers = 0 //used for pregame stats on statpanel
	var/totalPlayersReady = 0 //used for pregame stats on statpanel

/datum/controller/subsystem/ticker/Initialize(timeofday)
	var/all_music = CONFIG_GET(keyed_list/lobby_music)
	var/key = SAFEPICK(all_music)
	if(key)
		login_music = file(all_music[key])
	mode = config.pick_mode(GLOB.master_mode)
	mode.setup_round_stats()
	if(!role_authority)
		role_authority = new /datum/authority/branch/role()
		INIT_ANNOUNCE("\b Job setup complete")
	return SS_INIT_SUCCESS

/datum/controller/subsystem/ticker/fire(resumed = FALSE)
	switch(current_state)
		if(GAME_STATE_STARTUP)
			if(Master.initializations_finished_with_no_players_logged_in && !length(GLOB.clients))
				return
			if(isnull(start_at))
				start_at = time_left || world.time + (CONFIG_GET(number/lobby_countdown) * 10)
			var/message_send = list(CLIENT_LANGUAGE_ENGLISH = SPAN_ROUNDHEADER("[LANGUAGE_WELCOME_ENG] [CONFIG_GET(string/servername)]!"), CLIENT_LANGUAGE_RUSSIAN = SPAN_ROUNDHEADER("[LANGUAGE_WELCOME_RU] [CONFIG_GET(string/servername)]!"))
			var/countdown = time_left || CONFIG_GET(number/lobby_countdown) * 10
			var/second_message_send = list(CLIENT_LANGUAGE_ENGLISH = SPAN_ROUNDBODY("[LANGUAGE_WELCOME_SET_ENG] [DisplayTimeText(countdown, language = CLIENT_LANGUAGE_ENGLISH)]"), CLIENT_LANGUAGE_RUSSIAN = SPAN_ROUNDBODY("[LANGUAGE_WELCOME_SET_RU] [DisplayTimeText(countdown, language = CLIENT_LANGUAGE_RUSSIAN)]"))
			to_chat_spaced(world, message_send, MESSAGE_TYPE_SYSTEM, margin_top = 2, margin_bottom = 0)
			to_chat_spaced(world, second_message_send, MESSAGE_TYPE_SYSTEM, margin_top = 0)
			SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MODE_PREGAME_LOBBY)
			current_state = GAME_STATE_PREGAME
			fire()

		if(GAME_STATE_PREGAME)
			if(isnull(time_left))
				time_left = max(0, start_at - world.time)

			totalPlayers = length(GLOB.new_player_list)
			totalPlayersReady = 0
			for(var/i in GLOB.new_player_list)
				var/mob/new_player/player = i
				if(player.ready) // TODO: port this  == PLAYER_READY_TO_PLAY)
					++totalPlayersReady
			if(time_left < 0 || delay_start)
				return

			time_left -= wait

			if(time_left <= 40 SECONDS && !tipped)
				send_tip_of_the_round()
				tipped = TRUE
				flash_clients()

			if(time_left <= 0)
				request_start()

		if(GAME_STATE_PLAYING)
			mode.process(wait * 0.1)

			if((!roundend_check_paused && mode.check_finished(force_ending)) || force_ending)
				current_state = GAME_STATE_FINISHED
				ooc_allowed = TRUE
				mode.declare_completion(force_ending)
				REDIS_PUBLISH("byond.round", "type" = "round-complete")
				flash_clients()
				if(text2num(SSperf_logging?.round?.id) % CONFIG_GET(number/gamemode_rounds_needed) == 0 || GLOB.master_mode != MODE_NAME_DISTRESS_SIGNAL)
					addtimer(CALLBACK(
						SSvote,
						/datum/controller/subsystem/vote/proc/initiate_vote,
						"gamemode",
						"SERVER",
						CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/ticker, handle_map_reboot)),
						TRUE
					), 3 SECONDS)
				else
					handle_map_reboot()
				Master.SetRunLevel(RUNLEVEL_POSTGAME)

/// Attempt to start game asynchronously if applicable
/datum/controller/subsystem/ticker/proc/request_start()
	if(current_state == GAME_STATE_PREGAME)
		time_left = 0

	// Killswitch if hanging or interrupted
	if(SSnightmare.stat != NIGHTMARE_STATUS_DONE)
		if(SSnightmare.start_time && (world.time - SSnightmare.start_time) > 30 SECONDS)
			SSnightmare.stat = NIGHTMARE_STATUS_DONE
			log_admin("Nightmare setup was cancelled as it took more than 30 seconds! Game might be inconsistent!")
		else
			var/ret = INVOKE_ASYNC(SSnightmare, TYPE_PROC_REF(/datum/controller/subsystem/nightmare, prepare_game))
			if(!ret)
				return // Wait for completion
			log_debug("Nightmare setup finished")

	if(current_state != GAME_STATE_PREGAME)
		return
	current_state = GAME_STATE_SETTING_UP
	INVOKE_ASYNC(src, PROC_REF(setup_start))

	REDIS_PUBLISH("byond.round", "type" = "round-start")

	for(var/client/C in GLOB.admins)
		remove_verb(C, roundstart_mod_verbs)
	admin_verbs_minor_event -= roundstart_mod_verbs

	return TRUE

/// Try to effectively setup gamemode and start now
/datum/controller/subsystem/ticker/proc/setup_start()
	PRIVATE_PROC(TRUE)
	Master.SetRunLevel(RUNLEVEL_SETUP)
	setup_failed = !setup()
	if(setup_failed)
		current_state = GAME_STATE_STARTUP
		time_left = null
		start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		return FALSE
	return TRUE

/datum/controller/subsystem/ticker/proc/handle_map_reboot()
	if(SSmapping?.next_map_configs && SSmapping?.next_map_configs?[GROUND_MAP])
		Reboot()
	addtimer(CALLBACK(
		SSvote,
		/datum/controller/subsystem/vote/proc/initiate_vote,
		"groundmap",
		"SERVER",
		CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/ticker, Reboot)),
		TRUE
	), 3 SECONDS)

/datum/controller/subsystem/ticker/proc/setup()
	to_chat(world, list(CLIENT_LANGUAGE_ENGLISH = SPAN_BOLDNOTICE(LANGUAGE_JOIN_ENG), CLIENT_LANGUAGE_RUSSIAN = SPAN_BOLDNOTICE(LANGUAGE_JOIN_RU)))
	var/init_start = world.timeofday

	CHECK_TICK
	if(!mode.can_start(bypass_checks))
		to_chat(world, list(CLIENT_LANGUAGE_ENGLISH = LANGUAGE_RLOBBY_ENG, CLIENT_LANGUAGE_RUSSIAN = LANGUAGE_RLOBBY_RU))
		SSticker.role_authority.reset_roles()
		return FALSE

	CHECK_TICK
	if(!mode.pre_setup() && !bypass_checks)
		to_chat(world, list(CLIENT_LANGUAGE_ENGLISH = "<b>[LANGUAGE_RLOBBYP_ENG] [GLOB.master_mode].</b> [LANGUAGE_RLOBBY_ENG]", CLIENT_LANGUAGE_RUSSIAN = "<b>[LANGUAGE_RLOBBYP_RU] [GLOB.master_mode].</b> [LANGUAGE_RLOBBY_RU]"))
		SSticker.role_authority.reset_roles()
		return FALSE

	CHECK_TICK
	mode.announce()
	if(mode.taskbar_icon)
		RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGIN, PROC_REF(handle_mode_icon))
		set_clients_taskbar_icon(mode.taskbar_icon)

	if(GLOB.perf_flags & PERF_TOGGLE_LAZYSS)
		apply_lazy_timings()


	if(CONFIG_GET(flag/autooocmute))
		ooc_allowed = FALSE

	round_start_time = world.time

	CHECK_TICK
	for(var/I in round_start_events)
		var/datum/callback/cb = I
		cb.InvokeAsync()
	LAZYCLEARLIST(round_start_events)
	CHECK_TICK

	//Configure mode and assign player to special mode stuff
	if(!(mode.flags_round_type & MODE_NO_SPAWN))
		SSticker.role_authority.setup_candidates_and_roles() //Distribute jobs
		if(mode.flags_round_type & MODE_NEW_SPAWN)
			create_characters() // Create and equip characters
		else
			old_create_characters() //Create player characters and transfer them
			equip_characters()

	GLOB.data_core.manifest()

	log_world("Начало игры заняло [(world.timeofday - init_start) / 10]s")
	round_start_time = world.time
	if(Check_DS())
		GLOB.xenomorph_attack_delay = 35 MINUTES + round_start_time

	current_state = GAME_STATE_PLAYING
	Master.SetRunLevel(RUNLEVEL_GAME)
	SSatoms.lateinit_roundstart_atoms()

	CHECK_TICK

	for(var/mob/new_player/np in GLOB.new_player_list)
		INVOKE_ASYNC(np, TYPE_PROC_REF(/mob/new_player, new_player_panel_proc), TRUE)

	setup_economy()

	shuttle_controller?.setup_shuttle_docks()

	PostSetup()
	return TRUE


/datum/controller/subsystem/ticker/proc/PostSetup()
	set waitfor = FALSE
	mode.initialize_emergency_calls()
	mode.post_setup()

	// Switch back to default automatically
	save_mode(CONFIG_GET(string/gamemode_default))
	SSstats_collector.initial_players_counter = length(GLOB.clients)
	if(mode.round_statistics)
		to_chat_spaced(world, html = list(CLIENT_LANGUAGE_ENGLISH = FONT_SIZE_BIG(SPAN_ROLE_BODY("<B>[LANGUAGE_WELC_ENG] [mode.round_statistics.round_name]</B>")), CLIENT_LANGUAGE_RUSSIAN = FONT_SIZE_BIG(SPAN_ROLE_BODY("<B>[LANGUAGE_WELC_RU] [mode.round_statistics.round_name]</B>"))))
		begin_game_recording()

	supply_controller.process() //Start the supply shuttle regenerating points -- TLE

	for(var/i in GLOB.closet_list) //Set up special equipment for lockers and vendors, depending on gamemode
		var/obj/structure/closet/C = i
		INVOKE_ASYNC(C, TYPE_PROC_REF(/obj/structure/closet, select_gamemode_equipment), mode.type)
	for(var/obj/structure/machinery/vending/V in machines)
		INVOKE_ASYNC(V, TYPE_PROC_REF(/obj/structure/machinery/vending, select_gamemode_equipment), mode.type)

	SSautobalancer.round_start()

//These callbacks will fire after roundstart key transfer
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/cb)
	if(!HasRoundStarted())
		LAZYADD(round_start_events, cb)
	else
		cb.InvokeAsync()


//These callbacks will fire before roundend report
/datum/controller/subsystem/ticker/proc/OnRoundend(datum/callback/cb)
	if(current_state >= GAME_STATE_FINISHED)
		cb.InvokeAsync()
	else
		LAZYADD(round_end_events, cb)

/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return current_state >= GAME_STATE_PLAYING


/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return current_state == GAME_STATE_PLAYING


/datum/controller/subsystem/ticker/Recover()
	current_state = SSticker.current_state
	force_ending = SSticker.force_ending
	mode = SSticker.mode

	login_music = SSticker.login_music

	delay_end = SSticker.delay_end
	delay_start = SSticker.delay_start

	totalPlayers = SSticker.totalPlayers
	totalPlayersReady = SSticker.totalPlayersReady

	time_left = SSticker.time_left

	queue_delay = SSticker.queue_delay
	queued_players = SSticker.queued_players

	switch(current_state)
		if(GAME_STATE_SETTING_UP)
			Master.SetRunLevel(RUNLEVEL_SETUP)
		if(GAME_STATE_PLAYING)
			Master.SetRunLevel(RUNLEVEL_GAME)
		if(GAME_STATE_FINISHED)
			Master.SetRunLevel(RUNLEVEL_POSTGAME)


/datum/controller/subsystem/ticker/proc/GetTimeLeft()
	if(isnull(SSticker.time_left))
		return round(max(0, start_at - world.time) / 10)
	return round(time_left / 10)


/datum/controller/subsystem/ticker/proc/SetTimeLeft(newtime)
	if(newtime >= 0 && isnull(time_left)) //remember, negative means delayed
		start_at = world.time + newtime
	else
		time_left = newtime


/datum/controller/subsystem/ticker/proc/load_mode()
	var/mode = trim(file2text("data/mode.txt"))
	if(mode)
		GLOB.master_mode = SSmapping?.configs?[GROUND_MAP].force_mode ? SSmapping.configs[GROUND_MAP].force_mode : mode
	else
		GLOB.master_mode = MODE_NAME_EXTENDED
	log_game("Saved mode is '[GLOB.master_mode]'")


/datum/controller/subsystem/ticker/proc/save_mode(the_mode)
	fdel("data/mode.txt")
	WRITE_FILE(file("data/mode.txt"), the_mode)


/datum/controller/subsystem/ticker/proc/Reboot(reason, delay)
	set waitfor = FALSE

	if(usr && !check_rights(R_SERVER))
		return

	if(graceful)
		to_chat_forced(world, list(CLIENT_LANGUAGE_ENGLISH = "<h3>[SPAN_BOLDNOTICE(LANGUAGE_SHUTDOWN_ENG)]</h3>", CLIENT_LANGUAGE_RUSSIAN = "<h3>[SPAN_BOLDNOTICE(LANGUAGE_SHUTDOWN_RU)]</h3>"))
		world.Reboot(GLOB.href_token, graceful)
		return

	if(!delay)
		delay = CONFIG_GET(number/round_end_countdown) * 10

	var/skip_delay = check_rights()
	if(delay_end && !skip_delay)
		to_chat(world, list(CLIENT_LANGUAGE_ENGLISH = SPAN_BOLDNOTICE(LANGUAGE_RESTARTD_ENG), CLIENT_LANGUAGE_RUSSIAN = SPAN_BOLDNOTICE(LANGUAGE_RESTARTD_RU)))
		return
	to_chat(world, list(CLIENT_LANGUAGE_ENGLISH = SPAN_BOLDNOTICE("[LANGUAGE_RESTARTIN_ENG] [DisplayTimeText(delay, language = CLIENT_LANGUAGE_ENGLISH)]. [reason]"), CLIENT_LANGUAGE_RUSSIAN = SPAN_BOLDNOTICE("[LANGUAGE_RESTARTIN_RU] [DisplayTimeText(delay, language = CLIENT_LANGUAGE_RUSSIAN)]. [reason]")))
	var/start_wait = world.time
	sleep(delay - (world.time - start_wait))

	if(delay_end && !skip_delay)
		to_chat(world, list(CLIENT_LANGUAGE_ENGLISH = SPAN_BOLDNOTICE(LANGUAGE_RESTARTC_ENG), CLIENT_LANGUAGE_RUSSIAN = SPAN_BOLDNOTICE(LANGUAGE_RESTARTC_RU)))
		return

	log_game("Перезагрузка мира. [reason]")
	to_chat_forced(world, list(CLIENT_LANGUAGE_ENGLISH = "<h3>[SPAN_BOLDNOTICE(LANGUAGE_RESTART_ENG)]</h3>", CLIENT_LANGUAGE_RUSSIAN = "<h3>[SPAN_BOLDNOTICE(LANGUAGE_RESTART_RU)]</h3>"))

	world.Reboot(GLOB.href_token, graceful)

/datum/controller/subsystem/ticker/proc/create_characters()
	if(!SSticker.role_authority)
		return

	for(var/mob/new_player/player in GLOB.player_list)
		if(!player || !player.ready || !player.mind || !player.job)
			continue

		INVOKE_ASYNC(src, PROC_REF(spawn_and_equip_char), player)

/datum/controller/subsystem/ticker/proc/spawn_and_equip_char(mob/new_player/player)
	var/datum/job/J = GET_MAPPED_ROLE(player.job)
	if(J.job_options && player?.client?.prefs?.pref_special_job_options[J.title])
		J.handle_job_options(player.client.prefs.pref_special_job_options[J.title])
	if(J.handle_spawn_and_equip)
		J.spawn_and_equip(player)
	else
		var/mob/M = J.spawn_in_player(player)
		if(istype(M))
			J.equip_job(M)
			EquipCustomItems(M)

			if(M.client)
				var/client/C = M.client
				if(C.player_data && C.player_data.playtime_loaded && length(C.player_data.playtimes) == 0)
					msg_admin_niche("NEW PLAYER: <b>[key_name(player, 1, 1, 0)]</b>. IP: [player.lastKnownIP], CID: [player.computer_id]")
	QDEL_IN(player, 5)

/datum/controller/subsystem/ticker/proc/old_create_characters()
	for(var/mob/new_player/player in GLOB.player_list)
		if(!(player && player.ready && player.mind))
			continue

		if(!player.job && !player.mind.roundstart_picked)
			continue

		player.create_character()
		qdel(player)

/datum/controller/subsystem/ticker/proc/equip_characters()
	var/captainless=1
	if(mode && istype(mode, /datum/game_mode/huntergames)) // || istype(mode,/datum/game_mode/whiskey_outpost)
		return

	for(var/mob/living/carbon/human/player in GLOB.human_mob_list)
		if(player.mind)
			if(player.job == JOB_CO)
				captainless = FALSE
			if(player.job)
				SSticker.role_authority.equip_role(player, GET_MAPPED_ROLE(player.job), late_join = FALSE)
				EquipCustomItems(player)
			if(player.client)
				var/client/C = player.client
				if(C.player_data && C.player_data.playtime_loaded && length(C.player_data.playtimes) == 0)
					msg_admin_niche("NEW PLAYER: <b>[key_name(player, 1, 1, 0)]</b>. IP: [player.lastKnownIP], CID: [player.computer_id]")
				if(C.player_data && C.player_data.playtime_loaded && ((round(C.get_total_human_playtime() DECISECONDS_TO_HOURS, 0.1)) <= 5))
					msg_sea(("NEW PLAYER: <b>[key_name(player, 0, 1, 0)]</b> only has [(round(C.get_total_human_playtime() DECISECONDS_TO_HOURS, 0.1))] hours as a human. Current role: [player.get_role_name()] - Current location: [get_area(player)]"), TRUE)
	if(captainless)
		for(var/mob/M in GLOB.player_list)
			if(!istype(M,/mob/new_player))
				to_chat(M, "Должность командира морской пехоты никому не выдана.")

/datum/controller/subsystem/ticker/proc/send_tip_of_the_round()
	var/message
	var/tip_file = pick("strings/xenotips.txt", "strings/marinetips.txt", "strings/metatips.txt", 15;"strings/memetips.txt")
	var/list/tip_list = file2list(tip_file)
	if(length(tip_file))
		message = pick(tip_list)
	else
		CRASH("send_tip_of_the_round() failed somewhere")

	if(message)
		to_chat(world, list(CLIENT_LANGUAGE_ENGLISH = "<span class='purple'><b>[LANGUAGE_TIPS_ENG]: </b>[html_encode(message)]</span>", CLIENT_LANGUAGE_RUSSIAN = "<span class='purple'><b>[LANGUAGE_TIPS_RU]: </b>[html_encode(message)]</span>"))
		return TRUE
	else
		return FALSE

/// Placeholder proc to apply slower SS timings for performance. Should be refactored to be included in Master/SS probably. Note we can't change prios after MC init.
/datum/controller/subsystem/ticker/proc/apply_lazy_timings()
	/* Notes:
	 * SSsound: lowering SSsound freq probably won't help because it's just a worker for the sound queue, same amount of work gets queued anyway
	 * SSmob/SShuman/SSxeno: you don't want to touch these, because several systems down the line rely on the timing (2 SECONDS) for gameplay logic
	 * SSchat/SSinput: these are perf intensive but need to be SS_TICKER, changing wait would be troublesome and/or inconsequential for perf
	 * SScellauto: can't touch this because it would directly affect explosion spread speed
	 */

	SSquadtree?.wait	= 0.8 SECONDS // From 0.5, relevant based on player movement speed (higher = more error in sound location, motion detector pings, sentries target acquisition)
	SSlighting?.wait	= 0.6 SECONDS // From 0.4, same but also heavily scales on player/scene density (higher = less frequent lighting updates which is very noticeable as you move)
	SSstatpanels?.wait	= 1.5 SECONDS // From 0.6, refresh rate mainly matters for ALT+CLICK turf contents (which gens icons, intensive)
	SSsoundscape?.wait	= 2 SECONDS // From 1, soudscape triggering checks, scales on player count
	SStgui?.wait		= 1.2 SECONDS // From 0.9, UI refresh rate

	log_debug("Switching to lazy Subsystem timings for performance")

/datum/controller/subsystem/ticker/proc/set_clients_taskbar_icon(taskbar_icon)
	for(var/client/C as anything in GLOB.clients)
		winset(C, null, "mainwindow.icon=[taskbar_icon]")

/datum/controller/subsystem/ticker/proc/handle_mode_icon(dcs, client/C)
	SIGNAL_HANDLER

	winset(C, null, "mainwindow.icon=[SSticker.mode.taskbar_icon]")


/datum/controller/subsystem/ticker/proc/hijack_ocurred()
	if(mode)
		mode.is_in_endgame = TRUE
		mode.force_end_at = (world.time + 25 MINUTES)
