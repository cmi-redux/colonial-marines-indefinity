SUBSYSTEM_DEF(predships)
	name		= "PredShips"
	init_order	= SS_INIT_PREDSHIPS
	flags		= SS_NO_FIRE

	var/datum/map_template/ship_template // Current ship template in use
	var/list/list/managed_z   // Maps initating clan id to list(datum/space_level, list/turf(spawns))
	var/list/turf/spawnpoints // List of all spawn landmark locations
	/* Note we map clan_id as string due to legacy code using them internally */

	var/datum/clan_ui/clan_ui = new

/datum/controller/subsystem/predships/Initialize(timeofday)
	if(!ship_template)
		ship_template = new /datum/map_template(HUNTERSHIPS_TEMPLATE_PATH, cache = TRUE)
	LAZYINITLIST(managed_z)
	load_new(CLAN_SHIP_PUBLIC)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/predships/proc/init_spawnpoint(obj/effect/landmark/clan_spawn/SP)
	LAZYADD(spawnpoints, get_turf(SP))

/datum/controller/subsystem/predships/proc/get_clan_spawnpoints(clan_id)
	RETURN_TYPE(/list/turf)
	if(isnum(clan_id))
		clan_id = "[clan_id]"
	if(clan_id in managed_z)
		return managed_z[clan_id][2]

/datum/controller/subsystem/predships/proc/is_clanship_loaded(clan_id)
	if(isnum(clan_id))
		clan_id = "[clan_id]"
	if((clan_id in managed_z) && managed_z[clan_id][2])
		return TRUE
	return FALSE

/datum/controller/subsystem/predships/proc/load_new(initiating_clan_id)
	RETURN_TYPE(/list)
	if(isnum(initiating_clan_id))
		initiating_clan_id = "[initiating_clan_id]"
	if(!ship_template || !initiating_clan_id)
		return NONE
	if(initiating_clan_id in managed_z)
		return managed_z[initiating_clan_id]
	var/datum/space_level/level = ship_template.load_new_z()
	if(level)
		var/new_z = level.z_value
		var/list/turf/new_spawns = list()
		for(var/turf/spawnpoint in spawnpoints)
			if(spawnpoint?.z == new_z)
				new_spawns += spawnpoint
		managed_z[initiating_clan_id] = list(level, new_spawns)
	return managed_z[initiating_clan_id]

/datum/clan_ui
	var/list/clan_id_by_user = list()

/datum/clan_ui/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ClanMenu", "Clan Menu")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/clan_ui/ui_data(mob/user)
	. = list()

	var/datum/entity/clan/C
	var/list/datum/view_record/clan_playerbase_view/CPV
	var/clan_to_get = clan_id_by_user[user]

	if(clan_to_get)
		C = GET_CLAN(clan_to_get)
		C.sync()
		CPV = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_EQUALS, clan_to_get))
	else
		CPV = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_IS, clan_to_get))

	var/player_rank = user.client.clan_info.clan_rank

	if(user.client.clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER)
		player_rank = 999 // Target anyone except other managers

	if(C)
		. += list(
			clan_id = C.id,
			clan_name = html_encode(C.name),
			clan_description = html_encode(C.description),
			clan_honor = C.honor,
			clan_keys = list(),

			player_rank_pos = player_rank,

			player_delete_clan = (user.client.clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER),
			player_sethonor_clan = (user.client.clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER),
			player_setcolor_clan = (user.client.clan_info.permissions & CLAN_PERMISSION_ADMIN_MODIFY),

			player_rename_clan = (user.client.clan_info.permissions & CLAN_PERMISSION_ADMIN_MODIFY),
			player_setdesc_clan = (user.client.clan_info.permissions & CLAN_PERMISSION_MODIFY),
			player_modify_ranks = (user.client.clan_info.permissions & CLAN_PERMISSION_MODIFY),

			player_purge = (user.client.clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER),
			player_move_clans = (user.client.clan_info.permissions & CLAN_PERMISSION_ADMIN_MOVE)
		)
	else
		. += list(
			clan_id = null,
			clan_name = "Players without a clan",
			clan_description = "This is a list of players without a clan",
			clan_honor = null,
			clan_keys = list(),

			player_rank_pos = player_rank,

			player_delete_clan = FALSE,
			player_sethonor_clan = FALSE,
			player_setcolor_clan = FALSE,

			player_rename_clan = FALSE,
			player_setdesc_clan = FALSE,
			player_modify_ranks = FALSE,

			player_purge = (user.client.clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER),
			player_move_clans = (user.client.clan_info.permissions & CLAN_PERMISSION_ADMIN_MOVE)
		)

	for(var/datum/view_record/clan_playerbase_view/CP in CPV)
		var/rank_to_give = CP.clan_rank

		if(CP.permissions & CLAN_PERMISSION_ADMIN_MANAGER)
			rank_to_give = 999

		.["clan_keys"] += list(list(
			player_id = CP.player_id,
			name = CP.ckey,
			rank = clan_ranks[CP.clan_rank], // rank_to_give not used here, because we need to get their visual rank, not their position
			rank_pos = rank_to_give,
			honor = CP.honor
		))

/datum/clan_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = usr

	if(!user.client.clan_info)
		return

	user.client.clan_info.sync() // Make sure permissions/clan is accurate

	switch(action)
		if(CLAN_ACTION_CLAN_RENAME)
			var/datum/entity/clan/target_clan = GET_CLAN(params["clan_id"])
			target_clan.sync()
			if(!user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY))
				return

			var/input = input(src, "Input the new name", "Set Name", target_clan.name) as text|null

			if(!input || input == target_clan.name)
				return

			target_clan.name = trim(input)
			target_clan.save()
			target_clan.sync()
			log_and_message_admins("[key_name_admin(src)] has set the name of [target_clan.name] to [input].")
			to_chat(src, SPAN_NOTICE("Set the name of [target_clan.name] to [input]."))

		if(CLAN_ACTION_CLAN_SETDESC)
			var/datum/entity/clan/target_clan = GET_CLAN(params["clan_id"])
			target_clan.sync()
			if(!user.client.has_clan_permission(CLAN_PERMISSION_USER_MODIFY))
				return

			var/input = input(usr, "Input a new description", "Set Description", target_clan.description) as message|null

			if(!input || input == target_clan.description)
				return

			target_clan.description = trim(input)
			target_clan.save()
			target_clan.sync()
			log_and_message_admins("[key_name_admin(src)] has set the description of [target_clan.name].")
			to_chat(src, SPAN_NOTICE("Set the description of [target_clan.name]."))

		if(CLAN_ACTION_CLAN_SETCOLOR)
			var/datum/entity/clan/target_clan = GET_CLAN(params["clan_id"])
			target_clan.sync()
			if(!user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY))
				return

			var/color = input(usr, "Input a new color", "Set Color", target_clan.color) as color|null

			if(!color)
				return

			target_clan.color = color
			target_clan.save()
			target_clan.sync()
			log_and_message_admins("[key_name_admin(src)] has set the color of [target_clan.name] to [color].")
			to_chat(src, SPAN_NOTICE("Set the name of [target_clan.name] to [color]."))

		if(CLAN_ACTION_CLAN_SETHONOR)
			var/datum/entity/clan/target_clan = GET_CLAN(params["clan_id"])
			target_clan.sync()
			if(!user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER))
				return

			var/input = tgui_input_number(src, "Input the new honor", "Set Honor", target_clan.honor)

			if((!input && input != 0) || input == target_clan.honor)
				return

			target_clan.honor = input
			target_clan.save()
			target_clan.sync()
			log_and_message_admins("[key_name_admin(src)] has set the honor of clan [target_clan.name] from [target_clan.honor] to [input].")
			to_chat(src, SPAN_NOTICE("Set the honor of [target_clan.name] from [target_clan.honor] to [input]."))

		if(CLAN_ACTION_CLAN_DELETE)
			var/datum/entity/clan/target_clan = GET_CLAN(params["clan_id"])
			target_clan.sync()
			if(!user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER))
				return

			var/input = input(src, "Please input the name of the clan to proceed.", "Delete Clan") as text|null

			if(input != target_clan.name)
				to_chat(src, "You have decided not to delete [target_clan.name].")
				return

			log_and_message_admins("[key_name_admin(src)] has deleted the clan [target_clan.name].")
			to_chat(src, SPAN_NOTICE("You have deleted [target_clan.name]."))
			var/list/datum/view_record/clan_playerbase_view/CPV = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_EQUALS, target_clan.id))

			for(var/datum/view_record/clan_playerbase_view/CP in CPV)
				var/datum/entity/clan_player/pl = DB_EKEY(/datum/entity/clan_player/, CP.player_id)
				pl.sync()

				pl.clan_id = null
				pl.permissions = clan_ranks[CLAN_RANK_UNBLOODED].permissions
				pl.clan_rank = clan_ranks_ordered[CLAN_RANK_UNBLOODED]

				pl.save()

			target_clan.delete()

		if(CLAN_ACTION_PLAYER_PURGE)
			var/datum/entity/clan_player/target = GET_CLAN_PLAYER(params["player_id"])
			target.sync()

			var/datum/entity/player/P = DB_ENTITY(/datum/entity/player, target.player_id)
			P.sync()

			var/player_name = P.ckey

			var/player_rank = user.client.clan_info.clan_rank

			if(user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER, warn = FALSE))
				player_rank = 999

			if((target.permissions & CLAN_PERMISSION_ADMIN_MANAGER) || player_rank <= target.clan_rank)
				to_chat(src, SPAN_DANGER("You can't target this person!"))
				return

			if(!user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER))
				return

			var/input = input(src, "Are you sure you want to purge this person? Type '[player_name]' to purge", "Confirm Purge") as text|null

			if(!input || input != player_name)
				return

			log_and_message_admins("[key_name_admin(src)] has purged [player_name]'s clan profile.")
			to_chat(src, SPAN_NOTICE("You have purged [player_name]'s clan profile."))

			target.delete()

			if(P.owning_client)
				P.owning_client.clan_info = null

		if(CLAN_ACTION_PLAYER_MOVECLAN)
			var/datum/entity/clan_player/target = GET_CLAN_PLAYER(params["player_id"])
			target.sync()

			var/datum/entity/player/P = DB_ENTITY(/datum/entity/player, target.player_id)
			P.sync()

			var/player_name = P.ckey

			var/player_rank = user.client.clan_info.clan_rank

			if(user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER, warn = FALSE))
				player_rank = 999

			if((target.permissions & CLAN_PERMISSION_ADMIN_MANAGER) || player_rank <= target.clan_rank)
				to_chat(src, SPAN_DANGER("You can't target this person!"))
				return

			if(!user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MOVE))
				return

			var/is_clan_manager = user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER, warn = FALSE)
			var/list/datum/view_record/clan_view/CPV = DB_VIEW(/datum/view_record/clan_view/)

			var/list/clans = list()
			for(var/datum/view_record/clan_view/CV in CPV)
				clans += list("[CV.name]" = CV.clan_id)

			if(is_clan_manager && clans.len >= 1)
				if(target.permissions & CLAN_PERMISSION_ADMIN_ANCIENT)
					clans += list("Remove from Ancient")
				else
					clans += list("Make Ancient")

			if(target.clan_id)
				clans += list("Remove from clan")

			var/input = tgui_input_list(src, "Choose the clan to put them in", "Change player's clan", clans)
			if(!input)
				return

			if(input == "Remove from clan" && target.clan_id)
				target.clan_id = null
				target.clan_rank = clan_ranks_ordered[CLAN_RANK_YOUNG]
				to_chat(src, SPAN_NOTICE("Removed [player_name] from their clan."))
				log_and_message_admins("[key_name_admin(src)] has removed [player_name] from their current clan.")
			else if(input == "Remove from Ancient")
				target.clan_rank = clan_ranks_ordered[CLAN_RANK_YOUNG]
				target.permissions = clan_ranks[CLAN_RANK_YOUNG].permissions
				to_chat(src, SPAN_NOTICE("Removed [player_name] from ancient."))
				log_and_message_admins("[key_name_admin(src)] has removed [player_name] from ancient.")
			else if(input == "Make Ancient" && is_clan_manager)
				target.clan_rank = clan_ranks_ordered[CLAN_RANK_ADMIN]
				target.permissions = CLAN_PERMISSION_ADMIN_ANCIENT
				to_chat(src, SPAN_NOTICE("Made [player_name] an ancient."))
				log_and_message_admins("[key_name_admin(src)] has made [player_name] an ancient.")
			else
				to_chat(src, SPAN_NOTICE("Moved [player_name] to [input]."))
				log_and_message_admins("[key_name_admin(src)] has moved [player_name] to clan [input].")

				target.clan_id = clans[input]

				if(!(target.permissions & CLAN_PERMISSION_ADMIN_ANCIENT))
					target.permissions = clan_ranks[CLAN_RANK_BLOODED].permissions
					target.clan_rank = clan_ranks_ordered[CLAN_RANK_BLOODED]

			target.save()
			target.sync()

		if(CLAN_ACTION_PLAYER_MODIFYRANK)
			var/datum/entity/clan_player/target = GET_CLAN_PLAYER(params["player_id"])
			target.sync()

			var/datum/entity/player/P = DB_ENTITY(/datum/entity/player, target.player_id)
			P.sync()

			var/player_name = P.ckey

			var/player_rank = user.client.clan_info.clan_rank

			if(user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER, warn = FALSE))
				player_rank = 999

			if((target.permissions & CLAN_PERMISSION_ADMIN_MANAGER) || player_rank <= target.clan_rank)
				to_chat(src, SPAN_DANGER("You can't target this person!"))
				return

			if(!target.clan_id)
				to_chat(src, SPAN_WARNING("This player doesn't belong to a clan!"))
				return

			var/list/datum/rank/ranks = clan_ranks.Copy()
			ranks -= CLAN_RANK_ADMIN // Admin rank should not and cannot be obtained from here

			var/datum/rank/chosen_rank
			if(user.client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY, warn = FALSE))
				var/input = tgui_input_list(src, "Select the rank to change this user to.", "Select Rank", ranks)
				if(!input)
					return

				chosen_rank = ranks[input]

			else if(user.client.has_clan_permission(CLAN_PERMISSION_USER_MODIFY, target.clan_id))
				for(var/rank in ranks)
					if(!user.client.has_clan_permission(ranks[rank].permission_required, warn = FALSE))
						ranks -= rank

				var/input = tgui_input_list(src, "Select the rank to change this user to.", "Select Rank", ranks)

				if(!input)
					return

				chosen_rank = ranks[input]

				if(chosen_rank.limit_type)
					var/list/datum/view_record/clan_playerbase_view/CPV = DB_VIEW(/datum/view_record/clan_playerbase_view/, DB_AND(DB_COMP("clan_id", DB_EQUALS, target.clan_id), DB_COMP("rank", DB_EQUALS, clan_ranks_ordered[input])))
					var/players_in_rank = CPV.len

					switch(chosen_rank.limit_type)
						if(CLAN_LIMIT_NUMBER)
							if(players_in_rank >= chosen_rank.limit)
								to_chat(src, SPAN_DANGER("This slot is full! (Maximum of [chosen_rank.limit] slots)"))
								return

						if(CLAN_LIMIT_SIZE)
							var/list/datum/view_record/clan_playerbase_view/clan_players = DB_VIEW(/datum/view_record/clan_playerbase_view/, DB_COMP("clan_id", DB_EQUALS, target.clan_id))
							var/available_slots = Ceiling(clan_players.len / chosen_rank.limit)

							if(players_in_rank >= available_slots)
								to_chat(src, SPAN_DANGER("This slot is full! (Maximum of [chosen_rank.limit] per player in the clan, currently [available_slots])"))
								return

			else
				return // Doesn't have permission to do this

			if(!user.client.has_clan_permission(chosen_rank.permission_required)) // Double check
				return

			target.clan_rank = clan_ranks_ordered[chosen_rank.name]
			target.permissions = chosen_rank.permissions
			target.save()
			target.sync()
			log_and_message_admins("[key_name_admin(src)] has set the rank of [player_name] to [chosen_rank.name] for their clan.")
			to_chat(src, SPAN_NOTICE("Set [player_name]'s rank to [chosen_rank.name]"))

/datum/clan_ui/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE
