/obj/effect/landmark/objective_landmark
	name = "Objective Landmark"
	icon_state = "o_white"
	faction_to_get = FACTION_MARINE
	var/objective_spawn_name = "objective"
	var/objective_spawn_weight = 20

/obj/effect/landmark/objective_landmark/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/objective_landmark/LateInitialize()
	var/location
	for(var/obj/structure/structure in loc)
		if(istype(structure, /obj/structure/closet) || istype(structure, /obj/structure/safe) || istype(structure, /obj/structure/filingcabinet))
			location = structure
			break
	if(!location)
		location = get_turf(src)
	GLOB.objective_controller[faction_to_get].add_objective_spawn(objective_spawn_name, objective_spawn_weight, location)
	qdel(src)

/obj/effect/landmark/objective_landmark/close
	name = "Objective Landmark Close"
	icon_state = "o_green"
	objective_spawn_name = "close"

/obj/effect/landmark/objective_landmark/medium
	name = "Objective Landmark Medium"
	icon_state = "o_yellow"
	objective_spawn_name = "medium"

/obj/effect/landmark/objective_landmark/far
	name = "Objective Landmark Far"
	icon_state = "o_red"
	objective_spawn_name = "far"

/obj/effect/landmark/objective_landmark/science
	name = "Objective Landmark Science"
	icon_state = "o_blue"
	objective_spawn_name = "science"
