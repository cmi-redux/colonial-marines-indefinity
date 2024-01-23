/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

	recalculate_move_delay = TRUE



/mob/living/Initialize()
	. = ..()

	fire_reagent = new /datum/reagent/napalm/ut()

	attack_icon = image("icon" = 'icons/effects/attacks.dmi',"icon_state" = "", "layer" = 0)

	initialize_incision_depths()
	initialize_pain()
	initialize_stamina()
	GLOB.living_mob_list += src

/mob/living/Destroy()
	GLOB.living_mob_list -= src
	pipes_shown = null

	. = ..()

	attack_icon = null
	QDEL_NULL(fire_reagent)
	QDEL_NULL(pain)
	QDEL_NULL(stamina)
	QDEL_NULL(hallucinations)

//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(pressure)
	return

/mob/living/proc/initialize_pain()
	pain = new /datum/pain(src)

/mob/living/proc/initialize_stamina()
	stamina = new /datum/stamina(src)

/mob/living/proc/initialize_incision_depths()
	for(var/location in incision_depths)
		incision_depths[location] = SURGERY_DEPTH_SURFACE

/mob/living/proc/apply_stamina_damage(damage, def_zone, armor_type)
	if(!stamina)
		return

	stamina.apply_damage(damage)

//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src //make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = (burn_amount)/(H.limbs.len)
		var/extradam = 0 //added to when organ is at max dam
		for(var/obj/limb/affecting in H.limbs)
			if(!affecting) continue
			if(affecting.take_damage(0, divided_damage+extradam)) //TODO: fix the extradam stuff. Or, ebtter yet...rewrite this entire proc ~Carn
				H.UpdateDamageIcon()
		H.updatehealth()
		return 1

	else if(isAI(src))
		return 0

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired) //get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost // Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
// if(istype(src, /mob/living/carbon/human))
	return temperature



/mob/proc/get_contents()


//Recursive function to find everything a mob is holding.
/mob/living/get_contents(obj/item/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(obj/item/storage/S in Storage.return_inv()) //Check for storage items
		// L += get_contents(S)

		for(var/obj/item/gift/G in Storage.return_inv()) //Check for gift-wrapped items
			L += G.gift
			if(isstorage(G.gift))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in Storage.return_inv()) //Check for package wrapped items
			L += D.wrapped
			if(isstorage(D.wrapped)) //this should never happen
				L += get_contents(D.wrapped)
		return L

	else

		L += src.contents
		for(var/obj/item/storage/S in src.contents) //Check for storage items
			L += get_contents(S)

		for(var/obj/item/gift/G in src.contents) //Check for gift-wrapped items
			L += G.gift
			if(isstorage(G.gift))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in src.contents) //Check for package wrapped items
			L += D.wrapped
			if(isstorage(D.wrapped)) //this should never happen
				L += get_contents(D.wrapped)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return TRUE
	return FALSE


/mob/living/proc/get_limbzone_target()
	return rand_zone(zone_selected)



/mob/living/proc/UpdateDamageIcon()
	return


/mob/living/proc/Examine_OOC()
	set name = "Examine Meta-Info (OOC)"
	set category = "OOC"
	set src in view()

	if(CONFIG_GET(flag/allow_Metadata))
		if(client)
			to_chat(usr, "[src]'s Metainfo:<br>[client.prefs.metadata]")
		else
			to_chat(usr, "[src] does not have any stored infomation!")
	else
		to_chat(usr, "OOC Metadata is not supported by this server!")

	return

/mob/living/Move(newloc, direct)
	if(buckled && buckled.loc != newloc) //not updating position
		if(!buckled.anchored)
			return buckled.Move(newloc, direct)
		else
			return FALSE

	var/old_direction = dir
	var/atom/movable/pullee = pulling
	if(pullee && get_dist(src, pullee) > 1) //Is the pullee adjacent?
		stop_pulling()
	var/turf/T = loc
	. = ..()
	if(. && pulling && pulling == pullee) //we were pulling a thing and didn't lose it during our move.
		var/data = SEND_SIGNAL(pulling, COMSIG_MOVABLE_PULLED, src)
		if(!(data & COMPONENT_IGNORE_ANCHORED) && pulling.anchored)
			stop_pulling()
			return

		var/pull_dir = get_dir(src, pulling)

		if(grab_level >= GRAB_CARRY)
			switch(grab_level)
				if(GRAB_CARRY)
					var/direction_to_face = EAST

					if(direct & WEST)
						direction_to_face = WEST

					pulling.Move(newloc, direction_to_face)
					var/mob/living/pmob = pulling
					if(istype(pmob))
						SEND_SIGNAL(pmob, COMSIG_MOB_MOVE_OR_LOOK, TRUE, direction_to_face, direction_to_face)
				else
					pulling.Move(newloc, direct)
		else if(get_dist(src, pulling) > 1 || ((pull_dir - 1) & pull_dir)) //puller and pullee more than one tile away or in diagonal position
			var/pulling_dir = get_dir(pulling, T)
			pulling.Move(T, pulling_dir) //the pullee tries to reach our previous position
			if(pulling && get_dist(src, pulling) > 1) //the pullee couldn't keep up
				stop_pulling()
			else
				var/mob/living/pmob = pulling
				if(istype(pmob))
					SEND_SIGNAL(pmob, COMSIG_MOB_MOVE_OR_LOOK, TRUE, pulling_dir, pulling_dir)
				if(!(flags_atom & DIRLOCK))
					setDir(turn(direct, 180)) //face the pullee

	if(pulledby && get_dist(src, pulledby) > 1)//separated from our puller and not in the middle of a diagonal move.
		pulledby.stop_pulling()

	if(s_active && !( s_active in contents ) && get_turf(s_active) != get_turf(src)) //check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.storage_close(src)

	// Check if we're still pulling something
	if(pulling)
		SEND_SIGNAL(pulling, COMSIG_MOB_DRAGGED, src)

	if(back && (back.flags_item & ITEM_OVERRIDE_NORTHFACE))
		update_inv_back()

	if(lying && !buckled)
		makeTrail(newloc, T, old_direction)

/mob/proc/resist_grab(moving_resist)
	return //returning 1 means we successfully broke free

/mob/living/resist_grab(moving_resist)
	if(!pulledby)
		return
	if(pulledby.grab_level)
		if(prob(50))
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
			visible_message(SPAN_DANGER("[src] has broken free of [pulledby]'s grip!"), null, null, 5)
			pulledby.stop_pulling()
			return 1
		if(moving_resist && client) //we resisted by trying to move
			visible_message(SPAN_DANGER("[src] struggles to break free of [pulledby]'s grip!"), null, null, 5)
			client.next_movement = world.time + (10*pulledby.grab_level) + client.move_delay
	else
		pulledby.stop_pulling()
		return 1


/mob/living/movement_delay()
	. = ..()

	if(do_bump_delay)
		. += 10
		do_bump_delay = 0

	if(drowsyness > 0)
		. += 6

	if(pulling && pulling.drag_delay && get_pull_miltiplier()) //Dragging stuff can slow you down a bit.
		var/pull_delay = pulling.get_pull_drag_delay() * get_pull_miltiplier()

		var/grab_level_delay = 0
		switch(grab_level)
			if(GRAB_AGGRESSIVE)
				grab_level_delay = 6
			if(GRAB_CHOKE)
				grab_level_delay = 9

		. += max(pull_speed + (pull_delay + reagent_move_delay_modifier) + grab_level_delay, 0) //harder grab makes you slower
	move_delay = .


//the inherent slowdown of the object when pulled
/atom/movable/proc/get_pull_drag_delay()
	. = drag_delay

/obj/structure/closet/bodybag/get_pull_drag_delay()
	if(roller_buckled) //if the pulled bodybag is buckled to a roller bed, we use its drag_delay instead.
		. = roller_buckled.drag_delay
	else
		. = drag_delay

/mob/living/get_pull_drag_delay()
	if(buckled) //if the pulled mob is buckled to an object, we use that object's drag_delay.
		. = buckled.drag_delay
	else
		. = drag_delay

//whether we are slowed when dragging things
/mob/living/proc/get_pull_miltiplier()
	if(!HAS_TRAIT(src, TRAIT_DEXTROUS))
		if(grab_level == GRAB_CARRY)
			return 0.1
		else
			return 1
	else
		return 0

/mob/living/forceMove(atom/destination)
	if(pulling)
		var/pull_dist = get_dist(pulling, destination)
		if(pulling.z != destination?.z || pull_dist < 0 || pull_dist > 1)
			stop_pulling()
	if(pulledby)
		var/pull_dist = get_dist(pulledby, destination)
		if(pulledby.z != destination?.z || pull_dist < 0 || pull_dist > 1)
			pulledby.stop_pulling()
	if(buckled && destination != buckled.loc)
		buckled.unbuckle()
	. = ..()
	SEND_SIGNAL(src, COMSIG_MOB_MOVE_OR_LOOK, TRUE, dir, dir)

	if(.)
		reset_view(destination)

/mob/living/Collide(atom/movable/AM)
	if(buckled || now_pushing)
		return

	if(throwing)
		launch_impact(AM)
		return

	if(SEND_SIGNAL(src, COMSIG_LIVING_PRE_COLLIDE, AM) & COMPONENT_LIVING_COLLIDE_HANDLED)
		return

	if(!isliving(AM))
		..()
		return

	now_pushing = TRUE
	var/mob/living/L = AM

	if(L.status_flags & IMMOBILE_ACTION && src.faction == L.faction && src.mob_size <= L.mob_size)
		now_pushing = FALSE
		return

	//Leaping mobs just land on the tile, no pushing, no anything.
	if(status_flags & LEAPING)
		forceMove(L.loc)
		status_flags &= ~LEAPING
		now_pushing = FALSE
		return

	if(L.pulledby && L.pulledby != src && L.is_mob_restrained())
		if(!(world.time % 5))
			to_chat(src, SPAN_WARNING("[L] is restrained, you cannot push past."))
		now_pushing = FALSE
		return

	if(isxeno(L) && !islarva(L))
		var/mob/living/carbon/xenomorph/X = L
		if(X.mob_size >= MOB_SIZE_BIG || (ishuman(src) && !isyautja(src))) // Small xenos can be pushed by other xenos or preds
			now_pushing = FALSE
			return

	if(L.pulling)
		if(ismob(L.pulling))
			var/mob/P = L.pulling
			if(P.is_mob_restrained())
				if(!(world.time % 5))
					to_chat(src, SPAN_WARNING("[L] is restraining [P], you cannot push past."))
				now_pushing = FALSE
				return

	if(ishuman(L))
		if(!(L.status_flags & CANPUSH))
			now_pushing = FALSE
			return

	if(!L.buckled && !L.anchored)
		var/mob_swap
		//the puller can always swap with its victim if on grab intent
		if(L.pulledby == src && a_intent == INTENT_GRAB)
			mob_swap = 1
		//restrained people act if they were on 'help' intent to prevent a person being pulled from being separated from their puller
		else if((L.is_mob_restrained() || L.a_intent == INTENT_HELP) && (is_mob_restrained() || a_intent == INTENT_HELP))
			mob_swap = 1
		if(mob_swap)
			//switch our position with L
			if(loc && !loc.Adjacent(L.loc))
				now_pushing = FALSE
				return
			var/oldloc = loc
			var/oldLloc = L.loc

			L.add_temp_pass_flags(PASS_MOB_THRU)
			add_temp_pass_flags(PASS_MOB_THRU)

			L.Move(oldloc)
			Move(oldLloc)

			remove_temp_pass_flags(PASS_MOB_THRU)
			L.remove_temp_pass_flags(PASS_MOB_THRU)

			now_pushing = FALSE
			return

	now_pushing = FALSE

	if(!(L.status_flags & CANPUSH))
		return

	..()

/mob/living/launch_towards(datum/launch_metadata/LM)
	if(src)
		SEND_SIGNAL(src, COMSIG_MOB_MOVE_OR_LOOK, TRUE, dir, dir)
	if(!istype(LM) || !LM.target || !src || buckled)
		return
	if(pulling)
		stop_pulling() //being thrown breaks pulls.
	if(pulledby)
		pulledby.stop_pulling()
	. = ..()

//to make an attack sprite appear on top of the target atom.
/mob/living/proc/flick_attack_overlay(atom/target, attack_icon_state, duration = 4)
	set waitfor = FALSE

	if(!attack_icon)
		return FALSE

	attack_icon.icon_state = attack_icon_state
	attack_icon.pixel_x = -target.pixel_x
	attack_icon.pixel_y = -target.pixel_y
	target.overlays += attack_icon
	var/old_icon = attack_icon.icon_state
	var/old_pix_x = attack_icon.pixel_x
	var/old_pix_y = attack_icon.pixel_y
	addtimer(CALLBACK(istype(target, /mob/living) ? target : src, /mob/living/proc/finish_attack_overlay, target, old_icon, old_pix_x, old_pix_y), duration)

/mob/living/proc/finish_attack_overlay(atom/target, old_icon, old_pix_x, old_pix_y)
	if(!attack_icon || !target)
		return FALSE

	var/new_icon = attack_icon.icon_state
	var/new_pix_x = attack_icon.pixel_x
	var/new_pix_y = attack_icon.pixel_y
	attack_icon.icon_state = old_icon //necessary b/c the attack_icon can change sprite during the sleep.
	attack_icon.pixel_x = old_pix_x
	attack_icon.pixel_y = old_pix_y

	target.overlays -= attack_icon

	attack_icon.icon_state = new_icon
	attack_icon.pixel_x = new_pix_x
	attack_icon.pixel_y = new_pix_y

/mob/proc/flash_eyes()
	return

/mob/living/flash_eyes(intensity = 1, bypass_checks, type = /atom/movable/screen/fullscreen/flash, flash_timer = 40)
	if(bypass_checks || (get_eye_protection() < intensity && !(sdisabilities & DISABILITY_BLIND)))
		overlay_fullscreen("flash", type)
		spawn(flash_timer)
			clear_fullscreen("flash", 20)
		return TRUE
/**
 * We want to relay the zmovement to the buckled atom when possible
 * and only run what we can't have on buckled.zMove() or buckled.can_z_move() here.
 * This way we can avoid esoteric bugs, copypasta and inconsistencies.
 */
/mob/living/zMove(dir, turf/target, z_move_flags = ZMOVE_FLIGHT_FLAGS)
	if(buckled)
		if(buckled.currently_z_moving)
			return FALSE
		if(!(z_move_flags & ZMOVE_ALLOW_BUCKLED))
			buckled.unbuckle(src, FALSE)
		else
			if(!target)
				target = can_z_move(dir, get_turf(src), null, z_move_flags, src)
				if(!target)
					return FALSE
			return buckled.zMove(dir, target, z_move_flags) // Return value is a loc.
	return ..()

/mob/living/can_z_move(direction, turf/start, turf/destination, z_move_flags = ZMOVE_FLIGHT_FLAGS, mob/living/rider)
	if(z_move_flags & ZMOVE_INCAPACITATED_CHECKS && update_canmove())
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider || src, SPAN_WARNING("[rider ? src : "You"] can't do that right now!"))
		return FALSE
	if(!buckled || !(z_move_flags & ZMOVE_ALLOW_BUCKLED))
		if(!(z_move_flags & ZMOVE_FALL_CHECKS) && canmove && (!rider || rider.canmove))
			//An incorporeal mob will ignore obstacles unless it's a potential fall (it'd suck hard) or is carrying corporeal mobs.
			//Coupled with flying/floating, this allows the mob to move up and down freely.
			//By itself, it only allows the mob to move down.
			z_move_flags |= ZMOVE_IGNORE_OBSTACLES
		return ..()

/mob/set_currently_z_moving(value)
	if(buckled)
		return buckled.set_currently_z_moving(value)
	return ..()

/mob/living/onZImpact(turf/T, levels, message = TRUE)
	ZImpactDamage(T, levels)
	message = FALSE
	return ..()

/mob/living/proc/ZImpactDamage(turf/T, levels)
	if(SEND_SIGNAL(src, COMSIG_LIVING_Z_IMPACT, levels, T) & NO_Z_IMPACT_DAMAGE)
		return
	visible_message(SPAN_DANGER("[src] crashes into [T] with a sickening noise!"), \
					usr, SPAN_DANGER("You crash into [T] with a sickening noise!"))
	adjustBruteLoss((levels * 5) ** 1.5)
	KnockDown(levels * 4)
	fall(TRUE)

/mob/living/proc/makeTrail(turf/target_turf, turf/start, direction)
	if(!isturf(start) || !blood_volume)
		return

	var/blood_exists = locate(/obj/effect/decal/cleanable/trail_holder) in start

	var/trail_type = getTrail()
	if(!trail_type)
		return

	var/brute_ratio = round(getBruteLoss() / maxHealth, 0.1)
	if(blood_volume < max(BLOOD_VOLUME_NORMAL*(1 - brute_ratio * 0.25), 0))//don't leave trail if blood volume below a threshold
		return

	var/bleed_amount = bleedDragAmount()
	blood_volume = max(blood_volume - bleed_amount, 0) //that depends on our brute damage.
	var/newdir = get_dir(target_turf, start)
	if(newdir != direction)
		newdir = newdir | direction
		if(newdir == (NORTH|SOUTH))
			newdir = NORTH
		else if(newdir == (EAST|WEST))
			newdir = EAST
	if((newdir in GLOB.cardinals) && (prob(50)))
		newdir = turn(get_dir(target_turf, start), 180)
	if(!blood_exists)
		new /obj/effect/decal/cleanable/trail_holder(start, get_blood_color())

	for(var/obj/effect/decal/cleanable/trail_holder/TH in start)
		if((!(newdir in TH.existing_dirs) || trail_type == "trails_1" || trail_type == "trails_2") && TH.existing_dirs.len <= 16) //maximum amount of overlays is 16 (all light & heavy directions filled)
			TH.existing_dirs += newdir
			TH.overlays += image('icons/effects/new_blood.dmi', trail_type, dir = newdir)

/mob/living/carbon/human/makeTrail(turf/T)
	if(!is_bleeding())
		return
	..()

///Returns how much blood we're losing from being dragged a tile, from [/mob/living/proc/makeTrail]
/mob/living/proc/bleedDragAmount()
	var/brute_ratio = round(getBruteLoss() / maxHealth, 0.1)
	return max(1, brute_ratio * 2)

/mob/living/carbon/human/bleedDragAmount()
	var/bleed_amount = 0
	for(var/datum/effects/bleeding/external/B in effects_list)
		bleed_amount += B.blood_loss
	return bleed_amount

/mob/living/proc/getTrail()
	if(getBruteLoss() < 100)
		return pick("ltrails_1", "ltrails_2")
	else
		return pick("trails_1", "trails_2")

/mob/living/set_stat(new_stat)
	. = ..()
	if(isnull(.))
		return
	switch(.)
		if(DEAD)
			SEND_SIGNAL(src, COMSIG_MOB_STAT_SET_ALIVE)
	switch(stat)
		if(DEAD)
			SEND_SIGNAL(src, COMSIG_MOB_STAT_SET_DEAD)
