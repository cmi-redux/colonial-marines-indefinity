

/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"

	if(usr.is_mob_incapacitated())
		return

	if(hand)
		var/obj/item/W = l_hand
		if(W)
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if(W)
			W.attack_self(src)
			update_inv_r_hand()
	if(next_move < world.time)
		next_move = world.time + 2
	return

/mob/verb/toggle_normal_throw()
	set name = "Toggle Normal Throw"
	set category = "IC"
	set hidden = TRUE

	to_chat(usr, SPAN_DANGER("This mob type cannot throw items."))
	return

/mob/verb/view_playtime()
	set category = "OOC"
	set name = "View Playtimes"
	set desc = "View your playtimes."

	if(!SSentity_manager.initialized)
		to_chat(src, client.auto_lang(LANGUAGE_LOBBY_WAIT_DB))
		return

	if(client && client.player_data)
		client.player_data.tgui_interact(src)

/mob/verb/view_discord()
	set category = "OOC"
	set name = "Discord Connect"
	set desc = "View your discord info."

	if(!SSentity_manager.initialized || !client?.player_data?.discord_loaded)
		to_chat(src, client.auto_lang(LANGUAGE_LOBBY_WAIT_DB))
		return

	if(client.player_data.discord)
		client.player_data.discord.ui_interact(src)
	else
		discord_create()

/mob/proc/discord_create()
	var/discord_id = tgui_input_text(usr, "Insert your DISCORD ID (18-19 NUMBERS):", "Discord Connect", 0, 19, FALSE, timeout = 10 SECONDS)
	if(!isnull(discord_id))
		if(!(length(discord_id) == 18 || length(discord_id) == 19))
			to_chat(src, "<font color='red'>Inserted incurrect ID!</font>")
			return
		if(alert("Вы уверены, это нельзя будет изменить без помощи админа?",,"Да","Нет")=="Нет")
			return
		else
			if(!discord_id)
				to_chat(src, "<font color='red'>Произошла ошибка, повторите попытку!</font>")
				return
			var/list/datum/view_record/discord_view/strikes_discord = DB_VIEW(/datum/view_record/discord_view/, DB_COMP("discord_id", DB_EQUALS, discord_id))
			if(length(strikes_discord))
				to_chat(src, "<font color='red'>This is discord account already connected!</font>")
				return
			else
				var/datum/entity/discord/PS = DB_ENTITY(/datum/entity/discord)
				client.player_data.discord = PS
				client.player_data.discord.discord_id = discord_id

				var/discord_key = "[rand(0,9)][rand(0,9)][rand(0,9)][pick(alphabet_uppercase)][pick(alphabet_uppercase)][pick(alphabet_uppercase)]"
				var/list/datum/view_record/discord_view/same_discord_keys = DB_VIEW(/datum/view_record/discord_view/, DB_COMP("discord_key", DB_EQUALS, discord_key))
				var/list/discord_keys = list()
				for(var/datum/view_record/discord_view/discord in same_discord_keys)
					discord_keys += discord.discord_key
				while(discord_key in discord_keys)
					discord_key = "[rand(0,9)][rand(0,9)][rand(0,9)][pick(alphabet_uppercase)][pick(alphabet_uppercase)][pick(alphabet_uppercase)]"

				to_chat(src, "<font color='red'>Generated DISCORD KEY - [discord_key].</font>")
				client.player_data.discord.discord_key = discord_key
				client.player_data.discord.save_discord(discord_id, discord_key, client.player_data.id)

				var/datum/discord_embed/embed = new()
				embed.title = "Верефикация аккаунта"
				embed.description = "Верефикация с ключом **[discord_key]**, в раунде **[SSperf_logging.round?.id]** ожидает проверки"
				embed.color = COLOR_WEBHOOK_DEFAULT
				embed.content = "<@[discord_id]>"
				send2verefy_webhook(embed)
	else
		return

/proc/send2verefy_webhook(message_or_embed)
	var/webhook = CONFIG_GET(string/verefy_webhook_url)
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

/mob/verb/toggle_high_toss()
	set name = "Toggle High Toss"
	set category = "IC"
	set hidden = TRUE
	set src = usr

	to_chat(usr, SPAN_DANGER("This mob type cannot throw items."))
	return

/mob/proc/point_to(atom/A in view())
	//set name = "Point To"
	//set category = "Object"

	if(!isturf(src.loc) || !(A in view(src)))//target is no longer visible to us
		return 0

	if(!A.mouse_opacity)//can't click it? can't point at it.
		return 0

	if(is_mob_incapacitated() || (status_flags & FAKEDEATH)) //incapacitated, can't point
		return 0

	var/tile = get_turf(A)
	if(!tile)
		return 0

	if(recently_pointed_to > world.time)
		return 0

	next_move = world.time + 2

	point_to_atom(A, tile)
	return 1





/mob/verb/memory()
	set name = "Notes"
	set category = "IC"

	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "IC"

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)
	msg = sanitize(msg)

	if(mind)
		if(length(mind.memory) < 4000)
			mind.store_memory(msg)
		else
			src.sleeping = 9999999
			message_admins("[key_name(usr)] auto-slept for attempting to exceed mob memory limit. (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/verb/abandon_mob()
	set name = "Respawn"
	set category = "OOC"

	var/is_admin = 0
	if(client.admin_holder && (client.admin_holder.rights & R_ADMIN))
		is_admin = 1

	if(!CONFIG_GET(flag/respawn) && !is_admin)
		to_chat(usr, SPAN_NOTICE(" Возрождение отключено."))
		return
	if(stat != 2)
		to_chat(usr, SPAN_NOTICE(" <B>Вы должны умереть, чтобы использовать это!</B>"))
		return
	if(SSticker.mode && (SSticker.mode.name == "meteor" || SSticker.mode.name == "epidemic")) //BS12 EDIT
		to_chat(usr, SPAN_NOTICE(" Возрождение отключено в этом типе раунда."))
		return
	else
		var/deathtime = world.time - src.timeofdeath
		var/deathtimeminutes = round(deathtime / 600)
		var/pluralcheck = "minute"
		if(deathtimeminutes == 0)
			pluralcheck = ""
		else if(deathtimeminutes == 1)
			pluralcheck = " [deathtimeminutes] minute and"
		else if(deathtimeminutes > 1)
			pluralcheck = " [deathtimeminutes] minutes and"
		var/deathtimeseconds = round((deathtime - deathtimeminutes * 600) / 10,1)
		to_chat(usr, "You have been dead for[pluralcheck] [deathtimeseconds] seconds.")

	if(alert("Are you sure you want to respawn?",,client.auto_lang(LANGUAGE_YES),client.auto_lang(LANGUAGE_NO)) != client.auto_lang(LANGUAGE_YES))
		return

	log_game("[usr.name]/[usr.key] used abandon mob.")

	to_chat(usr, SPAN_NOTICE(" <B>Make sure to play a different character, and please roleplay correctly!</B>"))

	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return
	client.screen.Cut()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return

	var/mob/new_player/M = new /mob/new_player()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
	if(M.client) M.client.change_view(world_view_size)
// M.Login() //wat
	return

/*/mob/dead/observer/verb/observe()
	set name = "Observe"
	set category = "Ghost"

	reset_perspective(null)

	var/mob/target = tgui_input_list(usr, "Please select a human mob:", "Observe", GLOB.human_mob_list)
	if(!target)
		return

	do_observe(target) */ //disabled thanks to le exploiterinos

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "Object"
	reset_view(null)
	unset_interaction()
	if(istype(src, /mob/living))
		var/mob/living/M = src
		if(M.cameraFollow)
			M.cameraFollow = null

/mob/verb/eastface()
	set hidden = TRUE
	return face_dir(EAST)

/mob/verb/westface()
	set hidden = TRUE
	return face_dir(WEST)

/mob/verb/northface()
	set hidden = TRUE
	return face_dir(NORTH)

/mob/verb/southface()
	set hidden = TRUE
	return face_dir(SOUTH)


/mob/verb/northfaceperm()
	set hidden = TRUE
	set_face_dir(NORTH)

/mob/verb/southfaceperm()
	set hidden = TRUE
	set_face_dir(SOUTH)

/mob/verb/eastfaceperm()
	set hidden = TRUE
	set_face_dir(EAST)

/mob/verb/westfaceperm()
	set hidden = TRUE
	set_face_dir(WEST)


/atom/movable/proc/stop_pulling()
	if(!pulling)
		return
	var/mob/M = pulling
	pulling.pulledby = null
	pulling = null

	if(istype(M))
		if(M.client)
			//resist_grab uses long movement cooldown durations to prevent message spam
			//so we must undo it here so the victim can move right away
			M.client.next_movement = world.time
		M.update_transform(TRUE)
		M.update_canmove()

/mob/stop_pulling()
	if(!pulling)
		return
	var/mob/M = pulling
	pulling.pulledby = null
	pulling = null
	grab_level = 0

	if(client)
		client.recalculate_move_delay()
		// When you stop pulling a mob after you move a tile with it your next movement will still include
		// the grab delay so we have to fix it here (we love code)
		client.next_movement = world.time + client.move_delay
	if(hud_used && hud_used.pull_icon)
		hud_used.pull_icon.icon_state = "pull0"
	if(istype(r_hand, /obj/item/grab))
		temp_drop_inv_item(r_hand)
	else if(istype(l_hand, /obj/item/grab))
		temp_drop_inv_item(l_hand)
	if(istype(M))
		if(M.client)
			//resist_grab uses long movement cooldown durations to prevent message spam
			//so we must undo it here so the victim can move right away
			M.client.next_movement = world.time
		M.update_transform(TRUE)
		M.update_canmove()

/mob/verb/stop_pulling1()
	set name = "Stop Pulling"
	set category = "IC"

	stop_pulling()

/mob/living/carbon/human/verb/lookup()
	set name = "Look up"
	set category = "IC"

	if(!shadow)
		var/turf/above = SSmapping.get_turf_above(loc)
		if(above && istransparentturf(above))
			to_chat(src, SPAN_NOTICE("You look up."))
			shadow = new(above)
			reset_view(shadow)
		else
			to_chat(src, SPAN_NOTICE("You can see [above]."))
	else
		handle_watch_above()
