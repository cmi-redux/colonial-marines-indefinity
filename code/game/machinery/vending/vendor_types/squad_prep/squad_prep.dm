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


/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/training //Nonlethal stuff for events.
	name = "ColMarTech Automated Training Weapons Rack"
	desc = "An automated weapon rack hooked up to a big storage of standard-issue weapons and non-lethal ammunition."

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/training/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M4RA Battle Rifle", round(scale * 10), /obj/item/weapon/gun/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M37A2 Pump Shotgun", round(scale * 15), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 Submachine Gun", round(scale * 30), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", round(scale * 30), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("PRIMARY NONLETHAL AMMUNITION", -1, null, null),
		list("Box of Beanbag Shells (12g)", round(scale * 15), /obj/item/ammo_magazine/shotgun/beanbag, VENDOR_ITEM_REGULAR),
		list("M4RA Rubber Magazine (10x24mm)", round(scale * 15), /obj/item/ammo_magazine/rifle/m4ra/rubber, VENDOR_ITEM_REGULAR),
		list("M39 Rubber Magazine (10x20mm)", round(scale * 25), /obj/item/ammo_magazine/smg/m39/rubber, VENDOR_ITEM_REGULAR),
		list("M41A Rubber Magazine (10x24mm)", round(scale * 25), /obj/item/ammo_magazine/rifle/rubber, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", round(scale * 25), /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", round(scale * 25), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),

		list("SIDEARM NONLETHAL AMMUNITION", -1, null, null),
		list("88M4 Rubber Magazine (9mm)", round(scale * 25), /obj/item/ammo_magazine/pistol/mod88/rubber, VENDOR_ITEM_REGULAR),
		list("M4A3 Rubber Magazine (9mm)", round(scale * 25), /obj/item/ammo_magazine/pistol/rubber, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", -1, null, null),
		list("Rail Flashlight", round(scale * 25), /obj/item/attachable/flashlight, VENDOR_ITEM_RECOMMENDED),
		list("Underbarrel Flashlight Grip", round(scale * 10), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_RECOMMENDED),
		list("Underslung Grenade Launcher", round(scale * 25), /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR), //They already get these as on-spawns, might as well formalize some spares.

		list("UTILITIES", -1, null, null),
		list("M07 Training Grenade", round(scale * 15), /obj/item/explosive/grenade/high_explosive/training, VENDOR_ITEM_REGULAR),
		list("M15 Rubber Pellet Grenade", round(scale * 10), /obj/item/explosive/grenade/high_explosive/m15/rubber, VENDOR_ITEM_REGULAR),
		list("M5 Bayonet", round(scale * 25), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", round(scale * 10), /obj/item/storage/box/m94, VENDOR_ITEM_RECOMMENDED)
	)

//------------SQUAD MARINE UNIFORM AND GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_marine, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, VENDOR_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Uniform", 0, /obj/item/clothing/under/marine, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, VENDOR_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/light, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Medium Armor", 0, /obj/item/clothing/suit/storage/marine/medium, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Heavy Armor", 0, /obj/item/clothing/suit/storage/marine/heavy, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Backpack", 0, /obj/item/storage/backpack/marine, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Shotgun Scabbard", 0, /obj/item/storage/large_holster/m37, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig (Full)", 0, /obj/item/storage/belt/knifepouch, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig (Empty)", 0, /obj/item/storage/belt/grenade, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Small Document Pouch", 0, /obj/item/storage/pouch/document/small, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (VENDOR_CAN_BUY_R_POUCH|VENDOR_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", 0, null, null, null),
		list("VP78 Pistol", 15, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smart Pistol", 15, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),
		list("MOU-53 Shotgun", 30, /obj/item/storage/box/guncase/mou53, null, VENDOR_ITEM_REGULAR),
		list("M41AE2 Heavy Pulse Rifle", 30, /obj/item/storage/box/guncase/lmg, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("M40 HEDP High Explosive Packet (x3 grenades)", 20, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Packet (x3 grenades)", 20, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 HPDP White Phosphorus Packet (x3 grenades)", 20, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Packet (x3 grenades)", 10, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Packet (x3 airburst grenades)", 15, /obj/item/storage/box/packet/airburst_he, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Incendiary Airburst Packet (x3 airburst grenades)", 15, /obj/item/storage/box/packet/airburst_incen, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Smoke Airburst Packet (x3 airburst grenades)", 10, /obj/item/storage/box/packet/airburst_smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Hornet Airburst Packet (x3 airburst grenades", 15, /obj/item/storage/box/packet/hornet, null, VENDOR_ITEM_REGULAR),
		list("M20 Mine Box (x4 mines)", 20, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 15, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", 15, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_REGULAR),
		list("SensorMate Medical HUD", 15, /obj/item/clothing/glasses/hud/sensor, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("B12 Pattern Marine Armor", 30, /obj/item/clothing/suit/storage/marine/leader, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 15, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 15, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 15, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Data Detector", 15, /obj/item/device/motiondetector/intel, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),
		list("Powerloader Certification", 45, /obj/item/pamphlet/skill/powerloader, null, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 10, /obj/item/storage/pouch/shotgun/large, null, VENDOR_ITEM_REGULAR),

		list("EXTRA UTILITIES", 0, null, null, null),
		list("Armor Plate", 15, /obj/item/clothing/accessory/health/metal_plate, null, VENDOR_ITEM_MANDATORY),
		list("Armor Ceramic Plate", 15, /obj/item/clothing/accessory/health/ceramic_plate, null, VENDOR_ITEM_REGULAR),

		list("RADIO KEYS", 0, null, null, null),
		list("Engineering Radio Encryption Key", 5, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 5, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 5, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/clothing/marine
	name = "ColMarTech Automated Marine Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Marine Rifleman standard-issue equipment."
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM

	vendor_role = list(JOB_SQUAD_MARINE)

/obj/structure/machinery/cm_vending/clothing/marine/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_marine

/obj/structure/machinery/cm_vending/clothing/marine/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_ALPHA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha

/obj/structure/machinery/cm_vending/clothing/marine/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_BRAVO)
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo

/obj/structure/machinery/cm_vending/clothing/marine/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_CHARLIE)
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie

/obj/structure/machinery/cm_vending/clothing/marine/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_DELTA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta

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

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/alpha
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/alpha/populate_product_list(scale)
	listed_products = list(
		list("UNIFORM", -1, null, null),
		list("Lightweight IMP Backpack", 10, /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Ammo Load Rig", 10, /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern General Pistol Holster Rig", 10, /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig", 10, /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M44 Holster Rig", 10, /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 5, /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Shotgun Shell Loading Rig", 10, /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("Marine Alpha Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/alpha, VENDOR_ITEM_REGULAR),
		list("Marine Combat Gloves", 10, /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Marine Black Combat Gloves", 10, /obj/item/clothing/gloves/marine/black, VENDOR_ITEM_REGULAR),
		list("Marine Combat Boots", 20, /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", 5, /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", 10, /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM Uniform", 20, /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),

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

		list("MASKS", -1, null, null, null),
		list("Gas Mask", 20, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR)
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bravo
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_BRAVO, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bravo/populate_product_list(scale)
	listed_products = list(
		list("UNIFORM", -1, null, null),
		list("Lightweight IMP Backpack", 10, /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Ammo Load Rig", 10, /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern General Pistol Holster Rig", 10, /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig", 10, /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M44 Holster Rig", 10, /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 5, /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Shotgun Shell Loading Rig", 10, /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("Marine Bravo Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/bravo, VENDOR_ITEM_REGULAR),
		list("Marine Combat Gloves", 10, /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Marine Black Combat Gloves", 10, /obj/item/clothing/gloves/marine/black, VENDOR_ITEM_REGULAR),
		list("Marine Combat Boots", 20, /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", 5, /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", 10, /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM Uniform", 20, /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),

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

		list("MASKS", -1, null, null, null),
		list("Gas Mask", 20, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR)
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/charlie
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/charlie/populate_product_list(scale)
	listed_products = list(
		list("UNIFORM", -1, null, null),
		list("Lightweight IMP Backpack", 10, /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Ammo Load Rig", 10, /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern General Pistol Holster Rig", 10, /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig", 10, /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M44 Holster Rig", 10, /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 5, /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Shotgun Shell Loading Rig", 10, /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("Marine Charlie Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/charlie, VENDOR_ITEM_REGULAR),
		list("Marine Combat Gloves", 10, /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Marine Black Combat Gloves", 10, /obj/item/clothing/gloves/marine/black, VENDOR_ITEM_REGULAR),
		list("Marine Combat Boots", 20, /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", 5, /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", 10, /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM Uniform", 20, /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),

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

		list("MASKS", -1, null, null, null),
		list("Gas Mask", 20, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR)
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/delta
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DELTA, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/delta/populate_product_list(scale)
	listed_products = list(
		list("UNIFORM", -1, null, null),
		list("Lightweight IMP Backpack", 10, /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Ammo Load Rig", 10, /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern General Pistol Holster Rig", 10, /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig", 10, /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M44 Holster Rig", 10, /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 5, /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Shotgun Shell Loading Rig", 10, /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig", 5, /obj/item/storage/belt/knifepouch, VENDOR_ITEM_REGULAR),
		list("Marine Delta Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/delta, VENDOR_ITEM_REGULAR),
		list("Marine Combat Gloves", 10, /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Marine Black Combat Gloves", 10, /obj/item/clothing/gloves/marine/black, VENDOR_ITEM_REGULAR),
		list("Marine Combat Boots", 20, /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", 5, /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", 10, /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM Uniform", 20, /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),

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

		list("MASKS", -1, null, null, null),
		list("Gas Mask", 20, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR)
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
