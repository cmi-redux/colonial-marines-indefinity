
/obj/item/xeno_egg
	name = "egg"
	desc = "Some sort of egg."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "egg_item"
	w_class = SIZE_MASSIVE
	flags_atom = OPENCONTAINER
	flags_item = NOBLUDGEON
	throw_range = 1
	layer = MOB_LAYER
	faction_to_get = FACTION_XENOMORPH_NORMAL
	black_market_value = 35
	var/flags_embryo = NO_FLAGS

/obj/item/xeno_egg/Initialize(mapload, datum/faction/faction_to_set)
	pixel_x = rand(-3,3)
	pixel_y = rand(-3,3)
	create_reagents(60)
	reagents.add_reagent(PLASMA_EGG, 60, list("hive_number" = faction))

	if(faction_to_set)
		faction = faction_to_set

	. = ..()

	set_hive_data(src, faction)

/obj/item/xeno_egg/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user))
		. += "A queen egg, it needs to be planted on weeds to start growing."
		if(faction != user.faction)
			. += "This one appears to belong to the [faction.prefix]hive"

/obj/item/xeno_egg/afterattack(atom/target, mob/user, proximity)
	if(istype(target, /obj/effect/alien/resin/special/eggmorph))
		return //We tried storing the hugger from the egg, no need to try to plant it (we know the turf is occupied!)
	if(isxeno(user))
		var/turf/T = get_turf(target)
		plant_egg(user, T, proximity)
	if(proximity && ishuman(user))
		var/turf/T = get_turf(target)
		plant_egg_human(user, T)

/obj/item/xeno_egg/proc/plant_egg_human(mob/living/carbon/human/user, turf/T)
	if(user.faction != faction)
		if(!istype(T, /turf/open/floor/almayer/research/containment))
			to_chat(user, SPAN_WARNING("Best not to plant this thing outside of a containment cell."))
			return
		for (var/obj/O in T)
			if(!istype(O,/obj/structure/machinery/light/small))
				to_chat(user, SPAN_WARNING("The floor needs to be clear to plant this!"))
				return

	user.visible_message(SPAN_NOTICE("[user] starts planting [src]."), \
					SPAN_NOTICE("You start planting [src]."), null, 5)
	if(!do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	if(user.faction != faction)
		for (var/obj/O in T)
			if(!istype(O,/obj/structure/machinery/light/small))
				return

	var/obj/effect/alien/egg/newegg = new /obj/effect/alien/egg(T, faction)
	newegg.flags_embryo = flags_embryo

	newegg.add_hiddenprint(user)
	playsound(T, 'sound/effects/splat.ogg', 15, 1)
	qdel(src)

/obj/item/xeno_egg/proc/plant_egg(mob/living/carbon/xenomorph/user, turf/target_turf, proximity = TRUE)
	if(!proximity)
		return // no message because usual behavior is not to show any
	if(!user.faction)
		to_chat(user, SPAN_XENOWARNING("Your hive cannot procreate."))
		return
	if(!user.check_alien_construction(target_turf))
		return
	if(!user.check_plasma(30))
		return

	var/obj/effect/alien/weeds/hive_weeds = null
	for(var/obj/effect/alien/weeds/weeds in target_turf)
		if(weeds.weed_strength >= WEED_LEVEL_HIVE && weeds.faction == faction)
			hive_weeds = weeds
			break

	if(!hive_weeds)
		to_chat(user, SPAN_XENOWARNING("[src] can only be planted on [lowertext(faction.prefix)]hive weeds."))
		return

	user.visible_message(SPAN_XENONOTICE("[user] starts planting [src]."), SPAN_XENONOTICE("You start planting [src]."), null, 5)

	var/plant_time = 35
	if(isdrone(user))
		plant_time = 25
	if(iscarrier(user))
		plant_time = 10
	if(!do_after(user, plant_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	if(!user.check_alien_construction(target_turf))
		return
	if(!user.check_plasma(30))
		return

	for(var/obj/effect/alien/weeds/weeds in target_turf)
		if(weeds.weed_strength >= WEED_LEVEL_HIVE)
			user.use_plasma(30)
			var/obj/effect/alien/egg/newegg = new /obj/effect/alien/egg(target_turf, faction)

			newegg.flags_embryo = flags_embryo

			newegg.add_hiddenprint(user)
			playsound(target_turf, 'sound/effects/splat.ogg', 15, 1)
			qdel(src)
			break

/obj/item/xeno_egg/attack_self(mob/user)
	..()

	if(!isxeno(user))
		return

	var/mob/living/carbon/xenomorph/X = user
	if(iscarrier(X))
		var/mob/living/carbon/xenomorph/carrier/C = X
		C.store_egg(src)
	else
		var/turf/T = get_turf(user)
		plant_egg(user, T)



//Deal with picking up facehuggers. "attack_alien" is the universal 'xenos click something while unarmed' proc.
/obj/item/xeno_egg/attack_alien(mob/living/carbon/xenomorph/user)
	if(user.caste.can_hold_eggs == CAN_HOLD_ONE_HAND)
		attack_hand(user)
		return XENO_NO_DELAY_ACTION
	if(user.caste.can_hold_eggs == CAN_HOLD_TWO_HANDS)
		if(user.r_hand || user.l_hand)
			to_chat(user, SPAN_XENOWARNING("You need two hands to hold [src]."))
		else
			attack_hand(user)
		return XENO_NO_DELAY_ACTION

/obj/item/xeno_egg/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		qdel(src)

/obj/item/xeno_egg/flamer_fire_act()
	qdel(src)

/obj/item/xeno_egg/alpha
	color = "#ff4040"
	faction_to_get = FACTION_XENOMORPH_ALPHA

/obj/item/xeno_egg/forsaken
	color = "#cc8ec4"
	faction_to_get = FACTION_XENOMORPH_FORSAKEN
