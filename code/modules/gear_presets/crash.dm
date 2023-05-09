/datum/equipment_preset/crash
	name = MODE_NAME_CRASH
	faction = FACTION_USCM
	languages = list(LANGUAGE_ENGLISH)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/crash/load_status(mob/living/carbon/human/H)
	H.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW)


//*****************************************************************************************************//

/datum/equipment_preset/crash/commander
	name = "Special Ship Commander"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	assignment = JOB_CRASH_CO
	rank = JOB_CRASH_CO
	paygrade = "O5"
	role_comm_title = "CDR"
	skills = /datum/skills/commander
	idtype = /obj/item/card/id/gold

	utility_under = list(/obj/item/clothing/under/marine,/obj/item/clothing/under/marine/officer/command)
	utility_hat = list(/obj/item/clothing/head/cmcap,/obj/item/clothing/head/beret/cm/tan)
	utility_extra = list(/obj/item/clothing/glasses/sunglasses,/obj/item/clothing/glasses/sunglasses/big,/obj/item/clothing/glasses/sunglasses/aviator,/obj/item/clothing/glasses/mbcg)

	service_under = list(/obj/item/clothing/under/marine/officer/formal/white, /obj/item/clothing/under/marine/officer/formal/black)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)
	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)
	service_hat = list(/obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/marine/commander/dress, /obj/item/clothing/head/beret/marine/commander/black)

	dress_under = list(/obj/item/clothing/under/marine/dress, /obj/item/clothing/under/marine/officer/formal/servicedress)
	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)
	dress_hat = list(/obj/item/clothing/head/marine/peaked/captain/white, /obj/item/clothing/head/marine/peaked/captain/black)
	dress_shoes = list(/obj/item/clothing/shoes/dress/commander)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/white, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/black, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/suit)

/datum/equipment_preset/crash/commander/New()
	. = ..()
	access = get_all_marine_access()

/datum/equipment_preset/crash/commander/load_gear(mob/living/carbon/human/H)
	var/sidearm = "Mateba"
	var/kit = null
	var/sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/full
	var/backItem = /obj/item/storage/backpack/satchel/lockable

	if(H.client && H.client.prefs)
		sidearm = H.client.prefs.commander_sidearm
		switch(sidearm)
			if("Mateba")
				sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/full
				kit = /obj/item/storage/mateba_case/captain
			if("Colonel's Mateba")
				sidearmpath = /obj/item/storage/belt/gun/mateba/council/full
				kit = /obj/item/storage/mateba_case/captain/council
			if("Desert Eagle")
				sidearmpath = /obj/item/storage/belt/gun/m4a3/heavy/co
			if("Golden Desert Eagle")
				sidearmpath = /obj/item/storage/belt/gun/m4a3/heavy/co_golden
			if("M4A3 Custom")
				sidearmpath = /obj/item/storage/belt/gun/m4a3/commander
			if("VP78")
				sidearmpath = /obj/item/storage/belt/gun/m4a3/vp78

	//back
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	if(kit)
		H.equip_to_slot_or_del(new kit(H), WEAR_IN_BACK)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	//uniform
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/command(H), WEAR_BODY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/mp/so(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/claymore/mercsword/ceremonial(H), WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new sidearmpath(H), WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/techofficer/commander(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress/commander(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(H), WEAR_L_HAND)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/command(H), WEAR_L_STORE)


//*****************************************************************************************************//

/datum/equipment_preset/crash/head_surgeron
	name = "Special Ship Head Surgeon" //CMO
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_CMO, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_CRASH_CMO
	rank = JOB_CRASH_CMO
	paygrade = "CCMO"
	role_comm_title = "HS"
	skills = /datum/skills/CMO
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/crash/head_surgeron/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmo(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	//H.equip_to_slot_or_del(new /obj/item/clothing/head/cmo(H), WEAR_HEAD)//2.10.2018 Will want to work on this a bit more, it doesn't quite fit. - Joshuu
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)

//*****************************************************************************************************//

/datum/equipment_preset/crash/bcm
	name = "Special Ship Crew Master" //CE
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_CRASH_CHIEF_ENGINEER
	rank = JOB_CRASH_CHIEF_ENGINEER
	paygrade = "E8"
	role_comm_title = "BCM"
	skills = /datum/skills/CE
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/crash/bcm/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/eng(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine
	name = "USCM Squad" //Stub other Marine equipment stems from
	flags = EQUIPMENT_PRESET_STUB

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/sl
	name = "USCM Squad Squad Leader"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	paygrade = "ME5"
	role_comm_title = "SL"
	skills = /datum/skills/sl

/datum/equipment_preset/crash/marine/sl/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/leader(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/map/current_map(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/designator(H), WEAR_IN_BACK)

	add_common_wo_equipment(H)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/spec
	name = "USCM Squad Squad Weapons Specialist"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	paygrade = "ME3"
	role_comm_title = "Spc"
	skills = /datum/skills/specialist

/datum/equipment_preset/crash/marine/spec/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing(H), WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/attachable/magnetic_harness(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/spec_kit, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)

	add_common_wo_equipment(H)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/sg
	name = "USCM Squad Squad Smartgunner"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = JOB_SQUAD_SMARTGUN
	rank = JOB_SQUAD_SMARTGUN
	paygrade = "ME3"
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

/datum/equipment_preset/crash/marine/sg/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine


	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_R_HAND)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)

	add_common_wo_equipment(H)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/engineer
	name = "USCM Squad Squad Combat Technician"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	paygrade = "ME3"
	role_comm_title = "ComTech"
	skills = /datum/skills/combat_engineer

/datum/equipment_preset/crash/marine/engineer/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)

	generate_random_marine_primary_for_wo(H)
	add_common_wo_equipment(H)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/medic
	name = "USCM Squad Hospital Corpsman"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	paygrade = "ME3"
	role_comm_title = "HM"
	skills = /datum/skills/combat_medic

/datum/equipment_preset/crash/marine/medic/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(H), WEAR_L_STORE)

	generate_random_marine_primary_for_wo(H)
	add_common_wo_equipment(H)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/pfc
	name = "USCM Squad Rifleman (PFC)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrade = "ME2"
	role_comm_title = "RFN"
	skills = /datum/skills/pfc

/datum/equipment_preset/crash/marine/pfc/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)

	generate_random_marine_primary_for_wo(H)
	add_common_wo_equipment(H)
