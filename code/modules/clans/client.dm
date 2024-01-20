/client
	var/datum/entity/clan_player/clan_info

/client/load_player_data_info(datum/entity/player/player)
	set waitfor = FALSE

	. = ..()
	if(SSticker.role_authority && (player_data?.whitelist?.whitelist_flags & WHITELIST_PREDATOR))
		clan_info = GET_CLAN_PLAYER(player.id)
		clan_info.sync()

		if(player_data?.whitelist?.whitelist_flags & WHITELIST_YAUTJA_LEADER)
			clan_info.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_ADMIN]
			clan_info.permissions |= CLAN_PERMISSION_ALL
		else
			clan_info.permissions &= ~CLAN_PERMISSION_ADMIN_MANAGER // Only the leader can manage the ancients

		clan_info.save()

/client/proc/usr_create_new_clan()
	set name = "Create New Clan"
	set category = "Debug"

	if(!clan_info)
		return

	if(!(clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER))
		return

	var/input = input(src, "Name the clan:", "Create a Clan") as text|null

	if(!input)
		return

	to_chat(src, SPAN_NOTICE("Made a new clan called: [input]"))

	create_new_clan(input)

/client/verb/view_clan_info()
	set name = "View Clan Info"
	set category = "OOC.Records"

	var/clan_to_get

	if(!has_clan_permission(CLAN_PERMISSION_VIEW))
		return

	if(!clan_info)
		to_chat(src, SPAN_WARNING("You don't have a yautja whitelist!"))
		return

	if(clan_info.permissions & CLAN_PERMISSION_ADMIN_VIEW)
		var/list/datum/view_record/clan_view/CPV = DB_VIEW(/datum/view_record/clan_view/)

		var/clans = list()
		for(var/datum/view_record/clan_view/CV in CPV)
			clans += list("[CV.name]" = CV.clan_id)

		clans += list("People without clans" = null)

		var/input = tgui_input_list(src, "Choose the clan to view", "View clan", clans)

		if(!input)
			to_chat(src, SPAN_WARNING("Couldn't find any clans for you to view!"))
			return

		clan_to_get = clans[input]
	else if(clan_info.clan_id)

		var/options = list(
			"Your clan" = clan_info.clan_id,
			"People without clans" = null
		)

		var/input = tgui_input_list(src, "Choose the clan to view", "View clan", options)

		if(!input)
			return

		clan_to_get = options[input]
	else
		clan_to_get = null

	SSpredships.clan_ui.clan_id_by_user[mob] = clan_to_get

	SSpredships.clan_ui.tgui_interact(mob)

/client/proc/has_clan_permission(permission_flag, clan_id, warn)
	if(!clan_info)
		if(warn) to_chat(src, "You do not have a yautja whitelist!")
		return FALSE

	if(clan_id)
		if(clan_id != clan_info.clan_id)
			if(warn) to_chat(src, "You do not have permission to perform actions on this clan!")
			return FALSE


	if(!(clan_info.permissions & permission_flag))
		if(warn) to_chat(src, "You do not have the necessary permissions to perform this action!")
		return FALSE

	return TRUE

/client/proc/add_honor(number)
	if(!clan_info)
		return FALSE
	clan_info.sync()

	clan_info.honor = max(number + clan_info.honor, 0)
	clan_info.save()

	if(clan_info.clan_id)
		var/datum/entity/clan/target_clan = GET_CLAN(clan_info.clan_id)
		target_clan.sync()

		target_clan.honor = max(number + target_clan.honor, 0)

		target_clan.save()

	return TRUE
