/datum/custom_event_info
	var/name = "default"
	var/faction_name = "default"
	var/datum/faction/faction = null
	var/msg = ""

//this shows event info to player. can pass clients and mobs
/datum/custom_event_info/proc/show_player_event_info(client/user)

	if(!istype(user))
		return

	if(msg == "")
		to_chat(user, SPAN_WARNING("Для [faction_name] кастомное ивент сообщение не найдено. Либо не происходит никакого ивента или администраторы не установили его или посчитали что не нужно устанавливать."))
		return

	var/dat
	dat = "<h1 class='alert'>[faction_name] Ивент сообщение</h1>"
	dat += "<h2 class='alert'>Кастомный ивент в процессе. OOC Info:</h2>"
	dat += SPAN_ALERT("[msg]<br>")
	to_chat(user, dat)
	return

//this shows changed event info to everyone in the category
/datum/custom_event_info/proc/handle_event_info_update()

	if(!msg)
		return

	if(faction_name == "Global")
		var/dat = "<h1 class='alert'>[faction_name] Ивент сообщение</h1>"
		dat += "<h2 class='alert'>Кастомный ивент в прогрессе. OOC Info:</h2>"
		dat += SPAN_ALERT("[msg]<br>")
		to_world(dat)
		return
	else if(faction_name)
		for(var/mob/M in faction.totalMobs)
			show_player_event_info(M.client)
		return

	message_admins("ОШИБКА, ([faction_name ? faction_name : "name lost"]) фракция не найдена для ивент оповещения.")
	return

/proc/check_event_info(category = "Global", client/user)
	if(GLOB.custom_event_info_list[category])
		var/datum/custom_event_info/CEI = GLOB.custom_event_info_list[category]
		if(CEI.msg)
			CEI.show_player_event_info(user)
