/obj/effect/decal/kutjevo_decals
	icon = 'icons/effects/kutjevo_decals.dmi'
	layer = TURF_LAYER

/obj/effect/decal/kutjevo_decals/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
	return

/obj/effect/decal/kutjevo_decals/catwalk
	icon = 'icons/turf/floors/kutjevo/kutjevo_floor.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	layer = CATWALK_LAYER
	desc = "These things have no depth to them, are they just, painted on?"
