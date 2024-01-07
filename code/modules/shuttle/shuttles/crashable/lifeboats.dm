// === MOBILES

/// Generic Lifeboat definition
/obj/docking_port/mobile/crashable/lifeboat
	name = "lifeboat"
	area_type = /area/shuttle/lifeboat
	ignitionTime = 10 SECONDS
	width = 27
	height = 7
	rechargeTime = 20 MINUTES

	fires_on_crash = TRUE
	max_capacity = 25

	/// -1 queen locked, 0 locked til evac, 1 working
	var/status = LIFEBOAT_INACTIVE

	var/list/doors = list()
	var/list/status_displays = list()
	var/status_arrow = 0
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
	var/time = getTimerStr()
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
	for(var/mob/living/carbon/human/survived_human as anything in GLOB.alive_human_list) //check for lifeboats survivors
		var/area/area = get_area(survived_human)
		if(!survived_human)
			continue

		if(survived_human.stat != DEAD && (area in shuttle_areas))
			var/turf/turf = get_turf(survived_human)
			if(!turf || is_mainship_level(turf.z))
				continue

			survivors++
			to_chat(survived_human, "<br><br>[SPAN_CENTERBOLD("<big>You have successfully left the [MAIN_SHIP_NAME]. You may now ghost and observe the rest of the round.</big>")]<br>")
			survived_human.count_statistic_stat(STATISTICS_ESCAPE)

	SSevacuation.lifesigns += survivors

/// Port Aft Lifeboat (bottom-right, doors on its left side)
/obj/docking_port/mobile/crashable/lifeboat/port
	name = "port-aft lifeboat"
	id = MOBILE_SHUTTLE_LIFEBOAT_PORT

/// Starboard Aft Lifeboat (top-right, doors its right side)
/obj/docking_port/mobile/crashable/lifeboat/starboard
	name = "starboard-aft lifeboat"
	id = MOBILE_SHUTTLE_LIFEBOAT_STARBOARD

/obj/docking_port/mobile/crashable/lifeboat/crash_check()
	. = ..()
	if(.)
		return .

	if(prob(abs(((world.time - SSevacuation.evac_time) / EVACUATION_AUTOMATIC_DEPARTURE) - 1) * 100))
		return TRUE

/obj/docking_port/mobile/crashable/lifeboat/open_doors()
	. = ..()

	for(var/obj/structure/machinery/door/airlock/multi_tile/door in doors)
		INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, unlock_and_open))

/obj/docking_port/mobile/crashable/lifeboat/close_doors()
	. = ..()

	for(var/obj/structure/machinery/door/airlock/multi_tile/door in doors)
		INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, close_and_lock))

/obj/docking_port/mobile/crashable/lifeboat/overcap_launch_attempt()
	. = ..()

	status = LIFEBOAT_LOCKED
	ai_announcement("ATTENTION: [id] critical failure, unable to launch.")
	cell_explosion(return_center_turf(), 700, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("escape lifeboat malfunction"))

// === STATIONARIES

/// Generic lifeboat dock
/obj/docking_port/stationary/lifeboat_dock
	name = "Lifeboat docking port"
	width = 27
	height = 7

/obj/docking_port/stationary/lifeboat_dock/on_dock_ignition(departing_shuttle)
	var/obj/docking_port/mobile/crashable/lifeboat/docked_shuttle = departing_shuttle
	if(docked_shuttle)
		docked_shuttle.close_doors()

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
		docked_shuttle.open_doors()

	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, unlock_and_open)), 10)

/obj/docking_port/stationary/lifeboat_dock/proc/close_dock()
	var/obj/docking_port/mobile/crashable/lifeboat/docked_shuttle = get_docked()
	if(docked_shuttle)
		docked_shuttle.close_doors()

	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor/lifeboat, close_and_lock)), 10)

/// Port Aft Lifeboat default dock
/obj/docking_port/stationary/lifeboat_dock/port
	name = "Almayer Port Lifeboat Docking Port"
	id = "almayer-lifeboat1"
	roundstart_template = /datum/map_template/shuttle/lifeboat_port

/// Port Aft Lifeboat default dock
/obj/docking_port/stationary/lifeboat_dock/starboard
	name = "Almayer Starboard Lifeboat Docking Port"
	id = "almayer-lifeboat2"
	roundstart_template = /datum/map_template/shuttle/lifeboat_starboard

/obj/docking_port/stationary/lifeboat_dock/Initialize(mapload)
	. = ..()
	GLOB.lifeboat_almayer_docks += src

/obj/docking_port/stationary/lifeboat_dock/Destroy(force)
	if(force)
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
