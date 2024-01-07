// -- Docks
/obj/docking_port/stationary/crashmode
	id = DROPSHIP_HEART_OF_GOLD
	name = "USS Heart Of Gold Crash Site"
	dir = SOUTH
	width = 29
	height = 19
	dwidth = 14
	dheight = 9
	hidden = TRUE  //To make them not block landings during distress

/obj/docking_port/stationary/crashmode/on_crash()
	//clear areas around the shuttle with explosions
	var/turf/C = return_center_turf()

	var/cos = 1
	var/sin = 0
	switch(dir)
		if(WEST)
			cos = 0
			sin = 1
		if(SOUTH)
			cos = -1
			sin = 0
		if(EAST)
			cos = 0
			sin = -1

	var/updown = (round(width/2))*sin + (round(height/2))*cos
	var/leftright = (round(width/2))*cos - (round(height/2))*sin

	var/turf/front = locate(C.x, C.y - updown, C.z)
	var/turf/rear = locate(C.x, C.y + updown, C.z)
	var/turf/left = locate(C.x - leftright, C.y, C.z)
	var/turf/right = locate(C.x + leftright, C.y, C.z)

	cell_explosion(front, 600, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("посадки USS Heart Of Gold"))//Clears out walls
	cell_explosion(rear, 600, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("посадки USS Heart Of Gold"))
	cell_explosion(left, 600, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("посадки USS Heart Of Gold"))
	cell_explosion(right, 600, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("посадки USS Heart Of Gold"))

// -- Shuttles

/obj/docking_port/mobile/crashmode
	name = "USS Heart Of Gold"
	dir = SOUTH
	width = 29
	height = 19
	dwidth = 14
	dheight = 9

	callTime = 10 MINUTES
	ignitionTime = 5 SECONDS
	prearrivalTime = 12 SECONDS

	var/list/blended = list()

/obj/docking_port/mobile/crashmode/register()
	. = ..()
	SSshuttle.uss_heart_of_gold = src
	for(var/obj/structure/machinery/door/poddoor/almayer/blended/crash/B in machines)
		if(B.id == "crash_pod1")
			blended += B

/obj/docking_port/mobile/crashmode/afterShuttleMove()
	if(!is_ground_level(z))
		for(var/i in blended)
			var/obj/structure/machinery/door/poddoor/almayer/blended/B = i
			INVOKE_ASYNC(B, TYPE_PROC_REF(/obj/structure/machinery/door, close))
	else
		for(var/i in blended)
			var/obj/structure/machinery/door/poddoor/almayer/blended/B = i
			INVOKE_ASYNC(B, TYPE_PROC_REF(/obj/structure/machinery/door, open))

/obj/docking_port/stationary/crashmode/hangar
	name = "Hangar Pad One"
	id = DROPSHIP_HEART_OF_GOLD
//	roundstart_template = /datum/map_template/shuttle/uss_heart_of_gold


//Console

/obj/structure/machinery/computer/shuttle/shuttle_control/uss_heart_of_gold
	name = "'USS Heart Of Gold' shuttle console"
	desc = "The remote controls for the 'USS Hear Of Gold' shuttle."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	possible_destinations = "uss_heart_of_gold_loadingdock"

/obj/structure/machinery/computer/shuttle/shuttle_control/uss_heart_of_gold/attack_hand(mob/user)
	user.set_interaction(src)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Доступ Запрещен!"))
		return
	var/obj/docking_port/mobile/M = SSshuttle.uss_heart_of_gold
	var/dat = "Статус: [M ? M.getStatusText() : "*Missing*"]<br><br>"
	if(M)
		dat += "<A href='?src=[REF(src)];move=infinite-transit'>Начать Эвакуацию</A><br>"

	show_browser(user, dat, "computer", M ? M.name : "shuttle", 300, 200)

/obj/structure/machinery/computer/shuttle/shuttle_control/uss_heart_of_gold/Topic(href, href_list)
	. = ..()
	if(.)
		return

	add_fingerprint(usr, "topic")

	if(!isqueen(usr) && !allowed(usr))
		to_chat(usr, SPAN_DANGER("Доступ Запрещен!"))
		return TRUE


	if(!length(GLOB.active_nuke_list) && tgui_alert(usr, "Are you sure you want to launch the shuttle? Without sufficiently dealing with the threat, you will be in direct violation of your orders!", "Are you sure?", list(usr.client.auto_lang(LANGUAGE_YES), usr.client.auto_lang(LANGUAGE_CANCEL))) != usr.client.auto_lang(LANGUAGE_YES))
		return TRUE

	log_admin("[key_name(usr)] запустил uss heart of gold [!length(GLOB.active_nuke_list)? " early" : ""].")

	var/obj/docking_port/mobile/M = SSshuttle.uss_heart_of_gold
	if(!(M.shuttle_flags & GAMEMODE_IMMUNE) && world.time < SSticker.round_start_time + SSticker.mode.lz_selection_timer)
		to_chat(usr,  SPAN_WARNING("В данный момент шатл в стадии подготовки к запуску."))
		return TRUE
	if(!M.can_move_topic(usr))
		return TRUE

	visible_message(SPAN_NOTICE("Шатл отправляется. Пожалуйста стойте в стороне от дверей."))
	M.destination = null
	M.mode = SHUTTLE_IGNITING
	M.setTimer(M.ignitionTime)

	var/datum/game_mode/crash/C = SSticker.mode
	addtimer(VARSET_CALLBACK(C, marines_evac, CRASH_EVAC_INPROGRESS), M.ignitionTime + 1 SECONDS)
	addtimer(VARSET_CALLBACK(C, marines_evac, CRASH_EVAC_COMPLETED), 2 MINUTES)
	return TRUE
