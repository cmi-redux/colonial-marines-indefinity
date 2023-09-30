/obj/structure/machinery/cm_vending/clothing/medical_crew
	name = "\improper ColMarTech Medical Equipment Rack"
	desc = "An automated equipment vendor for the Medical Department."
	req_access = list(ACCESS_MARINE_MEDBAY)
	vendor_role = list(JOB_DOCTOR,JOB_NURSE,JOB_RESEARCHER,JOB_CMO)
	icon_state = "dress"

/obj/structure/machinery/cm_vending/clothing/medical_crew/get_listed_products(mob/user)
	if(!user)
		var/list/combined = list()
		combined += GLOB.cm_vending_clothing_nurse
		combined += GLOB.cm_vending_clothing_researcher
		combined += GLOB.cm_vending_clothing_cmo
		combined += GLOB.cm_vending_clothing_doctor
		return combined
	if(user.job == JOB_NURSE)
		return GLOB.cm_vending_clothing_nurse
	else if(user.job == JOB_RESEARCHER)
		return GLOB.cm_vending_clothing_researcher
	else if(user.job == JOB_CMO)
		///defined in senior_officers.dm
		return GLOB.cm_vending_clothing_cmo
	else if(user.job == JOB_DOCTOR)
		return GLOB.cm_vending_clothing_doctor
	return ..()



//------------ DOCTOR ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_doctor, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical/doctor, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/doc, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Green Scrubs", 0, /obj/item/clothing/under/rank/medical/green, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Snowcoat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),

		list("HELMET", 0, null, null, null),
		list("Surgical Cap, Blue", 0, /obj/item/clothing/head/surgery/blue, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Purple", 0, /obj/item/clothing/head/surgery/purple, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Green", 0, /obj/item/clothing/head/surgery/green, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

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
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	))

//------------ NURSE ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_nurse, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/doc, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Green Scrubs", 0, /obj/item/clothing/under/rank/medical/green, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Medical Nurse Scrubs", 0, /obj/item/clothing/under/rank/medical/nurse, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Snowcoat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),

		list("HELMET", 0, null, null, null),
		list("Surgical Cap, Blue", 0, /obj/item/clothing/head/surgery/blue, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Purple", 0, /obj/item/clothing/head/surgery/purple, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Green", 0, /obj/item/clothing/head/surgery/green, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

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
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	))

//------------ RESEARCHER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_researcher, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical/doctor, VENDOR_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, VENDOR_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/research, VENDOR_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Reagent Scanner HUD Goggles", 0, /obj/item/clothing/glasses/science, VENDOR_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Green Scrubs", 0, /obj/item/clothing/under/rank/medical/green, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Researcher Uniform", 0, /obj/item/clothing/under/marine/officer/researcher, VENDOR_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat/researcher, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Snowcoat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, VENDOR_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),

		list("HELMET", 0, null, null, null),
		list("Surgical Cap, Blue", 0, /obj/item/clothing/head/surgery/blue, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Purple", 0, /obj/item/clothing/head/surgery/purple, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Green", 0, /obj/item/clothing/head/surgery/green, VENDOR_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, VENDOR_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, VENDOR_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Vials Pouch", 0, /obj/item/storage/pouch/vials, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Chemist Pouch", 0, /obj/item/storage/pouch/chem, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, VENDOR_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, VENDOR_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	))

/obj/effect/essentials_set/medical
	spawned_gear_list = list(
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
	)

/obj/effect/essentials_set/medical/doctor
	spawned_gear_list = list(
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/accessory/stethoscope,
	)
