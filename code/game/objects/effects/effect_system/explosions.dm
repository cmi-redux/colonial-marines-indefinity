
// EXPLOSION PARTICLES EFFECT

/obj/effect/particle_effect/expl_particles
	name = "explosive particles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/particle_effect/expl_particles/Initialize(mapload, ...)
	. = ..()
	dir = pick(GLOB.alldirs)
	animate(src, 5, alpha = 0, easing = CUBIC_EASING)
	QDEL_IN(src, 5)

/datum/effect_system/expl_particles
	number = 10

/datum/effect_system/expl_particles/set_up(n = 10, c = 0, turf/loca)
	number = n
	if(istype(loca, /turf/)) location = loca
	else location = get_turf(loca)

/datum/effect_system/expl_particles/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		spawn(0)
			var/obj/effect/particle_effect/expl_particles/expl = new /obj/effect/particle_effect/expl_particles(src.location)
			var/direct = pick(GLOB.alldirs)
			for(i=0, i<pick(1;25,2;50,3,4;200), i++)
				sleep(1)
				step(expl,direct)



//EXPLOSION EFFECT

/obj/effect/particle_effect/explosion
	name = "explosive particles"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	opacity = TRUE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -32
	pixel_y = -32

/obj/effect/particle_effect/explosion/New()
	..()
	QDEL_IN(src, 10)



//explosion system

/datum/effect_system/explosion
	number = 1

/datum/effect_system/explosion/set_up(n = 1, c = 0, turf/loca)
	if(istype(loca, /turf/)) location = loca
	else location = get_turf(loca)

/datum/effect_system/explosion/start()
	new/obj/effect/particle_effect/explosion( location )
	var/datum/effect_system/expl_particles/P = new/datum/effect_system/expl_particles()
	P.set_up(10, 0, location)
	P.start()
	spawn(5)
		var/datum/effect_system/smoke_spread/S = new/datum/effect_system/smoke_spread()
		S.set_up(3,0,location,null, 2)
		S.start()
