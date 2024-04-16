/datum/job/uscm/squad/specialist
	title = JOB_SQUAD_SPECIALIST
	total_positions = 4
	spawn_positions = 4
	allow_additional = TRUE
	scaled = TRUE
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/spec
	entry_message_body = "<a href='%WIKIPAGE%'>You are the very rare and valuable weapon expert</a>, trained to use special equipment. You can serve a variety of roles, so choose carefully."

/datum/job/uscm/squad/specialist/get_total_positions(latejoin = FALSE)
	var/total_max
	for(var/datum/squad/squad as anything in SSticker.role_authority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_MARINE && squad.name != "Root")
			total_max += squad.max_specialists
	return total_max

/datum/job/uscm/squad/specialist/whiskey
	title = JOB_WO_SQUAD_SPECIALIST
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/spec

/datum/job/uscm/squad/specialist/crash
	title = JOB_CRASH_SQUAD_SPECIALIST
	total_positions = 1
	spawn_positions = 1
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/spec

AddTimelock(/datum/job/uscm/squad/specialist, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/marine/spec
	name = JOB_SQUAD_SPECIALIST
	icon_state = "spec_spawn"
	job = /datum/job/uscm/squad/specialist

/obj/effect/landmark/start/marine/spec/alpha
	icon_state = "spec_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/spec/bravo
	icon_state = "spec_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/spec/charlie
	icon_state = "spec_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/spec/delta
	icon_state = "spec_spawn_delta"
	squad = SQUAD_MARINE_4
