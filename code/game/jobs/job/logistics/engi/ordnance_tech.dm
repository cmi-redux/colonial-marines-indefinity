//Ordnance Technician
/datum/job/logistics/otech
	title = JOB_ORDNANCE_TECH
	total_positions = 3
	spawn_positions = 3
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "the chief engineer"
	selection_class = "job_ot"
	flags_startup_parameters = NO_FLAGS
	gear_preset = /datum/equipment_preset/uscm_ship/ordn
	entry_message_body = "<a href='%WIKIURL%'>Your job</a> is to maintain the integrity of the USCM weapons, munitions and equipment, including the orbital cannon. You can use the workshop in the portside hangar to construct new armaments for the marines. However you remain one of the more flexible roles on the ship and as such may receive other menial tasks from your superiors."

/datum/job/logistics/otech/set_spawn_positions(count)
	spawn_positions = ot_slot_formula(count)

/datum/job/logistics/otech/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = ot_slot_formula(get_total_population(FACTION_MARINE))
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

AddTimelock(/datum/job/logistics/otech, list(
	JOB_ENGINEER_ROLES = 1 HOURS
))

/obj/effect/landmark/start/otech
	name = JOB_ORDNANCE_TECH
	icon_state = "ot_spawn"
	job = /datum/job/logistics/otech
