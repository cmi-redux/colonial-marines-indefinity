/datum/job/command/tank_crew
	title = JOB_CREWMAN
	total_positions = 2
	spawn_positions = 2
	scaled = FALSE
	flags_startup_parameters = NO_FLAGS
	gear_preset = /datum/equipment_preset/uscm/tank
	entry_message_body = "<a href='%WIKIURL%'>Your job is to operate and maintain the ship's armored vehicles.</a> You are in charge of representing the armored presence amongst the marines during the operation, as well as maintaining and repairing your own vehicles."
	balance_formulas = list(BALANCE_FORMULA_COMMANDING, BALANCE_FORMULA_MISC, BALANCE_FORMULA_FIELD)

AddTimelock(/datum/job/command/tank_crew, list(
	JOB_SQUAD_ROLES = 10 HOURS,
	JOB_ENGINEER_ROLES = 5 HOURS
))

/obj/effect/landmark/start/tank_crew
	name = JOB_CREWMAN
	job = /datum/job/command/tank_crew
