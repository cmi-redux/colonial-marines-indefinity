/*
 * Traps
 */

/obj/effect/alien/resin/trap
	desc = "It looks like a hiding hole."
	name = "resin hole"
	icon_state = "trap0"
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	health = 5
	layer = ABOVE_WEED_LAYER
	var/list/tripwires = list()
	var/trap_type = RESIN_TRAP_EMPTY
	var/armed = 0
	var/created_by // ckey
	var/list/notify_list = list() // list of xeno mobs to notify on trigger
	var/datum/effect_system/smoke_spread/smoke_system
	var/datum/cause_data/cause_data
	plane = FLOOR_PLANE

/obj/effect/alien/resin/trap/Initialize(mapload, mob/living/carbon/xenomorph/xeno)
	. = ..()

	if(xeno)
		created_by = xeno.ckey
		faction = xeno.faction
		set_hive_data(src, faction)

	cause_data = create_cause_data("резиновая ловушка", xeno)

/obj/effect/alien/resin/trap/Initialize()
	. = ..()

	var/obj/effect/alien/weeds/node/node = locate() in loc
	if(node)
		node.RegisterSignal(src, COMSIG_PARENT_PREQDELETED, /obj/effect/alien/weeds/node/proc/trap_destroyed)
		node.overlay_node = FALSE
		node.overlays.Cut()

/obj/effect/alien/resin/trap/get_examine_text(mob/user)
	if(!isxeno(user))
		return ..()
	. = ..()
	switch(trap_type)
		if(RESIN_TRAP_EMPTY)
			. += "It's empty."
		if(RESIN_TRAP_HUGGER)
			. += "There's a little one inside."
		if(RESIN_TRAP_GAS)
			. += "It's filled with pressurised gas."
		if(RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			. += "It's filled with pressurised acid."

/obj/effect/alien/resin/trap/proc/facehugger_die()
	var/obj/item/clothing/mask/facehugger/hugger = new(loc)
	hugger.die()
	trap_type = RESIN_TRAP_EMPTY
	icon_state = "trap0"

/obj/effect/alien/resin/trap/flamer_fire_act()
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			burn_trap()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			trigger_trap(TRUE)
	..()

/obj/effect/alien/resin/trap/fire_act()
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			burn_trap()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			trigger_trap(TRUE)
	..()

/obj/effect/alien/resin/trap/bullet_act(obj/item/projectile/proj)
	var/mob/living/carbon/xenomorph/xeno = proj.firer
	if(istype(xeno) && (xeno.faction == faction || xeno.faction.faction_is_ally(faction)))
		return

	. = ..()

/obj/effect/alien/resin/trap/HasProximity(atom/movable/AM)
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			if(can_hug(AM, faction) && !isyautja(AM) && !issynth(AM))
				var/mob/living/L = AM
				L.visible_message(SPAN_WARNING("[L] trips on [src]!"),\
								SPAN_DANGER("You trip on [src]!"))
				L.apply_effect(1, WEAKEN)
				trigger_trap()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			if(ishuman(AM))
				var/mob/living/carbon/human/H = AM
				if(issynth(H) || isyautja(H))
					return
				if(H.stat == DEAD || !(H.canmove && H.can_action))
					return
				if(H.ally(faction))
					return
				trigger_trap()
			if(isxeno(AM))
				var/mob/living/carbon/xenomorph/xeno = AM
				if(xeno.faction != faction)
					trigger_trap()
			if(isvehiclemultitile(AM) && trap_type != RESIN_TRAP_GAS)
				trigger_trap()

/obj/effect/alien/resin/trap/proc/set_state(state = RESIN_TRAP_EMPTY)
	switch(state)
		if(RESIN_TRAP_EMPTY)
			trap_type = RESIN_TRAP_EMPTY
			icon_state = "trap0"
		if(RESIN_TRAP_HUGGER)
			trap_type = RESIN_TRAP_HUGGER
			icon_state = "trap1"
		if(RESIN_TRAP_ACID1)
			trap_type = RESIN_TRAP_ACID1
			icon_state = "trapacid1"
		if(RESIN_TRAP_ACID2)
			trap_type = RESIN_TRAP_ACID2
			icon_state = "trapacid2"
		if(RESIN_TRAP_ACID3)
			trap_type = RESIN_TRAP_ACID3
			icon_state = "trapacid3"
		if(RESIN_TRAP_GAS)
			trap_type = RESIN_TRAP_GAS
			icon_state = "trapgas"

/obj/effect/alien/resin/trap/proc/burn_trap()
	var/area/A = get_area(src)
	facehugger_die()
	clear_tripwires()
	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		to_chat(xeno, SPAN_XENOMINORWARNING("You sense one of your Hive's facehugger traps at [A.name] has been burnt!"))

/obj/effect/alien/resin/trap/proc/get_spray_type(level)
	switch(level)
		if(RESIN_TRAP_ACID1)
			return /obj/effect/xenomorph/spray/weak

		if(RESIN_TRAP_ACID2)
			return /obj/effect/xenomorph/spray

		if(RESIN_TRAP_ACID3)
			return /obj/effect/xenomorph/spray/strong

/obj/effect/alien/resin/trap/proc/trigger_trap(destroyed = FALSE)
	set waitfor = FALSE
	var/area/A = get_area(src)
	var/trap_type_name = ""
	switch(trap_type)
		if(RESIN_TRAP_EMPTY)
			trap_type_name = "empty"
		if(RESIN_TRAP_HUGGER)
			trap_type_name = "hugger"
			var/obj/item/clothing/mask/facehugger/FH = new(loc, faction)
			set_state()
			visible_message(SPAN_WARNING("[FH] gets out of [src]!"))
			sleep(15)
			if(FH.stat == CONSCIOUS && FH.loc) //Make sure we're conscious and not idle or dead.
				FH.leap_at_nearest_target()
		if(RESIN_TRAP_GAS)
			trap_type_name = "gas"
			smoke_system.set_up(2, 0, src.loc)
			smoke_system.start()
			set_state()
			clear_tripwires()
		if(RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			trap_type_name = "acid"
			var/spray_type = get_spray_type(trap_type)

			new spray_type(loc, cause_data, faction)
			for(var/turf/T in range(1,loc))
				var/obj/effect/xenomorph/spray/SP = new spray_type(T, cause_data, faction)
				for(var/mob/living/carbon/H in T)
					if(H.ally(faction))
						continue
					SP.apply_spray(H)
			set_state()
			clear_tripwires()
	if(!A)
		return
	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		if(destroyed)
			to_chat(xeno, SPAN_XENOMINORWARNING("You sense one of your Hive's [trap_type_name] traps at [A.name] has been destroyed!"))
		else
			to_chat(xeno, SPAN_XENOMINORWARNING("You sense one of your Hive's [trap_type_name] traps at [A.name] has been triggered!"))

/obj/effect/alien/resin/trap/proc/clear_tripwires()
	QDEL_NULL_LIST(tripwires)
	tripwires = list()

/obj/effect/alien/resin/trap/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.faction != faction)
		return ..()

	var/trap_acid_level = 0
	if(trap_type >= RESIN_TRAP_ACID1)
		trap_acid_level = 1 + trap_type - RESIN_TRAP_ACID1
	if(xeno.a_intent == INTENT_HARM && trap_type == RESIN_TRAP_EMPTY)
		return ..()

	if(trap_type == RESIN_TRAP_HUGGER)
		if(xeno.caste.can_hold_facehuggers)
			set_state()
			var/obj/item/clothing/mask/facehugger/hugger = new(loc, faction)
			xeno.put_in_active_hand(hugger)
			to_chat(xeno, SPAN_XENONOTICE("You remove the facehugger from [src]."))
			return XENO_NONCOMBAT_ACTION
		else
			to_chat(xeno, SPAN_XENONOTICE("[src] is occupied by a child."))
			return XENO_NO_DELAY_ACTION

	if((!xeno.acid_level || trap_type == RESIN_TRAP_GAS) && trap_type != RESIN_TRAP_EMPTY)
		to_chat(xeno, SPAN_XENONOTICE("Better not risk setting this off."))
		return XENO_NO_DELAY_ACTION

	if(!xeno.acid_level)
		to_chat(xeno, SPAN_XENONOTICE("You can't secrete any acid into \the [src]"))
		return XENO_NO_DELAY_ACTION

	if(trap_acid_level >= xeno.acid_level)
		to_chat(xeno, SPAN_XENONOTICE("It already has good acid in."))
		return XENO_NO_DELAY_ACTION

	if(isboiler(xeno))
		var/mob/living/carbon/xenomorph/boiler/user_boiler = xeno

		if(!user_boiler.check_plasma(200))
			to_chat(user_boiler, SPAN_XENOWARNING("You must produce more plasma before doing this."))
			return XENO_NO_DELAY_ACTION

		to_chat(user_boiler, SPAN_XENONOTICE("You begin charging the resin hole with acid gas."))
		xeno_attack_delay(user_boiler)
		if(!do_after(user_boiler, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, src))
			return XENO_NO_DELAY_ACTION

		if(trap_type != RESIN_TRAP_EMPTY)
			return XENO_NO_DELAY_ACTION

		if(!user_boiler.check_plasma(200))
			return XENO_NO_DELAY_ACTION

		if(user_boiler.ammo.type == /datum/ammo/xeno/boiler_gas)
			smoke_system = new /datum/effect_system/smoke_spread/xeno_weaken()
		else
			smoke_system = new /datum/effect_system/smoke_spread/xeno_acid()

		setup_tripwires()
		user_boiler.use_plasma(200)
		playsound(loc, 'sound/effects/refill.ogg', 25, 1)
		set_state(RESIN_TRAP_GAS)
		cause_data = create_cause_data("оезиновая газовая ловушка", user_boiler)
		user_boiler.visible_message(SPAN_XENOWARNING("\The [user_boiler] pressurises the resin hole with acid gas!"), \
		SPAN_XENOWARNING("You pressurise the resin hole with acid gas!"), null, 5)
	else
		//Non-boiler acid types
		var/acid_cost = 70
		if(xeno.acid_level == 2)
			acid_cost = 100
		else if(xeno.acid_level == 3)
			acid_cost = 200

		if(!xeno.check_plasma(acid_cost))
			to_chat(xeno, SPAN_XENOWARNING("You must produce more plasma before doing this."))
			return XENO_NO_DELAY_ACTION

		to_chat(xeno, SPAN_XENONOTICE("You begin charging the resin hole with acid."))
		xeno_attack_delay(xeno)
		if(!do_after(xeno, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, src))
			return XENO_NO_DELAY_ACTION

		if(!xeno.check_plasma(acid_cost))
			return XENO_NO_DELAY_ACTION

		xeno.use_plasma(acid_cost)
		cause_data = create_cause_data("резиновая кислотная ловушка", xeno)
		setup_tripwires()
		playsound(loc, 'sound/effects/refill.ogg', 25, 1)

		if(isburrower(xeno))
			set_state(RESIN_TRAP_ACID3)
		else
			set_state(RESIN_TRAP_ACID1 + xeno.acid_level - 1)

		xeno.visible_message(SPAN_XENOWARNING("\The [xeno] pressurises the resin hole with acid!"), \
		SPAN_XENOWARNING("You pressurise the resin hole with acid!"), null, 5)
	return XENO_NO_DELAY_ACTION


/obj/effect/alien/resin/trap/proc/setup_tripwires()
	clear_tripwires()
	for(var/turf/T in orange(1,loc))
		if(T.density)
			continue
		var/obj/effect/hole_tripwire/HT = new /obj/effect/hole_tripwire(T, faction)
		HT.linked_trap = src
		tripwires += HT

/obj/effect/alien/resin/trap/attackby(obj/item/W, mob/user)
	if(!(istype(W, /obj/item/clothing/mask/facehugger) && isxeno(user)))
		return ..()
	if(trap_type != RESIN_TRAP_EMPTY)
		to_chat(user, SPAN_XENOWARNING("You can't put a hugger in this hole!"))
		return
	var/obj/item/clothing/mask/facehugger/hugger = W
	if(hugger.stat == DEAD)
		to_chat(user, SPAN_XENOWARNING("You can't put a dead facehugger in [src]."))
	else
		var/mob/living/carbon/xenomorph/xeno = user
		if(!istype(xeno))
			return

		if(xeno.faction != faction)
			to_chat(user, SPAN_XENOWARNING("This resin hole doesn't belong to your hive!"))
			return

		if(hugger.faction != faction)
			to_chat(user, SPAN_XENOWARNING("This facehugger is tainted."))
			return

		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|INTERRUPT_DAZED, BUSY_ICON_HOSTILE))
			return

		set_state(RESIN_TRAP_HUGGER)
		to_chat(user, SPAN_XENONOTICE("You place a facehugger in [src]."))
		qdel(hugger)

/obj/effect/alien/resin/trap/Crossed(atom/A)
	if(ismob(A) || isvehiclemultitile(A))
		HasProximity(A)

/obj/effect/alien/resin/trap/Destroy()
	if(trap_type != RESIN_TRAP_EMPTY && loc)
		trigger_trap()
	QDEL_NULL_LIST(tripwires)
	. = ..()

/obj/effect/hole_tripwire
	name = "hole tripwire"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/effect/alien/resin/trap/linked_trap

/obj/effect/hole_tripwire/Destroy()
	if(linked_trap)
		linked_trap.tripwires -= src
		linked_trap = null
	. = ..()

/obj/effect/hole_tripwire/Crossed(atom/A)
	if(!linked_trap)
		qdel(src)
		return

	if(linked_trap.trap_type == RESIN_TRAP_EMPTY)
		qdel(src)
		return

	if(ishuman(A) || isxeno(A) || isvehiclemultitile(A))
		linked_trap.HasProximity(A)
