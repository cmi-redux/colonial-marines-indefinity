/obj/item/ammo_magazine/hardpoint/ltb_cannon
	name = "LTB Cannon Magazine"
	desc = "A primary armament cannon magazine"
	caliber = "86mm" //Making this unique on purpose
	icon_state = "ltbcannon_4"
	w_class = SIZE_LARGE //Heavy fucker
	ammo_preset = list(/datum/ammo/rocket/ltb)
	max_rounds = 4
	gun_type = /obj/item/hardpoint/primary/cannon

/obj/item/ammo_magazine/hardpoint/ltb_cannon/update_icon()
	icon_state = "ltbcannon_[ammo_position]"
