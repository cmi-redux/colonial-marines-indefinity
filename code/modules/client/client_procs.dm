	////////////
	//SECURITY//
	////////////
#define TOPIC_SPAM_DELAY 2 //2 ticks is about 2/10ths of a second; it was 4 ticks, but that caused too many clicks to be lost due to lag
#define UPLOAD_LIMIT 10485760 //Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?
#define MIN_CLIENT_VERSION 0 //Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.
#define GOOD_BYOND_MAJOR 513
#define GOOD_BYOND_MINOR 1500

GLOBAL_LIST_INIT(blacklisted_builds, list(
	"1407" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1408" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1428" = "bug causing right-click menus to show too many verbs that's been fixed in version 1429",
	"1548" = "bug breaking the \"alpha\" functionality in the game, allowing clients to be able to see things/mobs they should not be able to see.",
	))

#define LIMITER_SIZE 5
#define CURRENT_SECOND 1
#define SECOND_COUNT 2
#define CURRENT_MINUTE 3
#define MINUTE_COUNT 4
#define ADMINSWARNED_AT 5
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/

// This can be replaced with a more sophisticated solution later
GLOBAL_LIST_INIT(whitelisted_client_procs, list(
	/client/proc/toggle_ignore_self,
	/client/proc/toggle_help_intent_safety,
	/client/proc/toggle_middle_mouse_click,
	/client/proc/toggle_directional_assist,
	/client/proc/toggle_auto_eject,
	/client/proc/toggle_auto_eject_to_hand,
	/client/proc/toggle_eject_to_hand,
	/client/proc/toggle_automatic_punctuation,
	/client/proc/toggle_clickdrag_override,
	/client/proc/toggle_dualwield,
	/client/proc/toggle_gun_ammo_counter,
	/client/proc/toggle_middle_mouse_swap_hands,
	/client/proc/toggle_vend_item_to_hand,
	/client/proc/switch_item_animations,
	/client/proc/toggle_admin_sound_types,
	/client/proc/receive_random_tip,
	/client/proc/set_eye_blur_type,
))

/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob) //stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	// asset_cache
	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"])
		if(!asset_cache_job)
			return

	// Rate limiting
	var/mtl = CONFIG_GET(number/minute_topic_limit)
	if(!admin_holder && mtl)
		var/minute = round(world.time, 600)
		if(!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if(minute != topiclimiter[CURRENT_MINUTE])
			topiclimiter[CURRENT_MINUTE] = minute
			topiclimiter[MINUTE_COUNT] = 0
		topiclimiter[MINUTE_COUNT] += 1
		if(topiclimiter[MINUTE_COUNT] > mtl)
			var/msg = "Your previous action was ignored because you've done too many in a minute."
			if(minute != topiclimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				topiclimiter[ADMINSWARNED_AT] = minute
				msg += " Administrators have been informed."
				log_game("[key_name(src)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
				message_admins("[key_name(usr)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
			to_chat(src, SPAN_DANGER("[msg]"))
			return

	var/stl = CONFIG_GET(number/second_topic_limit)
	if (!admin_holder && stl && href_list["window_id"] != "statbrowser")
		var/second = round(world.time, 10)
		if(!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if(second != topiclimiter[CURRENT_SECOND])
			topiclimiter[CURRENT_SECOND] = second
			topiclimiter[SECOND_COUNT] = 0
		topiclimiter[SECOND_COUNT] += 1
		if(topiclimiter[SECOND_COUNT] > stl)
			to_chat(src, SPAN_DANGER("Your previous action was ignored because you've done too many in a second"))
			return

	// Tgui Topic middleware
	if(tgui_Topic(href_list))
		return

	//Logs all other hrefs
	if(CONFIG_GET(flag/log_hrefs) && GLOB.world_href_log)
		WRITE_LOG(GLOB.world_href_log, "<small>[src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>")

	if(href_list["reload_tguipanel"])
		nuke_chat()
	if(href_list["reload_statbrowser"])
		stat_panel.reinitialize()

	// TGUIless adminhelp
	if(href_list["tguiless_adminhelp"])
		no_tgui_adminhelp(input(src, "Enter your ahelp", "Ahelp") as null|message)
		return

	//byond bug ID:2256651
	if(asset_cache_job && (asset_cache_job in completed_asset_jobs))
		to_chat(src, SPAN_DANGER("An error has been detected in how your client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)"))
		src << browse("...", "window=asset_cache_browser")
		return

	if(href_list["asset_cache_preload_data"])
		asset_cache_preload_data(href_list["asset_cache_preload_data"])
		return

	//search the href for script injection
	if(findtext(href,"<script",1,0) )
		world.log << "Attempted use of scripts within a topic call, by [src]"
		message_admins("Attempted use of scripts within a topic call, by [src]")
		//del(usr)
		return

	if(href_list["priv_msg"])
		var/client/receiver_client
		for(var/client/C as anything in GLOB.clients)
			if(C.ckey == ckey(href_list["priv_msg"]))
				receiver_client = C
				break
		if(!receiver_client)
			to_chat(src, SPAN_WARNING("The person you were attempting to PM has gone offline!"))
			return
		if(unansweredAhelps[receiver_client.computer_id]) unansweredAhelps.Remove(receiver_client.computer_id)
		cmd_admin_pm(receiver_client, null)
		return

	else if(href_list["FaxView"])

		var/datum/fax/info = locate(href_list["FaxView"])

		if(!istype(info))
			return

		if(info.photo_list)
			for(var/photo in info.photo_list)
				usr << browse_rsc(info.photo_list[photo], photo)

		show_browser(usr, "<body class='paper'>[info.data]</body>", "Fax Message", "Fax Message")

	else if(href_list["medals_panel"])
		GLOB.medals_panel.tgui_interact(mob)

	//NOTES OVERHAUL
	if(href_list["add_merit_info"])
		var/key = href_list["add_merit_info"]
		var/add = input("Add Merit Note") as null|message
		if(!add)
			return

		var/datum/entity/player/P = get_player_from_key(key)
		P.add_note(add, FALSE, NOTE_MERIT)

	if(href_list["add_wl_info_1"])
		var/key = href_list["add_wl_info_1"]
		var/add = input("Add Commander Note") as null|message
		if(!add)
			return

		var/datum/entity/player/P = get_player_from_key(key)
		P.add_note(add, FALSE, NOTE_COMMANDER)

	if(href_list["add_wl_info_2"])
		var/key = href_list["add_wl_info_2"]
		var/add = input("Add Synthetic Note") as null|message
		if(!add)
			return

		var/datum/entity/player/P = get_player_from_key(key)
		P.add_note(add, FALSE, NOTE_SYNTHETIC)

	if(href_list["add_wl_info_3"])
		var/key = href_list["add_wl_info_3"]
		var/add = input("Add Yautja Note") as null|message
		if(!add)
			return

		var/datum/entity/player/P = get_player_from_key(key)
		P.add_note(add, FALSE, NOTE_YAUTJA)

	if(href_list["remove_wl_info"])
		var/key = href_list["remove_wl_info"]
		var/index = text2num(href_list["remove_index"])

		var/datum/entity/player/P = get_player_from_key(key)
		P.remove_note(index)

	switch(href_list["_src_"])
		if("admin_holder")
			hsrc = admin_holder
		if("mhelp")
			var/client/thread_author = GLOB.directory[href_list["mhelp_key"]]
			if(thread_author)
				var/datum/mentorhelp/help_thread = thread_author.current_mhelp
				hsrc = help_thread
		if("usr")
			hsrc = mob
		if("prefs")
			return prefs.process_link(usr, href_list)
		if("vars")
			return view_var_Topic(href, href_list, hsrc)
		if("glob_vars")
			return view_glob_var_Topic(href, href_list, hsrc)
		if("matrices")
			return matrix_editor_Topic(href, href_list, hsrc)
		if("vote")
			return SSvote.Topic(href, href_list)

	switch(href_list["action"])
		if("openLink")
			src << link(href_list["link"])
		if("proccall")
			var/proc_to_call = text2path(href_list["procpath"])

			if(proc_to_call in GLOB.whitelisted_client_procs)
				call(src, proc_to_call)()
			else
				message_admins("[key_name_admin(src)] attempted to do a href exploit. (Inputted command: [html_encode(proc_to_call)])")
			return // Don't call hsrc in this case since it's ourselves

	return ..() //redirect to hsrc.Topic()

/client/proc/handle_spam_prevention(message, mute_type)
	if(CONFIG_GET(flag/automute_on) && !admin_holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			to_chat(src, SPAN_DANGER("You have exceeded the spam filter limit for identical messages. An auto-mute was applied."))
			cmd_admin_mute(src.mob, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			to_chat(src, SPAN_DANGER("You are nearing the spam filter limit for identical messages."))
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
/* //Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 0
	fileaccess_timer = world.time + FTPDELAY */
	return 1


	///////////
	//CONNECT//
	///////////
/client/New(TopicData)
	soundOutput = new /datum/soundOutput(src)
	TopicData = null //Prevent calls to client.Topic from connect

	if(!(connection in list("seeker", "web"))) //Invalid connection type.
		return null

	if(IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		qdel(src)
		return

	GLOB.clients += src
	GLOB.directory[ckey] = src

	// Instantiate stat panel
	stat_panel = new(src, "statbrowser")
	stat_panel.subscribe(src, PROC_REF(on_stat_panel_message))

	// Instantiate tgui panel
	tgui_panel = new(src, "browseroutput")
	tgui_say = new(src, "tgui_say")

	load_player_data()

	// Change the way they should download resources.
	var/static/next_external_rsc = 0
	var/list/external_rsc_urls = CONFIG_GET(keyed_list/external_rsc_urls)
	if(length(external_rsc_urls))
		next_external_rsc = WRAP(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]

	if(!CONFIG_GET(flag/no_localhost_rank))
		var/static/list/localhost_addresses = list("127.0.0.1", "::1")
		if(isnull(address) || (address in localhost_addresses))
			var/datum/admins/admin = new("!localhost!", R_EVERYTHING, ckey)
			admin.associate(src)
			SSticker.role_authority.roles_whitelist[ckey] = WHITELIST_EVERYTHING

	//Admin Authorisation
	admin_holder = admin_datums[ckey]
	if(admin_holder)
		admin_holder.associate(src)
	notify_login()

	add_pref_verbs()
	//preferences datum - also holds some persistent data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(QDELETED(prefs) || !istype(prefs))
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.client_reconnected(src)
	prefs.last_ip = address //these are gonna be used for banning
	prefs.last_id = computer_id //these are gonna be used for banning
	fps = prefs.fps
	language = prefs.client_language
	xeno_prefix = prefs.xeno_prefix
	xeno_postfix = prefs.xeno_postfix
	xeno_name_ban = prefs.xeno_name_ban
	if(!xeno_prefix || xeno_name_ban)
		xeno_prefix = "XX"
	if(!xeno_postfix || xeno_name_ban)
		xeno_postfix = ""

	human_name_ban = prefs.human_name_ban

	var/full_version = "[byond_version].[byond_build ? byond_build : "xxx"]"

	if(GLOB.player_details[ckey])
		player_details = GLOB.player_details[ckey]
		player_details.byond_version = full_version
	else
		player_details = new
		player_details.byond_version = full_version
		GLOB.player_details[ckey] = player_details

	view = world_view_size
	. = ..() //calls mob.Login()

	if(SSinput.initialized)
		INVOKE_ASYNC(src, /client/proc/set_macros)

	// Version check below if we ever need to start checking against BYOND versions again.

	/*if((byond_version < world.byond_version) || ((byond_version == world.byond_version) && (byond_build < world.byond_build)))
		src << "<span class='warning'>Your version of Byond (v[byond_version].[byond_build]) differs from the server (v[world.byond_version].[world.byond_build]). You may experience graphical glitches, crashes, or other errors. You will be disconnected until your version matches or exceeds the server version.<br> \
		Direct Download (Windows Installer): http://www.byond.com/download/build/[world.byond_version]/[world.byond_version].[world.byond_build]_byond.exe <br> \
		Other versions (search for [world.byond_build] or higher): http://www.byond.com/download/build/[world.byond_version]</span>"
		qdel(src)
		return*/
	//hardcode for now

	if(num2text(byond_build) in GLOB.blacklisted_builds)
		log_access("Failed login: [key] - blacklisted byond build ([byond_version].[byond_build])")
		to_chat(src, SPAN_WARNING(FONT_SIZE_HUGE("Your version of byond is blacklisted.")), immediate = TRUE)
		to_chat(src, SPAN_WARNING(FONT_SIZE_LARGE("Byond build [byond_build] ([byond_version].[byond_build]) has been blacklisted for the following reason: [GLOB.blacklisted_builds[num2text(byond_build)]].")), immediate = TRUE)
		to_chat(src, SPAN_WARNING(FONT_SIZE_LARGE("Please download a new version of byond. If [byond_build] is the latest (which it shouldn't be), you can go to <a href=\"https://secure.byond.com/download/build\">BYOND's website</a> to download other versions.")), immediate = TRUE)
		to_chat(src, SPAN_NOTICE(FONT_SIZE_LARGE("You will now be automatically disconnected. Have a CM day.")), immediate = TRUE)
		qdel(src)
		return

	//do this check after the blacklist check to avoid confusion
	if((byond_version < GOOD_BYOND_MAJOR) || ((byond_version == GOOD_BYOND_MAJOR) && (byond_build < GOOD_BYOND_MINOR)))
		to_chat(src, FONT_SIZE_HUGE(SPAN_BOLDNOTICE("YOUR BYOND VERSION IS NOT WELL SUITED FOR THIS SERVER. Download latest BETA build or you may suffer random crashes or disconnects.")))

	// Initialize tgui panel
	stat_panel.initialize(
		inline_html = file("html/statbrowser.html"),
		inline_js = file("html/statbrowser.js"),
		inline_css = file("html/statbrowser.css"),
	)
	addtimer(CALLBACK(src, PROC_REF(check_panel_loaded)), 30 SECONDS)

	tgui_panel.initialize()
	tgui_say.initialize()

	check_event_info("Global", src)
	if(mob && !isobserver(mob) && !isnewplayer(mob) && mob.faction)
		check_event_info(mob.faction.name, src)

	if((world.address == address || !address) && !host)
		host = key
		world.update_status()

	connection_time = world.time
	winset(src, null, "command=\".configure graphics-hwmode on\"")

	send_assets()

	create_clickcatcher()
	apply_clickcatcher()

	if(prefs.lastchangelog != GLOB.changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		winset(src, "infowindow.changelog", "background-color=#ED9F9B;font-style=bold")

	if(prefs.toggle_prefs & TOGGLE_FULLSCREEN)
		toggle_fullscreen(TRUE)
	else
		toggle_fullscreen(FALSE)

	view = world_view_size

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_CLIENT_LOGIN, src)

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	if(!gc_destroyed)
		gc_destroyed = world.time
		if (!QDELING(src))
			stack_trace("Client does not purport to be QDELING, this is going to cause bugs in other places!")

		SEND_SIGNAL(src, COMSIG_PARENT_QDELETING, TRUE)
		Destroy()
	return ..()

/client/Destroy()
	QDEL_NULL(soundOutput)
	QDEL_NULL(obj_window)
	if(prefs)
		prefs.owner = null
		QDEL_NULL(prefs.preview_dummy)

	if(admin_holder)
		admin_holder.owner = null
		GLOB.admins -= src
	GLOB.directory -= ckey
	GLOB.clients -= src
	SSping.currentrun -= src

	unansweredAhelps?.Remove(computer_id)
	log_access("Вышел: [key_name(src)]")
	if(CLIENT_IS_STAFF(src))
		message_admins("Админ Вышел: [key_name(src)]")

		var/list/adm = get_admin_counts(R_MOD)
		REDIS_PUBLISH("byond.access", "type" = "logout", "key" = src.key, "remaining" = length(adm["total"]), "afk" = length(adm["afk"]))

	..()
	return QDEL_HINT_HARDDEL_NOW


#undef TOPIC_SPAM_DELAY
#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

/// Handles login-related logging and associated notifications
/client/proc/notify_login()
	log_access("Вошел: [key_name(src)] с [address ? address : "localhost"]-[computer_id] || BYOND v[byond_version].[byond_build]")
	if(CLIENT_IS_STAFF(src))
		message_admins("Админ Вошел: [key_name(src)]")

		var/list/adm = get_admin_counts(R_MOD)
		REDIS_PUBLISH("byond.access", "type" = "login", "key" = src.key, "remaining" = length(adm["total"]), "afk" = length(adm["afk"]))

	if(CONFIG_GET(flag/log_access))
		for(var/mob/M in GLOB.player_list)
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == address) )
					matches += "IP ([address])"
				if( (connection != "web") && (M.computer_id == computer_id) )
					if(matches) matches += " and "
					matches += "ID ([computer_id])"
					spawn() alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
				if(matches)
					if(M.client)
						message_admins("<font color='red'><B>Notice: </B>[SPAN_BLUE("<A href='?src=\ref[usr];priv_msg=[src.ckey]'>[key_name_admin(src)]</A> has the same [matches] as <A href='?src=\ref[usr];priv_msg=[src.ckey]'>[key_name_admin(M)]</A>.")]", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins("<font color='red'><B>Notice: </B>[SPAN_BLUE("<A href='?src=\ref[usr];priv_msg=[src.ckey]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in).")]", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")


//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration) return inactivity
	return 0

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_assets()
	spawn (10) //removing this spawn causes all clients to not get verbs.
		//load info on what assets the client has
		src << browse('code/modules/asset_cache/validate_assets.html', "window=asset_cache_browser")

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		addtimer(CALLBACK(SSassets.transport, TYPE_PROC_REF(/datum/asset_transport, send_assets_slow), src, SSassets.transport.preload), 5 SECONDS)

/proc/setup_player_entity(ckey)
	if(!ckey)
		return
	if(GLOB.player_entities["[ckey]"])
		return GLOB.player_entities["[ckey]"]
	var/datum/player_entity/P = new()
	P.ckey = ckey
	P.entity_name = ckey
	GLOB.player_entities["[ckey]"] = P
	return P

/client/proc/clear_chat_spam_mute(warn_level = 1, message = FALSE, increase_warn = FALSE)
	if(talked > warn_level)
		return
	talked = 0
	if(message)
		to_chat(src, SPAN_NOTICE("You may now speak again."))
	if(increase_warn)
		chatWarn++

//for adding procs that allow showing/hiding other groups of prefs
/client/proc/add_pref_verbs()
	add_verb(src, /client/proc/show_combat_chat_preferences)
	add_verb(src, /client/proc/show_ghost_preferences)

/client/proc/runtime_macro_insert(macro_button, parent, command)
	if(!macro_button || !parent || !command)
		return

	var/list/macro_sets = params2list(winget(src, null, "macros"))
	if(!(parent in macro_sets))
		var/old = LAZYACCESS(params2list(winget(src, "mainwindow", "macro")), 1)
		if(!old)
			return
		winset(src, null, "mainwindow.macro=[parent]")
		winset(src, null, "mainwindow.macro=[old]")

	winset(src, "[parent].[macro_button]", "parent=[parent];name=[macro_button];command=[command]")

/client/proc/runtime_macro_remove(macro_button, parent)
	if(!macro_button || !parent)
		return

	var/list/macro_sets = params2list(winget(src, null, "macros"))
	if(!(parent in macro_sets))
		var/old = params2list(winget(src, "mainwindow", "macro"))[1]
		winset(src, null, "mainwindow.macro=[parent]")
		winset(src, null, "mainwindow.macro=[old]")

	winset(src, "[parent].[macro_button]", "parent=")

/client/verb/read_key_down(key as text|null)
	set name = ".Read Key Down"
	set hidden = TRUE

	if(!key)
		return

	SEND_SIGNAL(src, COMSIG_CLIENT_KEY_DOWN, key)

/client/verb/read_key_up(key as text|null)
	set name = ".Read Key Up"
	set hidden = TRUE

	if(!key)
		return

	SEND_SIGNAL(src, COMSIG_CLIENT_KEY_UP, key)


/**
* Compiles a full list of verbs to be sent to the browser
* Sends the 2D verbs vector of (verb category, verb name)
*/
/client/proc/init_verbs()
	if(IsAdminAdvancedProcCall())
		return
	var/list/verblist = list()
	var/list/verbstoprocess = verbs.Copy()
	if(mob)
		verbstoprocess += mob.verbs
		for(var/atom/movable/thing as anything in mob.contents)
			verbstoprocess += thing.verbs
	panel_tabs.Cut() // panel_tabs get reset in init_verbs on JS side anyway
	for(var/procpath/verb_to_init as anything in verbstoprocess)
		if(!verb_to_init)
			continue
		if(verb_to_init.hidden)
			continue
		if(!istext(verb_to_init.category))
			continue
		panel_tabs |= verb_to_init.category
		verblist[++verblist.len] = list(verb_to_init.category, verb_to_init.name)
	src.stat_panel.send_message("init_verbs", list(panel_tabs = panel_tabs, verblist = verblist))

/client/proc/check_panel_loaded()
	if(stat_panel.is_ready())
		return
	to_chat(src, SPAN_USERDANGER("Statpanel failed to load, click <a href='?src=[REF(src)];reload_statbrowser=1'>here</a> to reload the panel "))

/**
 * Handles incoming messages from the stat-panel TGUI.
 */
/client/proc/on_stat_panel_message(type, payload)
	switch(type)
		if("Update-Verbs")
			init_verbs()
		if("Remove-Tabs")
			panel_tabs -= payload["tab"]
		if("Send-Tabs")
			panel_tabs |= payload["tab"]
		if("Reset-Tabs")
			panel_tabs = list()
		if("Set-Tab")
			stat_tab = payload["tab"]
			SSstatpanels.immediate_send_stat_data(src)


/**
 * Updates the keybinds for special keys
 *
 * Handles adding macros for the keys that need it
 * And adding movement keys to the clients movement_keys list
 * At the time of writing this, communication(OOC, Say, IC) require macros
 * Arguments:
 * * direct_prefs - the preference we're going to get keybinds from
 */
/client/proc/update_special_keybinds(datum/preferences/direct_prefs)
	var/datum/preferences/D = prefs || direct_prefs
	if(!D?.key_bindings)
		return
	movement_keys = list()
	for(var/key in D.key_bindings)
		for(var/kb_name in D.key_bindings[key])
			switch(kb_name)
				if("North")
					movement_keys[key] = NORTH
				if("East")
					movement_keys[key] = EAST
				if("West")
					movement_keys[key] = WEST
				if("South")
					movement_keys[key] = SOUTH
				if(SAY_CHANNEL)
					if(prefs.tgui_say)
						var/say = tgui_say_create_open_command(SAY_CHANNEL)
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=[say]")
					else
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=\"say\\n.typing\"")
				if(COMMS_CHANNEL)
					if(prefs.tgui_say)
						var/radio = tgui_say_create_open_command(COMMS_CHANNEL)
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=[radio]")
					else
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=\"say\\n.typing\"")
				if(ME_CHANNEL)
					if(prefs.tgui_say)
						var/me = tgui_say_create_open_command(ME_CHANNEL)
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=[me]")
					else
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=\"me\\n.typing\"")
				if(OOC_CHANNEL)
					if(prefs.tgui_say)
						var/ooc = tgui_say_create_open_command(OOC_CHANNEL)
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=[ooc]")
					else
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=ooc")
				if(LOOC_CHANNEL)
					if(prefs.tgui_say)
						var/looc = tgui_say_create_open_command(LOOC_CHANNEL)
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=[looc]")
					else
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=looc")
				if(MOD_CHANNEL)
					if(admin_holder?.check_for_rights(R_MOD))
						if(prefs.tgui_say)
							var/msay = tgui_say_create_open_command(MOD_CHANNEL)
							winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=[msay]")
						else
							winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=msay")
					else
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=")
				if(ADMIN_CHANNEL)
					if(admin_holder?.check_for_rights(R_ADMIN))
						if(prefs.tgui_say)
							var/asay = tgui_say_create_open_command(ADMIN_CHANNEL)
							winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=[asay]")
						else
							winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=asay")
					else
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=")
				if(MENTOR_CHANNEL)
					if(admin_holder?.check_for_rights(R_MENTOR))
						if(prefs.tgui_say)
							var/mentor = tgui_say_create_open_command(MENTOR_CHANNEL)
							winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=[mentor]")
						else
							winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=mentorsay")
					else
						winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=")
				if("Whisper")
					winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=whisper")

/client/proc/toggle_fullscreen(new_value)
	if(new_value)
		winset(src, "mainwindow", "is-maximized=false;can-resize=false;titlebar=false;menu=menu")
	else
		winset(src, "mainwindow", "is-maximized=false;can-resize=true;titlebar=true;menu=menu")
	winset(src, "mainwindow", "is-maximized=true")

/// Attempts to make the client orbit the given object, for administrative purposes.
/// If they are not an observer, will try to aghost them.
/client/proc/admin_follow(atom/movable/target)
	var/can_ghost = TRUE

	if(!isobserver(mob))
		can_ghost = admin_ghost()

	if(!can_ghost)
		return FALSE

	var/mob/dead/observer/observer = mob
	observer.ManualFollow(target)

/client/proc/check_timelock(list/roles, hours)
	var/timelock_name = "[islist(roles) ? jointext(roles, "") : roles][hours]"
	if(!GLOB.timelocks[timelock_name])
		GLOB.timelocks[timelock_name] = TIMELOCK_JOB(roles, hours)
	var/datum/timelock/timelock = GLOB.timelocks[timelock_name]
	if(timelock.can_play(src))
		return TRUE
	return FALSE

/client/verb/fix_stat_panel()
	set name = "Fix Stat Panel"
	set hidden = TRUE

/client/verb/change_lang()
	set name = "Change Language"
	set category = "OOC"

	language = language == CLIENT_LANGUAGE_RUSSIAN ? CLIENT_LANGUAGE_ENGLISH : CLIENT_LANGUAGE_RUSSIAN
	prefs.client_language = language
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE(auto_lang(LANGUAGE_CHANGE_MESSAGE)))
	init_verbs()
	for(var/window_id in tgui_windows)
		var/datum/tgui_window/window = tgui_windows[window_id]
		window.reinitialize()

/client/proc/auto_lang(language_choice)
	return auto_language(language_choice, language)

/proc/auto_language(language_choice, language)
	if(language == CLIENT_LANGUAGE_ENGLISH)
		return language_choice//GLOB.client_language_en[lang_version] huh, same
	else if(language == CLIENT_LANGUAGE_RUSSIAN)
		return GLOB.client_language_ru[language_choice]

/client/proc/open_filter_editor(atom/in_atom)
	if(admin_holder)
		admin_holder.filteriffic = new /datum/filter_editor(in_atom)
		admin_holder.filteriffic.tgui_interact(mob)

/// Clears the client's screen, aside from ones that opt out
/client/proc/clear_screen()
	for (var/object in screen)
		if (istype(object, /atom/movable/screen))
			var/atom/movable/screen/screen_object = object
			if (!screen_object.clear_with_screen)
				continue

		screen -= object

///opens the particle editor UI for the in_atom object for this client
/client/proc/open_particle_editor(atom/movable/in_atom)
	if(admin_holder)
		admin_holder.particle_test = new /datum/particle_editor(in_atom)
		admin_holder.particle_test.tgui_interact(mob)
