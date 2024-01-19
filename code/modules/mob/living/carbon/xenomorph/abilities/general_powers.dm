//// Powers used by multiple Xenomorphs.
// In general, powers files hold actual implementations of abilities,
// and abilities files hold the object declarations for the abilities

// Plant weeds
/datum/action/xeno_action/onclick/plant_weeds/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check())
		return
	if(!xeno.check_state())
		return
	if(xeno.burrow)
		return

	var/turf/target_turf = xeno.loc

	if(!istype(target_turf) || !(target_turf.turf_flags & TURF_EFFECT_AFFECTABLE))
		to_chat(xeno, SPAN_WARNING("You can't do that here."))
		return

	var/obj/effect/alien/weeds/node/node = locate() in target_turf
	if(node && node.weed_strength >= WEED_LEVEL_HIVE)
		to_chat(xeno, SPAN_WARNING("There's a pod here already!"))
		return

	for(var/obj/structure/struct in target_turf)
		if(struct.density && !(struct.flags_atom & ON_BORDER)) // Not sure exactly if we need to test against ON_BORDER though
			to_chat(xeno, SPAN_WARNING("You can't do that here."))
			return

	var/obj/effect/alien/resin/trap/resin_trap = locate() in target_turf
	if(resin_trap)
		to_chat(xeno, SPAN_WARNING("You can't weed on top of a trap!"))
		return

	var/obj/effect/alien/weeds/weed = node || locate() in target_turf
	if(weed && weed.weed_strength >= WEED_LEVEL_HIVE)
		to_chat(xeno, SPAN_WARNING("These weeds are too strong to plant a node on!"))
		return

	for(var/obj/structure/struct in target_turf)
		if(struct.density && !(struct.flags_atom & ON_BORDER)) // Not sure exactly if we need to test against ON_BORDER though
			to_chat(xeno, SPAN_WARNING("You can't do that here."))
			return

	var/area/area = get_area(target_turf)
	if(isnull(area) || !(area.is_resin_allowed))
		if(area.flags_area & AREA_UNWEEDABLE)
			to_chat(xeno, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(xeno, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	if(!check_and_use_plasma_owner())
		return

	var/list/to_convert
	if(node)
		to_convert = node.children.Copy()

	xeno.visible_message(SPAN_XENONOTICE("\The [xeno] regurgitates a pulsating node and plants it on the ground!"), \
	SPAN_XENONOTICE("You regurgitate a pulsating node and plant it on the ground!"), null, 5)
	var/obj/effect/alien/weeds/node/new_node = new node_type(xeno.loc, src, xeno)

	if(to_convert)
		for(var/cur_weed in to_convert)
			target_turf = get_turf(cur_weed)
			if(target_turf && !target_turf.density)
				new /obj/effect/alien/weeds(target_turf, new_node)
			qdel(cur_weed)

	playsound(xeno.loc, "alien_resin_build", 25)
	apply_cooldown()
	return ..()

/mob/living/carbon/xenomorph/lay_down()
	if(MODE_HAS_FLAG(MODE_HARDCORE))
		to_chat(src, SPAN_WARNING("No time to rest, must KILL!"))
		return

	if(fortify)
		to_chat(src, SPAN_WARNING("You cannot rest while fortified!"))
		return

	if(burrow)
		to_chat(src, SPAN_WARNING("You cannot rest while burrowed!"))
		return

	if(crest_defense)
		to_chat(src, SPAN_WARNING("You cannot rest while your crest is down!"))
		return

	return ..()

/datum/action/xeno_action/onclick/xeno_resting/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.lay_down()
	button.icon_state = xeno.resting ? "template_active" : "template"
	return ..()

// Shift spits
/datum/action/xeno_action/onclick/shift_spits/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state(1))
		return
	for(var/i in 1 to xeno.caste.spit_types.len)
		if(xeno.ammo == GLOB.ammo_list[xeno.caste.spit_types[i]])
			if(i == xeno.caste.spit_types.len)
				xeno.ammo = GLOB.ammo_list[xeno.caste.spit_types[1]]
			else
				xeno.ammo = GLOB.ammo_list[xeno.caste.spit_types[i+1]]
			break
	to_chat(xeno, SPAN_NOTICE("You will now spit [xeno.ammo.name] ([xeno.ammo.spit_cost] plasma)."))
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, "shift_spit_[xeno.ammo.icon_state]")
	return ..()

/datum/action/xeno_action/onclick/regurgitate/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(!isturf(xeno.loc))
		to_chat(xeno, SPAN_WARNING("You cannot regurgitate here."))
		return

	if(xeno.stomach_contents.len)
		for(var/mob/living/M in xeno.stomach_contents)
			// Also has good reason to be a proc on all Xenos
			xeno.regurgitate(M, TRUE)

	return ..()

/datum/action/xeno_action/onclick/choose_resin/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	tgui_interact(xeno)
	return ..()

/datum/action/xeno_action/onclick/choose_resin/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/choose_resin),
	)

/datum/action/xeno_action/onclick/choose_resin/ui_static_data(mob/user)
	var/mob/living/carbon/xenomorph/xeno = user
	if(!istype(xeno))
		return

	. = list()

	var/list/constructions = list()
	for(var/type in xeno.resin_build_order)
		var/list/entry = list()
		var/datum/resin_construction/RC = GLOB.resin_constructions_list[type]

		entry["name"] = RC.name
		entry["desc"] = RC.desc
		entry["image"] = replacetext(RC.construction_name, " ", "-")
		entry["plasma_cost"] = RC.cost
		entry["max_per_xeno"] = RC.max_per_xeno
		entry["id"] = "[type]"
		constructions += list(entry)

	.["constructions"] = constructions

/datum/action/xeno_action/onclick/choose_resin/ui_data(mob/user)
	var/mob/living/carbon/xenomorph/xeno = user
	if(!istype(xeno))
		return

	. = list()
	.["selected_resin"] = xeno.selected_resin


/datum/action/xeno_action/onclick/choose_resin/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChooseResin", "Choose Resin")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/action/xeno_action/onclick/choose_resin/Destroy()
	SStgui.close_uis(src)
	return ..()

/datum/action/xeno_action/onclick/choose_resin/ui_state(mob/user)
	return GLOB.always_state

/datum/action/xeno_action/onclick/choose_resin/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/xenomorph/xeno = usr
	if(!istype(xeno))
		return

	switch(action)
		if("choose_resin")
			var/selected_type = text2path(params["type"])
			if(!(selected_type in xeno.resin_build_order))
				return
			//update the button's overlay with new choice
			update_button_icon(selected_type, to_chat=TRUE)
			xeno.selected_resin = selected_type
			. = TRUE
		if("refresh_ui")
			. = TRUE

/datum/action/xeno_action/onclick/choose_resin/update_button_icon(selected_type, to_chat = FALSE)
	. = ..()
	if(!selected_type)
		return
	var/datum/resin_construction/resin_construction = GLOB.resin_constructions_list[selected_type]
	if(to_chat)
		to_chat(usr, SPAN_NOTICE("You will now build <b>[resin_construction.construction_name]\s</b> when secreting resin."))
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, resin_construction.construction_name)

// Resin
/datum/action/xeno_action/activable/secrete_resin/use_ability(atom/target_atom)
	if(!..())
		return FALSE
	var/mob/living/carbon/xenomorph/xeno = owner
	if(isstorage(target_atom.loc) || xeno.contains(target_atom) || istype(target_atom, /atom/movable/screen))
		return FALSE
	if(target_atom.z != xeno.z)
		to_chat(owner, SPAN_XENOWARNING("This area is too far away to affect!"))
		return
	apply_cooldown()
	switch(xeno.build_resin(target_atom, thick, make_message, plasma_cost != 0, build_speed_mod))
		if(SECRETE_RESIN_INTERRUPT)
			if(xeno_cooldown)
				apply_cooldown_override(xeno_cooldown * 2)
			return FALSE
		if(SECRETE_RESIN_FAIL)
			if(xeno_cooldown)
				apply_cooldown_override(1)
			return FALSE
	return TRUE

// leader Marker

/datum/action/xeno_action/activable/info_marker/use_ability(atom/target_atom, mods)
	if(!..())
		return FALSE

	if(mods["click_catcher"])
		return

	if(!action_cooldown_check())
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state(TRUE))
		return FALSE

	if(ismob(target_atom)) //anticheese : if they click a mob, it will cancel.
		to_chat(xeno, SPAN_XENOWARNING("You can't place resin markers on living things!"))
		return FALSE //this is because xenos have thermal vision and can see mobs through walls - which would negate not being able to place them through walls

	if(isstorage(target_atom.loc) || xeno.contains(target_atom) || istype(target_atom, /atom/movable/screen)) return FALSE
	var/turf/target_turf = get_turf(target_atom)

	if(target_turf.z != xeno.z)
		to_chat(xeno, SPAN_XENOWARNING("This area is too far away to affect!"))
		return
	if(!xeno.faction.living_xeno_queen || xeno.faction.living_xeno_queen.z != xeno.z)
		to_chat(xeno, SPAN_XENOWARNING("You have no queen, the psychic link is gone!"))
		return

	var/tally = 0

	for(var/obj/effect/alien/resin/marker/MRK in xeno.faction.resin_marks)
		if(MRK.createdby == xeno.nicknumber)
			tally++
	if(tally >= max_markers)
		to_chat(xeno, SPAN_XENOWARNING("You have reached the maximum number of resin marks."))
		var/obj/effect/alien/resin/marker/Goober = null
		var/promptuser = null
		for(var/i=1, i<=length(xeno.faction.resin_marks))
			Goober = xeno.faction.resin_marks[i]
			if(Goober.createdby == xeno.nicknumber)
				promptuser = tgui_input_list(xeno, "Remove oldest placed mark: '[Goober.mark_meaning.name]!'?", "Mark limit reached.", list(owner.client.auto_lang(LANGUAGE_YES), owner.client.auto_lang(LANGUAGE_NO)), theme="hive_status")
				break
			i++
		if(promptuser != owner.client.auto_lang(LANGUAGE_YES))
			return
		else if(promptuser == owner.client.auto_lang(LANGUAGE_YES))
			qdel(Goober)
			if(xeno.make_marker(target_turf))
				apply_cooldown()
				return TRUE
	else if(xeno.make_marker(target_turf))
		apply_cooldown()
		return TRUE


// Destructive Acid
/datum/action/xeno_action/activable/corrosive_acid/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.corrosive_acid(target, acid_type, acid_plasma_cost)
	for(var/obj/item/explosive/plastic/explosive in target.contents)
		xeno.corrosive_acid(explosive,acid_type,acid_plasma_cost)
	return ..()

/datum/action/xeno_action/onclick/emit_pheromones/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return
	xeno.emit_pheromones(emit_cost = plasma_cost)
	return ..()

/mob/living/carbon/xenomorph/proc/emit_pheromones(pheromone, emit_cost = 30)
	if(!check_state(TRUE))
		return
	if(!(locate(/datum/action/xeno_action/onclick/emit_pheromones) in actions))
		to_chat(src, SPAN_XENOWARNING("You are incapable of emitting pheromones!"))
		return
	if(!pheromone)
		if(current_aura)
			current_aura = null
			visible_message(SPAN_XENOWARNING("\The [src] stops emitting pheromones."), \
			SPAN_XENOWARNING("You stop emitting pheromones."), null, 5)
		else
			if(!check_plasma(emit_cost))
				to_chat(src, SPAN_XENOWARNING("You do not have enough plasma!"))
				return
			if(client.prefs && client.prefs.no_radials_preference)
				pheromone = tgui_input_list(src, "Choose a pheromone", "Pheromone Menu", caste.aura_allowed + "help" + "cancel", theme="hive_status")
				if(pheromone == "help")
					to_chat(src, SPAN_NOTICE("<br>Pheromones provide a buff to all Xenos in range at the cost of some stored plasma every second, as follows:<br><B>Frenzy</B> - Increased run speed, damage and chance to knock off headhunter masks.<br><B>Warding</B> - While in critical state, increased maximum negative health and slower off weed bleedout.<br><B>Recovery</B> - Increased plasma and health regeneration.<br>"))
					return
				if(!pheromone || pheromone == "cancel" || current_aura || !check_state(1)) //If they are stacking windows, disable all input
					return
			else
				var/static/list/phero_selections = list("Help" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_help"), "Frenzy" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_frenzy"), "Warding" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_warding"), "Recovery" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_recov"))
				pheromone = lowertext(show_radial_menu(src, src.client?.eye, phero_selections))
				if(pheromone == "help")
					to_chat(src, SPAN_XENONOTICE("<br>Pheromones provide a buff to all Xenos in range at the cost of some stored plasma every second, as follows:<br><B>Frenzy (Red)</B> - Increased run speed, damage and chance to knock off headhunter masks.<br><B>Warding (Green)</B> - While in critical state, increased maximum negative health and slower off weed bleedout.<br><B>Recovery (Blue)</B> - Increased plasma and health regeneration.<br>"))
					return
				if(!pheromone || current_aura || !check_state(1)) //If they are stacking windows, disable all input
					return
	if(pheromone)
		if(pheromone == current_aura)
			to_chat(src, SPAN_XENOWARNING("You are already emitting [pheromone] pheromones!"))
			return
		if(!check_plasma(emit_cost))
			to_chat(src, SPAN_XENOWARNING("You do not have enough plasma!"))
			return
		use_plasma(emit_cost)
		current_aura = pheromone
		visible_message(SPAN_XENOWARNING("\The [src] begins to emit strange-smelling pheromones."), \
		SPAN_XENOWARNING("You begin to emit '[pheromone]' pheromones."), null, 5)
		playsound(loc, "alien_drool", 25)

	if(isqueen(src) && faction && faction.xeno_leader_list.len && anchored)
		for(var/mob/living/carbon/xenomorph/xeno in faction.xeno_leader_list)
			xeno.handle_xeno_leader_pheromones()

/datum/action/xeno_action/activable/pounce/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check())
		return

	if(!target_atom)
		return

	if(target_atom.layer >= FLY_LAYER)//anything above that shouldn't be pounceable (hud stuff)
		return

	if(!isturf(xeno.loc))
		to_chat(xeno, SPAN_XENOWARNING("You can't [ability_name] from here!"))
		return

	if(!xeno.check_state())
		return

	if(xeno.legcuffed)
		to_chat(xeno, SPAN_XENODANGER("You can't [ability_name] with that thing on your leg!"))
		return

	if(!check_and_use_plasma_owner())
		return

	if(xeno.layer == XENO_HIDING_LAYER) //Xeno is currently hiding, unhide him
		var/datum/action/xeno_action/onclick/xenohide/hide = get_xeno_action_by_type(xeno, /datum/action/xeno_action/onclick/xenohide)
		if(hide)
			hide.post_attack()

	if(isravager(xeno))
		xeno.emote("roar")

	if(!tracks_target)
		target_atom = get_turf(target_atom)

	apply_cooldown()

	if(windup)
		xeno.set_face_dir(get_cardinal_dir(xeno, target_atom))
		if(!windup_interruptable)
			xeno.frozen = TRUE
			xeno.anchored = TRUE
			xeno.update_canmove()
		pre_windup_effects()

		if(!do_after(xeno, windup_duration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(xeno, SPAN_XENODANGER("You cancel your [ability_name]!"))
			if(!windup_interruptable)
				xeno.frozen = FALSE
				xeno.anchored = FALSE
				xeno.update_canmove()
			post_windup_effects(interrupted = TRUE)
			return

		if(!windup_interruptable)
			xeno.frozen = FALSE
			xeno.anchored = FALSE
			xeno.update_canmove()
		post_windup_effects()

	xeno.visible_message(SPAN_XENOWARNING("\The [xeno] [ability_name][findtext(ability_name, "e", -1) || findtext(ability_name, "p", -1) ? "s" : "es"] at [target_atom]!"), SPAN_XENOWARNING("You [ability_name] at [target_atom]!"))

	pre_pounce_effects()

	xeno.pounce_distance = get_dist(xeno, target_atom)

	var/datum/launch_metadata/LM = new()
	LM.target = target_atom
	LM.range = distance
	LM.speed = throw_speed
	LM.thrower = xeno
	LM.spin = FALSE
	LM.pass_flags = pounce_pass_flags
	LM.collision_callbacks = pounce_callbacks

	xeno.launch_towards(LM)

	xeno.update_icons()

	additional_effects_always()
	..()

	return TRUE

// Massive, customizable spray_acid
/datum/action/xeno_action/activable/spray_acid/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check())
		return

	if(!target_atom) return

	if(target_atom.layer >= FLY_LAYER)
		return

	if(!isturf(xeno.loc))
		to_chat(xeno, SPAN_XENOWARNING("You can't [ability_name] from here!"))
		return

	if(!xeno.check_state() || xeno.action_busy)
		return

	if(activation_delay)
		if(!do_after(xeno, activation_delay_length, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(xeno, SPAN_XENOWARNING("You decide to cancel your acid spray."))
			end_cooldown()
			return

	if(!action_cooldown_check())
		return

	apply_cooldown()

	if(!check_and_use_plasma_owner())
		return

	playsound(get_turf(xeno), 'sound/effects/refill.ogg', 25, 1)
	xeno.visible_message(SPAN_XENOWARNING("[xeno] vomits a flood of acid!"), SPAN_XENOWARNING("You vomit a flood of acid!"), null, 5)

	apply_cooldown()

	// Build our list of target turfs based on
	if(spray_type == ACID_SPRAY_LINE)
		xeno.do_acid_spray_line(getline2(xeno, target_atom, include_from_atom = FALSE), spray_effect_type, spray_distance)

	else if(spray_type == ACID_SPRAY_CONE)
		xeno.do_acid_spray_cone(get_turf(target_atom), spray_effect_type, spray_distance)

	return ..()

/datum/action/xeno_action/onclick/xenohide/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state(TRUE))
		return
	if(!action_cooldown_check())
		return
	if(xeno.action_busy)
		return
	if(xeno.layer != XENO_HIDING_LAYER)
		xeno.layer = XENO_HIDING_LAYER
		to_chat(xeno, SPAN_NOTICE("You are now hiding."))
		button.icon_state = "template_active"
	else
		xeno.layer = initial(xeno.layer)
		to_chat(xeno, SPAN_NOTICE("You have stopped hiding."))
		button.icon_state = "template"
	xeno.update_wounds()
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/place_trap/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(istype(xeno, /mob/living/carbon/xenomorph/burrower))
		var/mob/living/carbon/xenomorph/burrower/B = xeno
		if(B.burrow)
			return

	var/turf/target_turf = get_turf(xeno)
	if(!istype(target_turf))
		to_chat(xeno, SPAN_XENOWARNING("You can't do that here."))
		return
	if(SSinterior.in_interior(owner))
		to_chat(xeno, SPAN_WARNING("You sense this is not a suitable area for creating a resin hole."))
		return
	var/obj/effect/alien/weeds/alien_weeds = target_turf.check_xeno_trap_placement(xeno)
	if(!alien_weeds)
		return
	if(istype(alien_weeds, /obj/effect/alien/weeds/node))
		to_chat(xeno, SPAN_NOTICE("You start uprooting the node so you can put the resin hole in its place..."))
		if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, target_turf, INTERRUPT_ALL))
			return
		if(!target_turf.check_xeno_trap_placement(xeno))
			return
		new /obj/effect/alien/weeds(alien_weeds.loc, null, xeno)
		qdel(alien_weeds)

	if(!xeno.check_plasma(plasma_cost))
		return
	xeno.use_plasma(plasma_cost)
	playsound(xeno.loc, "alien_resin_build", 25)
	new /obj/effect/alien/resin/trap(target_turf, xeno)
	to_chat(xeno, SPAN_XENONOTICE("You place a resin hole on the weeds, it still needs a sister to fill it with acid."))
	return ..()

/turf/proc/check_xeno_trap_placement(mob/living/carbon/xenomorph/xeno)
	if(weedable < FULLY_WEEDABLE || !can_xeno_build(src))
		to_chat(xeno, SPAN_XENOWARNING("You can't do that here."))
		return FALSE

	var/obj/effect/alien/weeds/alien_weeds = locate() in src
	if(!alien_weeds)
		to_chat(xeno, SPAN_XENOWARNING("You can only shape on weeds. Find some resin before you start building!"))
		return FALSE

	if(alien_weeds.faction != xeno.faction)
		to_chat(xeno, SPAN_XENOWARNING("These weeds don't belong to your hive!"))
		return FALSE

	if(!xeno.check_alien_construction(src, check_doors = TRUE))
		return FALSE

	if(locate(/obj/effect/alien/resin/trap) in orange(1, src))
		to_chat(xeno, SPAN_XENOWARNING("This is too close to another resin hole!"))
		return FALSE

	if(locate(/obj/effect/alien/resin/fruit) in orange(1, src))
		to_chat(xeno, SPAN_XENOWARNING("This is too close to a fruit!"))
		return FALSE

	return alien_weeds

/datum/action/xeno_action/activable/place_construction/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return FALSE

	if(isstorage(target_atom.loc) || xeno.contains(target_atom) || istype(target_atom, /atom/movable/screen))
		return FALSE

	//Make sure construction is unrestricted
	if(xeno.faction && xeno.faction.construction_allowed == XENO_LEADER && xeno.hive_pos == NORMAL_XENO)
		to_chat(xeno, SPAN_WARNING("Construction is currently restricted to Leaders only!"))
		return FALSE
	else if(xeno.faction && xeno.faction.construction_allowed == XENO_QUEEN && !istype(xeno.caste, /datum/caste_datum/queen))
		to_chat(xeno, SPAN_WARNING("Construction is currently restricted to Queen only!"))
		return FALSE
	else if(xeno.faction && xeno.faction.construction_allowed == XENO_NOBODY)
		to_chat(xeno, SPAN_WARNING("The hive is too weak and fragile to have the strength to design constructions."))
		return FALSE

	var/turf/target_turf = get_turf(target_atom)

	var/area/area = get_area(target_turf)
	if(isnull(area) || !(area.is_resin_allowed))
		if(area.flags_area & AREA_UNWEEDABLE)
			to_chat(xeno, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(xeno, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return FALSE

	if(target_turf.z != xeno.z)
		to_chat(xeno, SPAN_XENOWARNING("This area is too far away to affect!"))
		return FALSE

	if(SSinterior.in_interior(xeno))
		to_chat(xeno, SPAN_XENOWARNING("It's too tight in here to build."))
		return FALSE

	if(!xeno.check_alien_construction(target_turf))
		return FALSE

	var/choice = XENO_STRUCTURE_CORE
	if(xeno.faction.hivecore_cooldown)
		to_chat(xeno, SPAN_WARNING("The weeds are still recovering from the death of the hive core, wait until the weeds have recovered!"))
		return FALSE
	if(xeno.faction.has_structure(XENO_STRUCTURE_CORE) || !xeno.faction.can_build_structure(XENO_STRUCTURE_CORE))
		choice = tgui_input_list(xeno, "Choose a structure to build", "Build structure", xeno.faction.faction_structure_types + "help", theme="hive_status")
		if(!choice)
			return
		if(choice == "help")
			var/message = "<br>Placing a construction node creates a template for special structures that can benefit the hive, which require the insertion of [MATERIAL_CRYSTAL] to construct the following:<br>"
			for(var/structure_name in xeno.faction.faction_structure_types)
				message += "[get_xeno_structure_desc(structure_name)]<br>"
			to_chat(xeno, SPAN_NOTICE(message))
			return TRUE
	if(!xeno.check_state(TRUE) || !xeno.check_plasma(400))
		return FALSE
	var/structure_type = xeno.faction.faction_structure_types[choice]
	var/datum/construction_template/xenomorph/structure_template = new structure_type()

	if(!spacecheck(xeno, target_turf, structure_template))
		return FALSE

	if(!do_after(xeno, XENO_STRUCTURE_BUILD_TIME, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return FALSE

	if(!spacecheck(xeno, target_turf, structure_template)) //doublechecking
		return FALSE

	if((choice == XENO_STRUCTURE_CORE) && isqueen(xeno) && xeno.faction.has_structure(XENO_STRUCTURE_CORE))
		if(xeno.faction.faction_location.hardcore || world.time > XENOMORPH_PRE_SETUP_CUTOFF)
			to_chat(xeno, SPAN_WARNING("You can't rebuild this structure!"))
			return
		if(alert(xeno, "Are you sure that you want to move the hive and destroy the old hive core?", , owner.client.auto_lang(LANGUAGE_YES), owner.client.auto_lang(LANGUAGE_NO)) != owner.client.auto_lang(LANGUAGE_YES))
			return
		qdel(xeno.faction.faction_location)
	else if(!xeno.faction.can_build_structure(choice))
		to_chat(xeno, SPAN_WARNING("You can't build any more [choice]s for the faction."))
		return FALSE

	if(!xeno.faction.can_build_structure(structure_template.name) && !(choice == XENO_STRUCTURE_CORE))
		to_chat(xeno, SPAN_WARNING("You cannot build any more [structure_template.name]!"))
		qdel(structure_template)
		return FALSE

	if(QDELETED(target_turf))
		to_chat(xeno, SPAN_WARNING("You cannot build here!"))
		qdel(structure_template)
		return FALSE

	var/queen_on_zlevel = !xeno.faction.living_xeno_queen || xeno.faction.living_xeno_queen.z == target_turf.z
	if(!queen_on_zlevel)
		to_chat(xeno, SPAN_WARNING("Your link to the Queen is too weak here. She is on another world."))
		qdel(structure_template)
		return FALSE

	if(SSinterior.in_interior(xeno))
		to_chat(xeno, SPAN_WARNING("It's too tight in here to build."))
		qdel(structure_template)
		return FALSE

	if(target_turf.weedable < FULLY_WEEDABLE || !can_xeno_build(target_turf))
		to_chat(xeno, SPAN_WARNING("\The [target_turf] can't support a [structure_template.name]!"))
		qdel(structure_template)
		return FALSE

	var/obj/effect/alien/weeds/weeds = locate() in target_turf
	if(weeds?.block_structures >= BLOCK_SPECIAL_STRUCTURES)
		to_chat(xeno, SPAN_WARNING("\The [weeds] block the construction of any special structures!"))
		qdel(structure_template)
		return FALSE

	xeno.use_plasma(400)
	xeno.place_construction(target_turf, structure_template)
	xeno.count_statistic_stat(STATISTIC_XENO_STRUCTURES_BUILD)

	return ..()

// XSS Spacecheck

/datum/action/xeno_action/activable/place_construction/proc/spacecheck(mob/living/carbon/xenomorph/xeno, turf/target_turf, datum/construction_template/xenomorph/template)
	if(template.block_range)
		for(var/turf/TA in range(target_turf, template.block_range))
			if(!xeno.check_alien_construction(TA, FALSE, TRUE))
				to_chat(xeno, SPAN_WARNING("You need more open space to build here."))
				qdel(template)
				return FALSE
		if(!xeno.check_alien_construction(target_turf))
			to_chat(xeno, SPAN_WARNING("You need more open space to build here."))
			qdel(template)
			return FALSE
		var/obj/effect/alien/weeds/alien_weeds = locate() in target_turf
		if(!alien_weeds || alien_weeds.weed_strength < WEED_LEVEL_HIVE || alien_weeds.faction != xeno.faction)
			to_chat(xeno, SPAN_WARNING("You can only shape on [lowertext(xeno.faction.prefix)]hive weeds. Find a hive node or core before you start building!"))
			qdel(template)
			return FALSE
		if(target_turf.density)
			qdel(template)
			to_chat(xeno, SPAN_WARNING("You need an empty space to build this."))
			return FALSE
	return TRUE

/datum/action/xeno_action/activable/xeno_spit/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/spit_target = aim_turf ? get_turf(target_atom) : target_atom
	if(!xeno.check_state())
		return

	if(spitting)
		to_chat(src, SPAN_WARNING("You are already preparing a spit!"))
		return

	if(!isturf(xeno.loc))
		to_chat(src, SPAN_WARNING("You can't spit from here!"))
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("You must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(xeno)

	if(!current_turf)
		return

	if(!check_plasma_owner())
		return

	if(xeno.ammo.spit_windup)
		spitting = TRUE
		if(xeno.ammo.pre_spit_warn)
			playsound(xeno.loc,"alien_drool", 55, 1)
		to_chat(xeno, SPAN_WARNING("You begin to prepare a large spit!"))
		xeno.visible_message(SPAN_WARNING("[xeno] prepares to spit a massive glob!"),\
		SPAN_WARNING("You begin to spit [xeno.ammo.name]!"))
		if(!do_after(xeno, xeno.ammo.spit_windup, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			to_chat(xeno, SPAN_XENODANGER("You decide to cancel your spit."))
			spitting = FALSE
			return
	plasma_cost = xeno.ammo.spit_cost

	if(!check_and_use_plasma_owner())
		spitting = FALSE
		return

	xeno_cooldown = xeno.caste.spit_delay + xeno.ammo.added_spit_delay
	xeno.visible_message(SPAN_XENOWARNING("[xeno] spits at [target_atom]!"), \

	SPAN_XENOWARNING("You spit a [xeno.ammo.name] at [target_atom]!") )
	playsound(xeno.loc, sound_to_play, 25, 1)

	var/obj/item/projectile/proj = new (current_turf, create_cause_data(xeno.ammo.name, xeno))
	proj.generate_bullet(xeno.ammo)
	proj.permutated += xeno
	proj.def_zone = xeno.get_limbzone_target()
	proj.fire_at(spit_target, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

	spitting = FALSE

	SEND_SIGNAL(xeno, COMSIG_XENO_POST_SPIT)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/bombard/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno) || !xeno.check_state() || !action_cooldown_check() || xeno.action_busy)
		return FALSE

	var/turf/target_turf = get_turf(target_atom)

	if(isnull(target_turf) || istype(target_turf, /turf/closed) || !target_turf.can_bombard(owner))
		to_chat(xeno, SPAN_XENODANGER("You can't bombard that!"))
		return FALSE

	if(!check_plasma_owner())
		return FALSE

	if(target_turf.z != xeno.z)
		to_chat(xeno, SPAN_WARNING("That target is too far away!"))
		return FALSE

	var/atom/bombard_source = get_bombard_source()
	if(!xeno.can_bombard_turf(target_turf, range, bombard_source))
		return FALSE

	xeno.visible_message(SPAN_XENODANGER("[xeno] digs itself into place!"), SPAN_XENODANGER("You dig yourself into place!"))
	if(!do_after(xeno, activation_delay, interrupt_flags, BUSY_ICON_HOSTILE))
		to_chat(xeno, SPAN_XENODANGER("You decide to cancel your bombard."))
		return FALSE

	if(!xeno.can_bombard_turf(target_turf, range, bombard_source)) //Second check in case something changed during the do_after.
		return FALSE

	if(!check_and_use_plasma_owner())
		return FALSE

	apply_cooldown()

	xeno.visible_message(SPAN_XENODANGER("[xeno] launches a massive ball of acid at [target_atom]!"), SPAN_XENODANGER("You launch a massive ball of acid at [target_atom]!"))
	playsound(get_turf(xeno), 'sound/effects/blobattack.ogg', 25, 1)

	recursive_spread(target_turf, effect_range, effect_range)

	return ..()

/datum/action/xeno_action/activable/bombard/proc/recursive_spread(turf/target_turf, dist_left, orig_depth)
	if(!istype(target_turf))
		return
	else if(dist_left == 0)
		return
	else if(istype(target_turf, /turf/closed) || istype(target_turf, /turf/open/space))
		return
	else if(!target_turf.can_bombard(owner))
		return

	addtimer(CALLBACK(src, PROC_REF(new_effect), target_turf, owner), 2*(orig_depth - dist_left))

	for(var/mob/living/L in target_turf)
		to_chat(L, SPAN_XENOHIGHDANGER("You see a massive ball of acid flying towards you!"))

	for(var/dirn in GLOB.alldirs)
		recursive_spread(get_step(target_turf, dirn), dist_left - 1, orig_depth)


/datum/action/xeno_action/activable/bombard/proc/new_effect(turf/target_turf, mob/living/carbon/xenomorph/xenomorph)
	if(!istype(target_turf))
		return

	for(var/obj/effect/xenomorph/boiler_bombard/boiler_bombard in target_turf)
		return

	new effect_type(target_turf, xenomorph)

/datum/action/xeno_action/activable/bombard/proc/get_bombard_source()
	return owner

/turf/proc/can_bombard(mob/bombarder)
	if(!can_be_dissolved() && density) return FALSE
	for(var/atom/target_atom in src)
		if(istype(target_atom, /obj/structure/machinery))
			continue
		if(ismob(target_atom)) continue // Mobs shouldn't block boiler gas

		if(target_atom && target_atom.unacidable && target_atom.density && !(target_atom.flags_atom & ON_BORDER))
			return FALSE

	return TRUE

/mob/living/carbon/xenomorph/proc/can_bombard_turf(atom/target_atom, range = 5, atom/bombard_source) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	if(!bombard_source || !isturf(bombard_source.loc))
		to_chat(src, SPAN_XENODANGER("That target is obstructed!"))
		return FALSE
	var/turf/current = bombard_source.loc
	var/turf/target_turf = get_turf(target_atom)

	if(get_dist_sqrd(current, target_turf) > (range*range))
		to_chat(src, SPAN_XENODANGER("That is too far away!"))
		return

	. = TRUE
	while(current != target_turf)
		if(!current)
			. = FALSE
		if(!current.can_bombard(src))
			. = FALSE
		if(current.opacity)
			. = FALSE
		if(.)
			for(var/atom/atom in current)
				if(atom.opacity)
					. = FALSE
					break
		if(!.)
			to_chat(src, SPAN_XENODANGER("That target is obstructed!"))
			return

		current = get_step_towards(current, target_turf)

/datum/action/xeno_action/activable/tail_stab/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner

	if(stabbing_xeno.burrow || stabbing_xeno.is_ventcrawling)
		to_chat(stabbing_xeno, SPAN_XENOWARNING("You must be above ground to do this."))
		return

	if(!stabbing_xeno.check_state())
		return FALSE

	var/pre_result = pre_ability_act(stabbing_xeno, targetted_atom)

	if(pre_result)
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	if (world.time <= stabbing_xeno.next_move)
		return FALSE

	var/distance = get_dist(stabbing_xeno, targetted_atom)
	if(distance > 2)
		return FALSE

	var/list/turf/path = getline2(stabbing_xeno, targetted_atom, include_from_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking your strike!"))
			return FALSE
		for(var/obj/path_contents in path_turf.contents)
			if(path_contents != targetted_atom && path_contents.density && !path_contents.throwpass)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking your strike!"))
				return FALSE

		var/atom/barrier = path_turf.handle_barriers(stabbing_xeno, null, (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			var/tail_stab_cooldown_multiplier = barrier.handle_tail_stab(stabbing_xeno)
			if(!tail_stab_cooldown_multiplier)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking your strike!"))
			else
				apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
				xeno_attack_delay(stabbing_xeno)
			return FALSE

	var/tail_stab_cooldown_multiplier = targetted_atom.handle_tail_stab(stabbing_xeno)
	if(tail_stab_cooldown_multiplier)
		stabbing_xeno.animation_attack_on(targetted_atom)
		apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
		xeno_attack_delay(stabbing_xeno)
		return ..()

	if(!isxeno_human(targetted_atom))
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] swipes their tail through the air!"), SPAN_XENOWARNING("You swipe your tail through the air!"))
		apply_cooldown(cooldown_modifier = 0.1)
		xeno_attack_delay(stabbing_xeno)
		playsound(stabbing_xeno, "alien_tail_swipe", 50, TRUE)
		return FALSE

	if(stabbing_xeno.can_not_harm(targetted_atom))
		return FALSE

	var/mob/living/carbon/target = targetted_atom

	if(target.stat == DEAD || HAS_TRAIT(target, TRAIT_NESTED))
		return FALSE

	var/obj/limb/limb = target.get_limb(check_zone(stabbing_xeno.zone_selected))
	if (ishuman(target) && (!limb || (limb.status & LIMB_DESTROYED)))
		to_chat(stabbing_xeno, (SPAN_WARNING("What [limb.display_name]?")))
		return FALSE

	if(!check_and_use_plasma_owner())
		return FALSE

	var/result = ability_act(stabbing_xeno, target, limb)

	apply_cooldown()
	xeno_attack_delay(stabbing_xeno)
	..()
	return result

/datum/action/xeno_action/activable/tail_stab/proc/pre_ability_act(mob/living/carbon/xenomorph/stabbing_xeno, atom/targetted_atom)
	return

/datum/action/xeno_action/activable/tail_stab/proc/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/target, obj/limb/limb)

	target.last_damage_data = create_cause_data(initial(stabbing_xeno.caste_type), stabbing_xeno)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = stabbing_xeno.dir
	/// Direction var to make the tail stab look cool and immersive.
	var/stab_direction

	var/stab_overlay

	if(blunt_stab)
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] swipes its tail into [target]'s [limb ? limb.display_name : "chest"], bashing it!"), SPAN_XENOWARNING("You swipe your tail into [target]'s [limb? limb.display_name : "chest"], bashing it!"))
		if(prob(1))
			playsound(target, 'sound/effects/comical_bonk.ogg', 50, TRUE)
		else
			playsound(target, "punch", 50, TRUE)
		// The xeno smashes the target with their tail, moving it to the side and thus their direction as well.
		stab_direction = turn(stabbing_xeno.dir, pick(90, -90))
		stab_overlay = "slam"
	else
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] skewers [target] through the [limb ? limb.display_name : "chest"] with its razor sharp tail!"), SPAN_XENOWARNING("You skewer [target] through the [limb? limb.display_name : "chest"] with your razor sharp tail!"))
		playsound(target, "alien_bite", 50, TRUE)
		// The xeno flips around for a second to impale the target with their tail. These look awsome.
		stab_direction = turn(get_dir(stabbing_xeno, target), 180)
		stab_overlay = "tail"

	stabbing_xeno.setDir(stab_direction)
	stabbing_xeno.emote("tail")

	/// Ditto.
	var/new_dir = stabbing_xeno.dir

	addtimer(CALLBACK(src, PROC_REF(reset_direction), stabbing_xeno, last_dir, new_dir), 0.5 SECONDS)

	stabbing_xeno.animation_attack_on(target)
	stabbing_xeno.flick_attack_overlay(target, stab_overlay)

	var/damage = (stabbing_xeno.melee_damage_upper + stabbing_xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER) * TAILSTAB_MOB_DAMAGE_MULTIPLIER

	if(stabbing_xeno.behavior_delegate)
		stabbing_xeno.behavior_delegate.melee_attack_additional_effects_target(target)
		stabbing_xeno.behavior_delegate.melee_attack_additional_effects_self()
		damage = stabbing_xeno.behavior_delegate.melee_attack_modify_damage(damage, target)

	target.apply_armoured_damage(get_xeno_damage_slash(target, damage), ARMOR_MELEE, BRUTE, limb ? limb.name : "chest")
	target.apply_effect(3, DAZE)
	shake_camera(target, 2, 1)

	target.handle_blood_splatter(get_dir(owner.loc, target.loc))
	return target

/datum/action/xeno_action/activable/tail_stab/proc/reset_direction(mob/living/carbon/xenomorph/stabbing_xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == stabbing_xeno.dir)
		stabbing_xeno.setDir(last_dir)
