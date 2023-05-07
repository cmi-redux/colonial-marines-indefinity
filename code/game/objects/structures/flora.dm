/*

Plants, trees, etc. If you want to create a plant that can have variations, make sure the .dmi file
has all of the variations with the same prefix and different numbers

Example:
	/obj/structure/flora/plant
		icon_tag = "plant"
		variations = "5"

	when this plant is created, it'll pick one of the five icon states in the dmi file, provided that you have plant_1, plant_3, etc

If you want to make plant cuttable, change it's cut_level var

PLANT_NO_CUT = 1 = Can't be cut down
PLANT_CUT_KNIFE = 2 = Needs at least a bootknife to be cut down
PLANT_CUT_MACHETE = 3 = Needs at least a machete to be cut down


*/

#define PLANT_NO_CUT 1
#define PLANT_CUT_KNIFE 2
#define PLANT_CUT_MACHETE 4

#define FLORA_NO_BURN 0
#define FLORA_BURN_NO_SPREAD 1
#define FLORA_BURN_SPREAD_ONCE 2
#define FLORA_BURN_SPREAD_ALL 4

/obj/structure/flora
	name = "plant"
	anchored = TRUE
	density = TRUE
	var/icon_tag = null
	var/variations = 1
	var/cut_level = PLANT_NO_CUT
	var/cut_hits = 3
	var/fire_flag = FLORA_NO_BURN
	var/center = TRUE //Determine if we want less or more ash when burned
	var/burning = FALSE

/obj/structure/flora/Initialize()
	. = ..()
	if(icon_tag)
		icon_state = "[icon_tag]_[rand(1,variations)]"

/obj/structure/flora/attackby(obj/item/W, mob/living/user)
	if(cut_level &~PLANT_NO_CUT && W.sharp > IS_SHARP_ITEM_SIMPLE)
		if(cut_level & PLANT_CUT_MACHETE && W.sharp == IS_SHARP_ITEM_ACCURATE)
			cut_hits--
		else
			cut_hits = 0
		user.animation_attack_on(src)
		to_chat(user, SPAN_WARNING("You cut [cut_hits > 0 ? "some of" : "all of"] \the [src] away with \the [W]."))
		playsound(src, 'sound/effects/vegetation_hit.ogg', 25, 1)
		if(cut_hits <= 0)
			qdel(src)
	else
		. = ..()

/obj/structure/flora/ex_act(power)
	if(power >= EXPLOSION_THRESHOLD_VLOW)
		deconstruct(FALSE)

/obj/structure/flora/flamer_fire_act()
	fire_act()

/obj/structure/flora/fire_act()
	if(QDELETED(src) || (fire_flag & FLORA_NO_BURN) || burning)
		return
	burning = TRUE
	var/spread_time = rand(75, 150)
	if(!(fire_flag & FLORA_BURN_NO_SPREAD))
		addtimer(CALLBACK(src, PROC_REF(spread_fire)), spread_time)
	addtimer(CALLBACK(src, PROC_REF(burn_up)), spread_time + 5 SECONDS)

/obj/structure/flora/proc/spread_fire()
	for(var/D in  GLOB.cardinals) //Spread fire
		var/turf/T = get_step(src.loc, D)
		if(T)
			for(var/obj/structure/flora/F in T)
				if(fire_flag & FLORA_BURN_SPREAD_ONCE)
					F.fire_flag |= FLORA_BURN_NO_SPREAD
				if(!(locate(/obj/flamer_fire) in T))
					new /obj/flamer_fire(T, create_cause_data("wildfire"))

/obj/structure/flora/proc/burn_up()
	new /obj/effect/decal/cleanable/dirt(loc)
	if(center)
		new /obj/effect/decal/cleanable/dirt(loc) //Produces more ash at the center
	qdel(src)

/obj/structure/flora/ex_act(power)
	if(power >= EXPLOSION_THRESHOLD_VLOW)
		deconstruct(FALSE)

//trees
/obj/structure/flora/tree
	name = "tree"
	pixel_x = -16
	layer = ABOVE_FLY_LAYER

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/structures/props/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/structures/props/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/structures/props/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/joshua
	name = "joshua tree"
	desc = "A tall tree covered in spiky-like needles, covering its trunk."
	icon = 'icons/obj/structures/props/joshuatree.dmi'
	icon_state = "joshua_1"
	pixel_x = 0
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/flora/tree/jungle
	name = "huge tree"
	icon = 'icons/obj/structures/props/ground_map64.dmi'
	desc = "What an enormous tree!"
	density = FALSE
	layer = ABOVE_XENO_LAYER

// LV-624's Yggdrasil Tree
/obj/structure/flora/tree/jungle/bigtreeTR
	icon_state = "bigtreeTR"

/obj/structure/flora/tree/jungle/bigtreeTL
	icon_state = "bigtreeTL"

/obj/structure/flora/tree/jungle/bigtreeBOT
	icon_state = "bigtreeBOT"

//grass
/obj/structure/flora/grass
	name = "grass"
	icon = 'icons/obj/structures/props/ausflora.dmi'
	density = FALSE
	fire_flag = FLORA_BURN_NO_SPREAD
/*

ICE GRASS

*/

/obj/structure/flora/grass/ice
	icon = 'icons/obj/structures/props/snowflora.dmi'
	variations = 3

/obj/structure/flora/grass/ice/brown
	icon_tag = "snowgrassbb"

/obj/structure/flora/grass/ice/green
	icon_tag = "snowgrassgb"

/obj/structure/flora/grass/ice/both
	icon_tag = "snowgrassall"

/*

	DESERT GRASS

*/

/obj/structure/flora/grass/desert
	icon = 'icons/obj/structures/props/dam.dmi'
	icon_state = "lightgrass_1"

/obj/structure/flora/grass/desert/heavy
	icon_state = "heavygrass_1"

/*

	TALLGRASS - SPREADS FIRES

*/

/obj/structure/flora/grass/short_grass
	name = "grass"
	icon = 'icons/obj/flora/grass.dmi'
	icon_state = "grass_short1"
	unslashable = TRUE
	unacidable = TRUE
	cut_level = PLANT_CUT_MACHETE
	layer = UNDER_TURF_LAYER -0.03
	var/overlay_deep = 1
	var/list/image/TallGrassEdgeCache = list()

/obj/structure/flora/grass/short_grass/Initialize()
	. = ..()

	if(!TallGrassEdgeCache || !TallGrassEdgeCache.len)
		TallGrassEdgeCache.len = 10
		TallGrassEdgeCache[SOUTH] = image(icon, "grass_edge_s")
		TallGrassEdgeCache[SOUTH].color = color
		TallGrassEdgeCache[EAST] = image(icon, "grass_edge_e")
		TallGrassEdgeCache[EAST].color = color
		TallGrassEdgeCache[WEST] = image(icon, "grass_edge_w")
		TallGrassEdgeCache[WEST].color = color
		TallGrassEdgeCache[NORTHEAST] = image(icon, "grass_edges_n-w")
		TallGrassEdgeCache[NORTHEAST].color = color
		TallGrassEdgeCache[SOUTHEAST] = image(icon, "grass_edges_s-w")
		TallGrassEdgeCache[SOUTHEAST].color = color
		TallGrassEdgeCache[SOUTHWEST] = image(icon, "grass_edges_s-e")
		TallGrassEdgeCache[SOUTHWEST].color = color

	auto_grass()

/obj/structure/flora/grass/short_grass/Crossed(atom/movable/arrived)
	. = ..()
	if(isliving(arrived))
		arrived.AddComponent(/datum/component/mob_overlay_effect, "short_grass", -4, FALSE)

/obj/structure/flora/grass/short_grass/proc/auto_grass()
	set waitfor = FALSE
	var/turf/T = get_turf(src)
	for(var/i = 0, i <= 3, i++)
		if(!get_step(src, 2**i))
			continue
		T = get_step(src, 2**i)
		if(T && !T.contents.Find(/obj/structure/flora/grass/tall_grass))
			T.overlays += TallGrassEdgeCache[2**i]
	T = get_step(src, NORTHWEST)
	if(!T.contents.Find(/obj/structure/flora/grass/tall_grass))
		T.add_overlay(TallGrassEdgeCache[NORTHWEST])
	T = get_step(src, SOUTHEAST)
	if(!T.contents.Find(/obj/structure/flora/grass/tall_grass))
		T.add_overlay(TallGrassEdgeCache[SOUTHEAST])
	T = get_step(src, SOUTHWEST)
	if(!T.contents.Find(/obj/structure/flora/grass/tall_grass))
		T.add_overlay(TallGrassEdgeCache[SOUTHWEST])

/obj/structure/flora/grass/tall_grass
	name = "tall grass"
	desc = "Even sprats are invisible in it."
	icon = 'icons/obj/flora/grass.dmi'
	icon_state = "grass_tall1"
	unslashable = TRUE
	unacidable = TRUE
	cut_level = PLANT_CUT_MACHETE
	var/overlay_deep = 2
	var/list/diged = list("2" = FALSE, "1" = FALSE, "8" = FALSE, "4" = FALSE)

/obj/structure/flora/grass/tall_grass/Initialize()
	. = ..()
	var/randed = rand(1, 3)
	icon_state = "grass_tall[randed]"

	update_overlays()

/obj/structure/flora/grass/tall_grass/Crossed(atom/movable/arrived)
	. = ..()
	if(isliving(arrived))
		set_diged_ways(GLOB.reverse_dir[arrived.dir])
		arrived.AddComponent(/datum/component/mob_overlay_effect, "tall_grass", 0, FALSE)

/obj/structure/flora/grass/tall_grass/Uncrossed(atom/movable/gone)
	. = ..()
	if(isliving(gone))
		set_diged_ways(gone.dir)

/obj/structure/flora/grass/tall_grass/update_overlays()
	. = ..()
	if(overlays)
		overlays.Cut()

	var/new_overlay = ""
	for(var/i in diged)
		if(diged[i])
			new_overlay += i
	overlays += "[new_overlay]"

/obj/structure/flora/grass/tall_grass/proc/set_diged_ways(dir)
	diged["[dir]"] = TRUE
	update_overlays()
	spawn(1 MINUTES)
		diged["[dir]"] = FALSE
		update_overlays()

// MAP VARIANTS //
// PARENT FOR COLOR, CORNERS AND CENTERS, BASED ON DIRECTIONS //

//TRIJENT - WHISKEY OUTPOST//
/obj/structure/flora/grass/tall_grass/desert
	color = COLOR_G_DES
	fire_flag = FLORA_BURN_SPREAD_ALL

/obj/structure/flora/grass/short_grass/desert
	color = COLOR_G_DES
	fire_flag = FLORA_BURN_SPREAD_ALL

//ICE COLONY - SOROKYNE//
/obj/structure/flora/grass/tall_grass/ice
	color = COLOR_G_ICE
	desc = "A large swathe of bristling snowgrass"

/obj/structure/flora/grass/short_grass/ice
	color = COLOR_G_ICE
	desc = "A large swathe of bristling snowgrass"

//LV - JUNGLE MAPS//

/obj/structure/flora/grass/tall_grass/jungle
	color = COLOR_G_JUNG
	desc = "A clump of vibrant jungle grasses"
	fire_flag = FLORA_BURN_SPREAD_ONCE

/obj/structure/flora/grass/short_grass/jungle
	color = COLOR_G_JUNG
	desc = "A clump of vibrant jungle grasses"
	fire_flag = FLORA_BURN_SPREAD_ONCE

//BUSHES

/*

	SNOW

*/

/obj/structure/flora/bush
	name = "bush"
	icon = 'icons/obj/structures/props/snowflora.dmi'
	icon_state = "snowbush_1"
	density = FALSE
	layer = ABOVE_XENO_LAYER
	fire_flag = FLORA_BURN_NO_SPREAD

/obj/structure/flora/bush/snow
	icon_tag = "snowbush"
	variations = 6

/*

	AUSBUSHES

*/

/obj/structure/flora/bush/ausbushes
	icon = 'icons/obj/structures/props/ausflora.dmi'
	icon_state = "firstbush_1"
	variations = 4
	cut_level = PLANT_CUT_KNIFE
	projectile_coverage = 0//CEASE EATING BULLETS, I BEG YOU

/obj/structure/flora/bush/ausbushes/ausbush
	icon_state = "firstbush_1"
	icon_tag = "firstbush"

/obj/structure/flora/bush/ausbushes/reedbush
	icon_state = "reedbush_1"
	icon_tag = "reedbush"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/palebush
	icon_state = "palebush_1"
	icon_tag = "palebush"

/obj/structure/flora/bush/ausbushes/grassybush
	icon_state = "grassybush_1"
	icon_tag = "grassybush"

/obj/structure/flora/bush/ausbushes/genericbush
	icon_state = "genericbush_1"
	icon_tag = "genericbush"

/obj/structure/flora/bush/ausbushes/pointybush
	icon_state = "pointybush_1"
	icon_tag = "pointybush"

/obj/structure/flora/bush/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"
	icon_tag = "lavendergrass"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/ppflowers
	icon_state = "ppflowers_1"
	icon_tag = "ppflowers"
	layer = BELOW_MOB_LAYER

/*

	AUSBUSHES (3 VARIATIONS)

*/


/obj/structure/flora/bush/ausbushes/var3
	icon_state = "leafybush_1"
	cut_level = PLANT_CUT_KNIFE
	variations = 3

/obj/structure/flora/bush/ausbushes/var3/leafybush
	icon_state = "leafybush_1"
	icon_tag = "leafybush"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/var3/stalkybush
	icon_state = "stalkybush_1"
	icon_tag = "stalkybush"

/obj/structure/flora/bush/ausbushes/var3/fernybush
	icon_state = "fernybush_1"
	icon_tag = "fernybush"

/obj/structure/flora/bush/ausbushes/var3/sunnybush
	icon_state = "sunnybush_1"
	icon_tag = "sunnybush"

/obj/structure/flora/bush/ausbushes/var3/ywflowers
	icon_state = "ywflowers_1"
	icon_tag = "ywflowers"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/var3/brflowers
	icon_state = "brflowers_1"
	icon_tag = "brflowers"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/var3/sparsegrass
	icon_state = "sparsegrass_1"
	icon_tag = "sparsegrass"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/var3/fullgrass
	icon_state =  "fullgrass_1"
	icon_tag = "fullgrass"
	layer = BELOW_MOB_LAYER

/*

	DESERT BUSH

*/

/obj/structure/flora/bush/desert
	icon = 'icons/obj/structures/props/dam.dmi'
	desc = "A small, leafy bush."
	icon_state = "tree_1"
	cut_level = PLANT_CUT_KNIFE
	layer = ABOVE_XENO_LAYER

/obj/structure/flora/bush/desert/cactus
	name = "cactus"
	desc = "It's a small, spiky cactus."
	icon_state = "cactus_3"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/desert/cactus/multiple
	name = "cacti"
	icon_state = "cacti_1"

/*

	POTTED PLANTS

*/

/obj/structure/flora/pottedplant
	name = "potted plant"
	icon = 'icons/obj/structures/props/plants.dmi'
	icon_state = "pottedplant_26"
	density = FALSE

/obj/structure/flora/pottedplant/random
	icon_tag = "pottedplant"
	variations = "30"

/obj/structure/flora/pottedplant/random/unanchored
	anchored = FALSE

/*

	JUNGLE FOLIAGE

*/

/obj/structure/flora/jungle
	name = "jungle foliage"
	icon = 'icons/turf/ground_map.dmi'
	density = FALSE
	layer = ABOVE_XENO_LAYER
	projectile_coverage = PROJECTILE_COVERAGE_NONE


/obj/structure/flora/jungle/shrub
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon_state = "grass4"

/obj/structure/flora/jungle/plantbot1
	name = "strange tree"
	desc = "Some kind of bizarre alien tree. It oozes with a sickly yellow sap."
	icon_state = "plantbot1"

/obj/structure/flora/jungle/planttop1
	name = "strange tree"
	desc = "Some kind of bizarre alien tree. It oozes with a sickly yellow sap."
	icon_state = "planttop1"


/obj/structure/flora/jungle/treeblocker
	name = "huge tree"
	icon_state = "" //will this break it?? - Nope
	density = TRUE

/obj/structure/flora/jungle/vines
	name = "vines"
	desc = "A mass of twisted vines."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "light_1"
	icon_tag = "light"
	variations = 3
	cut_level = PLANT_CUT_MACHETE
	fire_flag = FLORA_BURN_NO_SPREAD

/obj/structure/flora/jungle/vines/heavy
	desc = "A thick, coiled mass of twisted vines."
	opacity = TRUE
	icon_state = "heavy_6"
	icon_tag = "heavy"
	variations = 6

/obj/structure/flora/jungle/vines/heavy/New()
	..()
	icon_state = pick("heavy_1","heavy_2","heavy_3","heavy_4","heavy_5","heavy_6")

/obj/structure/flora/jungle/thickbush
	name = "dense vegetation"
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon = 'icons/obj/structures/props/jungleplants.dmi'
	icon_state = "bush_1"
	layer = BUSH_LAYER
	var/indestructable = 0
	var/stump = 0
	health = 100

/obj/structure/flora/jungle/thickbush/New()
	..()
	health = rand(50,75)
	if(prob(75))
		opacity = TRUE
	setDir(pick(NORTH,EAST,SOUTH,WEST))


/obj/structure/flora/jungle/thickbush/Collided(M as mob)
	if(istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = M
		A.forceMove(get_turf(src))
	else if(ismonkey(M))
		var/mob/A = M
		A.forceMove(get_turf(src))


/obj/structure/flora/jungle/thickbush/Crossed(atom/movable/AM)
	if(!stump)
		if(isliving(AM))
			var/mob/living/L = AM
			var/bush_sound_prob = 60
			if(istype(L, /mob/living/carbon/xenomorph))
				var/mob/living/carbon/xenomorph/X = L
				bush_sound_prob = X.tier * 20

			if(prob(bush_sound_prob))
				var/sound = pick('sound/effects/vegetation_walk_0.ogg','sound/effects/vegetation_walk_1.ogg','sound/effects/vegetation_walk_2.ogg')
				playsound(src.loc, sound, 25, 1)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				var/stuck = rand(0,10)
				switch(stuck)
					if(0 to 4)
						var/new_slowdown = H.next_move_slowdown + rand(2,3)
						H.next_move_slowdown = new_slowdown
						if(prob(2))
							to_chat(H, SPAN_WARNING("Moving through [src] slows you down."))
					if(5 to 7)
						var/new_slowdown = H.next_move_slowdown + rand(4,7)
						H.next_move_slowdown = new_slowdown
						if(prob(10))
							to_chat(H, SPAN_WARNING("It is very hard to move trough this [src]..."))
					if(8 to 9)
						var/new_slowdown = H.next_move_slowdown + rand(8,11)
						H.next_move_slowdown = new_slowdown
						to_chat(H, SPAN_WARNING("You got tangeled in [src]!"))
					if(10)
						var/new_slowdown = H.next_move_slowdown + rand(12,20)
						H.next_move_slowdown = new_slowdown
						to_chat(H, SPAN_WARNING("You got completely tangeled in [src]! Oh boy..."))

/obj/structure/flora/jungle/thickbush/attackby(obj/item/I as obj, mob/user as mob)
	//hatchets and shiet can clear away undergrowth
	if(I && (I.sharp >= IS_SHARP_ITEM_ACCURATE) && !stump)
		var/damage = rand(2,5)
		if(istype(I,/obj/item/weapon/melee/claymore/mercsword))
			damage = rand(8,18)
		if(indestructable)
			//this bush marks the edge of the map, you can't destroy it
			to_chat(user, SPAN_DANGER("You flail away at the undergrowth, but it's too thick here."))
		else
			user.visible_message(SPAN_DANGER("[user] flails away at the  [src] with [I]."),SPAN_DANGER("You flail away at the [src] with [I]."))
			playsound(src.loc, 'sound/effects/vegetation_hit.ogg', 25, 1)
			health -= damage
			if(health < 0)
				to_chat(user, SPAN_NOTICE("You clear away [src]."))
			healthcheck()
	else
		return ..()

/obj/structure/flora/jungle/thickbush/proc/healthcheck()
	if(health < 35 && opacity)
		opacity = FALSE
	if(health < 0)
		if(prob(10))
			icon_state = "stump[rand(1,2)]"
			name = "cleared foliage"
			desc = "There used to be dense undergrowth here."
			stump = 1
			pixel_x = rand(-6,6)
			pixel_y = rand(-6,6)
		else
			qdel(src)

/obj/structure/flora/jungle/thickbush/flamer_fire_act(dam = BURN_LEVEL_TIER_1)
	health -= dam
	healthcheck(src)


/obj/structure/flora/jungle/thickbush/jungle_plant
	icon_state = "plant_1"
	desc = "Looks like some of that fruit might be edible."
	icon_tag = "plant"
	variations  = 7























/*
var/list/world_trees = list()

/obj/structure/stalker/flora/trees
	name = "tree"
	name_ru = "������"
	icon = 'icons/stalker/structure/flora/derevya.dmi'
	layer = 3.2
	density = 0
	opacity = 0
	cast_shadow = TRUE

	alive
		icon_state = "topol1"
		icon_height = 54
		topol
			icon_state = "topol1"
			icon_height = 54

		bereza1
			icon_state = "bereza1"
			icon_height = 51

		bereza2
			icon_state = "bereza2"
			icon_height = 50

		bereza3
			icon_state = "bereza3"
			icon_height = 58

		bereza4
			icon_state = "bereza4"
			icon_height = 58

		el1
			icon_state = "el1"
			icon_height = 57

		el2
			icon_state = "el2"
			icon_height = 59

	leafless
		derevo1
			icon_state = "derevo1ll"

		derevo2
			icon_state = "derevo2ll"

		derevo3
			icon_state = "derevo3ll"

		bereza1
			icon_state = "bereza1ll"

		bereza2
			icon_state = "bereza2ll"

/obj/structure/stalker/flora/trees/Initialize()
	. = ..()
	pixel_x = rand(-16, 16)
	pixel_y = rand(-4,0)
	overlays += image('icons/stalker/structure/flora/krona.dmi', icon_state = icon_state, layer = 6.1)
	overlays += image('icons/stalker/structure/flora/krona2.dmi', icon_state = icon_state, layer = 4.9)
	world_trees += src

/obj/structure/stalker/flora/trees/attackby(obj/item/I, mob/user, params)
	if(flags & IN_PROGRESS)
		return

	if(istype(I,/obj/item/weapon/kitchen/knife))
		flags += IN_PROGRESS
		user << user.client.select_lang("<span class='notice'>�� ������ ������� ����� ����� � ������.</span>","<span class='notice'>You started cutting dead branches from a tree.</span>")
		if(!do_after(user, 100, target = src))
			flags &= ~IN_PROGRESS
			return
		flags &= ~IN_PROGRESS
		var/B = new /obj/item/stalker/brushwood
		user.put_in_hands(B)
		user << user.client.select_lang("<span class='notice'>�� ������� ������� ��������!</span>","<span class='notice'>You've gathered some brushwood!</span>")

/obj/structure/stalker/flora/grass
	name = "grass"
	name_ru = "�����"
	icon = 'icons/obj/flora/ausflora.dmi'
	layer = 2.75
	mouse_opacity = 0

/obj/structure/stalker/flora/grass/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item))
		return

/obj/structure/stalker/flora/grass/forest
	icon_state = "greengrass_1"

/obj/structure/stalker/flora/grass/forest/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/stalker/flora/grass/forest/LateInitialize()
	var/pixeling = 1
//	var/area/A = get_area(src)
//	if(istype(A, /area/stalker/blowout/outdoor/anomaly))
	var/state = pickweight(list("greengrass" = 48,"trees" = 10, "greenbush" = 15, "rocks" = 3, "darkbush" = 6, "treebush" = 10,"bush" = 1, "branch" = 4, "tall_grass" = 2, "stump" = 1))
	switch(state)
		if("greengrass")
			icon_state = "greengrass_[rand(1, 6)]"
		if("greenbush")
			icon_state = "greengrass_[rand(1, 6)]"
			var/obj/structure/stalker/flora/grass/bush/B = new(loc)
			B.icon_state = "greenbush_[rand(1, 4)]"
			if(prob(5))
				B.berry_type = pick("red", "orange", "blue", "green", "white", "black")
				B.grow_berries()
				if(!B.berry_type == "green")
					B.pixel_x = rand(-16,16)
					B.pixel_y = rand(-16,16)
		if("rocks")
			name = "rocks"
			icon = 'icons/obj/flora/rocks.dmi'
			icon_state = "rocks_[rand(1, 5)]"
			layer = 2.74
		if("darkbush")
			name = "bush"
			icon_state = "firstbush_[rand(1, 4)]"
		if("treebush")
			name = "bush"
			opacity = 0
			layer = 2.76
			if(prob(50))
				icon_state = "treebush_[rand(1, 4)]"
			else
				icon_state = "palebush_[rand(1, 4)]"
		if("bush")
			var/canspawn = 1
			var/near_t = range(1, src)
			if((locate(/turf/simulated/wall) in near_t) || (locate(/turf/stalker/floor/asphalt) in near_t) || (locate(/turf/stalker/floor/road) in near_t))
				canspawn = 0
			if(canspawn)
				var/num = rand(1,3)
				var/obj/structure/stalker/flora/grass/big_bush/ld = new(loc)
				ld.icon_state = "bush[num]_1"
				ld.overlays += image(icon = 'icons/stalker/structure/flora/bushes.dmi', icon_state = "[ld.icon_state]_overlay", layer = 5.6)
				var/obj/structure/stalker/flora/grass/big_bush/rd = new(locate(x+1,y,z))
				rd.icon_state = "bush[num]_2"
				rd.overlays += image(icon = 'icons/stalker/structure/flora/bushes.dmi', icon_state = "[rd.icon_state]_overlay", layer = 5.6)
				var/obj/structure/stalker/flora/grass/big_bush/lu = new(locate(x,y+1,z))
				lu.icon_state = "bush[num]_3"
				lu.overlays += image(icon = 'icons/stalker/structure/flora/bushes.dmi', icon_state = "[lu.icon_state]_overlay", layer = 5.6)
				var/obj/structure/stalker/flora/grass/big_bush/ru = new(locate(x+1,y+1,z))
				ru.icon_state = "bush[num]_4"
				ru.overlays += image(icon = 'icons/stalker/structure/flora/bushes.dmi', icon_state = "[ru.icon_state]_overlay", layer = 5.6)
			qdel(src)
		if("branch")
			name = "branch"
			icon = 'icons/obj/flora/wasteland.dmi'
			icon_state = "branch_[rand(1, 4)]"
			layer = 2.73
		if("tall_grass")
			icon_state = "tall_grass_[rand(1, 4)]"
//		if("flowers")
//			icon_state = "flowers_[rand(1, 14)]"
		if("stump")
			var/S = /obj/structure/stalker/pen
			new S(loc)
		if("trees")
			var/canspawn = 1
			var/near_t = range(1, src)
			if((locate(/turf/simulated/wall) in near_t) || (locate(/turf/stalker/floor/asphalt) in near_t) || (locate(/turf/stalker/floor/road) in near_t))
				canspawn = 0													//��������� ���� �� ����� ����� ��� ������
			if(canspawn)
				var/obj/structure/stalker/flora/trees/tree = pick(typesof(/obj/structure/stalker/flora/trees/alive))
				new tree(loc)

	if(pixeling)
		pixel_x = rand(-16,16)
		pixel_y = rand(-16,16)

	CHECK_TICK

/obj/structure/stalker/flora/grass/big_bush
	name = "bush"
	icon = 'icons/stalker/structure/flora/bushes.dmi'
	icon_state = "bush 0,0"
	opacity = TRUE
	layer = 3.5

/obj/structure/stalker/flora/grass/bush
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "greenbush_1"
	layer = 3.5
	mouse_opacity = 1
	var/berry_type = null
	var/berries = 0

/obj/structure/stalker/flora/grass/bush/proc/grow_berries()
	if(!berry_type || berries)
		return
	overlays += "[berry_type]_berries"
	if(berry_type == "green")
		set_light(1, 1, rgb(30,160,0))
	berries = 1

/obj/structure/stalker/flora/grass/bush/attack_hand(mob/user)
	if(berries)
		user << user.client.select_lang("<span class='notice'>�� ������ �������� �����.</span>","<span class='notice'>You started to gather berries.</span>")
		if(do_after(user, 100, target = src))
			user << user.client.select_lang("<span class='notice'>�� ������� ������� ����!</span>","<span class='notice'>You've gathered some berries!</span>")
			var/berr
			switch(berry_type)
				if("red")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/red
				if("orange")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/orange
				if("blue")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/blue
				if("green")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/green
				if("white")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/white
				if("black")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/black
			user.put_in_hands(berr)
			overlays -= "[berry_type]_berries"
			berries = 0
			set_light(0)
			spawn(6000)
				grow_berries()


/obj/structure/stalker/flora/grass/dry
	icon = 'icons/obj/flora/wasteland.dmi'
	icon_state = "tall_grass_4"

/obj/structure/stalker/flora/grass/dry/New()
	var/state = pickweight(list("grass" = 30, "grass_2" = 15, "branch" = 5, "trees" = 10, "null" = 40))
	switch(state)
		if("grass")
			icon_state = "tall_grass_[rand(1, 4)]"
		if("grass_2")
			icon_state = "tall_grass_[rand(5, 8)]"
		if("branch")
			name = "branch"
			icon_state = "branch_[rand(1, 4)]"
			layer = 2.73
		if("null")
			qdel(src)
		if("trees")
			var/canspawn = 1
			var/d_canspawn = 1
			var/b_canspawn = 1
			var/D1 = /obj/structure/stalker/flora/trees/leafless/derevo1
			var/D2 = /obj/structure/stalker/flora/trees/leafless/derevo2
			var/D3 = /obj/structure/stalker/flora/trees/leafless/derevo3
			var/B1 = /obj/structure/stalker/flora/trees/leafless/bereza1
			var/B2 = /obj/structure/stalker/flora/trees/leafless/bereza2
			var/near = range(3, src)											//��������� ���� �� ����� ������ ������� �������
			if((locate(D1) in near) || (locate(D2) in near) || (locate(D3) in near))
				d_canspawn = 0
				if((locate(B1) in near) || (locate(B2) in near))
					b_canspawn = 0

			var/near_t = range(1, src)
			if((locate(/turf/simulated/wall) in near_t) || (locate(/turf/stalker/floor/asphalt) in near_t) || (locate(/turf/stalker/floor/road) in near_t) || (locate(/turf/stalker/floor/tropa) in near_t))
				canspawn = 0													//��������� ���� �� ����� ����� ��� ������

			if(canspawn)														//������� �������
				if(d_canspawn)
					var/d_state = pickweight(list("1" = 33, "2" = 33, "3" = 33))
					switch(d_state)
						if("1")
							new D1(loc)
						if("2")
							new D2(loc)
						if("3")
							new D3(loc)
				else if(b_canspawn)
					if(prob(50))
						new B1(loc)
					else
						new B2(loc)


	pixel_x = rand(-16,16)
	pixel_y = rand(-16,16)

/obj/structure/stalker/flora/grass/swamp/reed
	icon_state = "reedbush_1"

/obj/structure/stalker/flora/grass/swamp/reed/New()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/stalker/flora/grass/swamp/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/stalker/flora/grass/swamp/stalkybush/New()
	icon_state = "stalkybush_[rand(1, 3)]"




FOG EFFECT LITTLE
atom/proc/WaterEffect()
    var/start = filters.len
    var/X,Y,rsq,i,f
    for(i in 1 to 7)
        // choose a wave with a random direction and a period between 10 and 30 pixels
        do
            X = 60*rand() - 30
            Y = 60*rand() - 30
            rsq = X*X + Y*Y
        while(rsq<100 || rsq>900)   // keep trying if we don't like the numbers
        // keep distortion (size) small, from 0.5 to 3 pixels
        // choose a random phase (offset)
        filters += filter(type="wave", x=X, y=Y, size=rand()*2.5+0.5, offset=rand(), flags = WAVE_BOUNDED)
    for(i=1, i<=WAVE_COUNT, ++i)
        // animate phase of each wave from its original phase to phase-1 and then reset;
        // this moves the wave forward in the X,Y direction
        f = filters[start+i]
        animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
        animate(offset=f:offset-1, time=rand()*20+10)



You can also try using different layers, just use two images for one foreground tree, an image of opaque tree will have lower layer than the player and an image that is slightly transparent will have layer higher than the player
I'm using this method to "unhide" people from trees




I get what you mentioned about alpha masking now.
So for you to do that, this is what you would want: 1) Create a plane master for the weather alpha channel. 2) Every area should have black or white icons that render to that plane. 3) Give the plane master a render target starting with an asterisk. 4) Use the alpha plane as a render source for your alpha mask filter on the weather plane that has the particles.
Vallat — 22.07.2021 19:27
I bet I've already tried that, but maybe I incorrectly used render source, let's try, thanks for advise
Hope that will work
Aaand it works
And that was as simple as I expected, thanks Lummox!
The funniest thing is that I was trying to add alpha filter to the weather plane using area as a render source
And was complaining about things not working



*/
