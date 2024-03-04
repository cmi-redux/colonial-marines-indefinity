/datum/job/uscm/squad/engineer
	title = JOB_SQUAD_ENGI
	total_positions = 12
	spawn_positions = 12
	allow_additional = TRUE
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/engineer
	entry_message_body = "You have the <a href='%WIKIURL%'>equipment and skill</a> to build fortifications, reroute power lines, and bunker down. Your squaddies will look to you when it comes to construction in the field of battle."
	balance_formulas = list("misc", BALANCE_FORMULA_ENGINEER, BALANCE_FORMULA_FIELD)

/datum/job/uscm/squad/engineer/get_total_positions(latejoin = FALSE)
	var/total_max
	for(var/datum/squad/squad in SSticker.role_authority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_MARINE && squad.name != "Root")
			total_max += squad.max_engineers
	return total_max

/datum/job/uscm/squad/engineer/whiskey
	title = JOB_WO_SQUAD_ENGINEER
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/engineer

/datum/job/uscm/squad/engineer/crash
	title = JOB_CRASH_SQUAD_ENGINEER
	total_positions = 3
	spawn_positions = 3
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/engineer

AddTimelock(/datum/job/uscm/squad/engineer, list(
	JOB_SQUAD_ROLES = 1 HOURS
))

/obj/effect/landmark/start/marine/engineer
	name = JOB_SQUAD_ENGI
	icon_state = "engi_spawn"
	job = /datum/job/uscm/squad/engineer

/obj/effect/landmark/start/marine/engineer/alpha
	icon_state = "engi_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/engineer/bravo
	icon_state = "engi_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/engineer/charlie
	icon_state = "engi_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/engineer/delta
	icon_state = "engi_spawn_delta"
	squad = SQUAD_MARINE_4
