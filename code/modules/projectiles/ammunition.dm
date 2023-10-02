//Magazine items, and casings.
/*
Boxes of ammo. Certain weapons have internal boxes of ammo that cannot be removed and function as part of the weapon.
They're all essentially identical when it comes to getting the job done.
*/
/obj/item/ammo_magazine
	name = "generic ammo"
	desc = "A box of ammo."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = null
	item_state = "ammo_mag" //PLACEHOLDER. This ensures the mag doesn't use the icon state instead.
	var/bonus_overlay = null //Sprite pointer in ammo.dmi to an overlay to add to the gun, for extended mags, box mags, and so on
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	matter = list("metal" = 1000)
	//Low.
	throwforce = 2
	w_class = SIZE_SMALL
	throw_speed = SPEED_SLOW
	throw_range = 6
	var/list/ammo_preset = list(/datum/ammo/bullet)
	var/list/default_ammo = list()
	var/default_projectile = /obj/item/projectile
	var/caliber = null // This is used for matching handfuls to each other or whatever the mag is. Examples are" "12g" ".44" ".357" etc.
	var/obj/item/projectile/current_rounds[]
	var/max_rounds = 7 //How many rounds can it hold?
	var/ammo_position = 0
	var/gun_type = null //Path of the gun that it fits. Mags will fit any of the parent guns as well, so make sure you want this.
	var/flags_magazine = AMMUNITION_REFILLABLE //flags specifically for magazines.
	var/base_mag_icon //the default mag icon state.
	var/base_mag_item //the default mag item (inhand) state.
	var/transfer_handful_amount = 8 //amount of bullets to transfer, 5 for 12g, 9 for 45-70
	var/handful_state = "bullet" //used for generating handfuls from boxes and setting their sprite when loading/unloading
	var/transfer_delay = 0.5 SECONDS
	var/cause_data = "взрыв боеприпасов"
	var/shrapnel_type = /datum/ammo/bullet/shrapnel
	var/explosing = FALSE
	var/acting_with = FALSE

	/// If this and ammo_band_icon aren't null, run update_ammo_band(). Is the color of the band, such as green on AP.
	var/ammo_band_color
	/// If this and ammo_band_color aren't null, run update_ammo_band() Is the greyscale icon used for the ammo band.
	var/ammo_band_icon
	/// Is the greyscale icon used for the ammo band when it's empty of bullets.
	var/ammo_band_icon_empty


/obj/item/ammo_magazine/Initialize(mapload, spawn_empty = FALSE)
	. = ..()
	for(var/i in ammo_preset)
		default_ammo += GLOB.ammo_list[i]

	GLOB.ammo_magazine_list += src
	base_mag_icon = icon_state
	base_mag_item = item_state
	if(max_rounds > AMMO_MAX_ROUNDS)
		max_rounds = AMMO_MAX_ROUNDS

	if(spawn_empty)
		icon_state += "_e"
		item_state += "_e"

	generate_ammo(spawn_empty)
	pixel_x = rand(-8, 8) //Want to move them just a tad.
	pixel_y = rand(-8, 8)
	if(ammo_band_color && ammo_band_icon)
		update_ammo_band()

/obj/item/ammo_magazine/Destroy()
	GLOB.ammo_magazine_list -= src
	return ..()

/obj/item/ammo_magazine/proc/update_ammo_band()
	overlays.Cut()
	var/band_icon = ammo_band_icon
	if(!ammo_position)
		band_icon = ammo_band_icon_empty
	var/image/ammo_band_image = image(icon, src, band_icon)
	ammo_band_image.color = ammo_band_color
	ammo_band_image.appearance_flags = RESET_COLOR|KEEP_APART
	overlays += ammo_band_image

/obj/item/ammo_magazine/clicked(mob/user, list/mods)
	if(mods["alt"] && Adjacent(user))
		if(src == user.get_inactive_hand()) //Have to be holding it in the hand.
			if(ammo_position > 0)
				check_bad_ammo(user)
			else
				to_chat(user, "[src] пуст. Нечего проверять.")
		return 1
	if(mods["ctrl"] && Adjacent(user))
		if(src == user.get_inactive_hand()) //Have to be holding it in the hand.
			if(ammo_position > 0)
				if(retrieve_ammo(1, user))
					return 1
			else
				to_chat(user, "[src] пуст. Нечего взять.")
		return 1
	return (..())

/obj/item/ammo_magazine/update_icon()
	if(ammo_position <= 0)
		icon_state = base_mag_icon + "_e"
		item_state = base_mag_item + "_e"
	else
		icon_state = base_mag_icon
		item_state = base_mag_item //to-do, unique magazine inhands for majority firearms.

	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		if(C.r_hand == src)
			C.update_inv_r_hand()
		else if(C.l_hand == src)
			C.update_inv_l_hand()

	if(ammo_band_color && ammo_band_icon)
		update_ammo_band()

/obj/item/ammo_magazine/get_examine_text(mob/user)
	. = ..()

	if(flags_magazine & AMMUNITION_HIDE_AMMO)
		return

	. += "[src] has <b>[ammo_position]</b> rounds out of <b>[max_rounds]</b>."

/obj/item/ammo_magazine/proc/check_bad_ammo(mob/user)
	if(acting_with)
		to_chat(user, "Вы уже взаимодествуете с [src].")
		return FALSE
	to_chat(user, "Вы начали проверять [src] на бракованные пули.")
	var/list/current_rounds_updated[max_rounds]
	for(var/i = 1 to max_rounds)
		current_rounds_updated[i] = "empty"

	var/broken_ammoes = 0
	for(var/b = 1 to ammo_position)
		var/obj/item/projectile/proj = current_rounds[b]
		if(do_after(user, transfer_delay * user.get_skill_duration_multiplier(SKILL_FIREARMS), INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_GENERIC))
			playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)

			if((proj.scrap_ammo_perc && prob(20)) || (proj.scrap_ammo_perc > 25))
				proj.forceMove(get_turf(user))
				current_rounds[ammo_position] = "empty"
				broken_ammoes++
				to_chat(user, "Вы выбрасываете из магазина бракованный патрон [proj].")
			else
				current_rounds_updated[b-broken_ammoes] = current_rounds[b]
				current_rounds[ammo_position] = "empty"
				to_chat(user, "Вы переходите к следующему патрону.")
		else
			to_chat(user, "Вы перестали искать бракованные патроны в [src].")
			for(var/c = 1 to ammo_position)
				current_rounds_updated[c-broken_ammoes] = current_rounds[c-broken_ammoes]
			break
	for(var/obj/item/projectile/proj as anything in current_rounds_updated)
		current_rounds[current_rounds_updated[proj]] = proj
	ammo_position -= broken_ammoes

/obj/item/ammo_magazine/attack_hand(mob/user)
	if(flags_magazine & AMMUNITION_REFILLABLE) //actual refillable magazine, not just a handful of bullets or a fuel tank.
		if(src == user.get_inactive_hand()) //Have to be holding it in the hand.
			if(retrieve_ammo(0, user))
				return TRUE
			return FALSE
	return ..() //Do normal stuff.

//We should only attack it with handfuls. Empty hand to take out, handful to put back in. Same as normal handful.
/obj/item/ammo_magazine/attackby(obj/item/I, mob/living/user, bypass_hold_check = 0)
	if(istype(I, /obj/item/ammo_magazine) && flags_magazine & AMMUNITION_REFILLABLE)
		var/obj/item/ammo_magazine/MG = I
		if(MG.flags_magazine & AMMUNITION_HANDFUL) //got a handful of bullets
			var/obj/item/ammo_magazine/handful/transfer_from = I
			if(src == user.get_inactive_hand() || bypass_hold_check) //It has to be held.
				transfer_ammo(transfer_from, transfer_from.ammo_position, user) // This takes care of the rest.
			else
				to_chat(user, "Try holding [src] before you attempt to restock it.")
	else if(istype(I, /obj/item/projectile) && (flags_magazine & AMMUNITION_REFILLABLE))
		if(src == user.get_inactive_hand() || bypass_hold_check) //It has to be held.
			var/obj/item/projectile/transfer_from = I
			transfer_bullet(transfer_from, user)
	else if(istype(I, /obj/item/tool/weldingtool))
		prime(create_cause_data(initial(I), user))

/obj/item/ammo_magazine/proc/ammo_transfer_action_check(obj/item/projectile/source, mob/user)
	if(explosing)
		to_chat(user, "Вы в своем уме? Оно сейчас рванет!")
		return FALSE
	if(user?.action_busy || acting_with)
		to_chat(user, "Вы уже чем-то заняты.")
		return FALSE
	if(source)
		if(ammo_position == max_rounds)
			to_chat(user, "[src] уже заполнено.")
			return FALSE
		if(source.caliber[1] != caliber[1])
			to_chat(user, "Они разного калибра, лучше их не смешивать.")
			return FALSE
	else
		if(!ammo_position)
			to_chat(user, "[src] пусто.")
			return FALSE
	return TRUE

/obj/item/ammo_magazine/proc/transfer_bullet_out(mob/user)
	if(user)
		if(!do_after(user, transfer_delay * user.get_skill_duration_multiplier(SKILL_FIREARMS), INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_FRIENDLY))
			return FALSE
		playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)
	var/obj/item/projectile/proj = current_rounds[ammo_position]
	current_rounds[ammo_position] = "empty"
	ammo_position--
	update_icon()
	proj.update_icon()
	return proj

/obj/item/ammo_magazine/proc/transfer_bullet_in(obj/item/projectile/transfering, mob/user)
	if(user)
		if(!do_after(user, transfer_delay * user.get_skill_duration_multiplier(SKILL_FIREARMS), INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_FRIENDLY))
			return FALSE
		playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)
		user.drop_inv_item_to_loc(transfering, src)
	else
		transfering.forceMove(src)
	ammo_position++
	current_rounds[ammo_position] = transfering
	update_icon()

/obj/item/ammo_magazine/proc/retrieve_ammo(transfer_amount, mob/user, put_somewhere = TRUE)
	if(!ammo_transfer_action_check(null, user))
		return FALSE
	acting_with = TRUE
	var/to_transfer = transfer_amount ? min(transfer_amount, ammo_position) : ammo_position
	var/transfered = 1
	var/obj/item/projectile/taken_projectile
	var/obj/item/ammo_magazine/handful/new_handful
	if(to_transfer == 1)
		taken_projectile = transfer_bullet_out(user)
		if(!taken_projectile)
			acting_with = FALSE
			return FALSE
		if(put_somewhere)
			if(user)
				user.put_in_hands(taken_projectile)
				to_chat(user, SPAN_NOTICE("Вы взяли <b>[transfered]</b> [taken_projectile] из [src]."))
			else
				taken_projectile.forceMove(get_turf(src))
	else
		var/obj/item/projectile/projectile_sample = current_rounds[ammo_position]
		new_handful = new projectile_sample.ammo.handful_type(src, TRUE, TRUE)
		new_handful.generate_handful(current_rounds[ammo_position].ammo, caliber, transfer_handful_amount, gun_type)
		new_handful.generate_ammo(TRUE)
		to_transfer = min(new_handful.max_rounds, ammo_position)

		var/obj/item/projectile/projectile_transfering = transfer_bullet_out(user)
		if(!projectile_transfering)
			acting_with = FALSE
			return FALSE
		new_handful.transfer_bullet_in(projectile_transfering)
		if(user)
			user.put_in_hands(new_handful)
		else
			new_handful.forceMove(get_turf(src))

		for(transfered;transfered<to_transfer;transfered++)
			var/obj/item/projectile/proj = transfer_bullet_out(user)
			if(!proj)
				break
			proj.forceMove(new_handful)
			new_handful.transfer_bullet_in(proj)

		if(user)
			to_chat(user, SPAN_NOTICE("Вы взяли <b>[transfered]</b> [new_handful] из [src]."))

	if(!ammo_position && istype(src, /obj/item/ammo_magazine/handful))
		if(user)
			user.temp_drop_inv_item(src)
		qdel(src)
	acting_with = FALSE
	if(put_somewhere)
		return transfered
	else
		return list(transfered, to_transfer == 1 ? taken_projectile : new_handful)

/obj/item/ammo_magazine/proc/transfer_bullet(obj/item/projectile/source, mob/user)
	if(!ammo_transfer_action_check(source, user))
		return FALSE
	acting_with = TRUE
	transfer_bullet_in(source, user)
	acting_with = FALSE
	return TRUE

/obj/item/ammo_magazine/proc/transfer_ammo(obj/item/ammo_magazine/source, transfer_amount, mob/user)
	if(!ammo_transfer_action_check(source, user))
		return
	acting_with = TRUE
	var/to_transfer = min(transfer_amount, max_rounds - ammo_position)
	var/transfered = 0
	for(transfered;transfered<to_transfer;transfered++)
		var/obj/item/projectile/proj = source.transfer_bullet_out(user)
		if(!proj)
			break
		proj.forceMove(src)
		transfer_bullet_in(proj)

	if(source.ammo_position <= 0 && istype(source, /obj/item/ammo_magazine/handful)) //We want to delete it if it'projectile a handful.
		if(user)
			user.temp_drop_inv_item(source)
		qdel(source) //Dangerous. Can mean future procs break if they reference the source. Have to account for this.

	acting_with = FALSE
	return transfered // We return the number transferred if it was successful.

/obj/item/ammo_magazine/proc/generate_ammo(empty)
	current_rounds = list()
	current_rounds.len = max_rounds
	for(var/i = 1 to max_rounds)
		current_rounds[i] = empty ? "empty" : new default_projectile(src, null, default_ammo[i % default_ammo.len + 1], caliber)
	if(!empty)
		ammo_position = current_rounds.len
	update_icon()

/obj/item/ammo_magazine/proc/generate_bad_ammo(amount_ammo_broken = 1)
	var/list/proj_pool = current_rounds.Copy()
	for(var/i=0;i<amount_ammo_broken;i++)
		var/obj/item/projectile/proj = pick(proj_pool)
		proj_pool -= proj
		if(!istype(proj))
			continue
		proj.scrap_ammo_perc += 4*round(0, max(amount_ammo_broken*20, 100))

//explosion
/obj/item/ammo_magazine/proc/explosing_check()
	if(!explosing)
		return TRUE
	return FALSE

/obj/item/ammo_magazine/proc/prime(datum/cause_data/weapon_cause_data)
	if(!explosing_check())
		return
	explosing = TRUE
	anchored = TRUE
	playsound(src, 'sound/effects/explosion_psss.ogg', 2, 1)
	if(!weapon_cause_data)
		weapon_cause_data = create_cause_data(cause_data)

	create_shrapnel(src, 4, , ,shrapnel_type, weapon_cause_data)
	start_shoting(src, , , , weapon_cause_data)
	cell_explosion(src, 50, 200, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, weapon_cause_data)
	if(!QDELETED(src))
		qdel(src)

/obj/item/ammo_magazine/proc/start_shoting(turf/epicenter, shrapnel_number = ammo_position, shrapnel_direction, shrapnel_spread = 90, datum/cause_data/cause_data_new, ignore_source_mob = FALSE, on_hit_coefficient = 0.15)
	epicenter = get_turf(epicenter)

	var/time_to_shot = 1 SECONDS
	if(shrapnel_number)
		time_to_shot = 5 SECONDS / shrapnel_number

	var/mob/living/mob_standing_on_turf
	var/mob/living/mob_lying_on_turf
	var/atom/source = epicenter

	for(var/mob/living/M in epicenter) //find a mob at the epicenter. Non-prone mobs take priority
		if(M.density && !mob_standing_on_turf)
			mob_standing_on_turf = M
		else if(!mob_lying_on_turf)
			mob_lying_on_turf = M

	if(mob_standing_on_turf && isturf(mob_standing_on_turf.loc))
		source = mob_standing_on_turf//we designate any mob standing on the turf as the "source" so that they don't simply get hit by every projectile


	for(var/i=0;i<shrapnel_number;i++)
		var/obj/item/projectile/proj = transfer_bullet_out()
		proj.bullet_ready_to_fire(initial(name), cause_data)
		if(cause_data_new)
			proj.weapon_cause_data = cause_data_new
		proj.forceMove(get_turf(src))

		var/mob/source_mob = cause_data_new?.resolve_mob()
		if(mob_standing_on_turf && mob_standing_on_turf && prob(100*on_hit_coefficient)) //if a non-prone mob is on the same turf as the shrapnel explosion, some of the shrapnel hits him
			proj.ammo.on_hit_mob(mob_standing_on_turf, proj)
			mob_standing_on_turf.bullet_act(proj)
		else if(mob_lying_on_turf && mob_lying_on_turf && prob(100*on_hit_coefficient))
			proj.ammo.on_hit_mob(mob_lying_on_turf, proj)
			mob_lying_on_turf.bullet_act(proj)

		else
			var/angle = rand(0,360)
			var/atom/target = get_angle_target_turf(epicenter, angle, 20)
			proj.projectile_flags |= PROJECTILE_SHRAPNEL
			proj.fire_at(target, source_mob, source, proj.ammo.max_range, proj.ammo.shell_speed)
		sleep(time_to_shot)

/obj/item/ammo_magazine/bullet_act(obj/item/projectile/proj)
	..()

	var/ammo_flags = proj.ammo.traits_to_give | proj.projectile_override_flags
	if(ammo_flags && ammo_flags & (/datum/element/bullet_trait_incendiary) || proj.ammo.flags_ammo_behavior & AMMO_XENO)
		addtimer(CALLBACK(src, PROC_REF(prime), proj.weapon_cause_data), 1)
	else if(rand(0,50) < 1)
		addtimer(CALLBACK(src, PROC_REF(prime), proj.weapon_cause_data), 1)
	else
		generate_bad_ammo(rand(1, ammo_position))

/obj/item/ammo_magazine/ex_act(severity, explosion_direction, datum/cause_data/explosion_cause_data)
	switch(severity)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			addtimer(CALLBACK(src, PROC_REF(prime), explosion_cause_data), 1)

/obj/item/ammo_magazine/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	addtimer(CALLBACK(src, PROC_REF(prime), flame_cause_data), 1)

//Magazines that actually cannot be removed from the firearm. Functionally the same as the regular thing, but they do have three extra vars.
/obj/item/ammo_magazine/internal
	name = "internal chamber"
	desc = "You should not be able to examine it."
	//For revolvers and shotguns.
	var/chamber_closed = 1 //Starts out closed. Depends on firearm.

//Helper proc, to allow us to see a percentage of how full the magazine is.
/obj/item/ammo_magazine/proc/get_ammo_percent() // return % charge of cell
	return 100*ammo_position/max_rounds

//----------------------------------------------------------------//
//Now for handfuls, which follow their own rules and have some special differences from regular boxes.

/*
Handfuls are generated dynamically and they are never actually loaded into the item.
What they do instead is refill the magazine with ammo and sometime save what sort of
ammo they are in order to use later. The internal magazine for the gun really does the
brunt of the work. This is also far, far better than generating individual items for
bullets/shells. ~N
*/

/obj/item/ammo_magazine/handful
	name = "generic handful"
	desc = "A handful of rounds to reload on the go."
	icon = 'icons/obj/items/weapons/guns/handful.dmi'
	icon_state = "bullet_1"
	matter = list("metal" = 50) //This changes based on the ammo ammount. 5k is the base of one shell/bullet.
	flags_equip_slot = null // It only fits into pockets and such.
	w_class = SIZE_SMALL
	max_rounds = 5 // For shotguns, though this will be determined by the handful type when generated.
	flags_atom = FPRINT|CONDUCT
	flags_magazine = AMMUNITION_HANDFUL
	attack_speed = 3 // should make reloading less painful

/obj/item/ammo_magazine/handful/Initialize(mapload, spawn_empty)
	. = ..()
	update_icon()

/obj/item/ammo_magazine/handful/update_icon() //Handles the icon itself as well as some bonus things.
	if(max_rounds >= ammo_position)
		var/I = ammo_position*50 // For the metal.
		matter = list("metal" = I)
	icon_state = handful_state + "_[ammo_position]"

/obj/item/ammo_magazine/handful/pickup(mob/user)
	var/olddir = dir
	. = ..()
	dir = olddir

/obj/item/ammo_magazine/handful/equipped(mob/user, slot)
	var/thisDir = src.dir
	..(user,slot)
	setDir(thisDir)
	return

/obj/item/ammo_magazine/handful/attackby(obj/item/transfer_from, mob/user)
	if(istype(transfer_from, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/transfering = transfer_from
		if(transfer_ammo(transfering, transfering.ammo_position, user))
			return TRUE
		return FALSE

	else if(istype(transfer_from, /obj/item/projectile))
		var/obj/item/projectile/transfering = transfer_from
		if(transfer_bullet(transfering, user))
			return TRUE
		return FALSE

/obj/item/ammo_magazine/handful/proc/generate_handful(new_ammo, new_caliber, new_max_rounds, new_gun_type)
	var/datum/ammo/A = new_ammo
	var/ammo_name = A.name //Let'projectile pull up the name.
	var/multiple_handful_name = A.multiple_handful_name

	name = "handful of [ammo_name + (multiple_handful_name ? " ":"projectile ") + "([new_caliber[1]])"]"

	default_ammo = list(new_ammo)
	caliber = new_caliber
	max_rounds = new_max_rounds
	if(new_gun_type)
		gun_type = new_gun_type
	handful_state = A.handful_state
	if(A.handful_color)
		color = A.handful_color
	update_icon()

//----------------------------------------------------------------//
