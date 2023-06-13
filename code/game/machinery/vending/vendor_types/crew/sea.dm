//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_sea, list(
		list("PERSONAL PRIMARY (CHOOSE 1)", 0, null, null, null),
		list("M41A MK1 Pulse Rifle", 0, /obj/item/weapon/gun/rifle/m41aMK1, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),

		list("GUN ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, VENDOR_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, VENDOR_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, VENDOR_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", 0, /obj/item/attachable/flashlight, VENDOR_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/sea
	name = "ColMarTech SEA Weapon Rack"
	desc = "An automated gear rack for the Senior Enlisted Advisor."
	req_access = list(ACCESS_MARINE_SEA)
	vendor_role = list(JOB_SEA)
	icon_state = "guns"

/obj/structure/machinery/cm_vending/gear/sea/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_sea

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_sea, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer Uniform", 0, /obj/item/clothing/under/marine/dress, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Gloves", 0, /obj/item/clothing/gloves/marine, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel/lockable, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, VENDOR_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, VENDOR_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Combat Toolbelt Rig (Full)", 0, /obj/item/storage/belt/gun/utility, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("COMBAT ARMOR (CHOOSE 1)", 0, null, null, null),
		list("M3-VL Pattern Ballistics Vest", 0, /obj/item/clothing/suit/storage/marine/light/vest, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("M3-L Pattern Light Armor", 0, /obj/item/clothing/suit/storage/marine/light, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("M3 Pattern Padded Armor", 0, /obj/item/clothing/suit/storage/marine/padded, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Bulletproof Vest", 0, /obj/item/clothing/suit/armor/bulletproof, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Drill Hat", 0, /obj/item/clothing/head/drillhat, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("M10 Helmet", 0, /obj/item/clothing/head/helmet/marine, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("TOOLS OF THE TRADE", 0, null, null, null),
		list("CPR Dummy", 5, /obj/item/cpr_dummy, null, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/clothing/sea
	name = "ColMarTech SEA Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Senior Enlisted Advisor standard-issue equipment."
	req_access = list(ACCESS_MARINE_SEA)
	vendor_role = list(JOB_SEA)

/obj/structure/machinery/cm_vending/clothing/sea/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_sea
