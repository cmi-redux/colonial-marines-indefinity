
//A gaggle of gladiators
/datum/emergency_call/pirates
	name = "Fun - Pirates"
	mob_max = 35
	mob_min = 10
	arrival_message = "'What shall we do with a drunken sailor? What shall we do with a drunken sailor? What shall we do with a drunken sailor early in the morning?'"
	objectives = "Pirate! Loot! Ransom!"
	probability = 1
	hostility = TRUE

/datum/emergency_call/pirates/create_member(datum/mind/mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/new_human = new(spawn_loc)
	mind.transfer_to(new_human, TRUE)
	GLOB.ert_mobs += new_human
	if(!leader && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(new_human.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = new_human
		arm_equipment(new_human, /datum/equipment_preset/fun/pirate/captain, TRUE, TRUE)
		to_chat(new_human, SPAN_ROLE_HEADER("You are the leader of these jolly pirates!"))
		to_chat(new_human, SPAN_ROLE_BODY("Loot this place for all its worth! Take everything of value that's not nailed down!"))
	else
		arm_equipment(new_human, /datum/equipment_preset/fun/pirate, TRUE, TRUE)
		to_chat(new_human, SPAN_ROLE_HEADER("You are a jolly pirate! Yarr!"))
		to_chat(new_human, SPAN_ROLE_BODY("Loot this place for all its worth! Take everything of value that's not nailed down!"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), new_human, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)
