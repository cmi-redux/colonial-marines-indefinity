
var/world_view_size = 7
var/lobby_view_size = 16

var/internal_tick_usage = 0

var/list/reboot_sfx = file2list("config/reboot_sfx.txt")
/world
	mob = /mob/new_player
	turf = /turf/open/space/basic
	area = /area/space
	view = "15x15"
	cache_lifespan = 0 //stops player uploaded stuff from being kept in the rsc past the current session
	hub = "Exadv1.spacestation13"

/world/New()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if(debug_server)
		LIBCALL(debug_server, "auxtools_init")()
		enable_debugging()
	internal_tick_usage = 0.2 * world.tick_lag
	hub_password = "kMZy3U5jJHSiBQjr"

#ifdef BYOND_TRACY
	#warn BYOND_TRACY is enabled
	prof_init()
#endif

	GLOB.config_error_log = GLOB.world_attack_log = GLOB.world_href_log = GLOB.world_attack_log = "data/logs/config_error.[GUID()].log"

	config.Load(params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])

	SSdatabase.start_up()

	SSentity_manager.start_up()
	SSentity_manager.setup_round_id()

	var/latest_changelog = file("[global.config.directory]/../html/changelogs/archive/" + time2text(world.timeofday, "YYYY-MM") + ".yml")
	GLOB.changelog_hash = fexists(latest_changelog) ? md5(latest_changelog) : 0 //for telling if the changelog has changed recently

	initialize_tgs()
	initialize_marine_armor()

	#ifdef UNIT_TESTS
	GLOB.test_log = "data/logs/tests.log"
	#endif

	load_admins()
	jobban_loadbanfile()
	LoadBans()
	load_motd()
	load_tm_message()
	load_mode()
	loadShuttleInfoDatums()
	populate_gear_list()
	initialize_global_regex()

	//Emergency Fix
	//end-emergency fix

	init_global_referenced_datums()

	var/testing_locally = (world.params && world.params["local_test"])
	var/running_tests = (world.params && world.params["run_tests"])
	#ifdef UNIT_TESTS
	running_tests = TRUE
	#endif
	// Only do offline sleeping when the server isn't running unit tests or hosting a local dev test
	sleep_offline = (!running_tests && !testing_locally)

	initiate_minimap_icons()

	change_tick_lag(CONFIG_GET(number/ticklag))
	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000

	Master.Initialize(10, FALSE, TRUE)

	#ifdef UNIT_TESTS
	HandleTestRun()
	#endif

	update_status()

	//Scramble the coords obsfucator
	obfs_x = rand(-2000, 2000) //A number between -2000 and 2000
	obfs_y = rand(-2000, 2000) //A number between -2000 and 2000

	spawn(3000) //so we aren't adding to the round-start lag
		if(CONFIG_GET(flag/ToRban))
			ToRban_autoupdate()

	// If the server's configured for local testing, get everything set up ASAP.
	// Shamelessly stolen from the test manager's host_tests() proc
	if(testing_locally)
		GLOB.master_mode = "extended"

		// Wait for the game ticker to initialize
		while(!SSticker.initialized)
			sleep(10)

		// Start the game ASAP
		SSticker.request_start()
	return

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/proc/start_logging()
	GLOB.round_id = SSentity_manager.round.id

	GLOB.log_directory = "data/logs/[time2text(world.realtime, "YYYY/MM-Month/DD-Day")]/round-"

	if(GLOB.round_id)
		GLOB.log_directory += GLOB.round_id
	else
		GLOB.log_directory += "[replacetext(time_stamp(), ":", ".")]"

	runtime_logging_ready = TRUE // Setting up logging now, so disabling early logging
	#ifndef UNIT_TESTS
	world.log = file("[GLOB.log_directory]/dd.log")
	#endif
	backfill_runtime_log()

	GLOB.logger.init_logging()

	GLOB.tgui_log = "[GLOB.log_directory]/tgui.log"
	GLOB.world_href_log = "[GLOB.log_directory]/hrefs.log"
	GLOB.world_game_log = "[GLOB.log_directory]/game.log"
	GLOB.world_attack_log = "[GLOB.log_directory]/attack.log"
	GLOB.world_runtime_log = "[GLOB.log_directory]/runtime.log"
	GLOB.round_stats = "[GLOB.log_directory]/round_stats.log"
	GLOB.scheduler_stats = "[GLOB.log_directory]/round_scheduler_stats.log"
	GLOB.mutator_logs = "[GLOB.log_directory]/mutator_logs.log"

	start_log(GLOB.tgui_log)
	start_log(GLOB.world_href_log)
	start_log(GLOB.world_game_log)
	start_log(GLOB.world_attack_log)
	start_log(GLOB.world_runtime_log)
	start_log(GLOB.round_stats)
	start_log(GLOB.scheduler_stats)
	start_log(GLOB.mutator_logs)

	if(fexists(GLOB.config_error_log))
		fcopy(GLOB.config_error_log, "[GLOB.log_directory]/config_error.log")
		fdel(GLOB.config_error_log)

	if(GLOB.round_id)
		log_game("Round ID: [GLOB.round_id]")

	log_runtime(GLOB.revdata.get_log_message())

/world/proc/initialize_tgs()
	TgsNew(new /datum/tgs_event_handler/impl, TGS_SECURITY_TRUSTED)
	GLOB.revdata.load_tgs_info()

/world/Topic(T, addr, master, key)
	TGS_TOPIC

	if (T == "ping")
		var/x = 1
		for(var/client/C)
			x++
		return x

	else if(T == "players")
		return length(GLOB.clients)

	else if(T == "status")
		var/list/s = list()
		s["mode"] = GLOB.master_mode
		if(SSmapping && SSmapping?.configs?[GROUND_MAP])
			s["map"] = SSmapping.configs[GROUND_MAP].map_name
		s["stationtime"] = duration2text()
		s["players"] = GLOB.clients.len

		return list2params(s)

	// Used in external requests for player data.
	else if(T == "pinfo")
		var/retdata = ""
		if(addr != "127.0.0.1")
			return "Nah ah ah, you didn't say the magic word"
		for(var/client/C in GLOB.clients)
			retdata  += C.key+","+C.address+","+C.computer_id+"|"

		return retdata

	else if(copytext(T,1,6) == "notes")
		if(addr != "127.0.0.1")
			return "Nah ah ah, you didn't say the magic word"
		if(!SSdatabase.connection.connection_ready())
			return "Database is not yet ready. Please wait."
		var/input[] = params2list(T)
		var/ckey = trim(input["ckey"])
		var/dat = "Notes for [ckey]:<br/><br/>"
		var/datum/entity/player/P = get_player_from_key(ckey)
		if(!P)
			return ""
		P.load_refs()
		if(!P.notes || !P.notes.len)
			return dat + "No information found on the given key."

		for(var/datum/entity/player_note/N in P.notes)
			var/admin_name = (N.admin && N.admin.ckey) ? "[N.admin.ckey]" : "-LOADING-"
			var/ban_text = N.ban_time ? "Banned for [N.ban_time] minutes | " : ""
			var/confidential_text = N.is_confidential ? " \[CONFIDENTIALLY\]" : ""
			dat += "[ban_text][N.text]<br/>by [admin_name] ([N.admin_rank])[confidential_text] on [N.date]<br/><br/>"
		return dat

/world/Reboot(shutdown = FALSE, reason)
	if(!notify_restart())
		log_debug("Failed to notify discord about restart")

	Master.Shutdown()
	send_reboot_sound()
	var/server = CONFIG_GET(string/server)
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/client/C = thing
		C?.tgui_panel?.send_roundrestart()
		if(server) //if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[server]")

	#ifdef UNIT_TESTS
	FinishTestRun()
	return
	#endif

	if(shutdown)
		shutdown()
	else
		..(reason)

//	if(TgsAvailable())
//		send_tgs_restart()
//		TgsReboot()
//		TgsEndProcess()
//	else
//		shutdown()

/world/proc/send_tgs_restart()
	if(CONFIG_GET(string/new_round_alert_channel) && CONFIG_GET(string/new_round_alert_role_id))
		if(SSticker.mode.round_statistics)
			send2chat("[SSticker.mode.round_statistics.round_name][GLOB.round_id ? " (Round [GLOB.round_id])" : ""] completed!", CONFIG_GET(string/new_round_alert_channel))
		if(SSmapping.next_map_configs)
			var/datum/map_config/next_map = SSmapping.next_map_configs[GROUND_MAP]
			if(next_map)
				send2chat("<@&[CONFIG_GET(string/new_round_alert_role_id)]> Restarting! Next map is [next_map.map_name]", CONFIG_GET(string/new_round_alert_channel))
		else
			send2chat("<@&[CONFIG_GET(string/new_round_alert_role_id)]> Restarting!", CONFIG_GET(string/new_round_alert_channel))
	return

/world/proc/send_reboot_sound()
	var/reboot_sound = SAFEPICK(reboot_sfx)
	if(reboot_sound)
		var/sound/reboot_sound_ref = sound(reboot_sound)
		for(var/client/client as anything in GLOB.clients)
			if(client?.prefs.toggles_sound & SOUND_REBOOT)
				SEND_SOUND(client, reboot_sound_ref)

/world/proc/notify_restart()
	if(world.port != 1400)
		return FALSE
	var/datum/discord_embed/embed = new()
	embed.title = "**Раунд [SSticker.mode.round_statistics.round_name], № [SSperf_logging?.round?.id] ЗАВЕРШЕН**"
	var/next_map_info = ""
	if(SSmapping?.next_map_configs && SSmapping?.next_map_configs?[GROUND_MAP])
		next_map_info = ", **Следующая Карта:** __[SSmapping.next_map_configs[GROUND_MAP]?.map_name]__"
	var/last_round = ""
	if(SSticker.graceful)
		last_round = "\n__**Это последний раунд!**__\nВсем спасибо за участие на старте, cледующий старт по расписанию."
	embed.description = "[SSticker.mode.end_round_message()]\n**Онлайн:** **(AVG)** ``[round(SSstats_collector.get_avg_players(), 0.01)]``, *на момент перезапуска ``[length(GLOB.clients)]``*\n\
	**Карта:** __[SSmapping.configs[GROUND_MAP]?.map_name]__[next_map_info]\n**Длительность раунда:** *[duration2text()]*[last_round]"
	embed.color = COLOR_WEBHOOK_DEFAULT
	embed.content = "[CONFIG_GET(string/new_round_mention_webhook_url)]"
	send2new_round_webhook(embed)
	return TRUE

/proc/send2new_round_webhook(message_or_embed)
	var/webhook = CONFIG_GET(string/new_round_webhook_url)
	if(!webhook)
		return

	var/list/webhook_info = list()
	if(istext(message_or_embed))
		var/message_content = replacetext(replacetext(message_or_embed, "\proper", ""), "\improper", "")
		message_content = GLOB.has_discord_embeddable_links.Replace(replacetext(message_content, "`", ""), " ```$1``` ")
		webhook_info["content"] = message_content
	else
		var/datum/discord_embed/embed = message_or_embed
		webhook_info["embeds"] = list(embed.convert_to_list())
		if(embed.content)
			webhook_info["content"] = embed.content
	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(webhook_info), headers, "tmp/response.json")
	request.begin_async()

/world/proc/notify_manager(restarting = FALSE)
	. = FALSE
	var/manager = CONFIG_GET(string/manager_url)
	if(!manager)
		return TRUE

	var/list/payload = list()
	payload["round_time"] = world.time
	payload["drift"] = Master.tickdrift
	if(restarting)
		payload["restarting"] = TRUE
		if(SSticker?.mode)
			payload["round_result"] = SSticker.mode.end_round_message()
	if(SSticker?.mode?.round_statistics)
		payload["mission_name"] = SSticker.mode.round_statistics.round_name
	if(SSmapping.next_map_configs)
		var/datum/map_config/next_map = SSmapping.next_map_configs[GROUND_MAP]
		if(next_map)
			payload["next_map"] = next_map.map_name
	payload["avg_players"] = SSstats_collector.get_avg_players()

	var/payload_ser = url_encode(json_encode(payload))
	world.Export("[manager]/?payload=[payload_ser]")
	return TRUE

/world/proc/load_mode()
	GLOB.master_mode = trim(file2text("data/mode.txt"))
	log_misc("Saved mode is '[GLOB.master_mode]'")

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	join_motd = list(CLIENT_LANGUAGE_RUSSIAN = file2text("config/motd_ru.txt"), CLIENT_LANGUAGE_ENGLISH = file2text("config/motd_en.txt"))

/world/proc/load_tm_message()
	var/datum/getrev/revdata = GLOB.revdata
	if(revdata.testmerge.len)
		current_tms = revdata.GetTestMergeInfo()

/world/proc/update_status()
	//Note: Hub content is limited to 254 characters, including limited HTML/CSS.
	var/s = ""
	if(CONFIG_GET(string/servername))
		s += "<a href=\"[CONFIG_GET(string/forumurl)]\"><b>[CONFIG_GET(string/servername)]</b></a>"
	if(SSmapping?.configs)
		var/datum/map_config/MG = SSmapping.configs[GROUND_MAP]
		s += "<br>Map: [MG?.map_name ? "<b>[MG.map_name]</b>" : ""]"
	if(SSticker?.mode)
		s += "<br>Mode: <b>[SSticker.mode.name]</b>"
		s += "<br>Round time: <b>[duration2text()]</b>"
	world.status = s

#define FAILED_DB_CONNECTION_CUTOFF 1
var/failed_db_connections = 0
var/failed_old_db_connections = 0

// /hook/startup/proc/connectDB()
// if(!setup_database_connection())
// world.log << "Your server failed to establish a connection with the feedback database."
// else
// world.log << "Feedback database connection established."
// return 1

var/datum/BSQL_Connection/connection
/proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF) //If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0


	return .

/proc/set_global_view(view_size)
	world_view_size = view_size
	for(var/client/c in GLOB.clients)
		c.view = world_view_size

#undef FAILED_DB_CONNECTION_CUTOFF

/proc/give_image_to_client(obj/O, icon_text)
	var/image/I = image(null, O)
	I.maptext = icon_text
	for(var/client/c in GLOB.clients)
		if(!ishuman(c.mob))
			continue
		c.images += I

/world/proc/change_fps(new_value = 20)
	if(new_value <= 0)
		CRASH("change_fps() called with [new_value] new_value.")
	if(fps == new_value)
		return //No change required.

	fps = new_value
	on_tickrate_change()

/world/proc/change_tick_lag(new_value = 0.5)
	if(new_value <= 0)
		CRASH("change_tick_lag() called with [new_value] new_value.")
	if(tick_lag == new_value)
		return //No change required.

	tick_lag = new_value
	on_tickrate_change()

/world/proc/on_tickrate_change()
	SStimer.reset_buckets()

/world/proc/incrementMaxZ()
	maxz++
	//SSmobs.MaxZChanged()

/** For initializing and starting byond-tracy when BYOND_TRACY is defined
 * byond-tracy is a useful profiling tool that allows the user to view the CPU usage and execution time of procs as they run.
*/
/world/proc/prof_init()
	var/lib

	switch(world.system_type)
		if(MS_WINDOWS)
			lib = "prof.dll"
		if(UNIX)
			lib = "libprof.so"
		else
			CRASH("unsupported platform")

	var/init = LIBCALL(lib, "init")()
	if("0" != init)
		CRASH("[lib] init error: [init]")

/world/proc/HandleTestRun()
	//trigger things to run the whole process
	Master.sleep_offline_after_initializations = FALSE
	SSticker.request_start()
	CONFIG_SET(number/round_end_countdown, 0)
	var/datum/callback/cb
#ifdef UNIT_TESTS
	cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(RunUnitTests))
#else
	cb = VARSET_CALLBACK(SSticker, force_ending, TRUE)
#endif
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_addtimer), cb, 10 SECONDS))

/world/proc/FinishTestRun()
	set waitfor = FALSE
	var/list/fail_reasons
	if(!GLOB)
		fail_reasons = list("Missing GLOB!")
	else if(total_runtimes)
		fail_reasons = list("Total runtimes: [total_runtimes]")
#ifdef UNIT_TESTS
	if(GLOB.failed_any_test)
		LAZYADD(fail_reasons, "Unit Tests failed!")
#endif
	if(!fail_reasons)
		text2file("Success!", "data/logs/ci/clean_run.lk")
	else
		log_world("Test run failed!\n[fail_reasons.Join("\n")]")
	sleep(0) //yes, 0, this'll let Reboot finish and prevent byond memes
	qdel(src) //shut it down


/proc/backfill_runtime_log()
	if(length(full_init_runtimes))
		world.log << "========= EARLY RUNTIME ERRORS ========"
		for(var/line in full_init_runtimes)
			world.log << line
		world.log << "======================================="
		world.log << ""
