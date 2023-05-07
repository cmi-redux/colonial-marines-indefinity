/datum/xeno_mutation/strain/railgun
	name = LANGUAGE_STRAIN_RAILGUN
	description = LANGUAGE_STRAIN_DESC_RAILGUN
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_BOILER) //Only boiler.
	mutation_actions_to_remove = list(
		/datum/action/xeno_action/onclick/toggle_bomb,
	)
	mutation_actions_to_add = list()
	keystone = TRUE

	behavior_delegate_type = /datum/behavior_delegate/boiler_railgun

/datum/xeno_mutation/strain/railgun/apply_mutator(datum/mutator_set/individual_mutations/mutator_set)
	. = ..()
	if(. == 0)
		return

	var/mob/living/carbon/xenomorph/boiler/boiler = mutator_set.xeno
	if(boiler.is_zoomed)
		boiler.zoom_out()
	boiler.mutation_type = BOILER_RAILGUN
	var/datum/new_ammo = /datum/ammo/xeno/railgun_glob
	boiler.ammo = GLOB.ammo_list[new_ammo]
	boiler.min_bombard_dist = 0

	boiler.tileoffset = 9
	boiler.viewsize = RAILGUN_VIEWRANGE

	boiler.recalculate_everything()

	apply_behavior_holder(boiler)

	mutator_update_actions(boiler)
	mutator_set.recalculate_actions(description, flavor_description)

/datum/behavior_delegate/boiler_railgun
	name = "Boiler Railgun Behavior Delegate"
