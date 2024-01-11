//---------------------------MAGAZINE BOXES------------------

/obj/item/ammo_box
	name = "generic ammo box"
	icon = 'icons/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	icon_state = "base"
	w_class = SIZE_HUGE
	var/empty = FALSE
	var/limit_per_tile = 1	//how many you can deploy per tile
	layer = LOWER_ITEM_LAYER	//to not hide other items

	var/cause_data = "взрыва ящика боеприпасов"
	var/shrapnel_type = /datum/ammo/bullet/shrapnel/medium
	var/burning = FALSE
	var/can_explode = FALSE

	var/text_markings_icon = 'icons/obj/items/weapons/guns/ammo_boxes/text.dmi'
	var/handfuls_icon = 'icons/obj/items/weapons/guns/ammo_boxes/handfuls.dmi'
	var/magazines_icon = 'icons/obj/items/weapons/guns/ammo_boxes/magazines.dmi'
	var/flames_icon = 'icons/obj/items/weapons/guns/ammo_boxes/misc.dmi'

//---------------------GENERAL PROCS

/obj/item/ammo_box/attack_self(mob/living/user)
	..()
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return

	if(user.a_intent == INTENT_HARM)
		unfold_box(user)
		return
	deploy_ammo_box(user, user.loc)

/obj/item/ammo_box/proc/unfold_box(mob/user)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return
	if(is_loaded())
		to_chat(user, SPAN_WARNING("You need to empty the box before unfolding it!"))
		return
	new /obj/item/stack/sheet/cardboard(user.loc)
	qdel(src)

/obj/item/ammo_box/proc/is_loaded()
	return FALSE

/obj/item/ammo_box/proc/deploy_ammo_box(mob/user, turf/T)
	user.drop_held_item()

//---------------------FIRE HANDLING PROCS
/obj/item/ammo_box/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/tool/weldingtool))
		if(!burning_check())
			return
		burning = TRUE
		process_burning()

/obj/item/ammo_box/bullet_act(obj/item/projectile/proj)
	..()
	if(!burning_check())
		return
	var/ammo_flags = proj.ammo.traits_to_give | proj.projectile_override_flags
	if(ammo_flags && ammo_flags & (/datum/element/bullet_trait_incendiary) || proj.ammo.flags_ammo_behavior & AMMO_XENO)
		burning = TRUE
		addtimer(CALLBACK(src, PROC_REF(process_burning), proj.weapon_cause_data), 1)
	else if(rand(0,300) < 20)
		burning = TRUE
		addtimer(CALLBACK(src, PROC_REF(process_burning), proj.weapon_cause_data), 1)

/obj/item/ammo_box/ex_act(severity, explosion_direction, datum/cause_data/explosion_cause_data)
	if(!burning_check())
		return
	switch(severity)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			burning = TRUE
			addtimer(CALLBACK(src, PROC_REF(process_burning), explosion_cause_data), 1)

/obj/item/ammo_box/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	if(!burning_check())
		return
	burning = TRUE
	addtimer(CALLBACK(src, PROC_REF(process_burning), flame_cause_data), 1)

/obj/item/ammo_box/proc/burning_check()
	if(!burning)
		return TRUE
	return FALSE

/obj/item/ammo_box/proc/apply_fire_overlay()
	return

/obj/item/ammo_box/proc/process_burning()
	return

/obj/item/ammo_box/proc/handle_side_effects()
	return

/obj/item/ammo_box/proc/explode(datum/cause_data/cause_data)
	playsound(src, 'sound/effects/explosion_psss.ogg', 2, 1)
	var/shrapnel_count
	for(var/obj/item/ammo_magazine/a in contents)
		shrapnel_count += a.ammo_position/6
	if(shrapnel_count)
		create_shrapnel(src, shrapnel_count, , ,shrapnel_type, cause_data)
		cell_explosion(src, 200, 200, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
	else
		create_shrapnel(src, 8, , ,shrapnel_type, cause_data)
		cell_explosion(src, 25, 200, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
	if(!QDELETED(src))
		qdel(src)

/obj/item/ammo_box/magazine
	name = "magazine box (M41A x 10)"
	icon_state = "base_m41" //base color of box
	var/overlay_ammo_type = "_reg" //used for ammo type color overlay
	var/overlay_gun_type = "_m41" //used for text overlay
	var/overlay_content = "_reg"
	var/magazine_type = /obj/item/ammo_magazine/rifle
	var/num_of_magazines = 10
	var/handfuls = FALSE
	var/icon_state_deployed = null
	var/handful = "shells" //used for 'magazine' boxes that give handfuls to determine what kind for the sprite
	can_explode = TRUE
	limit_per_tile = 2

/obj/item/ammo_box/magazine/empty
	empty = TRUE

//---------------------GENERAL PROCS

/obj/item/ammo_box/magazine/Initialize()
	. = ..()
	if(handfuls)
		var/obj/item/ammo_magazine/AM = new magazine_type(src)
		AM.max_rounds = num_of_magazines
		AM.generate_ammo(FALSE)
	else if(!empty)
		for(var/i = 1 to num_of_magazines)
			contents += new magazine_type(src)
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	update_icon()

/obj/item/ammo_box/magazine/update_icon()
	if(overlays)
		overlays.Cut()
	if(!icon_state_deployed) // The lid is on the sprite already.
		overlays += image(icon, icon_state = "[icon_state]_lid") //adding lid
	if(overlay_gun_type)
		overlays += image(text_markings_icon, icon_state = "text[overlay_gun_type]") //adding text
	if(overlay_ammo_type)
		overlays += image(text_markings_icon, icon_state = "base_type[overlay_ammo_type]") //adding base color stripes
	if(overlay_ammo_type!="_reg" && overlay_ammo_type!="_blank" && (!icon_state_deployed) )
		overlays += image(text_markings_icon, icon_state = "lid_type[overlay_ammo_type]") //adding base color stripes

//---------------------INTERACTION PROCS

/obj/item/ammo_box/magazine/get_examine_text(mob/living/user)
	. = ..()
	. += SPAN_INFO("[SPAN_HELPFUL("Activate")] box in hand or [SPAN_HELPFUL("click")] with it on the ground to deploy it. Activating it while empty will fold it into cardboard sheet.")
	if(src.loc != user) //feeling box weight in a distance is unnatural and bad
		return
	if(!handfuls)
		if(contents.len < (num_of_magazines/3))
			. += SPAN_INFO("It feels almost empty.")
			return
		if(contents.len < ((num_of_magazines*2)/3))
			. += SPAN_INFO("It feels about half full.")
			return
		. += SPAN_INFO("It feels almost full.")
	else
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in contents
		if(AM)
			if(AM.ammo_position < (AM.max_rounds/3))
				. += SPAN_INFO("It feels almost empty.")
				return
			if(AM.ammo_position < ((AM.max_rounds*2)/3))
				. += SPAN_INFO("It feels about half full.")
				return
			. += SPAN_INFO("It feels almost full.")
	if(burning)
		. += SPAN_DANGER("It's on fire and might explode!")

/obj/item/ammo_box/magazine/is_loaded()
	if(handfuls)
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in contents
		return AM?.ammo_position
	return length(contents)

/obj/item/ammo_box/magazine/deploy_ammo_box(mob/living/user, turf/T)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return

	var/box_on_tile = 0
	for(var/obj/structure/magazine_box/found_MB in T.contents)
		if(limit_per_tile != found_MB.limit_per_tile)
			to_chat(user, SPAN_WARNING("You can't deploy different size boxes in one place!"))
			return
		box_on_tile++
		if(box_on_tile >= limit_per_tile)
			to_chat(user, SPAN_WARNING("You can't cram any more boxes in here!"))
			return

	var/obj/structure/magazine_box/M = new /obj/structure/magazine_box(T)
	M.icon_state = icon_state_deployed ? icon_state_deployed : icon_state
	M.name = name
	M.desc = desc
	M.item_box = src
	M.can_explode = can_explode
	M.limit_per_tile = limit_per_tile
	M.update_icon()
	if(limit_per_tile > 1)
		M.assign_offsets(T)
	user.drop_inv_item_on_ground(src)
	Move(M)

/obj/item/ammo_box/magazine/afterattack(atom/target, mob/living/user, proximity)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return
	if(!proximity)
		return
	if(isturf(target))
		var/turf/T = target
		if(!T.density)
			deploy_ammo_box(user, T)

//---------------------FIRE HANDLING PROCS

/obj/item/ammo_box/magazine/process_burning(datum/cause_data/flame_cause_data)
	var/obj/structure/magazine_box/host_box
	if(istype(loc, /obj/structure/magazine_box))
		host_box = loc
	if(can_explode)
		var/time_until_explode = rand(1, 100)
		handle_side_effects(host_box, time_until_explode < 20)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/ammo_box, explode), flame_cause_data), time_until_explode)
	else
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), (host_box ? host_box : src)), 4 SECONDS)

/obj/item/ammo_box/magazine/handle_side_effects(obj/structure/magazine_box/host_box, will_explode = FALSE)
	var/shown_message = "\The [src] catches on fire!"
	if(will_explode)
		shown_message = "\The [src] catches on fire and ammunition starts cooking off! It's gonna blow!"

	if(host_box)
		host_box.apply_fire_overlay(will_explode)
		host_box.set_light_on(TRUE)
		host_box.visible_message(SPAN_WARNING(shown_message))
	else
		apply_fire_overlay(will_explode)
		set_light_on(TRUE)
		visible_message(SPAN_WARNING(shown_message))

/obj/item/ammo_box/magazine/apply_fire_overlay(will_explode = FALSE)
	//original fire overlay is made for standard mag boxes, so they don't need additional offsetting
	var/offset_y = 0
	if(limit_per_tile == 1) //snowflake nailgun ammo box again
		offset_y += -2
	var/image/fire_overlay = image(flames_icon, icon_state = will_explode ? "on_fire_explode_overlay" : "on_fire_overlay", pixel_y = offset_y)
	overlays.Add(fire_overlay)

//-----------------------------------------------------------------------------------

//-----------------------BIG AMMO BOX (with loose ammunition)---------------

/obj/item/ammo_box/rounds
	name = "rifle ammunition box (10x24mm)"
	desc = "A 10x24mm ammunition box. Used to refill M41A MK1, MK2, M4RA and M41AE2 HPR magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_m41"
	item_state = "base_m41"
	flags_equip_slot = SLOT_BACK
	var/overlay_gun_type = "_rounds" //used for ammo type color overlay
	var/overlay_content = "_reg"
	var/default_ammo = /datum/ammo/bullet/rifle
	var/default_projectile = /obj/item/projectile
	var/obj/item/projectile/current_rounds[]
	var/ammo_position = 0
	var/max_rounds = 600
	var/caliber = CALIBER_10X24MM
	can_explode = TRUE

/obj/item/ammo_box/rounds/empty
	empty = TRUE

//---------------------GENERAL PROCS

/obj/item/ammo_box/rounds/Initialize()
	. = ..()
	default_ammo = GLOB.ammo_list[default_ammo]
	if(max_rounds > AMMO_MAX_ROUNDS)
		max_rounds = AMMO_MAX_ROUNDS

	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	generate_ammo()
	update_icon()

/obj/item/ammo_box/rounds/proc/generate_ammo()
	current_rounds = list()
	current_rounds.len = max_rounds
	for(var/i = 1 to max_rounds)
		current_rounds[i] = empty ? "empty" : new default_projectile(src, null, default_ammo, caliber)
	if(!empty)
		ammo_position = current_rounds.len //The position is always in the beginning [1]. It can move from there.

/obj/item/ammo_box/rounds/update_icon()
	if(overlays)
		overlays.Cut()
	overlays += image(text_markings_icon, icon_state = "text[overlay_gun_type]") //adding base color stripes

	if(ammo_position == max_rounds)
		overlays += image(handfuls_icon, icon_state = "rounds[overlay_content]")
	else if(ammo_position > (max_rounds/2))
		overlays += image(handfuls_icon, icon_state = "rounds[overlay_content]_3")
	else if(ammo_position > (max_rounds/4))
		overlays += image(handfuls_icon, icon_state = "rounds[overlay_content]_2")
	else if(ammo_position > 0)
		overlays += image(handfuls_icon, icon_state = "rounds[overlay_content]_1")

//---------------------INTERACTION PROCS

/obj/item/ammo_box/rounds/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("To refill a magazine click on the box with it in your hand. Being on [SPAN_HELPFUL("HARM")] intent will fill box from the magazine.")
	if(ammo_position)
		. +=  "It contains [ammo_position] round\s."
	else
		. +=  "It's empty."
	if(burning)
		. += SPAN_DANGER("It's on fire and might explode!")

/obj/item/ammo_box/rounds/is_loaded()
	return ammo_position

/obj/item/ammo_box/rounds/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = I
		if(!isturf(loc))
			to_chat(user, SPAN_WARNING("\The [src] must be on the ground to be used."))
			return
		if(AM.flags_magazine & AMMUNITION_REFILLABLE)
			if(caliber[1] != AM.caliber[1])
				to_chat(user, SPAN_WARNING("The rounds don't match up. Better not mix them up."))
				return

			var/dumping = FALSE // we REFILL BOX (dump to it) on harm intent, otherwise we refill FROM box
			if(user.a_intent == INTENT_HARM)
				if(AM.flags_magazine & AMMUNITION_CANNOT_REMOVE_BULLETS)
					to_chat(user, SPAN_WARNING("You can't remove ammo from \the [AM]!"))
					return
				dumping = TRUE

			var/transfering   = 0   // Amount of bullets we're trying to transfer
			var/transferable  = 0   // Amount of bullets that can actually be transfered
			do
				// General checking
				if(dumping)
					transferable = min(AM.ammo_position, max_rounds - ammo_position)
				else
					transferable = min(ammo_position, AM.max_rounds - AM.ammo_position)
				if(transferable < 1)
					to_chat(user, SPAN_NOTICE("You cannot transfer any more rounds."))

				// Half-Loop 1: Start transfering
				else if(!transfering)
					transfering = min(transferable, 48) // Max per transfer
					if(!do_after(user, AM.transfer_delay * user.get_skill_duration_multiplier(SKILL_FIREARMS), INTERRUPT_ALL_OUT_OF_RANGE, dumping ? BUSY_ICON_HOSTILE : BUSY_ICON_FRIENDLY))
						to_chat(user, SPAN_NOTICE("You stop transferring rounds."))
						transferable = 0

				// Half-Loop 2: Process transfer
				else
					transfering = min(transfering, transferable)
					transferable -= transfering
					if(dumping)
						transfering = -transfering
					for(var/i=0;i<transfering;i++)
						var/obj/item/projectile/proj = current_rounds[ammo_position]
						current_rounds[ammo_position] = "empty"
						ammo_position--
						proj.forceMove(AM)
						AM.ammo_position++
						AM.current_rounds[AM.ammo_position] = proj
					AM.update_icon()
					update_icon()
					playsound(src, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 20, TRUE, 6)
					to_chat(user, SPAN_NOTICE("You have transferred [abs(transfering)] rounds to [dumping ? src : AM]."))
					transfering = 0

			while(transferable >= 1)

			AM.update_icon(AM.ammo_position)
			update_icon()

		else if(AM.flags_magazine & AMMUNITION_HANDFUL)
			if(!(default_ammo in AM.default_ammo))
				to_chat(user, SPAN_WARNING("Those aren't the same rounds. Better not mix them up."))
				return
			if(caliber != AM.caliber)
				to_chat(user, SPAN_WARNING("The rounds don't match up. Better not mix them up."))
				return
			if(ammo_position == max_rounds)
				to_chat(user, SPAN_WARNING("\The [src] is already full."))
				return

			playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)
			var/transfering = min(AM.ammo_position, max_rounds - ammo_position)
			for(var/i=0;i<transfering;i++)
				var/obj/item/projectile/proj = AM.transfer_bullet_out()
				proj.forceMove(src)
				ammo_position++
				current_rounds[ammo_position] = proj
			AM.update_icon()
			update_icon()
			to_chat(user, SPAN_NOTICE("You put [transfering] round\s into [src]."))
			if(AM.ammo_position <= 0)
				user.temp_drop_inv_item(AM)
				qdel(AM)

//---------------------FIRE HANDLING PROCS

/obj/item/ammo_box/rounds/process_burning(datum/cause_data/flame_cause_data)
	if(can_explode)
		var/time_until_explode = rand(1, 100)
		handle_side_effects(time_until_explode < 20)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/ammo_box, explode), flame_cause_data), time_until_explode)
	else
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), (src)), 6 SECONDS)

/obj/item/ammo_box/rounds/handle_side_effects(will_explode = FALSE)
	if(will_explode)
		visible_message(SPAN_WARNING("\The [src] catches on fire and ammunition starts cooking off! It's gonna blow!"))
	else
		visible_message(SPAN_WARNING("\The [src] catches on fire!"))

	apply_fire_overlay(will_explode)
	set_light_on(TRUE)

/obj/item/ammo_box/rounds/apply_fire_overlay(will_explode = FALSE)
	//original fire overlay is made for standard mag boxes, so they don't need additional offsetting
	var/image/fire_overlay = image(icon, icon_state = will_explode ? "on_fire_explode_overlay" : "on_fire_overlay", pixel_x = pixel_x, pixel_y = pixel_y)
	overlays.Add(fire_overlay)
