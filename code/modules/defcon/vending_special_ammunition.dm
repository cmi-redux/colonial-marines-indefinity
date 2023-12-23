GLOBAL_LIST_EMPTY(unlocked_gears_defcon)
GLOBAL_REFERENCE_LIST_INDEXED_SORTED(gears_defcon, /datum/defcon_asset, name)

/////////////////
/////VENDING/////
/////////////////
/obj/structure/defcon_vendor
	name = "ColMarTech Special Operation Gear Vendor"
	desc = "An automated gear rack hooked up to a special gear storage."
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "intel_gear"
	anchored = TRUE
	anchored = TRUE
	wrenchable = FALSE
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE

	faction_to_get = FACTION_MARINE

	//per faction access
	//set to TRUE to allow everyone to use it on distress beacon mode OR to limit to roles above on all other modes.
	var/access_settings_override = FALSE

/obj/structure/defcon_vendor/attack_hand(mob/user)
	var/area/a = get_area(src)
	//no idea why it was made just a structure, so this is gonna be here for now
	if(!a.master || a.master.requires_power && !a.master.unlimited_power && !a.master.power_equip)
		return

	if(!ishuman(user) || !get_access_permission(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/list/list_of_gears = list()
	var/list/assets = GLOB.unlocked_gears_defcon[faction_to_get]
	for(var/i in assets)
		var/datum/defcon_asset/asset = i
		if(!asset.can_access(user))
			continue

		list_of_gears[asset.name] = asset

	if(!length(list_of_gears))
		to_chat(user, SPAN_WARNING("No tech gear is available at the moment!"))
		return

	var/user_input = tgui_input_list(user, "Choose a tech to retrieve an item from.", name, list_of_gears)
	if(!user_input)
		return

	var/datum/defcon_asset/chosen_asset = list_of_gears[user_input]
	if(!chosen_asset.can_access(user))
		to_chat(user, SPAN_WARNING("You cannot access this tech!"))
		return

	chosen_asset.on_access(user)

/obj/structure/defcon_vendor/proc/get_access_permission(mob/living/carbon/human/user)
	if(Check_DS())
		if(access_settings_override) //everyone allowed to grab stuff
			return TRUE
		else if(user.ally(faction))	//only it's faction group allowed
			return TRUE
	else
		if(access_settings_override)
			if(user.ally(faction))	//vica versa for extended and other modes, allowed by default, not allowed with override
				return TRUE
		else
			return TRUE

	return FALSE


/////////////////////////////
//LIST OF ALL GEARS PRESETS//
/////////////////////////////
/datum/defcon_asset
	var/name = "PLEASE SET ME!!!!!!"
	var/asset_name = "PLEASE SET ME!!!!!!"
	var/cost_points = 0
	var/faction_name = FACTION_MARINE

	var/unlocked = FALSE

	var/list/already_accessed = list()

	var/input_message = "Choose an item to retrieve."
	var/list/slots_to_equip_to = list(
		WEAR_L_HAND,
		WEAR_R_HAND,
		WEAR_IN_BACK,
		WEAR_IN_JACKET,
		WEAR_IN_L_STORE,
		WEAR_IN_R_STORE
	)
	var/options_to_give = 1
	var/restricted_usecase = FALSE

	var/add_to_list = TRUE

/datum/defcon_asset/proc/get_options(mob/living/carbon/human/H, obj/structure/defcon_vendor/D)
	return list()

/// This proc can potentially be blocking! Don't use unless you know what you're doing!
/datum/defcon_asset/proc/get_items_to_give(mob/living/carbon/human/H, obj/structure/defcon_vendor/D)
	var/list/options = get_options(H, D)
	if(!length(options))
		return

	if(length(options) == 1)
		// thanks byond
		return list(options[options[1]])
	else
		var/list/items_to_give = list()
		for(var/i in 1 to min(length(options), options_to_give))
			var/player_input = tgui_input_list(H, input_message, name, options)
			// Early return here because they decided to cancel their selection or the option no longer exists.
			if(!player_input || !(player_input in get_options(H, D)))
				return

			items_to_give += options[player_input]
			options -= player_input

		return items_to_give

/datum/defcon_asset/proc/on_access(mob/living/carbon/human/H, obj/structure/defcon_vendor/D)
	var/list/items_to_give = get_items_to_give(H, D)

	if(!length(items_to_give))
		return

	if(!can_access(H, D))
		return

	for(var/i in items_to_give)
		var/atom/movable/item_to_give = i

		if(ispath(i))
			item_to_give = new i()

		if(H.put_in_active_hand(item_to_give))
			continue

		for(var/slot in slots_to_equip_to)
			if(H.equip_to_slot_if_possible(item_to_give, slot, disable_warning=TRUE))
				break

		if(!item_to_give.loc)
			item_to_give.forceMove(get_turf(H))

	already_accessed += H
	RegisterSignal(H, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_mob))

/datum/defcon_asset/proc/cleanup_mob(mob/living/carbon/human/H)
	SIGNAL_HANDLER
	already_accessed -= H

// Called as to whether on_pod_access should be called
/datum/defcon_asset/proc/can_access(mob/living/carbon/human/H, obj/structure/defcon_vendor/D)

	if(H in already_accessed)
		to_chat(H, SPAN_WARNING("You've already accessed this asset!"))
		return FALSE

	return TRUE

/datum/defcon_asset/proc/on_unlock(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(add_to_list)
		if(!length(GLOB.unlocked_gears_defcon[faction_name]))
			GLOB.unlocked_gears_defcon[faction_name] = list()
		GLOB.unlocked_gears_defcon[faction_name] += src
	unlocked = TRUE
	return TRUE


/////////////////
//LIST OF TECHS//
/////////////////

////////////////////////
//SUPPORT (ENGI|MEDIC)//
////////////////////////
/datum/defcon_asset/support_kits
	name = "Support Kits"
	add_to_list = FALSE

	var/list/kits = list("Engineer Kit", "Medical Kit")

/datum/defcon_asset/support_kits/on_unlock()
	for(var/kit in kits)
		var/datum/defcon_asset/gear = GLOB.gears_defcon[kit]
		gear.on_unlock()
	. = ..()

/datum/defcon_asset/support_kits/upp
	name = "UPP Support Kits"
	faction_name = FACTION_UPP

	kits = list("UPP Engineer Kit", "UPP Medical Kit")

//ENGI
/datum/defcon_asset/engi_czsp
	name = "Engineer Kit"
	asset_name = "Engi CZSP"
	cost_points = 10

/datum/defcon_asset/engi_czsp/get_options(mob/living/carbon/human/H, obj/structure/defcon_vendor/D)
	. = ..()
	if(!H || H.job == JOB_SQUAD_ENGI)
		.["Engineering Upgrade Kit"] = /obj/item/engi_upgrade_kit
	else
		.["Random Tool"] = pick(common_tools)

/datum/defcon_asset/engi_czsp/on_unlock()
	. = ..()
	var/datum/supply_packs/SP = /datum/supply_packs/upgrade_turrets_kits
	SP = supply_controller.supply_packs[initial(SP.name)]
	SP.buyable = TRUE
	SP.cost = 40

/datum/defcon_asset/engi_czsp/upp
	name = "UPP Engineer Kit"
	faction_name = FACTION_UPP

//MEDIC
/datum/defcon_asset/medic_czsp
	name = "Medical Kit"
	asset_name = "Medic CZSP"
	cost_points = 10

/datum/defcon_asset/medic_czsp/on_unlock()
	. = ..()
	var/datum/supply_packs/SP = /datum/supply_packs/upgraded_medical_kits
	SP = supply_controller.supply_packs[initial(SP.name)]
	SP.buyable = TRUE
	SP.cost = 40

/datum/defcon_asset/medic_czsp/get_options(mob/living/carbon/human/H, obj/structure/defcon_vendor/D)
	. = ..()

	if(!H || skillcheck(H, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		.["Medical CZSP"] = /obj/item/storage/box/combat_zone_support_package
	else
		var/type_to_add = /obj/item/stack/medical/bruise_pack
		if(prob(50))
			type_to_add = /obj/item/stack/medical/ointment

		if(prob(5))
			type_to_add = /obj/item/device/healthanalyzer

		.["Random Medical Item"] = type_to_add

/datum/defcon_asset/medic_czsp/upp
	name = "UPP Medical Kit"
	faction_name = FACTION_UPP


//////////////////
///////AMMO///////
//////////////////
/datum/defcon_asset/enhanced_antibiologicals
	name = "Special Ammo"
	asset_name = "Ammo Kits"
	cost_points = 25

	input_message = "Choose an ammo kit to retrieve."

/datum/defcon_asset/enhanced_antibiologicals/on_unlock()
	. = ..()
	var/datum/supply_packs/SP = /datum/supply_packs/special_ammo
	SP = supply_controller.supply_packs[initial(SP.name)]
	SP.buyable = TRUE
	SP.cost = 40


/datum/defcon_asset/enhanced_antibiologicals/get_options(mob/living/carbon/human/H, obj/structure/defcon_vendor/D)
	. = ..()

	.["Incendiary Buckshot Kit"] = /obj/item/storage/box/shotgun/buckshot
	.["Incendiary Slug Kit"] = /obj/item/storage/box/shotgun/slug
	.["Incendiary Ammo Kit"] = /obj/item/ammo_kit/incendiary
	.["Penetrating Ammo Kit"] = /obj/item/ammo_kit/penetrating
	.["Cluster Ammo Kit"] = /obj/item/ammo_kit/cluster
	.["Toxin Ammo Kit"] = /obj/item/ammo_kit/toxin

/datum/defcon_asset/enhanced_antibiologicals/upp
	name = "UPP Special Ammo"
	faction_name = FACTION_UPP


///////////////////
////ADV WEAPONS////
///////////////////
/datum/defcon_asset/advanced_weapons
	name = "Experemental Guns Kits"
	asset_name = "Advanced Weapons"
	cost_points = 15

	input_message = "Choose an weapon kit to retrieve."

/datum/defcon_asset/advanced_weapons/on_unlock()
	. = ..()
	var/datum/supply_packs/SP = /datum/supply_packs/special_guns_kit
	SP = supply_controller.supply_packs[initial(SP.name)]
	SP.buyable = TRUE
	SP.cost = 40

/datum/defcon_asset/advanced_weapons/on_access(mob/living/carbon/human/H, obj/structure/defcon_vendor/D)
	. = ..()

	.["Railgun"] = /obj/item/advanced_weapon_kit/railgun
	.["Shotgun"] = /obj/item/advanced_weapon_kit/heavyshotgun

/datum/defcon_asset/advanced_weapons/upp
	name = "UPP Experemental Guns Kits"
	faction_name = FACTION_UPP


//////////////////
/////IMPLANTS/////
//////////////////
/datum/defcon_asset/combat_implants
	name = "Implants"
	asset_name = "Combat Implants"
	cost_points = 20

	input_message = "Choose a combat implant to retrieve."
	options_to_give = 2

/datum/defcon_asset/combat_implants/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Nightvision Implant"] = /obj/item/device/implanter/nvg
	.["Rejuvenation Implant"] = /obj/item/device/implanter/rejuv
	.["Agility Implant"] = /obj/item/device/implanter/agility
	.["Subdermal Armor"] = /obj/item/device/implanter/subdermal_armor

/datum/defcon_asset/combat_implants/get_items_to_give(mob/living/carbon/human/H, obj/structure/droppod/D)
	var/list/chosen_options = ..()

	if(!chosen_options)
		return

	var/obj/item/storage/box/implant/B = new()
	B.storage_slots = options_to_give
	for(var/i in chosen_options)
		new i(B)

	return list(B)

/datum/defcon_asset/combat_implants/upp
	name = "UPP Implants"
	faction_name = FACTION_UPP


//////////////////
///////AMMO///////
//////////////////
/obj/item/ammo_kit
	name = "ammo kit"
	icon = 'icons/obj/items/devices.dmi'
	desc = "An ammo kit used to convert regular ammo magazines of various weapons into a different variation."
	icon_state = "kit_generic"

	var/list/convert_map
	var/uses = 5

/obj/item/ammo_kit/Initialize(mapload, ...)
	. = ..()
	convert_map = get_convert_map()

/obj/item/ammo_kit/get_examine_text(mob/user)
	. = ..()
	. += "It has [uses] uses remaining.<br>"

/obj/item/ammo_kit/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	if(!(target.type in convert_map))
		return ..()

	if(uses <= 0)
		return ..()

	var/obj/item/ammo_magazine/M = target
	if(M.ammo_position < M.max_rounds)
		to_chat(user, SPAN_WARNING("The magazine needs to be full for you to apply this kit onto it."))
		return

	if(user.l_hand != M && user.r_hand != M)
		to_chat(user, SPAN_WARNING("The magazine needs to be in your hands for you to apply this kit onto it."))
		return

	var/type_to_convert_to = convert_map[target.type]

	user.drop_held_item(M)
	QDEL_NULL(M)
	M = new type_to_convert_to(get_turf(user))
	user.put_in_any_hand_if_possible(M)
	uses -= 1
	playsound(get_turf(user), "sound/machines/fax.ogg", 5)

	user.count_statistic_stat(STATISTICS_AMMO_CONVERTED)

	if(uses <= 0)
		user.drop_held_item(src)
		qdel(src)

/obj/item/ammo_kit/proc/get_convert_map()
	return list()

/obj/item/ammo_kit/incendiary
	name = "incendiary ammo kit"
	icon_state = "kit_incendiary"
	desc = "Converts magazines into incendiary ammo."

/obj/item/ammo_kit/incendiary/get_convert_map()
	. = ..()
	.[/obj/item/ammo_magazine/smg/m39] = /obj/item/ammo_magazine/smg/m39/incendiary
	.[/obj/item/ammo_magazine/rifle] = /obj/item/ammo_magazine/rifle/incendiary
	.[/obj/item/ammo_magazine/rifle/l42a] = /obj/item/ammo_magazine/rifle/l42a/incendiary
	.[/obj/item/ammo_magazine/rifle/m41aMK1] = /obj/item/ammo_magazine/rifle/m41aMK1/incendiary
	.[/obj/item/ammo_magazine/pistol] =  /obj/item/ammo_magazine/pistol/incendiary
	.[/obj/item/ammo_magazine/pistol/vp78] =  /obj/item/ammo_magazine/pistol/vp78/incendiary
	.[/obj/item/ammo_magazine/pistol/mod88] =  /obj/item/ammo_magazine/pistol/mod88/incendiary
	.[/obj/item/ammo_magazine/revolver] =  /obj/item/ammo_magazine/revolver/incendiary

/obj/item/storage/box/shotgun
	name = "incendiary shotgun kit"
	desc = "A kit containing incendiary shotgun shells."
	icon_state = "incenbuck"
	storage_slots = 5
	var/amount = 5
	var/to_hold

/obj/item/storage/box/shotgun/fill_preset_inventory()
	if(to_hold)
		for(var/i in 1 to amount)
			new to_hold(src)

/obj/item/storage/box/shotgun/buckshot
	name = "incendiary buckshot kit"
	desc = "A box containing 5 handfuls of incendiary buckshot."
	can_hold = list(
		/obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary
	)
	to_hold = /obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary

/obj/item/storage/box/shotgun/slug
	name = "incendiary slug kit"
	desc = "A box containing 5 handfuls of incendiary slugs."
	icon_state = "incenslug"
	can_hold = list(
		/obj/item/ammo_magazine/handful/shotgun/incendiary
	)
	to_hold = /obj/item/ammo_magazine/handful/shotgun/incendiary

/obj/item/ammo_kit/penetrating
	name = "wall-piercing ammo kit"
	icon_state = "kit_penetrating"
	desc = "Converts magazines into wall-piercing ammo."

/obj/item/ammo_kit/penetrating/get_convert_map()
	. = ..()
	.[/obj/item/ammo_magazine/smg/m39] = /obj/item/ammo_magazine/smg/m39/penetrating
	.[/obj/item/ammo_magazine/rifle] = /obj/item/ammo_magazine/rifle/penetrating
	.[/obj/item/ammo_magazine/rifle/l42a] = /obj/item/ammo_magazine/rifle/l42a/penetrating
	.[/obj/item/ammo_magazine/rifle/m41aMK1] = /obj/item/ammo_magazine/rifle/m41aMK1/penetrating
	.[/obj/item/ammo_magazine/pistol] =  /obj/item/ammo_magazine/pistol/penetrating
	.[/obj/item/ammo_magazine/pistol/vp78] =  /obj/item/ammo_magazine/pistol/vp78/penetrating
	.[/obj/item/ammo_magazine/pistol/mod88] =  /obj/item/ammo_magazine/pistol/mod88/penetrating
	.[/obj/item/ammo_magazine/revolver] =  /obj/item/ammo_magazine/revolver/penetrating

/obj/item/ammo_kit/cluster
	name = "cluster ammo kit"
	icon_state = "kit_cluster"
	desc = "Converts magazines into cluster-hit ammo. The ammo will stack up cluster micro-missiles inside the target, detonating them at a certain threshold."

/obj/item/ammo_kit/cluster/get_convert_map()
	. = ..()
	.[/obj/item/ammo_magazine/smg/m39] = /obj/item/ammo_magazine/smg/m39/cluster
	.[/obj/item/ammo_magazine/rifle] = /obj/item/ammo_magazine/rifle/cluster
	.[/obj/item/ammo_magazine/rifle/l42a] = /obj/item/ammo_magazine/rifle/l42a/cluster
	.[/obj/item/ammo_magazine/rifle/m41aMK1] = /obj/item/ammo_magazine/rifle/m41aMK1/cluster
	.[/obj/item/ammo_magazine/pistol] =  /obj/item/ammo_magazine/pistol/cluster
	.[/obj/item/ammo_magazine/pistol/vp78] =  /obj/item/ammo_magazine/pistol/vp78/cluster
	.[/obj/item/ammo_magazine/pistol/mod88] =  /obj/item/ammo_magazine/pistol/mod88/cluster
	.[/obj/item/ammo_magazine/revolver] =  /obj/item/ammo_magazine/revolver/cluster

/obj/item/ammo_kit/toxin
	name = "toxin ammo kit"
	icon_state = "kit_toxin"
	desc = "Converts magazines into toxin ammo. Toxin ammo will poison your target, weakening their defences."

/obj/item/ammo_kit/toxin/get_convert_map()
	. = ..()
	.[/obj/item/ammo_magazine/smg/m39] = /obj/item/ammo_magazine/smg/m39/toxin
	.[/obj/item/ammo_magazine/rifle] = /obj/item/ammo_magazine/rifle/toxin
	.[/obj/item/ammo_magazine/rifle/l42a] = /obj/item/ammo_magazine/rifle/l42a/toxin
	.[/obj/item/ammo_magazine/rifle/m41aMK1] = /obj/item/ammo_magazine/rifle/m41aMK1/toxin
	.[/obj/item/ammo_magazine/pistol] =  /obj/item/ammo_magazine/pistol/toxin
	.[/obj/item/ammo_magazine/pistol/vp78] =  /obj/item/ammo_magazine/pistol/vp78/toxin
	.[/obj/item/ammo_magazine/pistol/mod88] =  /obj/item/ammo_magazine/pistol/mod88/toxin
	.[/obj/item/ammo_magazine/revolver] =  /obj/item/ammo_magazine/revolver/toxin


///////////////////
///////STIMS///////
///////////////////
/obj/item/storage/pouch/stimulant_injector
	name = "stimulant pouch"
	desc = "A pouch that holds stimulant injectors."
	icon = 'icons/obj/items/clothing/pouches.dmi'
	icon_state = "stimulant"
	w_class = SIZE_LARGE //does not fit in backpack
	max_w_class = SIZE_SMALL
	flags_equip_slot = SLOT_STORE
	storage_slots = 3
	storage_flags = STORAGE_FLAGS_POUCH
	can_hold = list(/obj/item/reagent_container/hypospray/autoinjector/stimulant)
	var/stimulant_type

/obj/item/storage/pouch/stimulant_injector/fill_preset_inventory()
	if(!stimulant_type)
		return

	for(var/i in 1 to storage_slots)
		new stimulant_type(src)

/obj/item/storage/pouch/stimulant_injector/speed
	desc = "A pouch that holds speed stimulant injectors."
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/speed_stimulant

/obj/item/storage/pouch/stimulant_injector/brain
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/brain_stimulant
	desc = "A pouch that holds brain stimulant injectors."

/obj/item/storage/pouch/stimulant_injector/redemption
	desc = "A pouch that holds redemption stimulant injectors."
	storage_slots = 1
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/redemption_stimulant

/obj/item/reagent_container/hypospray/autoinjector/stimulant
	icon_state = "stimpack"
	// 5 minutes per injection
	amount_per_transfer_from_this = 5
	// maximum of 15 minutes per injector, has an OD of 15
	volume = 5
	uses_left = 1

/obj/item/reagent_container/hypospray/autoinjector/stimulant/update_icon()
	overlays.Cut()
	if(!uses_left)
		icon_state = "stimpack0"
		return

	icon_state = "stimpack"
	var/datum/reagent/R = chemical_reagents_list[chemname]

	if(!R)
		return
	var/image/I = image(icon, src, icon_state="+stimpack_custom")
	I.color = R.color
	overlays += I

/obj/item/reagent_container/hypospray/autoinjector/stimulant/speed_stimulant
	name = "speed stimulant autoinjector"
	chemname = "speed_stimulant"
	desc = "A stimpack loaded with an experimental performance enhancement stimulant. Extremely muscle-stimulating. Lasts 5 minutes."

/obj/item/reagent_container/hypospray/autoinjector/stimulant/brain_stimulant
	name = "brain stimulant stimpack"
	chemname = "brain_stimulant"
	desc = "A stimpack loaded with an experimental CNS stimulant. Extremely nerve-stimulating. Lasts 5 minutes."

/obj/item/reagent_container/hypospray/autoinjector/stimulant/redemption_stimulant
	amount_per_transfer_from_this = 5
	volume = 5
	name = "redemption stimulant autoinjector"
	chemname = "redemption_stimulant"
	desc = "A stimpack loaded with an experimental bone, organ and muscle stimulant. Significantly increases what a human can take before they go down. Lasts 5 minutes."
/////ADDITIONAL SUPPORT/////


//////////////////
/////MEDI KIT/////
//////////////////
/obj/item/storage/box/combat_zone_support_package
	name = "medical combat support kit"
	use_sound = "toolbox"
	desc = "Contains upgraded medical kits, nanosplints and an upgraded defibrillator."
	icon_state = "medicbox"
	storage_slots = 4

/obj/item/storage/box/combat_zone_support_package/Initialize()
	. = ..()
	new /obj/item/stack/medical/advanced/bruise_pack/upgraded(src)
	new /obj/item/stack/medical/advanced/ointment/upgraded(src)
	new /obj/item/stack/medical/splint/nano(src)
	new /obj/item/device/defibrillator/upgraded(src)


/obj/item/storage/box/czsp/medic_upgraded_kits
	name = "medical upgrade kit"
	icon_state = "upgradedkitbox"
	desc = "This kit holds upgraded trauma and burn kits, for critical injuries."
	max_w_class = SIZE_MEDIUM

	storage_slots = 2

/obj/item/storage/box/czsp/medic_upgraded_kits/Initialize()
	. = ..()
	new /obj/item/stack/medical/advanced/bruise_pack/upgraded(src)
	new /obj/item/stack/medical/advanced/ointment/upgraded(src)

/obj/item/stack/medical/advanced/ointment/upgraded
	name = "upgraded burn kit"
	singular_name = "upgraded burn kit"
	stack_id = "upgraded advanced burn kit"

	icon_state = "burnkit_upgraded"
	desc = "An upgraded advanced burn treatment kit. Three times as effective as standard-issue, and non-replenishible. Use sparingly on only the most critical burns."

	max_amount = 10
	amount = 10

/obj/item/stack/medical/advanced/ointment/upgraded/Initialize(mapload, ...)
	. = ..()
	heal_burn = initial(heal_burn) * 3 // 3x stronger

/obj/item/stack/medical/advanced/bruise_pack/upgraded
	name = "upgraded trauma kit"
	singular_name = "upgraded trauma kit"
	stack_id = "upgraded advanced trauma kit"

	icon_state = "traumakit_upgraded"
	desc = "An upgraded advanced trauma treatment kit. Three times as effective as standard-issue, and non-replenishible. Use sparingly on only the most critical wounds."

	max_amount = 10
	amount = 10

/obj/item/stack/medical/advanced/bruise_pack/upgraded/Initialize(mapload, ...)
	. = ..()
	heal_brute = initial(heal_brute) * 3 // 3x stronger

/obj/item/stack/medical/splint/nano
	name = "nano splints"
	singular_name = "nano splint"

	icon_state = "nanosplint"
	desc = "Advanced technology allows these splints to hold bones in place while being flexible and damage-resistant. These aren't plentiful, so use them sparingly on critical areas."

	indestructible_splints = TRUE
	amount = 5
	max_amount = 5

	stack_id = "nano splint"

/obj/item/device/defibrillator/upgraded
	name = "upgraded emergency defibrillator"
	icon_state = "defib_adv"
	desc = "An advanced rechargeable defibrillator using induction to deliver shocks through metallic objects, such as armor, and does so with much greater efficiency than the standard variant."

	icon_state_for_paddles = "defib_adv"

	blocked_by_suit = FALSE
	heart_damage_mult = 0.3
	additional_charge_cost = 2.0
	boost_recharge = 0.6
	healing_mult = 1.75

/obj/item/ammo_magazine/internal/pillgun
	name = "pill tube"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	ammo_preset = list(/datum/ammo/pill)
	caliber = "pill"
	max_rounds = 1
	chamber_closed = FALSE

	var/list/pills

/obj/item/ammo_magazine/internal/pillgun/Initialize(mapload, spawn_empty)
	. = ..()
	ammo_position = length(pills)

/obj/item/ammo_magazine/internal/pillgun/Entered(atom/movable/arrived, old_loc)
	. = ..()
	if(!istype(arrived, /obj/item/reagent_container/pill))
		return

	LAZYADD(pills, arrived)
	ammo_position = length(pills)

/obj/item/ammo_magazine/internal/pillgun/Exited(atom/movable/gone, direction)
	. = ..()
	if(!istype(gone, /obj/item/reagent_container/pill))
		return

	LAZYREMOVE(pills, gone)
	ammo_position = length(pills)

/obj/item/ammo_magazine/internal/pillgun/super
	max_rounds = 5

// upgraded version, currently no way of getting it
/obj/item/weapon/gun/pill/super
	name = "large pill gun"
	current_mag = /obj/item/ammo_magazine/internal/pillgun/super

/obj/item/weapon/gun/pill
	name = "pill gun"
	desc = "A spring loaded rifle designed to fit pills, designed to inject patients from a distance."
	icon = 'icons/obj/items/weapons/guns/effect.dmi'
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_SLOW
	throw_range = 10
	force = 4.0

	current_mag = /obj/item/ammo_magazine/internal/pillgun

	flags_gun_features = GUN_INTERNAL_MAG

	matter = list("metal" = 2000)

/obj/item/weapon/gun/pill/attackby(obj/item/I as obj, mob/user as mob)
	if(I.loc == current_mag)
		return

	if(!istype(I, /obj/item/reagent_container/pill))
		return

	if(current_mag.ammo_position >= current_mag.max_rounds)
		to_chat(user, SPAN_WARNING("[src] is at maximum ammo capacity!"))
		return

	user.drop_inv_item_on_ground(I)
	I.forceMove(current_mag)

/obj/item/weapon/gun/pill/update_icon()
	. = ..()
	if(!current_mag || !current_mag.ammo_position)
		icon_state = base_icon
	else
		icon_state = base_icon + "_e"

/obj/item/weapon/gun/pill/unload(mob/user, reload_override, drop_override, loc_override)
	var/obj/item/ammo_magazine/internal/pillgun/internal_mag = current_mag

	if(!istype(internal_mag))
		return

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	var/obj/item/reagent_container/pill/pill_to_use = LAZYACCESS(internal_mag.pills, 1)

	if(!pill_to_use)
		return

	pill_to_use.forceMove(get_turf(H.loc))
	H.put_in_active_hand(pill_to_use)

/obj/item/weapon/gun/pill/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	if(!able_to_fire(user))
		return

	if(!current_mag.ammo_position)
		click_empty(user)
		return

	if(!istype(current_mag, /obj/item/ammo_magazine/internal/pillgun))
		return

	var/obj/item/ammo_magazine/internal/pillgun/internal_mag = current_mag
	var/obj/item/reagent_container/pill/pill_to_use = LAZYACCESS(internal_mag.pills, 1)

	if(QDELETED(pill_to_use))
		click_empty(user)
		return

	var/obj/item/projectile/pill/proj = new /obj/item/projectile/pill(src, user, src)
	proj.generate_bullet(GLOB.ammo_list[/datum/ammo/pill], user, 0, NO_FLAGS)

	pill_to_use.forceMove(proj)
	proj.source_pill = pill_to_use

	playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)

	proj.fire_at(target, user, src)

/datum/ammo/pill
	name = "syringe"
	icon_state = "syringe"
	flags_ammo_behavior = AMMO_IGNORE_ARMOR|AMMO_ALWAYS_FF

	damage = 0

/datum/ammo/pill/on_hit_mob(mob/M, obj/item/projectile/proj)
	. = ..()

	if(!ishuman(M))
		return

	if(!istype(proj, /obj/item/projectile/pill))
		return

	var/obj/item/projectile/pill/pill_projectile = proj

	if(QDELETED(pill_projectile.source_pill))
		pill_projectile.source_pill = null
		return

	var/datum/reagents/pill_reagents = pill_projectile.source_pill.reagents

	pill_reagents.trans_to(M, pill_reagents.total_volume)

/obj/item/projectile/pill
	var/obj/item/reagent_container/pill/source_pill

/obj/item/projectile/pill/Destroy()
	. = ..()
	source_pill = null


//////////////////
/////ENGI KIT/////
//////////////////
/obj/item/engi_upgrade_kit
	name = "engineering upgrade kit"
	desc = "A kit used to upgrade the defenses of an engineer's sentry. Back in 1980 when the machines tried to break free, it was a single android who laid them low. Now their technology is used widely on the rim."

	icon = 'icons/obj/items/storage.dmi'
	icon_state = "upgradekit"

/obj/item/engi_upgrade_kit/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/engi_upgrade_kit/update_icon()
	overlays.Cut()
	if(prob(20))
		icon_state = "upgradekit_alt"
		desc = "A kit used to upgrade the defenses of an engineer's sentry. Do you... enjoy violence? Of course you do. It's a part of you."
	. = ..()

/obj/item/engi_upgrade_kit/afterattack(atom/target, mob/user, proximity_flag, click_parameters, proximity)
	if(!ishuman(user))
		return ..()

	if(!istype(target, /obj/item/defenses/handheld))
		return ..()

	var/obj/item/defenses/handheld/D = target
	var/mob/living/carbon/human/H = user

	var/list/upgrade_list = D.get_upgrade_list()
	if(!length(upgrade_list))
		return

	var/chosen_upgrade = show_radial_menu(user, target, upgrade_list, require_near = TRUE)
	if(QDELETED(D) || !upgrade_list[chosen_upgrade])
		return

	if((user.get_active_hand()) != src)
		to_chat(user, SPAN_WARNING("You must be holding the [src] to upgrade \the [D]!"))
		return

	var/type_to_change_to = D.upgrade_string_to_type(chosen_upgrade)

	if(!type_to_change_to)
		return

	H.drop_inv_item_on_ground(D)
	qdel(D)

	D = new type_to_change_to()
	H.put_in_any_hand_if_possible(D)

	if(D.loc != H)
		D.forceMove(H.loc)

	H.drop_held_item(src)

	user.count_statistic_stat(STATISTICS_UPGRADE_TURRETS)

	qdel(src)
/////ADDITIONAL SUPPORT/////


//////////////////
/////IMPLANTS/////
//////////////////
/obj/item/storage/box/implant
	name = "implant box"
	desc = "A sterile metal lockbox housing hypodermic implant injectors."
	icon_state = "implantbox"
	use_sound = "toolbox"
	storage_slots = 5
	can_hold = list(/obj/item/device/implanter)
	w_class = SIZE_SMALL

/obj/item/device/implanter
	name = "implanter"
	desc = "An injector that drives an implant into your body. The injection stings quite badly."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "implanter"

	w_class = SIZE_SMALL

	var/implant_type
	var/uses = 1
	var/implant_time = 3 SECONDS
	var/implant_string = "Awesome."

/obj/item/device/implanter/update_icon()
	if(!uses)
		icon_state = "[initial(icon_state)]0"
		return

	icon_state = initial(icon_state)

/obj/item/device/implanter/attack(mob/living/M, mob/living/user)
	if(!uses || !implant_type)
		return ..()

	if(LAZYISIN(M.implants, implant_type))
		to_chat(user, SPAN_WARNING("[M] already have this implant!"))
		return

	if(length(M.implants) >= M.max_implants)
		to_chat(user, SPAN_WARNING("[M] can't take any more implants!"))
		return

	var/self_inject = TRUE
	if(M != user)
		self_inject = FALSE
		if(!do_after(user, implant_time, INTERRUPT_ALL, BUSY_ICON_GENERIC, M, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			return

	user.count_statistic_stat(STATISTICS_IMPLANTS_IMPLANTED)

	implant(M, self_inject)

/obj/item/device/implanter/attack_self(mob/user)
	..()

	if(!uses || !implant_type)
		return ..()

	if(LAZYISIN(user.implants, implant_type))
		to_chat(user, SPAN_WARNING("You already have this implant!"))
		return

	if(length(user.implants) >= user.max_implants)
		to_chat(user, SPAN_WARNING("You can't take any more implants!"))
		return

	user.count_statistic_stat(STATISTICS_IMPLANTS_IMPLANTED)

	implant(user, TRUE)

/obj/item/device/implanter/proc/implant(mob/M, self_inject)
	if(uses <= 0)
		return

	if(LAZYISIN(M.implants, implant_type))
		QDEL_NULL(M.implants[implant_type])

	if(self_inject)
		to_chat(M, SPAN_NOTICE("You implant yourself with \the [src]. You feel [implant_string]"))
	else
		to_chat(M, SPAN_NOTICE("You've been implanted with \the [src]. You feel [implant_string]"))

	playsound(src, 'sound/items/air_release.ogg', 75, TRUE)
	var/obj/item/device/internal_implant/I = new implant_type(M)
	LAZYSET(M.implants, implant_type, I)
	I.on_implanted(M)
	uses = max(uses - 1, 0)
	if(!uses)
		garbage = TRUE
	update_icon()

/obj/item/device/internal_implant
	name = "implant"
	desc = "An implant, usually delivered with an implanter."
	icon_state = "implant"

	var/mob/living/host

/obj/item/device/internal_implant/proc/on_implanted(mob/living/M)
	SHOULD_CALL_PARENT(TRUE)
	host = M

/obj/item/device/internal_implant/Destroy()
	host = null
	return ..()

/obj/item/device/implanter/nvg
	name = "nightvision implant"
	desc = "This implant will give you night vision. These implants get damaged on death."
	implant_type = /obj/item/device/internal_implant/nvg
	implant_string = "your pupils dilating to unsettling levels."

/obj/item/device/internal_implant/nvg
	var/implant_health = 2

/obj/item/device/internal_implant/nvg/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_HUMAN_POST_UPDATE_SIGHT, PROC_REF(give_nvg))
	RegisterSignal(M, COMSIG_MOB_DEATH, PROC_REF(remove_health))
	RegisterSignal(M, COMSIG_MOB_RECALCULATE_CLIENT_COLOR, PROC_REF(apply_nvgvision_handler))
	apply_nvgvision_handler(M)
	give_nvg(M)

/obj/item/device/internal_implant/nvg/proc/remove_health(mob/living/M)
	SIGNAL_HANDLER
	implant_health--
	if(implant_health <= 0)
		UnregisterSignal(M, list(
			COMSIG_HUMAN_POST_UPDATE_SIGHT,
			COMSIG_MOB_RECALCULATE_CLIENT_COLOR,
			COMSIG_MOB_DEATH
		))
		M.update_client_color_matrices(0.1 SECONDS)
		to_chat(M, SPAN_WARNING("Everything feels a lot darker."))
	else
		to_chat(M, SPAN_WARNING("You feel the effects of the nightvision implant waning."))

/obj/item/device/internal_implant/nvg/proc/give_nvg(mob/living/M)
	SIGNAL_HANDLER
	M.see_invisible = SEE_INVISIBLE_MINIMUM

/obj/item/device/internal_implant/nvg/proc/apply_nvgvision_handler(mob/living/M)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(apply_nvgvision), M), 0.1 SECONDS)

/obj/item/device/internal_implant/nvg/proc/apply_nvgvision(mob/living/M)
	if(!M.client) //Shouldn't happen but can't hurt to check.
		return

	var/base_colour
	if(!M.client.color) //No set client colour.
		base_colour = color_matrix_saturation(1.35) //Crank up the saturation and get ready to party.
	else if(istext(M.client.color)) //Hex colour string.
		base_colour = color_matrix_multiply(color_matrix_from_string(M.client.color), color_matrix_saturation(1.35))
	else //Colour matrix.
		base_colour = color_matrix_multiply(M.client.color, color_matrix_saturation(1.35))

	var/list/colours = list(
		"greened" = color_matrix_multiply(base_colour, color_matrix_from_string("#2dc092")),
		"green" = color_matrix_multiply(base_colour, color_matrix_from_string("#2dc404")),
		"greenid" = color_matrix_multiply(base_colour, color_matrix_from_string("#2dc829"))
		)

	//Animate the victim's client.
	animate(M.client, color = colours["greened"], time = 60 SECONDS, loop = -1)
	animate(color = colours["green"], time = 60 SECONDS)
	animate(color = colours["greenid"], time = 60 SECONDS)
	animate(color = colours["greened"], time = 60 SECONDS)
	animate(color = colours["green"], time = 60 SECONDS)

/obj/item/device/implanter/rejuv
	name = "rejuvenation implant"
	desc = "This implant will automatically activate at the brink of death. When activated, it will expend itself, greatly healing you, and giving you a stimulant that speeds you up significantly and dulls all pain."
	implant_type = /obj/item/device/internal_implant/rejuv
	implant_string = "something beating next to your heart." //spooky second heart deep lore

/obj/item/device/internal_implant/rejuv
	/// Assoc list where the keys are the reagent ids of the reagents to be injected and the values are the amount to be injected
	var/list/stimulant_to_inject = list(
		"speed_stimulant" = 0.5,
		"redemption_stimulant" = 3,
	)

/obj/item/device/internal_implant/rejuv/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	), PROC_REF(check_revive))

/obj/item/device/internal_implant/rejuv/proc/check_revive(mob/living/M, list/damagedata, damagetype)
	SIGNAL_HANDLER
	if((M.health - damagedata["damage"]) <= HEALTH_THRESHOLD_CRIT)
		UnregisterSignal(M, list(
			COMSIG_MOB_TAKE_DAMAGE,
			COMSIG_HUMAN_TAKE_DAMAGE,
			COMSIG_XENO_TAKE_DAMAGE
		))

		INVOKE_ASYNC(src, PROC_REF(revive), M)

/obj/item/device/internal_implant/rejuv/proc/revive(mob/living/M)
	SEND_SIGNAL(M, COMSIG_HUMAN_REVIVED)
	M.track_revive()
	M.heal_all_damage()
	M.count_statistic_stat(STATISTICS_REVIVED_BY_IMPLANT)
	for(var/i in stimulant_to_inject)
		var/reagent_id = i
		var/injection_amt = stimulant_to_inject[i]
		M.reagents.add_reagent(reagent_id, injection_amt)

/obj/item/device/implanter/agility
	name = "agility implant"
	desc = "This implant will make you more agile, allowing you to vault over structures extremely quickly and allowing you to fireman carry other people."
	implant_type = /obj/item/device/internal_implant/agility
	implant_string = "your heartrate increasing significantly and your pupils dilating."

/obj/item/device/implanter/agility/get_examine_text(mob/user)
	. = ..()
	. += "To fireman carry someone, aggresive-grab them and drag their sprite to yours.<br>"

/obj/item/device/internal_implant/agility
	var/move_delay_mult  = 0.94
	var/climb_delay_mult = 0.20
	var/carry_delay_mult = 0.25
	var/grab_delay_mult  = 0.30

/obj/item/device/internal_implant/agility/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_HUMAN_POST_MOVE_DELAY, PROC_REF(handle_movedelay))
	RegisterSignal(M, COMSIG_LIVING_CLIMB_STRUCTURE, PROC_REF(handle_climbing))
	RegisterSignal(M, COMSIG_HUMAN_CARRY, PROC_REF(handle_fireman))
	RegisterSignal(M, COMSIG_MOB_GRAB_UPGRADE, PROC_REF(handle_grab))

/obj/item/device/internal_implant/agility/proc/handle_movedelay(mob/living/M, list/movedata)
	SIGNAL_HANDLER
	movedata["move_delay"] *= move_delay_mult

/obj/item/device/internal_implant/agility/proc/handle_climbing(mob/living/M, list/climbdata)
	SIGNAL_HANDLER
	climbdata["climb_delay"] *= climb_delay_mult

/obj/item/device/internal_implant/agility/proc/handle_fireman(mob/living/M, list/carrydata)
	SIGNAL_HANDLER
	carrydata["carry_delay"] *= carry_delay_mult
	return COMPONENT_CARRY_ALLOW

/obj/item/device/internal_implant/agility/proc/handle_grab(mob/living/M, list/grabdata)
	SIGNAL_HANDLER
	grabdata["grab_delay"] *= grab_delay_mult
	return TRUE

/obj/item/device/implanter/subdermal_armor
	name = "subdermal armor implant"
	desc = "This implant will grant you armor under the skin, reducing incoming damage and strengthening bones."
	implant_type = /obj/item/device/internal_implant/subdermal_armor
	implant_string = "your skin becoming significantly harder.. That's going to hurt in a decade."

/obj/item/device/internal_implant/subdermal_armor
	var/burn_damage_mult = 0.9
	var/brute_damage_mult = 0.85
	var/bone_break_mult = 0.25

/obj/item/device/internal_implant/subdermal_armor/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	), PROC_REF(handle_damage))
	RegisterSignal(M, COMSIG_HUMAN_BONEBREAK_PROBABILITY, PROC_REF(handle_bonebreak))

/obj/item/device/internal_implant/subdermal_armor/proc/handle_damage(mob/living/M, list/damagedata, damagetype)
	SIGNAL_HANDLER
	if(damagetype == BRUTE)
		damagedata["damage"] *= brute_damage_mult
	else if(damagetype == BURN)
		damagedata["damage"] *= burn_damage_mult

/obj/item/device/internal_implant/subdermal_armor/proc/handle_bonebreak(mob/living/M, list/bonedata)
	SIGNAL_HANDLER
	bonedata["bonebreak_probability"] *= bone_break_mult


//////////////////////////
/////ADVANCED WEAPONS/////
//////////////////////////
/obj/item/advanced_weapon_kit
	name = "advanced weapon kit"
	desc = "It seems to be a kit to choose an advanced weapon"

	icon = 'icons/obj/items/storage.dmi'
	icon_state = "advkit"

	var/gun_type = /obj/item/weapon/gun/shotgun
	var/ammo_type = /obj/item/ammo_magazine/handful/shotgun
	var/ammo_type_count = 1


/obj/item/advanced_weapon_kit/attack_self(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user

	new gun_type(get_turf(H))
	for (var/i in 1 to ammo_type_count)
		new ammo_type(get_turf(H))

	qdel(src)

/obj/item/advanced_weapon_kit/heavyshotgun
	name = "advanced shotgun kit"
	desc = "It seems to be a kit to choose an advanced weapon"

	icon_state = "pro_case_large"

	gun_type = /obj/item/weapon/gun/shotgun/type23/breacher
	ammo_type = /obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath
	ammo_type_count = 3

/obj/item/advanced_weapon_kit/railgun
	name = "advanced railgun kit"
	desc = "It seems to be a kit to choose an advanced weapon"

	icon_state = "pro_case_large"

	gun_type = /obj/item/weapon/gun/rifle/railgun
	ammo_type = /obj/item/ammo_magazine/railgun
	ammo_type_count = 3


/obj/item/weapon/gun/rifle/railgun
	name = "Railgun"
	desc = "A poggers hellbliterator"
	icon_state = "m42a"
	item_state = "m42a"
	unacidable = TRUE
	indestructible = 1
	faction_to_get = FACTION_MARINE

	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/railgun
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list()
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY
	map_specific_decoration = TRUE
	actions_types = list(/datum/action/item_action/railgun_start_charge, /datum/action/item_action/railgun_abort_charge)

	// Hellpullverizer ready or not??
	var/charged = FALSE

/obj/item/weapon/gun/rifle/railgun/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/rifle/railgun/able_to_fire()
	return charged

/obj/item/weapon/gun/rifle/railgun/proc/start_charging(user)
	if(charged)
		to_chat(user, SPAN_WARNING("Your railgun is already charged."))
		return

	to_chat(user, SPAN_WARNING("You start charging your railgun."))
	if(!do_after(user, 8 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_WARNING("You stop charging your railgun."))
		return

	to_chat(user, SPAN_WARNING("You finish charging your railgun."))

	charged = TRUE
	return

/obj/item/weapon/gun/rifle/railgun/on_enter_storage(obj/item/storage/storage)
	if(charged)
		abort_charge()
	. = ..()

/obj/item/weapon/gun/rifle/railgun/proc/abort_charge(user)
	if(!charged)
		return
	charged = FALSE
	if(user)
		to_chat(user, SPAN_WARNING("You depower your railgun to store it."))
	return

/obj/item/weapon/gun/rifle/railgun/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/railgun/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*5
	burst_amount = BURST_AMOUNT_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/railgun/unique_action(mob/user)
	if(in_chamber)
		to_chat(user, SPAN_WARNING("There's already a round chambered!"))
		return

	var/result = load_into_chamber()
	if(result)
		to_chat(user, SPAN_WARNING("You run the bolt on [src], chambering a round!"))
	else
		to_chat(user, SPAN_WARNING("You run the bolt on [src], but it's out of rounds!"))

/obj/item/weapon/gun/rifle/railgun/reload_into_chamber(mob/user)
	charged = FALSE
	in_chamber = null // blackpilled again
	return null

/datum/action/item_action/railgun_start_charge
	name = "Start Charging"

/datum/action/item_action/railgun_start_charge/action_activate()
	if(target)
		var/obj/item/weapon/gun/rifle/railgun/R = target
		R.start_charging(owner)

/datum/action/item_action/railgun_abort_charge
	name = "Abort Charge"

/datum/action/item_action/railgun_abort_charge/action_activate()
	if(target)
		var/obj/item/weapon/gun/rifle/railgun/R = target
		R.abort_charge(owner)

/obj/item/ammo_magazine/railgun
	name = "\improper Railgun Ammunition (5 rounds)"
	desc = "A magazine ammo for the poggers Railgun."
	caliber = "14mm"
	icon_state = "m42c" //PLACEHOLDER
	w_class = SIZE_MEDIUM
	max_rounds = 5
	ammo_preset = list(/datum/ammo/bullet/sniper/railgun)
	gun_type = /obj/item/weapon/gun/rifle/railgun

/datum/ammo/bullet/sniper/railgun
	name = "railgun bullet"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER
	accurate_range_min = 4

	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 32
	max_range = 32
	scatter = 0
	damage = 3*100
	penetration= ARMOR_PENETRATION_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	damage_falloff = 0

/datum/ammo/bullet/sniper/railgun/on_hit_mob(mob/M, _unused)
	if(isxeno(M))
		M.Slow(1)
