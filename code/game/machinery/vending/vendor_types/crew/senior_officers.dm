/obj/structure/machinery/cm_vending/clothing/senior_officer
	name = "\improper ColMarTech Senior Officer Equipment Rack"
	desc = "An automated equipment vendor for Senior Officers."
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_CHIEF_POLICE, JOB_CMO, JOB_XO, JOB_CHIEF_ENGINEER, JOB_CHIEF_REQUISITION, JOB_AUXILIARY_OFFICER)

/obj/structure/machinery/cm_vending/clothing/senior_officer/get_listed_products(mob/user)
	if(!user)
		var/list/combined = list()
		combined += GLOB.cm_vending_clothing_xo
		combined += GLOB.cm_vending_clothing_chief_engineer
		combined += GLOB.cm_vending_clothing_req_officer
		combined += GLOB.cm_vending_clothing_cmo
		combined += GLOB.cm_vending_clothing_military_police_chief
		return combined
	if(user.job == JOB_XO)
		return GLOB.cm_vending_clothing_xo
	else if(user.job == JOB_CHIEF_ENGINEER)
		return GLOB.cm_vending_clothing_chief_engineer
	else if(user.job == JOB_CHIEF_REQUISITION)
		return GLOB.cm_vending_clothing_req_officer
	else if(user.job == JOB_CMO)
		return GLOB.cm_vending_clothing_cmo
	else if(user.job == JOB_CHIEF_POLICE)
		return GLOB.cm_vending_clothing_military_police_chief
	else if(user.job == JOB_AUXILIARY_OFFICER)
		return GLOB.cm_vending_clothing_auxiliary_officer
	return ..()


//------------ CHIEF MP ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_military_police_chief, list(
		list("POLICE SET (MANDATORY)", 0, null, null, null),
		list("Essential Police Set", 0, /obj/effect/essentials_set/chiefmilitarypolice, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("CMP Uniform", 0, /obj/item/clothing/under/marine/officer/warrant, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/cmpcom, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, VENDOR_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("ARMOR (TAKE ALL)", 0, null, null, null),
		list("Military Police Chief M3 Armor", 0, /obj/item/clothing/suit/storage/marine/mp/wo, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Chief MP M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/mp/wo, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("CMP Beret", 0, /obj/item/clothing/head/beret/marine/mp/cmp, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("HANDGUN CASE (CHOOSE 1)", 0, null, null, null),
		list("88 mod 4 Combat Pistol Case", 0, /obj/item/storage/box/guncase/mod88, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M44 Combat Revolver Case", 0, /obj/item/storage/box/guncase/m44, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M4A3 Service Pistol Case", 0, /obj/item/storage/box/guncase/m4a3, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Military Police Satchel", 0, /obj/item/storage/backpack/satchel/sec, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))


//------------ CHIEF ENGINEER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_chief_engineer, list(

		list("SHIPSIDE GEAR", 0, null, null, null),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/ce, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Toolbelt", 0, /obj/item/storage/belt/utility/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine, VENDOR_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Welding Goggles", 0, /obj/item/clothing/glasses/welding, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Chief Engineer Uniform", 0, /obj/item/clothing/under/marine/officer/ce, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Service Uniform", 0, /obj/item/clothing/under/marine/officer/bridge, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Beret, Engineering", 0, /obj/item/clothing/head/beret/eng, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Hardhat", 0, /obj/item/clothing/head/hardhat/white, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Patrol Cap", 0, /obj/item/clothing/head/cmcap, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Welding Helmet", 0, /obj/item/clothing/head/welding, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Black Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest/black, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Blue Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest/blue, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Orange Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Yellow Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest/yellow, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("USCM Service Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/service, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Leather Satchel", 0, /obj/item/storage/backpack/satchel, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Chestrig", 0, /obj/item/storage/backpack/marine/satchel/tech, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", 0, /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Welding Kit", 0, /obj/item/tool/weldpack, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 0, /obj/item/storage/pouch/flamertank, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),


		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("DEPLOYMENT GEAR", 0, null, null, null),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/mp/so, VENDOR_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_REGULAR),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, VENDOR_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 0, /obj/item/device/binoculars/range/designator, VENDOR_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("COMBAT HELMET (CHOOSE 1)", 0, null, null, null),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/mp/so, VENDOR_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),
		list("M10 Technician Helmet", 0, /obj/item/clothing/head/helmet/marine/tech, VENDOR_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("PRIMARY FIREARMS (CHOOSE 1)", 0, null, null, null),
		list("M37A2 Pump Shotgun", 0, /obj/item/storage/box/guncase/pumpshotgun, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", 0, /obj/item/storage/box/guncase/m41a, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Unit", 0, /obj/item/storage/box/guncase/flamer, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),

	))


//------------ CHIEF REQ ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_req_officer, list(

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Quartermaster Uniform", 0, /obj/item/clothing/under/rank/ro_suit, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/qm, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel/tech, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Req Cap", 0, /obj/item/clothing/head/cmcap/req, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Quartermaster Jacket", 0, /obj/item/clothing/suit/storage/ro, VENDOR_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M44 Custom Revolver", 0, /obj/item/storage/belt/gun/m44/custom, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/mp/so, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/mp/so, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, VENDOR_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Empty)", 0, /obj/item/storage/pouch/tools, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("Spare Equipment", 0, null, null, null),
		list("Rubber Stamp", 10, /obj/item/tool/stamp/ro, null, VENDOR_ITEM_REGULAR),
	))


//------------ CHIEF MEDICAL OFFICER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_cmo, list(

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/cmo, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat, VENDOR_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("EYEWARE (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Reagent Scanner HUD Goggles", 0, /obj/item/clothing/glasses/science, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Green Scrubs", 0, /obj/item/clothing/under/rank/medical/green, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Doctor Uniform", 0, /obj/item/clothing/under/rank/medical, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", 0, /obj/item/storage/backpack/marine/satchel, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("USCM Backpack", 0, /obj/item/storage/backpack/marine, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/mp/so, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/mp/so, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, VENDOR_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))





//------------ EXECUTIVE OFFFICER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_xo, list(

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Service Uniform", 0, /obj/item/clothing/under/marine/officer/bridge, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("PERSONAL WEAPON (CHOOSE 1)", 0, null, null, null),
		list("VP78 Pistol", 0, /obj/item/storage/belt/gun/m4a3/vp78, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/commander, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("Ceremonial Sword", 0, /obj/item/storage/large_holster/ceremonial_sword/full, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/mp/so, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/mp/so, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, VENDOR_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Gloves", 0, /obj/item/clothing/gloves/marine, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Security HUD Glasses", 0, /obj/item/clothing/glasses/sunglasses/sechud, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Bimex Personal Shades", 0, /obj/item/clothing/glasses/sunglasses/big, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Aviator Shades", 0, /obj/item/clothing/glasses/sunglasses/aviator, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("PATCHES", 0, null, null, null),
		list("Falling Falcons Shoulder Patch", 0, /obj/item/clothing/accessory/patch/falcon, VENDOR_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("USCM Shoulder Patch", 0, /obj/item/clothing/accessory/patch, VENDOR_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Document Pouch", 0, /obj/item/storage/pouch/document, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),


		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("HATS (CHOOSE 1)", 0, null, null, null),
		list("Officer Beret", 0, /obj/item/clothing/head/beret/marine/chiefofficer, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Peaked cap", 0, /obj/item/clothing/head/marine/peaked, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Patrol Cap", 0, /obj/item/clothing/head/cmcap, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Officer Cap", 0, /obj/item/clothing/head/cmcap/ro, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
	))



//------------ AUXILIARY SUPPORT OFFICER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_auxiliary_officer, list(

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Officer Uniform", 0, /obj/item/clothing/under/marine/officer/bridge, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/qm, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel/tech, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Patrol Cap", 0, /obj/item/clothing/head/cmcap, VENDOR_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Auxiliary Support Officer Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/service/aso, VENDOR_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M44 Custom Revolver", 0, /obj/item/storage/belt/gun/m44/custom, VENDOR_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/mp/so, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/mp/so, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, VENDOR_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Empty)", 0, /obj/item/storage/pouch/tools, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/effect/essentials_set/chiefmilitarypolice
	spawned_gear_list = list(
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/storage/belt/security/mp/full,
		/obj/item/clothing/head/helmet/marine/mp/wo,
	)
