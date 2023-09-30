// === MOBILES

/// Generic Lifeboat definition
/obj/docking_port/mobile/crashable/lifeboat
	name = "lifeboat"
	area_type = /area/shuttle/lifeboat
	ignitionTime = 8 SECONDS
	width = 27
	height = 7
	rechargeTime = 20 MINUTES
	preferred_direction = NORTH
	port_direction = NORTH

	var/available = TRUE // can be used for evac? false if queenlocked or if in transit already
	var/status = LIFEBOAT_INACTIVE // -1 queen locked, 0 locked til evac, 1 working
	var/list/doors = list()
	var/list/status_displays = list()
	var/status_arrow = 0
	var/survivors = 0
	var/obj/structure/machinery/bolt_control/target/terminal

/obj/docking_port/mobile/crashable/lifeboat/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/docking_port/mobile/crashable/lifeboat/LateInitialize()
	. = ..()
	for(var/obj/structure/machinery/status_display/lifeboat/SD as anything in GLOB.lifeboat_displays)
		if(SD.id == id)
			status_displays += SD
	for(var/obj/structure/machinery/bolt_control/target/T in machines)
		if(T.id == id)
			terminal = T
			return

/obj/docking_port/mobile/crashable/lifeboat/process()
	var/time
	time = getTimerStr()
	for(var/obj/structure/machinery/status_display/lifeboat/SD as anything in status_displays)
		if(status_arrow < 2 || timeLeft() <= 10 || SSevacuation.evac_status < EVACUATION_STATUS_IN_PROGRESS)
			SD.set_and_update_lifeboat(time, "Lifeboat is refueling. Please wait.")
		else
			SD.set_lifeboat_overlay_arrow()
	status_arrow++
	if(status_arrow > 3)
		status_arrow = 0

/obj/docking_port/mobile/crashable/lifeboat/set_mode(new_mode)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(manage_displays), mode)
	if(terminal && mode == SHUTTLE_IDLE && status == LIFEBOAT_ACTIVE)
		terminal.unlock()
	else if(mode == SHUTTLE_CALL)
		addtimer(CALLBACK(src, PROC_REF(check_for_survivors), 3 SECONDS))

/obj/docking_port/mobile/crashable/lifeboat/proc/manage_displays(mode)
	SHOULD_NOT_SLEEP(TRUE)

	if(mode == SHUTTLE_RECHARGING)
		START_PROCESSING(SSobj, src)
	else if(mode == SHUTTLE_IDLE)
		STOP_PROCESSING(SSobj, src)
		if(status == LIFEBOAT_ACTIVE)
			set_displays("lifeboat_overlay_ready")
		else if(status == LIFEBOAT_LOCKED)
			set_displays("lifeboat_overlay_error")
	else if(mode == SHUTTLE_IGNITING)
		set_displays("lifeboat_overlay_departing")
	else if(mode == SHUTTLE_CALL)
		set_displays("lifeboat_overlay_departed")

/obj/docking_port/mobile/crashable/lifeboat/proc/set_displays(mode)
	for(var/obj/structure/machinery/status_display/lifeboat/SD as anything in status_displays)
		SD.set_lifeboat_overlay(mode)

/obj/docking_port/mobile/crashable/lifeboat/proc/check_for_survivors()
	for(var/mob/living/carbon/human/M as anything in GLOB.alive_human_list) //check for lifeboats survivors
		var/area/A = get_area(M)
		if(!M)
			continue
		if(M.stat != DEAD && (A in shuttle_areas))
			var/turf/T = get_turf(M)
			if(!T || is_mainship_level(T.z))
				continue
			survivors++
			M.count_statistic_stat(STATISTICS_ESCAPE)
			to_chat(M, "<br><br>[SPAN_CENTERBOLD("<big>You have successfully left the [MAIN_SHIP_NAME]. You may now ghost and observe the rest of the round.</big>")]<br>")
	SSevacuation.lifesigns += survivors
	available = FALSE

/// Port Aft Lifeboat (bottom-right, doors on its left side)
/obj/docking_port/mobile/crashable/lifeboat/port
	name = "port-aft lifeboat"
	id = MOBILE_SHUTTLE_LIFEBOAT_PORT
	preferred_direction = WEST
	port_direction = WEST

/// Starboard Aft Lifeboat (top-right, doors its right side)
/obj/docking_port/mobile/crashable/lifeboat/starboard
	name = "starboard-aft lifeboat"
	id = MOBILE_SHUTTLE_LIFEBOAT_STARBOARD
	preferred_direction = EAST
	port_direction = EAST

/obj/docking_port/mobile/crashable/lifeboat/proc/check_passengers()
	. = TRUE
	var/n = 0 //Generic counter.
	for(var/mob/living/carbon/human/M as anything in GLOB.alive_human_list)
		var/area/A = get_area(M)
		if(!M)
			continue
		if(A in shuttle_areas)
			var/turf/T = get_turf(M)
			if(!T || is_mainship_level(T.z))
				continue
			n++
	for(var/mob/living/carbon/xenomorph/X as anything in GLOB.living_xeno_list)
		var/area/A = get_area(X)
		if(!X)
			continue
		if(A in shuttle_areas)
			var/turf/T = get_turf(X)
			if(!T || is_mainship_level(T.z))
				continue
			if(isqueen(X))
				return FALSE
			else if(X.mob_size >= MOB_SIZE_BIG)
				n += 3
			n++
	if(n > 25)  . = FALSE
	return TRUE

/obj/docking_port/mobile/crashable/lifeboat/proc/try_launch()
	if(!check_passengers())
		available = FALSE
		status = LIFEBOAT_LOCKED
		ai_announcement("ATTENTION: [id] critical failure, unable to launch.")
		sleep(40)
		explosion(return_center_turf(), -1, -1, 3, 4, , , , create_cause_data("escape lifeboat malfunction"))
		return
	send_to_infinite_transit()

/obj/docking_port/mobile/crashable/lifeboat/proc/send_to_infinite_transit()
	destination = null
	set_mode(SHUTTLE_IGNITING)
	on_ignition()
	setTimer(ignitionTime)

// === STATIONARIES

/// Generic lifeboat dock
/obj/docking_port/stationary/lifeboat_dock
	name   = "Lifeboat docking port"
	width  = 27
	height = 7

/obj/docking_port/stationary/lifeboat_dock/on_dock_ignition(departing_shuttle)
	var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = departing_shuttle
	if(istype(lifeboat))
		for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat/door in lifeboat.doors)
			INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, close_and_lock))

	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, close_and_lock)), 10)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat/blastdoor, bolt_explosion)), 75)

/obj/docking_port/stationary/lifeboat_dock/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			blastdoor.vacate_premises()

/obj/docking_port/stationary/lifeboat_dock/proc/open_dock()
	var/obj/docking_port/mobile/crashable/lifeboat/docked_shuttle = get_docked()
	if(docked_shuttle)
		for(var/obj/structure/machinery/door/airlock/multi_tile/door in docked_shuttle.doors)
			INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, unlock_and_open))

	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, unlock_and_open)), 10)

/obj/docking_port/stationary/lifeboat_dock/proc/close_dock()
	var/obj/docking_port/mobile/crashable/lifeboat/docked_shuttle = get_docked()
	if(docked_shuttle)
		for(var/obj/structure/machinery/door/airlock/multi_tile/door in docked_shuttle.doors)
			INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, close_and_lock))

	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, close_and_lock)), 10)

/// Port Aft Lifeboat default dock
/obj/docking_port/stationary/lifeboat_dock/port
	name = "Almayer Port Lifeboat Docking Port"
	dir = NORTH
	id = "almayer-lifeboat1"
	roundstart_template = /datum/map_template/shuttle/lifeboat_port

/// Port Aft Lifeboat default dock
/obj/docking_port/stationary/lifeboat_dock/starboard
	name = "Almayer Starboard Lifeboat Docking Port"
	dir = NORTH
	id = "almayer-lifeboat2"
	roundstart_template = /datum/map_template/shuttle/lifeboat_starboard

/obj/docking_port/stationary/lifeboat_dock/Initialize(mapload)
	. = ..()
	GLOB.lifeboat_almayer_docks += src

/obj/docking_port/stationary/lifeboat_dock/Destroy(force)
	if (force)
		GLOB.lifeboat_almayer_docks -= src
	return ..()

// === SHUTTLE TEMPLATES FOR SPAWNING THEM

/// Port-door lifeboat, bow east
/datum/map_template/shuttle/lifeboat_port
	name = "Port door lifeboat"
	shuttle_id = MOBILE_SHUTTLE_LIFEBOAT_PORT

/// Starboard-door lifeboat, bow east
/datum/map_template/shuttle/lifeboat_starboard
	name = "Starboard door lifeboat"
	shuttle_id = MOBILE_SHUTTLE_LIFEBOAT_STARBOARD
