/datum/xeno_mutation/strain/shatterglob
	name = LANGUAGE_STRAIN_GLOB
	description = LANGUAGE_STRAIN_DESC_GLOB
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_BOILER) //Only boiler.
	mutation_actions_to_remove = list()
	mutation_actions_to_add = list()
	keystone = TRUE

	behavior_delegate_type = /datum/behavior_delegate/boiler_shatterglob

/datum/xeno_mutation/strain/shatterglob/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == 0)
		return

	var/mob/living/carbon/xenomorph/boiler/boiler = mutator_set.xeno
	boiler.mutation_type = BOILER_SHATTER

	boiler.recalculate_everything()

	apply_behavior_holder(boiler)

	mutator_update_actions(boiler)
	mutator_set.recalculate_actions(description, flavor_description)

/datum/behavior_delegate/boiler_shatterglob
	name = "Boiler Shatter Glob Behavior Delegate"
