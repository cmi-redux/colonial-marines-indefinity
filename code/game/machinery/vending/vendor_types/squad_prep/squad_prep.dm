//------------SQUAD PREP VENDORS -------------------

//------------SQUAD PREP WEAPON RACKS---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep
	name = "ColMarTech Automated Weapons Rack"
	desc = "An automated weapon rack hooked up to a big storage of standard-issue weapons."
	icon_state = "guns"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_PREP, ACCESS_MARINE_CARGO)
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M4RA Battle Rifle", round(scale * 10), /obj/item/weapon/gun/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M37A2 Pump Shotgun", round(scale * 15), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 Submachine Gun", round(scale * 30), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", round(scale * 30), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", round(scale * 25), /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", round(scale * 25), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", round(scale * 25), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F Flare Gun", round(scale * 10), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", -1, null, null),
		list("M39 Folding Stock", round(scale * 10), /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("M41A Folding Stock", round(scale * 10), /obj/item/attachable/stock/rifle/collapsible, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", round(scale * 25), /obj/item/attachable/flashlight, VENDOR_ITEM_RECOMMENDED),
		list("Underbarrel Flashlight Grip", round(scale * 10), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_RECOMMENDED),
		list("Underslung Grenade Launcher", round(scale * 25), /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR), //They already get these as on-spawns, might as well formalize some spares.

		list("UTILITIES", -1, null, null),
		list("M5 Bayonet", round(scale * 25), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", round(scale * 10), /obj/item/storage/box/m94, VENDOR_ITEM_RECOMMENDED)
	)

//------------SQUAD PREP UNIFORM VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep
	name = "ColMarTech Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a small storage of standard marine uniforms."
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list()
	listed_products = list()
	hackable = TRUE

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/populate_product_list(scale)
	listed_products = list(
		list("UNIFORM & STORAGE", -1, null, null),
		list("Lightweight IMP Backpack", 10, /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("Marine Radio Headset", 10, /obj/item/device/radio/headset/almayer, VENDOR_ITEM_REGULAR),
		list("Marine Combat Gloves", 10, /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Marine Black Combat Gloves", 10, /obj/item/clothing/gloves/marine/black, VENDOR_ITEM_REGULAR),
		list("Marine Combat Boots", 20, /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", 5, /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", 10, /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM Technical Satchel", 10, /obj/item/storage/backpack/marine/satchel/tech, VENDOR_ITEM_REGULAR),
		list("USCM Uniform", 20, /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),

		list("BELTS", -1, null, null),
		list("M276 Pattern Ammo Load Rig", 10, /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M40 Grenade Rig", 8, /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Shotgun Shell Loading Rig", 10, /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 Pattern General Pistol Holster Rig", 10, /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig", 10, /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M44 Holster Rig", 10, /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M82F Holster Rig", 5, /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),

		list("ARMOR", -1, null, null),
		list("M10 Pattern Marine Helmet", 20, /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Carrier Marine Armor", 20, /obj/item/clothing/suit/storage/marine/carrier, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Padded Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padded, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Padless Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Ridged Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless_lines, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Skull Marine Armor", 20, /obj/item/clothing/suit/storage/marine/skull, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Smooth Marine Armor", 20, /obj/item/clothing/suit/storage/marine/smooth, VENDOR_ITEM_REGULAR),
		list("M3-EOD Pattern Heavy Armor", 10, /obj/item/clothing/suit/storage/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L Pattern Light Armor", 10, /obj/item/clothing/suit/storage/marine/light, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null, null),
		list("Gas Mask", 20, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),
		list("M5 Integrated Gas Mask", 10, /obj/item/prop/helmetgarb/helmet_gasmask, VENDOR_ITEM_REGULAR),
		list("M10 Helmet Netting", 10, /obj/item/prop/helmetgarb/netting, VENDOR_ITEM_REGULAR),
		list("M10 Helmet Rain Cover", 10, /obj/item/prop/helmetgarb/raincover, VENDOR_ITEM_REGULAR),
		list("Firearm Lubricant", 20, /obj/item/prop/helmetgarb/gunoil, VENDOR_ITEM_REGULAR),
		list("USCM Flair", 20, /obj/item/prop/helmetgarb/flair_uscm, VENDOR_ITEM_REGULAR)
		)

//--------------SQUAD SPECIFIC VERSIONS--------------
//Those vendors aren't being used i will make them us the main vendor a parent to avoid having four different
// list with just the headset changed.

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/alpha
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/alpha/populate_product_list(scale)
	listed_products += list(
		list("HEADSET", -1, null, null),
		list("Marine Alpha Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/alpha, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bravo
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_BRAVO, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bravo/populate_product_list(scale)
	listed_products += list(
		list("HEADSET", -1, null, null),
		list("Marine Bravo Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/bravo, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/charlie
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/charlie/populate_product_list(scale)
	listed_products += list(
		list("HEADSET", -1, null, null),
		list("Marine Charlie Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/charlie, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/delta
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DELTA, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/delta/populate_product_list(scale)
	listed_products += list(
		list("HEADSET", -1, null, null),
		list("Marine Delta Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/delta, VENDOR_ITEM_REGULAR),
		)

//------------SQUAD AMMUNITION VENDOR---------------

/obj/structure/machinery/cm_vending/ammo/squad_prep
	show_points = TRUE
	req_access = list()

/obj/structure/machinery/cm_vending/ammo/squad_prep/get_listed_products(mob/user)
	var/special_ammo_cmod = GLOB.objective_controller[faction?.faction_name].current_level * 0.6
	var/listed_products_list = list(
		list("BASE AMMUNITION", 0, null, null, null),
		list("M41A MK2 Magazine", 8, /obj/item/ammo_magazine/rifle, null, VENDOR_ITEM_MANDATORY),
		list("M41A MK2 extended Magazine", 12, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M41A MK2 AP Magazine", 18, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK1 Magazine", 14, /obj/item/ammo_magazine/rifle/m41aMK1, null, VENDOR_ITEM_MANDATORY),
		list("M41A MK1 AP Magazine", 26, /obj/item/ammo_magazine/rifle/m41aMK1/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("M41AE2 ammo box", 20, /obj/item/ammo_magazine/rifle/lmg, null, VENDOR_ITEM_RECOMMENDED),
		list("M4RA Magazine", 7, /obj/item/ammo_magazine/rifle/m4ra, null, VENDOR_ITEM_MANDATORY),
		list("M4RA extended Magazine", 11, /obj/item/ammo_magazine/rifle/m4ra/ext, null, VENDOR_ITEM_REGULAR),
		list("M4RA AP Magazine", 14, /obj/item/ammo_magazine/rifle/m4ra/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("M39 HV Magazine", 6, /obj/item/ammo_magazine/smg/m39, null, VENDOR_ITEM_MANDATORY),
		list("M39 HV extended Magazine", 9, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine", 13, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("Box of Buckshot Shells (12g)", 10, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
		list("Box of Flechette Shells (12g)", 10, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),
		list("Box of Shotgun Slugs (12g)", 10, /obj/item/ammo_magazine/shotgun/slugs, null, VENDOR_ITEM_REGULAR),
		list("M4A3 Magazine", 3, /obj/item/ammo_magazine/pistol, null, VENDOR_ITEM_MANDATORY),
		list("M4A3 HP Magazine", 4, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine", 6, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("VP78 Magazine", 4, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_MANDATORY),
		list("88M4 AP Magazine", 7, /obj/item/ammo_magazine/pistol/mod88, null, VENDOR_ITEM_RECOMMENDED),
		list("M44 Speedloader", 6, /obj/item/ammo_magazine/revolver, null, VENDOR_ITEM_MANDATORY),
		list("M44 Marksman Speedloader", 8, /obj/item/ammo_magazine/revolver/marksman, null, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speedloader", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("M41A MK2 Incendiary Magazine", 18 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M41A MK2 LE Magazine", 48 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/le, null, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Explosive Magazine", 48 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/explosive, null, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Wall-Piercing Magazine", 24 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/penetrating, null, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Cluster Magazine", 21 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/cluster, null, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Toxin Magazine", 23 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/toxin, null, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Incendiary Magazine", 26 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m41aMK1/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Wall-Piercing Magazine", 33 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m41aMK1/penetrating, null, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Cluster Magazine", 30 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m41aMK1/cluster, null, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Toxin Magazine", 32 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m41aMK1/toxin, null, VENDOR_ITEM_REGULAR),
		list("M41AE2 Holo Target Rounds", 16, /obj/item/ammo_magazine/rifle/lmg/holo_target, null, VENDOR_ITEM_REGULAR),
		list("M4RA Incendiary Magazine", 14 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m4ra/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M4RA LE Magazine", 38 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m4ra/le, null, VENDOR_ITEM_REGULAR),
		list("M4RA Wall-Piercing Magazine", 19 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m4ra/penetrating, null, VENDOR_ITEM_REGULAR),
		list("M4RA Cluster Magazine", 16 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m4ra/cluster, null, VENDOR_ITEM_REGULAR),
		list("M4RA Toxin Magazine", 18 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m4ra/toxin, null, VENDOR_ITEM_REGULAR),
		list("M39 Incendiary Magazine", 13 * special_ammo_cmod, /obj/item/ammo_magazine/smg/m39/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M39 LE Magazine", 32 * special_ammo_cmod, /obj/item/ammo_magazine/smg/m39/le, null, VENDOR_ITEM_REGULAR),
		list("M39 Wall-Piercing Magazine", 17 * special_ammo_cmod, /obj/item/ammo_magazine/smg/m39/penetrating, null, VENDOR_ITEM_REGULAR),
		list("M39 Cluster Magazine", 14 * special_ammo_cmod, /obj/item/ammo_magazine/smg/m39/cluster, null, VENDOR_ITEM_REGULAR),
		list("M39 Toxin Magazine", 16 * special_ammo_cmod, /obj/item/ammo_magazine/smg/m39/toxin, null, VENDOR_ITEM_REGULAR),
		list("Box of Incendiary Shotgun Slugs (12g)", 20 * special_ammo_cmod, /obj/item/ammo_magazine/shotgun/incendiary, null, VENDOR_ITEM_REGULAR),
		list("Box of Incendiary Buckshot Shells (12g)", 20 * special_ammo_cmod, /obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M4A3 Incendiary Magazine", 6 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M4A3 Wall-Piercing Magazine", 9 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/penetrating, null, VENDOR_ITEM_REGULAR),
		list("M4A3 Cluster Magazine", 7 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/cluster, null, VENDOR_ITEM_REGULAR),
		list("M4A3 Toxin Magazine", 8 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/toxin, null, VENDOR_ITEM_REGULAR),
		list("VP78 Incendiary Magazine", 4 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/vp78/incendiary, null, VENDOR_ITEM_REGULAR),
		list("VP78 Wall-Piercing Magazine", 7 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/vp78/penetrating, null, VENDOR_ITEM_REGULAR),
		list("VP78 Cluster Magazine", 5 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/vp78/cluster, null, VENDOR_ITEM_REGULAR),
		list("VP78 Toxin Magazine", 6 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/vp78/toxin, null, VENDOR_ITEM_REGULAR),
		list("88M4 Incendiary Magazine", 7 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/mod88/incendiary, null, VENDOR_ITEM_REGULAR),
		list("88M4 Wall-Piercing Magazine", 11 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/mod88/penetrating, null, VENDOR_ITEM_REGULAR),
		list("88M4 Cluster Magazine", 9 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/mod88/cluster, null, VENDOR_ITEM_REGULAR),
		list("88M4 Toxin Magazine", 10 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/mod88/toxin, null, VENDOR_ITEM_REGULAR),
		list("M44 Incendiary Speedloader", 10 * special_ammo_cmod, /obj/item/ammo_magazine/revolver/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M44 Wall-Piercing Speedloader", 14 * special_ammo_cmod, /obj/item/ammo_magazine/revolver/penetrating, null, VENDOR_ITEM_REGULAR),
		list("M44 Cluster Speedloader", 12 * special_ammo_cmod, /obj/item/ammo_magazine/revolver/cluster, null, VENDOR_ITEM_REGULAR),
		list("M44 Toxic Speedloader", 13 * special_ammo_cmod, /obj/item/ammo_magazine/revolver/toxin, null, VENDOR_ITEM_REGULAR),

		list("MIXED AMMUNITION", 0, null, null, null),
		list("M41A MK2 Mixed E-A Magazine", 14 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/extended/mixed/ea_mixed, null, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Mixed E-A-I Magazine", 21 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/extended/mixed/eai_mixed, null, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Mixed E-A-I-C-T-P Magazine", 25 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/extended/mixed/eaictp_mixed, null, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Mixed E-A Magazine", 18, /obj/item/ammo_magazine/rifle/m41aMK1/mixed/ea_mixed, null, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Mixed E-A-I Magazine", 24 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m41aMK1/mixed/eai_mixed, null, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Mixed E-A-I-C-T-P Magazine", 30 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m41aMK1/mixed/eaictp_mixed, null, VENDOR_ITEM_REGULAR),
		list("M4RA Mixed E-A Magazine", 12, /obj/item/ammo_magazine/rifle/m4ra/ext/mixed/ea_mixed, null, VENDOR_ITEM_REGULAR),
		list("M4RA Mixed E-A-I Magazine", 15 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m4ra/ext/mixed/eai_mixed, null, VENDOR_ITEM_REGULAR),
		list("M4RA Mixed E-A-I-C-T-P Magazine", 20 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/m4ra/ext/mixed/eaictp_mixed, null, VENDOR_ITEM_REGULAR),
		list("M39 Mixed E-A Magazine", 10, /obj/item/ammo_magazine/smg/m39/extended/mixed/ea_mixed, null, VENDOR_ITEM_REGULAR),
		list("M39 Mixed E-A-I Magazine", 12 * special_ammo_cmod, /obj/item/ammo_magazine/smg/m39/extended/mixed/eai_mixed, null, VENDOR_ITEM_REGULAR),
		list("M39 Mixed E-A-I-C-T-P Magazine", 15 * special_ammo_cmod, /obj/item/ammo_magazine/smg/m39/extended/mixed/eaictp_mixed, null, VENDOR_ITEM_REGULAR)
	)
	return listed_products_list

/obj/structure/machinery/cm_vending/ammo/squad_prep/upp
	name = "UPP Automated Ammo Rack"
	faction_to_get = FACTION_UPP

/obj/structure/machinery/cm_vending/ammo/squad_prep/upp/get_listed_products(mob/user)
	var/special_ammo_cmod = 4
	if(GLOB.objective_controller[faction?.faction_name].current_level < 4)
		special_ammo_cmod = 1
	var/listed_products_list = list(
		list("BASE AMMUNITION", 0, null, null, null),
		list("Type 71 magazine", 22, /obj/item/ammo_magazine/rifle/type71, null, VENDOR_ITEM_REGULAR),
		list("Type 71 AP magazine", 29, /obj/item/ammo_magazine/rifle/type71/ap, null, VENDOR_ITEM_REGULAR),
		list("PPSh-17b stick magazine", 15, /obj/item/ammo_magazine/smg/ppsh, null, VENDOR_ITEM_REGULAR),
		list("PPSh-17b drum magazine", 30, /obj/item/ammo_magazine/smg/ppsh/extended, null, VENDOR_ITEM_REGULAR),
		list("M60 ammo box", 42, /obj/item/ammo_magazine/m60, null, VENDOR_ITEM_REGULAR),
		list("rotating ammo drum", 48, /obj/item/ammo_magazine/minigun, null, VENDOR_ITEM_REGULAR),
		list("handful of heavy buckshot shells", 20, /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot, null, VENDOR_ITEM_REGULAR),
		list("handful of heavy flechette shells", 20, /obj/item/ammo_magazine/handful/shotgun/heavy/flechette, null, VENDOR_ITEM_REGULAR),
		list("handful of heavy shotgun slugs", 20, /obj/item/ammo_magazine/handful/shotgun/heavy/slug, null, VENDOR_ITEM_REGULAR),
		list("PK-9 magazine", 8, /obj/item/ammo_magazine/pistol/c99, null, VENDOR_ITEM_REGULAR),
		list("CZ-81 20-round magazine", 16, /obj/item/ammo_magazine/pistol/skorpion, null, VENDOR_ITEM_REGULAR),
		list("N-Y speed loader", 13, /obj/item/ammo_magazine/revolver/upp, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 HEAP magazine", 50 * special_ammo_cmod, /obj/item/ammo_magazine/rifle/type71/heap, null, VENDOR_ITEM_REGULAR),
		list("handful of dragon's breath shells", 30 * special_ammo_cmod, /obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath, null, VENDOR_ITEM_REGULAR),
		list("PK-9 tranquilizer magazine", 45 * special_ammo_cmod, /obj/item/ammo_magazine/pistol/c99/tranq, null, VENDOR_ITEM_REGULAR),
		list("N-Y shrapnel-shot speed loader", 45 * special_ammo_cmod, /obj/item/ammo_magazine/revolver/upp/shrapnel, null, VENDOR_ITEM_REGULAR),

		list("MIXED AMMUNITION", 0, null, null, null),
		list("Coder message from bunker, help me, Mr Texan holding me in and don't feeding, I'm hungry and wanna escape, help meeeee! I had chance to send that message to you fellow marines...", 0, null, null, null),
	)
	return listed_products_list

//--------------SQUAD MUNITION VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad
	name = "\improper ColMarTech Automated Munition Squad Vendor"
	desc = "An automated supply rack hooked up to a small storage of various ammunition types. Can be accessed by any Marine Rifleman."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

	vend_x_offset = 2

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state


/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad/populate_product_list(scale)
	listed_products = list(

		list("ARMOR-PIERCING AMMUNITION", -1, null, null),
		list("M4RA AP Magazine (10x24mm)", round(scale * 3.5), /obj/item/ammo_magazine/rifle/m4ra/ap, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", round(scale * 3), /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine (10x24mm)", round(scale * 3), /obj/item/ammo_magazine/rifle/ap, VENDOR_ITEM_REGULAR),

		list("EXTENDED AMMUNITION", -1, null, null),
		list("M39 Extended Magazine (10x20mm)", round(scale * 1.8), /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Extended Magazine (10x20mm)", round(scale * 1.9), /obj/item/ammo_magazine/rifle/extended, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", -1, null, null),
		list("M56 Smartgun Drum", 1, /obj/item/ammo_magazine/smartgun, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", round(scale * 2), /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", round(scale * 2), /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARM AMMUNITION", -1, null, null),
		list("VP78 Magazine", round(scale * 5), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", round(scale * 5), /obj/item/ammo_magazine/pistol/smart, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank", round(scale * 3), /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		list("M41AE2 Box Magazine", round(scale * 3), /obj/item/ammo_magazine/rifle/lmg, VENDOR_ITEM_REGULAR),
		list("M56D Drum Magazine", round(scale * 2), /obj/item/ammo_magazine/m56d, VENDOR_ITEM_REGULAR),
		list("HIRR Baton Slugs", round(scale * 6), /obj/item/explosive/grenade/slug/baton, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S Star Shell", round(scale * 2), /obj/item/explosive/grenade/high_explosive/airburst/starshell, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S Hornet Shell", round(scale * 4), /obj/item/explosive/grenade/high_explosive/airburst/hornet_shell, VENDOR_ITEM_REGULAR),
		)

//--------------SQUAD ARMAMENTS VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad
	name = "\improper ColMarTech Automated Armaments Squad Vendor"
	desc = "An automated supply rack hooked up to a small storage of various firearms and explosives. Can be accessed by any Marine Rifleman."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE

	vend_x_offset = 2
	vend_y_offset = 1
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/populate_product_list(scale)
	listed_products = list(
		list("WEBBINGS", -1, null, null),
		list("Brown Webbing Vest", round(scale * 2), /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", round(scale * 1), /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("Webbing", round(scale * 3), /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", round(scale * 1), /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", round(scale * 1), /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("BACKPACKS", -1, null, null),
		list("Lightweight IMP Backpack", round(scale * 15), /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", round(scale * 5), /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("USCM Technician Welderpack", round(scale * 2), /obj/item/storage/backpack/marine/engineerpack, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", round(scale * 3), /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_ITEM_REGULAR),
		list("Radio Telephone Backpack", round(scale * 1), /obj/item/storage/backpack/marine/satchel/rto, VENDOR_ITEM_REGULAR),

		list("BELTS", -1, null, null),
		list("G8-A General Utility Pouch", round(scale * 2), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", round(scale * 10), /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", round(scale * 2), /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", round(scale * 5), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", round(scale * 2), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", round(scale * 3), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),

		list("POUCHES", -1, null, null),
		list("Construction Pouch", round(scale * 2), /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("Document Pouch", round(scale * 2), /obj/item/storage/pouch/document/small, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", round(scale * 2), /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Full)", round(scale * 5), /obj/item/storage/pouch/firstaid/full, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch (Empty)", round(scale * 4), /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("Flare Pouch", round(scale * 5), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", round(scale * 3), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", round(scale * 5), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Empty)", round(scale * 4), /obj/item/storage/pouch/medical, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", round(scale * 2), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", round(scale * 2), /obj/item/storage/pouch/medkit, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", round(scale *5), /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", round(scale * 15), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),
		list("Syringe Pouch", round(scale * 2), /obj/item/storage/pouch/syringe, VENDOR_ITEM_REGULAR),
		list("Tools Pouch", round(scale * 2), /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", round(scale * 2), /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Combat Flashlight", round(scale * 5), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool (ET)", round(scale * 2), /obj/item/tool/shovel/etool/folded, VENDOR_ITEM_REGULAR),
		list("Trench Shovel (TS)", round(scale * 1), /obj/item/tool/shovel/etool/trench, VENDOR_ITEM_REGULAR),
		list("M89-S Signal Flare Pack", round(scale * 1), /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", round(scale * 5), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("Binoculars", round(scale * 1), /obj/item/device/binoculars, VENDOR_ITEM_REGULAR),
		list("MB-6 Folding Barricades (x3)", round(scale * 2), /obj/item/stack/folding_barricade/three, VENDOR_ITEM_REGULAR),
		list("Spare PDT/L Battle Buddy Kit", round(scale * 3), /obj/item/storage/box/pdt_kit, VENDOR_ITEM_REGULAR),
		list("W-Y brand rechargeable mini-battery", round(scale * 2.5), /obj/item/cell/crap, VENDOR_ITEM_REGULAR)
		)

//--------------SQUAD ATTACHMENTS VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/attachments/squad
	name = "\improper Armat Systems Squad Attachments Vendor"
	desc = "An automated supply rack hooked up to a small storage of weapons attachments. Can be accessed by any Marine Rifleman."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE

	vend_y_offset = 1

/obj/structure/machinery/cm_vending/sorted/attachments/squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/attachments/squad/populate_product_list(scale)
	listed_products = list(
		list("BARREL", -1, null, null),
		list("Barrel Charger", round(scale * 0.9), /obj/item/attachable/heavy_barrel, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", round(scale * 2.5), /obj/item/attachable/extended_barrel, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", round(scale * 2.5), /obj/item/attachable/compensator, VENDOR_ITEM_REGULAR),
		list("Suppressor", round(scale * 2.5), /obj/item/attachable/suppressor, VENDOR_ITEM_REGULAR),

		list("RAIL", -1, null, null),
		list("B8 Smart-Scope", round(scale * 1.5), /obj/item/attachable/scope/mini_iff, VENDOR_ITEM_REGULAR),
		list("Magnetic Harness", round(scale * 4), /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", round(scale * 2), /obj/item/attachable/scope/mini, VENDOR_ITEM_REGULAR),
		list("S5 Red-Dot Sight", round(scale * 3), /obj/item/attachable/reddot, VENDOR_ITEM_REGULAR),
		list("S6 Reflex Sight", round(scale * 3), /obj/item/attachable/reflex, VENDOR_ITEM_REGULAR),
		list("S8 4x Telescopic Scope", round(scale * 2), /obj/item/attachable/scope, VENDOR_ITEM_REGULAR),

		list("UNDERBARREL", -1, null, null),
		list("Angled Grip", round(scale * 2.5), /obj/item/attachable/angledgrip, VENDOR_ITEM_REGULAR),
		list("Bipod", round(scale * 2.5), /obj/item/attachable/bipod, VENDOR_ITEM_REGULAR),
		list("Burst Fire Assembly", round(scale * 1.5), /obj/item/attachable/burstfire_assembly, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", round(scale * 1.5), /obj/item/attachable/gyro, VENDOR_ITEM_REGULAR),
		list("Laser Sight", round(scale * 3), /obj/item/attachable/lasersight, VENDOR_ITEM_REGULAR),
		list("Mini Flamethrower", round(scale * 1.5), /obj/item/attachable/attached_gun/flamer, VENDOR_ITEM_REGULAR),
		list("XM-VESG-1 Flamer Nozzle", round(scale * 1.5), /obj/item/attachable/attached_gun/flamer_nozzle, VENDOR_ITEM_REGULAR),
		list("U7 Underbarrel Shotgun", round(scale * 1.5), /obj/item/attachable/attached_gun/shotgun, VENDOR_ITEM_REGULAR),
		list("Underbarrel Extinguisher", round(scale * 1.5), /obj/item/attachable/attached_gun/extinguisher, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", round(scale * 3), /obj/item/attachable/verticalgrip, VENDOR_ITEM_REGULAR),

		list("STOCK", -1, null, null),
		list("M37 Wooden Stock", round(scale * 1.5), /obj/item/attachable/stock/shotgun, VENDOR_ITEM_REGULAR),
		list("M39 Arm Brace", round(scale * 1.5), /obj/item/attachable/stock/smg/collapsible/brace, VENDOR_ITEM_REGULAR),
		list("M39 Stock", round(scale * 1.5), /obj/item/attachable/stock/smg, VENDOR_ITEM_REGULAR),
		list("M41A Solid Stock", round(scale * 1.5), /obj/item/attachable/stock/rifle, VENDOR_ITEM_REGULAR),
		list("M44 Magnum Sharpshooter Stock", round(scale * 1.5), /obj/item/attachable/stock/revolver, VENDOR_ITEM_REGULAR)
		)

//------------ESSENTIAL SETS---------------
/obj/effect/essentials_set/random/uscm_light_armor
	spawned_gear_list = list(
		/obj/item/clothing/suit/storage/marine/light/padded,
		/obj/item/clothing/suit/storage/marine/light/padless,
		/obj/item/clothing/suit/storage/marine/light/padless_lines,
		/obj/item/clothing/suit/storage/marine/light/carrier,
		/obj/item/clothing/suit/storage/marine/light/skull,
		/obj/item/clothing/suit/storage/marine/light/smooth,
	)

/obj/effect/essentials_set/random/uscm_heavy_armor
	spawned_gear_list = list(
		/obj/item/clothing/suit/storage/marine/heavy/padded,
		/obj/item/clothing/suit/storage/marine/heavy/padless,
		/obj/item/clothing/suit/storage/marine/heavy/padless_lines,
		/obj/item/clothing/suit/storage/marine/heavy/carrier,
		/obj/item/clothing/suit/storage/marine/heavy/skull,
		/obj/item/clothing/suit/storage/marine/heavy/smooth,
	)
