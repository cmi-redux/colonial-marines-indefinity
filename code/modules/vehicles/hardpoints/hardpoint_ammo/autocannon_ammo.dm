/obj/item/ammo_magazine/hardpoint/ace_autocannon
	name = "Tank Autocannon Magazine"
	desc = "A primary armament autocannon magazine"
	caliber = "20mm"
	icon_state = "ace_autocannon"
	w_class = SIZE_LARGE
	ammo_preset = list(/datum/ammo/bullet/tank/flak)
	max_rounds = 40
	gun_type = /obj/item/hardpoint/primary/autocannon

/obj/item/ammo_magazine/hardpoint/ace_autocannon/update_icon()
	if(ammo_position > 0)
		icon_state = "ace_autocannon"
	else
		icon_state = "ace_autocannon_empty"
