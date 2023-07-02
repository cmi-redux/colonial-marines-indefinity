#define WAIT_MAPVIEW_READY while(!SSmapview.initialized) {stoplag();}

SUBSYSTEM_DEF(mapview)
	name		= "Mapview"
	wait		= 1 SECONDS
	flags		= SS_POST_FIRE_TIMING
	runlevels	= RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	priority	= SS_PRIORITY_MAPVIEW
	init_order	= SS_INIT_MAPVIEW

	var/force_update_minimaps = FALSE
	var/generating_coldown = 15 MINUTES
	COOLDOWN_DECLARE(generate_minimaps)

	var/list/datum/tacmap/faction_datum/faction_tcmp = list()
	var/list/datum/tacmap/minimap/minimaps_by_trait = list()
	var/list/datum/tacmap/mob_datum/assoc_mobs_datums = list()
	var/list/datum/callback/removal_cbs = list()

/datum/controller/subsystem/mapview/stat_entry(msg)
	msg = "F:[length(faction_tcmp)]|M:[length(removal_cbs)]|P:[length(minimaps_by_trait)]"
	return ..()

/datum/controller/subsystem/mapview/Initialize(start_timeofday)
	INIT_ANNOUNCE("Генерация миникарт...")
	var/start_time = REALTIMEOFDAY
	for(var/trait in TCMP_MAPS_TRAITS)
		var/datum/tacmap/minimap/map_datum = new(trait)
		minimaps_by_trait["[trait]"] = map_datum
	COOLDOWN_START(src, generate_minimaps, generating_coldown)
	INIT_ANNOUNCE("Генерация миникарт выполнена за [(REALTIMEOFDAY - start_time)/10] секунд!")
	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapview/Recover()
	faction_tcmp = SSmapview.faction_tcmp
	minimaps_by_trait = SSmapview.minimaps_by_trait
	assoc_mobs_datums = SSmapview.assoc_mobs_datums
	removal_cbs = SSmapview.removal_cbs

/datum/controller/subsystem/mapview/fire(resumed)
	if(force_update_minimaps || COOLDOWN_FINISHED(src, generate_minimaps))
		update_minimaps(!force_update_minimaps)

/datum/controller/subsystem/mapview/proc/update_minimaps(coldown)
	set waitfor = FALSE

	if(coldown)
		COOLDOWN_START(src, generate_minimaps, generating_coldown)
	else
		force_update_minimaps = FALSE

	spawn()
		message_admins("started updating minimaps")
		for(var/trait in TCMP_MAPS_TRAITS)
			var/datum/tacmap/minimap/minimap = minimaps_by_trait["[trait]"]
			for(var/level in minimap.map_zlevels)
				minimap.generate_minimap(level)
				sleep(1)

		message_admins("finished updating minimaps")

/datum/controller/subsystem/mapview/proc/get_minimap_ui(datum/faction/faction, zlevel, map_name)
	set waitfor = FALSE
	WAIT_MAPVIEW_READY
	return new /datum/ui_minimap(faction?.tcmp_faction_datum, minimaps_by_trait["[SSmapping.level_minimap_trait(zlevel)]"], map_name)


///////////////////////
//MARKERS PROCCESSING//
///////////////////////
/datum/controller/subsystem/mapview/proc/add_marker(atom/movable/atom_ref, iconstate, recoloring = TRUE, rotating = FALSE, custom_color, flags)
	set waitfor = FALSE
	WAIT_MAPVIEW_READY

	if(assoc_mobs_datums[atom_ref])
		error("Trying to add marker with mob already in marker system [atom_ref], caution!")
		return
	if(!minimaps_by_trait["[SSmapping.level_minimap_trait(atom_ref.z)]"])
		return
	if(!atom_ref?.faction || !atom_ref?.faction?.faction_name || !atom_ref?.faction)
		error("Trying to add marker without faction [atom_ref], [atom_ref?.faction], caution!")
		return

	var/datum/tacmap/mob_datum/new_mob_datum = new(atom_ref, iconstate, recoloring, rotating, custom_color, flags)
	assoc_mobs_datums[atom_ref] = new_mob_datum
	minimaps_by_trait["[SSmapping.level_minimap_trait(atom_ref.z)]"].assoc_mobs_datums[atom_ref] = new_mob_datum
	SSmapview.removal_cbs[atom_ref] = CALLBACK(src, PROC_REF(removeimage), new_mob_datum, atom_ref)
	RegisterSignal(atom_ref, COMSIG_PARENT_QDELETING, PROC_REF(remove_marker))

/datum/controller/subsystem/mapview/proc/removeimage(datum/tacmap/mob_datum/new_atom, atom/movable/atom_ref)
	var/ref = SSmapview.minimaps_by_trait["[SSmapping.level_minimap_trait(atom_ref.z)]"].assoc_mobs_datums
	ref -= new_atom // see above http://www.byond.com/forum/post/2661309
	SSmapview.removal_cbs -= new_atom

/datum/controller/subsystem/mapview/proc/remove_marker(atom/movable/source)
	SIGNAL_HANDLER
	if(!SSmapview.removal_cbs[source]) //already removed
		return
	var/datum/tacmap/mob_datum/mob_datum = assoc_mobs_datums[source]
	mob_datum.UnregisterSignal(source, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_Z_CHANGED))
	assoc_mobs_datums -= source
	removal_cbs[source].Invoke()
	removal_cbs -= source
///////////////////////
