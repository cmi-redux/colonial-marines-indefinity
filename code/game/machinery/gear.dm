/obj/structure/machinery/gear
	name = "gear"
	icon_state = "gear"
	anchored = TRUE
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE
	use_power = USE_POWER_NONE
	var/id

/obj/structure/machinery/gear/proc/start_moving(direction)
	icon_state = "[initial(icon_state)]_moving"
	if(direction)
		setDir(direction)

/obj/structure/machinery/gear/proc/stop_moving()
	icon_state = initial(icon_state)

/obj/structure/machinery/elevator_strut
	name = "\improper strut"
	icon = 'icons/turf/elevator_strut.dmi'
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	density = FALSE
	use_power = USE_POWER_NONE
	opacity = TRUE
	layer = ABOVE_MOB_LAYER
	var/id

/obj/structure/machinery/elevator_strut/top
	icon_state = "strut_top"

/obj/structure/machinery/elevator_strut/bottom
	icon_state = "strut_bottom"

/obj/structure/machinery/gear/sky_scraper
	icon = 'icons/turf/elevator.dmi'
	icon_state = "w_gear"

/obj/structure/machinery/gear/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override)
	. = ..()
	if(istype(port, /obj/docking_port/mobile/sselevator))
		var/obj/docking_port/mobile/sselevator/L = port
		L.gears += src
