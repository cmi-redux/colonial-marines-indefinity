/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "A pool of blood. Someones going to be missing this."
	icon = 'icons/effects/new_blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = ABOVE_WEED_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	cleanable_type = CLEANABLE_BLOOD
	overlay_on_initialize = FALSE
	base_icon = 'icons/effects/blood.dmi'
	var/bloodiness = 4
	var/list/viruses
	var/basecolor= "#830303" // Color when wet.
	var/should_dry = TRUE
	var/dryname = "dried blood" //when the blood lasts long enough, it becomes dry and gets a new name
	var/drydesc = "Looks like it's been here a while. Eew." //as above
	var/drytime = 0
	var/dry_start_time // If this dries, track the dry start time for footstep drying
	garbage = FALSE // Keep for atmosphere

/obj/effect/decal/cleanable/blood/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	viruses = null
	return ..()

/obj/effect/decal/cleanable/blood/Initialize(mapload, b_color)
	. = ..()
	if(b_color)
		basecolor = b_color
	pixel_x = rand(-8,8)
	pixel_y = rand(-8,8)
	if(!should_dry)
		return
	dry_start_time = world.time
	if(bloodiness)
		start_drying()
	else
		dry()
	update_icon()

/obj/effect/decal/cleanable/blood/update_icon()
	if(basecolor == "rainbow")
		basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	color = basecolor

/obj/effect/decal/cleanable/blood/Crossed(atom/movable/AM)
	. = ..()
	// Check if the blood is dry and only humans
	// can make footprints
	if(!bloodiness || !ishuman(AM))
		return

	if(SSticker.mode && MODE_HAS_TOGGLEABLE_FLAG(MODE_BLOOD_OPTIMIZATION))
		return

	var/mob/living/carbon/human/H = AM
	H.add_blood(basecolor, BLOOD_FEET)

	var/dry_time_left = 0
	if(drytime)
		dry_time_left = max(0, drytime - (world.time - dry_start_time))

	if(GLOB.perf_flags & PERF_TOGGLE_NOBLOODPRINTS)
		return

	if(!H.bloody_footsteps)
		H.AddElement(/datum/element/bloody_feet, dry_time_left, H.shoes, bloodiness, basecolor)
	else
		SEND_SIGNAL(H, COMSIG_HUMAN_BLOOD_CROSSED, bloodiness, basecolor, dry_time_left)

/obj/effect/decal/cleanable/blood/process()
	if(world.time > drytime)
		dry()

/obj/effect/decal/cleanable/blood/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/decal/cleanable/blood/proc/get_timer()
	drytime = world.time + 3 MINUTES

/obj/effect/decal/cleanable/blood/proc/start_drying()
	get_timer()
	START_PROCESSING(SSobj, src)

///This is what actually "dries" the blood. Returns true if it's all out of blood to dry, and false otherwise
/obj/effect/decal/cleanable/blood/proc/dry()
	if(bloodiness > 1)
		bloodiness -= 1
		get_timer()
		return FALSE
	else
		name = dryname
		desc = drydesc
		bloodiness = 0
		icon_state = "[icon_state]-old"
		STOP_PROCESSING(SSobj, src)
		return TRUE

/obj/effect/decal/cleanable/blood/can_place_cleanable(obj/effect/decal/cleanable/old_cleanable)
	. = ..()

	var/obj/effect/decal/cleanable/blood/B = old_cleanable
	if(istype(B) && B.bloodiness > bloodiness)
		return FALSE

/obj/effect/decal/cleanable/blood/old
	bloodiness = 0
	icon_state = "floor1-old"

/obj/effect/decal/cleanable/blood/splatter
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7","splatter1","splatter2","splatter3","splatter4","splatter5","splatter6")
	cleanable_type = CLEANABLE_BLOOD_SPLATTER

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = ""
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	cleanable_type = CLEANABLE_BLOOD_GIBS
	var/fleshcolor = "#830303"

/obj/effect/decal/cleanable/blood/gibs/update_icon()
	var/image/giblets = new(base_icon, "[icon_state]_flesh", dir)
	if(!fleshcolor || fleshcolor == "rainbow")
		fleshcolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	giblets.color = fleshcolor

	if(basecolor == "rainbow") basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	color = basecolor

	overlays += giblets

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")


/obj/effect/decal/cleanable/blood/gibs/proc/streak(list/directions)
	var/direction = pick(directions)
	for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
		sleep(3)
		if(i > 0)
			var/obj/effect/decal/cleanable/blood/b = new /obj/effect/decal/cleanable/blood/splatter(src.loc)
			b.basecolor = src.basecolor
			b.update_icon()
			for(var/datum/disease/D in src.viruses)
				var/datum/disease/ND = D.Copy(1)
				LAZYADD(b.viruses, ND)
				ND.holder = b

		if(step_to(src, get_step(src, direction), 0))
			break


/obj/effect/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = "It's red."
	icon_state = "drip5" //using drip5 since the others tend to blend in with pipes & wires.
	random_icon_states = list("drip1","drip2","drip3","drip4","drip5")
	bloodiness = 0
	cleanable_type = CLEANABLE_BLOOD_DRIP
	var/drips = 1
	dryname = "drips of blood"
	drydesc = "It's red."
