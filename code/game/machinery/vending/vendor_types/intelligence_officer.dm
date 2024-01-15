//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_intelligence_officer, list(
		list("INTELLIGENCE SET (MANDATORY)", 0, null, null, null),
		list("Essential Intelligence Set", 0, /obj/effect/essentials_set/intelligence_officer, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("SUPPLIES", 0, null, null, null),
		list("Power Control Module", 5, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("M2 Night Vision Goggles", 25, /obj/item/prop/helmetgarb/helmet_nvg, null, VENDOR_ITEM_RECOMMENDED),
		list("Data Detector", 5, /obj/item/device/motiondetector/intel, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Fulton Recovery Device", 10, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED),
		list("Plastic Explosive", 10, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),
		list("Medical Helmet Optic", 5, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("ARMORS", 0, null, null, null),
		list("M3 B12 Pattern Marine Armor", 20, /obj/item/clothing/suit/storage/marine/leader, null, VENDOR_ITEM_REGULAR),
		list("M4 Pattern Armor", 20, /obj/item/clothing/suit/storage/marine/rto, null, VENDOR_ITEM_REGULAR),

		list("CLOTHING ITEMS", 0, null, null, null),
		list("USCM logistics IMP backpack", 20, /obj/item/storage/backpack/marine/satchel/big, null, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 6, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 8, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("USCM Radio Telephone Pack", 15, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 4, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 3, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 6, /obj/item/storage/pouch/sling, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 6, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 6, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 6, /obj/item/storage/pouch/shotgun/large, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch (Full)", 15, /obj/item/storage/pouch/autoinjector/full, null, VENDOR_ITEM_RECOMMENDED),
		list("M276 Pattern Combat Toolbelt Rig", 15, /obj/item/storage/belt/gun/utility, null, VENDOR_ITEM_REGULAR),
		list("M2 Night Vision Goggles", 30, /obj/item/prop/helmetgarb/helmet_nvg, null, VENDOR_ITEM_RECOMMENDED),

		list("EXTRA UTILITIES", 0, null, null, null),
		list("Armor Plate", 15, /obj/item/clothing/accessory/health/metal_plate, null, VENDOR_ITEM_MANDATORY),
		list("Armor Ceramic Plate", 15, /obj/item/clothing/accessory/health/ceramic_plate, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Medical Helmet Optic", 15, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/intelligence_officer
	name = "ColMarTech Intelligence Officer Gear Rack"
	desc = "An automated gear rack for IOs."
	icon_state = "intel_gear"
	req_access = list(ACCESS_MARINE_COMMAND)
	vendor_role = list(JOB_INTEL)

/obj/structure/machinery/cm_vending/gear/intelligence_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_intelligence_officer

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_intelligence_officer, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/insulated, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/mre, VENDOR_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("XM4 Pattern Intel Armor", 0, /obj/item/clothing/suit/storage/marine/intel, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Service Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/service, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Expedition Pack", 0, /obj/item/storage/backpack/marine/satchel/intel, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Radio Telephone Pack", 0, /obj/item/storage/backpack/marine/satchel/rto/io, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("XM12 Officer Helmet", 0, /obj/item/clothing/head/helmet/marine/intel, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Beret, Standard", 0, /obj/item/clothing/head/beret/cm, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Beret, Tan", 0, /obj/item/clothing/head/beret/cm/tan, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("USCM Officer Cap", 0, /obj/item/clothing/head/cmcap/ro, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Document Pouch", 0, /obj/item/storage/pouch/document, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pills)", 0, /obj/item/storage/pouch/firstaid/pills/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

//VENDOR_CAN_BUY_SHOES VENDOR_CAN_BUY_UNIFORM currently not used
/obj/structure/machinery/cm_vending/clothing/intelligence_officer
	name = "ColMarTech Intelligence Officer Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of IO standard-issue equipment."
	req_access = list(ACCESS_MARINE_COMMAND)
	vendor_role = list(JOB_INTEL)

/obj/structure/machinery/cm_vending/clothing/intelligence_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_intelligence_officer

//------------GUNS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/intelligence_officer
	name = "\improper ColMarTech Intelligence Officer Weapons Rack"
	desc = "An automated weapon rack hooked up to a small storage of standard-issue weapons. Can be accessed only by the Intelligence Officers."
	icon_state = "guns"
	req_access = list(ACCESS_MARINE_COMMAND)
	vendor_role = list(JOB_INTEL)
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/intelligence_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_guns_intelligence_officer

GLOBAL_LIST_INIT(cm_vending_guns_intelligence_officer, list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M4RA Battle Rifle", 4, /obj/item/weapon/gun/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M39 Submachine Gun", 4, /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M37A2 Pump Shotgun", 4, /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", 4, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", 4, /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", 4, /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", 4, /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", -1, null, null),
		list("Rail Flashlight", 8, /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flashlight Grip", 4, /obj/item/attachable/flashlight/grip, VENDOR_ITEM_RECOMMENDED),

		list("UTILITIES", -1, null, null),
		list("M11 Throwing Knife", 18, /obj/item/weapon/throwing_knife, VENDOR_ITEM_REGULAR),
		list("M5 Bayonet", 4, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M89-S Signal Flare Pack", 2, /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare pack", 20, /obj/item/storage/box/m94, VENDOR_ITEM_RECOMMENDED)
	))

//------------ESSENTIAL SETS---------------

/obj/effect/essentials_set/intelligence_officer
	spawned_gear_list = list(
		/obj/item/tool/crowbar,
		/obj/item/stack/fulton,
		/obj/item/device/motiondetector/intel,
		/obj/item/device/binoculars,
	)
