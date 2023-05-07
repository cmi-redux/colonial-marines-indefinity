/mob/new_player/Login()
	if(!mind)
		mind = new /datum/mind(key, ckey)
		mind.active = 1
		mind.current = src
		mind_initialize()

	if(length(GLOB.newplayer_start))
		forceMove(get_turf(pick(GLOB.newplayer_start)))
	else
		forceMove(locate(1,1,1))
	lastarea = get_area(src.loc)

	sight |= SEE_TURFS

	. = ..()

	if(SSqueue.hard_popcap <= (length(GLOB.clients)-length(GLOB.que_clients)) && SSqueue.hard_popcap && !(client in GLOB.admins))
		que_data = SSqueue.queue_player(src)
		queue_player_panel()
		addtimer(CALLBACK(src, PROC_REF(lobby)), 4 SECONDS)
	else
		new_player_panel()
		addtimer(CALLBACK(src, PROC_REF(lobby)), 4 SECONDS)

/mob/new_player/proc/exit_queue()
	close_spawn_windows()
	sleep(1 SECONDS)
	new_player_panel()

/mob/new_player/proc/queue_player_panel(refresh = FALSE)
	if(!client)
		return
	var/time_que = world.time - que_data.time_join
	var/output = "<div align='center'>[client.auto_lang(LANGUAGE_WELCOME)],"
	output +="<br><b>[client.key]</b>"
	output +="<br><b>[client.auto_lang(LANGUAGE_WHO_PLAYERS)]: [GLOB.clients.len - GLOB.que_clients]</b>"
	output +="<br><b>[client.auto_lang(LANGUAGE_QUEUE_START)]: [time2text(que_data.time_join, "mm.ss")]</b>"
	output +="<br><b>[client.auto_lang(LANGUAGE_QUEUE_WAITING)]: [time2text(time_que, "mm.ss")]</b>"
	output +="<br><b>[client.auto_lang(LANGUAGE_QUEUE_POS)]: [que_data.position]</b>"
	output +="<br><b>[client.auto_lang(LANGUAGE_QUEUE_TOTAL_POS)]: [length(SSqueue.queued)]</b>"
	if(GLOB.last_time_qued)
		output +="<br><b>[client.auto_lang(LANGUAGE_QUEUE_LAST_TIME_EXIT)]: [GLOB.last_time_qued]</b>"
	output += "</div>"
	if(refresh)
		close_browser(src, "que")
	show_browser(src, output, client.auto_lang(LANGUAGE_QUEUE), "que", "size=240x300;can_close=0;can_minimize=0")
	return

/mob/new_player/proc/lobby()
	if(!client)
		return

	client.playtitlemusic()

	// To show them the full lobby art. This fixes itself on a mind transfer so no worries there.
	client.change_view(lobby_view_size)
	// Credit the lobby art author
	if(displayed_lobby_art != -1)
		var/list/lobby_authors = CONFIG_GET(str_list/lobby_art_authors)
		var/author = lobby_authors[displayed_lobby_art]
		if(author != "Unknown")
			to_chat(src, SPAN_ROUNDBODY("<hr>[client.auto_lang(LANGUAGE_LOBBY_ART)] [author]<hr>"))
	if(join_motd)
		to_chat(src, "<div class=\"motd\">[join_motd[client.language]]</div>")
	if(current_tms)
		to_chat(src, SPAN_BOLDANNOUNCE(current_tms))
