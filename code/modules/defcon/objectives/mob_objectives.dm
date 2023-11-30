// --------------------------------------------
// *** Recover the dead ***
// --------------------------------------------
/datum/cm_objective/recover_corpses
	name = "Recover corpses"
	objective_state = OBJECTIVE_ACTIVE
	/// List of list of active corpses per tech-faction ownership
	var/list/corpses = list()
	var/list/scored_corpses = list()

/datum/cm_objective/recover_corpses/New(faction_to_get)
	. = ..()

	RegisterSignal(SSdcs, list(
		COMSIG_GLOB_MARINE_DEATH,
		COMSIG_GLOB_XENO_DEATH
	), PROC_REF(handle_mob_deaths))

/datum/cm_objective/recover_corpses/Destroy()
	corpses = null
	. = ..()

/datum/cm_objective/recover_corpses/proc/generate_corpses(numCorpsesToSpawn)
	var/list/obj/effect/landmark/corpsespawner/objective_spawn_corpse = GLOB.corpse_spawns.Copy()
	while(numCorpsesToSpawn--)
		if(!length(objective_spawn_corpse))
			break
		var/obj/effect/landmark/corpsespawner/spawner = pick(objective_spawn_corpse)
		var/turf/spawnpoint = get_turf(spawner)
		if(spawnpoint)
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(spawnpoint)
			M.create_hud() //Need to generate hud before we can equip anything apparently...
			arm_equipment(M, spawner.equip_path, TRUE, FALSE)
			for(var/obj/structure/bed/nest/found_nest in spawnpoint)
				for(var/turf/the_turf in list(get_step(found_nest, NORTH),get_step(found_nest, EAST),get_step(found_nest, WEST)))
					if(the_turf.density)
						found_nest.dir = get_dir(found_nest, the_turf)
						found_nest.pixel_x = found_nest.buckling_x["[found_nest.dir]"]
						found_nest.pixel_y = found_nest.buckling_y["[found_nest.dir]"]
						M.dir = get_dir(the_turf,found_nest)
				if(!found_nest.buckled_mob)
					found_nest.do_buckle(M,M)
		objective_spawn_corpse.Remove(spawner)

/datum/cm_objective/recover_corpses/post_round_start()
	activate()

/datum/cm_objective/recover_corpses/proc/handle_mob_deaths(datum/source, mob/living/carbon/dead_mob, gibbed)
	SIGNAL_HANDLER

	if(!iscarbon(dead_mob))
		return

	// This mob has already been scored before
	if(LAZYISIN(scored_corpses, dead_mob))
		return

	LAZYDISTINCTADD(corpses, dead_mob)
	RegisterSignal(dead_mob, COMSIG_PARENT_QDELETING, PROC_REF(handle_corpse_deletion))
	RegisterSignal(dead_mob, COMSIG_LIVING_REJUVENATED, PROC_REF(handle_mob_revival))

	if(isxeno(dead_mob))
		RegisterSignal(dead_mob, COMSIG_XENO_REVIVED, PROC_REF(handle_mob_revival))
	else
		RegisterSignal(dead_mob, COMSIG_HUMAN_REVIVED, PROC_REF(handle_mob_revival))


/datum/cm_objective/recover_corpses/proc/handle_mob_revival(mob/living/carbon/revived_mob)
	SIGNAL_HANDLER

	UnregisterSignal(revived_mob, list(COMSIG_LIVING_REJUVENATED, COMSIG_PARENT_QDELETING))

	if(isxeno(revived_mob))
		UnregisterSignal(revived_mob, COMSIG_XENO_REVIVED)
	else
		UnregisterSignal(revived_mob, COMSIG_HUMAN_REVIVED)

	LAZYREMOVE(corpses, revived_mob)


/datum/cm_objective/recover_corpses/proc/handle_corpse_deletion(mob/living/carbon/deleted_mob)
	SIGNAL_HANDLER

	UnregisterSignal(deleted_mob, list(
		COMSIG_LIVING_REJUVENATED,
		COMSIG_PARENT_QDELETING
	))

	if(isxeno(deleted_mob))
		UnregisterSignal(deleted_mob, COMSIG_XENO_REVIVED)
	else
		UnregisterSignal(deleted_mob, COMSIG_HUMAN_REVIVED)

	LAZYREMOVE(corpses, deleted_mob)

/// Get score value for a given corpse
/datum/cm_objective/recover_corpses/proc/score_corpse(mob/target)
	var/cost_value = OBJECTIVE_LOW_VALUE

	if(isyautja(target))
		cost_value = OBJECTIVE_ABSOLUTE_VALUE

	else if(isxeno(target))
		var/mob/living/carbon/xenomorph/X = target
		switch(X.tier)
			if(1)
				if(ispredalien(X))
					cost_value = OBJECTIVE_ABSOLUTE_VALUE
				else
					cost_value = OBJECTIVE_LOW_VALUE
			if(2)
				cost_value = OBJECTIVE_MEDIUM_VALUE
			if(3)
				cost_value = OBJECTIVE_EXTREME_VALUE
			else
				if(isqueen(X)) //queen is Tier 0 for some reason...
					cost_value = OBJECTIVE_ABSOLUTE_VALUE

	else if(ishumansynth_strict(target))
		return OBJECTIVE_LOW_VALUE

	return cost_value

/datum/cm_objective/recover_corpses/process()

	for(var/mob/target as anything in corpses)
		if(QDELETED(target))
			LAZYREMOVE(corpses, target)
			continue

		// Add points depending on who controls it
		var/turf/T = get_turf(target)
		var/area/A = get_area(T)
		if(A.flags_area & AREA_RECOVER_CORPSES && A.faction_to_get == controller)
			value += score_corpse(target)
			SSfactions.statistics["corpses_recovered"]++
			SSfactions.statistics["corpses_total_points_earned"] = value

			LAZYREMOVE(corpses, target)
			LAZYDISTINCTADD(scored_corpses, target)

			if(isxeno(target))
				UnregisterSignal(target, COMSIG_XENO_REVIVED)
			else
				UnregisterSignal(target, COMSIG_HUMAN_REVIVED)

/datum/cm_objective/recover_corpses/get_point_value()
	return value

/datum/cm_objective/recover_corpses/total_point_value()
	var/total_value
	for(var/mob/target as anything in corpses)
		total_value += score_corpse(target)
	for(var/mob/target as anything in scored_corpses)
		total_value += score_corpse(target)
	return total_value


// --------------------------------------------
// *** Get a mob to an area/level ***
// --------------------------------------------
#define MOB_CAN_COMPLETE_AFTER_DEATH 1
#define MOB_FAILS_ON_DEATH 2

/datum/cm_objective/move_mob
	var/area/destination
	var/mob/living/target
	var/mob_can_die = MOB_CAN_COMPLETE_AFTER_DEATH
	controller = FACTION_MARINE


/datum/cm_objective/move_mob/New(faction_to_get, mob/living/survivor)
	if(istype(survivor, /mob/living))
		target = survivor
		RegisterSignal(survivor, COMSIG_MOB_DEATH, PROC_REF(handle_death))
		RegisterSignal(survivor, COMSIG_PARENT_QDELETING, PROC_REF(handle_corpse_deletion))
	activate()
	. = ..()

/datum/cm_objective/move_mob/Destroy()
	UnregisterSignal(target, list(
		COMSIG_MOB_DEATH,
		COMSIG_PARENT_QDELETING,
		COMSIG_LIVING_REJUVENATED,
	))
	if(isxeno(target))
		UnregisterSignal(target, COMSIG_XENO_REVIVED)
	else
		UnregisterSignal(target, COMSIG_HUMAN_REVIVED)
	destination = null
	target = null
	return ..()

/datum/cm_objective/move_mob/proc/handle_corpse_deletion(mob/living/carbon/deleted_mob)
	SIGNAL_HANDLER

	qdel(src)

/datum/cm_objective/move_mob/proc/handle_death(mob/living/carbon/dead_mob)
	SIGNAL_HANDLER

	if(mob_can_die == MOB_FAILS_ON_DEATH)
		deactivate()
		if(isxeno(dead_mob))
			RegisterSignal(dead_mob, COMSIG_XENO_REVIVED, PROC_REF(handle_mob_revival))
		else
			RegisterSignal(dead_mob, COMSIG_HUMAN_REVIVED, PROC_REF(handle_mob_revival))
		RegisterSignal(dead_mob, COMSIG_LIVING_REJUVENATED, PROC_REF(handle_mob_revival))

/datum/cm_objective/move_mob/proc/handle_mob_revival(mob/living/carbon/revived_mob)
	SIGNAL_HANDLER

	UnregisterSignal(revived_mob, list(COMSIG_LIVING_REJUVENATED))

	if(isxeno(revived_mob))
		UnregisterSignal(revived_mob, COMSIG_XENO_REVIVED)
	else
		UnregisterSignal(revived_mob, COMSIG_HUMAN_REVIVED)
	activate()

/datum/cm_objective/move_mob/check_completion()
	. = ..()
	if(istype(get_area(target), destination))
		if(target.stat != DEAD || mob_can_die & MOB_CAN_COMPLETE_AFTER_DEATH)
			complete()
			return TRUE

/datum/cm_objective/move_mob/complete()
	SSfactions.statistics["survivors_rescued"]++
	SSfactions.statistics["survivors_rescued_total_points_earned"] += value
	deactivate()

/datum/cm_objective/move_mob/almayer
	destination = /area/almayer

/datum/cm_objective/move_mob/almayer/survivor
	name = "Rescue the Survivor"
	mob_can_die = MOB_FAILS_ON_DEATH
	value = OBJECTIVE_EXTREME_VALUE

/datum/cm_objective/move_mob/almayer/vip
	name = "Rescue the VIP"
	mob_can_die = MOB_FAILS_ON_DEATH
	value = OBJECTIVE_ABSOLUTE_VALUE
