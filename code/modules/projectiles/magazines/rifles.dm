


//-------------------------------------------------------
//M41A (MK2) PULSE RIFLE AMMUNITION

/obj/item/ammo_magazine/rifle
	name = "M41A magazine"
	desc = "A 10mm assault rifle magazine."
	caliber = CALIBER_10X24MM
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "m41a"
	item_state = "generic_mag"
	w_class = SIZE_MEDIUM
	ammo_preset = list(/datum/ammo/bullet/rifle)
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/m41a
	transfer_delay = 0.8 SECONDS
	ammo_band_icon = "+m41a_band"
	ammo_band_icon_empty = "+m41a_band_e"

/obj/item/ammo_magazine/rifle/extended
	name = "M41A extended magazine"
	desc = "A 10mm assault extended rifle magazine."
	icon_state = "m41a_extended"
	max_rounds = 60
	bonus_overlay = "m41a_ex"

/obj/item/ammo_magazine/rifle/incendiary
	name = "M41A incendiary magazine"
	desc = "A 10mm assault rifle magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/incendiary)
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/explosive
	name = "M41A explosive magazine"
	desc = "A 10mm assault rifle magazine. Oh god... just don't hit friendlies with it."
	ammo_preset = list(/datum/ammo/bullet/rifle/explosive)
	ammo_band_color = AMMO_BAND_COLOR_EXPLOSIVE

/obj/item/ammo_magazine/rifle/heap
	name = "M41A HEAP magazine (10x24mm)"
	desc = "A 10mm armor piercing high explosive magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/heap)
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/ap
	name = "M41A AP magazine"
	desc = "A 10mm armor piercing magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap)
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/le
	name = "M41A LE magazine"
	desc = "A 10mm armor shredding magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/le)
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/penetrating
	name = "M41A wall-piercing magazine"
	desc = "A 10mm wall-piercing magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/penetrating)
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/cluster
	name = "M41A cluster magazine"
	desc = "A 10mm cluster magazine. Designed to attach tiny explosives to targets, to detonate all at once if enough hit."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/cluster)
	ammo_band_color = AMMO_BAND_COLOR_CLUSTER

/obj/item/ammo_magazine/rifle/toxin
	name = "M41A toxin magazine"
	desc = "A 10mm toxin magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/toxin)
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/rifle/rubber
	name = "M41A Rubber Magazine"
	desc = "A 10mm magazine filled with rubber bullets."
	ammo_preset = list(/datum/ammo/bullet/rifle/rubber)
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/extended/mixed
	name = "M41A extended mixed magazine"
	desc = "A 10mm assault extended mixed rifle magazine."
	ammo_band_color = AMMO_BAND_COLOR_MIXED

/obj/item/ammo_magazine/rifle/extended/mixed/ea_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap)

/obj/item/ammo_magazine/rifle/extended/mixed/eai_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap, /datum/ammo/bullet/rifle/incendiary)

/obj/item/ammo_magazine/rifle/extended/mixed/eaictp_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap, /datum/ammo/bullet/rifle/incendiary, /datum/ammo/bullet/rifle/ap/cluster, /datum/ammo/bullet/rifle/ap/toxin, /datum/ammo/bullet/rifle/ap/penetrating)

//-------------------------------------------------------
//M41A (MK1) TRUE AND ORIGINAL

/obj/item/ammo_magazine/rifle/m41aMK1
	name = "M41A MK1 magazine"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds."
	icon_state = "m41a_mk1"
	max_rounds = 95
	gun_type = /obj/item/weapon/gun/rifle/m41aMK1
	ammo_preset = list(/datum/ammo/bullet/rifle)
	ammo_band_icon = "+m41a_mk1_band"
	ammo_band_icon_empty = "+m41a_mk1_band_e"

/obj/item/ammo_magazine/rifle/m41aMK1/ap
	name = "M41A MK1 AP magazine"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains AP bullets."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap)
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/m41aMK1/heap
	name = "M41A MK1 HEAP magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains High-Explosive Armor-Piercing bullets."
	ammo_preset = list(/datum/ammo/bullet/rifle/heap)
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/m41aMK1/incendiary
	name = "M41A MK1 incendiary magazine"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains incendiary bullets."
	ammo_preset = list(/datum/ammo/bullet/rifle/incendiary)
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/m41aMK1/toxin
	name = "M41A MK1 toxin magazine"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains toxic bullets."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/toxin)
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/rifle/m41aMK1/penetrating
	name = "M41A MK1 wall-piercing magazine"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains wall-piercing bullets."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/penetrating)
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/m41aMK1/cluster
	name = "M41A MK1 cluster magazine"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains cluster bullets."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/cluster)
	ammo_band_color = AMMO_BAND_COLOR_CLUSTER

/obj/item/ammo_magazine/rifle/m41aMK1/mixed
	name = "M41A MK1 mixed magazine"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains mixed bullets types"
	ammo_band_color = AMMO_BAND_COLOR_MIXED

/obj/item/ammo_magazine/rifle/m41aMK1/mixed/ea_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap)

/obj/item/ammo_magazine/rifle/m41aMK1/mixed/eai_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap, /datum/ammo/bullet/rifle/incendiary)

/obj/item/ammo_magazine/rifle/m41aMK1/mixed/eaictp_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap, /datum/ammo/bullet/rifle/incendiary, /datum/ammo/bullet/rifle/ap/cluster, /datum/ammo/bullet/rifle/ap/toxin, /datum/ammo/bullet/rifle/ap/penetrating)

//-------------------------------------------------------
//M4RA, l42 reskin, same stats as before but different, lore friendly, shell.

/obj/item/ammo_magazine/rifle/m4ra
	name = "M4RA magazine (10x24mm)"
	desc = "A magazine of standard 10x24mm rounds for use in the M4RA battle rifle."
	icon_state = "m4ra"
	ammo_preset = list(/datum/ammo/bullet/rifle)
	max_rounds = 25
	gun_type = /obj/item/weapon/gun/rifle/m4ra
	ammo_band_icon = "+m4ra_band"
	ammo_band_icon_empty = "+m4ra_band_e"

/obj/item/ammo_magazine/rifle/m4ra/ap
	name = "M4RA armor-piercing magazine (10x24mm)"
	desc = "A magazine of armor-piercing 10x24mm rounds for use in the M4RA battle rifle."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap)
	max_rounds = 25
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/m4ra/le
	name = "M4RA LE magazine (10x24mm)"
	desc = "A magazine of armor-piercing 10x24mm rounds armor shredding magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/le)
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/m4ra/ext
	name = "M4RA extended magazine (10x24mm)"
	desc = "A magazine of armor-piercing 10x24mm rounds for use in the M4RA battle rifle. Holds an additional 10 rounds, up to 35."
	icon_state = "m4ra_extended"
	bonus_overlay = "m4ra_ex"
	max_rounds = 35

/obj/item/ammo_magazine/rifle/m4ra/rubber
	name = "M4RA rubber magazine (10x24mm)"
	desc = "A magazine of less than lethal rubber 10x24mm rounds for use in the M4RA battle rifle."
	ammo_preset = list(/datum/ammo/bullet/rifle/rubber)
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/m4ra/heap
	name = "M4RA high-explosive armor-piercing magazine (10x24mm)"
	desc = "A magazine of high explosive armor piercing 10x24mm rounds for use in the M4RA battle rifle."
	ammo_preset = list(/datum/ammo/bullet/rifle/heap)
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/m4ra/incendiary
	name = "M4RA incendiary magazine (10x24mm)"
	desc = "A magazine of incendiary 10x24mm rounds for use in the M4RA battle rifle."
	ammo_preset = list(/datum/ammo/bullet/rifle/incendiary)
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/m4ra/toxin
	name = "M4RA toxin magazine (10x24mm)"
	desc = "A magazine of toxin 10x24mm rounds for use in the M4RA battle rifle."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/toxin)
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/rifle/m4ra/penetrating
	name = "M4RA wall-penetrating magazine (10x24mm)"
	desc = "A magazine of wall-penetrating 10x24mm rounds for use in the M4RA battle rifle."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/penetrating)
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/m4ra/cluster
	name = "M4RA cluster magazine (10x24mm)"
	desc = "A magazine of cluster 10x24mm rounds for use in the M4RA battle rifle."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/cluster)
	ammo_band_color = AMMO_BAND_COLOR_CLUSTER

/obj/item/ammo_magazine/rifle/m4ra/ext/mixed
	name = "M4RA mixed magazine"
	desc = "A magazine of mixed 10x24mm rounds for use in the M4RA battle rifle."
	ammo_band_color = AMMO_BAND_COLOR_MIXED

/obj/item/ammo_magazine/rifle/m4ra/ext/mixed/ea_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap)

/obj/item/ammo_magazine/rifle/m4ra/ext/mixed/eai_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap, /datum/ammo/bullet/rifle/incendiary)

/obj/item/ammo_magazine/rifle/m4ra/ext/mixed/eaictp_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap, /datum/ammo/bullet/rifle/incendiary, /datum/ammo/bullet/rifle/ap/cluster, /datum/ammo/bullet/rifle/ap/toxin, /datum/ammo/bullet/rifle/ap/penetrating)

//-------------------------------------------------------
//XM40 AKA SOF RIFLE FROM HELL (It's an EM-2, a prototype of the real world L85A1 way back from the 1940s. We've given it a blue plastic shell and an integral suppressor)

/obj/item/ammo_magazine/rifle/xm40
	name = "XM40 magazine (10x24mm)"
	desc = "A stubby and wide, high-capacity double stack magazine used in the XM40 pulse rifle. Fires 10x24mm Armor Piercing rounds, holding up to 60 + 1 in the chamber."
	icon_state = "m40_sd"
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/m41a/elite/xm40
	ammo_preset = list(/datum/ammo/bullet/rifle/ap)

/obj/item/ammo_magazine/rifle/xm40/heap
	name = "XM40 HEAP magazine (10x24mm)"
	desc = "A stubby and wide, high-capacity double stack magazine used in the XM40 pulse rifle. Fires 10x24mm High Explosive Armor Piercing rounds, holding up to 60 + 1 in the chamber."
	icon_state = "m40_sd_heap"
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/m41a/elite/xm40
	ammo_preset = list(/datum/ammo/bullet/rifle/heap)

//-------------------------------------------------------
//MAR-40 AK CLONE //AK47 and FN FAL together as one.

/obj/item/ammo_magazine/rifle/mar40
	name = "MAR magazine (7.62x39mm)"
	desc = "A 7.62x39mm magazine for the MAR series of firearms."
	caliber = CALIBER_7_62X39MM
	icon_state = "mar40"
	ammo_preset = list(/datum/ammo/bullet/rifle/mar40)
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/mar40
	w_class = SIZE_MEDIUM

/obj/item/ammo_magazine/rifle/mar40/extended
	name = "MAR extended magazine (7.62x39mm)"
	desc = "A 7.62x39mm MAR magazine, this one carries more rounds than the average magazine."
	max_rounds = 60
	bonus_overlay = "mar40_ex"
	icon_state = "mar40_extended"

/obj/item/ammo_magazine/rifle/mar40/lmg
	name = "MAR drum magazine (7.62x39mm)"
	desc = "A 7.62x39mm drum magazine for the MAR-50 LMG."
	icon_state = "mar50"
	max_rounds = 100
	gun_type = /obj/item/weapon/gun/rifle/mar40/lmg

//-------------------------------------------------------
//M16 RIFLE

/obj/item/ammo_magazine/rifle/m16
	name = "M16 magazine (5.56x45mm)"
	desc = "A 5.56x45mm magazine for the M16 assault rifle."
	caliber = CALIBER_5_56X45MM
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "m16"
	ammo_preset = list(/datum/ammo/bullet/rifle)
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/m16
	w_class = SIZE_MEDIUM
	ammo_band_icon = "+m16_band"
	ammo_band_icon_empty = "+m16_band_e"

/obj/item/ammo_magazine/rifle/m16/ap
	name = "M16 AP magazine (5.56x45mm)"
	desc = "An AP 5.56x45mm magazine for the M16 assault rifle."
	caliber = CALIBER_5_56X45MM
	ammo_preset = list(/datum/ammo/bullet/rifle/ap)
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/m16
	w_class = SIZE_MEDIUM
	ammo_band_color = AMMO_BAND_COLOR_AP

//-------------------------------------------------------
//AR10 RIFLE

/obj/item/ammo_magazine/rifle/ar10
	name = "AR10 magazine (7.62x51mm)"
	desc = "A 7.62x51mm magazine for the AR10 assault rifle."
	caliber = "7.62x51mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "ar10"
	ammo_preset = list(/datum/ammo/bullet/rifle)
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/ar10
	w_class = SIZE_MEDIUM

//-------------------------------------------------------
//M41AE2 HEAVY PULSE RIFLE

/obj/item/ammo_magazine/rifle/lmg
	name = "M41AE2 ammo box"
	desc = "A semi-rectangular box of rounds for the M41AE2 Heavy Pulse Rifle."
	icon_state = "m41ae2"
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/rifle/lmg
	flags_magazine = AMMUNITION_CANNOT_REMOVE_BULLETS|AMMUNITION_REFILLABLE
	ammo_band_icon = "+m41ae2_band"
	ammo_band_icon_empty = "+m41ae2_band_e"

/obj/item/ammo_magazine/rifle/lmg/holo_target
	name = "M41AE2 ammo box (10x24mm holo-target)"
	desc = "A semi-rectangular box of holo-target rounds for the M41AE2 Heavy Pulse Rifle."
	ammo_preset = list(/datum/ammo/bullet/rifle/holo_target)
	max_rounds = 200
	ammo_band_color = AMMO_BAND_COLOR_HOLOTARGETING

/obj/item/ammo_magazine/rifle/lmg/heap
	name = "M41AE2 HEAP ammo box (10x24mm)"
	desc = "A semi-rectangular box of rounds for the M41AE2 Heavy Pulse Rifle. This one contains the standard Armor-Piercing explosive tipped round of the USCM."
	ammo_preset = list(/datum/ammo/bullet/rifle/heap)
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/rifle/lmg
	ammo_band_color = AMMO_BAND_COLOR_HEAP

//-------------------------------------------------------
//UPP TYPE 71 RIFLE

/obj/item/ammo_magazine/rifle/type71
	name = "Type 71 magazine (5.45x39mm)"
	desc = "A 5.45x39mm high-capacity casket magazine for the Type 71 rifle."
	caliber = CALIBER_5_45X39MM
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "type_71"
	ammo_preset = list(/datum/ammo/bullet/rifle/type71)
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/type71

/obj/item/ammo_magazine/rifle/type71/ap
	name = "Type 71 AP magazine (5.45x39mm)"
	desc = "A 5.45x39mm high-capacity casket magazine containing armor piercing rounds for the Type 71 rifle."
	icon_state = "type_71_ap"
	ammo_preset = list(/datum/ammo/bullet/rifle/type71/ap)
	bonus_overlay = "type71_ap"

/obj/item/ammo_magazine/rifle/type71/heap
	name = "Type 71 HEAP magazine (5.45x39mm)"
	desc = "A 5.45x39mm high-capacity casket magazine containing the standard high explosive armor piercing rounds for the Type 71 rifle."
	icon_state = "type_71_heap"
	ammo_preset = list(/datum/ammo/bullet/rifle/type71/heap)
	bonus_overlay = "type71_heap"

//-------------------------------------------------------
//L42A Battle Rifle

/obj/item/ammo_magazine/rifle/l42a
	name = "L42A magazine (10x24mm)"
	desc = "A 10mm battle rifle magazine."
	icon_state = "l42mk1"
	ammo_preset = list(/datum/ammo/bullet/rifle)
	bonus_overlay = "l42_mag_overlay"
	max_rounds = 25
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM
	ammo_band_icon = "+l42mk1_band"
	ammo_band_icon_empty = "+l42mk1_band_e"

/obj/item/ammo_magazine/rifle/l42a/ap
	name = "L42A AP magazine (10x24mm)"
	desc = "A 10mm battle rifle armor piercing magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap)
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/l42a/le
	name = "L42A LE magazine (10x24mm)"
	desc = "A 10mm battle rifle armor shredding magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/le)
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/l42a/rubber
	name = "L42A rubber magazine (10x24mm)"
	ammo_preset = list(/datum/ammo/bullet/rifle/rubber)
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/l42a/heap
	name = "L42A HEAP (10x24mm)"
	desc = "A 10mm battle rifle high explosive armor piercing magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/heap)
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/l42a/penetrating
	name = "L42A wall-piercing magazine (10x24mm)"
	desc = "A 10mm battle rifle wall-piercing magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/penetrating)
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/l42a/cluster
	name = "L42A cluster magazine (10x24mm)"
	desc = "A 10mm battle rifle cluster magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/cluster)
	ammo_band_color = AMMO_BAND_COLOR_CLUSTER

/obj/item/ammo_magazine/rifle/l42a/toxin
	name = "L42A toxin magazine (10x24mm)"
	desc = "A 10mm battle rifle toxin magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap/toxin)
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/rifle/l42a/extended
	name = "L42A extended magazine (10x24mm)"
	desc = "A 10mm battle rifle extended magazine."
	icon_state = "l42mk1_extended"
	ammo_preset = list(/datum/ammo/bullet/rifle)
	bonus_overlay = "l42_ex_overlay"
	max_rounds = 35
	gun_type = /obj/item/weapon/gun/rifle/l42a

/obj/item/ammo_magazine/rifle/l42a/incendiary
	name = "L42A incendiary magazine (10x24mm)"
	desc = "A 10mm battle rifle incendiary magazine."
	ammo_preset = list(/datum/ammo/bullet/rifle/incendiary)
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/l42a
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/l42a/abr40
	name = "ABR-40 magazine (10x24mm)"
	desc = "An ABR-40 magazine loaded with full metal jacket ammunition, for use at the firing range or while hunting. Theoretically cross-compatible with an L42A battle rifle."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "abr40"
	bonus_overlay = "abr40_mag_overlay"
	max_rounds = 12
	w_class = SIZE_SMALL
	ammo_band_icon = "+abr40_band"
	ammo_band_icon_empty = "+abr40_band_e"

/obj/item/ammo_magazine/rifle/l42a/abr40/holo_target
	name = "ABR-40 holotargeting magazine (10x24mm)"
	desc = "An ABR-40 magazine loaded with holo-targeting ammunition, primarily utilized to highlight hunting targets for easier target capture. Theoretically cross-compatible with an L42A battle rifle."
	ammo_preset = list(/datum/ammo/bullet/rifle/holo_target/hunting)
	ammo_band_color = AMMO_BAND_COLOR_HOLOTARGETING

/obj/item/ammo_magazine/rifle/l42a/extended/mixed
	name = "L42A extended mixed magazine (10x24mm)"
	desc = "A 10mm battle rifle mixed extended magazine"
	ammo_band_color = AMMO_BAND_COLOR_MIXED

/obj/item/ammo_magazine/rifle/l42a/extended/mixed/ea_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap)

/obj/item/ammo_magazine/rifle/l42a/extended/mixed/eai_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap, /datum/ammo/bullet/rifle/incendiary)

/obj/item/ammo_magazine/rifle/l42a/extended/mixed/eaictp_mixed
	ammo_preset = list(/datum/ammo/bullet/rifle, /datum/ammo/bullet/rifle/ap, /datum/ammo/bullet/rifle/incendiary, /datum/ammo/bullet/rifle/ap/cluster, /datum/ammo/bullet/rifle/ap/toxin, /datum/ammo/bullet/rifle/ap/penetrating)

//-------------------------------------------------------
// NSG 23 ASSAULT RIFLE - PMC PRIMARY RIFLE

/obj/item/ammo_magazine/rifle/nsg23
	name = "NSG 23 magazine"
	desc = "An NSG 23 assault rifle magazine."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/wy.dmi'
	icon_state = "nsg23"
	item_state = "nsg23"
	bonus_overlay = "nsg23_mag_overlay" //needs to be an overlay, as the mag has a hole that would be filled over by the ext overlay
	max_rounds = 30
	gun_type = /obj/item/weapon/gun/rifle/nsg23
	ammo_band_icon = "+nsg23_band"
	ammo_band_icon_empty = "+nsg23_band_e"

/obj/item/ammo_magazine/rifle/nsg23/extended
	name = "NSG 23 extended magazine"
	desc = "An NSG 23 assault rifle magazine. This one contains 45 bullets."
	icon_state = "nsg23_ext"
	item_state = "nsg23_ext"
	bonus_overlay = "nsg23_ext_overlay"
	max_rounds = 45

/obj/item/ammo_magazine/rifle/nsg23/ap
	name = "NSG 23 armor-piercing magazine"
	desc = "An NSG 23 assault rifle magazine. This one is armor piercing."
	ammo_preset = list(/datum/ammo/bullet/rifle/ap)
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/nsg23/heap
	name = "NSG 23 HEAP magazine (10x24mm)"
	desc = "An NSG 23 assault rifle magazine. This one is loaded with armor-piercing explosive tipped rounds."
	ammo_preset = list(/datum/ammo/bullet/rifle/heap)
	ammo_band_color = AMMO_BAND_COLOR_HEAP

//--------------------------------------------------------
//Bolt action rifle ammo

/obj/item/ammo_magazine/rifle/boltaction
	name = "Basira-Armstrong magazine (6.5mm)"
	desc = "A magazine for the Basira-Armstrong hunting rifle. Compliant with the 15-cartridge limit on civilian hunting rifles."
	caliber = CALIBER_6_5MM
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "hunting"
	ammo_preset = list(/datum/ammo/bullet/sniper/crude)
	max_rounds = 10
	gun_type = /obj/item/weapon/gun/boltaction
	w_class = SIZE_SMALL
