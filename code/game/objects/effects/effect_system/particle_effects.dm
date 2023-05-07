

//the objects used by /datum/effect_system

/obj/effect/particle_effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE // So effect are not targeted by alien acid.

/obj/effect/particle_effect/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if(PF)
		PF.flags_pass = PASS_OVER|PASS_AROUND|PASS_UNDER|PASS_THROUGH|PASS_MOB_THRU

	//Fire
/obj/effect/particle_effect/fire  //Fire that ignites mobs and deletes itself after some time, but doesn't mess with atmos. Good fire flamethrowers and incendiary stuff.
	name = "fire"
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	var/life = 0.5 SECONDS
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/particle_effect/fire/New()
	if(!istype(loc, /turf))
		qdel(src)
	addtimer(CALLBACK(src, PROC_REF(handle_extinguish)), life)

	setDir(pick( GLOB.cardinals))
	set_light(3)

	for(var/mob/living/L in loc)//Mobs
		L.fire_act()
	for(var/obj/effect/alien/weeds/weeds in loc)//Weeds
		weeds.fire_act()
	for(var/obj/effect/alien/egg/egg in loc)//Eggs
		egg.fire_act()
	for(var/obj/structure/bed/nest/nest in loc)//Nests
		nest.fire_act()

/obj/effect/particle_effect/fire/proc/handle_extinguish()
	if(istype(loc, /turf))
		set_light(0)
	qdel(src)

/obj/effect/particle_effect/fire/Crossed(mob/living/L)
	..()
	if(isliving(L))
		L.fire_act()

	//End fire

/obj/effect/particle_effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	var/life = 15
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/particle_effect/water/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if(PF)
		PF.flags_pass = PASS_THROUGH|PASS_OVER|PASS_MOB_THRU|PASS_UNDER

/obj/effect/particle_effect/water/Move(turf/NewLoc, direction)
	//var/turf/T = src.loc
	//if(istype(T, /turf))
	//	T.firelevel = 0 //TODO: FIX
	if(--src.life < 1)
		//SN src = null
		qdel(src)
	if(NewLoc.density)
		return 0
	.=..()

/obj/effect/particle_effect/water/Collide(atom/A)
	if(reagents)
		reagents.reaction(A)
	return ..()


/////////////////////
//////PARTICLES//////
/////////////////////

/particles
	icon = 'icons/effects/particles.dmi'

//FIRE
/*
/atom/movable/particle_emitter/fire_emitter
    spawn_count = 15
    particles_type = /particles/fire
    filters = list(filter(type = "outline", size = 1, color = rgb(213, 82, 10)))*/

/particles/fire
	width = 400
	height = 400
	color = rgb(232, 162, 15)
	lifespan = 7
	fade = 3
	spawning = 15
	velocity = generator("vector", list(0, 0.5), list(0, 3), UNIFORM_RAND)
	position = generator("vector", list(-5, 0), list(4, 0), NORMAL_RAND)
	icon_state = "fire"
	gradient = list(rgb(232, 202, 15), 1, rgb(255, 183, 33, 70))
	color_change = 0.5

/particles/fog
	width = 64
	height = 128
	color = rgb(61, 82, 81)

/particles/smoke
	width = 64
	height = 128
	count = 20000
	spawning = 10
	gravity = list(0, 1)
	bound1 = list(-1000, 0, -1000)
	lifespan = 60
	fade = 100
	position = generator("box", list(-5,0,0), list(5,0,0))
	drift = generator("sphere", -5, 5)
	velocity = 2
	friction = 0.5
	color = rgb(0, 0, 0, 40)

/particles/smoke
	width = 64
	height = 128
	count = 20000
	spawning = 10
	gravity = list(0, 1)
	bound1 = list(-1000, 0, -1000)
	lifespan = 60
	fade = 100
	position = generator("box", list(-5,0,0), list(5,0,0))
	drift = generator("sphere", -5, 5)
	velocity = 2
	friction = 0.5
	color = "black"
/*
/atom/movable/particle_emitter/jarka_jet
    spawn_count = 50
    despawn_delay = 50
    layer_offset = -0.01
    particles_type = /particles/jarka_jet
    filters = list(filter(type = "outline", size = 1, color = rgb(182, 76, 39)))

/particles/jarka_jet
    width = 400
    height = 400
    color = rgb(232, 162, 15)
    count = 1000
    lifespan = 7
    fade = 40
    spawning = 0//    50
    velocity = generator("vector", list(-2, 12), list(2, 12), NORMAL_RAND)
    position = generator("vector", list(-2, 0), list(2, 0), NORMAL_RAND)
    drift = generator("vector", list(-0.1, -0.1), list(0.1, 0.1))
    icon = 'icons/effects/particles.dmi'
    icon_state = "fire"
    gradient = list(1, rgb(255, 255, 255, 10), 1.2, 2, rgb(253, 223, 171), 3, rgb(241, 164, 82), 4, rgb(237, 127, 90))
    color_change = 0.5


        var/times = 12
        while(times > 0.5)
            particles.velocity = generator("vector", list(-times/6, times), list(times/6, times), NORMAL_RAND)
            times -= times / sqrt(times)
            particles.spawning -= 0.25
            sleep(0.5)
        animate(src, alpha = 0, time = 10)
        sleep(10)
        particles = null

*/
