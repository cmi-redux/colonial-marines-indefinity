/datum/job/uscm/squad/medic
	title = JOB_SQUAD_MEDIC
	total_positions = 16
	spawn_positions = 16
	allow_additional = TRUE
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/medic
	entry_message_body = "<a href='%WIKIPAGE%'>You tend the wounds of your squad mates</a> and make sure they are healthy and active. You may not be a fully-fledged doctor, but you stand between life and death when it matters."
	balance_formulas = list("misc", BALANCE_FORMULA_MEDIC, BALANCE_FORMULA_FIELD)


/datum/job/uscm/squad/medic/get_total_positions(latejoin = FALSE)
	var/total_max
	for(var/datum/squad/squad as anything in SSticker.role_authority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_MARINE && squad.name != "Root")
			total_max += squad.max_medics

	if(total_max > total_positions_so_far)
		total_positions_so_far = total_max

	spawn_positions = total_max

	return total_max

/datum/job/uscm/squad/medic/whiskey
	title = JOB_WO_SQUAD_MEDIC
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/medic

/datum/job/uscm/squad/medic/crash
	title = JOB_CRASH_SQUAD_MEDIC
	total_positions = 3
	spawn_positions = 3
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/medic

AddTimelock(/datum/job/uscm/squad/medic, list(
	JOB_MEDIC_ROLES = 1 HOURS,
	JOB_SQUAD_ROLES = 1 HOURS
))

/obj/effect/landmark/start/marine/medic
	name = JOB_SQUAD_MEDIC
	icon_state = "medic_spawn"
	job = /datum/job/uscm/squad/medic

/obj/effect/landmark/start/marine/medic/alpha
	icon_state = "medic_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/medic/bravo
	icon_state = "medic_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/medic/charlie
	icon_state = "medic_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/medic/delta
	icon_state = "medic_spawn_delta"
	squad = SQUAD_MARINE_4
