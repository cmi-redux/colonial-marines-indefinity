var/bomb_set = FALSE

/obj/structure/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Nuke the entire site from orbit, it's the only way to be sure. Too bad we don't have any orbital nukes."
	icon = 'icons/obj/structures/machinery/nuclearbomb.dmi'
	icon_state = "nuke"
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE
	anchored = FALSE
	var/crash_nuke = FALSE
	var/timing = FALSE
	var/deployable = FALSE
	var/explosion_time = null
	var/timeleft = 4800
	var/safety = TRUE
	var/being_used = FALSE
	var/end_round = TRUE
	var/timer_announcements_flags = NUKE_SHOW_TIMER_ALL
	var/has_auth
	var/obj/item/disk/nuclear/red/r_auth
	var/obj/item/disk/nuclear/green/g_auth
	var/obj/item/disk/nuclear/blue/b_auth
	pixel_x = -16
	use_power = USE_POWER_NONE
	req_access = list()
	flags_atom = FPRINT
	faction_to_get = FACTION_MARINE
	var/command_lockout = FALSE //If set to TRUE, only command staff would be able to disable the nuke

/obj/structure/machinery/nuclearbomb/Initialize()
	. = ..()

	SSmapview.add_marker(src, "nuke", recoloring = FALSE)

/obj/structure/machinery/nuclearbomb/update_icon()
	overlays.Cut()
	if(anchored)
		var/image/I = image(icon, "+deployed")
		overlays += I
	if(!safety)
		var/image/I = image(icon, "+unsafe")
		overlays += I
	if(timing)
		var/image/I = image(icon, "+timing")
		overlays += I
	if(timing == -1)
		var/image/I = image(icon, "+activation")
		overlays += I

/obj/structure/machinery/nuclearbomb/power_change()
	return

/obj/structure/machinery/nuclearbomb/process()
	. = ..()
	GLOB.active_nuke_list += src
	if(timing)
		bomb_set = TRUE //So long as there is one nuke timing, it means one nuke is armed.
		timeleft = explosion_time - world.time
		if(world.time >= explosion_time)
			explode()
		//3 warnings: 1. Halfway through, 2. 1 minute left, 3. 10 seconds left.
		//this structure allows varedits to var/timeleft without losing or spamming warnings.
		else if(timer_announcements_flags)
			if(timer_announcements_flags & NUKE_SHOW_TIMER_HALF)
				if(timeleft <= initial(timeleft) / 2 && timeleft >= initial(timeleft) / 2 - 30)
					announce_to_players(NUKE_SHOW_TIMER_HALF)
					timer_announcements_flags &= ~NUKE_SHOW_TIMER_HALF
					return
			if(timer_announcements_flags & NUKE_SHOW_TIMER_MINUTE)
				if(timeleft <= 600 && timeleft >= 570)
					announce_to_players(NUKE_SHOW_TIMER_MINUTE)
					timer_announcements_flags = NUKE_SHOW_TIMER_TEN_SEC
					return
			if(timer_announcements_flags & NUKE_SHOW_TIMER_TEN_SEC)
				if(timeleft <= 100 && timeleft >= 70)
					announce_to_players(NUKE_SHOW_TIMER_TEN_SEC)
					timer_announcements_flags = 0
					return
	else
		stop_processing()

/obj/structure/machinery/nuclearbomb/attack_alien(mob/living/carbon/xenomorph/M)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, attack_hand), M)
	return XENO_ATTACK_ACTION

/obj/structure/machinery/nuclearbomb/attackby(obj/item/O as obj, mob/user as mob)
	if(anchored && timing && bomb_set && HAS_TRAIT(O, TRAIT_TOOL_WIRECUTTERS))
		user.visible_message(SPAN_DANGER("[user] begins to defuse \the [src]."), SPAN_DANGER("You begin to defuse \the [src]. This will take some time..."))
		if(do_after(user, 150 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			disable()
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return
	..()

/obj/structure/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if(user.is_mob_incapacitated() || !user.can_action || get_dist(src, user) > 1 || isRemoteControlling(user))
		return

	if(isyautja(user))
		to_chat(usr, SPAN_YAUTJABOLD("A human Purification Device. Primitive and bulky, but effective. You don't have time to try figure out their counterintuitive controls. Better leave the hunting grounds before it detonates."))

	if(deployable)
		if(!ishuman(user) && (!isqueen(user) && (!isxeno(user) && !crash_nuke)))
			to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
			return

		if(isxeno(user))
			if(timing && bomb_set)
				user.visible_message(SPAN_DANGER("[user] begins to defuse \the [src]."), SPAN_DANGER("You begin to defuse \the [src]. This will take some time..."))
				if(do_after(user, 15 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
					SSticker.mode.on_nuclear_diffuse(src, user)
					disable()
			return
		tgui_interact(user)

	else
		make_deployable()


// TGUI \\

/obj/structure/machinery/nuclearbomb/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NuclearBomb", "[src.name]")
		ui.open()

/obj/structure/machinery/nuclearbomb/ui_state(mob/user)
	if(being_used)
		return UI_CLOSE
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/nuclearbomb/ui_status(mob/user)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/nuclearbomb/ui_data(mob/user)
	var/list/data = list()

	var/allowed = allowed(user)

	data["anchor"] = anchored
	data["safety"] = safety
	data["timing"] = timing
	data["timeleft"] = duration2text_sec(timeleft)
	data["command_lockout"] = command_lockout
	data["allowed"] = allowed
	data["being_used"] = being_used

	return data

/obj/structure/machinery/nuclearbomb/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/area/A = get_area(src)
	switch(action)
		if("toggleNuke")
			if(timing == -1)
				return

			if(!ishuman(usr))
				return

			if(!allowed(usr) || (crash_nuke && !has_auth))
				to_chat(usr, SPAN_DANGER("Access denied!"))
				return

			if(!anchored)
				to_chat(usr, SPAN_DANGER("Engage anchors first!"))
				return

			if(safety)
				to_chat(usr, SPAN_DANGER("The safety is still on."))
				return

			if(!A.can_build_special)
				to_chat(usr, SPAN_DANGER("You cannot deploy [src] here!"))
				return

			if(usr.action_busy)
				return

			usr.visible_message(SPAN_WARNING("[usr] begins to [timing ? "disengage" : "engage"] [src]!"), SPAN_WARNING("You begin to [timing ? "disengage" : "engage"] [src]."))
			being_used = TRUE
			ui = SStgui.try_update_ui(usr, src, ui)
			if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				timing = !timing
				if(timing)
					if(!safety)
						bomb_set = TRUE
						explosion_time = world.time + timeleft
						start_processing()
						announce_to_players()
						message_admins("\The [src] has been activated by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
					else
						bomb_set = FALSE
				else
					disable()
					message_admins("\The [src] has been deactivated by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
				playsound(src.loc, 'sound/effects/thud.ogg', 100, 1)
			being_used = FALSE
			. = TRUE

		if("toggleSafety")
			if(!allowed(usr) || (crash_nuke && !has_auth))
				to_chat(usr, SPAN_DANGER("Access denied!"))
				return
			if(timing)
				to_chat(usr, SPAN_DANGER("Disengage first!"))
				return
			if(!A.can_build_special)
				to_chat(usr, SPAN_DANGER("You cannot deploy [src] here!"))
				return
			if(usr.action_busy)
				return
			usr.visible_message(SPAN_WARNING("[usr] begins to [safety ? "disable" : "enable"] the safety on [src]!"), SPAN_WARNING("You begin to [safety ? "disable" : "enable"] the safety on [src]."))
			being_used = TRUE
			ui = SStgui.try_update_ui(usr, src, ui)
			if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				safety = !safety
				playsound(src.loc, 'sound/items/poster_being_created.ogg', 100, 1)
			being_used = FALSE
			if(safety)
				timing = FALSE
				bomb_set = FALSE
			. = TRUE

		if("toggleCommandLockout")
			if(!ishuman(usr))
				return
			if(!allowed(usr) || (crash_nuke && !has_auth))
				to_chat(usr, SPAN_DANGER("Access denied!"))
				return
			if(command_lockout)
				command_lockout = FALSE
				req_one_access = list()
				to_chat(usr, SPAN_DANGER("Command lockout disengaged."))
			else
				//Check if they have command access
				var/list/acc = list()
				var/mob/living/carbon/human/H = usr
				if(H.wear_id)
					acc += H.wear_id.GetAccess()
				if(H.get_active_hand())
					acc += H.get_active_hand().GetAccess()
				if(!(ACCESS_MARINE_COMMAND in acc))
					to_chat(usr, SPAN_DANGER("Access denied!"))
					return

				command_lockout = TRUE
				req_one_access = list(ACCESS_MARINE_COMMAND)
				to_chat(usr, SPAN_DANGER("Command lockout engaged."))
			. = TRUE

		if("toggleAnchor")
			if(timing || (crash_nuke && !has_auth))
				to_chat(usr, SPAN_DANGER("Disengage first!"))
				return
			if(!A.can_build_special)
				to_chat(usr, SPAN_DANGER("You cannot deploy [src] here!"))
				return
			if(usr.action_busy)
				return
			being_used = TRUE
			ui = SStgui.try_update_ui(usr, src, ui)
			if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				if(!anchored)
					visible_message(SPAN_DANGER("With a steely snap, bolts slide out of [src] and anchor it to the flooring."))
				else
					visible_message(SPAN_DANGER("The anchoring bolts slide back into the depths of [src]."))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
				anchored = !anchored
			being_used = FALSE
			. = TRUE

	update_icon()
	add_fingerprint(usr)

/obj/structure/machinery/nuclearbomb/verb/make_deployable()
	set category = "Object"
	set name = "Make Deployable"
	set src in oview(1)

	if(!usr.can_action || usr.is_mob_restrained() || being_used || timing || (crash_nuke && !has_auth))
		return

	if(!ishuman(usr))
		to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
		return

	var/area/A = get_area(src)
	if(!A.can_build_special)
		to_chat(usr, SPAN_DANGER("You don't want to deploy this here!"))
		return

	usr.visible_message(SPAN_WARNING("[usr] begins to [deployable ? "close" : "adjust"] several panels to make [src] [deployable ? "undeployable" : "deployable"]."), SPAN_WARNING("You begin to [deployable ? "close" : "adjust"] several panels to make [src] [deployable ? "undeployable" : "deployable"]."))
	being_used = TRUE
	if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		if(deployable)
			deployable = FALSE
			anchored = FALSE
		else
			deployable = TRUE
			anchored = TRUE
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
	being_used = FALSE
	update_icon()

//unified all announcements to one proc
/obj/structure/machinery/nuclearbomb/proc/announce_to_players(timer_warning)
	if(timer_warning) //we check for timer warnings first
		//humans part
		var/list/humans_other = GLOB.human_mob_list + GLOB.dead_mob_list
		var/list/humans_USCM = list()
		for(var/mob/M in humans_other)
			var/mob/living/carbon/human/H = M
			if(istype(H)) //if it's unconsious human or yautja, we remove them
				if(H.stat != CONSCIOUS || isyautja(H))
					humans_other.Remove(M)
					continue
			if(M.faction == GLOB.faction_datum[FACTION_MARINE])			//separating marines from other factions. Survs go here too
				humans_USCM += M
				humans_other -= M
		announcement_helper("WARNING.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_USCM, 'sound/misc/notice1.ogg')
		announcement_helper("WARNING.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
		//preds part
		var/t_left = duration2text_sec(round(rand(timeleft - timeleft / 10, timeleft + timeleft / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!\n\nYou have approximately [t_left] seconds to abandon the hunting grounds before activation of human Purification Device."))
		//xenos part
		var/warning
		if(timer_warning & NUKE_SHOW_TIMER_HALF)
			warning = "Hive killer is halfway through preparation cycle!"
		else if(timer_warning & NUKE_SHOW_TIMER_MINUTE)
			warning = "Hive killer is almost ready to trigger!"
		else
			warning = "DISABLE IT! NOW!"
		for(var/faction_to_get in FACTION_LIST_XENOMORPH)
			var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
			if(!length(faction.totalMobs))
				continue
			xeno_announcement(SPAN_XENOANNOUNCE(warning), faction, XENO_GENERAL_ANNOUNCE)
		return

	//deal with start/stop announcements for players
	var/list/humans_other = GLOB.human_mob_list + GLOB.dead_mob_list
	var/list/humans_USCM = list()
	for(var/mob/M in humans_other)
		var/mob/living/carbon/human/H = M
		if(istype(H)) //if it's unconsious human or yautja, we remove them
			if(H.stat != CONSCIOUS || isyautja(H))
				humans_other.Remove(M)
				continue
		if(H.ally(faction))			//separating marines from other factions. Survs go here too
			humans_USCM += M
			humans_other -= M
	if(timing)
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE ACTIVATED.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_USCM, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE ACTIVATED.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "HQ Nuclear Tracker", humans_other, 'sound/misc/notice1.ogg')
		var/t_left = duration2text_sec(round(rand(timeleft - timeleft / 10, timeleft + timeleft / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>A human Purification Device has been detected. You have approximately [t_left] to abandon the hunting grounds before it activates."))
		for(var/faction_to_get in FACTION_LIST_XENOMORPH)
			var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
			if(!length(faction.totalMobs))
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts have deployed a hive killer at [get_area_name(loc)]! Stop it at all costs!"), faction, XENO_GENERAL_ANNOUNCE)
	else
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DEACTIVATED.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_USCM, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DEACTIVATED.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>The human Purification Device's signature has disappeared."))
		for(var/faction_to_get in FACTION_LIST_XENOMORPH)
			var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
			if(!length(faction.totalMobs))
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("The hive killer has been disabled! Rejoice!"), faction, XENO_GENERAL_ANNOUNCE)
	return

/obj/structure/machinery/nuclearbomb/ex_act(severity)
	return

/obj/structure/machinery/nuclearbomb/proc/disable()
	timing = FALSE
	bomb_set = FALSE
	timeleft = initial(timeleft)
	explosion_time = null
	GLOB.active_nuke_list -= src
	announce_to_players()

/obj/structure/machinery/nuclearbomb/proc/explode()
	if(safety)
		timing = FALSE
		stop_processing()
		update_icon()
		return FALSE
	timing = -1
	update_icon()
	safety = TRUE

	SSticker.mode.on_nuclear_explosion()

	sleep(100)
	cell_explosion(loc, 4000, 1, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name)))
	qdel(src)
	return TRUE

/obj/structure/machinery/nuclearbomb/Destroy()
	if(timing != -1)
		message_admins("\The [src] has been unexpectedly deleted at ([x],[y],[x]). [ADMIN_JMP(src)]")
		log_game("\The [src] has been unexpectedly deleted at ([x],[y],[x]).")
	bomb_set = FALSE
	..()


/obj/structure/machinery/nuclearbomb/crash
	name = "\improper Nuclear Fission Explosive"
	desc = "This is nuclear bomb, need three disks to activate."
	crash_nuke = TRUE

/obj/structure/machinery/nuclearbomb/crash/Initialize(mapload, ...)
	GLOB.nuke_list += src
	. = ..()

/obj/structure/machinery/nuclearbomb/crash/attackby(obj/item/O as obj, mob/user as mob)
	if(!istype(O, /obj/item/disk/nuclear))
		return
	if(!user.drop_inv_item_to_loc(O, src))
		return
	switch(O.type)
		if(/obj/item/disk/nuclear/red)
			r_auth = O
		if(/obj/item/disk/nuclear/green)
			g_auth = O
		if(/obj/item/disk/nuclear/blue)
			b_auth = O
	if(r_auth && g_auth && b_auth)
		has_auth = TRUE
	..()

/obj/structure/machinery/nuclearbomb/crash/Destroy()
	GLOB.nuke_list -= src
	SSmapview.remove_marker(src)
	..()
