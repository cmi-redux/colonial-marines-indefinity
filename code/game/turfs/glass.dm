/turf/open/floor/glass
	name = "glass floor"
	desc = "Don't jump on it, or do, I'm not your mom."
	icon = 'icons/turf/floors/glass.dmi'
	icon_state = "glass"
	base_icon = "glass"
	baseturfs = /turf/open/openspace
	shoefootstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD
	mediumxenofootstep = FOOTSTEP_HARD
	heavyxenofootstep = FOOTSTEP_GENERIC_HEAVY

	special_icon = 0

/turf/open/floor/glass/Initialize(mapload)
	icon_state = "" //Prevent the normal icon from appearing behind the smooth overlays
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/glass/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency)

/turf/open/floor/glass/reinforced
	name = "reinforced glass floor"
	desc = "Do jump on it, it can take it."
	icon = 'icons/turf/floors/reinf_glass.dmi'
	icon_state = "reinf_glass"
	base_icon = "reinf_glass"
	hull_floor = TRUE
