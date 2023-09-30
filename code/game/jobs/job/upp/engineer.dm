/datum/job/upp/squad/engineer
	title = JOB_UPP_ENGI
	total_positions = 12
	spawn_positions = 12
	allow_additional = TRUE
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/upp/sapper
	entry_message_body = "You have the <a href='%WIKIURL%'>equipment and skill</a> to build fortifications, reroute power lines, and bunker down. Your squaddies will look to you when it comes to construction in the field of battle."
	balance_formulas = list("misc", BALANCE_FORMULA_ENGINEER, BALANCE_FORMULA_FIELD)

/datum/job/upp/squad/engineer/set_spawn_positions(count)
	for(var/datum/squad/sq in SSticker.role_authority.squads)
		if(sq)
			sq.max_engineers = engi_slot_formula(count)

/datum/job/upp/squad/engineer/get_total_positions(latejoin = FALSE)
	var/slots = engi_slot_formula(get_total_population(FACTION_UPP))

	if(slots <= total_positions_so_far)
		slots = total_positions_so_far
	else
		total_positions_so_far = slots

	if(latejoin)
		for(var/datum/squad/sq in SSticker.role_authority.squads)
			if(sq)
				sq.max_engineers = slots

	return (slots*4)

AddTimelock(/datum/job/upp/squad/engineer, list(
	JOB_SQUAD_ROLES = 1 HOURS
))

/obj/effect/landmark/start/upp/squad/engineer
	name = JOB_UPP_ENGI
	icon_state = "engi_spawn"
	job = /datum/job/upp/squad/engineer

/obj/effect/landmark/start/upp/squad/engineer/red_dragon
	icon_state = "engi_spawn_alpha"
	squad = SQUAD_UPP_1

/obj/effect/landmark/start/upp/squad/engineer/sun_rise
	icon_state = "engi_spawn_bravo"
	squad = SQUAD_UPP_2

/obj/effect/landmark/start/upp/squad/engineer/veiled_threat
	icon_state = "engi_spawn_charlie"
	squad = SQUAD_UPP_3

/obj/effect/landmark/start/upp/squad/engineer/death_seekers
	icon_state = "engi_spawn_delta"
	squad = SQUAD_UPP_4
