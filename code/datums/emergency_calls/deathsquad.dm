


//Weyland-Yutani Deathsquad - W-Y Deathsquad. Event only
/datum/emergency_call/death
	name = "Weyland Whiteout Operators"
	mob_max = 8
	mob_min = 5
	arrival_message = "'!`2*%slau#*jer t*h$em a!l%. le&*ve n(o^ w&*nes%6es.*v$e %#d ou^'"
	objectives = "Whiteout protocol is in effect for the target. Ensure there are no traces of the infestation or any witnesses."
	probability = 1
	shuttle_id = "Distress_PMC"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item
	max_medics = 1
	max_heavies = 2
	hostility = TRUE
	assigned_squad = SQUAD_WY_7


// DEATH SQUAD--------------------------------------------------------------------------------
/datum/emergency_call/death/create_member(datum/mind/mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/new_human = new(spawn_loc)
	mind.transfer_to(new_human, TRUE)
	GLOB.ert_mobs += new_human
	assigned_to_squads(new_human)

	if(!leader && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(new_human.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = new_human
		to_chat(new_human, SPAN_ROLE_HEADER("You are the Whiteout Team Leader!"))
		to_chat(new_human, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(new_human, /datum/equipment_preset/pmc/w_y_whiteout/leader, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(new_human.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Whiteout Team Medic!"))
		to_chat(new_human, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(new_human, /datum/equipment_preset/pmc/w_y_whiteout/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(new_human.client, list(JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN), time_required_for_job))
		heavies++
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Whiteout Team Terminator!"))
		to_chat(new_human, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(new_human, /datum/equipment_preset/pmc/w_y_whiteout/terminator, TRUE, TRUE)
	else
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Whiteout Team Operative!"))
		to_chat(new_human, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(new_human, /datum/equipment_preset/pmc/w_y_whiteout, TRUE, TRUE)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), new_human, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

//################################################################################################
// Marine commandos - USCM Deathsquad. Event only
/datum/emergency_call/marsoc
	name = "Marine Raider Strike Team"
	mob_max = 8
	mob_min = 5
	probability = 1
	shuttle_id = "Distress_USCM"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc

/datum/emergency_call/marsoc/create_member(datum/mind/mind, turf/override_spawn_loc)

	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/new_human = new(spawn_loc)
	mind.transfer_to(new_human, TRUE)
	GLOB.ert_mobs += new_human
	assigned_to_squads(new_human)

	if(!leader && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(new_human.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = new_human
		to_chat(new_human, SPAN_WARNING(FONT_SIZE_BIG("You are a Marine Raider Team Leader, better than all the rest.")))
		arm_equipment(new_human, /datum/equipment_preset/uscm/marsoc/sl, TRUE, TRUE)
	else
		to_chat(new_human, SPAN_WARNING(FONT_SIZE_BIG("You are an elite Marine Raider Operative, the best of the best.")))
		arm_equipment(new_human, /datum/equipment_preset/uscm/marsoc, TRUE, TRUE)
	to_chat(new_human, SPAN_BOLDNOTICE("You are absolutely loyal to High Command and must follow their directives."))
	to_chat(new_human, SPAN_BOLDNOTICE("Execute the mission assigned to you with extreme prejudice!"))
	return

/datum/emergency_call/marsoc_covert
	name = "Marine Raider Operatives (Covert)"
	mob_max = 8
	mob_min = 5
	probability = 1
	shuttle_id = "Distress_USCM"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc

/datum/emergency_call/marsoc_covert/create_member(datum/mind/mind)

	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/new_human = new(spawn_loc)
	mind.transfer_to(new_human, TRUE)
	GLOB.ert_mobs += new_human

	if(!leader && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(new_human.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = new_human
		to_chat(new_human, SPAN_WARNING(FONT_SIZE_BIG("You are a Marine Raider Team Leader, better than all the rest.")))
		arm_equipment(new_human, /datum/equipment_preset/uscm/marsoc/sl/covert, TRUE, TRUE)
	else
		to_chat(new_human, SPAN_WARNING(FONT_SIZE_BIG("You are an elite Marine Raider, the best of the best.")))
		arm_equipment(new_human, /datum/equipment_preset/uscm/marsoc/covert, TRUE, TRUE)
	to_chat(new_human, SPAN_BOLDNOTICE("You are absolutely loyal to High Command and must follow their directives."))
	to_chat(new_human, SPAN_BOLDNOTICE("Execute the mission assigned to you with extreme prejudice!"))
	return

/obj/effect/landmark/ert_spawns/distress_uscm
	name = "Distress_USCM"

/obj/effect/landmark/ert_spawns/distress_uscm/item
	name = "Distress_USCMItem"
