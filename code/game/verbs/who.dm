/client/verb/who()//likely don't touch any... this is easy can die. (:troll_fale:)
	set name = "Who"
	set category = "OOC"

	var/list/counted_humanoids = list(
							"Observers" = 0,
							"Admin observers" = 0,
							"Humans" = 0,
							"Infected humans" = 0,
							FACTION_MARINE = 0,
							"USCM Marines" = 0,
							"Lobby" = 0,

							FACTION_YAUTJA = 0,
							"Infected preds" = 0,

							FACTION_PMC = 0,
							FACTION_CLF = 0,
							FACTION_UPP = 0,
							FACTION_FREELANCER = 0,
							FACTION_SURVIVOR = 0,
							FACTION_WY_DEATHSQUAD = 0,
							FACTION_COLONIST = 0,
							FACTION_MERCENARY = 0,
							FACTION_DUTCH = 0,
							FACTION_HEFA = 0,
							FACTION_GLADIATOR = 0,
							FACTION_PIRATE = 0,
							FACTION_PIZZA = 0,
							FACTION_SOUTO = 0,

							FACTION_NEUTRAL = 0,

							"Zombies" = 0
							)

	var/list/counted_xenos = list()

	var/players = length(GLOB.clients)

	var/dat = "<html><body><B>[auto_lang(LANGUAGE_WHO_PLAYERS)]:</B><BR>"
	var/list/Lines = list()
	if(admin_holder && ((R_ADMIN & admin_holder.rights) || (R_MOD & admin_holder.rights)))
		for(var/client/C in GLOB.clients)
			var/entry = C.donator_info.patreon_function_available("ooc_color") ? "<font color='#D4AF37'>[C.key]</font>" : "[C.key]"
			if(C.mob)
				if(istype(C.mob, /mob/new_player))
					entry += " - [auto_lang(LANGUAGE_WHO_LOBBY)]"
					counted_humanoids["Lobby"]++
				else
					entry += " - [auto_lang(LANGUAGE_WHO_PLAYING_AS)] [C.mob.real_name]"

				if(isobserver(C.mob))
					counted_humanoids["Observers"]++
					if(C.admin_holder?.rights & R_MOD)
						counted_humanoids["Admin observers"]++
						counted_humanoids["Observers"]--
					var/mob/dead/observer/O = C.mob
					if(O.started_as_observer)
						entry += " - <font color='#808080'>[auto_lang(LANGUAGE_WHO_SPECTATING)]</font>"
					else
						entry += " - <font color='#A000D0'><b>[auto_lang(LANGUAGE_WHO_DEAD)]</B></font>"
				else
					switch(C.mob.stat)
						if(UNCONSCIOUS)
							entry += " - <font color='#B0B0B0'><b>[auto_lang(LANGUAGE_WHO_UNCONSCIOUS)]</B></font>"
						if(DEAD)
							entry += " - <font color='#A000D0'><b>[auto_lang(LANGUAGE_WHO_DEAD)]</B></font>"

					if(C.mob && C.mob.stat != DEAD)
						if(ishuman(C.mob))
							var/mob/living/carbon/human/Z = C.mob
							if(!C.mob.faction)
								counted_humanoids["Observers"]++
							else if(Z.species.name == "Zombie")
								counted_humanoids["Zombies"]++
								entry += " - <font color='#2DACB1'><B>[auto_lang(LANGUAGE_WHO_ZOMBIE)]</B></font>"
							else if(C.mob.faction.faction_name == FACTION_YAUTJA)
								counted_humanoids[FACTION_YAUTJA]++
								entry += " - <font color='#7ABA19'><B>[auto_lang(LANGUAGE_WHO_YAUTJA)]</B></font>"
								if(C.mob.status_flags & XENO_HOST)
									counted_humanoids["Infected preds"]++
							else
								counted_humanoids["Humans"]++
								if(C.mob.status_flags & XENO_HOST)
									counted_humanoids["Infected humans"]++
								if(C.mob.faction.faction_name == FACTION_MARINE)
									counted_humanoids[FACTION_MARINE]++
									if(C.mob.job in (ROLES_MARINES))
										counted_humanoids["USCM Marines"]++
								else
									counted_humanoids[C.mob.faction]++
						else if(isxeno(C.mob))
							var/mob/living/carbon/xenomorph/xeno = C.mob
							counted_xenos[xeno.faction]++
							if(xeno.caste_type == "Predalien")
								counted_xenos["Predalien"]++
							entry += " - <B><font color='red'>[auto_lang(LANGUAGE_WHO_XENOMORPHS)]</font></B>"
				entry += " (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=\ref[C.mob]'>?</A>)"
				Lines += entry

		for(var/line in sortList(Lines))
			dat += "[line]<BR>"
		dat += "<B>[auto_lang(LANGUAGE_WHO_TOTAL_PLAYERS)]: [players]</B>"
		dat += "<BR><B style='color:#777'>[auto_lang(LANGUAGE_WHO_LOBBY)]: [counted_humanoids["Lobby"]]</B>"
		dat += "<BR><B style='color:#777'>[auto_lang(LANGUAGE_WHO_SPECTATATORS)]: [counted_humanoids["Observers"]] [auto_lang(LANGUAGE_WHO_PLAYERS_AND)] [counted_humanoids["Admin observers"]] [auto_lang(LANGUAGE_WHO_ADMINISTRATORS)]</B>"
		dat += "<BR><B style='color:#2C7EFF'>[auto_lang(LANGUAGE_WHO_HUMANS)]: [counted_humanoids["Humans"]]</B> <B style='color:#F00'>([auto_lang(LANGUAGE_WHO_INFECTED)]: [counted_humanoids["Infected humans"]])</B>"
		if(counted_humanoids[FACTION_MARINE])
			dat += "<BR><B style='color:#2C7EFF'>[auto_lang(LANGUAGE_WHO_USCM)]: [counted_humanoids[FACTION_MARINE]]</B> <B style='color:#688944'>([auto_lang(LANGUAGE_WHO_MARINES)]: [counted_humanoids["USCM Marines"]])</B>"
		if(counted_humanoids[FACTION_YAUTJA])
			dat += "<BR><B style='color:#7ABA19'>[auto_lang(LANGUAGE_WHO_YAUTJES)]: [counted_humanoids[FACTION_YAUTJA]]</B> [counted_humanoids["Infected preds"] ? "<b style='color:#F00'>([auto_lang(LANGUAGE_WHO_INFECTED)]: [counted_humanoids["Infected preds"]])</b>" : ""]"
		if(counted_humanoids["Zombies"])
			dat += "<BR><B style='color:#2DACB1'>[auto_lang(LANGUAGE_WHO_ZOMBIE)]: [counted_humanoids["Zombies"]]</B>"

		var/show_fact = TRUE
		for(var/i in 10 to length(counted_humanoids) - 2)
			if(counted_humanoids[counted_humanoids[i]])
				if(show_fact)
					dat += "<br><BR>[auto_lang(LANGUAGE_WHO_ANOTHER_FACTIONS)]:"
					show_fact = FALSE
				dat += "<BR><B style='color:[GLOB.faction_datum[counted_humanoids[i]].color ? GLOB.faction_datum[counted_humanoids[i]].color : "#2C7EFF"]'>[counted_humanoids[i]]: [counted_humanoids[counted_humanoids[i]]]</B>"
		if(counted_humanoids[FACTION_NEUTRAL])
			dat += "<BR><B style='color:#688944'>[FACTION_NEUTRAL]: [counted_humanoids[FACTION_NEUTRAL]]</B>"
		show_fact = TRUE
		for(var/datum/faction/faction in counted_xenos)
			// Print predalien counts last
			if(faction == "Predalien")
				continue
			if(show_fact)
				dat += "<BR><BR>[auto_lang(LANGUAGE_WHO_XENOMORPHS)]:"
				show_fact = FALSE
			if(faction)
				dat += "<BR><B style='color:[faction.color ? faction.color : "#8200FF"]'>[faction.name]: [counted_xenos[faction]]</B> <B style='color:#4D0096'>([auto_lang(LANGUAGE_WHO_QUEEN)]: [faction.living_xeno_queen ? auto_lang(LANGUAGE_WHO_QUEEN_ALIVE) : auto_lang(LANGUAGE_WHO_QUEEN_DEAD)])</B>"
			else
				dat += "<BR><B style='color:#F00'>[auto_lang(LANGUAGE_WHO_ERROR_TD)] [faction].</B>"
		if(counted_xenos["Predalien"])
			dat += "<BR><B style='color:#7ABA19'>[auto_lang(LANGUAGE_WHO_XENO_YAUTJES)]: [counted_xenos["Predalien"]]</B>"

	else
		for(var/client/C in GLOB.clients)
			if(C.admin_holder && C.admin_holder.fakekey)
				continue

			Lines += C.key
		for(var/line in sortList(Lines))
			dat += "[line]<br>"
		dat += "<b>[auto_lang(LANGUAGE_WHO_TOTAL_PLAYERS)]: [players]</b><br>"

	dat += "</body></html>"
	show_browser(usr, dat, auto_lang(LANGUAGE_WHO_POPULATION), "who", "size=600x800")


/client/verb/staffwho()
	set name = "Staffwho"
	set category = "Admin"

	var/dat = "<B>[auto_lang(LANGUAGE_WHO_ADMINISTRATION)]:</B><br>"
	var/list/mappings
	if(CONFIG_GET(flag/show_manager))
		LAZYSET(mappings, "<B style='color:purple'>[auto_lang(LANGUAGE_WHO_MANAGERS)]</B>", R_HOST)
	if(CONFIG_GET(flag/show_devs))
		LAZYSET(mappings, "<B style='color:blue'>[auto_lang(LANGUAGE_WHO_MAINTAINERS)]</B>", R_PROFILER)
	LAZYSET(mappings, "<B style='color:red'>[auto_lang(LANGUAGE_WHO_ADMINISTRATORS)]</B>", R_ADMIN)
	if(CONFIG_GET(flag/show_mods))
		LAZYSET(mappings, "<B style='color:orange'>[auto_lang(LANGUAGE_WHO_MODERATORS)]</B>", R_MOD && R_BAN)
	if(CONFIG_GET(flag/show_mentors))
		LAZYSET(mappings, "<B style='color:green'>[auto_lang(LANGUAGE_WHO_MENTORS)]</B>", R_MENTOR)

	var/list/listings
	for(var/category in mappings)
		LAZYSET(listings, category, list())

	for(var/client/C in GLOB.admins)
		if(C.admin_holder?.fakekey && !CLIENT_IS_STAFF(src))
			continue
		for(var/category in mappings)
			if(CLIENT_HAS_RIGHTS(C, mappings[category]))
				LAZYADD(listings[category], C)
				break

	for(var/category in listings)
		dat += "<BR><B>[auto_lang(LANGUAGE_WHO_CURRENTLY)] [category] ([length(listings[category])]):<BR></B>\n"
		for(var/client/entry in listings[category])
			dat += "\t[entry.key] [auto_lang(LANGUAGE_WHO_ADMIN_IS)] [entry.admin_holder.rank]"
			if(entry.admin_holder.extra_titles?.len)
				for(var/srank in entry.admin_holder.extra_titles)
					dat += " & [srank]"
			if(CLIENT_IS_STAFF(src))
				if(entry.admin_holder?.fakekey)
					dat += " <i>([auto_lang(LANGUAGE_WHO_HIDDEN)])</i>"
				if(istype(entry.mob, /mob/dead/observer))
					dat += "<B> - <font color='#808080'>[auto_lang(LANGUAGE_WHO_SPECTATING)]</font></B>"
				else if(istype(entry.mob, /mob/new_player))
					dat += "<B> - <font color='#FFFFFF'>[auto_lang(LANGUAGE_WHO_LOBBY)]</font></B>"
				else
					dat += "<B> - <font color='#688944'>[auto_lang(LANGUAGE_WHO_PLAYING)]</font></B>"
				if(entry.is_afk())
					dat += "<B> <font color='#A040D0'> ([auto_lang(LANGUAGE_WHO_AFK)])</font></B>"
			dat += "<BR>"
	dat += "</body></html>"
	show_browser(usr, dat, auto_lang(LANGUAGE_WHO_ADMIN_POPULATION), "staffwho", "size=600x800")
