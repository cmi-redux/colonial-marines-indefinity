

//Colonial Liberation Front
/datum/emergency_call/clf
	name = "Colonial Liberation Front (Squad)"
	mob_max = 10
	arrival_message = "'Attention, you are tresspassing on our soverign territory. Expect no forgiveness.'"
	objectives = "Assault the USCM, and sabotage as much as you can. Ensure any survivors escape in your custody."
	probability = 20
	hostility = TRUE
	assigned_squad = SQUAD_CLF_5
	var/max_synths = 1
	var/synths = 0

/datum/emergency_call/clf/print_backstory(mob/living/carbon/human/new_human)
	if(ishuman_strict(new_human))
		var/message = "[pick(5;"on the UA prison station", 10;"in the LV-624 jungle", 25;"on the farms of LV-771", 25;"in the slums of LV-221", 20;"the red wastes of LV-361", 15;"the icy tundra of LV-571")] to a [pick(50;"poor", 15;"well-off", 35;"average")] family."
		var/message_grew = "[pick(20;"the Dust Raiders killed someone close to you in 2181", 20;"you harbor a strong hatred of the United Americas", 10;"you are a wanted criminal in the United Americas", 5;"have UPP sympathies and want to see the UA driven out of the secor", 10;"you believe the USCM occupation will hurt your quality of life", 5;"are a violent person and want to kill someone for the sake of killing", 20;"want the Neroid Sector to be free from outsiders", 10;"your militia was absorbed into the CLF")]"
		to_chat(new_human, SPAN_BOLD("As a native of the Neroid Sector, you joined the CLF because [message_grew]."))
		to_chat(new_human, SPAN_BOLD("You grew up [message] and are considered a terrorist by the UA."))
	else
		to_chat(new_human, SPAN_BOLD("You were brought online in an underground CLF workshop, reprogrammed to serve the CLF and fight for their freedom."))
		to_chat(new_human, SPAN_BOLD("Originally, you were programmed with medical and engineering knowledge to assist with building and maintaining colonies."))
		to_chat(new_human, SPAN_BOLD("However, the hackers managed to load combat protocols and install a new directive: Irrational hatred for everything USCM."))

	to_chat(new_human, SPAN_BOLD("The Neroid Sector has largely enjoyed its independence."))
	to_chat(new_human, SPAN_BOLD("Though technically part of the United American frontier, many colonists in the Neroid Sector have enjoyed their freedoms."))
	to_chat(new_human, SPAN_BOLD("In 2172, however, the United Americas moved the USCM Battalion, the 'Dust Raiders', and the battalion flagship, the USS Alistoun, to the Neroid Sector."))
	to_chat(new_human, SPAN_BOLD("The Dust Raiders responded with deadly force, scattering many of the colonists who attempted to fight their occupation."))
	to_chat(new_human, SPAN_BOLD("The Dust Raiders and their flagship, the USS Alistoun eventually withdrew from the sector by the end of the year.</font>"))
	to_chat(new_human, SPAN_BOLD("With the Neroid Sector existing in relative isolation from United America oversight for the last five years, many colonists have considered themselves free from governmental rule."))
	to_chat(new_human, SPAN_BOLD("The year is now [GLOB.game_year]."))
	to_chat(new_human, SPAN_BOLD("The arrival of the USCM Battalion, the Falling Falcons, and their flagship, the [MAIN_SHIP_NAME], have reaffirmed that the United Americas considers the Neroid Sector part of their holdings."))
	to_chat(new_human, SPAN_BOLD("It is up to you and your fellow colonists to make them realize their trespasses. This sector is no longer theirs."))

/datum/emergency_call/clf/create_member(datum/mind/mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/new_human = new(spawn_loc)
	mind.transfer_to(new_human, TRUE)
	GLOB.ert_mobs += new_human

	if(!leader && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(new_human.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = new_human
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Cell Leader of the local resistance group, the Colonial Liberation Front!"))
		arm_equipment(new_human, /datum/equipment_preset/clf/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_SYNTH) && new_human.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Multi-Purpose Synthetic for the local resistance group, the Colonial Liberation Front!"))
		arm_equipment(new_human, /datum/equipment_preset/clf/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(new_human.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Medic of the local resistance group, the Colonial Liberation Front!"))
		arm_equipment(new_human, /datum/equipment_preset/clf/medic, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(new_human.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		to_chat(new_human, SPAN_ROLE_HEADER("You are an Engineer of the local resistance group, the Colonial Liberation Front!"))
		arm_equipment(new_human, /datum/equipment_preset/clf/engineer, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(new_human.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(new_human.client, JOB_SQUAD_SPECIALIST, time_required_for_job))
		heavies++
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Specialist of the local resistance group, the Colonial Liberation Front!"))
		arm_equipment(new_human, /datum/equipment_preset/clf/specialist, TRUE, TRUE)
	else
		to_chat(new_human, SPAN_ROLE_HEADER("You are a Fighter of the local resistance group, the Colonial Liberation Front!"))
		arm_equipment(new_human, /datum/equipment_preset/clf/soldier, TRUE, TRUE)

	print_backstory(new_human)
	assigned_to_squads(new_human)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), new_human, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)


/datum/emergency_call/clf/platoon
	name = "Colonial Liberation Front (Platoon)"
	mob_min = 8
	mob_max = 35
	probability = 1
	max_engineers = 2
	max_medics = 2
	max_heavies = 2
	max_synths = 1
