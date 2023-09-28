///Footstep component. Plays footsteps at parents location when it is appropriate.
/datum/component/footstep
	///How many steps the parent has taken since the last time a footstep was played.
	var/steps = 0
	///volume determines the extra volume of the footstep. This is multiplied by the base volume, should there be one.
	var/volume
	///e_range stands for extra range - aka how far the sound can be heard. This is added to the base value and ignored if there isn't a base value.
	var/e_range
	///footstep_type is a define which determines what kind of sounds should get chosen.
	var/footstep_type
	///This can be a list OR a soundfile OR null. Determines whatever sound gets played.
	var/footstep_sounds
	var/drag_sounds

/datum/component/footstep/Initialize(footstep_type_ = FOOTSTEP_MOB_BAREFOOT, volume_ = 0.5, e_range_ = 3, drag_sounds_ = 'sound/effects/alien_dragsound_large.ogg')
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	volume = volume_
	e_range = e_range_
	footstep_type = footstep_type_
	drag_sounds = drag_sounds_
	switch(footstep_type)
		if(FOOTSTEP_MOB_HUMAN)
			if(!ishuman(parent))
				return COMPONENT_INCOMPATIBLE
			RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), PROC_REF(play_humanstep))
			return
		if(FOOTSTEP_MOB_SHOE)
			footstep_sounds = GLOB.shoefootstep
		if(FOOTSTEP_MOB_BAREFOOT)
			footstep_sounds = GLOB.barefootstep
		if(FOOTSTEP_XENO_MEDIUM)
			footstep_sounds = GLOB.xenomediumstep
		if(FOOTSTEP_XENO_HEAVY)
			footstep_sounds = GLOB.xenoheavystep
	RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), PROC_REF(play_simplestep)) //Note that this doesn't get called for humans.

///Prepares a footstep. Determines if it should get played. Returns the turf it should get played on. Note that it is always a /turf/open
/datum/component/footstep/proc/prepare_step()
	var/turf/open/T = get_turf(parent)
	if(!istype(T))
		return

	var/mob/living/LM = parent
	if(LM.buckled || LM.throwing || LM.is_ventcrawling || LM.stat == DEAD)
		return

	steps++

	if(steps % 2)
		return
	return T

/datum/component/footstep/proc/play_simplestep()
	SIGNAL_HANDLER
	var/mob/living/parent_mob = parent
	var/turf/open/T = prepare_step()
	if(!T)
		return

	if(parent_mob.lying && (isfile(drag_sounds) || istext(drag_sounds)))
		playsound(T, drag_sounds, volume, rand(20000, 25000), e_range)

	if(isfile(footstep_sounds) || istext(footstep_sounds))
		playsound(T, footstep_sounds, volume)
		return
	var/turf_footstep
	if(T.snow)
		turf_footstep = FOOTSTEP_SNOW
	else if(T.weeds)
		turf_footstep = FOOTSTEP_RESIN
	else switch(footstep_type)
		if(FOOTSTEP_XENO_MEDIUM)
			turf_footstep = T.mediumxenofootstep
		if(FOOTSTEP_MOB_BAREFOOT)
			turf_footstep = T.barefootstep
		if(FOOTSTEP_XENO_HEAVY)
			turf_footstep = T.heavyxenofootstep
		if(FOOTSTEP_MOB_SHOE)
			turf_footstep = T.shoefootstep

	if(!turf_footstep)
		return

//	var/mob/M = parent
//	play_fov_effect(T, 5, "footstep", M.dir, ignore_self = TRUE)

	playsound(T, pick(footstep_sounds[turf_footstep][1]), footstep_sounds[turf_footstep][2] * volume, TRUE, footstep_sounds[turf_footstep][3] + e_range)

/datum/component/footstep/proc/play_humanstep()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/parent_human = parent
	var/turf/open/T = prepare_step()
	if(!T)
		return

	if(parent_human.lying && (isfile(drag_sounds) || istext(drag_sounds)))
		playsound(T, drag_sounds, volume, rand(20000, 25000), e_range)

	if(T.snow)
		playsound(T, pick(GLOB.barefootstep[FOOTSTEP_SNOW][1]),
			GLOB.barefootstep[FOOTSTEP_SNOW][2] * volume,
			TRUE,
			GLOB.barefootstep[FOOTSTEP_SNOW][3] + e_range)
		return
	else if(T.weeds)
		playsound(T, pick(GLOB.barefootstep[FOOTSTEP_RESIN][1]),
			GLOB.barefootstep[FOOTSTEP_RESIN][2] * volume,
			TRUE,
			GLOB.barefootstep[FOOTSTEP_RESIN][3] + e_range)
		return
	if(parent_human.shoes) //are we wearing shoes
		playsound(T, pick(GLOB.shoefootstep[T.shoefootstep][1]),
			GLOB.shoefootstep[T.shoefootstep][2] * volume,
			TRUE,
			GLOB.shoefootstep[T.shoefootstep][3] + e_range)
		return
	playsound(T, pick(GLOB.barefootstep[T.barefootstep][1]),
		GLOB.barefootstep[T.barefootstep][2] * volume,
		TRUE,
		GLOB.barefootstep[T.barefootstep][3] + e_range)

//	play_fov_effect(T, 5, "footstep", parent_human.dir, ignore_self = TRUE)
