/proc/create_all_lighting_objects()
	for(var/area/area in world)
		if(!area.static_lighting)
			continue

		for(var/turf/turf in area)
			new/datum/static_lighting_object(turf)
			CHECK_TICK
		CHECK_TICK
