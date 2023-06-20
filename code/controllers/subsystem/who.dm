SUBSYSTEM_DEF(who)
	name = "Who"
	flags = SS_NO_INIT|SS_BACKGROUND
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	wait = 5 SECONDS

	var/datum/player_list/who = new
	var/datum/player_list/staff/staff_who = new

/datum/controller/subsystem/who/fire(resumed = TRUE)
	who.update_data()
	staff_who.update_data()

//datum
/datum/player_list
	var/tgui_name = "Who"
	var/tgui_interface_name = "Who"
	var/list/mobs_ckey = list()
	var/list/list_data = list()

/datum/player_list/proc/update_data()
	var/list/new_list_data = list()
	mobs_ckey = list()
	new_list_data["additional_info"] = list()
	new_list_data["additional_info"]["observers"] = 0

	for(var/client/client in GLOB.clients)
		new_list_data["all_clients"]++
		var/list/client_payload = list()
		client_payload["ckey"] = "[client.key]"
		client_payload["ckey_color"] = client.player_data?.donator_info.patreon_function_available("ooc_color") ? "#D4AF37" : "white"
		var/mob/client_mob = client.mob
		mobs_ckey[client.key] = client_mob
		if(client_mob)
			if(istype(client_mob, /mob/new_player))
				client_payload["mob_type"] = "new_player"
				new_list_data["additional_info"]["lobby"]++
				new_list_data["total_players"] += list(client_payload)
				continue
			else
				client_payload["mob_name"] = "[client_mob.real_name]"

			if(isobserver(client_mob))
				client_payload["mob_type"] = "observer"
				if(CLIENT_IS_STAFF(client))
					new_list_data["additional_info"]["admin_observers"]++
				else
					new_list_data["additional_info"]["observers"]++

				var/mob/dead/observer/observer = client_mob
				if(observer.started_as_observer)
					client_payload["observer_state"] = "Spectating"
					client_payload["mob_state_color"] = "#808080"
				else
					client_payload["observer_state"] = "DEAD"
					client_payload["mob_state_color"] = "#A000D0"

			else
				client_payload["mob_type"] = "mob"
				client_payload["mob_state"] = "Alive"
				switch(client_mob.stat)
					if(UNCONSCIOUS)
						client_payload["mob_state"] = "Unconscious"
						client_payload["color_mob_state"] = "#B0B0B0"
					if(DEAD)
						client_payload["mob_state"] = "DEAD"
						client_payload["color_mob_state"] = "#A000D0"

				if(client_mob.stat != DEAD)
					if(isxeno(client_mob))
						client_payload["mob_type_name"] = "Xenomorph"
						client_payload["mob_state_color"] = "#f00"

					else if(ishuman(client_mob))
						if(client_mob.faction.faction_name == FACTION_ZOMBIE)
							client_payload["mob_type_name"] = "Zombie"
							client_payload["mob_state_color"] = "#2DACB1"
						else if(client_mob.faction.faction_name == FACTION_YAUTJA)
							client_payload["mob_type_name"] = "Yautja"
							client_payload["mob_state_color"] = "#7ABA19"
							new_list_data["additional_info"]["yautja"]++
							if(client_mob.status_flags & XENO_HOST)
								new_list_data["additional_info"]["infected_preds"]++
						else
							new_list_data["additional_info"]["humans"]++
							if(client_mob.status_flags & XENO_HOST)
								new_list_data["additional_info"]["infected_humans"]++
							if(client_mob.faction.faction_name == FACTION_MARINE)
								new_list_data["additional_info"]["uscm"]++
								if(client_mob.job in (ROLES_MARINES))
									new_list_data["additional_info"]["uscm_marines"]++

		new_list_data["total_players"] += list(client_payload)

	for(var/faction_to_get in FACTION_LIST_HUMANOID - FACTION_YAUTJA - FACTION_MARINE)
		var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
		if(!length(faction.totalMobs))
			continue
		new_list_data["factions"] += list(list(
			"color" = faction.color ? faction.color : "#2C7EFF",
			"name" = faction.name,
			"value" = length(faction.totalMobs)
		))

	for(var/faction_to_get in FACTION_LIST_XENOMORPH)
		var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
		if(!length(faction.totalMobs))
			continue
		new_list_data["xenomorphs"] += list(list(
			"color" = faction.color ? faction.color : "#8200FF",
			"queen" = "Queen: [faction.living_xeno_queen ? "Alive" : "Dead"]",
			"queen_color" = "#4D0096",
			"name" = faction.name,
			"value" = length(faction.totalMobs)
		))

	list_data = new_list_data

/datum/player_list/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_name, tgui_interface_name)
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/player_list/ui_data(mob/user)
	. = list_data

/datum/player_list/ui_static_data(mob/user)
	. = list()

	.["admin"] = CLIENT_IS_STAFF(user.client)

/datum/player_list/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("get_player_panel")
			admin_datums[usr.client.ckey].show_player_panel(mobs_ckey[params["ckey"]])

/datum/player_list/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE


/datum/player_list/staff
	tgui_name = "StaffWho"
	tgui_interface_name = "Staff Who"

/datum/player_list/staff/update_data()
	var/list/new_list_data = list()
	mobs_ckey = list()

	var/list/listings
	var/list/mappings
	if(CONFIG_GET(flag/show_manager))
		LAZYSET(mappings, "manager", R_HOST)
	if(CONFIG_GET(flag/show_devs))
		LAZYSET(mappings, "maintainer", R_PROFILER)
	LAZYSET(mappings, "administrator", R_ADMIN)
	if(CONFIG_GET(flag/show_mods))
		LAZYSET(mappings, "moderator", R_MOD && R_BAN)
	if(CONFIG_GET(flag/show_mentors))
		LAZYSET(mappings, "mentor", R_MENTOR)

	for(var/category in mappings)
		LAZYSET(listings, category, list())

	for(var/client/client in GLOB.admins)
		if(client.admin_holder?.fakekey && !CLIENT_IS_STAFF(client))
			continue

		for(var/category in mappings)
			if(CLIENT_HAS_RIGHTS(client, mappings[category]))
				LAZYADD(listings[category], client)
				break

	for(var/category in listings)
		new_list_data[category] = list() //Currently
		new_list_data[category]["total"] = length(listings[category])
		new_list_data[category]["admins"] = list()
		for(var/client/entry in listings[category])
			var/list/admin = list()
			var/rank = entry.admin_holder.rank
			if(entry.admin_holder.extra_titles?.len)
				for(var/srank in entry.admin_holder.extra_titles)
					rank += " & [srank]"

			admin["ckey"] = entry.key
			admin["rank"] = rank

			if(CLIENT_IS_STAFF(entry))
				if(entry.admin_holder?.fakekey)
					admin["hidden"] = "HIDDEN"

				if(istype(entry.mob, /mob/dead/observer))
					admin["state"] = "Spectating"
					admin["state_color"] = "#808080"
				else if(istype(entry.mob, /mob/new_player))
					admin["state"] = "in Lobby"
					admin["state_color"] = "#688944"
				else
					admin["state"] = "Playing"
					admin["state_color"] = "#688944"

				if(entry.is_afk())
					admin["afk"] = "AFK"
					admin["afk_color"] = "#A040D0"

			new_list_data[category]["admins"] += list(admin)

	list_data = new_list_data

/mob/verb/who()
	set category = "OOC"
	set name = "Who"

	SSwho.who.tgui_interact(src)

/mob/verb/staffwho()
	set category = "Admin"
	set name = "Staff Who"

	SSwho.staff_who.tgui_interact(src)
