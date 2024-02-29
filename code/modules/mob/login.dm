/// Handles setting lastKnownIP and computer_id for use by the ban systems
/mob/proc/update_Login_details()
	if(client)
		lastKnownIP = client.address
		computer_id = client.computer_id

/mob/Login()
	set waitfor = FALSE

	if(!client)
		return

	logging_ckey = client.ckey
	persistent_ckey = client.ckey

	if(client.player_data)
		client.player_data.playtime_start = world.time

	GLOB.player_list |= src

	update_Login_details()

	client.images = null
	client.screen = null //remove hud items just in case
	if(!hud_used)
		create_hud()
	if(hud_used)
		hud_used.show_hud(hud_used.hud_version)

	reload_fullscreens()

	if(length(client_color_matrices))
		update_client_color_matrices(time = 0) //This mob has client color matrices set, apply them instantly on login.
	else
		update_client_color_matrices(time = 1.5 SECONDS) //Otherwise, fade any matrices from a previous mob.

	next_move = 1
	sight |= SEE_SELF

	. = ..()

	reset_view(loc)
	update_sight()

	//updating atom HUD
	refresh_huds()

	if(client)
		check_event_info("Global", client)
		if(!isobserver(src) && faction)
			check_event_info(faction.name, client)

	if(client.player_details)
		for(var/foo in client.player_details.post_login_callbacks)
			var/datum/callback/CB = foo
			CB.Invoke()

	client.init_verbs()

	if(length(GLOB.clients) >= CONFIG_GET(number/soft_popcap))
		to_chat(src, SPAN_WARNING("<h1>[CONFIG_GET(string/soft_popcap_message)]</h1>"))

	SSautobalancer.balance_action(src, "login")

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_LOGIN, src)
	SEND_SIGNAL(client, COMSIG_CLIENT_MOB_LOGIN, src)
	SEND_SIGNAL(src, COMSIG_MOB_LOGIN)
