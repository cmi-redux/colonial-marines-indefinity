/datum/map_template
	var/name = "Default Template Name"
	var/width = 0
	var/height = 0
	var/mappath = null
	var/loaded = 0 // Times loaded this round
	var/datum/parsed_map/cached_map
	var/keep_cached_map = FALSE
	///If true, any openspace turfs above the template will be replaced with ceiling_turf when loading. Should probably be FALSE for lower levels of multi-z ruins.
	var/has_ceiling = FALSE
	///What turf to replace openspace with when has_ceiling is true
	var/turf/ceiling_turf = /turf/open/floor/plating
	///What baseturfs to set when replacing openspace when has_ceiling is true
	var/list/ceiling_baseturfs = list()

/datum/map_template/New(path = null, rename = null, cache = FALSE)
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath, cache)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path, cache = FALSE)
	var/datum/parsed_map/parsed = new(file(path))
	var/bounds = parsed?.bounds
	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = bounds[MAP_MAXY]
		if(cache)
			cached_map = parsed
	return bounds

/datum/parsed_map/proc/initTemplateBounds()
	var/list/obj/structure/cable/cables = list()
	var/list/atom/atoms = list()
	var/list/area/areas = list()

	var/list/turfs = block( locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
							locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	for(var/selected_turf in turfs)
		var/turf/turf = selected_turf
		atoms += turf
		areas |= turf.loc
		for(var/obj in turf)
			atoms += obj
			if(istype(obj, /obj/structure/cable))
				cables += obj
				continue

	SSmapping.reg_in_areas_in_z(areas)
	SSatoms.InitializeAtoms(atoms)

	for(var/turf/turf as anything in turfs)
		if(turf.always_lit)
			continue
		var/area/area = turf.loc
		if(!area.static_lighting)
			continue
		turf.static_lighting_build_overlay()

	//SSmachines.setup_template_powernets(cables)  // mapping TODO:

/datum/map_template/proc/load_new_z()
	var/x = round((world.maxx - width)/2)
	var/y = round((world.maxy - height)/2)

	var/datum/space_level/level = SSmapping.add_new_zlevel(name, list(ZTRAIT_AWAY = TRUE))
	var/datum/parsed_map/parsed = load_map(file(mappath), x, y, level.z_value, no_changeturf=(SSatoms.initialized == INITIALIZATION_INSSATOMS), placeOnTop=TRUE)
	var/list/bounds = parsed.bounds
	if(!bounds)
		return FALSE

	repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	parsed.initTemplateBounds()
	log_game("Z-level [name] loaded at at [x],[y],[world.maxz]")

	return level

/datum/map_template/proc/load(turf/T, centered, delete)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x + width > world.maxx)
		return
	if(T.y + height > world.maxy)
		return

	// Accept cached maps, but don't save them automatically - we don't want
	// ruins clogging up memory for the whole round.
	var/datum/parsed_map/parsed = cached_map || new(file(mappath))
	cached_map = keep_cached_map ? parsed : null
	if(!parsed.load(T.x, T.y, T.z, cropMap = TRUE, no_changeturf = (SSatoms.initialized == INITIALIZATION_INSSATOMS), placeOnTop = TRUE, delete = delete))
		return
	var/list/bounds = parsed.bounds
	if(!bounds)
		return

	//initialize things that are normally initialized after map load
	parsed.initTemplateBounds()

	if(has_ceiling)
		var/affected_turfs = get_affected_turfs(T, FALSE)
		generate_ceiling(affected_turfs)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	return bounds

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))

/datum/map_template/proc/generate_ceiling(affected_turfs)
	for(var/turf/turf in affected_turfs)
		var/turf/ceiling = get_step_multiz(turf, UP)
		if(ceiling)
			if(istype(ceiling, /turf/open/openspace) || istype(ceiling, /turf/open/space/openspace))
				ceiling.ChangeTurf(ceiling_turf, ceiling_baseturfs)

//for your ever biggening badminnery kevinz000
//❤ - Cyberboss
/proc/load_new_z_level(file, name)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()
