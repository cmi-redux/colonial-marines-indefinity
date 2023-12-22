/turf/open/space
	icon = 'icons/turf/floors/space.dmi'
	name = "space"
	icon_state = "0"
	turf_flags = TURF_MULTIZ
	weedable = NOT_WEEDABLE
	weather_affectable = FALSE
	can_bloody = FALSE
	always_lit = TRUE
	supports_surgery = FALSE
	plane = PLANE_SPACE
	layer = SPACE_LAYER
	vis_flags = VIS_INHERIT_ID

/turf/open/space/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(FALSE)

	vis_contents.Cut() //removes inherited overlays
	visibilityChanged()

	if(flags_atom & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED

	turfs += src

	if(opacity)
		directional_opacity = ALL_CARDINALS

	pass_flags = pass_flags_cache[type]
	if(isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()

	if(!istype(src, /turf/open/space/transit))
		icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

	multiz_turfs()
	if(mapload)
		return INITIALIZE_HINT_ROUNDSTART
	else
		var/turf/T = SSmapping.get_turf_above(src)
		if(T)
			T.multiz_turf_new(src, DOWN)
		T = SSmapping.get_turf_below(src)
		if(T)
			T.multiz_turf_new(src, UP)
		return INITIALIZE_HINT_LATELOAD

/turf/open/space/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/contained_object in contents)
			if(contained_object.flags_obj & OBJ_BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/contained_object in contents)
			if(contained_object.flags_obj & OBJ_BLOCK_Z_IN_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/space/zPassOut(atom/movable/A, direction, turf/destination, allow_anchored_movement)
	if(A.anchored && !allow_anchored_movement)
		return FALSE
	if(direction == DOWN)
		for(var/obj/contained_object in contents)
			if(contained_object.flags_obj & OBJ_BLOCK_Z_OUT_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/contained_object in contents)
			if(contained_object.flags_obj & OBJ_BLOCK_Z_OUT_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/space/basic/New() //Do not convert to Initialize
	//This is used to optimize the map loader
	return

// override for space turfs, since they should never hide anything
/turf/open/space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(FALSE)

/turf/open/space/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if(R.use(1))
			to_chat(user, SPAN_NOTICE(" Constructing support lattice ..."))
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			ReplaceWithLattice()
		return

	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if(S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			S.build(src)
			S.use(1)
			return
		else
			to_chat(user, SPAN_DANGER("The plating is going to need some support."))
	return
