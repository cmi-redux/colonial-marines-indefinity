/obj/structure/machinery/door/poddoor/shutters
	name = "\improper Shutters"
	icon = 'icons/obj/structures/doors/rapid_pdoor.dmi'
	icon_state = "shutter1"
	base_icon_state = "shutter"
	power_channel = POWER_CHANNEL_ENVIRON

/obj/structure/machinery/door/poddoor/shutters/opened
	density = FALSE

/obj/structure/machinery/door/poddoor/shutters/update_icon()
	if(density)
		icon_state = "[base_icon_state]1"
	else
		icon_state = "[base_icon_state]0"
	return

/obj/structure/machinery/door/poddoor/shutters/attackby(obj/item/C as obj, mob/user as mob)
	add_fingerprint(user)
	if(!C.pry_capable)
		return
	if(density && (stat & NOPOWER) && !operating && !unacidable)
		operating = 1
		spawn(-1)
			flick("[base_icon_state]c0", src)
			icon_state = "[base_icon_state]0"
			sleep(15)
			density = FALSE
			set_opacity(FALSE)
			operating = 0
			return
	return

/obj/structure/machinery/door/poddoor/shutters/open()
	if(operating) //doors can still open when emag-disabled
		return

	operating = TRUE
	flick("[base_icon_state]c0", src)
	icon_state = "[base_icon_state]0"
	playsound(loc, 'sound/machines/blastdoor.ogg', 25)

	addtimer(CALLBACK(src, PROC_REF(finish_open)), openspeed)
	return TRUE

/obj/structure/machinery/door/poddoor/shutters/finish_open()
	density = FALSE
	layer = open_layer
	set_opacity(FALSE)

	if(operating) //emag again
		operating = FALSE
	if(autoclose)
		addtimer(CALLBACK(src, PROC_REF(autoclose)), 150)

/obj/structure/machinery/door/poddoor/shutters/close()
	if(operating)
		return

	operating = TRUE
	flick("[base_icon_state]c1", src)
	icon_state = "[base_icon_state]1"
	layer = closed_layer
	density = TRUE
	if(visible)
		set_opacity(TRUE)
	playsound(loc, 'sound/machines/blastdoor.ogg', 25)

	addtimer(CALLBACK(src, PROC_REF(finish_close)), openspeed)
	return

/obj/structure/machinery/door/poddoor/shutters/finish_close()
	operating = FALSE

/obj/structure/machinery/door/poddoor/shutters/almayer
	icon = 'icons/obj/structures/doors/blastdoors_shutters.dmi'
	openspeed = 4 //shorter open animation.
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/poddoor/shutters/almayer/open
	density = FALSE

/obj/structure/machinery/door/poddoor/shutters/almayer/Initialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/poddoor/shutters/almayer/yautja
	name = "Armory Shutter"
	id = "Yautja Armory"
	needs_power = FALSE
	unacidable = TRUE
	indestructible = TRUE

/obj/structure/machinery/door/poddoor/shutters/almayer/yautja/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_YAUTJA_ARMORY_OPENED, PROC_REF(open))

/obj/structure/machinery/door/poddoor/shutters/almayer/containment
	unacidable = TRUE
	var/xeno_overridable = TRUE

/obj/structure/machinery/door/poddoor/shutters/almayer/containment/attack_alien(mob/living/carbon/xenomorph/M)
	if(isqueen(M) && density && !operating)
		INVOKE_ASYNC(src, PROC_REF(pry_open), M)
		return XENO_ATTACK_ACTION
	else
		. = ..(M)

/obj/structure/machinery/door/poddoor/shutters/almayer/containment/pry_open(mob/living/carbon/xenomorph/X, time = 4 SECONDS)
	. = ..()
	if(. && !(stat & BROKEN) && xeno_overridable)
		stat |= BROKEN
		addtimer(CALLBACK(src, PROC_REF(unbreak_doors)), 10 SECONDS)

/obj/structure/machinery/door/poddoor/shutters/almayer/containment/proc/unbreak_doors()
	stat &= ~BROKEN

/obj/structure/machinery/door/poddoor/shutters/almayer/containment/skyscraper
	name = "Floor Lockdown"
	desc = "Safety shutters to prevent on lockdown any movements"
	var/lock_type = "stairs"
	density = FALSE
	xeno_overridable = FALSE

/obj/structure/machinery/door/poddoor/shutters/almayer/containment/skyscraper/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/poddoor/shutters/almayer/containment/skyscraper/LateInitialize()
	. = ..()
	var/obj/structure/machinery/computer/security_blocker/blocker = GLOB.skyscrapers_sec_comps["[z]"]
	if(!blocker)
		return
	if(lock_type == "stairs")
		blocker.stairs_doors += src
	else if(lock_type == "elevator")
		blocker.elevator_doors += src
	else if(lock_type == "move_lock")
		blocker.move_lock_doors += src

//transit shutters used by marine dropships
/obj/structure/machinery/door/poddoor/shutters/transit
	name = "Transit shutters"
	desc = "Safety shutters to prevent dangerous depressurization during flight"
	icon = 'icons/obj/structures/doors/blastdoors_shutters.dmi'
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/shutters/transit/ex_act(severity) //immune to explosions
	return

/obj/structure/machinery/door/poddoor/shutters/transit/open
	density = FALSE

/obj/structure/machinery/door/poddoor/shutters/almayer/pressure
	name = "pressure shutters"
	density = FALSE
	opacity = FALSE
	unacidable = TRUE
	icon_state = "shutter0"
	open_layer = PODDOOR_CLOSED_LAYER
	closed_layer = PODDOOR_CLOSED_LAYER

/obj/structure/machinery/door/poddoor/shutters/almayer/pressure/ex_act(severity)
	return

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors
	name = "\improper Uniform Vendor Shutters"
	id = "bot_uniforms"
	unacidable = TRUE
	unslashable = TRUE

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors/ex_act(severity)
		return

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors/attackby(obj/item/attacking_item, mob/user)
	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR))
		return
	..()
