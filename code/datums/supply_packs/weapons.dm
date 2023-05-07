/datum/supply_packs/m56b_smartgun
	name = "M56B Smartgun System Package (x1)"
	contains = list(
		/obj/item/storage/box/m56_system,
	)
	cost = 100
	containertype = /obj/structure/closet/crate/weapon
	containername = "M56B Smartgun System Package"
	group = "Weapons"

/datum/supply_packs/flamethrower
	name = "M240 Flamethrower Crate (M240 x2, Broiler-T Fuelback x2)"
	contains = list(
		/obj/item/storage/box/guncase/flamer,
		/obj/item/storage/box/guncase/flamer,
		/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit,
		/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "M240 Incinerator crate"
	group = "Weapons"

/datum/supply_packs/mou53
	name = "MOU-53 Break Action Shotgun Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/mou53,
		/obj/item/storage/box/guncase/mou53,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "MOU-53 Breack Action Shotgun Crate"
	group = "Weapons"

/datum/supply_packs/turrets
	name = "turrets supply pack"
	contains = list(
		/obj/item/defenses/handheld/tesla_coil,
		/obj/item/defenses/handheld/planted_flag,
		/obj/item/defenses/handheld/bell_tower,
		/obj/item/defenses/handheld/sentry,
		/obj/item/defenses/handheld/sentry/flamer
	)
	cost = 240
	containertype = /obj/structure/closet/crate
	containername = "turrets supply pack"
	group = "Weapons"

/datum/supply_packs/turret_tesla
	name = "turrets supply pack (x1 21S Tesla Coil)"
	contains = list(
		/obj/item/defenses/handheld/tesla_coil
	)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "turret supply pack"
	group = "Weapons"

/datum/supply_packs/turret_jima
	name = "turrets supply pack (x1 JIMA Planted Flag)"
	contains = list(
		/obj/item/defenses/handheld/planted_flag
	)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "turret supply pack"
	group = "Weapons"

/datum/supply_packs/turret_bell
	name = "turrets supply pack (x1 R-1NG Bell Tower)"
	contains = list(
		/obj/item/defenses/handheld/bell_tower
	)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "turret supply pack"
	group = "Weapons"

/datum/supply_packs/turret_sentry
	name = "turrets supply pack (x1 UA 571-C Sentry Gun)"
	contains = list(
		/obj/item/defenses/handheld/sentry
	)
	cost = 70
	containertype = /obj/structure/closet/crate
	containername = "turret supply pack"
	group = "Weapons"

/datum/supply_packs/turret_flamer
	name = "turrets supply pack (x1 UA 42-F Sentry Flamer)"
	contains = list(
		/obj/item/defenses/handheld/sentry/flamer
	)
	cost = 70
	containertype = /obj/structure/closet/crate
	containername = "turret supply pack"
	group = "Weapons"

/datum/supply_packs/smartpistol
	name = "SU-6 Smart Pistol Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/smartpistol,
		/obj/item/storage/box/guncase/smartpistol,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "SU-6 Smart Pistol Crate"
	group = "Weapons"

/datum/supply_packs/vp78
	name = "VP-78 Hand Cannon Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/vp78,
		/obj/item/storage/box/guncase/vp78,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "VP-78 Hand Cannon Crate"
	group = "Weapons"

/datum/supply_packs/gun
	contains = list(
		/obj/item/weapon/gun/rifle/m41aMK1,
		/obj/item/weapon/gun/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1,
	)
	name = "M41A MK1 Rifle Crate (x2 MK1, x2 magazines)"
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "M41A MK1 Rifle Crate"
	group = "Weapons"

/datum/supply_packs/gun/heavyweapons
	contains = list(
		/obj/item/storage/box/guncase/lmg,
		/obj/item/storage/box/guncase/lmg,
	)
	name = "M41AE2 HPR crate (HPR x2, HPR ammo box x2)"
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M41AE2 HPR crate"
	group = "Weapons"

/datum/supply_packs/gun/merc
	contains = list()
	name = "black market firearms (x1)"
	cost = 40
	contraband = 1
	containertype = /obj/structure/largecrate/guns/merc
	containername = "\improper black market firearms crate"
	group = "Weapons"
