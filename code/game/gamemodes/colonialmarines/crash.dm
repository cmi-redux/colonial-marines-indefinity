/proc/Check_Crash()
	if(SSticker.mode == MODE_NAME_CRASH || GLOB.master_mode == MODE_NAME_CRASH)
		return TRUE
	return FALSE

/datum/game_mode/crash
	name = MODE_NAME_CRASH
	config_tag = MODE_NAME_CRASH
	required_players = 1 //Need at least one player, but really we need 2.
	xeno_required_num = 1 //Need at least one xeno.
	flags_round_type = MODE_NEW_SPAWN|MODE_NO_SHIP_MAP
	var/round_status_flags
	round_end_states = list(MODE_CRASH_X_MAJOR, MODE_CRASH_M_MAJOR, MODE_CRASH_X_MINOR, MODE_CRASH_M_MINOR, MODE_GENERIC_DRAW_NUKE)

	faction_result_end_state = list(
		FACTION_MARINE = list(
			MODE_CRASH_M_MAJOR = list("marine_major", list('sound/music/round_end/winning_triumph1.ogg', 'sound/music/round_end/winning_triumph2.ogg'), list()),
			MODE_CRASH_M_MINOR = list("marine_major", list('sound/music/round_end/neutral_hopeful1.ogg', 'sound/music/round_end/neutral_hopeful2.ogg'), list()),
			MODE_CRASH_X_MINOR = list("marine_minor", list('sound/music/round_end/neutral_melancholy1.ogg', 'sound/music/round_end/neutral_melancholy2.ogg'), list()),
			MODE_CRASH_X_MAJOR = list("marine_minor", list('sound/music/round_end/sad_loss1.ogg', 'sound/music/round_end/sad_loss2.ogg'), list()),
			MODE_GENERIC_DRAW_NUKE =  list("draw", list('sound/music/round_end/nuclear_detonation1.ogg', 'sound/music/round_end/nuclear_detonation2.ogg'), list()),
		),
		FACTION_XENOMORPH_NORMAL = list(
			MODE_CRASH_X_MAJOR = list("xeno_major", list('sound/music/round_end/winning_triumph1.ogg', 'sound/music/round_end/winning_triumph2.ogg'), list()),
			MODE_CRASH_X_MINOR = list("xeno_major", list('sound/music/round_end/neutral_hopeful1.ogg', 'sound/music/round_end/neutral_hopeful2.ogg'), list()),
			MODE_CRASH_M_MINOR = list("xeno_minor", list('sound/music/round_end/neutral_melancholy1.ogg', 'sound/music/round_end/neutral_melancholy2.ogg'), list()),
			MODE_CRASH_M_MAJOR = list("xeno_minor", list('sound/music/round_end/sad_loss1.ogg', 'sound/music/round_end/sad_loss2.ogg'), list()),
			MODE_GENERIC_DRAW_NUKE =  list("draw", list('sound/music/round_end/nuclear_detonation1.ogg', 'sound/music/round_end/nuclear_detonation2.ogg'), list()),
		)
	)

	population_min = 0
	population_max = 30

	// Round end conditions
	var/shuttle_landed = FALSE
	var/marines_evac = CRASH_EVAC_NONE

	// Shuttle details
	var/shuttle_id = DROPSHIP_HEART_OF_GOLD
	var/obj/docking_port/mobile/crashmode/shuttle

	var/bioscan_interval = INFINITY

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Pre-pre-startup */
/datum/game_mode/crash/can_start()
	initialize_special_clamps()

	var/datum/map_template/shuttle/ST = SSmapping.shuttle_templates[shuttle_id]
	shuttle = SSshuttle.load_template_to_transit(ST)

	return TRUE

/obj/effect/landmark/crash/nuclear_spawn
	name = "nuclear spawn"

/obj/effect/landmark/crash/nuclear_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.nuke_spawn_locs += src

/obj/effect/landmark/crash/nuclear_spawn/Destroy()
	GLOB.nuke_spawn_locs -= src
	return ..()

/obj/effect/landmark/crash/resin_silo_spawn
	name = "resin silo spawn"

/obj/effect/landmark/crash/resin_silo_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.resin_silo_spawn_locs += src

/obj/effect/landmark/crash/resin_silo_spawn/Destroy()
	GLOB.resin_silo_spawn_locs -= src
	return ..()


////////////////////////////////////////////////////////////////////////////////////////


/datum/game_mode/crash/pre_setup()
	if(SSticker.role_authority)
		for(var/datum/squad/squad in SSticker.role_authority.squads)
			if(squad.faction == GLOB.faction_datum[FACTION_MARINE] && squad.name != "Root")
				squad.roundstart = FALSE
				squad.usable = FALSE

	var/obj/effect/landmark/crash/nuclear_spawn/NS = SAFEPICK(GLOB.nuke_spawn_locs)
	if(NS)
		GLOB.nuke_list += new /obj/structure/machinery/nuclearbomb/crash(NS.loc)
	qdel(NS)
	var/obj/effect/landmark/crash/resin_silo_spawn/RSS = SAFEPICK(GLOB.resin_silo_spawn_locs)
	if(RSS)
		var/obj/effect/alien/resin/special/pylon/core/core = new(RSS.loc, null, GLOB.faction_datum[FACTION_XENOMORPH_NORMAL])
		core.crash_mode = TRUE
		GLOB.xeno_resin_silos += core
	new /obj/structure/alien/weeds(RSS.loc, null, null, GLOB.faction_datum[FACTION_XENOMORPH_NORMAL])
	qdel(RSS)

	for(var/i in GLOB.shuttle_controls)
		var/obj/structure/machinery/computer/shuttle_control/computer_to_disable = i
		if(istype(computer_to_disable, /obj/structure/machinery/computer/shuttle/shuttle_control/uss_heart_of_gold))
			continue
		computer_to_disable.stat |= BROKEN
		computer_to_disable.update_icon()

	QDEL_LIST(GLOB.hunter_primaries)
	QDEL_LIST(GLOB.hunter_secondaries)
	QDEL_LIST(GLOB.crap_items)
	QDEL_LIST(GLOB.good_items)

	//desert river test
	if(!length(round_toxic_river))
		round_toxic_river = null //No tiles?
	else
		round_time_river = rand(-100,100)
		flags_round_type |= MODE_FOG_ACTIVATED

	// Shuttle crash point creating
	var/obj/docking_port/stationary/crashmode/temp_crashable_port
	for(var/i = 1 to 10)
		var/list/all_ground_levels = SSmapping.levels_by_trait(ZTRAIT_GROUND)
		var/ground_z_level = all_ground_levels[1]

		var/list/area/potential_areas = SSmapping.areas_in_z["[ground_z_level]"]

		var/area/area_picked = pick(potential_areas)

		var/list/potential_turfs = list()

		for(var/turf/turf_in_area in area_picked)
			potential_turfs += turf_in_area

		if(!length(potential_turfs))
			continue

		var/turf/turf_picked = pick(potential_turfs)

		temp_crashable_port = new(turf_picked)
		temp_crashable_port.width = shuttle.width
		temp_crashable_port.height = shuttle.height

		if(!shuttle.check_crash_point(temp_crashable_port))
			qdel(temp_crashable_port)
			continue
		break

	shuttle.crashing = TRUE
	SSshuttle.moveShuttleToDock(shuttle, temp_crashable_port, TRUE) // FALSE = instant arrival
	addtimer(CALLBACK(src, PROC_REF(crash_shuttle), temp_crashable_port), 10 MINUTES)

	..()

	var/obj/structure/tunnel/T
	var/i = 0
	var/turf/t
	while(length(GLOB.xeno_tunnels) && i++ < 3)
		t = get_turf(pick_n_take(GLOB.xeno_tunnels))
		T = new(t)
		T.id = "hole[i]"
	return TRUE

/datum/game_mode/crash/post_setup()
	set waitfor = FALSE
	update_controllers()
	initialize_post_marine_gear_list()

	if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_BASIC_RT])
		flags_round_type |= MODE_BASIC_RT

	round_time_lobby = world.time

	return ..()

/datum/game_mode/crash/proc/update_controllers()
	if(SSitem_cleanup)
		SSitem_cleanup.start_processing_time = 0
		SSitem_cleanup.percentage_of_garbage_to_delete = 1.0
		SSitem_cleanup.wait = 1 MINUTES
		SSitem_cleanup.next_fire = 1 MINUTES
		spawn(0)
			SSitem_cleanup.delete_almayer()

/datum/game_mode/crash/announce()
	to_chat(world, "<span class='round_header'>Ship crashed over - [SSmapping.configs[GROUND_MAP].map_name]! You know all about enemy, time to final battle!</span>")
	faction_announcement("Scheduled for landing in T-10 Minutes. Prepare for landing. Known hostiles near LZ. Detonation Protocol Active, planet disposable. Marines disposable.")
	playsound(shuttle, 'sound/machines/warning-buzzer.ogg', 75, 0, 30)

#define XENO_FOG_DELAY_INTERVAL		(60 MINUTES)
#define FOG_DELAY_INTERVAL		(15 MINUTES)
#define PODLOCKS_OPEN_WAIT		(15 MINUTES) // CORSAT pod doors drop at 12:45

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/crash/process()
	. = ..()
	if(round_started > 0)
		round_started--
		return FALSE

	if(!round_finished)
		for(var/faction_to_get in FACTION_LIST_ALL)
			var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
			if(!faction.xeno_queen_timer)
				continue

			if(!faction.living_xeno_queen && faction.xeno_queen_timer < world.time)
				xeno_message("Улей готов для эволюции новой королевы.", 3, faction)

			if(!evolution_ovipositor_threshold && world.time >= SSticker.round_start_time + round_time_evolution_ovipositor)
				faction.evolution_without_ovipositor = FALSE
				if(faction.living_xeno_queen && !faction.living_xeno_queen.ovipositor)
					to_chat(faction.living_xeno_queen, SPAN_XENODANGER("Время сесть на яйцеклад и дать эволюцию детям."))
				evolution_ovipositor_threshold = TRUE
				msg_admin_niche("[faction] требуется Королева на яйцекладе.")

		// Automated bioscan / Queen Mother message
		if(world.time > bioscan_current_interval) //If world time is greater than required bioscan time.
			announce_bioscans() //Announce the results of the bioscan to both sides.
			bioscan_current_interval += bioscan_ongoing_interval //Add to the interval based on our set interval time.


		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks..
			if(!(round_status_flags & ROUNDSTATUS_PODDOORS_OPEN))
				if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_LOCKDOWN])
					if(world.time >= (PODLOCKS_OPEN_WAIT + round_time_lobby))
						round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN
						var/input = "Защитная блокировка будет снята через 30 секунд согласно автоматическому протоколу."
						var/name = "Automated Security Authority Announcement"
						faction_announcement(input, name, 'sound/AI/commandreport.ogg')
						for(var/i in GLOB.living_xeno_list)
							var/mob/M = i
							sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
							to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
							to_chat(M, SPAN_XENOANNOUNCE("Для моих детей и их Королевы. Я чувствую что большие двери ловушки откроются через 30 секунд."))
						addtimer(CALLBACK(src, PROC_REF(open_podlocks), "map_lockdown"), 300)

			if(round_should_check_for_win)
				check_win()
			round_checkwin = 0

		if(!GLOB.resin_lz_allowed && world.time >= SSticker.round_start_time + round_time_resin)
			set_lz_resin_allowed(TRUE)

#undef XENO_FOG_DELAY_INTERVAL
#undef FOG_DELAY_INTERVAL
#undef PODLOCKS_OPEN_WAIT

/datum/game_mode/crash/proc/crash_shuttle(obj/docking_port/stationary/target)
	sleep(1200)
	shuttle_landed = TRUE
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_blurb_uscm)), DROPSHIP_DROP_MSG_DELAY)
	// We delay this a little because the shuttle takes some time to land, and we want to the xenos to know the position of the marines.
	bioscan_interval = world.time + 30 SECONDS

///////////////////////////
//Checks to see who won///
//////////////////////////
/datum/game_mode/crash/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return

	if(!shuttle_landed && !force_end_at)
		return

	var/living_player_list[] = count_humans_and_xenos(SSevacuation.get_affected_zlevels())
	var/num_humans = living_player_list[1]
	var/num_xenos = living_player_list[2]

	if(force_end_at && world.time > force_end_at)
		round_finished = MODE_CRASH_X_MINOR
	if((planet_nuked == NUKE_NONE && marines_evac == CRASH_EVAC_NONE) && (!num_humans && !length(GLOB.xeno_resin_silos) && !num_xenos))
		round_finished = MODE_GENERIC_DRAW_NUKE
	if(planet_nuked == NUKE_NONE && length(GLOB.xeno_resin_silos) && (marines_evac == CRASH_EVAC_NONE && !num_humans) && !length(GLOB.active_nuke_list))
		round_finished = MODE_CRASH_X_MAJOR
	if(planet_nuked == NUKE_NONE && !length(GLOB.active_nuke_list) && !num_humans && (marines_evac != CRASH_EVAC_NONE || !length(GLOB.xeno_resin_silos)))
		round_finished = MODE_CRASH_X_MINOR
	if((planet_nuked == NUKE_COMPLETED && marines_evac == CRASH_EVAC_NONE) || (planet_nuked == NUKE_NONE && !length(GLOB.xeno_resin_silos) && !num_xenos && marines_evac != CRASH_EVAC_NONE))
		round_finished = MODE_CRASH_M_MINOR
	if((planet_nuked == NUKE_COMPLETED && marines_evac != CRASH_EVAC_NONE) || (planet_nuked == NUKE_NONE && !length(GLOB.xeno_resin_silos) && !num_xenos))
		round_finished = MODE_CRASH_M_MAJOR

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/crash/check_finished()
	if(round_finished)
		return TRUE

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/crash/declare_completion()
	. = ..()

	declare_completion_announce_fallen_soldiers()
	declare_completion_announce_xenomorphs()
	declare_completion_announce_medal_awards()
	declare_fun_facts()

/datum/game_mode/crash/on_nuclear_diffuse(obj/structure/machinery/nuclearbomb/bomb, mob/living/carbon/xenomorph/xenomorph)
	. = ..()
	var/living_player_list[] = count_humans_and_xenos(SSevacuation.get_affected_zlevels())
	var/num_humans = living_player_list[1]
	if(!num_humans)
		addtimer(VARSET_CALLBACK(src, marines_evac, CRASH_EVAC_COMPLETED), 10 SECONDS)
		faction_announcement("WARNING. WARNING. Planetary Nuke Deactivated. WARNING. WARNING. Mission Failed. WARNING. WARNING.", "Priority Alert", "Everyone (-Yautja)")
