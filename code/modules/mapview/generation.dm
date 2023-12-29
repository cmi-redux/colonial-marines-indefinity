///Default HUD screen minimap object
/atom/movable/screen/minimap
	name = "Minimap"
	icon = null
	icon_state = ""
	layer = ABOVE_HUD_LAYER
	screen_loc = "1,1"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/datum/tacmap/minimap
	var/map_ref
	//Mobs assoc
	var/list/datum/tacmap/atom_datum/assoc_atom_datums = list()
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

	new_minimap.Scale(new_minimap.Width()*MINIMAP_SCALE,new_minimap.Height()*MINIMAP_SCALE) //scale it up x2 to make it easer to see

	var/atom/movable/screen/minimap/mapview = SSmapview.hud_by_zlevel["[level_to_gen]"]
	if(mapview)
		mapview.icon = new_minimap
	else
		mapview = new
		mapview.icon = new_minimap
		mapview.screen_loc = "[level_to_gen]_mapview:1,1"
		mapview.assigned_map = "[level_to_gen]"
		SSmapview.hud_by_zlevel["[level_to_gen]"] = mapview

	var/icon/flat_map = getFlatIcon(mapview, appearance_flags = TRUE)
	if(!flat_map)
		to_chat(usr, SPAN_WARNING("M: F1 error happened, contact coder."))
	else
		qdel(SSmapview.flat_maps_by_zlevel["[level_to_gen]"])
		SSmapview.flat_maps_by_zlevel["[level_to_gen]"] = flat_map
