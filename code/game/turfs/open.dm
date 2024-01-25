
//turfs with density = FALSE

/turf/open
	plane = FLOOR_PLANE
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF|TURF_EFFECT_AFFECTABLE
	minimap_color = MINIMAP_AREA_COLONY
	var/allow_construction = TRUE //whether you can build things like barricades on this turf.
	var/bleed_layer = 0 //snow layer
	var/scorchable = FALSE //if TRUE set to be an icon_state which is the full sprite version of whatever gets scorched --> for border turfs like grass edges and shorelines
	var/scorchedness = 0 //how scorched is this turf 0 to 3
	var/icon_state_before_scorching //this is really dumb, blame the mappers...
	var/shoefootstep = FOOTSTEP_FLOOR
	var/barefootstep = FOOTSTEP_HARD
	var/mediumxenofootstep = FOOTSTEP_HARD
	var/heavyxenofootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/update_overlays()
	. = ..()
	if(!.)
		return

	add_cleanable_overlays()

	var/list/turf/open/auto_turf/auto_turf_dirs = list()
	for(var/direction in GLOB.alldirs)
		var/turf/open/auto_turf/T = get_step(src, direction)
		if(!istype(T))
			continue

		if(bleed_layer >= T.bleed_layer)
			continue

		auto_turf_dirs["[direction]"] = T

	var/list/handled_dirs = list()
	var/list/unhandled_dirs = list()
	for(var/direction in GLOB.diagonals)
		var/x_dir = direction & (direction-1)
		var/y_dir = direction - x_dir

		if(!("[direction]" in auto_turf_dirs))
			unhandled_dirs |= x_dir
			unhandled_dirs |= y_dir
			continue

		var/turf/open/auto_turf/xy_turf = auto_turf_dirs["[direction]"]
		if(("[x_dir]" in auto_turf_dirs) && ("[y_dir]" in auto_turf_dirs))
			var/special_icon_state = "[xy_turf.icon_prefix]_innercorner"
			var/image/I = image(xy_turf.icon, special_icon_state, dir = REVERSE_DIR(direction), layer = layer + 0.001 + xy_turf.bleed_layer * 0.0001)
			I.appearance_flags = RESET_TRANSFORM|RESET_ALPHA|RESET_COLOR
			overlays += I
			handled_dirs += "[x_dir]"
			handled_dirs += "[y_dir]"
			continue

		var/special_icon_state = "[xy_turf.icon_prefix]_outercorner"
		var/image/I = image(xy_turf.icon, special_icon_state, dir = REVERSE_DIR(direction), layer = layer + 0.001 + xy_turf.bleed_layer * 0.0001)
		I.appearance_flags = RESET_TRANSFORM|RESET_ALPHA|RESET_COLOR
		overlays += I
		unhandled_dirs |= x_dir
		unhandled_dirs |= y_dir

	for(var/direction in unhandled_dirs)
		if(("[direction]" in auto_turf_dirs) && !("[direction]" in handled_dirs))
			var/turf/open/auto_turf/turf = auto_turf_dirs["[direction]"]
			var/special_icon_state = "[turf.icon_prefix]_[pick("innercorner", "outercorner")]"
			var/image/I = image(turf.icon, special_icon_state, dir = REVERSE_DIR(direction), layer = layer + 0.001 + turf.bleed_layer * 0.0001)
			I.appearance_flags = RESET_TRANSFORM|RESET_ALPHA|RESET_COLOR
			overlays += I

	if(scorchedness)
		if(!icon_state_before_scorching) //I hate you mappers, stop var editting turfs
			icon_state_before_scorching = icon_state
		var/new_icon_state = "[icon_state_before_scorching]_scorched[scorchedness]"
		if(icon_state != new_icon_state) //no point in updating the icon_state if it would be updated to be the same thing that it was
			icon_state = new_icon_state
			for(var/i in GLOB.cardinals) //but we still check so that we can update our neighbor's overlays if we do
				var/turf/open/T = get_step(src, i) //since otherwise they'd be stuck with overlays that were made with
				T.update_icon()
		for(var/i in GLOB.cardinals)
			var/turf/open/T = get_step(src, i)
			if(istype(T, /turf/open) && T.scorchable && T.scorchedness < scorchedness)
				var/icon/edge_overlay
				if(T.scorchedness)
					edge_overlay = icon(T.icon, "[T.scorchable]_scorched[T.scorchedness]")
				else
					edge_overlay = icon(T.icon, T.scorchable)
				if(!T.icon_state_before_scorching)
					T.icon_state_before_scorching = T.icon_state
				var/direction_from_neighbor_towards_src = get_dir(T, src)
				var/icon/culling_mask = icon(T.icon, "[T.scorchable]_mask[turf_edgeinfo_cache[T.icon_state_before_scorching][dir2indexnum(T.dir)][dir2indexnum(direction_from_neighbor_towards_src)]]", direction_from_neighbor_towards_src)
				edge_overlay.Blend(culling_mask, ICON_OVERLAY)
				edge_overlay.SwapColor(rgb(255, 0, 255, 255), rgb(0, 0, 0, 0))
				overlays += edge_overlay

/turf/open/proc/scorch(heat_level)
	// All scorched icons should be in the dmi that their unscorched bases are
	// "name_scorched#" where # is the scorchedness level 0 - 1 - 2 - 3
	// 0 being no scorch, and 3 the most scorched
	// level 1 should appear dried version of the base sprite so singeing works well
	// depending on the heat_level either will singe or progressively increase the scorchedness up to level 3
	// heat_level's logic has been written to scale with /obj/flamer_fire's burnlevel --- greenfire=15,orangefire=30,bluefire=40,whitefire=80

	if(scorchedness == 3) //already scorched to hell, no point in doing anything more
		return

	switch(heat_level)
		if(0)
			return

		if(1) // 1 only singes
			if(!scorchedness) // we only singe that which hasnt burned
				scorchedness = 1

		if(2 to 30)
			scorchedness = Clamp(scorchedness + 1, 0, 3) //increase scorch by 1 (not that hot of a fire)

		if(31 to 60)
			scorchedness = Clamp(scorchedness + 2, 0, 3) //increase scorch by 2 (hotter fire)

		if(61 to INFINITY)
			scorchedness = 3 //max out the scorchedness (hottest fire)
			var/turf/open/singe_target //super heats singe the surrounding singeables
			for(var/i in GLOB.cardinals)
				singe_target = get_step(src, i)
				if(istype(singe_target, /turf/open))
					if(singe_target.scorchable && !singe_target.scorchedness)  //much recurision checking
						singe_target.scorch(1)

	update_icon()

/turf/open/get_examine_text(mob/user)
	. = ..()
	var/ceiling_info = ceiling_desc(user)
	if(ceiling_info)
		. += ceiling_info
	if(scorchedness)
		switch(scorchedness)
			if(1)
				. += "Lightly Toasted."
			if(2)
				. += "Medium Roasted."
			if(3)
				. += "Well Done."

//direction is direction of travel of A
/turf/open/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.flags_obj & OBJ_BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	return FALSE

//direction is direction of travel of A
/turf/open/zPassOut(atom/movable/A, direction, turf/destination, allow_anchored_movement)
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.flags_obj & OBJ_BLOCK_Z_OUT_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/river
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	shoefootstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	mediumxenofootstep = FOOTSTEP_WATER
	heavyxenofootstep = FOOTSTEP_WATER

// Prison grass
/turf/open/organic/grass
	name = "grass"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "grass1"
	turf_flags = TURF_MULTIZ|TURF_TRENCHING|TURF_WEATHER_PROOF
	weedable = FULLY_WEEDABLE

	antipierce = 5

// Mars grounds

/turf/open/mars
	name = "sand"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_sand_1"
	turf_flags = TURF_MULTIZ|TURF_TRENCHING|TURF_WEATHER_PROOF
	weedable = FULLY_WEEDABLE
	minimap_color = MINIMAP_MARS_DIRT

	antipierce = 5

/turf/open/mars_cave
	name = "cave"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_cave_1"
	shoefootstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	mediumxenofootstep = FOOTSTEP_SAND

	antipierce = 5

/turf/open/mars_cave/Initialize(mapload, ...)
	. = ..()

	var/r = rand(0, 2)

	if(r == 0 && icon_state == "mars_cave_2")
		icon_state = "mars_cave_3"

/turf/open/mars_dirt
	name = "dirt"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_dirt_1"
	turf_flags = TURF_MULTIZ|TURF_TRENCHING|TURF_WEATHER_PROOF
	minimap_color = MINIMAP_DIRT
	weedable = FULLY_WEEDABLE
	shoefootstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	mediumxenofootstep = FOOTSTEP_SAND
	antipierce = 5

/turf/open/mars_dirt/Initialize(mapload, ...)
	. = ..()
	var/r = rand(0, 32)

	if(r == 0 && icon_state == "mars_dirt_4")
		icon_state = "mars_dirt_1"
		return

	r = rand(0, 32)

	if(r == 0 && icon_state == "mars_dirt_4")
		icon_state = "mars_dirt_2"
		return

	r = rand(0, 6)

	if(r == 0 && icon_state == "mars_dirt_4")
		icon_state = "mars_dirt_7"


// Beach


/turf/open/beach
	name = "Beach"
	icon = 'icons/turf/floors/beach.dmi'

	antipierce = 15

/turf/open/beach/Entered(atom/movable/arrived, old_loc)
	..()

	if(arrived.throwing || !ishuman(arrived))
		return

	var/mob/living/carbon/human/human = arrived
	if(human.bloody_footsteps)
		SEND_SIGNAL(human, COMSIG_HUMAN_CLEAR_BLOODY_FEET)


/turf/open/beach/sand
	name = "Sand"
	icon_state = "sand"
	turf_flags = TURF_MULTIZ|TURF_TRENCHING|TURF_WEATHER_PROOF
	weedable = FULLY_WEEDABLE
	shoefootstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	mediumxenofootstep = FOOTSTEP_SAND

/turf/open/beach/coastline
	name = "Coastline"
	icon = 'icons/turf/beach2.dmi'
	icon_state = "sandwater"
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	weedable = NOT_WEEDABLE
	shoefootstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	mediumxenofootstep = FOOTSTEP_SAND

/turf/open/beach/water
	name = "Water"
	icon_state = "water"
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	weedable = NOT_WEEDABLE
	shoefootstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	mediumxenofootstep = FOOTSTEP_WATER
	heavyxenofootstep = FOOTSTEP_WATER

/turf/open/beach/water2
	name = "Water"
	icon_state = "water"
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	weedable = NOT_WEEDABLE
	shoefootstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	mediumxenofootstep = FOOTSTEP_WATER
	heavyxenofootstep = FOOTSTEP_WATER


//LV ground

/turf/open/gm //Basic groundmap turf parent
	name = "ground dirt"
	icon = 'icons/turf/ground_map.dmi'
	icon_state = "desert"
	turf_flags = TURF_MULTIZ|TURF_TRENCHING|TURF_EFFECT_AFFECTABLE|TURF_WEATHER_PROOF

	antipierce = 10

/turf/open/gm/attackby(obj/item/I, mob/user)

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
		L.set_light_on(TRUE)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)
	return

/turf/open/gm/ex_act(severity) //Should make it indestructible
	return

/turf/open/gm/fire_act(exposed_temperature, exposed_volume)
	return

/turf/open/gm/dirt
	name = "dirt"
	icon_state = "desert"
	baseturfs = /turf/open/gm/dirt
	minimap_color = MINIMAP_DIRT
	shoefootstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	mediumxenofootstep = FOOTSTEP_SAND

/turf/open/gm/dirt/Initialize(mapload, ...)
	. = ..()
	if(rand(0,15) == 0)
		icon_state = "desert[pick("0","1","2","3")]"

/turf/open/gm/grass
	name = "grass"
	icon_state = "grass1"
	baseturfs = /turf/open/gm/grass
	scorchable = "grass1"
	shoefootstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	mediumxenofootstep = FOOTSTEP_GRASS

/turf/open/gm/grass/grass1
	icon_state = "grass1"

/turf/open/gm/grass/grass2
	icon_state = "grass2"

/turf/open/gm/grass/grassbeach
	icon_state = "grassbeach"

/turf/open/gm/grass/grassbeach/north

/turf/open/gm/grass/grassbeach/south
	dir = 1

/turf/open/gm/grass/grassbeach/west
	dir = 4

/turf/open/gm/grass/grassbeach/east
	dir = 8

/turf/open/gm/grass/gbcorner
	icon_state = "gbcorner"

/turf/open/gm/grass/gbcorner/north_west

/turf/open/gm/grass/gbcorner/south_east
	dir = 1

/turf/open/gm/grass/gbcorner/south_west
	dir = 4

/turf/open/gm/grass/gbcorner/north_east
	dir = 8

/turf/open/gm/grass/Initialize(mapload, ...)
	. = ..()

	if(!locate(icon_state) in turf_edgeinfo_cache)
		switch(icon_state)
			if("grass1")
				turf_edgeinfo_cache["grass1"] = GLOB.edgeinfo_full
			if("grass2")
				turf_edgeinfo_cache["grass2"] = GLOB.edgeinfo_full
			if("grassbeach")
				turf_edgeinfo_cache["grassbeach"] = GLOB.edgeinfo_edge
			if("gbcorner")
				turf_edgeinfo_cache["gbcorner"] = GLOB.edgeinfo_corner

/turf/open/gm/dirt2
	name = "dirt"
	icon_state = "dirt"
	baseturfs = /turf/open/gm/dirt2
	minimap_color = MINIMAP_DIRT
	shoefootstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	mediumxenofootstep = FOOTSTEP_SAND

/turf/open/gm/dirtgrassborder
	name = "grass"
	icon_state = "grassdirt_edge"
	baseturfs = /turf/open/gm/dirtgrassborder
	scorchable = "grass1"
	shoefootstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	mediumxenofootstep = FOOTSTEP_SAND

/turf/open/gm/dirtgrassborder/north

/turf/open/gm/dirtgrassborder/south
	dir = 1

/turf/open/gm/dirtgrassborder/west
	dir = 4

/turf/open/gm/dirtgrassborder/east
	dir = 8

/turf/open/gm/dirtgrassborder/grassdirt_corner
	icon_state = "grassdirt_corner"

/turf/open/gm/dirtgrassborder/grassdirt_corner/north_west

/turf/open/gm/dirtgrassborder/grassdirt_corner/north_east
	dir = 1

/turf/open/gm/dirtgrassborder/grassdirt_corner/south_east
	dir = 4

/turf/open/gm/dirtgrassborder/grassdirt_corner/south_west
	dir = 8

/turf/open/gm/dirtgrassborder/grassdirt_corner2
	icon_state = "grassdirt_corner2"

/turf/open/gm/dirtgrassborder/grassdirt_corner2/north_west

/turf/open/gm/dirtgrassborder/grassdirt_corner2/south_east
	dir = 1

/turf/open/gm/dirtgrassborder/grassdirt_corner2/north_east
	dir = 4

/turf/open/gm/dirtgrassborder/grassdirt_corner2/south_west
	dir = 8

/turf/open/gm/dirtgrassborder/Initialize(mapload, ...)
	. = ..()

	if(!locate(icon_state) in turf_edgeinfo_cache)
		switch(icon_state)
			if("grassdirt_edge")
				turf_edgeinfo_cache["grassdirt_edge"] = GLOB.edgeinfo_edge
			if("grassdirt_corner")
				turf_edgeinfo_cache["grassdirt_corner"] = GLOB.edgeinfo_corner
			if("grassdirt_corner2")
				turf_edgeinfo_cache["grassdirt_corner2"] = GLOB.edgeinfo_corner2

/turf/open/gm/dirtgrassborder2
	name = "grass"
	icon_state = "grassdirt2_edge"
	baseturfs = /turf/open/gm/dirtgrassborder2
	shoefootstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	mediumxenofootstep = FOOTSTEP_SAND

/turf/open/gm/river
	name = "river"
	icon_state = "seashallow"
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	weedable = NOT_WEEDABLE
	var/icon_overlay = "riverwater"
	var/covered = 0
	var/covered_name = "grate"
	var/cover_icon = 'icons/turf/floors/filtration.dmi'
	var/cover_icon_state = "grate"
	var/default_name = "river"
	var/no_overlay = FALSE
	var/base_river_slowdown = 1.75
	baseturfs = /turf/open/gm/river
	minimap_color = MINIMAP_WATER
	shoefootstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	mediumxenofootstep = FOOTSTEP_WATER
	heavyxenofootstep = FOOTSTEP_WATER

	layer = UNDER_TURF_LAYER -0.03

/turf/open/gm/river/update_overlays()
	. = ..()
	if(!.)
		return

	if(no_overlay)
		return

	if(covered)
		name = covered_name
		overlays += image("icon"=src.cover_icon,"icon_state"=cover_icon_state,"layer"=CATWALK_LAYER,"dir" = dir)
	else
		name = default_name

/turf/open/gm/river/ex_act(severity)
	if(covered & severity >= EXPLOSION_THRESHOLD_LOW)
		covered = 0
		update_icon()
		spawn(10)
			for(var/atom/movable/atom_movable in src)
				Entered(atom_movable)
				for(var/atom/movable/second_atom_movable in src)
					if(atom_movable == second_atom_movable)
						continue
					second_atom_movable.Crossed(atom_movable)
	if(!covered && HAS_TRAIT(src, TRAIT_FISHING) && prob(5))
		var/obj/item/caught_item = get_fishing_loot(src, get_area(src), 15, 35, 10, 2)
		caught_item.sway_jitter(3, 6)

/turf/open/gm/river/Entered(atom/movable/arrived, old_loc)
	..()

	SEND_SIGNAL(arrived, COMSIG_MOVABLE_ENTERED_RIVER, src, covered)

	if(!iscarbon(arrived) || arrived.throwing)
		return

	if(!iscarbon(arrived))
		return

	if(!covered)
		if(isliving(arrived))
			arrived.AddComponent(/datum/component/mob_overlay_effect, -8, 18)
		var/mob/living/carbon/carbon = arrived
		var/river_slowdown = base_river_slowdown

		if(ishuman(carbon))
			var/mob/living/carbon/human/human = arrived
			cleanup(human)
			if(human.gloves && rand(0,100) < 60)
				if(istype(human.gloves,/obj/item/clothing/gloves/yautja/hunter))
					var/obj/item/clothing/gloves/yautja/hunter/Y = human.gloves
					if(Y && istype(Y) && Y.cloaked)
						to_chat(human, SPAN_WARNING("Your bracers hiss and spark as they short out!"))
						Y.decloak(human, TRUE, DECLOAK_SUBMERGED)

		else if(isxeno(carbon))
			river_slowdown -= 0.7
			if(isboiler(carbon))
				river_slowdown -= 1

		var/new_slowdown = carbon.next_move_slowdown + river_slowdown
		carbon.next_move_slowdown = new_slowdown

		if(carbon.on_fire)
			carbon.ExtinguishMob()

	if(ishuman(arrived))
		var/mob/living/carbon/human/human = arrived
		if(human.bloody_footsteps)
			SEND_SIGNAL(human, COMSIG_HUMAN_CLEAR_BLOODY_FEET)

/turf/open/gm/river/proc/cleanup(mob/living/carbon/human/living)
	if(!living || !istype(living)) return

	if(living.back)
		if(living.back.clean_blood())
			living.update_inv_back(0)
	if(living.wear_suit)
		if(living.wear_suit.clean_blood())
			living.update_inv_wear_suit(0)
	if(living.w_uniform)
		if(living.w_uniform.clean_blood())
			living.update_inv_w_uniform(0)
	if(living.gloves)
		if(living.gloves.clean_blood())
			living.update_inv_gloves(0)
	if(living.shoes)
		if(living.shoes.clean_blood())
			living.update_inv_shoes(0)
	living.clean_blood()


/turf/open/gm/river/stop_crusher_charge()
	return !covered


/turf/open/gm/river/poison/Initialize(mapload, ...)
	. = ..()
	overlays += image("icon"='icons/effects/effects.dmi',"icon_state"="greenglow","layer"=MOB_LAYER+0.1)

/turf/open/gm/river/poison/Entered(mob/living/arrived, old_loc)
	..()
	if(istype(arrived))
		arrived.apply_damage(55,TOX)


/turf/open/gm/river/ocean
	color = "#dae3e2"
	base_river_slowdown = 4 // VERY. SLOW.

/turf/open/gm/river/ocean/Entered(atom/movable/arrived)
	. = ..()
	if(prob(20)) // fuck you
		if(!ismob(arrived))
			return
		var/mob/unlucky_mob = arrived
		var/turf/target_turf = get_random_turf_in_range(arrived.loc, 3, 0)
		var/datum/launch_metadata/LM = new()
		LM.target = target_turf
		LM.range = get_dist(arrived.loc, target_turf)
		LM.speed = SPEED_FAST
		LM.thrower = unlucky_mob
		LM.spin = TRUE
		LM.pass_flags = NO_FLAGS
		to_chat(unlucky_mob, SPAN_WARNING("The ocean currents sweep you off your feet and throw you away!"))
		unlucky_mob.launch_towards(LM)
		return

	if(world.time % 5)
		if(ismob(arrived))
			var/mob/rivermob = arrived
			to_chat(rivermob, SPAN_WARNING("Moving through the incredibly deep ocean slows you down a lot!"))

/turf/open/gm/coast
	name = "coastline"
	icon_state = "beach"
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	weedable = NOT_WEEDABLE
	baseturfs = /turf/open/gm/coast

	layer = UNDER_TURF_LAYER -0.03

/turf/open/gm/coast/Entered(atom/movable/arrived)
	. = ..()
	if(isliving(arrived))
		arrived.AddComponent(/datum/component/mob_overlay_effect, -2, 12)

/turf/open/gm/coast/north

/turf/open/gm/coast/south
	dir = 1

/turf/open/gm/coast/west
	dir = 4

/turf/open/gm/coast/east
	dir = 8

/turf/open/gm/coast/beachcorner
	icon_state = "beachcorner"

/turf/open/gm/coast/beachcorner/north_west

/turf/open/gm/coast/beachcorner/north_east
	dir = 1

/turf/open/gm/coast/beachcorner/south_east
	dir = 4

/turf/open/gm/coast/beachcorner/south_west
	dir = 8

/turf/open/gm/coast/beachcorner2
	icon_state = "beachcorner2"

/turf/open/gm/coast/beachcorner2/north_west

/turf/open/gm/coast/beachcorner2/north_east
	dir = 1

/turf/open/gm/coast/beachcorner2/south_west
	dir = 4

/turf/open/gm/coast/beachcorner2/south_east
	dir = 8

/turf/open/gm/riverdeep
	name = "river"
	icon_state = "seadeep"
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	weedable = NOT_WEEDABLE
	baseturfs = /turf/open/gm/riverdeep
	minimap_color = MINIMAP_WATER
	shoefootstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	mediumxenofootstep = FOOTSTEP_WATER
	heavyxenofootstep = FOOTSTEP_WATER

	layer = UNDER_TURF_LAYER -0.03

/turf/open/gm/riverdeep/Entered(atom/movable/arrived)
	. = ..()
	if(ishuman(arrived))
		arrived.AddComponent(/datum/component/mob_overlay_effect, -16, 28)

/turf/open/gm/river/no_overlay
	no_overlay = TRUE


//ELEVATOR SHAFT-----------------------------------//
/turf/open/gm/empty
	name = "empty space"
	icon = 'icons/turf/open_space.dmi'
	icon_state = "black"
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	density = TRUE


//Nostromo turfs

/turf/open/nostromowater
	name = "ocean"
	desc = "It's a long way down to the ocean from here."
	icon = 'icons/turf/ground_map.dmi'
	icon_state = "seadeep"
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	weedable = NOT_WEEDABLE
	shoefootstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	mediumxenofootstep = FOOTSTEP_WATER
	heavyxenofootstep = FOOTSTEP_WATER

//Ice Colony grounds

//Ice Floor
/turf/open/ice
	name = "ice floor"
	icon = 'icons/turf/ice.dmi'
	icon_state = "ice_floor"
	turf_flags = TURF_MULTIZ|TURF_TRENCHING|TURF_WEATHER_PROOF
	baseturfs = /turf/open/ice
	shoefootstep = FOOTSTEP_ICE
	barefootstep = FOOTSTEP_ICE
	mediumxenofootstep = FOOTSTEP_ICE

	antipierce = 5

//Randomize ice floor sprite
/turf/open/ice/Initialize(mapload, ...)
	. = ..()
	setDir(pick(GLOB.alldirs))

// Colony tiles
/turf/open/asphalt
	name = "asphalt"
	icon = 'icons/turf/floors/asphalt.dmi'
	icon_state = "sunbleached_asphalt"
	baseturfs = /turf/open/asphalt
	mediumxenofootstep = FOOTSTEP_CONCRETE
	barefootstep = FOOTSTEP_CONCRETE
	shoefootstep = FOOTSTEP_CONCRETE

	antipierce = 10

/turf/open/asphalt/cement
	name = "concrete"
	icon_state = "cement5"
/turf/open/asphalt/cement_sunbleached
	name = "concrete"
	icon_state = "cement_sunbleached5"


// Jungle turfs (Whiksey Outpost)


/turf/open/jungle
	name = "wet grass"
	desc = "Thick, long, wet grass."
	icon = 'icons/turf/floors/jungle.dmi'
	icon_state = "grass1"
	var/icon_spawn_state = "grass1"
	turf_flags = TURF_MULTIZ|TURF_TRENCHING|TURF_WEATHER_PROOF
	weedable = FULLY_WEEDABLE
	allow_construction = FALSE
	var/bushes_spawn = TRUE
	var/plants_spawn = TRUE
	baseturfs = /turf/open/jungle
	shoefootstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	mediumxenofootstep = FOOTSTEP_GRASS

	antipierce = 10

/turf/open/jungle/Initialize(mapload, ...)
	. = ..()

	icon_state = icon_spawn_state

	if(plants_spawn && prob(40))
		if(prob(90))
			var/image/I
			if(prob(35))
				I = image('icons/obj/structures/props/jungleplants.dmi',"plant[rand(1,7)]")
			else
				if(prob(30))
					I = image('icons/obj/structures/props/ausflora.dmi',"reedbush_[rand(1,4)]")
				else if(prob(33))
					I = image('icons/obj/structures/props/ausflora.dmi',"leafybush_[rand(1,3)]")
				else if(prob(50))
					I = image('icons/obj/structures/props/ausflora.dmi',"fernybush_[rand(1,3)]")
				else
					I = image('icons/obj/structures/props/ausflora.dmi',"stalkybush_[rand(1,3)]")
			I.pixel_x = rand(-6,6)
			I.pixel_y = rand(-6,6)
			overlays += I
		else
			var/obj/structure/flora/jungle/thickbush/jungle_plant/J = new(src)
			J.pixel_x = rand(-6,6)
			J.pixel_y = rand(-6,6)
	if(bushes_spawn && prob(90))
		new /obj/structure/flora/jungle/thickbush(src)



/turf/open/jungle/proc/Spread(probability, prob_loss = 50)
	if(probability <= 0)
		return
	for(var/turf/open/jungle/J in orange(1, src))
		if(!J.bushes_spawn)
			continue

		var/turf/open/jungle/P = null
		if(J.type == src.type)
			P = J
		else
			P = new src.type(J)

		if(P && prob(probability))
			P.Spread(probability - prob_loss)

/turf/open/jungle/attackby(obj/item/I, mob/user)
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
		L.set_light_on(TRUE)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)
	return

/turf/open/jungle/clear
	icon_state = "grass_clear"
	icon_spawn_state = "grass1"
	bushes_spawn = FALSE
	plants_spawn = FALSE

/turf/open/jungle/path
	name = "dirt"
	desc = "it is very dirty."
	icon = 'icons/turf/floors/jungle.dmi'
	icon_state = "grass_path"
	icon_spawn_state = "dirt"
	minimap_color = MINIMAP_DIRT
	bushes_spawn = FALSE
	shoefootstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	mediumxenofootstep = FOOTSTEP_GRASS

/turf/open/jungle/path/Initialize(mapload, ...)
	. = ..()
	for(var/obj/structure/flora/jungle/thickbush/B in src)
		qdel(B)

/turf/open/jungle/impenetrable
	icon_state = "grass_impenetrable"
	icon_spawn_state = "grass1"
	bushes_spawn = FALSE

/turf/open/jungle/impenetrable/Initialize(mapload, ...)
	. = ..()
	var/obj/structure/flora/jungle/thickbush/B = new(src)
	B.indestructable = TRUE


/turf/open/jungle/water
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/turf/floors//beach.dmi'
	icon_state = "water"
	icon_spawn_state = "water"
	turf_flags = TURF_MULTIZ|TURF_WEATHER_PROOF
	weedable = NOT_WEEDABLE
	bushes_spawn = FALSE
	shoefootstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	mediumxenofootstep = FOOTSTEP_WATER
	heavyxenofootstep = FOOTSTEP_WATER

/turf/open/jungle/water/Initialize(mapload, ...)
	. = ..()
	for(var/obj/structure/flora/jungle/thickbush/B in src)
		qdel(B)

/turf/open/jungle/water/Entered(atom/movable/arrived, old_loc)
	..()
	if(istype(arrived, /mob/living))
		var/mob/living/living = arrived
		//slip in the murky water if we try to run through it
		if(prob(50))
			to_chat(living, pick(SPAN_NOTICE("You slip on something slimy."),SPAN_NOTICE("You fall over into the murk.")))
			living.apply_effect(2, STUN)
			living.apply_effect(1, WEAKEN)

		//piranhas - 25% chance to be an omnipresent risk, although they do practically no damage
		if(prob(25))
			to_chat(living, SPAN_NOTICE("You feel something slithering around your legs."))
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(living)
					if(istype(T, /turf/open/jungle/water))
						to_chat(living, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						living.apply_damage(rand(0,1), BRUTE, sharp=1)
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(living)
					if(istype(T, /turf/open/jungle/water))
						to_chat(living, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						living.apply_damage(rand(0,1), BRUTE, sharp=1)
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(living)
					if(istype(T, /turf/open/jungle/water))
						to_chat(living, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						living.apply_damage(rand(0,1), BRUTE, sharp=1)
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(living)
					if(istype(T, /turf/open/jungle/water))
						to_chat(living, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						living.apply_damage(rand(0,1), BRUTE, sharp=1)

/turf/open/jungle/water/deep
	plants_spawn = 0
	density = TRUE
	icon_state = "water2"
	icon_spawn_state = "water2"
	plants_spawn = FALSE
	density = TRUE




//SHUTTLE 'FLOORS'
//not a child of turf/open/floor because shuttle floors are magic and don't behave like real floors.

/turf/open/shuttle
	name = "floor"
	icon_state = "floor"
	icon = 'icons/turf/shuttle.dmi'
	allow_construction = FALSE
	shoefootstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD
	mediumxenofootstep = FOOTSTEP_PLATING

/turf/open/shuttle/dropship
	name = "floor"
	icon_state = "rasputin1"

/turf/open/shuttle/predship
	name = "ship floor"
	icon_state = "floor6"
	allow_construction = TRUE

//not really plating, just the look
/turf/open/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "plating"

/turf/open/shuttle/brig // Added this floor tile so that I have a separate turf to check in the shuttle -- Polymorph
	name = "Brig floor" // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/open/shuttle/escapepod
	icon = 'icons/turf/escapepods.dmi'
	icon_state = "floor3"

/turf/open/shuttle/lifeboat
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating"
	allow_construction = FALSE

// Elevator floors
/turf/open/shuttle/elevator
	icon = 'icons/turf/elevator.dmi'
	icon_state = "floor"

/turf/open/shuttle/elevator/grating
	icon_state = "floor_grating"
	allow_construction = TRUE


//vehicle interior floors
/turf/open/shuttle/vehicle
	name = "floor"
	icon = 'icons/turf/vehicle_interior.dmi'
	icon_state = "floor_0"

//vehicle interior floors
/turf/open/shuttle/vehicle/med
	name = "floor"
	icon_state = "dark_sterile"
