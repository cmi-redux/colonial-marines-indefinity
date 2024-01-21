


//FLOORS-----------------------------------//
//Snow Floor
/turf/open/snow
	name = "snow layer"
	icon = 'icons/turf/floors/snow2.dmi'
	icon_state = "snow_0"
	shoefootstep = FOOTSTEP_SNOW
	barefootstep = FOOTSTEP_SNOW
	mediumxenofootstep = FOOTSTEP_SNOW

	antipierce = 5

	//PLACING/REMOVING/BUILDING
/turf/open/snow/attackby(obj/item/I, mob/user)

	//Light Stick
	if(istype(I, /obj/item/lightstick))
		var/obj/item/lightstick/L = I
		if(locate(/obj/item/lightstick) in get_turf(src))
			to_chat(user, "There's already a [L]  at this position!")
			return

		to_chat(user, "Now planting \the [L].")
		if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		user.visible_message("\blue[user.name] planted \the [L] into [src].")
		L.anchored = TRUE
		L.icon_state = "lightstick_[L.s_color][L.anchored]"
		user.drop_held_item()
		L.forceMove(src)
		L.pixel_x += rand(-5,5)
		L.pixel_y += rand(-5,5)
		L.set_light(2)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)



//Update icon and sides on start, but skip nearby check for turfs.
/turf/open/snow/Initialize(mapload, ...)
	. = ..()
	new /obj/structure/snow(src, bleed_layer)
	bleed_layer = 0
	update_icon()

/turf/open/snow/Entered(atom/movable/arrived, old_loc)
	if(bleed_layer > 0)
		if(iscarbon(arrived))
			var/mob/living/carbon/C = arrived
			var/slow_amount = 0.75
			var/can_stuck = 1
			if(istype(C, /mob/living/carbon/xenomorph)||isyautja(C))
				slow_amount = 0.25
				can_stuck = 0
			var/new_slowdown = C.next_move_slowdown + (slow_amount * bleed_layer)
			if(prob(2))
				to_chat(C, SPAN_WARNING("Moving through [src] slows you down.")) //Warning only
			else if(can_stuck && bleed_layer == 3 && prob(2))
				to_chat(C, SPAN_WARNING("You get stuck in [src] for a moment!"))
				new_slowdown += 10
			C.next_move_slowdown = new_slowdown
	..()

//Explosion act
/turf/open/snow/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(20) && bleed_layer)
				bleed_layer--
				update_icon()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(60) && bleed_layer)
				bleed_layer = max(bleed_layer - 2, 0)
				update_icon()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if(bleed_layer)
				bleed_layer = 0
				update_icon()

//SNOW LAYERS-----------------------------------//
/turf/open/snow/layer0
	icon_state = "snow_0"
	bleed_layer = 0
	shoefootstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	mediumxenofootstep = FOOTSTEP_SAND

/turf/open/snow/layer1
	icon_state = "snow_1"
	bleed_layer = 1

/turf/open/snow/layer2
	icon_state = "snow_2"
	bleed_layer = 2

/turf/open/snow/layer3
	icon_state = "snow_3"
	bleed_layer = 3



