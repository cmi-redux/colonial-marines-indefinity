/obj/item/weapon/gun/pistol/tranquilizer
	name = "Tranquilizer gun"
	desc = "Contains horse tranquilizer darts. Useful at knocking people out."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/event.dmi'
	icon_state = "pk9r"
	item_state = "pk9r"
	current_mag = /obj/item/ammo_magazine/pistol/tranq


/obj/item/weapon/gun/pistol/tranquilizer/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	damage_mult = 0 // Miniscule amounts of damage

/obj/item/weapon/gun/pistol/tranquilizer/handle_starting_attachment()//Making the gun have an invisible silencer since it's supposed to have one.
	..()
	var/obj/item/attachable/suppressor/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/ammo_magazine/pistol/tranq
	name = "Tranquilizer magazine (Horse Tranquilizer)"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	ammo_preset = list(/datum/ammo/bullet/pistol/tranq)
	caliber = CALIBER_22
	icon_state = "pk-9_tranq"
	max_rounds = 5
	gun_type = /obj/item/weapon/gun/pistol/tranquilizer
