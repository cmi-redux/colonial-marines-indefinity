/turf/open/trench
	name = "trench"
	icon = 'icons/turf/trenches_turfs.dmi'
	icon_state = "trench_wall"
	turf_flags = TURF_MULTIZ|TURF_TRENCH
	weedable = SEMI_WEEDABLE
	allow_construction = FALSE
	var/type_matterial = "wood"
	var/movement_delay = 0.5
	var/list/cadeblockers = list()
	var/cadeblockers_range = 1

/turf/open/trench/Initialize()
	. = ..()
	for(var/turf/T in range(cadeblockers_range, src))
		var/obj/structure/blocker/anti_cade/CB = new(T)
		CB.to_block = src

		cadeblockers.Add(CB)

/turf/open/trench/ChangeTurf()
	QDEL_NULL_LIST(cadeblockers)
	. = ..()

/turf/open/trench/fake
	turf_flags = null

/turf/open/trench/tough

/turf/open/trench/ex_act(severity)
	return

/turf/open/trench/New()
	..()
	dir = pick(GLOB.alldirs)
	update_icon()

/turf/open/trench/ex_act(severity)
	return

/turf/open/trench/clicked(mob/user, list/mods)
	if(mods["right"])
		fill(user)
		return 1
	return (..())

/turf/open/trench/proc/fill(mob/living/user)
	if(user.action_busy)
		return

	var/obj/item/tool/shovel/etool/trench/S = user.get_active_hand()
	if(!istype(S) || S.folded)
		return

	if(turf_flags & TURF_TRENCH)
		for(var/obj/structure/object in contents)
			if(object)
				to_chat(user, "There are things in the way.")
				return
		to_chat(user, SPAN_NOTICE("You start fill in the trench."))
		playsound(user.loc, 'sound/effects/thud.ogg', 50, 1, 6)
		visible_message("[user] begins fill in the trench!")
		if(!do_after(user, S.shovelspeed * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("You stop digging."))
			return
		for(var/mob/M in src)
			if(ishuman(M))
				M.pixel_y = 0
		to_chat(user, SPAN_NOTICE("You finishes filling in trench."))
		visible_message("[user] finishes filling in trench.")
		ChangeTurf(/turf/open/gm/dirt2)
		update_trench_shit()

/turf/open/proc/update_trench_layers()
	QDEL_NULL_LIST(vis_contents)
	for(var/direction in GLOB.cardinals)
		var/turf/turf_to_check = get_step(src, direction)
		if(istype(turf_to_check, /turf/open/trench))
			continue
		if(istype(turf_to_check, /turf/open) || istype(turf_to_check, /turf/closed))
			var/obj/structure/platform/trench/side = new(src)
			side.dir = direction
			switch(direction)
				if(NORTH)
					side.pixel_y += ((world.icon_size) - 22)
					side.layer = BELOW_OBJ_LAYER
				if(SOUTH)
					side.pixel_y -= ((world.icon_size) - 16)
				if(WEST)
					side.pixel_x -= (world.icon_size)
					side.layer = BELOW_OBJ_LAYER
				if(EAST)
					side.pixel_x += (world.icon_size)
					side.layer = BELOW_OBJ_LAYER
				else
					qdel(side)
			vis_contents += side

/turf/open/trench/update_icon()
	update_trench_shit()

/turf/open/proc/update_trench_shit()
	for(var/direction in GLOB.cardinals)
		var/turf/turf_to_check = get_step(src,direction)
		if(istype(turf_to_check, /turf/open/trench))//Rebuild our neighbors.
			var/turf/open/trench/T = turf_to_check
			T.update_trench_layers()
			continue

	update_trench_layers()

/turf/open/trench/Entered(atom/movable/arrived)
	. = ..()
	if(isliving(arrived))
		arrived.AddComponent(/datum/component/mob_overlay_effect, type, -4, FALSE)
		var/mob/living/C = arrived
		if(C && C.throwing)
			return
		C.next_move_slowdown = C.next_move_slowdown + movement_delay

/obj/structure/platform/trench
	name = "Trench Wall"
	icon = 'icons/turf/trenches_turfs.dmi'
	icon_state = "trench_wall_side"
	mouse_opacity = FALSE
	unacidable = TRUE
	indestructible = TRUE
	climb_delay = CLIMB_DELAY_LONG

/obj/structure/platform/trench/ex_act()
	return FALSE
