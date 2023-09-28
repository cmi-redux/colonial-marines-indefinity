// devolve a xeno - lots of old, vaguely shitty code here
/datum/action/xeno_action/onclick/deevolve/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return
	if(!user_xeno.observed_xeno)
		to_chat(user_xeno, SPAN_WARNING("You must overwatch the xeno you want to de-evolve."))
		return

	var/mob/living/carbon/xenomorph/target_xeno = user_xeno.observed_xeno
	if(!user_xeno.check_plasma(plasma_cost))
		return

	if(target_xeno.faction != user_xeno.faction)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] doesn't belong to your hive!"))
		return

	if(target_xeno.is_ventcrawling)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] can't be deevolved here."))
		return

	if(!isturf(target_xeno.loc))
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] can't be deevolved here."))
		return

	if(target_xeno.health <= 0)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] is too weak to be deevolved."))
		return

	if(length(target_xeno.caste.deevolves_to) < 1)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] can't be deevolved."))
		return

	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] is banished and can't be deevolved."))
		return


	var/newcaste

	if(length(target_xeno.caste.deevolves_to) == 1)
		newcaste = target_xeno.caste.deevolves_to[1]
	else if(length(target_xeno.caste.deevolves_to) > 1)
		newcaste = tgui_input_list(user_xeno, "Choose a caste you want to de-evolve [target_xeno] to.", "De-evolve", target_xeno.caste.deevolves_to, theme = "hive_status")

	if(!newcaste)
		return

	if(newcaste == "Larva")
		to_chat(user_xeno, SPAN_XENOWARNING("You cannot deevolve xenomorphs to larva."))
		return

	if(user_xeno.observed_xeno != target_xeno)
		return

	if(alert(user_xeno, "Are you sure you want to deevolve [target_xeno] from [target_xeno.caste.caste_type] to [newcaste]?", , owner.client.auto_lang(LANGUAGE_YES), owner.client.auto_lang(LANGUAGE_NO)) != owner.client.auto_lang(LANGUAGE_YES))
		return

	var/reason = stripped_input(user_xeno, "Provide a reason for deevolving this xenomorph, [target_xeno]")
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("You must provide a reason for deevolving [target_xeno]."))
		return

	if(!check_and_use_plasma_owner(plasma_cost))
		return

	to_chat(target_xeno, SPAN_XENOWARNING("The queen is deevolving you for the following reason: [reason]"))

	var/xeno_type
	var/level_to_switch_to = target_xeno.get_vision_level()
	switch(newcaste)
		if(XENO_CASTE_RUNNER)
			xeno_type = /mob/living/carbon/xenomorph/runner
		if(XENO_CASTE_DRONE)
			xeno_type = /mob/living/carbon/xenomorph/drone
		if(XENO_CASTE_SENTINEL)
			xeno_type = /mob/living/carbon/xenomorph/sentinel
		if(XENO_CASTE_SPITTER)
			xeno_type = /mob/living/carbon/xenomorph/spitter
		if(XENO_CASTE_LURKER)
			xeno_type = /mob/living/carbon/xenomorph/lurker
		if(XENO_CASTE_WARRIOR)
			xeno_type = /mob/living/carbon/xenomorph/warrior
		if(XENO_CASTE_DEFENDER)
			xeno_type = /mob/living/carbon/xenomorph/defender
		if(XENO_CASTE_BURROWER)
			xeno_type = /mob/living/carbon/xenomorph/burrower

	//From there, the new xeno exists, hopefully
	var/mob/living/carbon/xenomorph/new_xeno = new xeno_type(get_turf(target_xeno), target_xeno)

	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(user_xeno, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		if(new_xeno)
			qdel(new_xeno)
		return

	if(target_xeno.mind)
		target_xeno.mind.transfer_to(new_xeno)
	else
		new_xeno.key = target_xeno.key
		if(new_xeno.client)
			new_xeno.client.change_view(world_view_size)
			new_xeno.client.pixel_x = 0
			new_xeno.client.pixel_y = 0

	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()
	if(new_xeno.client)
		new_xeno.set_lighting_alpha(level_to_switch_to)
	// If the player has self-deevolved before, don't allow them to do it again
	if(!(/mob/living/carbon/xenomorph/verb/Deevolve in target_xeno.verbs))
		remove_verb(new_xeno, /mob/living/carbon/xenomorph/verb/Deevolve)

	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_type] emerges from the husk of \the [target_xeno]."), \
	SPAN_XENODANGER("[user_xeno] makes you regress into your previous form."))

	if(user_xeno.faction.living_xeno_queen && user_xeno.faction.living_xeno_queen.observed_xeno == target_xeno)
		user_xeno.faction.living_xeno_queen.overwatch(new_xeno)

	message_admins("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")
	log_admin("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")

	target_xeno.transfer_observers_to(new_xeno)

	if(SSticker.mode.round_statistics && !new_xeno.statistic_exempt)
		SSticker.mode.round_statistics.track_new_participant(target_xeno.faction, -1) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.stop_tracking(target_xeno)
	SSround_recording.recorder.track_player(new_xeno)
	qdel(target_xeno)
	return ..()

/datum/action/xeno_action/onclick/remove_eggsac/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(user_xeno.action_busy) return
	if(alert(user_xeno, "Are you sure you want to remove your ovipositor? (5 min cooldown to grow a new one)", , owner.client.auto_lang(LANGUAGE_YES), owner.client.auto_lang(LANGUAGE_NO)) != owner.client.auto_lang(LANGUAGE_YES))
		return
	if(!user_xeno.check_state())
		return
	if(!user_xeno.ovipositor)
		return
	user_xeno.visible_message(SPAN_XENOWARNING("\The [user_xeno] starts detaching itself from its ovipositor!"), \
		SPAN_XENOWARNING("You start detaching yourself from your ovipositor."))
	if(!do_after(user_xeno, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 10)) return
	if(!user_xeno.check_state())
		return
	if(!user_xeno.ovipositor)
		return
	user_xeno.dismount_ovipositor()
	return ..()

/datum/action/xeno_action/onclick/grow_ovipositor/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	var/turf/current_turf = get_turf(user_xeno)
	if(!current_turf || !istype(current_turf))
		return

	if(!action_cooldown_check())
		to_chat(user_xeno, SPAN_XENOWARNING("You're still recovering from detaching your old ovipositor. Wait [DisplayTimeText(timeleft(cooldown_timer_id), language = CLIENT_LANGUAGE_RUSSIAN)]."))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(user_xeno, SPAN_XENOWARNING("You need to be on resin to grow an ovipositor."))
		return

	if(SSinterior.in_interior(user_xeno))
		to_chat(user_xeno, SPAN_XENOWARNING("It's too tight in here to grow an ovipositor."))
		return

	if(alien_weeds.faction != user_xeno.faction)
		to_chat(user_xeno, SPAN_XENOWARNING("These weeds don't belong to your hive! You can't grow an ovipositor here."))
		return

	if(!user_xeno.check_alien_construction(current_turf))
		return

	if(user_xeno.action_busy)
		return

	if(!user_xeno.check_plasma(plasma_cost))
		return

	user_xeno.visible_message(SPAN_XENOWARNING("\The [user_xeno] starts to grow an ovipositor."), \
	SPAN_XENOWARNING("You start to grow an ovipositor...(takes 20 seconds, hold still)"))
	if(!do_after(user_xeno, 200, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, numticks = 20) && user_xeno.check_plasma(plasma_cost))
		return
	if(!user_xeno.check_state()) return
	if(!locate(/obj/effect/alien/weeds) in current_turf)
		return
	user_xeno.use_plasma(plasma_cost)
	user_xeno.visible_message(SPAN_XENOWARNING("\The [user_xeno] has grown an ovipositor!"), \
	SPAN_XENOWARNING("You have grown an ovipositor!"))
	user_xeno.mount_ovipositor()
	return ..()

/datum/action/xeno_action/onclick/set_xeno_lead/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(!action_cooldown_check())
		return
	var/datum/faction/faction = user_xeno.faction
	if(user_xeno.observed_xeno)
		if(!faction.open_xeno_leader_positions.len && user_xeno.observed_xeno.hive_pos == NORMAL_XENO)
			to_chat(user_xeno, SPAN_XENOWARNING("You currently have [faction.xeno_leader_list.len] promoted leaders. You may not maintain additional leaders until your power grows."))
			return
		var/mob/living/carbon/xenomorph/target_xeno = user_xeno.observed_xeno
		if(target_xeno == user_xeno)
			to_chat(user_xeno, SPAN_XENOWARNING("You cannot add yourself as a leader!"))
			return
		apply_cooldown()
		if(target_xeno.hive_pos == NORMAL_XENO)
			if(!faction.add_hive_leader(target_xeno))
				to_chat(user_xeno, SPAN_XENOWARNING("Unable to add the leader."))
				return
			to_chat(user_xeno, SPAN_XENONOTICE("You've selected [target_xeno] as a Hive Leader."))
			to_chat(target_xeno, SPAN_XENOANNOUNCE("[user_xeno] has selected you as a Hive Leader. The other Xenomorphs must listen to you. You will also act as a beacon for the Queen's pheromones."))
		else
			faction.remove_hive_leader(target_xeno)
			to_chat(user_xeno, SPAN_XENONOTICE("You've demoted [target_xeno] from Hive Leader."))
			to_chat(target_xeno, SPAN_XENOANNOUNCE("[user_xeno] has demoted you from Hive Leader. Your leadership rights and abilities have waned."))
	else
		var/list/possible_xenos = list()
		for(var/mob/living/carbon/xenomorph/target_xeno in faction.xeno_leader_list)
			possible_xenos += target_xeno

		if(possible_xenos.len > 1)
			var/mob/living/carbon/xenomorph/selected_xeno = tgui_input_list(user_xeno, "Target", "Watch which leader?", possible_xenos, theme="hive_status")
			if(!selected_xeno || selected_xeno.hive_pos == NORMAL_XENO || selected_xeno == user_xeno.observed_xeno || selected_xeno.stat == DEAD || selected_xeno.z != user_xeno.z || !user_xeno.check_state())
				return
			user_xeno.overwatch(selected_xeno)
		else if(possible_xenos.len)
			user_xeno.overwatch(possible_xenos[1])
		else
			to_chat(user_xeno, SPAN_XENOWARNING("There are no Xenomorph leaders. Overwatch a Xenomorph to make it a leader."))
	return ..()

/datum/action/xeno_action/activable/queen_heal/use_ability(atom/A, verbose)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		to_chat(user_xeno, SPAN_WARNING("You must select a valid turf to heal around."))
		return

	if(user_xeno.loc.z != target_turf.loc.z)
		to_chat(user_xeno, SPAN_XENOWARNING("You are too far away to do this here."))
		return

	if(!check_and_use_plasma_owner())
		return

	for(var/mob/living/carbon/xenomorph/target_xeno in range(4, target_turf))
		if(!user_xeno.can_not_harm(target_xeno))
			continue

		if(SEND_SIGNAL(target_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			if(verbose)
				to_chat(user_xeno, SPAN_XENOMINORWARNING("You cannot heal [target_xeno]!"))
			continue

		if(target_xeno == user_xeno)
			continue

		if(target_xeno.stat == DEAD || QDELETED(target_xeno))
			continue

		if(!target_xeno.caste.can_be_queen_healed)
			continue

		var/amount_heal = target_xeno.maxHealth * 0.3
		user_xeno.track_heal_damage(null, target_xeno, amount_heal)
		new /datum/effects/heal_over_time(target_xeno, amount_heal, 2 SECONDS, 2)
		target_xeno.flick_heal_overlay(3 SECONDS, "#D9F500") //it's already hard enough to gauge health without hp overlays!

	apply_cooldown()
	to_chat(user_xeno, SPAN_XENONOTICE("You channel your plasma to heal your sisters' wounds around this area."))
	return ..()

/datum/action/xeno_action/onclick/give_evo_points/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost))
		return

	if(world.time < SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK)
		to_chat(usr, SPAN_XENOWARNING("You must give some time for larva to spawn before sacrificing them. Please wait another [round((SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK - world.time) / 600)] minutes."))
		return

	var/choice = tgui_input_list(user_xeno, "Choose a xenomorph to give evolution points for a burrowed larva:", "Give Evolution Points", user_xeno.faction.totalMobs, theme="hive_status")

	if(!choice)
		return

	var/mob/living/carbon/xenomorph/target_xeno

	for(var/mob/living/carbon/xenomorph/xeno in user_xeno.faction.totalMobs)
		if(html_encode(xeno.name) == html_encode(choice))
			target_xeno = xeno
			break

	if(target_xeno == user_xeno)
		to_chat(user_xeno, SPAN_XENOWARNING("You cannot give evolution points to yourself."))
		return

	if(target_xeno.evolution_stored == target_xeno.evolution_threshold)
		to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph is already ready to evolve!"))
		return

	if(target_xeno.faction != user_xeno.faction)
		to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph doesn't belong to your hive!"))
		return

	if(target_xeno.health < 0)
		to_chat(user_xeno, SPAN_XENOWARNING("What's the point? They're about to die."))
		return

	if(user_xeno.faction.stored_larva < required_larva)
		to_chat(user_xeno, SPAN_XENOWARNING("You need at least [required_larva] burrowed larva to sacrifice one for evolution points."))
		return

	if(tgui_alert(user_xeno, "Are you sure you want to sacrifice a larva to give [target_xeno] [evo_points_per_larva] evolution points?", "Give Evolution Points", list("Yes", "No")) != "Yes")
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost) || target_xeno.health < 0 || user_xeno.faction.stored_larva < required_larva)
		return

	to_chat(target_xeno, SPAN_XENOWARNING("\The [user_xeno] has given you evolution points! Use them well."))
	to_chat(user_xeno, SPAN_XENOWARNING("\The [target_xeno] was given [evo_points_per_larva] evolution points."))

	if(target_xeno.evolution_stored + evo_points_per_larva > target_xeno.evolution_threshold)
		target_xeno.evolution_stored = target_xeno.evolution_threshold
	else
		target_xeno.evolution_stored += evo_points_per_larva

	user_xeno.faction.stored_larva--
	return ..()

/datum/action/xeno_action/onclick/banish/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost))
		return

	var/choice = tgui_input_list(user_xeno, "Choose a xenomorph to banish:", "Banish", user_xeno.faction.totalMobs, theme = "hive_status")

	if(!choice)
		return

	var/mob/living/carbon/xenomorph/target_xeno

	for(var/mob/living/carbon/xenomorph/potential in user_xeno.faction.totalMobs)
		if(html_encode(potential.name) == html_encode(choice))
			target_xeno = potential
			break

	if(target_xeno == user_xeno)
		to_chat(user_xeno, SPAN_XENOWARNING("You cannot banish yourself."))
		return

	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("This user_xeno is already banished!"))
		return

	if(target_xeno.faction != user_xeno.faction)
		to_chat(user_xeno, SPAN_XENOWARNING("This user_xeno doesn't belong to your hive!"))
		return

	// No banishing critted xenos
	if(target_xeno.health < 0)
		to_chat(user_xeno, SPAN_XENOWARNING("What's the point? They're already about to die."))
		return

	if(alert(user_xeno, "Are you sure you want to banish [target_xeno] from the hive? This should only be done with good reason. (Note this prevents them from rejoining the hive after dying for 30 minutes as well unless readmitted)", , owner.client.auto_lang(LANGUAGE_YES), owner.client.auto_lang(LANGUAGE_NO)) != owner.client.auto_lang(LANGUAGE_YES))
		return

	var/reason = stripped_input(user_xeno, "Provide a reason for banishing [target_xeno]. This will be announced to the entire hive!")
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("You must provide a reason for banishing [target_xeno]."))
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost) || target_xeno.health < 0)
		return

	// Let everyone know they were banished
	xeno_announcement("By [user_xeno]'s will, [target_xeno] has been banished from the hive!\n\n[reason]", user_xeno.faction, title = SPAN_ANNOUNCEMENT_HEADER_BLUE("Banishment"))
	to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [user_xeno] has banished you from the hive! Other xenomorphs may now attack you freely, but your link to the hivemind remains, preventing you from harming other sisters.")))

	target_xeno.banished = TRUE
	target_xeno.hud_update_banished()
	target_xeno.lock_evolve = TRUE
	user_xeno.faction.banished_ckeys[target_xeno.name] = target_xeno.ckey
	addtimer(CALLBACK(src, PROC_REF(remove_banish), user_xeno.faction, target_xeno.name), 30 MINUTES)

	message_admins("[key_name_admin(user_xeno)] has banished [key_name_admin(target_xeno)]. Reason: [reason]")
	return ..()

/datum/action/xeno_action/onclick/banish/proc/remove_banish(datum/faction/faction, name)
	faction.banished_ckeys.Remove(name)


// Readmission = un-banish

/datum/action/xeno_action/onclick/readmit/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost))
		return

	var/choice = tgui_input_list(user_xeno, "Choose a xenomorph to readmit:", "Re-admit", user_xeno.faction.banished_ckeys, theme="hive_status")

	if(!choice)
		return

	var/banished_ckey
	var/banished_name

	for(var/mob_name in user_xeno.faction.banished_ckeys)
		if(user_xeno.faction.banished_ckeys[mob_name] == user_xeno.faction.banished_ckeys[choice])
			banished_ckey = user_xeno.faction.banished_ckeys[mob_name]
			banished_name = mob_name
			break

	var/banished_living = FALSE
	var/mob/living/carbon/xenomorph/target_xeno

	for(var/mob/living/carbon/xenomorph/potential in user_xeno.faction.totalMobs)
		if(potential.ckey == banished_ckey)
			target_xeno = potential
			banished_living = TRUE
			break

	if(banished_living)
		if(!target_xeno.banished)
			to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph isn't banished!"))
			return

		if(alert(user_xeno, "Are you sure you want to readmit [target_xeno] into the hive?", , owner.client.auto_lang(LANGUAGE_YES), owner.client.auto_lang(LANGUAGE_NO)) != owner.client.auto_lang(LANGUAGE_YES))
			return

		if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost))
			return

		to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [user_xeno] has readmitted you into the hive.")))
		target_xeno.banished = FALSE
		target_xeno.hud_update_banished()
		target_xeno.lock_evolve = FALSE

	user_xeno.faction.banished_ckeys.Remove(banished_name)
	return ..()

/datum/action/xeno_action/onclick/eye
	name = "Enter Eye Form"
	action_icon_state = "queen_eye"
	plasma_cost = 0

/datum/action/xeno_action/onclick/eye/use_ability(atom/A)
	. = ..()
	if(!owner)
		return

	new /mob/hologram/queen(owner.loc, owner)
	qdel(src)

/datum/action/xeno_action/activable/expand_weeds
	var/list/recently_built_turfs

/datum/action/xeno_action/activable/expand_weeds/New(Target, override_icon_state)
	. = ..()
	recently_built_turfs = list()

/datum/action/xeno_action/activable/expand_weeds/Destroy()
	recently_built_turfs = null
	return ..()

/datum/action/xeno_action/activable/expand_weeds/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/target_turf = get_turf(A)

	if(!target_turf || target_turf.weedable < FULLY_WEEDABLE || target_turf.snow || (target_turf.z != user_xeno.z))
		to_chat(user_xeno, SPAN_XENOWARNING("You can't do that here."))
		return

	var/area/AR = get_area(target_turf)
	if(!AR.is_resin_allowed)
		if(AR.flags_area & AREA_UNWEEDABLE)
			to_chat(X, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	var/obj/effect/alien/weeds/located_weeds = locate() in target_turf
	if(located_weeds)
		if(istype(located_weeds, /obj/effect/alien/weeds/node))
			return

		if(located_weeds.weed_strength > user_xeno.weed_level)
			to_chat(user_xeno, SPAN_XENOWARNING("There's stronger weeds here already!"))
			return

		if(!check_and_use_plasma_owner(node_plant_plasma_cost))
			return

		to_chat(user_xeno, SPAN_XENONOTICE("You plant a node at [target_turf]."))
		new /obj/effect/alien/weeds/node(target_turf, null, user_xeno)
		playsound(target_turf, "alien_resin_build", 35)
		apply_cooldown_override(node_plant_cooldown)
		return

	var/obj/effect/alien/weeds/node/node
	for(var/direction in  GLOB.cardinals)
		var/obj/effect/alien/weeds/weeds = locate() in get_step(target_turf, direction)
		if(weeds && weeds.faction == user_xeno.faction && weeds.parent && !weeds.hibernate && !LinkBlocked(weeds, get_turf(weeds), target_turf))
			node = weeds.parent
			break

	if(!node)
		to_chat(user_xeno, SPAN_XENOWARNING("You can only plant weeds near weeds with a connected node!"))
		return

	if(target_turf in recently_built_turfs)
		to_chat(user_xeno, SPAN_XENOWARNING("You've recently built here already!"))
		return

	if(!check_and_use_plasma_owner())
		return

	new /obj/effect/alien/weeds(target_turf, node)
	playsound(target_turf, "alien_resin_build", 35)

	recently_built_turfs += target_turf
	addtimer(CALLBACK(src, PROC_REF(reset_turf_cooldown), target_turf), turf_build_cooldown)

	to_chat(user_xeno, SPAN_XENONOTICE("You plant weeds at [target_turf]."))
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/expand_weeds/proc/reset_turf_cooldown(turf/target_turf)
	recently_built_turfs -= target_turf

/datum/action/xeno_action/activable/place_queen_beacon/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return FALSE

	if(user_xeno.action_busy)
		return FALSE

	var/turf/target_turf = get_turf(A)
	if(!check_turf(user_xeno, target_turf))
		return FALSE
	if(!do_after(user_xeno, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		return FALSE
	if(!check_turf(user_xeno, target_turf))
		return FALSE

	for(var/i in transported_xenos)
		UnregisterSignal(i, COMSIG_MOVABLE_PRE_MOVE)

	to_chat(user_xeno, SPAN_XENONOTICE("You rally the hive to the queen beacon!"))
	LAZYCLEARLIST(transported_xenos)
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, PROC_REF(tunnel_xeno))
	for(var/xeno in faction.totalMobs)
		if(xeno == user_xeno)
			continue
		tunnel_xeno(src, xeno)

	addtimer(CALLBACK(src, PROC_REF(transport_xenos), target_turf), 3 SECONDS)
	return ..()

/datum/action/xeno_action/activable/place_queen_beacon/proc/tunnel_xeno(datum/source, mob/living/carbon/xenomorph/user_xeno)
	SIGNAL_HANDLER
	if(user_xeno.z == owner.z)
		to_chat(user_xeno, SPAN_XENONOTICE("You begin tunneling towards the queen beacon!"))
		RegisterSignal(user_xeno, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(cancel_movement))
		LAZYADD(transported_xenos, user_xeno)

/datum/action/xeno_action/activable/place_queen_beacon/proc/transport_xenos(turf/target_turf)
	UnregisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN)
	for(var/xeno in transported_xenos)
		var/mob/living/carbon/xenomorph/user_xeno = xeno
		to_chat(user_xeno, SPAN_XENONOTICE("You tunnel to the queen beacon!"))
		UnregisterSignal(user_xeno, COMSIG_MOVABLE_PRE_MOVE)
		if(target_turf)
			user_xeno.forceMove(target_turf)

/datum/action/xeno_action/activable/place_queen_beacon/proc/cancel_movement()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_MOVE

/datum/action/xeno_action/activable/place_queen_beacon/proc/check_turf(mob/living/carbon/xenomorph/queen/user_xeno, turf/target_turf)
	if(!target_turf || target_turf.density)
		to_chat(user_xeno, SPAN_XENOWARNING("You can't place a queen beacon here."))
		return FALSE

	if(target_turf.z != user_xeno.z)
		to_chat(user_xeno, SPAN_XENOWARNING("That's too far away!"))
		return FALSE

	var/obj/effect/alien/weeds/located_weeds = locate() in target_turf
	if(!located_weeds)
		to_chat(user_xeno, SPAN_XENOWARNING("You need to place the queen beacon on weeds."))
		return FALSE

	return TRUE


/datum/action/xeno_action/activable/blockade/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	if(user_xeno.action_busy)
		return FALSE

	var/width = initial(pillar_type.width)
	var/height = initial(pillar_type.height)

	var/turf/target_turf = get_turf(A)
	if(target_turf.density)
		to_chat(user_xeno, SPAN_XENOWARNING("You can only construct this blockade in open areas!"))
		return FALSE

	if(target_turf.z != owner.z)
		to_chat(user_xeno, SPAN_XENOWARNING("That's too far away!"))
		return FALSE

	if(!target_turf.weeds)
		to_chat(user_xeno, SPAN_XENOWARNING("You can only construct this blockade on weeds!"))
		return FALSE

	if(!user_xeno.check_plasma(plasma_cost))
		return

	var/list/alerts = list()
	for(var/i in RANGE_TURFS(round(width/2), target_turf))
		alerts += new /obj/effect/warning/alien(i)

	if(!do_after(user_xeno, time_taken, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		QDEL_NULL_LIST(alerts)
		return FALSE
	QDEL_NULL_LIST(alerts)

	if(!check_turf(user_xeno, target_turf))
		return FALSE

	if(!check_and_use_plasma_owner())
		return

	var/turf/new_turf = locate(max(target_turf.x - round(width/2), 1), max(target_turf.y - round(height/2), 1), target_turf.z)
	to_chat(user_xeno, SPAN_XENONOTICE("You raise a blockade!"))
	var/obj/effect/alien/resin/resin_pillar/RP = new pillar_type(new_turf)
	RP.start_decay(brittle_time, decay_time)

	return ..()

/datum/action/xeno_action/activable/blockade/proc/check_turf(mob/living/carbon/xenomorph/queen/target_turf, turf/target_turf)
	if(target_turf.density)
		to_chat(target_turf, SPAN_XENOWARNING("You can't place a blockade here."))
		return FALSE

	return TRUE

/mob/living/carbon/xenomorph/proc/xeno_tacmap()
	set name = "View Xeno Tacmap"
	set desc = "This opens a tactical map, where you can see where every xenomorph is."
	set category = "Alien"

	mapview()

/mob/living/carbon/xenomorph/proc/mapview()
	var/datum/ui_minimap/chosed = minimap["[map_to_view]"]
	chosed.tgui_interact(src)

/mob/living/carbon/xenomorph/proc/xeno_tacmap_loc_change()
	set name = "Xeno Tacmap Location Change"
	set desc = "This changes tactical map location, where you can see where every xenomorph is."
	set category = "Alien"

	map_to_view = tgui_input_list(src, "Choose map to view.", minimap_name, ALL_MAPVIEW_MAPTYPES)
