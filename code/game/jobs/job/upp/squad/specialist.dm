/datum/job/upp/squad/specialist
	title = JOB_UPP_SPECIALIST
	total_positions = 4
	spawn_positions = 4
	allow_additional = TRUE
	scaled = TRUE
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/upp/specialist
	entry_message_body = "<a href='%WIKIURL%'>You are the very rare and valuable weapon expert</a>, trained to use special equipment. You can serve a variety of roles, so choose carefully."

/datum/job/upp/squad/specialist/get_total_positions(count)
	var/total_max
	for(var/datum/squad/squad in SSticker.role_authority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_UPP && squad.name != "Root")
			total_max += squad.max_specialists
	return total_max

AddTimelock(/datum/job/upp/squad/specialist, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/upp/squad/spec
	name = JOB_UPP_SPECIALIST
	icon_state = "spec_spawn"
	job = /datum/job/upp/squad/specialist

/obj/effect/landmark/start/upp/squad/spec/red_dragon
	icon_state = "spec_spawn_alpha"
	squad = SQUAD_UPP_1

/obj/effect/landmark/start/upp/squad/spec/sun_rise
	icon_state = "spec_spawn_bravo"
	squad = SQUAD_UPP_2

/obj/effect/landmark/start/upp/squad/spec/veiled_threat
	icon_state = "spec_spawn_charlie"
	squad = SQUAD_UPP_3

/obj/effect/landmark/start/upp/squad/spec/death_seekers
	icon_state = "spec_spawn_delta"
	squad = SQUAD_UPP_4
