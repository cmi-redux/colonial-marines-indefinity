/datum/job/command/bridge
	title = JOB_SO
	total_positions = 4
	spawn_positions = 4
	allow_additional = TRUE
	scaled = FALSE
	flags_startup_parameters = NO_FLAGS
	gear_preset = /datum/equipment_preset/uscm_ship/so
	entry_message_body = "<a href='%WIKIPAGE%'>Your job is to monitor the Marines, man the CIC, and listen to your superior officers.</a> You are in charge of logistics and the overwatch system. You are also in line to take command after other eligible superior commissioned officers."

/datum/job/command/bridge/set_spawn_positions(count)
	spawn_positions = so_slot_formula(count)

/datum/job/command/bridge/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = so_slot_formula(get_total_population(FACTION_MARINE))
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/command/bridge/generate_entry_message(mob/living/carbon/human/H)
	return ..()

AddTimelock(/datum/job/command/bridge, list(
	JOB_SQUAD_LEADER = 1 HOURS,
	JOB_HUMAN_ROLES = 15 HOURS
))

/obj/effect/landmark/start/bridge
	name = JOB_SO
	icon_state = "so_spawn"
	job = /datum/job/command/bridge
