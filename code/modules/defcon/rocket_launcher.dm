GLOBAL_LIST_EMPTY_TYPED(rocket_launcher_computer_turf_position, /datum/rocket_launcher_computer_location)
GLOBAL_DATUM(rocket_launcher_eye_location, /datum/coords)

/datum/rocket_launcher_computer_location
	var/datum/coords/coords
	var/direction

/obj/effect/landmark/rocket_launcher_computer
	name = "Rocket Launcher computer landmark"
	desc = "A computer with an orange interface, it's idly blinking, awaiting a password."

/obj/effect/landmark/rocket_launcher_computer/Initialize(mapload, ...)
	. = ..()
	var/datum/rocket_launcher_computer_location/RCL = new()
	RCL.coords = new(loc)
	RCL.direction = dir

	GLOB.rocket_launcher_computer_turf_position.Add(RCL)

	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/rocket_launcher_camera_pos
	name = "Rocket launcher camera position landmark"

/obj/effect/landmark/rocket_launcher_camera_pos/Initialize(mapload, ...)
	. = ..()

	GLOB.rocket_launcher_eye_location = new(loc)

	return INITIALIZE_HINT_QDEL

/obj/structure/machinery/computer/rocket_launcher
	name = "rocket launcher computer"

	icon_state = "terminal"

	var/mob/hologram/rocket_launcher/eye
	var/turf/last_location
	var/turf/start_location
	var/target_z

	var/max_ammo = 12
	var/ammo = 12
	var/ammo_recharge_time = 30 SECONDS

	var/fire_cooldown = 1.5 SECONDS
	var/next_fire = 0

	var/power = 900
	var/range = 2

/obj/structure/machinery/computer/rocket_launcher/Initialize()
	. = ..()
	if(!GLOB.rocket_launcher_eye_location)
		stack_trace("Rocket Launcher eye location is not initialised! There is no landmark for it on [SSmapping.configs[GROUND_MAP].map_name]")
		return INITIALIZE_HINT_QDEL

	target_z = GLOB.rocket_launcher_eye_location.z_pos

/obj/structure/machinery/computer/rocket_launcher/attackby(obj/I as obj, mob/user as mob)  //Can't break or disassemble.
	return

/obj/structure/machinery/computer/rocket_launcher/bullet_act(obj/item/projectile/proj) //Can't shoot it
	return FALSE

/obj/structure/machinery/computer/rocket_launcher/proc/set_operator(mob/living/carbon/human/H)
	if(!istype(H))
		return
	remove_current_operator()

	operator = H
	RegisterSignal(operator, COMSIG_PARENT_QDELETING, PROC_REF(remove_current_operator))
	RegisterSignal(operator, COMSIG_MOVABLE_MOVED, PROC_REF(remove_current_operator))
	RegisterSignal(operator, COMSIG_MOB_POST_CLICK, PROC_REF(fire_gun))

	if(!last_location)
		if(GLOB.rocket_launcher_eye_location)
			last_location = GLOB.rocket_launcher_eye_location.get_turf_from_coord()
		else
			last_location = locate(1, 1, target_z)

		start_location = last_location

	eye = new(last_location, operator)
	RegisterSignal(eye, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_and_set_zlevel))
	RegisterSignal(eye, COMSIG_PARENT_QDELETING, PROC_REF(remove_current_operator))

/obj/structure/machinery/computer/rocket_launcher/proc/check_and_set_zlevel(mob/hologram/rocket_launcher/H, turf/NewLoc, direction)
	SIGNAL_HANDLER
	if(!start_location)
		start_location = GLOB.rocket_launcher_eye_location.get_turf_from_coord()

	if(!NewLoc || (NewLoc.z != target_z && H.z != target_z))
		H.loc = start_location
		return COMPONENT_OVERRIDE_MOVE

/obj/structure/machinery/computer/rocket_launcher/proc/can_fire(mob/living/carbon/human/H, turf/turf)
	if(turf.z != target_z)
		return FALSE

	if(istype(turf, /turf/open/space)) // No firing into space
		return FALSE

	if(next_fire > world.time)
		to_chat(H, SPAN_WARNING("[icon2html(src)] The barrel is still hot! Wait [SPAN_BOLD((next_fire - world.time)/10)] more seconds before firing."))
		return FALSE

	if(ammo <= 0)
		to_chat(H, SPAN_WARNING("[icon2html(src)] No more shells remaining in the barrel. Please wait for automatic reloading. [SPAN_BOLD("([ammo]/[max_ammo])")]"))
		return FALSE

	return TRUE

/obj/structure/machinery/computer/rocket_launcher/proc/recharge_ammo()
	ammo = min(ammo + 1, max_ammo)

	if(ammo < max_ammo)
		addtimer(CALLBACK(src, PROC_REF(recharge_ammo)), ammo_recharge_time, TIMER_UNIQUE|TIMER_OVERRIDE)

	if(operator)
		to_chat(operator, SPAN_NOTICE("[icon2html(src)] Loaded in a shell [SPAN_BOLD("([ammo]/[max_ammo] shells left).")]"))

/obj/structure/machinery/computer/rocket_launcher/proc/fire_gun(mob/living/carbon/human/H, atom/A, mods)
	SIGNAL_HANDLER

	if(!H.client)
		return

	var/turf/turf = get_turf(A)
	if(!istype(turf))
		return

	if(!turf)
		to_chat(H, SPAN_WARNING("[icon2html(src)] This area is too reinforced to fire into."))
		return FALSE

	if(!can_fire(H, turf))
		return

	next_fire = world.time + fire_cooldown

	addtimer(CALLBACK(src, PROC_REF(recharge_ammo)), ammo_recharge_time, TIMER_UNIQUE)
	ammo--

	to_chat(H, SPAN_NOTICE("[icon2html(src)] Firing shell. [SPAN_BOLD("([ammo]/[max_ammo] shells left).")]"))

	var/image/I = image('icons/effects/alert.dmi', turf, "alert_greyscale", ABOVE_OBJ_LAYER)
	I.color = "#0000ff"

	H.client.images += I
	playsound_client(H.client, 'sound/machines/rocket_launcher/rocket_launcher_shoot.ogg')

	addtimer(CALLBACK(src, PROC_REF(land_shot), turf, H.client, I), 10 SECONDS)

/obj/structure/machinery/computer/rocket_launcher/proc/land_shot(turf/target_turf, client/firer, image/to_remove)
	if(firer)
		firer.images -= to_remove
		var/turf/roof = target_turf.get_real_roof()
		target_turf = roof.air_strike(rand(10, 15), target_turf)
		playsound(target_turf, 'sound/machines/rocket_launcher/rocket_launcher_impact.ogg', sound_range = 75)
		cell_explosion(target_turf, power, power/range, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("rocket_launcher", firer.mob))

/obj/structure/machinery/computer/rocket_launcher/proc/remove_current_operator()
	SIGNAL_HANDLER
	if(!operator) return

	if(eye)
		last_location = eye.loc
		if(eye.gc_destroyed)
			eye = null
		else
			QDEL_NULL(eye)

	UnregisterSignal(operator, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOVABLE_PRE_MOVE,
		COMSIG_MOB_POST_CLICK
	))
	operator.update_sight()
	operator = null

/obj/structure/machinery/computer/rocket_launcher/attack_hand(mob/living/carbon/human/H)
	if(..())
		return

	if(!istype(H))
		return

	if(operator && operator.stat == CONSCIOUS)
		to_chat(H, SPAN_WARNING("Someone is already using this computer!"))
		return

	#define INPUT_COORD "Input Co-ordinates"
	if(tgui_alert(H, "View a specific co-ordinate, or continue without inputting a co-ordinate?", \
		"Rocket Launcher Computer", list(INPUT_COORD, "Continue without inputting a co-ordinate")) == INPUT_COORD)
		var/x_coord = input(H, "Longitude") as num|null
		var/y_coord = input(H, "Latitude") as num|null

		if(!x_coord || !y_coord)
			return

		last_location = locate(deobfuscate_x(x_coord), deobfuscate_y(y_coord), target_z)
	#undef INPUT_COORD

	set_operator(H)

/mob/hologram/rocket_launcher
	name = "Camera"
	density = FALSE
	mouse_icon = 'icons/effects/mouse_pointer/mecha_mouse.dmi'

/mob/hologram/rocket_launcher/Initialize(mapload, mob/M)
	. = ..(mapload, M)

	if(allow_turf_entry(src, loc) & COMPONENT_TURF_DENY_MOVEMENT)
		loc = GLOB.rocket_launcher_eye_location.get_turf_from_coord()
		to_chat(M, SPAN_WARNING("[icon2html(src)] Observation area was blocked. Switched to a viewable location."))

	RegisterSignal(M, COMSIG_HUMAN_UPDATE_SIGHT, PROC_REF(see_only_turf))
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTER, PROC_REF(allow_turf_entry))
	M.update_sight()

/mob/hologram/rocket_launcher/Destroy()
	UnregisterSignal(linked_mob, COMSIG_HUMAN_UPDATE_SIGHT)
	linked_mob.update_sight()

	return ..()

/mob/hologram/rocket_launcher/proc/see_only_turf(mob/living/carbon/human/H)
	SIGNAL_HANDLER

	H.see_in_dark = 50
	H.sight = (SEE_TURFS|BLIND)
	H.see_invisible = SEE_INVISIBLE_MINIMUM
	return COMPONENT_OVERRIDE_UPDATE_SIGHT

/mob/hologram/rocket_launcher/proc/allow_turf_entry(mob/self, turf/to_enter)
	SIGNAL_HANDLER

	var/turf/roof = to_enter.get_real_roof()
	if(!roof.air_strike(5, to_enter, TRUE))
		to_chat(linked_mob, SPAN_WARNING("[icon2html(src)] This area is too reinforced to enter."))
		return COMPONENT_TURF_DENY_MOVEMENT

	if(istype(to_enter, /turf/closed/wall))
		var/turf/closed/wall/W = to_enter
		if(W.hull)
			return COMPONENT_TURF_DENY_MOVEMENT

	return COMPONENT_TURF_ALLOW_MOVEMENT
