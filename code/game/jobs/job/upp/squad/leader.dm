/datum/job/upp/squad/leader
	title = JOB_UPP_LEADER
	total_positions = 4
	spawn_positions = 4
	supervisors = "the acting commanding officer"
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/upp/leader
	entry_message_body = "<a href='%WIKIURL%'>You are responsible for the men and women of your squad.</a> Make sure they are on task, working together, and communicating. You are also in charge of communicating with command and letting them know about the situation first hand. Keep out of harm's way."
	balance_formulas = list(BALANCE_FORMULA_COMMANDING, BALANCE_FORMULA_MISC, BALANCE_FORMULA_FIELD)

/datum/job/upp/squad/leader/get_total_positions(count)
	var/total_max
	for(var/datum/squad/squad in SSticker.role_authority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_UPP && squad.name != "Root")
			total_max += squad.max_leaders
	return total_max

AddTimelock(/datum/job/upp/squad/leader, list(
	JOB_SQUAD_SUP_LIST = 3 HOURS,
	JOB_SQUAD_ROLES = 10 HOURS
))

/obj/effect/landmark/start/upp/squad/leader
	name = JOB_UPP_LEADER
	icon_state = "leader_spawn"
	job = /datum/job/upp/squad/leader

/obj/effect/landmark/start/upp/squad/leader/red_dragon
	icon_state = "leader_spawn_alpha"
	squad = SQUAD_UPP_1

/obj/effect/landmark/start/upp/squad/leader/sun_rise
	icon_state = "leader_spawn_bravo"
	squad = SQUAD_UPP_2

/obj/effect/landmark/start/upp/squad/leader/veiled_threat
	icon_state = "leader_spawn_charlie"
	squad = SQUAD_UPP_3

/obj/effect/landmark/start/upp/squad/leader/death_seekers
	icon_state = "leader_spawn_delta"
	squad = SQUAD_UPP_4
