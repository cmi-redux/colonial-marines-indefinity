/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	reset_view()

	if(next_move > world.time)
		return

	if(is_mob_incapacitated(TRUE))
		to_chat(src, SPAN_WARNING("You can't resist in your current state."))
		return

	resisting = TRUE

	next_move = world.time + 20

	//Getting out of someone's inventory.
	if(istype(loc, /obj/item/holder))
		var/obj/item/holder/holder = loc //Get our item holder.
		var/mob/mob = holder.loc //Get our mob holder (if any).

		if(istype(mob))
			mob.drop_inv_item_on_ground(holder)
			to_chat(mob, "[holder] wriggles out of your grip!")
			to_chat(src, "You wriggle out of [mob]'s grip!")
		else if(istype(holder.loc, /obj/item))
			to_chat(src, "You struggle free of [holder.loc].")
			holder.forceMove(get_turf(holder))

		if(!istype(mob))
			return

		for(var/obj/item/holder/hold in mob.contents)
			return

		mob.status_flags &= ~PASSEMOTES
		return

	//resisting grabs (as if it helps anyone...)
	if(!is_mob_restrained(0) && pulledby)
		visible_message(SPAN_DANGER("[src] resists against [pulledby]'s grip!"))
		resist_grab()
		return

	//unbuckling yourself
	if(buckled && (last_special <= world.time) )
		resist_buckle()

	//escaping a bodybag or a thermal tarp
	if(loc && (istype(loc, /obj/structure/closet/bodybag)))
		var/obj/structure/closet/bodybag/bodybag = loc
		if(bodybag.opened)
			return
		visible_message("[bodybag] begins to wiggle violently!")
		if(do_after(src, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, bodybag))//5 second unzip from inside
			bodybag.open()

		///The medical machines below are listed separately to allow easier changes to each process

	//getting out of hypersleep
	if(loc && (istype(loc, /obj/structure/machinery/cryopod)))
		var/obj/structure/machinery/cryopod/cryopod = loc
		cryopod.eject()

	//getting out of bodyscanner
	if(loc && (istype(loc, /obj/structure/machinery/medical_pod/bodyscanner)))
		var/obj/structure/machinery/medical_pod/bodyscanner/bodyscaner = loc
		bodyscaner.go_out() //This doesn't need flashiness as you can just WASD to walk out anyways

	//getting out of autodoc, resist does the emergency eject
	//regular ejection is done with verbs and doesnt work for half the time
	if(loc && (istype(loc, /obj/structure/machinery/medical_pod/autodoc)))
		var/obj/structure/machinery/medical_pod/autodoc/autodoc = loc
		if(alert(usr, "Would you like to emergency eject out of [autodoc]? A surgery may be in progress.", "Confirm", client.auto_lang(LANGUAGE_YES), client.auto_lang(LANGUAGE_NO)) == client.auto_lang(LANGUAGE_YES))
			visible_message(SPAN_WARNING ("[autodoc]'s emergency lights blare as the casket starts moving!"))
			to_chat(usr, SPAN_NOTICE ("You are now leaving [autodoc]"))
			playsound(src, 'sound/machines/beepalert.ogg', 30)
			if(do_after(src, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, autodoc))//5 sec delay
				autodoc.go_out() //Eject doesnt work you have to force it
		else
			return

	//getting out of cryocells
	if(loc && (istype(loc, /obj/structure/machinery/cryo_cell)))
		var/obj/structure/machinery/cryo_cell/cryo_cell = loc
		cryo_cell.move_eject() //Ejection process listed under the machine, no need to list again

	//getting out of sleeper
	if(loc && (istype(loc, /obj/structure/machinery/medical_pod/sleeper)))
		var/obj/structure/machinery/medical_pod/sleeper/sleeper = loc
		sleeper.go_out() //This doesn't need flashiness as the verb is instant as well

	//Breaking out of a locker?
	else if(loc && (istype(loc, /obj/structure/closet)))
		var/breakout_time = 2 //2 minutes by default

		var/obj/structure/closet/closet = loc
		if(closet.opened)
			return //Door's open... wait, why are you in it's contents then?
		if(istype(loc, /obj/structure/closet/secure_closet))
			var/obj/structure/closet/secure_closet/secure_closet = loc
			if(!secure_closet.locked && !secure_closet.welded)
				return //It's a secure closet, but isn't locked. Easily escapable from, no need to 'resist'
		else if(!closet.welded)
			return //closed but not welded...

		//okay, so the closet is either welded or locked... resist!!!
		next_move = world.time + 100
		last_special = world.time + 100
		to_chat(src, SPAN_DANGER("You lean on the back of \the [closet] and start pushing the door open. (this will take about [breakout_time] minutes)"))
		for(var/mob/observed in viewers(loc))
			observed.show_message(SPAN_DANGER("<B>The [loc] begins to shake violently!</B>"), 1)

		if(!do_after(src, (breakout_time*1 MINUTES), INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST))
			return

		if(!closet || !src || stat != CONSCIOUS || loc != closet || closet.opened) //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened
			return
		//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
		if(istype(loc, /obj/structure/closet/secure_closet))
			var/obj/structure/closet/secure_closet/secure_closet = loc
			if(!secure_closet.locked && !secure_closet.welded)
				return
		else if(!closet.welded)
			return
		//Well then break it!
		if(istype(loc, /obj/structure/closet/secure_closet))
			var/obj/structure/closet/secure_closet/secure_closet = loc
			secure_closet.desc = "It appears to be broken."
			secure_closet.icon_state = secure_closet.icon_off
			flick(secure_closet.icon_broken, secure_closet)
			sleep(10)
			flick(secure_closet.icon_broken, secure_closet)
			sleep(10)
			secure_closet.broken = 1
			secure_closet.locked = 0
			secure_closet.update_icon()
			to_chat(src, SPAN_DANGER("You successfully break out!"))
			for(var/mob/observed in viewers(loc))
				observed.show_message(SPAN_DANGER("<B>\the [src] successfully broke out of \the [secure_closet]!</B>"), 1)
			if(istype(secure_closet.loc, /obj/structure/bigDelivery)) //Do this to prevent contents from being opened into nullspace (read: bluespace)
				var/obj/structure/bigDelivery/bigDelivery = secure_closet.loc
				bigDelivery.attack_hand(src)
			secure_closet.open()
			return
		else
			closet.welded = 0
			closet.update_icon()
			to_chat(src, SPAN_DANGER("You successfully break out!"))
			for(var/mob/O in viewers(loc))
				O.show_message(SPAN_DANGER("<B>\the [src] successfully broke out of \the [closet]!</B>"), SHOW_MESSAGE_VISIBLE)
			if(istype(closet.loc, /obj/structure/bigDelivery)) //nullspace ect... read the comment above
				var/obj/structure/bigDelivery/BD = closet.loc
				BD.attack_hand(src)
			closet.open()
			return

	//breaking out of handcuffs & putting out fires
	if(canmove && !knocked_down)
		if(on_fire)
			resist_fire()

		var/on_acid = FALSE
		for(var/datum/effects/acid/A in effects_list)
			on_acid = TRUE
			break
		if(on_acid)
			resist_acid()

	SEND_SIGNAL(src, COMSIG_MOB_RESISTED)

	if(!iscarbon(src))
		return
	var/mob/living/carbon/closet = src
	if((closet.handcuffed || closet.legcuffed) && closet.canmove && (closet.last_special <= world.time))
		resist_restraints()

/mob/living/proc/resist_buckle()
	buckled.manual_unbuckle(src)

/mob/living/proc/resist_fire()
	return

/mob/living/proc/resist_acid()
	return

/mob/living/proc/resist_restraints()
	return
