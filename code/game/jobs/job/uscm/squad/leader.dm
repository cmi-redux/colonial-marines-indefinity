/datum/job/uscm/squad/leader
	title = JOB_SQUAD_LEADER
	total_positions = 4
	spawn_positions = 4
	supervisors = "the acting commanding officer"
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/leader
	entry_message_body = "<a href='%WIKIPAGE%'>You are responsible for the men and women of your squad.</a> Make sure they are on task, working together, and communicating. You are also in charge of communicating with command and letting them know about the situation first hand. Keep out of harm's way."
	balance_formulas = list(BALANCE_FORMULA_COMMANDING, BALANCE_FORMULA_MISC, BALANCE_FORMULA_FIELD)

/datum/job/uscm/squad/leader/get_total_positions(latejoin = FALSE)
	var/total_max
	for(var/datum/squad/squad in SSticker.role_authority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_MARINE && squad.name != "Root")
			total_max += squad.max_leaders
	return total_max

/datum/job/uscm/squad/leader/whiskey
	title = JOB_WO_SQUAD_LEADER
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/sl

/datum/job/uscm/squad/leader/crash
	title = JOB_CRASH_SQUAD_LEADER
	total_positions = 1
	spawn_positions = 1
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/sl

AddTimelock(/datum/job/uscm/squad/leader, list(
	JOB_SQUAD_ROLES = 10 HOURS
))

/obj/effect/landmark/start/marine/leader
	name = JOB_SQUAD_LEADER
	icon_state = "leader_spawn"
	job = /datum/job/uscm/squad/leader

/obj/effect/landmark/start/marine/leader/alpha
	icon_state = "leader_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/leader/bravo
	icon_state = "leader_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/leader/charlie
	icon_state = "leader_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/leader/delta
	icon_state = "leader_spawn_delta"
	squad = SQUAD_MARINE_4
