#define PYLON_REPAIR_TIME (4 SECONDS)
#define PYLON_WEEDS_REGROWTH_TIME (15 SECONDS)

//Hive Pylon - Remote building location for other structures, generates strong weeds

/obj/effect/alien/resin/special/pylon
	name = XENO_STRUCTURE_PYLON
	desc = "A towering spike of resin. Its base pulsates with large tendrils."
	icon_state = "pylon"

	health = 1800
	block_range = 0

	var/cover_range = WEED_RANGE_PYLON
	var/node_type = /obj/effect/alien/weeds/node/pylon
	var/linked_turfs = list()

	var/damaged = FALSE
	var/plasma_stored = 0
	var/plasma_required_to_repair = 1000

	var/protection_level = 10

	plane = FLOOR_PLANE

	light_on = TRUE
	light_range = 3
	light_power = 0.2
	light_system = STATIC_LIGHT
	light_color = COLOR_VIBRANT_LIME

/obj/effect/alien/resin/special/pylon/Initialize(mapload, hive_ref)
	. = ..()

	place_node()
	for(var/turf/turf in range(round(cover_range*COVERAGE_MULT), loc))
		LAZYADD(turf.linked_pylons, src)
		linked_turfs += turf

/obj/effect/alien/resin/special/pylon/Destroy()
	for(var/turf/turf as anything in linked_turfs)
		LAZYREMOVE(turf.linked_pylons, src)

	var/obj/effect/alien/weeds/node/pylon/pylon = locate() in loc
	if(pylon)
		qdel(pylon)
	. = ..()

/obj/effect/alien/resin/special/pylon/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(isxeno_builder(xeno) && xeno.a_intent == INTENT_HELP && xeno.faction == faction)
		do_repair(xeno) //This handles the delay itself.
		return XENO_NO_DELAY_ACTION
	else
		return ..()

/obj/effect/alien/resin/special/pylon/proc/do_repair(mob/living/carbon/xenomorph/xeno)
	if(!istype(xeno))
		return
	if(!xeno.plasma_max)
		return
	var/can_repair = damaged || health < maxhealth
	if(!can_repair)
		to_chat(xeno, SPAN_XENONOTICE("\The [name] is in good condition, you don't need to repair it."))
		return

	to_chat(xeno, SPAN_XENONOTICE("You begin adding the plasma to \the [name] to repair it."))
	xeno_attack_delay(xeno)
	if(!do_after(xeno, PYLON_REPAIR_TIME, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src) || !can_repair)
		return

	var/amount_to_use = min(xeno.plasma_stored, (plasma_required_to_repair - plasma_stored))
	plasma_stored += amount_to_use
	xeno.plasma_stored -= amount_to_use

	if(plasma_stored < plasma_required_to_repair)
		to_chat(xeno, SPAN_WARNING("\The [name] requires [plasma_required_to_repair - plasma_stored] more plasma to repair it."))
		return

	damaged = FALSE
	plasma_stored = 0
	health = initial(health)

	var/obj/effect/alien/weeds/node/pylon/pylon = locate() in loc
	if(!pylon)
		return
	for(var/obj/effect/alien/weeds/weeds in pylon.children)
		if(get_dist(pylon, weeds) >= pylon.node_range)
			continue
		if(istype(weeds, /obj/effect/alien/weeds/weedwall))
			continue
		addtimer(CALLBACK(weeds, TYPE_PROC_REF(/obj/effect/alien/weeds, weed_expand), pylon), PYLON_WEEDS_REGROWTH_TIME, TIMER_UNIQUE)

	to_chat(xeno, SPAN_XENONOTICE("You have successfully repaired \the [name]."))
	playsound(loc, "alien_resin_build", 25)

/obj/effect/alien/resin/special/pylon/proc/place_node()
	var/obj/effect/alien/weeds/node/pylon/pylon = new node_type(loc, null, null, faction)
	pylon.resin_parent = src

/obj/effect/alien/resin/special/pylon/cluster
	name = XENO_STRUCTURE_CLUSTER
	desc = "A large clump of gooey mass. It rhythmically pulses, as if its pumping something into the weeds below..."
	icon = 'icons/mob/xenos/structures48x48.dmi'
	icon_state = "hive_cluster_idle"

	pixel_x = -8
	pixel_y = -8

	health = 1200
	block_range = 0

	node_type = /obj/effect/alien/weeds/node/pylon/cluster

	damaged = FALSE
	plasma_stored = 0
	plasma_required_to_repair = 300

	protection_level = 5

//Hive Core - Generates strong weeds, supports other buildings
/obj/effect/alien/resin/special/pylon/core
	name = XENO_STRUCTURE_CORE
	desc = "A giant pulsating mound of mass. It looks very much alive."
	icon_state = "core"
	health = 2000
	cover_range = WEED_RANGE_CORE
	node_type = /obj/effect/alien/weeds/node/pylon/core
	var/hardcore = FALSE
	var/next_attacked_message = 5 SECONDS
	var/last_attacked_message = 0
	var/warn = TRUE // should we warn of hivecore destruction?
	var/heal_amount = 100
	var/heal_interval = 10 SECONDS
	var/last_healed = 0
	var/last_attempt = 0 // logs time of last attempt to prevent spam. if you want to destroy it, you must commit.
	var/last_larva_time = 0
	var/last_surge_time = 0
	var/spawn_cooldown = 30 SECONDS
	var/surge_cooldown = 90 SECONDS
	var/surge_incremental_reduction = 3 SECONDS
	var/crash_mode = FALSE

	protection_level = 20

	light_on = TRUE
	light_range = 4
	light_power = 0.3
	light_system = STATIC_LIGHT
	light_color = COLOR_PURPLE_GRAY

/obj/effect/alien/resin/special/pylon/core/Initialize(mapload, datum/faction/faction_to_set)
	. = ..()

	if(faction_to_set)
		faction = faction_to_set
		faction_to_set.set_faction_location(src)

	faction.hive_location = src
	SSmapview.add_marker(src, "hive_core")

/obj/effect/alien/resin/special/pylon/core/process()
	// Handle spawning larva if core is connected to a hive
	if(faction)
		for(var/mob/living/carbon/xenomorph/larva/larva in range(2, src))
			if(!larva.ckey && larva.burrowable && !QDELETED(larva))
				visible_message(SPAN_XENODANGER("[larva] quickly burrows into \the [src]."))
				faction.stored_larva++
				faction.faction_ui.update_burrowed_larva()
				qdel(larva)

		if((last_larva_time + spawn_cooldown) < world.time && can_spawn_larva()) // every minute
			last_larva_time = world.time
			var/list/players_with_xeno_pref = get_alien_candidates()
			if(players_with_xeno_pref && players_with_xeno_pref.len && can_spawn_larva())
				spawn_burrowed_larva(pick(players_with_xeno_pref))

		if((faction.hijack_burrowed_surge || crash_mode) && (last_surge_time + surge_cooldown) < world.time)
			last_surge_time = world.time
			faction.stored_larva++
			faction.faction_ui.update_burrowed_larva()
			announce_dchat("The hive has gained another burrowed larva! Use the Join As Xeno verb to take it.", src)
			if(surge_cooldown > 30 SECONDS) //mostly for sanity purposes
				surge_cooldown = surge_cooldown - surge_incremental_reduction //ramps up over time

	// Hive core can repair itself over time
	if(health < maxhealth && last_healed <= world.time)
		health += min(heal_amount, maxhealth-health)
		last_healed = world.time + heal_interval

/obj/effect/alien/resin/special/pylon/core/proc/can_spawn_larva()
	if(faction.hardcore)
		return FALSE

	return faction.stored_larva

/obj/effect/alien/resin/special/pylon/core/proc/spawn_burrowed_larva(mob/xeno_candidate)
	if(can_spawn_larva() && xeno_candidate)
		var/mob/living/carbon/xenomorph/larva/new_xeno = spawn_faction_larva(loc, faction)
		if(isnull(new_xeno))
			return FALSE

		new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly emerges from [src]!"),
		SPAN_XENODANGER("You emerge from [src] and awaken from your slumber. For the Hive!"))
		msg_admin_niche("[key_name(new_xeno)] emerged from \a [src]. (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
		playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 50, 1)
		if(!SSticker.mode.transfer_xenomorph(xeno_candidate, new_xeno))
			qdel(new_xeno)
			return FALSE
		to_chat(new_xeno, SPAN_XENOANNOUNCE("You are a xenomorph larva awakened from slumber!"))
		playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 50, 1)
		if(new_xeno.client)
			if(new_xeno.client?.prefs.toggles_flashing & FLASH_POOLSPAWN)
				window_flash(new_xeno.client)

		faction.stored_larva--
		faction.faction_ui.update_burrowed_larva()

		return TRUE
	return FALSE

/obj/effect/alien/resin/special/pylon/core/attackby(obj/item/attack_item, mob/user)
	if(!istype(attack_item, /obj/item/grab) || !isxeno(user))
		return ..(attack_item, user)

	var/larva_amount = 0 // The amount of larva they get

	var/obj/item/grab/grab = attack_item
	if(!isxeno(grab.grabbed_thing))
		return
	var/mob/living/carbon/carbon_mob = grab.grabbed_thing
	if(carbon_mob.buckled)
		to_chat(user, SPAN_XENOWARNING("Unbuckle first!"))
		return
	if(!faction || carbon_mob.stat != DEAD)
		return

	if(SSticker.mode && !(SSticker.mode.flags_round_type & MODE_XVX))
		return // For now, disabled on gamemodes that don't support it (primarily distress signal)

	// Will probably allow for hives to slowly gain larva by killing hostile xenos and taking them to the hive core
	// A self sustaining cycle until one hive kills more of the other hive to tip the balance

	// Makes attacking hives very profitable if they can successfully wipe them out without suffering any significant losses
	var/mob/living/carbon/xenomorph/xeno = carbon_mob
	if(xeno.faction != faction)
		if(isqueen(xeno))
			larva_amount = 5
		else
			larva_amount += max(xeno.tier, 1) // Now you always gain larva.
	else
		return

	if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
		return

	visible_message(SPAN_DANGER("[src] engulfs [xeno] in resin!"))
	playsound(src, "alien_resin_build", 25, 1)
	qdel(xeno)

	faction.stored_larva += larva_amount
	faction.faction_ui.update_burrowed_larva()

/obj/effect/alien/resin/special/pylon/core/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent != INTENT_HELP && xeno.can_destroy_special() && xeno.faction == faction)
		if(!hardcore && last_attempt + 6 SECONDS > world.time)
			to_chat(xeno,SPAN_WARNING("You have attempted to destroy \the [src] too recently! Wait a bit!")) // no spammy
		else
			if((alert(xeno, xeno.client.auto_lang(LANGUAGE_HIVE_CORE_COLDOWN), xeno.client.auto_lang(LANGUAGE_CONFIRM), xeno.client.auto_lang(LANGUAGE_YES), xeno.client.auto_lang(LANGUAGE_NO)) != xeno.client.auto_lang(LANGUAGE_YES)))
				INVOKE_ASYNC(src, PROC_REF(startDestroying), xeno)
		return XENO_NO_DELAY_ACTION

	if(faction)
		var/current_health = health
		if(hardcore && (xeno.faction == faction || xeno.faction.faction_is_ally(faction)))
			return XENO_NO_DELAY_ACTION
		. = ..()
		if(hardcore && last_attacked_message < world.time && current_health > health)
			xeno_message(SPAN_XENOANNOUNCE(xeno.client.auto_lang(LANGUAGE_HIVE_CORE_UNDER_ATTACK)), 2, faction)
			last_attacked_message = world.time + next_attacked_message
	else
		. = ..()

/obj/effect/alien/resin/special/pylon/core/Destroy()
	if(faction)
		visible_message(SPAN_XENOHIGHDANGER("The resin roof withers away as \the [src] dies!"), max_distance = WEED_RANGE_CORE)
		faction.faction_location = null
		if(world.time < XENOMORPH_PRE_SETUP_CUTOFF && !hardcore)
			. = ..()
			return
		faction.hivecore_cooldown = TRUE
		INVOKE_ASYNC(src, PROC_REF(cooldownFinish), faction) // start cooldown
		if(hardcore)
			xeno_message(SPAN_XENOANNOUNCE("You can no longer gain new sisters or another Queen. Additionally, you are unable to heal if your Queen is dead"), 2, faction)
			faction.hardcore = TRUE
			faction.allow_queen_evolve = FALSE
			faction.faction_structures_limit[XENO_STRUCTURE_CORE] = 0
			faction.faction_structures_limit[XENO_STRUCTURE_POOL] = 0
			xeno_announcement("\The [faction.name] has lost their hive core!", "everything", HIGHER_FORCE_ANNOUNCE)

		if(faction.hijack_burrowed_surge)
			visible_message(SPAN_XENODANGER("You hear something resembling a scream from [src] as it's destroyed!"))
			xeno_message(SPAN_XENOANNOUNCE("Psychic pain storms throughout the hive as [src] is destroyed! You will no longer gain burrowed larva over time."), 3, faction)
			faction.hijack_burrowed_surge = FALSE

	. = ..()

/obj/effect/alien/resin/special/pylon/core/proc/startDestroying(mob/living/carbon/xenomorph/xeno)
	xeno_message(SPAN_XENOANNOUNCE("[xeno] is destroying \the [src]!"), 3, faction)
	visible_message(SPAN_DANGER("[xeno] starts destroying \the [src]!"))
	last_attempt = world.time //spamcheck
	if(!do_after(xeno, 5 SECONDS , INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(xeno,SPAN_WARNING("You stop destroying \the [src]."))
		visible_message(SPAN_WARNING("[xeno] stops destroying \the [src]."))
		last_attempt = world.time // update the spam check
		return XENO_NO_DELAY_ACTION
	qdel(src)

/obj/effect/alien/resin/special/pylon/core/proc/cooldownFinish(datum/faction/faction)
	sleep(HIVECORE_COOLDOWN)
	if(faction.hivecore_cooldown) // check if its true so we don't double set it.
		faction.hivecore_cooldown = FALSE
		xeno_message(SPAN_XENOANNOUNCE("The weeds have recovered! A new hive core can be built!"), 3, faction)
	else
		log_admin("Hivecore cooldown reset proc aborted due to hivecore cooldown var being set to false before the cooldown has finished!")
		// Tell admins that this condition is reached so they know what has happened if it fails somehow
		return

#undef PYLON_REPAIR_TIME
#undef PYLON_WEEDS_REGROWTH_TIME
