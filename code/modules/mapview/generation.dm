#define MINIMAP_FILE_DIR "maps/minimaps/"

/datum/tacmap/minimap
	///Actual icon of the drawn zlevel with all of it's atoms
	var/list/icon/minimap_layers = list()
	//Mobs assoc
	var/list/datum/tacmap/mob_datum/assoc_mobs_datums = list()
	///x offset of the actual icon to center it to screens
	var/x_offset = 0
	///y offset of the actual icons to keep it to screens
	var/y_offset = 0

	var/map_trait
	var/list/map_zlevels = list()
	var/list/sizes = list()

/datum/tacmap/minimap/New(trait)
	map_trait = trait
	map_zlevels = SSmapping.levels_by_trait(map_trait)
	for(var/level in map_zlevels)
		map_zlevels += level
		generate_minimap(level)

/datum/tacmap/minimap/proc/generate_minimap(level_to_gen)
	var/icon/new_minimap = new('icons/minimap.dmi') //480x480 blank icon template for drawing on the map

	for(var/xval = 1 to world.maxx)
		for(var/yval = 1 to world.maxy) //Scan all the turfs and draw as needed
			var/turf/turf = locate(xval, yval, level_to_gen)
			var/turf/turf_above = SSmapping.get_turf_above(turf)
			if(istype(turf, /turf/open/space))
				new_minimap.DrawBox(rgb(0,0,0), turf.x, turf.y)
				continue
			if(is_ground_level(level_to_gen))
				if(istype(turf_above, /turf/closed/wall/rock))
					new_minimap.DrawBox(rgb(0,0,0), turf.x, turf.y)
					continue
			if(locate(/obj/structure/cargo_container) in turf)
				new_minimap.DrawBox(rgb(120,120,120), turf.x, turf.y)
				continue
			if(istype(turf, /turf/open/gm/river))
				new_minimap.DrawBox(rgb(150,150,240), turf.x, turf.y)
				continue
			if(istype(turf, /turf/open/gm/dirt))
				new_minimap.DrawBox(rgb(140,140,140), turf.x, turf.y)
				continue
			if(locate(/obj/structure/fence) in turf)
				new_minimap.DrawBox(rgb(55,55,55), turf.x, turf.y)
				continue
			if(locate(/obj/structure/machinery/door) in turf)
				new_minimap.DrawBox(rgb(50,50,50), turf.x, turf.y)
				continue
			if(locate(/obj/structure/window_frame) in turf || locate(/obj/structure/window/framed) in turf)
				new_minimap.DrawBox(rgb(40,40,40), turf.x, turf.y)
				continue
			if(istype(turf, /turf/closed/wall/almayer/outer))
				new_minimap.DrawBox(rgb(20,20,20), turf.x, turf.y)
				continue
			if(istype(turf, /turf/closed/wall))
				new_minimap.DrawBox(rgb(30,30,30), turf.x, turf.y)
				continue
			if(istype(turf_above, /turf/open/openspace))
				new_minimap.DrawBox(rgb(160,160,160), turf.x, turf.y)
				continue
			if(istype(turf_above, /turf/open/floor/glass))
				new_minimap.DrawBox(rgb(120,120,120), turf.x, turf.y)
				continue
			if(istype(turf_above, /turf/open/floor/roof/asphalt))
				new_minimap.DrawBox(rgb(100,100,100), turf.x, turf.y)
				continue
			if(istype(turf_above, /turf/open/floor/roof/metal))
				new_minimap.DrawBox(rgb(80,80,80), turf.x, turf.y)
				continue
			if(istype(turf_above, /turf/open/floor/roof/sheet) || istype(turf_above, /turf/open/floor/roof/ship_hull))
				new_minimap.DrawBox(rgb(60,60,60), turf.x, turf.y)
				continue
			if(istype(turf, /turf/open/space))
				new_minimap.DrawBox(rgb(0,0,0), turf.x, turf.y)
				continue

	new_minimap.Scale(480*2,480*2) //scale it up x2 to make it easer to see
	new_minimap.Crop(1, 1, min(new_minimap.Width(), 480), min(new_minimap.Height(), 480)) //then cut all the empty pixels

	var/largest_x = 0
	var/smallest_x = SCREEN_PIXEL_SIZE
	var/largest_y = 0
	var/smallest_y = SCREEN_PIXEL_SIZE
	for(var/xval=1 to SCREEN_PIXEL_SIZE step 2) //step 2 is twice as fast :)
		for(var/yval=1 to SCREEN_PIXEL_SIZE step 2) //keep in mind 1 wide giant straight lines will offset wierd but you shouldnt be mapping those anyway right???
			if(!new_minimap.GetPixel(xval, yval))
				continue
			if(xval > largest_x)
				largest_x = xval
			else if(xval < smallest_x)
				smallest_x = xval
			if(yval > largest_y)
				largest_y = yval
			else if(yval < smallest_y)
				smallest_y = yval
	sizes = list(largest_x, largest_y, smallest_x, smallest_y)

	x_offset = FLOOR((SCREEN_PIXEL_SIZE-largest_x-smallest_x)/2, 1)
	y_offset = FLOOR((SCREEN_PIXEL_SIZE-largest_y-smallest_y)/2, 1)

	new_minimap.Shift(EAST, x_offset)
	new_minimap.Shift(NORTH, y_offset)

	minimap_layers["[level_to_gen]"] = new_minimap

	fcopy(new_minimap, "[MINIMAP_FILE_DIR][level_to_gen].dmi")
