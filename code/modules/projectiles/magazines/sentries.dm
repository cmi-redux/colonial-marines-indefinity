// STANDARD Sentry
/obj/item/ammo_magazine/sentry
	name = "M30 ammo drum (10x28mm Caseless)"
	desc = "An ammo drum of 500 10x28mm caseless rounds for the UA 571-C Sentry Gun. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "ua571c"
	w_class = SIZE_MEDIUM
	flags_magazine = NO_FLAGS //can't be refilled or emptied by hand
	caliber = CALIBER_10X24MM
	max_rounds = 500
	ammo_preset = list(/datum/ammo/bullet/turret)
	gun_type = null
	transfer_delay = 0.6 SECONDS

/obj/item/ammo_magazine/sentry/dropped
	max_rounds = 100

/obj/item/ammo_magazine/sentry/premade
	max_rounds = 99999

/obj/item/ammo_magazine/sentry/premade/dumb
	ammo_preset = list(/datum/ammo/bullet/turret/dumb)

/obj/item/ammo_magazine/sentry/shotgun
	name = "12g buckshot drum"
	desc = "An ammo drum of 50 12g buckshot drums for the UA 12-G Shotgun Sentry. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	caliber = CALIBER_12G
	max_rounds = 50
	ammo_preset = list(/datum/ammo/bullet/shotgun/buckshot)

/obj/item/ammo_magazine/sentry/anti_tank
	name = "105mm \"crowbars\" drum"
	desc = "An ammo drum of 20 105mm \"crowbars\" drums for the UA AT DE-58 Sentry Gun. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	w_class = SIZE_HUGE
	caliber = CALIBER_105MM
	max_rounds = 20
	ammo_preset = list(/datum/ammo/bullet/tank/crowbar)

// FLAMER Sentry
/obj/item/ammo_magazine/sentry_flamer
	name = "sentry incinerator tank"
	desc = "A fuel tank of usually Ultra Thick Napthal Fuel, a sticky combustible liquid chemical, used in the UA 42-F."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "ua571c"
	w_class = SIZE_MEDIUM
	flags_magazine = NO_FLAGS
	caliber = "Napalm B"
	max_rounds = 100
	ammo_preset = list(/datum/ammo/flamethrower/sentry_flamer)
	gun_type = null

/obj/item/ammo_magazine/sentry_flamer/glob
	name = "plasma sentry incinerator tank"
	desc = "A fuel tank of compressed Ultra Thick Napthal Fuel, used in the UA 60-FP."
	ammo_preset = list(/datum/ammo/flamethrower/sentry_flamer/glob)

/obj/item/ammo_magazine/sentry_flamer/mini
	name = "mini sentry incinerator tank"
	desc = "A fuel tank of Ultra Thick Napthal Fuel, used in the UA 45-FM."
	ammo_preset = list(/datum/ammo/flamethrower/sentry_flamer/mini)
