
//external magazines

/obj/item/ammo_magazine/revolver
	name = "M44 speed loader (.44)"
	desc = "A revolver speed loader."
	ammo_preset = list(/datum/ammo/bullet/revolver)
	flags_equip_slot = NO_FLAGS
	caliber = CALIBER_44
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "m44"
	item_state = "generic_speedloader"
	w_class = SIZE_SMALL
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/m44
	transfer_delay = 0.1 SECONDS
	ammo_band_icon = "+m44_tip"
	ammo_band_icon_empty = "empty"

/obj/item/ammo_magazine/revolver/marksman
	name = "M44 marksman speed loader (.44)"
	ammo_preset = list(/datum/ammo/bullet/revolver/marksman)
	caliber = CALIBER_44
	ammo_band_color = REVOLVER_TIP_COLOR_MARKSMAN

/obj/item/ammo_magazine/revolver/heavy
	name = "M44 heavy speed loader (.44)"
	ammo_preset = list(/datum/ammo/bullet/revolver/heavy)
	caliber = CALIBER_44
	ammo_band_color = REVOLVER_TIP_COLOR_HEAVY

/obj/item/ammo_magazine/revolver/incendiary
	name = "M44 incendiary speed loader (.44)"
	ammo_preset = list(/datum/ammo/bullet/revolver/incendiary)
	ammo_band_color = REVOLVER_TIP_COLOR_INCENDIARY

/obj/item/ammo_magazine/revolver/toxin
	name = "M44 toxic speed loader (.44)"
	ammo_preset = list(/datum/ammo/bullet/revolver/marksman/toxin)
	ammo_band_color = REVOLVER_TIP_COLOR_TOXIN

/obj/item/ammo_magazine/revolver/penetrating
	name = "M44 wall-piercing speed loader (.44)"
	ammo_preset = list(/datum/ammo/bullet/revolver/penetrating)
	ammo_band_color = REVOLVER_TIP_COLOR_PENETRATING

/obj/item/ammo_magazine/revolver/cluster
	name = "M44 cluster speed loader (.44)"
	desc = "A revolver speed loader. Designed to attach tiny explosives to targets, to detonate all at once if enough hit."
	ammo_preset = list(/datum/ammo/bullet/revolver/cluster)
	ammo_band_color = AMMO_BAND_COLOR_CLUSTER

/obj/item/ammo_magazine/revolver/pkd
	name = "Plfager Katsuma stripper clip (.44)"
	desc = "Flip up the two side latches (three on PKL) and push after aligning with feed lips on blaster. Clip can be re-used."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "pkd_44"
	caliber = ".44 sabot"

/obj/item/ammo_magazine/revolver/upp
	name = "N-Y speed loader (7.62x38mmR)"
	ammo_preset = list(/datum/ammo/bullet/revolver/nagant)
	caliber = CALIBER_7_62X38MM
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "ny762"
	gun_type = /obj/item/weapon/gun/revolver/nagant

/obj/item/ammo_magazine/revolver/upp/shrapnel
	name = "N-Y shrapnel-shot speed loader (7.62x38mmR)"
	desc = "This speedloader contains seven 'shrapnel-shot' bullets, cheap recycled casings picked up off the ground and refilled with gunpowder and random scrap metal. Acts similarly to flechette."
	ammo_preset = list(/datum/ammo/bullet/revolver/nagant/shrapnel)
	icon_state = "ny762_shrapnel"

/obj/item/ammo_magazine/revolver/small
	name = "S&W speed loader (.357)"
	ammo_preset = list(/datum/ammo/bullet/revolver/small)
	caliber = CALIBER_357
	icon_state = "357"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "38"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/small

/obj/item/ammo_magazine/revolver/cmb
	name = "Spearhead hollowpoint speed loader (.357)"
	desc = "This speedloader was created for the Colonial Marshals' most commonly issued sidearm, loaded with hollowpoint rounds either for colonies with wildlife problems or orbital stations, which favor the lesser penetration over other ammunition to lessen the risk of hull breaches. In exchange, they're near useless against armored targets, but what's the chance of that being a problem on a space station?"
	ammo_preset = list(/datum/ammo/bullet/revolver/small/hollowpoint)
	caliber = CALIBER_357
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "cmb_hp"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/cmb

/obj/item/ammo_magazine/revolver/cmb/normalpoint //put these in the marshall ert
	name = "Spearhead speed loader (.357)"
	desc = "This speedloader is fitted with standard .357 revolver bullets. A surprising rarity, as most CMB revolvers are issued to Marshals on colonies with wildlife, or weakly-hulled space stations."
	ammo_preset = list(/datum/ammo/bullet/revolver/small)
	icon_state = "cmb"

/**
 * MATEBA REVOLVER
 */

/obj/item/ammo_magazine/revolver/mateba
	name = "Mateba speed loader (.454)"
	desc = "A formidable .454 speedloader, made exclusively for the Mateba autorevolver. Packs a devastating punch. This standard-variant is optimized for anti-armor."
	ammo_preset = list(/datum/ammo/bullet/revolver/mateba)
	caliber = CALIBER_454
	icon_state = "mateba"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/mateba

/obj/item/ammo_magazine/revolver/mateba/highimpact
	name = "High Impact Mateba speed loader (.454)"
	desc = "A formidable .454 speedloader, made exclusively for the Mateba autorevolver. Packs a devastating punch. This high impact variant is optimized for anti-personnel. Don't point at anything you don't want to destroy."
	ammo_preset = list(/datum/ammo/bullet/revolver/mateba/highimpact)
	ammo_band_color = REVOLVER_TIP_COLOR_HIGH_IMPACT

/obj/item/ammo_magazine/revolver/mateba/highimpact/ap
	name = "High Impact Armor-Piercing Mateba speed loader (.454)"
	desc = "A formidable .454 speedloader, made exclusively for the Mateba autorevolver. Packs a devastating punch. This armor-piercing variant is optimized against armored targets at the cost of lower overall damage. Don't point at anything you don't want to destroy."
	ammo_preset = list(/datum/ammo/bullet/revolver/mateba/highimpact/ap)
	ammo_band_color = REVOLVER_TIP_COLOR_AP

/obj/item/ammo_magazine/revolver/mateba/highimpact/explosive
	name = "Mateba explosive speed loader (.454)"
	desc = "A formidable .454 speedloader, made exclusively for the Mateba autorevolver. There's an impact charge built into the bullet tip. Firing this at anything will result in a powerful explosion. Use with EXTREME caution."
	icon_state = "mateba_explosive"
	ammo_preset = list(/datum/ammo/bullet/revolver/mateba/highimpact/explosive)
	ammo_band_color = REVOLVER_TIP_COLOR_EXPLOSIVE

/**
 * WEBLEY REVOLVER
*/

/obj/item/ammo_magazine/revolver/webley
	name = "Webley speed loader (.455)"
	desc = ".455 Webley, the last decent pistol calibre. Loaded with Mk III dum-dum bullets, because Marines are not human and the Hague Conventions do not apply to them."
	ammo_preset = list(/datum/ammo/bullet/revolver/webley)
	caliber = CALIBER_455
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "357"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/m44/custom/webley

//INTERNAL MAGAZINES

//---------------------------------------------------

/obj/item/ammo_magazine/internal/revolver
	name = "revolver cylinder"
	ammo_preset = list(/datum/ammo/bullet/revolver)
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver

//-------------------------------------------------------
//M44 MAGNUM REVOLVER //Not actually cannon, but close enough.

/obj/item/ammo_magazine/internal/revolver/m44
	caliber = CALIBER_44
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/m44

/obj/item/ammo_magazine/internal/revolver/m44/pkd
	max_rounds = 8
	caliber = ".44 sabot"

/obj/item/ammo_magazine/internal/revolver/m44/marksman
	ammo_preset = list(/datum/ammo/bullet/revolver/marksman)

//-------------------------------------------------------
//RUSSIAN REVOLVER //Based on the 7.62mm Russian revolvers.

/obj/item/ammo_magazine/internal/revolver/upp
	ammo_preset = list(/datum/ammo/bullet/revolver/nagant)
	caliber = CALIBER_7_62X38MM
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/nagant

/obj/item/ammo_magazine/internal/revolver/upp/shrapnel
	ammo_preset = list(/datum/ammo/bullet/revolver/nagant/shrapnel)


//-------------------------------------------------------
//357 REVOLVER //Based on the generic S&W 357.

/obj/item/ammo_magazine/internal/revolver/small
	ammo_preset = list(/datum/ammo/bullet/revolver/small)
	caliber = CALIBER_38
	gun_type = /obj/item/weapon/gun/revolver/small

//-------------------------------------------------------
//BURST REVOLVER //Mateba is pretty well known. The cylinder folds up instead of to the side.

/obj/item/ammo_magazine/internal/revolver/mateba
	ammo_preset = list(/datum/ammo/bullet/revolver)
	caliber = CALIBER_454
	gun_type = /obj/item/weapon/gun/revolver/mateba

/obj/item/ammo_magazine/internal/revolver/mateba/impact
	ammo_preset = list(/datum/ammo/bullet/revolver/mateba/highimpact)

/obj/item/ammo_magazine/internal/revolver/mateba/ap
	ammo_preset = list(/datum/ammo/bullet/revolver/mateba/highimpact/ap)

/obj/item/ammo_magazine/internal/revolver/mateba/explosive
	ammo_preset = list(/datum/ammo/bullet/revolver/mateba/highimpact/explosive)

//-------------------------------------------------------
//MARSHALS REVOLVER //Spearhead exists in Alien cannon.

/obj/item/ammo_magazine/internal/revolver/cmb
	ammo_preset = list(/datum/ammo/bullet/revolver/small)
	caliber = CALIBER_357
	gun_type = /obj/item/weapon/gun/revolver/cmb

/obj/item/ammo_magazine/internal/revolver/cmb/hollowpoint
	ammo_preset = list(/datum/ammo/bullet/revolver/small/hollowpoint)
	caliber = CALIBER_357
	gun_type = /obj/item/weapon/gun/revolver/cmb

//-------------------------------------------------------
//BIG GAME HUNTER'S REVOLVER
/obj/item/ammo_magazine/internal/revolver/webley
	caliber = CALIBER_455
	ammo_preset = list(/datum/ammo/bullet/revolver/webley)
	gun_type = /obj/item/weapon/gun/revolver/m44/custom/webley
