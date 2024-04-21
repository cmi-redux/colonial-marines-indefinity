
//UPP COMMANDOS
/datum/emergency_call/upp_commando
	name = "UPP Commandos"
	mob_max = 6
	probability = 1
	objectives = "Stealthily assault the ship. Use your silenced weapons, tranquilizers, and night vision to get the advantage on the enemy. Take out the power systems, comms and engine. Stick together and keep a low profile."
	shuttle_id = "Distress_UPP"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_upp
	item_spawn = /obj/effect/landmark/ert_spawns/distress_upp/item
	hostility = TRUE
	assigned_squad = SQUAD_UPP_SOZ

/datum/emergency_call/upp_commando/print_backstory(mob/living/carbon/human/new_human)
	to_chat(new_human, SPAN_BOLD("You grew up in relativly simple family in [pick(75;"Eurasia", 25;"a famished UPP colony")] with few belongings or luxuries."))
	to_chat(new_human, SPAN_BOLD("The family you grew up with were [pick(50;"getting by", 25;"impoverished", 25;"starving")] and you were one of [pick(10;"two", 20;"three", 20;"four", 30;"five", 20;"six")] children."))
	to_chat(new_human, SPAN_BOLD("You come from a long line of [pick(40;"crop-harvesters", 20;"soldiers", 20;"factory workers", 5;"scientists", 15;"engineers")], and quickly enlisted to improve your living conditions."))
	to_chat(new_human, SPAN_BOLD("Following your enlistment UPP military at the age of 17 you were assigned to the 17th 'Smoldering Sons' battalion (six hundred strong) under the command of Colonel Ganbaatar."))
	to_chat(new_human, SPAN_BOLD("You were shipped off with the battalion to one of the UPP's most remote territories, a gas giant designated MV-35 in the Anglo-Japanese Arm, in the Neroid Sector."))
	to_chat(new_human, SPAN_BOLD("For the past 14 months, you and the rest of the Smoldering Sons have been stationed at MV-35's only facility, the helium refinery, Altai Station."))
	to_chat(new_human, SPAN_BOLD("As MV-35 and Altai Station are the only UPP-held zones in the Neroid Sector for many lightyears, you have spent most of your military career holed up in crammed quarters in near darkness, waiting for supply shipments and transport escort deployments."))
	to_chat(new_human, SPAN_BOLD("With the recent arrival of the enemy USCM battalion the 'Falling Falcons' and their flagship, the [MAIN_SHIP_NAME], the UPP has felt threatened in the sector."))
	to_chat(new_human, SPAN_BOLD("In an effort to protect the vunerable MV-35 from the emproaching UA/USCM imperialists, the leadership of your battalion has opted this the best opportunity to strike at the Falling Falcons to catch them off guard."))
	to_chat(new_human, SPAN_WARNING(FONT_SIZE_BIG("Glory to Colonel Ganbaatar.")))
	to_chat(new_human, SPAN_WARNING(FONT_SIZE_BIG("Glory to the Smoldering Sons.")))
	to_chat(new_human, SPAN_WARNING(FONT_SIZE_BIG("Glory to the UPP.")))
	to_chat(new_human, SPAN_NOTICE(" Use say :3 <text> to speak in your native tongue."))
	to_chat(new_human, SPAN_NOTICE(" This allows you to speak privately with your fellow UPP allies."))
	to_chat(new_human, SPAN_NOTICE(" Utilize it with your radio to prevent enemy radio interceptions."))

/datum/emergency_call/upp_commando/create_member(datum/mind/mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/new_human = new(spawn_loc)
	mind.transfer_to(new_human, TRUE)
	GLOB.ert_mobs += new_human

	if(!leader && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(new_human.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = new_human
		arm_equipment(new_human, /datum/equipment_preset/upp/commando/leader, TRUE, TRUE)
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Commando Team Leader of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
	else if(medics < max_medics && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(new_human.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Commando Medic of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(new_human, /datum/equipment_preset/upp/commando/medic, TRUE, TRUE)
	else
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Commando of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(new_human, /datum/equipment_preset/upp/commando, TRUE, TRUE)

	print_backstory(new_human)
	assigned_to_squads(new_human)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), new_human, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

