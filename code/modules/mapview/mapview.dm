///////////////////////
//TACMAP INITIAL INFO//
///////////////////////

//MINIMAP EFFECT TO MOVABLE
/obj/effect/tacmap_detector
	invisibility = 101
	anchored = 1
	var/atom/movable/atom_ref
	var/datum/shape/rectangle/range_bounds

/obj/effect/tacmap_detector/New(atom/movable/follow_ref)
	atom_ref = follow_ref
	range_bounds = new

/obj/effect/tacmap_detector/proc/get_range_bounds()
	var/turf/cur_turf = get_turf(src)
	if(!istype(cur_turf))
		return

	if(!range_bounds)
		range_bounds = new/datum/shape/rectangle
	range_bounds.center_x = cur_turf.x
	range_bounds.center_y = cur_turf.y
	range_bounds.width = atom_ref.sensor_radius * 2
	range_bounds.height = atom_ref.sensor_radius * 2
	return range_bounds

///////////////////////

///////////////////////
/////FACTION DATUM/////
///////////////////////
/datum/tacmap/faction_datum
	var/datum/faction/faction
	var/list/datum/tacmap/mob_datum/faction_mobs_to_draw = list()
	var/list/datum/tacmap/mob_datum/mobs_to_draw = list()

	var/list/enemy_draw = list()
	var/list/passive_scan = list()

/datum/tacmap/faction_datum/New(datum/faction/faction_to_set)
	faction = faction_to_set
	SSmapview.faction_tcmp[faction.faction_name] = src

/datum/tacmap/faction_datum/proc/overlays_to_draw(zlevel)
	if(!enemy_draw[zlevel])
		enemy_draw[zlevel] = TRUE
		spawn(12 SECONDS)
			enemy_draw(zlevel)
			enemy_draw[zlevel] = FALSE
	if(!passive_scan[zlevel])
		passive_scan[zlevel] = TRUE
		spawn(8 SECONDS)
			passive_scan(zlevel)
			passive_scan[zlevel] = FALSE

	var/list/image/images_to_gen = list()
	for(var/datum/tacmap/mob_datum/mob_datum as anything in mobs_to_draw)
		if(mob_datum.atom_ref.z == text2num(zlevel))
			images_to_gen += mob_datum.image_assoc[faction.faction_name]
	for(var/datum/tacmap/mob_datum/mob_datum as anything in faction_mobs_to_draw)
		if(mob_datum.atom_ref.z == text2num(zlevel) && (mob_datum.atom_ref.tacmap_visibly || mob_datum.flags_tacmap & TCMP_INVISIBLY_OV))
			images_to_gen += mob_datum.image_assoc[faction.faction_name]
	return images_to_gen

/datum/tacmap/faction_datum/proc/passive_scan(zlevel)
	for(var/atom/movable/M as anything in SSmapview.minimaps_by_trait["[SSmapping.level_minimap_trait(zlevel)]"].assoc_mobs_datums)
		var/datum/tacmap/mob_datum/tcov = SSmapview.minimaps_by_trait["[SSmapping.level_minimap_trait(zlevel)]"].assoc_mobs_datums[M]
		if(LAZYISIN(mobs_to_draw, tcov))
			continue
		if(tcov.atom_ref_faction != faction)
			var/turf/turf = get_turf(tcov.atom_ref.loc)
			var/turf/roof = turf.get_real_roof()
			if(!roof.air_strike(25, turf, TRUE))
				continue
			mobs_to_draw += tcov
			spawn(4 SECONDS)
				mobs_to_draw -= tcov

/datum/tacmap/faction_datum/proc/enemy_draw()
	for(var/datum/tacmap/mob_datum/tcov as anything in faction_mobs_to_draw)
		var/list/view_candidates = SSquadtree.players_in_range(tcov.tcmp_effect.get_range_bounds(), tcov.atom_ref.z, QTREE_EXCLUDE_OBSERVER | QTREE_SCAN_MOBS)

		for(var/mob/living/M as anything in view_candidates)
			if(M.faction == faction)
				continue
			var/datum/tacmap/mob_datum/tcov_second = SSmapview.assoc_mobs_datums[M]
			if(LAZYISIN(mobs_to_draw, tcov_second))
				continue
			if(faction.faction_is_ally(tcov_second.atom_ref_faction))
				if(tcov_second.atom_ref_faction != faction)
					mobs_to_draw += tcov_second
					spawn(11 SECONDS)
						mobs_to_draw -= tcov_second
			else
				mobs_to_draw += tcov_second
				spawn(11 SECONDS)
					mobs_to_draw -= tcov_second
///////////////////////

///////////////////////
//////////UI///////////
///////////////////////
/datum/ui_minimap
	var/minimap_name = "Tactical Map"
	var/datum/tacmap/faction_datum/faction_tcmp_ref
	var/datum/tacmap/mob_datum/active_marker
	var/list/concurrent_users = list()
	var/datum/tacmap/minimap/map
	var/data_initialized = FALSE

/datum/ui_minimap/New(datum/tacmap/faction_datum/ftcmp_ref, datum/tacmap/minimap/minimap_ref, map_name)
	if(faction_tcmp_ref)
		faction_tcmp_ref = ftcmp_ref
	map = minimap_ref
	minimap_name = map_name
	if(!map)
		error("UI minimap tried to load without map")
		qdel(src)

/datum/ui_minimap/proc/update_all_data(send_update = TRUE)
	data_initialized = TRUE
	if(send_update)
		SStgui.update_uis(src)

/datum/ui_minimap/tgui_interact(mob/user, datum/tgui/ui)
	if(!data_initialized)
		update_all_data()
	// Update UI
	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		var/user_ref = WEAKREF(user)
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living && !(user_ref in concurrent_users))
			concurrent_users += user_ref
		// Open UI
		ui = new(user, src, "Minimap", minimap_name)
		ui.open()
		ui.set_autoupdate(10)

/datum/ui_minimap/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/minimap)
	)

/datum/ui_minimap/ui_data()
	. = list()

	var/list/markers = get_markers()
	if(active_marker)
		.["activeMarker"] = list(
			name = markers[active_marker],
		)
	.["markers"] = list()
	for(var/i in markers)
		var/datum/tacmap/mob_datum/M = markers[i]
		var/marker_color = M.get_color(faction_tcmp_ref.faction)
		.["markers"] += list(list(
			name = i,
			x = M.atom_ref.x,
			y = M.atom_ref.y,
			z = M.atom_ref.z,
			color = marker_color
		))

/datum/ui_minimap/ui_static_data()
	. = list()
	.["map_name"] = map

/datum/ui_minimap/ui_act(action, list/params)
	. = ..()

	if(.)
		return

	if(action == "switch_marker")
		var/c_tag = params["name"]
		var/list/markers = get_markers()
		var/datum/tacmap/mob_datum/M = markers[c_tag]
		active_marker = M

		. = TRUE

/datum/ui_minimap/proc/get_markers()
	if(!faction_tcmp_ref)
		return list()
	var/list/markers_view = list()
	var/list/markers_ally = faction_tcmp_ref.faction_mobs_to_draw
	for(var/datum/tacmap/mob_datum/M as anything in markers_ally)
		if(M.atom_ref.z & map.map_zlevels)
			markers_view["[M.generated_tag_ally]"] = M
	var/list/markers = faction_tcmp_ref.mobs_to_draw
	for(var/datum/tacmap/mob_datum/M as anything in markers)
		if(M.atom_ref.z & map.map_zlevels)
			markers_view["[M.generated_tag]"] = M
	return markers_view

/datum/ui_minimap/ui_close(mob/user)
	var/user_ref = WEAKREF(user)
	// Living creature or not, we remove you anyway.
	concurrent_users -= user_ref
	// Unregister map objects
	user.unset_interaction()

/datum/ui_minimap/ui_state(mob/user)
	return GLOB.always_state
///////////////////////
