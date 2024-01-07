/obj/docking_port/mobile/crashable/escape_shuttle
	name = "Escape Pod"
	id = ESCAPE_SHUTTLE
	area_type = /area/shuttle/escape_pod
	width = 4
	height = 5
	preferred_direction = SOUTH
	rechargeTime = SHUTTLE_RECHARGE
	ignitionTime = 8 SECONDS
	ignition_sound = 'sound/effects/escape_pod_warmup.ogg'

	max_capacity = 3

	var/datum/door_controller/single/door_handler = new()

/obj/docking_port/mobile/crashable/escape_shuttle/Initialize(mapload)
	. = ..(mapload)
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/airlock/evacuation/air in place)
			door_handler.doors += list(air)
			air.breakable = FALSE
			air.indestructible = TRUE
			air.unacidable = TRUE
			air.linked_shuttle = src

/obj/docking_port/mobile/crashable/escape_shuttle/evac_launch()
	var/obj/structure/machinery/computer/shuttle/escape_pod_panel/panel = getControlConsole()
	if(panel.pod_state == STATE_DELAYED)
		return

	. = ..()
	if(!.)
		return

	if(!crash_land) // so doors won't break in space
		for(var/obj/structure/machinery/door/air in door_handler.doors)
			for(var/obj/effect/xenomorph/acid/acid in air.loc)
				if(acid.acid_t == air)
					qdel(acid)
			air.breakable = FALSE
			air.indestructible = TRUE
			air.unacidable = TRUE

/obj/docking_port/mobile/crashable/escape_shuttle/open_doors()
	. = ..()

	door_handler.control_doors("force-unlock")

/obj/docking_port/mobile/crashable/escape_shuttle/close_doors()
	. = ..()

	door_handler.control_doors("force-lock-launch")

/obj/docking_port/mobile/crashable/escape_shuttle/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	playsound(src,'sound/effects/escape_pod_launch.ogg', 50, 1)

/obj/docking_port/mobile/crashable/escape_shuttle/proc/cancel_evac()
	door_handler.control_doors("force-unlock")
	evac_set = FALSE

	var/obj/structure/machinery/computer/shuttle/escape_pod_panel/panel = getControlConsole()
	if(panel.pod_state != STATE_READY && panel.pod_state != STATE_DELAYED)
		return
	panel.pod_state = STATE_IDLE
	for(var/area/interior_area in shuttle_areas)
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in interior_area)
			cryotube.dock_state = STATE_IDLE

/obj/docking_port/mobile/crashable/escape_shuttle/proc/prepare_evac()
	door_handler.control_doors("force-unlock")
	evac_set = TRUE
	for(var/area/interior_area in shuttle_areas)
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in interior_area)
			cryotube.dock_state = STATE_READY
	for(var/obj/structure/machinery/door/air in door_handler.doors)
		air.breakable = TRUE
		air.indestructible = FALSE
		air.unslashable = FALSE
		air.unacidable = FALSE

/obj/docking_port/mobile/crashable/escape_shuttle/e
	id = ESCAPE_SHUTTLE_EAST
	width = 4
	height = 5

/obj/docking_port/mobile/crashable/escape_shuttle/cl
	id = ESCAPE_SHUTTLE_EAST_CL
	width = 4
	height = 5
	early_crash_land_chance = 25
	crash_land_chance = 5

/obj/docking_port/mobile/crashable/escape_shuttle/w
	id = ESCAPE_SHUTTLE_WEST
	width = 4
	height = 5

/obj/docking_port/mobile/crashable/escape_shuttle/n
	id = ESCAPE_SHUTTLE_NORTH
	width = 5
	height = 4

/obj/docking_port/mobile/crashable/escape_shuttle/s
	id = ESCAPE_SHUTTLE_SOUTH
	width = 5
	height = 4

/obj/docking_port/stationary/escape_pod
	name = "Escape Pod Dock"

/obj/docking_port/stationary/escape_pod/Initialize(mapload)
	. = ..()
	GLOB.escape_almayer_docks += src
	var/obj/docking_port/mobile/crashable/escape_shuttle/escape_shuttle = get_docked()
	if(escape_shuttle)
		escape_shuttle.name = "[initial(escape_shuttle.name)] [length(GLOB.escape_almayer_docks)]"

/obj/docking_port/stationary/escape_pod/Destroy(force)
	if(force)
		GLOB.escape_almayer_docks -= src
	return ..()

/obj/docking_port/stationary/escape_pod/west
	id = ESCAPE_SHUTTLE_WEST_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_w
	width = 4
	height = 5

/obj/docking_port/stationary/escape_pod/east
	id = ESCAPE_SHUTTLE_EAST_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_e
	width = 4
	height = 5

/obj/docking_port/stationary/escape_pod/north
	id = ESCAPE_SHUTTLE_NORTH_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_n
	width = 5
	height = 4

/obj/docking_port/stationary/escape_pod/south
	id = ESCAPE_SHUTTLE_SOUTH_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_s
	width = 5
	height = 4

/obj/docking_port/stationary/escape_pod/cl
	id = ESCAPE_SHUTTLE_SOUTH_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_e_cl
	width = 4
	height = 5

/datum/map_template/shuttle/escape_pod_w
	name = "Escape Pod W"
	shuttle_id = ESCAPE_SHUTTLE_WEST

/datum/map_template/shuttle/escape_pod_e
	name = "Escape Pod E"
	shuttle_id = ESCAPE_SHUTTLE_EAST

/datum/map_template/shuttle/escape_pod_n
	name = "Escape Pod N"
	shuttle_id = ESCAPE_SHUTTLE_NORTH

/datum/map_template/shuttle/escape_pod_s
	name = "Escape Pod S"
	shuttle_id = ESCAPE_SHUTTLE_SOUTH

/datum/map_template/shuttle/escape_pod_e_cl
	name = "Escape Pod E CL"
	shuttle_id = ESCAPE_SHUTTLE_EAST_CL
