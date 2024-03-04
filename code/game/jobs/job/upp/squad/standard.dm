/datum/job/upp/squad/standard
	title = JOB_UPP
	total_positions = -1
	spawn_positions = -1
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/upp/soldier
	entry_message_body = "You are a rank-and-file <a href='"+URL_WIKI_MARINE_QUICKSTART+"'>Marine of the USCM</a>, and that is your strength. What you lack alone, you gain standing shoulder to shoulder with the men and women of the corps. Ooh-rah!"

/datum/job/upp/squad/standard/set_spawn_positions(count)
	spawn_positions = max((round(count * STANDARD_MARINE_TO_TOTAL_SPAWN_RATIO)), 8)

/obj/effect/landmark/start/upp/squad
	name = JOB_UPP
	icon_state = "marine_spawn"
	job = /datum/job/upp/squad/standard

/obj/effect/landmark/start/upp/squad/red_dragon
	icon_state = "marine_spawn_alpha"
	squad = SQUAD_UPP_1

/obj/effect/landmark/start/upp/squad/sun_rise
	icon_state = "marine_spawn_bravo"
	squad = SQUAD_UPP_2

/obj/effect/landmark/start/upp/squad/veiled_threat
	icon_state = "marine_spawn_charlie"
	squad = SQUAD_UPP_3

/obj/effect/landmark/start/upp/squad/death_seekers
	icon_state = "marine_spawn_delta"
	squad = SQUAD_UPP_4
