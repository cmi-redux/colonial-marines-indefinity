/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/is_mob_restrained()
	if(handcuffed)
		return TRUE
	return

/mob/living/carbon/check_view_change(new_size, atom/source)
	LAZYREMOVE(view_change_sources, source)
	var/highest_view = 0
	for(var/view_source as anything in view_change_sources)
		var/view_rating = view_change_sources[view_source]
		if(highest_view < view_rating)
			highest_view = view_rating
	if(source && new_size != world_view_size)
		LAZYSET(view_change_sources, source, new_size)
	if(new_size < highest_view)
		new_size = highest_view
	return new_size

/mob/living/carbon/attackby(obj/item/item, mob/user)
	if(user.a_intent != INTENT_HELP)
		return ..()
	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL) && ishuman(user))
		var/mob/living/carbon/human/programmer = user
		if(!faction_tag)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an Faction IFF tag to reprogram."))
			return
		programmer.visible_message(SPAN_NOTICE("[programmer] starts reprogramming \the [src]'s [faction_tag]..."), SPAN_NOTICE("You start reprogramming \the [src]'s [faction_tag]..."), max_distance = 3)
		if(!do_after(programmer, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
			return
		if(!faction_tag)
			to_chat(programmer, SPAN_WARNING("\The [src]'s Faction IFF tag got removed while you were reprogramming it!"))
			return
		if(!faction_tag.handle_reprogramming(programmer, src))
			return
		programmer.visible_message(SPAN_NOTICE("[programmer] reprograms \the [src]'s [faction_tag]."), SPAN_NOTICE("You reprogram \the [src]'s [faction_tag]."), max_distance = 3)
		return
	if(item.type in SURGERY_TOOLS_PINCH)
		if(!faction_tag)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an Faction IFF tag to remove."))
			return
		user.visible_message(SPAN_NOTICE("[user] starts removing \the [src]'s [faction_tag]..."), SPAN_NOTICE("You start removing \the [src]'s [faction_tag]..."), max_distance = 3)
		if(!do_after(user, 5 SECONDS * SURGERY_TOOLS_PINCH[item.type], INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
			return
		if(!faction_tag)
			to_chat(user, SPAN_WARNING("\The [src]'s Faction IFF tag got removed while you were removing it!"))
			return
		user.put_in_hands(faction_tag)
		faction_tag = null
		user.visible_message(SPAN_NOTICE("[user] removes \the [src]'s Faction IFF tag."), SPAN_NOTICE("You remove \the [src]'s Faction IFF tag."), max_distance = 3)
		return
	return ..()

/mob/living/carbon/proc/handle_queen_screech(mob/living/carbon/xenomorph/queen/queen, list/mobs_in_view)
	if(!(src in mobs_in_view))
		return
	var/mob/living/carbon/human/H = src
	if(H && (istype(H.wear_l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.wear_r_ear, /obj/item/clothing/ears/earmuffs)))
		return
	var/dist = get_dist(queen, src)
	if(dist <= 4)
		to_chat(src, SPAN_DANGER("An ear-splitting guttural roar shakes the ground beneath your feet!"))
		adjust_effect(4, STUN)
		apply_effect(4, WEAKEN)
		if(!ear_deaf || !HAS_TRAIT(src, TRAIT_EAR_PROTECTION))
			AdjustEarDeafness(5) //Deafens them temporarily
	else if(dist >= 5 && dist < 7)
		adjust_effect(3, STUN)
		if(!ear_deaf || !HAS_TRAIT(src, TRAIT_EAR_PROTECTION))
			AdjustEarDeafness(2)
		to_chat(src, SPAN_DANGER("The roar shakes your body to the core, freezing you in place!"))

/mob/living/carbon/proc/handle_faction_convert(mob/living/carbon/human/converter)
	if(converter.faction == faction)
		return TRUE
	if(morale)
		if(morale_flags & MORALE_FLAG_NO_SELF_CAP)
			return FALSE
		if(alert(src, "[converter] offering you to join their faction ([converter.faction]), maybe that in this is situation good choice", , client.auto_lang(LANGUAGE_YES), client.auto_lang(LANGUAGE_NO)) != client.auto_lang(LANGUAGE_YES))
			return FALSE
	else
		if(morale_flags & MORALE_FLAG_NO_AUTO_CAP)
			if(alert(src, "[converter] offering you to join their faction ([converter.faction]), maybe that in this is situation good choice", , client.auto_lang(LANGUAGE_YES), client.auto_lang(LANGUAGE_NO)) != client.auto_lang(LANGUAGE_YES))
				return FALSE

	converter.visible_message(SPAN_WARNING("[converter] converted [src]."),\
	SPAN_WARNING("You converted [src]."))

	converter.faction.add_mob(src)
	return TRUE

///Checks if something prevents sharp objects from interacting with the mob (such as armor blocking surgical tools / surgery)
/mob/living/carbon/proc/get_sharp_obj_blocker(obj/limb/limb)
	return null
