//Special ammo magazines for hardpoint modules. Some aren't here since you can use normal magazines on them
/obj/item/ammo_magazine/hardpoint
	flags_magazine = 0 //No refilling

/obj/item/ammo_magazine/hardpoint/attackby(obj/item/O, mob/user)
	if(O.type != type)
		to_chat(user, SPAN_WARNING("You need another [initial(name)] to be able to transfer ammo."))
		return

	transfer_ammo(O, user)

/obj/item/ammo_magazine/hardpoint/transfer_ammo(obj/item/ammo_magazine/source, mob/user)
	if(ammo_position == max_rounds)
		to_chat(user, SPAN_WARNING("[src] is already full."))
		return

	if(!source.ammo_position)
		to_chat(user, SPAN_WARNING("[source] is empty, find a new one."))
		return

	if(source.caliber != caliber) //Are they the same caliber?
		to_chat(user, SPAN_WARNING("Wrong ammo type."))
		return

	user.visible_message(SPAN_WARNING("[user] starts refilling [src]."), SPAN_WARNING("You start refilling [src]."))

	if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		user.visible_message(SPAN_WARNING("[user] stops refilling [src]."), SPAN_WARNING("You stop refilling [src]."))
		return

	var/S = min(max_rounds - ammo_position, source.ammo_position)

	for(var/i=0;i<S;i++)
		var/obj/item/projectile/P = source.transfer_bullet_out()
		P.forceMove(src)
		ammo_position++
		current_rounds[ammo_position] = P
	source.update_icon()
	update_icon()
	user.visible_message(SPAN_WARNING("[user] finishes refilling [src]."), SPAN_WARNING("You finish refilling [src]. Ammo count: [ammo_position]."))
