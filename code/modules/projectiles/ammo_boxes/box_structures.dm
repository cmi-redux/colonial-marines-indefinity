//-----------------------MAG BOX STRUCTURE-----------------------

/obj/structure/magazine_box
	name = "magazine_box"
	icon = 'icons/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	icon_state = "base_m41"
	var/obj/item/ammo_box/magazine/item_box
	var/limit_per_tile = 1 //this is inherited from the item when deployed
	layer = LOWER_ITEM_LAYER	//to not hide other items

	var/can_explode = TRUE
	var/cause_data = "взрыв ящика боеприпасов"
	var/burning = FALSE

	var/text_markings_icon = 'icons/obj/items/weapons/guns/ammo_boxes/text.dmi'
	var/handfuls_icon = 'icons/obj/items/weapons/guns/ammo_boxes/handfuls.dmi'
	var/magazines_icon = 'icons/obj/items/weapons/guns/ammo_boxes/magazines.dmi'
	var/flames_icon = 'icons/obj/items/weapons/guns/ammo_boxes/misc.dmi'

//---------------------GENERAL PROCS

/obj/structure/magazine_box/Destroy()
	if(item_box)
		qdel(item_box)
		item_box = null
	return ..()

/obj/structure/magazine_box/update_icon()
	if(overlays)
		overlays.Cut()
		if(item_box.overlay_gun_type)
			overlays += image(text_markings_icon, icon_state = "text[item_box.overlay_gun_type]") //adding text

	if(!item_box.handfuls)
		if(item_box.overlay_ammo_type)
			overlays += image(text_markings_icon, icon_state = "base_type[item_box.overlay_ammo_type]") //adding base color stripes
		if(item_box.contents.len == item_box.num_of_magazines)
			overlays += image(magazines_icon, icon_state = "magaz[item_box.overlay_content]")
		else if(item_box.contents.len > (item_box.num_of_magazines/2))
			overlays += image(magazines_icon, icon_state = "magaz[item_box.overlay_content]_3")
		else if(item_box.contents.len > (item_box.num_of_magazines/4))
			overlays += image(magazines_icon, icon_state = "magaz[item_box.overlay_content]_2")
		else if(item_box.contents.len > 0)
			overlays += image(magazines_icon, icon_state = "magaz[item_box.overlay_content]_1")
	else
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
		if(item_box.overlay_ammo_type)
			overlays += image(text_markings_icon, icon_state = "base_type[item_box.overlay_ammo_type]")
		if(AM.ammo_position == item_box.num_of_magazines)
			overlays += image(icon, icon_state = "[item_box.handful][item_box.overlay_content]")
		else if(AM.ammo_position > (item_box.num_of_magazines/2))
			overlays += image(icon, icon_state = "[item_box.handful][item_box.overlay_content]_3")
		else if(AM.ammo_position > (item_box.num_of_magazines/4))
			overlays += image(icon, icon_state = "[item_box.handful][item_box.overlay_content]_2")
		else if(AM.ammo_position > 0)
			overlays += image(icon, icon_state = "[item_box.handful][item_box.overlay_content]_1")

//handles assigning offsets for stacked boxes
/obj/structure/magazine_box/proc/assign_offsets(turf/T)
	if(limit_per_tile == 2) //you can deploy 2 mag boxes per tile
		for(var/obj/structure/magazine_box/found_MB in T.contents)
			if(found_MB != src)
				pixel_y = found_MB.pixel_y * -1 //we assign a mirrored offset
				return
		pixel_y = -8 //if there is no box, by default we offset the box to the bottom
	else if(limit_per_tile == 4) //you can deploy 4 misc boxes per tile
		var/list/possible_offsets = list(list(-8, -3, TRUE), list(7, -3, TRUE), list(-8, 13, TRUE), list(7, 13, TRUE)) //x_offset, y_offset, available
		for(var/obj/structure/magazine_box/found_MB in T.contents)
			if(found_MB == src)
				continue
			for(var/list/L in possible_offsets)
				if(L[1] == found_MB.pixel_x && L[2] == found_MB.pixel_y)
					L[3] = FALSE
					break
		for(var/list/L in possible_offsets)
			if(L[3])
				pixel_x = L[1]
				pixel_y = L[2]
				return

//---------------------INTERACTION PROCS

/obj/structure/magazine_box/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr))
		if(burning)
			to_chat(usr, SPAN_DANGER("It's on fire and might explode!"))
			return

		if(!ishuman(usr))
			return
		visible_message(SPAN_NOTICE("[usr] picks up the [name]."))

		usr.put_in_hands(item_box)
		item_box = null
		qdel(src)

/obj/structure/magazine_box/get_examine_text(mob/user)
	. = ..()
	if(get_dist(src,user) > 2 && !isobserver(user))
		return
	. += SPAN_INFO("[SPAN_HELPFUL("Click")] on the box with an empty hand to take a magazine out. [SPAN_HELPFUL("Drag")] it onto yourself to pick it up.")
	if(item_box.handfuls)
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
		if(AM)
			. +=  SPAN_INFO("It has roughly [round(AM.ammo_position/5)] handfuls remaining.")
	else
		. +=  SPAN_INFO("It has [item_box.contents.len] magazines out of [item_box.num_of_magazines].")
	if(burning)
		. +=  SPAN_DANGER("It's on fire and might explode!")

/obj/structure/magazine_box/attack_hand(mob/living/user)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return
	if(item_box.contents.len)
		if(!item_box.handfuls)
			var/obj/item/ammo_magazine/ammo_magazine = pick(item_box.contents)
			item_box.contents -= ammo_magazine
			user.put_in_hands(ammo_magazine)
			to_chat(user, SPAN_NOTICE("You retrieve \a [ammo_magazine] from \the [src]."))
		else
			var/obj/item/ammo_magazine/ammo_magazine = locate(/obj/item/ammo_magazine) in item_box.contents
			if(ammo_magazine)
				ammo_magazine.retrieve_ammo(ammo_magazine.transfer_handful_amount, user)
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))

/obj/structure/magazine_box/attackby(obj/item/acting_magazine, mob/living/user)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return
	if(!item_box.handfuls)
		if(istypestrict(acting_magazine,item_box.magazine_type))
			if(istype(acting_magazine, /obj/item/storage/box/m94))
				var/obj/item/storage/box/m94/flare_pack = acting_magazine
				if(flare_pack.contents.len < flare_pack.max_storage_space)
					to_chat(user, SPAN_WARNING("\The [acting_magazine] is not full."))
					return
				var/flare_type
				if(istype(acting_magazine, /obj/item/storage/box/m94/signal))
					flare_type = /obj/item/device/flashlight/flare/signal
				else
					flare_type = /obj/item/device/flashlight/flare
				for(var/obj/item/device/flashlight/flare/flare in flare_pack.contents)
					if(flare.fuel < 1)
						to_chat(user, SPAN_WARNING("Some flares in \the [flare] are used."))
						return
					if(flare.type != flare_type)
						to_chat(user, SPAN_WARNING("Some flares in \the [acting_magazine] are not of the correct type."))
						return
			else if(istype(acting_magazine, /obj/item/storage/box/mre))
				var/obj/item/storage/box/mre/mre_pack = acting_magazine
				if(mre_pack.isopened)
					to_chat(user, SPAN_WARNING("\The [acting_magazine] was already opened and isn't suitable for storing in \the [src]."))
					return
			else if(istype(acting_magazine, /obj/item/cell/high))
				var/obj/item/cell/high/cell = acting_magazine
				if(cell.charge != cell.maxcharge)
					to_chat(user, SPAN_WARNING("\The [acting_magazine] needs to be fully charged before it can be stored in \the [src]."))
					return
			if(item_box.contents.len < item_box.num_of_magazines)
				user.drop_inv_item_to_loc(acting_magazine, src)
				item_box.contents += acting_magazine
				to_chat(user, SPAN_NOTICE("You put a [acting_magazine] in to \the [src]"))
				update_icon()
			else
				to_chat(user, SPAN_WARNING("\The [src] is full."))
		else
			to_chat(user, SPAN_WARNING("You don't want to mix different magazines in one box."))
	else
		if(istype(acting_magazine, /obj/item/ammo_magazine))
			var/obj/item/ammo_magazine/ammo_magazine = locate(/obj/item/ammo_magazine/shotgun) in item_box.contents
			ammo_magazine.attackby(acting_magazine, user, TRUE)

//---------------------FIRE HANDLING PROCS
/obj/structure/magazine_box/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	if(burning || !item_box)
		return
	burning = TRUE
	item_box.flamer_fire_act(damage, flame_cause_data)
	return

/obj/structure/magazine_box/proc/apply_fire_overlay(will_explode = FALSE)
	//original fire overlay is made for standard mag boxes, so they don't need additional offsetting
	var/offset_x = 0
	var/offset_y = 0

	if(limit_per_tile == 4) //misc boxes (mre, flares etc)
		offset_x += 1
		offset_y += -6
	else if(istype(src, /obj/item/ammo_box/magazine/nailgun)) //this snowflake again
		offset_y += -2

	var/image/fire_overlay = image(flames_icon, icon_state = will_explode ? "on_fire_explode_overlay" : "on_fire_overlay", pixel_x = offset_x, pixel_y = offset_y)
	overlays += (fire_overlay)
