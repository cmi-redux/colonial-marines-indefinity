

//Minigun

/obj/item/ammo_magazine/minigun
	name = "rotating ammo drum (7.62x51mm)"
	desc = "A huge ammo drum for a huge gun."
	caliber = CALIBER_7_62X51MM
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "painless" //PLACEHOLDER

	matter = list("metal" = 10000)
	ammo_preset = list(/datum/ammo/bullet/minigun)
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/minigun
	w_class = SIZE_MEDIUM
	transfer_delay = 3 SECONDS

//M60

/obj/item/ammo_magazine/m60
	name = "M60 ammo box (7.62x51mm)"
	desc = "A blast from the past chambered in 7.62X51mm NATO."
	caliber = CALIBER_7_62X51MM
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "m60" //PLACEHOLDER

	matter = list("metal" = 10000)
	ammo_preset = list(/datum/ammo/bullet/m60)
	max_rounds = 100
	gun_type = /obj/item/weapon/gun/m60
	transfer_delay = 2 SECONDS

//rocket launchers

/obj/item/ammo_magazine/rifle/grenadespawner
	name = "GRENADE SPAWNER AMMO"
	desc = "OH GOD OH FUCK"
	ammo_preset = list(/datum/ammo/grenade_container/rifle)
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/huggerspawner
	name = "HUGGER SPAWNER AMMO"
	desc = "OH GOD OH FUCK"
	ammo_preset = list(/datum/ammo/hugger_container)
	ammo_band_color = AMMO_BAND_COLOR_SUPER
