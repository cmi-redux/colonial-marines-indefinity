/datum/job/upp/squad/conscript
	title = JOB_UPP_CONSCRIPT
	total_positions = 4
	spawn_positions = 4
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/upp/soldier
	entry_message_body = "You are a rank-and-file <a href='"+URL_WIKI_MARINE_QUICKSTART+"'>Marine of the USCM</a>, and that is your strength. What you lack alone, you gain standing shoulder to shoulder with the men and women of the corps. Ooh-rah!"

AddTimelock(/datum/job/upp/squad/leader, list(
	JOB_SQUAD_ROLES = 20 HOURS,
))

/obj/effect/landmark/start/upp/squad/conscript
	name = JOB_UPP_CONSCRIPT
	icon_state = "marine_spawn"
	job = /datum/job/upp/squad/conscript

/obj/effect/landmark/start/upp/squad/conscript/red_dragon
	icon_state = "marine_spawn_alpha"
	squad = SQUAD_UPP_1

/obj/effect/landmark/start/upp/squad/conscript/sun_rise
	icon_state = "marine_spawn_bravo"
	squad = SQUAD_UPP_2

/obj/effect/landmark/start/upp/squad/conscript/veiled_threat
	icon_state = "marine_spawn_charlie"
	squad = SQUAD_UPP_3

/obj/effect/landmark/start/upp/squad/conscript/death_seekers
	icon_state = "marine_spawn_delta"
	squad = SQUAD_UPP_4
