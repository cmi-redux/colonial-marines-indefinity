
//Cleanbot
/obj/structure/machinery/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, he looks so excited!"
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "cleanbot0"
	density = FALSE
	anchored = FALSE
	//weight = 1.0E7
	health = 25
	maxhealth = 25
	var/cleaning = 0
	var/screwloose = 0
	var/oddbutton = 0
	var/blood = 1
	var/list/target_types = list()
	var/obj/effect/decal/cleanable/target
	var/obj/effect/decal/cleanable/oldtarget
	var/oldloc = null
	req_access = list(ACCESS_CIVILIAN_ENGINEERING)
	var/path[] = new()
	var/patrol_path[] = null
	var/beacon_freq = 1445 // navigation beacon frequency
	var/closest_dist
	var/closest_loc
	var/failed_steps
	var/should_patrol
	var/next_dest
	var/next_dest_loc

/obj/structure/machinery/bot/cleanbot/Initialize(mapload, ...)
	. = ..()
	get_targets()
	icon_state = "cleanbot[on]"

	should_patrol = 1

	botcard = new(src)
	if(SSticker.role_authority)
		var/datum/job/ctequiv = GET_MAPPED_ROLE(JOB_CARGO_TECH)
		if(ctequiv) botcard.access = ctequiv.get_access()

	locked = 0 // Start unlocked so roboticist can set them to patrol.

	SSradio.add_object(src, beacon_freq, filter = RADIO_NAVBEACONS)

	start_processing()

/obj/structure/machinery/bot/cleanbot/Destroy()
	QDEL_NULL(target)
	QDEL_NULL(oldtarget)
	SSradio.remove_object(src, beacon_freq)
	. = ..()

/obj/structure/machinery/bot/cleanbot/turn_on()
	. = ..()
	icon_state = "cleanbot[on]"
	updateUsrDialog()

/obj/structure/machinery/bot/cleanbot/turn_off()
	..()
	if(!QDELETED(target))
		target.targeted_by = null
	target = null
	oldtarget = null
	oldloc = null
	icon_state = "cleanbot[on]"
	path = new()
	updateUsrDialog()

/obj/structure/machinery/bot/cleanbot/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	usr.set_interaction(src)
	interact(user)

/obj/structure/machinery/bot/cleanbot/interact(mob/user as mob)
	var/dat
	dat += text({"
<TT><B>Automatic Station Cleaner v1.0</B></TT><BR><BR>
Status: []<BR>
Behaviour controls are [locked ? "locked" : "unlocked"]<BR>
Maintenance panel is [open ? "opened" : "closed"]"},
text("<A href='?src=\ref[src];operation=start'>[on ? "On" : "Off"]</A>"))
	if(!locked || isRemoteControlling(user))
		dat += text({"<BR>Cleans Blood: []<BR>"}, text("<A href='?src=\ref[src];operation=blood'>[blood ? user.client.auto_lang(LANGUAGE_YES) : user.client.auto_lang(LANGUAGE_NO)]</A>"))
		dat += text({"<BR>Patrol station: []<BR>"}, text("<A href='?src=\ref[src];operation=patrol'>[should_patrol ? user.client.auto_lang(LANGUAGE_YES) : user.client.auto_lang(LANGUAGE_NO)]</A>"))
	//	dat += text({"<BR>Beacon frequency: []<BR>"}, text("<A href='?src=\ref[src];operation=freq'>[beacon_freq]</A>"))
	if(open && !locked)
		dat += text({"
Odd looking screw twiddled: []<BR>
Weird button pressed: []"},
text("<A href='?src=\ref[src];operation=screw'>[screwloose ? user.client.auto_lang(LANGUAGE_YES) : user.client.auto_lang(LANGUAGE_NO)]</A>"),
text("<A href='?src=\ref[src];operation=oddbutton'>[oddbutton ? user.client.auto_lang(LANGUAGE_YES) : user.client.auto_lang(LANGUAGE_NO)]</A>"))

	show_browser(user, dat, "Cleaner v1.0 controls", "autocleaner")
	onclose(user, "autocleaner")
	return

/obj/structure/machinery/bot/cleanbot/Topic(href, href_list)
	if(..())
		return
	usr.set_interaction(src)
	add_fingerprint(usr)
	switch(href_list["operation"])
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
		if("blood")
			blood =!blood
			get_targets()
			updateUsrDialog()
		if("patrol")
			should_patrol =!should_patrol
			patrol_path = null
			updateUsrDialog()
		if("freq")
			var/freq = text2num(input("Select frequency for  navigation beacons", "Frequnecy", num2text(beacon_freq / 10))) * 10
			if(freq > 0)
				beacon_freq = freq
			updateUsrDialog()
		if("screw")
			screwloose = !screwloose
			to_chat(usr, SPAN_NOTICE("You twiddle the screw."))
			updateUsrDialog()
		if("oddbutton")
			oddbutton = !oddbutton
			to_chat(usr, SPAN_NOTICE("You press the weird button."))
			updateUsrDialog()

/obj/structure/machinery/bot/cleanbot/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/card/id))
		if(allowed(usr) && !open)
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [ src.locked ? "lock" : "unlock"] the [src] behaviour controls."))
		else
			if(open)
				to_chat(user, SPAN_WARNING("Please close the access panel before locking it."))
			else
				to_chat(user, SPAN_NOTICE("This [src] doesn't seem to respect your authority."))
	else
		return ..()

/obj/structure/machinery/bot/cleanbot/process()
	set background = TRUE

	if(!on)
		return
	if(cleaning)
		return

	if(!screwloose && !oddbutton && prob(5))
		visible_message("[src] makes an excited beeping booping sound!")

	if(screwloose && prob(5))
		if(isturf(loc))
			var/turf/T = loc
			T.wet_floor(FLOOR_WET_WATER)
	if(oddbutton && prob(5))
		visible_message("Something flies out of [src]. He seems to be acting oddly.")
		var/obj/effect/decal/cleanable/blood/gibs/gib = new /obj/effect/decal/cleanable/blood/gibs(loc)
		oldtarget = gib
	if(!target || src.target == null)
		for (var/obj/effect/decal/cleanable/D in view(7,src))
			for(var/T in src.target_types)
				if(isnull(D.targeted_by) && (D.type == T || D.parent_type == T) && D != src.oldtarget)   // If the mess isn't targeted
					oldtarget = D  // or if it is but the bot is gone.
					target = D  // and it's stuff we clean?  Clean it.
					D.targeted_by = src // Claim the mess we are targeting.
					return

	if(!target || src.target == null)
		if(loc != src.oldloc)
			oldtarget = null

		if(!should_patrol)
			return

		if(!patrol_path || patrol_path.len < 1)
			var/datum/radio_frequency/frequency = SSradio.return_frequency(beacon_freq)

			if(!frequency) return

			closest_dist = 9999
			closest_loc = null
			next_dest_loc = null

			var/datum/signal/signal = new()
			signal.source = src
			signal.transmission_method = 1
			signal.data = list("findbeacon" = "patrol")
			frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
			spawn(5)
				if(!next_dest_loc)
					next_dest_loc = closest_loc
				if(next_dest_loc)
					patrol_path = AStar(loc, next_dest_loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id=botcard, exclude=null)
		else
			patrol_move()

		return

	if(target && path.len == 0)
		spawn(0)
			if(!src || !target) return
			path = AStar(loc, src.target.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id=botcard)
			if(!path) path = list()
			if(path.len == 0)
				oldtarget = src.target
				target.targeted_by = null
				target = null
		return
	if(path.len > 0 && src.target && (target != null))
		step_to(src, src.path[1])
		path -= src.path[1]
	else if(path.len == 1)
		step_to(src, target)

	if(target && (target != null))
		patrol_path = null
		if(loc == src.target.loc)
			clean(target)
			path = new()
			target = null
			return

	oldloc = src.loc

/obj/structure/machinery/bot/cleanbot/proc/patrol_move()
	if(patrol_path.len <= 0)
		return

	var/next = src.patrol_path[1]
	patrol_path -= next
	if(next == src.loc)
		return

	var/moved = step_towards(src, next)
	if(!moved)
		failed_steps++
	if(failed_steps > 4)
		patrol_path = null
		next_dest = null
		failed_steps = 0
	else
		failed_steps = 0

/obj/structure/machinery/bot/cleanbot/receive_signal(datum/signal/signal)
	var/recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid)
		return

	var/dist = get_dist(src, signal.source.loc)
	if(dist < closest_dist && signal.source.loc != src.loc)
		closest_dist = dist
		closest_loc = signal.source.loc
		next_dest = signal.data["next_patrol"]

	if(recv == next_dest)
		next_dest_loc = signal.source.loc
		next_dest = signal.data["next_patrol"]

/obj/structure/machinery/bot/cleanbot/proc/get_targets()
	target_types = list()

	target_types += /obj/effect/decal/cleanable/blood/oil
	target_types += /obj/effect/decal/cleanable/vomit
	target_types += /obj/effect/decal/cleanable/crayon
	target_types += /obj/effect/decal/cleanable/liquid_fuel
	target_types += /obj/effect/decal/cleanable/mucus
	target_types += /obj/effect/decal/cleanable/dirt

	if(blood)
		target_types += /obj/effect/decal/cleanable/blood

/obj/structure/machinery/bot/cleanbot/proc/clean(obj/effect/decal/cleanable/target)
	anchored = TRUE
	icon_state = "cleanbot-c"
	visible_message(SPAN_DANGER("[src] begins to clean up the [target]"))
	cleaning = 1
	var/cleantime = 50
	if(istype(target,/obj/effect/decal/cleanable/dirt)) // Clean Dirt much faster
		cleantime = 10
	spawn(cleantime)
		cleaning = 0
		qdel(target)
		icon_state = "cleanbot[on]"
		anchored = FALSE
		target = null

/obj/structure/machinery/bot/cleanbot/explode()
	on = 0
	visible_message(SPAN_DANGER("<B>[src] blows apart!</B>"), null, null, 1)
	var/turf/Tsec = get_turf(src)

	new /obj/item/reagent_container/glass/bucket(Tsec)

	new /obj/item/device/assembly/prox_sensor(Tsec)

	if(prob(50))
		new /obj/item/robot_parts/arm/l_arm(Tsec)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return
