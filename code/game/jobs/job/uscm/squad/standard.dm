/datum/job/uscm/squad/standard
	title = JOB_SQUAD_MARINE
	total_positions = -1
	spawn_positions = -1
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/pfc
	entry_message_body = "You are a rank-and-file <a href='"+URL_WIKI_MARINE_QUICKSTART+"'>Marine of the USCM</a>, and that is your strength. What you lack alone, you gain standing shoulder to shoulder with the men and women of the corps. Ooh-rah!"

/datum/job/uscm/squad/standard/set_spawn_positions(count)
	spawn_positions = max((round(count * STANDARD_MARINE_TO_TOTAL_SPAWN_RATIO)), 8)

/datum/job/uscm/squad/standard/whiskey
	title = JOB_WO_SQUAD_MARINE
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/pfc

/datum/job/uscm/squad/standard/crash
	title = JOB_CRASH_SQUAD_MARINE
	total_positions = 16
	spawn_positions = 16
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/pfc

/obj/effect/landmark/start/marine
	name = JOB_SQUAD_MARINE
	icon_state = "marine_spawn"
	job = /datum/job/uscm/squad/standard

/obj/effect/landmark/start/marine/alpha
	icon_state = "marine_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/bravo
	icon_state = "marine_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/charlie
	icon_state = "marine_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/delta
	icon_state = "marine_spawn_delta"
	squad = SQUAD_MARINE_4