#define MUTATOR_COST_CHEAP 1
#define MUTATOR_COST_MODERATE 2
#define MUTATOR_COST_EXPENSIVE 3
#define MUTATOR_COST_VERY_EXPENSIVE 4
#define MUTATOR_COST_KEYSTONE 6

#define MUTATOR_GAIN_PER_QUEEN_LEVEL 1
#define MUTATOR_GAIN_PER_XENO_LEVEL 1
//Individual mutator
/datum/xeno_mutation
	var/name = "Mutator name" //Name of the mutator, should be short but informative
	var/description = "Mutator description" //Description to be displayed on purchase
	var/flavor_description = null // Optional flavor text to be shown. Semi-OOC
	var/cost = MUTATOR_COST_CHEAP //How expensive the mutator is
	var/required_level = 0 //Level of xeno upgrade required to unlock
	var/unique = TRUE //True if you can only buy it once
	var/death_persistent = FALSE //True if the mutators persists after Queen death (aka, mostly for "once ever" mutators)
	var/hive_only = FALSE //Hive-only mutators
	var/individual_only = FALSE //Individual-only mutators
	var/xeno_strain = FALSE
	var/keystone = FALSE //Xeno can only take one Keystone mutator
	var/flaw = FALSE //Flaws give you points back, but you can only take one of them
	var/list/caste_whitelist = list() //List of the only castes that can buy this mutator

	// Both should be set to null when their use is not necessary.
	/// A list of PATHS of actions that need to be removed when a xeno takes the mutator.
	var/list/mutation_actions_to_remove  //Actions to remove when the mutator is added
	/// A list of PATHS of actions to be ADDED when the Xeno takes the mutator.
	var/list/mutation_actions_to_add	 //Actions to add when the mutator is added

	// Type of the behavior datum to add
	var/behavior_delegate_type = null // Specify this on subtypes

/datum/xeno_mutation/proc/apply_mutator(datum/mutator_set/mutator_set)
	if(!mutator_set.can_purchase_mutator(src) || (!mutator_set.can_purchase_strain(src) && xeno_strain) || !istype(mutator_set))
		return FALSE
	mutator_set.remaining_points -= cost
	mutator_set.purchased_mutators += name
	if(istype(mutator_set, /datum/mutator_set/individual_mutations))
		var/datum/mutator_set/individual_mutations/IM = mutator_set
		if(IM.xeno)
			IM.xeno.faction.faction_ui.update_xeno_info()

	return TRUE

// Sets up actions for when a mutator is taken
// Must be called at the end of any mutator that changes available actions
// (read: Strains) apply_mutator proc for the mutator to work correctly.
/datum/xeno_mutation/proc/mutator_update_actions(mob/living/carbon/xenomorph/xeno)
	if(mutation_actions_to_remove)
		for(var/action_path in mutation_actions_to_remove)
			remove_action(xeno, action_path)
	if(mutation_actions_to_add)
		for(var/action_path in mutation_actions_to_add)
			give_action(xeno, action_path)

// Substitutes the existing behavior delegate for the strain-defined one.
/datum/xeno_mutation/proc/apply_behavior_holder(mob/living/carbon/xenomorph/xeno)
	if(!istype(xeno))
		log_debug("Null mob handed to apply_behavior_holder. Tell the devs.")
		log_admin("Null mob handed to apply_behavior_holder. Tell the devs.")
		message_admins("Null mob handed to apply_behavior_holder. Tell the devs.")

	if(behavior_delegate_type)
		if(xeno.behavior_delegate)
			qdel(xeno.behavior_delegate)
		xeno.behavior_delegate = new behavior_delegate_type()
		xeno.behavior_delegate.bound_xeno = xeno
		xeno.behavior_delegate.add_to_xeno()


/datum/xeno_mutation/strain
	xeno_strain = TRUE
	individual_only = TRUE


//////////////////////
//KEYSTONE BIG BUFFS//
//////////////////////

//DECREASE ABILITY COLDOWNS
/datum/xeno_mutation/mutator/decrease_cooldown
	name = LANGUAGE_MUTATION_COOLDOWN
	description = LANGUAGE_MUTATION_COOLDOWN_DESC
	cost = MUTATOR_COST_KEYSTONE
	individual_only = TRUE
	keystone = TRUE

/datum/xeno_mutation/mutator/decrease_cooldown/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.decrease_cooldown = TRUE
	mutator_set.recalculate_stats(description)

//ADDITIONAL REGENERATE
/datum/xeno_mutation/mutator/regeneration
	name = LANGUAGE_MUTATION_REGENERATE
	description = LANGUAGE_MUTATION_REGENERATE_DESC
	cost = MUTATOR_COST_KEYSTONE
	individual_only = TRUE
	keystone = TRUE

/datum/xeno_mutation/mutator/regeneration/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.regeneration = TRUE
	mutator_set.recalculate_stats(description)

//VAMPIRISM, ON ATACK REGENERATE HEALTH
/datum/xeno_mutation/mutator/vampirism
	name = LANGUAGE_MUTATION_VAMPIRISM
	description = LANGUAGE_MUTATION_VAMPIRISM_DESC
	cost = MUTATOR_COST_KEYSTONE
	individual_only = TRUE
	keystone = TRUE

/datum/xeno_mutation/mutator/vampirism/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.vampirism = TRUE
	mutator_set.recalculate_stats(description)

//BONUS RESIST TO DAMAGE
/datum/xeno_mutation/mutator/additional_resist
	name = LANGUAGE_MUTATION_RESIST
	description = LANGUAGE_MUTATION_RESIST_DESC
	cost = MUTATOR_COST_KEYSTONE
	individual_only = TRUE
	keystone = TRUE

/datum/xeno_mutation/mutator/additional_resist/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.additional_resist = TRUE
	mutator_set.damage_income_modifier -= 0.25
	mutator_set.recalculate_stats(description)

//BONUS TO MUTATORS
/datum/xeno_mutation/mutator/bonus_mutators
	name = LANGUAGE_MUTATION_BONUS
	description = LANGUAGE_MUTATION_BONUS_DESC
	cost = MUTATOR_COST_KEYSTONE
	individual_only = TRUE
	keystone = TRUE

/datum/xeno_mutation/mutator/bonus_mutators/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.bonus_mutators = 2
	mutator_set.recalculate_stats(description)

//ABLE BUY MULTIPLY ALL MUTATOS
/datum/xeno_mutation/mutator/mutators_mult
	name = LANGUAGE_MUTATION_REPURCHASE
	description = LANGUAGE_MUTATION_REPURCHASE_DESC
	cost = MUTATOR_COST_KEYSTONE
	individual_only = TRUE
	keystone = TRUE

/datum/xeno_mutation/mutator/mutators_mult/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.mutators_mult = TRUE
	mutator_set.recalculate_stats(description)

//MAKE YOUR CLAW TOXIC
/datum/xeno_mutation/mutator/build_limit
	name = LANGUAGE_MUTATION_SPEC_STR_ADD
	description = LANGUAGE_MUTATION_SPEC_STR_ADD_DESC
	cost = MUTATOR_COST_KEYSTONE
	individual_only = TRUE
	keystone = TRUE

/datum/xeno_mutation/mutator/build_limit/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.special_structures_multiplier += 1
	mutator_set.recalculate_stats(description)

//MAKE YOUR CLAW TOXIC
/datum/xeno_mutation/mutator/acid_claws
	name = LANGUAGE_MUTATION_ACID_CLAWS
	description = LANGUAGE_MUTATION_ACID_CLAWS_DESC
	cost = MUTATOR_COST_KEYSTONE
	individual_only = TRUE
	keystone = TRUE

/datum/xeno_mutation/mutator/acid_claws/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.acid_boost_level += 1
	mutator_set.damage_multiplier += 0.25
	mutator_set.acid_claws = TRUE //turns claws acid, damage is calcualted elsewhere
	mutator_set.recalculate_stats(description)

/////////////////////////////
//END OF KEYSTONE BIG BUFFS//
/////////////////////////////


//////////////
//BASE STATS//
//////////////

//HEALTH
/datum/xeno_mutation/mutator/health
	name = LANGUAGE_MUTATION_HEALTH
	description = LANGUAGE_MUTATION_HEALTH_DESC
	cost = MUTATOR_COST_CHEAP
	unique = FALSE

/datum/xeno_mutation/mutator/health/apply_mutator(datum/mutator_set/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.health_multiplier += 0.05 * mutator_set.bonus_mutators
	mutator_set.recalculate_stats(description)

//PLASMA
/datum/xeno_mutation/mutator/plasma
	name = LANGUAGE_MUTATION_PLASMA
	description = LANGUAGE_MUTATION_PLASMA_DESC
	cost = MUTATOR_COST_CHEAP
	unique = FALSE

/datum/xeno_mutation/mutator/plasma/apply_mutator(datum/mutator_set/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.plasma_multiplier += 0.05 * mutator_set.bonus_mutators
	mutator_set.recalculate_stats(description)

//DAMAGE
/datum/xeno_mutation/mutator/damage
	name = LANGUAGE_MUTATION_DAMAGE
	description = LANGUAGE_MUTATION_DAMAGE_DESC
	cost = MUTATOR_COST_MODERATE
	unique = FALSE

/datum/xeno_mutation/mutator/damage/apply_mutator(datum/mutator_set/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.damage_multiplier += 0.1 * mutator_set.bonus_mutators
	mutator_set.recalculate_stats(description)


//ARMOR
/datum/xeno_mutation/mutator/armor
	name = LANGUAGE_MUTATION_ARMOR
	description = LANGUAGE_MUTATION_ARMOR_DESC
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE

/datum/xeno_mutation/mutator/armor/apply_mutator(datum/mutator_set/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.armor += 2.5 * mutator_set.bonus_mutators
	mutator_set.armor_multiplier += 0.10 * mutator_set.bonus_mutators
	mutator_set.recalculate_stats(description)


//SPEED
/datum/xeno_mutation/mutator/speed
	name = LANGUAGE_MUTATION_SPEED
	description = LANGUAGE_MUTATION_SPEED_DESC
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE

/datum/xeno_mutation/mutator/speed/apply_mutator(datum/mutator_set/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.speed_multiplier -= 0.05 * mutator_set.bonus_mutators
	mutator_set.recalculate_stats(description)

//ACID
/datum/xeno_mutation/mutator/acid
	name = LANGUAGE_MUTATION_ACID
	description = LANGUAGE_MUTATION_ACID_DESC
	cost = MUTATOR_COST_MODERATE
	unique = TRUE
	caste_whitelist = list("Burrower", "Drone", "Hivelord", "Praetorian", "Queen", "Sentinel", "Spitter") //Only for acid classes, except for Boiler

/datum/xeno_mutation/mutator/acid/apply_mutator(datum/mutator_set/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.acid_boost_level += 1 * mutator_set.bonus_mutators //acid is one step stronger
	mutator_set.recalculate_everything(description)

//PHEROMONES
/datum/xeno_mutation/mutator/pheromones
	name = LANGUAGE_MUTATION_PHEROMONES
	description = LANGUAGE_MUTATION_PHEROMONES_DESC
	cost = MUTATOR_COST_MODERATE
	unique = TRUE
	caste_whitelist = list("Carrier", "Drone", "Hivelord", "Praetorian", "Queen") //Only for pheromone-givers

/datum/xeno_mutation/mutator/pheromones/apply_mutator(datum/mutator_set/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.pheromones_boost_level += 1 * mutator_set.bonus_mutators
	mutator_set.recalculate_pheromones(description)

//WEEDS
/datum/xeno_mutation/mutator/hardy_weeds
	name = LANGUAGE_MUTATION_WEEDS
	description = LANGUAGE_MUTATION_WEEDS_DESC
	cost = MUTATOR_COST_KEYSTONE
	unique = TRUE
	individual_only = TRUE
	caste_whitelist = list("Burrower", "Carrier", "Drone", "Hivelord", "Queen") //Only for weed-layers

/datum/xeno_mutation/mutator/hardy_weeds/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.weed_boost_level += 2 * mutator_set.bonus_mutators
	mutator_set.recalculate_actions(description)

//TACKLE
/datum/xeno_mutation/mutator/better_tackle
	name = LANGUAGE_MUTATION_TACKLE
	description = LANGUAGE_MUTATION_TACKLE_DESC
	cost = MUTATOR_COST_VERY_EXPENSIVE
	unique = TRUE

/datum/xeno_mutation/mutator/better_tackle/apply_mutator(datum/mutator_set/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.tackle_chance_multiplier += 0.2 * mutator_set.bonus_mutators
	mutator_set.tackle_strength_bonus += 1 * mutator_set.bonus_mutators
	mutator_set.recalculate_stats(description)


////////
//HIVE//
////////

//LEADERS
/datum/xeno_mutation/mutator/more_leaders
	name = LANGUAGE_MUTATION_LEADERS
	description = LANGUAGE_MUTATION_LEADERS_DESC
	cost = MUTATOR_COST_VERY_EXPENSIVE
	unique = TRUE
	hive_only = TRUE

/datum/xeno_mutation/mutator/more_leaders/apply_mutator(datum/mutator_set/hive_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.leader_count_boost += 3
	mutator_set.recalculate_hive(description)

//EVOLVE
/datum/xeno_mutation/mutator/faster_maturation
	name = LANGUAGE_MUTATION_MATURATION
	description = LANGUAGE_MUTATION_MATURATION_DESC
	cost = MUTATOR_COST_VERY_EXPENSIVE
	unique = TRUE
	hive_only = TRUE
	keystone = TRUE

/datum/xeno_mutation/mutator/faster_maturation/apply_mutator(datum/mutator_set/hive_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.maturation_multiplier -= 0.2
	mutator_set.recalculate_maturation(description)

//TIER SLOTS
/datum/xeno_mutation/mutator/more_tier_slots
	name = LANGUAGE_MUTATION_MORE_SLOTS
	description = LANGUAGE_MUTATION_MORE_SLOTS_DESC
	cost = MUTATOR_COST_VERY_EXPENSIVE
	unique = TRUE
	hive_only = TRUE

/datum/xeno_mutation/mutator/more_tier_slots/apply_mutator(datum/mutator_set/hive_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return
	mutator_set.tier_slot_multiplier -= 0.2
	mutator_set.recalculate_hive(description)

//DEF STRUCT
/datum/xeno_mutation/mutator/upgreded_defens_struct
	name = LANGUAGE_MUTATION_DEFENSIVE
	description = LANGUAGE_MUTATION_DEFENSIVE_DESC
	cost = MUTATOR_COST_VERY_EXPENSIVE
	unique = TRUE
	hive_only = TRUE
	var/list/constructions_to_add = list(
		/datum/resin_construction/resin_obj/resin_spike,
		/datum/resin_construction/resin_obj/acid_pillar
	)

	var/list/hivelord_constructions = list(
		/datum/resin_construction/resin_turf/wall/reflective
	)

	var/list/drone_constructions = list()

	var/list/queen_constructions = list(
		/datum/resin_construction/resin_obj/acid_pillar/strong,
		/datum/resin_construction/resin_turf/wall/reflective
	)

	var/list/queen_ovi_constructions = list(
		/datum/resin_construction/resin_obj/acid_pillar/strong,
		/datum/resin_construction/resin_turf/wall/reflective
	)

/datum/xeno_mutation/mutator/upgreded_defens_struct/apply_mutator(datum/mutator_set/hive_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return

	var/list/drone_abilities = drone_constructions + constructions_to_add
	for(var/i in drone_abilities)
		GLOB.resin_build_order_drone += i

	var/list/hivelord_abilities = hivelord_constructions + constructions_to_add
	for(var/i in hivelord_abilities)
		GLOB.resin_build_order_hivelord += i

	var/list/queen_abilities = queen_constructions + constructions_to_add
	for(var/i in queen_abilities)
		GLOB.resin_build_order_queen += i

	var/list/queen_ovi_abilities = queen_ovi_constructions + constructions_to_add
	for(var/i in queen_ovi_abilities)
		GLOB.resin_build_order_queen_ovi += i

	mutator_set.recalculate_hive(description)

/datum/xeno_mutation/mutator/upgreded_defens_struct/offensive
	name = LANGUAGE_MUTATION_OFFENSIVE
	description = LANGUAGE_MUTATION_OFFENSIVE_DESC
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE
	hive_only = TRUE
	constructions_to_add = list(
		/datum/resin_construction/resin_obj/shield_dispenser,
		/datum/resin_construction/resin_obj/grenade
	)

	hivelord_constructions = list(
		/datum/resin_construction/resin_obj/movable/thick_membrane,
		/datum/resin_construction/resin_obj/movable/thick_wall
	)

	drone_constructions = list(
		/datum/resin_construction/resin_obj/movable/wall,
		/datum/resin_construction/resin_obj/movable/membrane
	)

	queen_constructions = list(
		/datum/resin_construction/resin_obj/movable/wall,
		/datum/resin_construction/resin_obj/movable/membrane
	)

	queen_ovi_constructions = list(
		/datum/resin_construction/resin_obj/movable/thick_membrane,
		/datum/resin_construction/resin_obj/movable/thick_wall
	)

//SHIELD SLASH
/datum/xeno_mutation/mutator/shielding_slash
	name = LANGUAGE_MUTATION_SHIELD_SLASH
	description = LANGUAGE_MUTATION_SHIELD_SLASH_DESC

	var/stat_name = LANGUAGE_MUTATION_SHIELD_SLASH_STAT

	var/max_shield = 160
	var/shield_per_slash = 20

	cost = MUTATOR_COST_VERY_EXPENSIVE
	unique = TRUE
	hive_only = TRUE

	var/datum/faction/faction

/datum/xeno_mutation/mutator/shielding_slash/apply_mutator(datum/mutator_set/hive_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return

	faction = mutator_set.faction

	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, PROC_REF(give_shielding_slash))

	for(var/xeno in mutator_set.faction.totalMobs)
		give_shielding_slash(src, xeno)

	mutator_set.recalculate_hive(description)

/datum/xeno_mutation/mutator/shielding_slash/proc/give_shielding_slash(datum/source, mob/living/carbon/xenomorph/xeno)
	SIGNAL_HANDLER
	if(xeno.faction != faction)
		return

	xeno.AddComponent(/datum/component/shield_slash, max_shield, shield_per_slash, stat_name)
	to_chat(xeno, SPAN_XENODANGER(xeno.client.auto_lang(LANGUAGE_MUTATION_SHIELD_SLASH_MSG)))

//ENDURANCE
/datum/xeno_mutation/mutator/endurance
	name = LANGUAGE_MUTATION_ENDURACNE
	description = LANGUAGE_MUTATION_ENDURACNE_DESC

	cost = MUTATOR_COST_MODERATE
	unique = TRUE
	hive_only = TRUE

	/// Speed multiplier off weeds for xenomorphs
	var/offweed_speed_mult = 0.95

	/// Amount to heal xenos per second by if they're not on weeds
	var/heal_amt_per_second = AMOUNT_PER_TIME(50, 15 SECONDS)

	var/datum/faction/faction

/datum/xeno_mutation/mutator/endurance/apply_mutator(datum/mutator_set/hive_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return

	faction = mutator_set.faction

	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, PROC_REF(apply_tech))
	for(var/xeno in mutator_set.faction.totalMobs)
		apply_tech(src, xeno)

	mutator_set.recalculate_hive(description)

	START_PROCESSING(SSprocessing, src)

/datum/xeno_mutation/mutator/endurance/process(delta_time)
	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		var/turf/T = get_turf(xeno)
		if(!T.weeds)
			xeno.apply_damage(-(heal_amt_per_second*delta_time), BRUTE)

/datum/xeno_mutation/mutator/endurance/proc/apply_tech(datum/source, mob/living/carbon/xenomorph/xeno)
	SIGNAL_HANDLER
	RegisterSignal(xeno, COMSIG_XENO_MOVEMENT_DELAY, PROC_REF(handle_speed))

/datum/xeno_mutation/mutator/endurance/proc/handle_speed(mob/living/carbon/xenomorph/xeno, list/speeds)
	SIGNAL_HANDLER
	var/turf/T = get_turf(xeno)

	if(!T.weeds)
		speeds["speed"] *= offweed_speed_mult

//ACIDIC BLOOD
/datum/xeno_mutation/mutator/acidic_blood
	name = LANGUAGE_MUTATION_ACIDIC_BLOOD
	description = LANGUAGE_MUTATION_ACIDIC_BLOOD_DESC

	cost = MUTATOR_COST_MODERATE
	unique = TRUE
	hive_only = TRUE

	var/acid_damage_mult = 3

	var/datum/faction/faction

/datum/xeno_mutation/mutator/acidic_blood/apply_mutator(datum/mutator_set/hive_mutations/mutator_set)
	. = ..()
	if(. == FALSE)
		return

	faction = mutator_set.faction

	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, PROC_REF(register_component))

	for(var/xeno in mutator_set.faction.totalMobs)
		register_component(src, xeno)

	mutator_set.recalculate_hive(description)

/datum/xeno_mutation/mutator/acidic_blood/proc/register_component(datum/source, mob/living/carbon/xenomorph/xeno)
	SIGNAL_HANDLER
	if(xeno.faction == faction)
		RegisterSignal(xeno, COMSIG_XENO_DEAL_ACID_DAMAGE, PROC_REF(handle_acid_blood))

/datum/xeno_mutation/mutator/acidic_blood/proc/handle_acid_blood(mob/living/carbon/xenomorph/xeno, mob/target, list/damage)
	SIGNAL_HANDLER
	damage["damage"] *= acid_damage_mult



//////////////////
//MUTATORS DATUM//
//////////////////
/datum/mutator_set
	var/remaining_points = 2 //How many points the xeno / hive still has to spend on mutators
	var/list/purchased_mutators = list() //List of purchased mutators
	var/list/purchased_strains = list() //List of purchased strains

	//Variables that affect the xeno / all xenos of the hive:
	var/health_multiplier = 1.0
	var/plasma_multiplier = 1.0
	var/plasma_gain_multiplier = 1.0
	var/speed_multiplier = 0
	var/damage_multiplier = 1.0
	var/armor_multiplier = 1.0
	var/armor = 0
	var/acid_boost_level = 0
	var/pheromones_boost_level = 0
	var/weed_boost_level = 0

	var/tackle_chance_multiplier = 1.0
	var/tackle_strength_bonus = 0

	var/bonus_mutators = 1
	var/mutators_mult = FALSE
	var/special_structures_multiplier = 1.0
	var/need_weeds = TRUE

	var/mob/living/carbon/xenomorph/xeno
	var/datum/faction/faction

//Functions to be overloaded to call for when something gets updated on the xenos
/datum/mutator_set/proc/recalculate_everything(description, flavor_description = null)

/datum/mutator_set/proc/recalculate_stats(description, flavor_description = null)

/datum/mutator_set/proc/recalculate_actions(description, flavor_description = null)

/datum/mutator_set/proc/recalculate_pheromones(description, flavor_description = null)

/datum/mutator_set/proc/give_feedback(description, flavor_description = null)
	to_chat(xeno, SPAN_XENOANNOUNCE(xeno.client.auto_lang(description)))
	if(flavor_description != null)
		to_chat(xeno, SPAN_XENOLEADER(xeno.client.auto_lang(flavor_description)))
	xeno.xeno_jitter(15)

/datum/mutator_set/proc/purchase_mutator(datum/xeno_mutation/xeno_mutation)
	if(xeno_mutation.apply_mutator(src))
		log_mutator("[xeno.name] purchased [xeno_mutation]")
		to_chat(usr, usr.client.auto_lang(LANGUAGE_MUTATION_COMPLETED))
		return TRUE
	else
		to_chat(usr, usr.client.auto_lang(LANGUAGE_MUTATION_FAILED))
		return FALSE

/datum/mutator_set/proc/list_and_purchase_mutators()
	var/list/mutators_for_purchase = available_mutators()
	if(!length(mutators_for_purchase))
		to_chat(usr, usr.client.auto_lang(LANGUAGE_MUTATION_NO_MORE))
	var/pick = tgui_input_list(usr, usr.client.auto_lang(LANGUAGE_MUTATION_CHOICE), usr.client.auto_lang(LANGUAGE_MUTATION_CONFIRM), mutators_for_purchase)
	if(!pick)
		return FALSE
	var/datum/xeno_mutation/xeno_mutation = GLOB.xeno_mutator_list[mutators_for_purchase[pick]]
	if(alert(usr, "[usr.client.auto_lang(xeno_mutation.description)]\n\n[usr.client.auto_lang(LANGUAGE_MUTATION_PURCHASE)]", usr.client.auto_lang(LANGUAGE_MUTATION_CONFIRM), usr.client.auto_lang(LANGUAGE_YES), usr.client.auto_lang(LANGUAGE_NO)) != usr.client.auto_lang(LANGUAGE_YES))
		return
	purchase_mutator(xeno_mutation)

/datum/mutator_set/proc/can_purchase_mutator(datum/xeno_mutation/xeno_mutation)
	if(remaining_points < xeno_mutation.cost)
		return FALSE //mutator is too expensive
	if(xeno_mutation.unique && !mutators_mult)
		if(xeno_mutation.name in purchased_mutators)
			return FALSE //unique mutator already purchased
	if(xeno_mutation.keystone)
		for(var/name in purchased_mutators)
			if(GLOB.xeno_mutator_list[name].keystone)
				return FALSE //We already have a keystone mutator
	if(xeno_mutation.flaw)
		for(var/name in purchased_mutators)
			if(GLOB.xeno_mutator_list[name].flaw)
				return FALSE //We already have a flaw mutator
	return TRUE

//Lists mutators available for purchase
/datum/mutator_set/proc/available_mutators()
	var/list/can_purchase = list()

	for(var/str in GLOB.xeno_mutator_list)
		var/datum/xeno_mutation/xeno_mutation = GLOB.xeno_mutator_list[str]
		if(can_purchase_mutator(xeno_mutation))
			LAZYSET(can_purchase, "[xeno.client.auto_lang(str)] ([xeno_mutation.cost] [xeno.client.auto_lang(LANGUAGE_POINTS)])", str)
	return can_purchase

/datum/mutator_set/proc/list_and_purchase_strains()
	var/list/strains_for_purchase = available_strains()
	if(!length(strains_for_purchase))
		to_chat(usr, usr.client.auto_lang(LANGUAGE_MUTATION_NO_MORE))
	var/pick = tgui_input_list(usr, usr.client.auto_lang(LANGUAGE_MUTATION_CHOICE), usr.client.auto_lang(LANGUAGE_MUTATION_CONFIRM), strains_for_purchase)
	if(!pick)
		return FALSE
	var/datum/xeno_mutation/xeno_mutation = GLOB.xeno_strain_list[strains_for_purchase[pick]]
	if(alert(usr, "[usr.client.auto_lang(xeno_mutation.description)]\n\n[usr.client.auto_lang(LANGUAGE_MUTATION_PURCHASE)]", usr.client.auto_lang(LANGUAGE_MUTATION_CONFIRM), usr.client.auto_lang(LANGUAGE_YES), usr.client.auto_lang(LANGUAGE_NO)) != usr.client.auto_lang(LANGUAGE_YES))
		return
	purchase_mutator(xeno_mutation)

/datum/mutator_set/proc/can_purchase_strain(datum/xeno_mutation/xeno_mutation)
	if(xeno.mutation_type != initial(xeno.mutation_type))
		return FALSE
	if(remaining_points < xeno_mutation.cost)
		return FALSE //strain is too expensive
	if(xeno_mutation.unique)
		if(xeno_mutation.name in purchased_strains)
			return FALSE //unique strain already purchased
	if(xeno_mutation.keystone)
		for(var/name in purchased_strains)
			if(GLOB.xeno_strain_list[name].keystone)
				return FALSE //We already have a keystone strain
	if(xeno_mutation.flaw)
		for(var/name in purchased_strains)
			if(GLOB.xeno_strain_list[name].flaw)
				return FALSE //We already have a flaw strain
	return TRUE

//Lists strains available for purchase
/datum/mutator_set/proc/available_strains()
	var/list/can_purchase = list()

	for(var/str in GLOB.xeno_strain_list)
		var/datum/xeno_mutation/xeno_mutation = GLOB.xeno_strain_list[str]
		if(can_purchase_strain(xeno_mutation))
			LAZYSET(can_purchase, "[xeno.client.auto_lang(xeno_mutation.name)] ([xeno_mutation.cost] [xeno.client.auto_lang(LANGUAGE_POINTS)])", str)
	return can_purchase


////////////////////
//HIVE MUTATATIONS//
////////////////////
/datum/mutator_set/hive_mutations
	var/leader_count_boost = 0
	var/maturation_multiplier = 1.0
	var/tier_slot_multiplier = 1.0
	var/larva_gestation_multiplier = 1.0
	var/bonus_larva_spawn_chance = 0

/datum/mutator_set/hive_mutations/New(datum/faction/faction_to_set)
	faction = faction_to_set

/datum/mutator_set/hive_mutations/Destroy()
	if(faction)
		faction.mutators = null
		faction = null
	. = ..()

/datum/mutator_set/hive_mutations/list_and_purchase_mutators()
	if(!faction || !faction.living_xeno_queen)
		return //somehow Queen is not set but this function was called...
	if(faction.living_xeno_queen.is_dead())
		return //Dead xenos can't mutate!
	if(!faction.living_xeno_queen.ovipositor)
		to_chat(usr, usr.client.auto_lang(LANGUAGE_MUTATION_OVI))
		return
	var/list/mutators_for_purchase = available_mutators()
	if(!length(mutators_for_purchase))
		to_chat(usr, usr.client.auto_lang(LANGUAGE_MUTATION_NO_MORE))
	var/pick = tgui_input_list(usr, usr.client.auto_lang(LANGUAGE_MUTATION_CHOICE), usr.client.auto_lang(LANGUAGE_MUTATION_CONFIRM), mutators_for_purchase)
	if(!pick)
		return FALSE
	var/datum/xeno_mutation/xeno_mutation = GLOB.xeno_mutator_list[mutators_for_purchase[pick]]
	if(alert(usr, "[usr.client.auto_lang(xeno_mutation.description)]\n\n[usr.client.auto_lang(LANGUAGE_MUTATION_PURCHASE)]", usr.client.auto_lang(LANGUAGE_MUTATION_CONFIRM), usr.client.auto_lang(LANGUAGE_YES), usr.client.auto_lang(LANGUAGE_NO)) != usr.client.auto_lang(LANGUAGE_YES))
		return
	purchase_mutator(xeno_mutation)

/datum/mutator_set/hive_mutations/can_purchase_mutator(datum/xeno_mutation/xeno_mutation)
	. = ..()
	if(. == FALSE)
		return
	if(xeno_mutation.individual_only)
		return FALSE //We can't buy individual mutators on a Hive level
	return TRUE

//Called when the Queen dies
// This isn't currently used, but if anyone wants to, expect it to be broken because
// I haven't made any effort to integrate it into the new system (Fourkhan, 5/11/19)
/datum/mutator_set/hive_mutations/proc/reset_mutators()
	if(!length(purchased_mutators))
		//No mutators purchased, nothing to reset!
		return

	var/depowered = FALSE
	for(var/name in purchased_mutators)
		if(!GLOB.xeno_mutator_list[name].death_persistent)
			purchased_mutators -= name
			depowered = TRUE

	if(!depowered)
		return //We haven't lost anything

	leader_count_boost = 0
	maturation_multiplier = 1.0
	tier_slot_multiplier = 1.0
	larva_gestation_multiplier = 1.0
	bonus_larva_spawn_chance = 0

	health_multiplier = 1.0
	plasma_multiplier = 1.0
	plasma_gain_multiplier = 1.0
	speed_multiplier = 0
	damage_multiplier = 1.0
	armor_multiplier = 1.0
	armor = 0
	acid_boost_level = 0
	pheromones_boost_level = 0
	weed_boost_level = 0

	special_structures_multiplier = 1.0

	tackle_chance_multiplier = 1.0
	tackle_strength_bonus = 0

	reset_structure_list()

	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		xeno.recalculate_everything()
		to_chat(xeno, SPAN_XENOANNOUNCE(usr.client.auto_lang(LANGUAGE_MUTATION_QUEEN_DEATH)))
		playsound(xeno.loc, "alien_help", 25)
		xeno.xeno_jitter(15)

/datum/mutator_set/hive_mutations/proc/reset_structure_list()
	var/list/constructions_to_remove = list(
		/datum/resin_construction/resin_obj/resin_spike,
		/datum/resin_construction/resin_obj/acid_pillar,
		/datum/resin_construction/resin_obj/shield_dispenser,
		/datum/resin_construction/resin_turf/wall/reflective,
		/datum/resin_construction/resin_obj/acid_pillar/strong,
		/datum/resin_construction/resin_obj/movable/thick_membrane,
		/datum/resin_construction/resin_obj/movable/thick_wall,
		/datum/resin_construction/resin_obj/movable/wall,
		/datum/resin_construction/resin_obj/movable/membrane,
		/datum/resin_construction/resin_obj/grenade
	)
	for(var/i in constructions_to_remove)
		GLOB.resin_build_order_drone -= i
		GLOB.resin_build_order_hivelord -= i
		GLOB.resin_build_order_queen -= i
		GLOB.resin_build_order_queen_ovi -= i

/datum/mutator_set/hive_mutations/give_feedback(description, flavor_description = null, mob/living/carbon/xenomorph/xeno)
	to_chat(xeno, SPAN_XENOANNOUNCE("[usr.client.auto_lang(LANGUAGE_MUTATION_QUEEN_BOON)]: [usr.client.auto_lang(description)]"))
	if(flavor_description != null)
		to_chat(xeno, SPAN_XENOLEADER(usr.client.auto_lang(flavor_description)))
	xeno.xeno_jitter(15)

/datum/mutator_set/hive_mutations/recalculate_everything(description, flavor_description)
	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		xeno.recalculate_everything()
		give_feedback(description, flavor_description, xeno)

/datum/mutator_set/hive_mutations/recalculate_stats(description, flavor_description = null)
	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		xeno.recalculate_stats()
		give_feedback(description, flavor_description, xeno)

/datum/mutator_set/hive_mutations/recalculate_actions(description, flavor_description = null)
	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		xeno.recalculate_actions()
		give_feedback(description, flavor_description, xeno)

/datum/mutator_set/hive_mutations/recalculate_pheromones(description, flavor_description = null)
	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		xeno.recalculate_pheromones()
		give_feedback(description, flavor_description, xeno)

/datum/mutator_set/hive_mutations/proc/recalculate_maturation(description, flavor_description = null)
	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		xeno.recalculate_maturation()
		give_feedback(description, flavor_description, xeno)

/datum/mutator_set/hive_mutations/proc/recalculate_hive(description, flavor_description = null)
	faction.recalculate_hive()
	for(var/mob/living/carbon/xenomorph/xeno in faction.totalMobs)
		give_feedback(description, flavor_description, xeno)

/mob/living/carbon/xenomorph/queen/verb/purchase_hive_mutations()
	set name = "Purchase Hive Mutators"
	set desc = "Purchase Mutators affecting the entire hive."
	set category = "Alien"
	if(!faction || !faction.mutators)
		return //For some reason we don't have mutators
	faction.mutators.list_and_purchase_mutators()


//////////////////////////
//INDIVIDUAL MUTATATIONS//
//////////////////////////
/datum/mutator_set/individual_mutations
	var/gas_boost_level = 0
	var/gas_life_multiplier = 1.0
	var/pull_multiplier = 1.0
	var/carry_boost_level = 0
	var/egg_laying_multiplier = 1.0
	var/damage_income_modifier = 1
	//ONE SELECT
	var/acid_claws = FALSE
	var/decrease_cooldown = FALSE
	var/regeneration = FALSE
	var/vampirism = FALSE
	var/additional_resist = FALSE

/datum/mutator_set/New(mob/living/carbon/xenomorph/xenomorph_to_set)
	xeno = xenomorph_to_set

/datum/mutator_set/individual_mutations/Destroy()
	if(xeno)
		xeno.mutators = null
		xeno = null
	. = ..()

/datum/mutator_set/individual_mutations/can_purchase_mutator(datum/xeno_mutation/xeno_mutation)
	. = ..()
	if(. == FALSE)
		return
	if(xeno_mutation.hive_only)
		return FALSE //We can't buy Hive mutators on an individual level
	if(xeno_mutation.caste_whitelist && (xeno_mutation.caste_whitelist.len > 0) && !(xeno.caste_type in xeno_mutation.caste_whitelist))
		return FALSE //We are not on the whitelist
	return TRUE

/datum/mutator_set/individual_mutations/recalculate_everything(description, flavor_description = null)
	xeno.recalculate_everything()
	give_feedback(description, flavor_description)

/datum/mutator_set/individual_mutations/recalculate_stats(description, flavor_description = null)
	xeno.recalculate_stats()
	give_feedback(description, flavor_description)

/datum/mutator_set/individual_mutations/recalculate_actions(description, flavor_description = null)
	xeno.recalculate_actions()
	give_feedback(description, flavor_description)

/datum/mutator_set/individual_mutations/recalculate_pheromones(description, flavor_description = null)
	xeno.recalculate_pheromones()
	give_feedback(description, flavor_description)

/datum/mutator_set/individual_mutations/recalculate_actions(description, flavor_description = null)
	xeno.recalculate_actions()
	give_feedback(description, flavor_description)

/mob/living/carbon/xenomorph/verb/purchase_mutators()
	set name = "Purchase Mutators"
	set desc = "Purchase Mutators for yourself."
	set category = "Alien"
	if(is_dead())
		return //Dead xenos can't mutate!
	src.mutators.list_and_purchase_mutators()

/mob/living/carbon/xenomorph/verb/list_mutators()
	set name = "List Mutators"
	set desc = "List Mutators that apply to you."
	set category = "Alien"
	var/dat = "<html><body><B>[usr.client.auto_lang(LANGUAGE_MUTATION_MUTATORS)]:</B><BR>"
	if(!src.mutators.purchased_mutators || !src.mutators.purchased_mutators.len)
		dat += "-<BR>"
	else
		for(var/m in src.mutators.purchased_mutators)
			dat += "[usr.client.auto_lang(m)]<BR>"
	dat += "<B>[usr.client.auto_lang(LANGUAGE_MUTATION_HIVE_MUTATORS)]:</B><BR>"
	if(!length(faction.mutators.purchased_mutators) || !length(faction.mutators.purchased_mutators))
		dat += "-<BR>"
	else
		for(var/m in faction.mutators.purchased_mutators)
			dat += "[usr.client.auto_lang(m)]<BR>"
	show_browser(usr, dat, usr.client.auto_lang(LANGUAGE_MUTATION_MUTATOR), "mutations", "size=600x800")

/datum/mutator_set/individual_mutations/can_purchase_strain(datum/xeno_mutation/xeno_mutation)
	. = ..()
	if(. == FALSE)
		return
	if(xeno_mutation.hive_only)
		return FALSE //We can't buy Hive strains on an individual level
	if(xeno_mutation.caste_whitelist && (xeno_mutation.caste_whitelist.len > 0) && !(xeno.caste_type in xeno_mutation.caste_whitelist))
		return FALSE //We are not on the whitelist
	return TRUE

/mob/living/carbon/xenomorph/verb/purchase_strains()
	set name = "Purchase Strains"
	set desc = "Purchase Strains for yourself."
	set category = "Alien"

	if(is_dead())
		return //Dead xenos can't mutate!
	if(!mutators)
		return //For some reason we don't have strains
	mutators.list_and_purchase_strains()

/mob/living/carbon/xenomorph/verb/list_strains()
	set name = "List Strains"
	set desc = "List your current Strain, if any."
	set category = "Alien"

	var/dat = "<html><body><B>"
	if(isnull(mutators) || isnull(mutators.purchased_strains) || !length(mutators.purchased_strains))
		dat += "-</B><BR>"
	else
		for(var/m in mutators.purchased_strains)
			dat += "[usr.client.auto_lang(m)]</B><BR>"

	dat += "</body></html>"
	show_browser(usr, dat, usr.client.auto_lang(LANGUAGE_MUTATION_STRAIN), "strains", "size=600x800")
