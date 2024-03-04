/datum/job/upp/squad/conscript
	title = JOB_UPP_CONSCRIPT
	total_positions = 8
	spawn_positions = 8
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/upp/soldier
	entry_message_body = "You are a rank-and-file <a href='"+URL_WIKI_MARINE_QUICKSTART+"'>Marine of the UPP</a>, and that is your strength. What you lack alone, you gain standing shoulder to shoulder with the men and women of the corps. Ooh-rah!"

/datum/job/upp/squad/conscript/get_total_positions(count)
	var/total_max
	for(var/datum/squad/squad in SSticker.role_authority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_UPP && squad.name != "Root")
			total_max += squad.max_supports
	return total_max

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
