//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_commanding_officer, list(
		list("CAPTAIN'S PRIMARY (CHOOSE 1)", 0, null, null, null),
		list("M46C pulse rifle", 0, /obj/effect/essentials_set/co/riflepreset, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("M56C Smartgun", 0, /obj/item/storage/box/m56c_system, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M41A MK1 Magazine", 30, /obj/item/ammo_magazine/rifle/m41aMK1, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK1 AP Magazine", 40, /obj/item/ammo_magazine/rifle/m41aMK1/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK2 Extended Magazine", 20, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M41A MK2 AP Magazine", 20, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M56B Smartgun Drum", 20, /obj/item/ammo_magazine/smartgun, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("High Impact Mateba Speedloader (.454)", 15, /obj/item/ammo_magazine/revolver/mateba/highimpact, null, VENDOR_ITEM_RECOMMENDED),
		list("High Impact AP Mateba Speedloader (.454)", 20, /obj/item/ammo_magazine/revolver/mateba/highimpact/ap, null, VENDOR_ITEM_REGULAR),
		list("High Impact Desert Eagle Magazine (.50)", 15, /obj/item/ammo_magazine/pistol/heavy/super/highimpact, null, VENDOR_ITEM_RECOMMENDED),
		list("High Impact AP Desert Eagle Magazine (.50)", 20, /obj/item/ammo_magazine/pistol/heavy/super/highimpact/ap, null, VENDOR_ITEM_REGULAR),

		list("RAIL ATTACHMENTS", 0, null, null, null),
		list("Red-Dot Sight", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", 15, /obj/item/attachable/scope/mini, null, VENDOR_ITEM_REGULAR),

		list("UNDERBARREL ATTACHMENTS", 0, null, null, null),
		list("Laser Sight", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Angled Grip", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Shotgun", 15, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Extinguisher", 15, /obj/item/attachable/attached_gun/extinguisher, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flamethrower", 15, /obj/item/attachable/attached_gun/flamer, null, VENDOR_ITEM_REGULAR),

		list("BARREL ATTACHMENTS", 0, null, null, null),
		list("Barrel Charger", 25, /obj/item/attachable/heavy_barrel, null, VENDOR_ITEM_RECOMMENDED),
		list("Suppressor", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 15, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/gear/commanding_officer
	name = "\improper ColMarTech Commanding Officer Weapon Rack"
	desc = "An automated weapons rack for the Commanding Officer. It features a robust selection of weaponry meant only for the USCM's top officers."
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_CO, JOB_WO_CO)
	icon_state = "guns"
	type_used_points = USING_SNOWFLAKE_POINTS

/obj/structure/machinery/cm_vending/gear/commanding_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_commanding_officer

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_commanding_officer, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel/lockable, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, VENDOR_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Commanding Officer's M3 Armor", 0, /obj/item/clothing/suit/storage/marine/mp/co, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Commanding Officer's M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/co, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Commanding Officer's Gloves", 0, /obj/item/clothing/gloves/marine/techofficer/commander, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, VENDOR_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Tactical Waistcoat", 0, /obj/item/clothing/accessory/storage/black_vest/waistcoat, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("HUDS (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Security HUD Glasses", 0, /obj/item/clothing/glasses/sunglasses/sechud, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("BELTS (TAKE ALL)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/commanding_officer
	name = "\improper ColMarTech Commanding Officer Equipment Rack"
	desc = "An automated equipment vendor for the Commanding Officer. Contains a prime selection of equipment for only the USCM's top officers."
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_CO, JOB_WO_CO)

/obj/structure/machinery/cm_vending/clothing/commanding_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_commanding_officer

// This gets around the COs' weapon not spawning without incendiary mag.
/obj/effect/essentials_set/co/riflepreset
	spawned_gear_list = list(
		/obj/item/weapon/gun/rifle/m46c,
	)
