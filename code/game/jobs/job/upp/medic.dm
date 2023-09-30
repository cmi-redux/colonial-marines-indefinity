/datum/job/upp/squad/medic
	title = JOB_UPP_MEDIC
	total_positions = 16
	spawn_positions = 16
	allow_additional = TRUE
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/upp/medic
	entry_message_body = "<a href='%WIKIURL%'>You tend the wounds of your squad mates</a> and make sure they are healthy and active. You may not be a fully-fledged doctor, but you stand between life and death when it matters."
	balance_formulas = list("misc", BALANCE_FORMULA_MEDIC, BALANCE_FORMULA_FIELD)

/datum/job/upp/squad/medic/set_spawn_positions(count)
	for(var/datum/squad/sq in SSticker.role_authority.squads)
		if(sq)
			sq.max_medics = medic_slot_formula(count)

/datum/job/upp/squad/medic/get_total_positions(latejoin = FALSE)
	var/slots = medic_slot_formula(get_total_population(FACTION_UPP))

	if(slots <= total_positions_so_far)
		slots = total_positions_so_far
	else
		total_positions_so_far = slots

	if(latejoin)
		for(var/datum/squad/sq in SSticker.role_authority.squads)
			if(sq)
				sq.max_medics = slots

	return (slots*4)

AddTimelock(/datum/job/upp/squad/medic, list(
	JOB_MEDIC_ROLES = 1 HOURS,
	JOB_SQUAD_ROLES = 1 HOURS
))

/obj/effect/landmark/start/upp/squad/medic
	name = JOB_UPP_MEDIC
	icon_state = "medic_spawn"
	job = /datum/job/upp/squad/medic

/obj/effect/landmark/start/upp/squad/medic/red_dragon
	icon_state = "medic_spawn_alpha"
	squad = SQUAD_UPP_1

/obj/effect/landmark/start/upp/squad/medic/sun_rise
	icon_state = "medic_spawn_bravo"
	squad = SQUAD_UPP_2

/obj/effect/landmark/start/upp/squad/medic/veiled_threat
	icon_state = "medic_spawn_charlie"
	squad = SQUAD_UPP_3

/obj/effect/landmark/start/upp/squad/medic/death_seekers
	icon_state = "medic_spawn_delta"
	squad = SQUAD_UPP_4
