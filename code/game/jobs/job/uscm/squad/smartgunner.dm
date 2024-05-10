/datum/job/uscm/squad/smartgunner
	title = JOB_SQUAD_SMARTGUN
	total_positions = 4
	spawn_positions = 4
	allow_additional = TRUE
	scaled = TRUE
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/sg
	entry_message_body = "<a href='%WIKIPAGE%'>You are the smartgunner.</a> Your task is to provide heavy weapons support."

/datum/job/uscm/squad/smartgunner/get_total_positions(latejoin = FALSE)
	var/total_max
	for(var/datum/squad/squad as anything in SSticker.role_authority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_MARINE && squad.name != "Root")
			total_max += squad.max_main_supports
	return total_max

/datum/job/uscm/squad/smartgunner/whiskey
	title = JOB_WO_SQUAD_SMARTGUNNER
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/sg

/datum/job/uscm/squad/smartgunner/crash
	title = JOB_CRASH_SQUAD_SMARTGUNNER
	total_positions = 1
	spawn_positions = 1
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/sg

AddTimelock(/datum/job/uscm/squad/smartgunner, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/marine/smartgunner
	name = JOB_SQUAD_SMARTGUN
	icon_state = "smartgunner_spawn"
	job = /datum/job/uscm/squad/smartgunner

/obj/effect/landmark/start/marine/smartgunner/alpha
	icon_state = "smartgunner_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/smartgunner/bravo
	icon_state = "smartgunner_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/smartgunner/charlie
	icon_state = "smartgunner_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/smartgunner/delta
	icon_state = "smartgunner_spawn_delta"
	squad = SQUAD_MARINE_4
