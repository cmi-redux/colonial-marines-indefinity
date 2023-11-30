#define CORPSES_TO_SPAWN 200

SUBSYSTEM_DEF(objectives)
	name = "Objectives"
	init_order = SS_INIT_OBJECTIVES
	runlevels = RUNLEVEL_GAME
	wait = 10 SECONDS
	var/list/datum/objectives_datum/active_objectives_controller = list()
	var/total_objectives = 0
	var/total_active_objectives = 0
	var/next_sitrep = SITREP_INTERVAL
	var/statistics = list()

	// Keep track of the list of objectives to process, in case we need to defer to the next tick.
	var/list/datum/cm_objective/current_active_run = list()

/datum/controller/subsystem/objectives/Initialize(start_timeofday)
	. = ..()

	statistics["documents_completed"] = 0
	statistics["documents_total_instances"] = 0
	statistics["documents_total_points_earned"] = 0

	statistics["chemicals_completed"] = 0
	statistics["chemicals_total_instances"] = 0
	statistics["chemicals_total_points_earned"] = 0

	statistics["data_retrieval_completed"] = 0
	statistics["data_retrieval_total_instances"] = 0
	statistics["data_retrieval_total_points_earned"] = 0

	statistics["item_retrieval_completed"] = 0
	statistics["item_retrieval_total_instances"] = 0
	statistics["item_retrieval_total_points_earned"] = 0

	statistics["miscellaneous_completed"] = 0
	statistics["miscellaneous_total_instances"] = 0
	statistics["miscellaneous_total_points_earned"] = 0

	statistics["survivors_rescued"] = 0
	statistics["survivors_rescued_total_points_earned"] = 0

	statistics["corpses_recovered"] = 0
	statistics["corpses_total_points_earned"] = 0

	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(pre_round_start))
	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, PROC_REF(post_round_start))

	return SS_INIT_SUCCESS

/datum/controller/subsystem/objectives/stat_entry(msg)
	msg = "OC:[length(GLOB.objective_controller)]|AOC:[length(active_objectives_controller)]|O:[total_objectives]|AO:[total_active_objectives]|"
	return ..()

/datum/controller/subsystem/objectives/fire(resumed = FALSE)
	if(!resumed)
		active_objectives_controller = list()
		total_objectives = 0
		total_active_objectives = 0
		for(var/datum/objectives_datum/objectives_controller in GLOB.objective_controller)
			total_objectives += length(objectives_controller.objectives)
			if(!objectives_controller.check_status())
				total_objectives += length(objectives_controller.processing_objectives)
			else
				total_active_objectives += length(objectives_controller.processing_objectives)
				active_objectives_controller += objectives_controller

		for(var/datum/objectives_datum/objectives_controller in active_objectives_controller)
			current_active_run += objectives_controller.objectives.Copy()

		if(world.time > next_sitrep)
			next_sitrep = world.time + SITREP_INTERVAL
			announce_stats()
			if(MC_TICK_CHECK)
				return

	while(length(current_active_run))
		var/datum/cm_objective/objective = current_active_run[length(current_active_run)]

		current_active_run.len--
		objective.process()
		objective.check_completion()
		if(objective.objective_state & OBJECTIVE_COMPLETE|OBJECTIVE_FAILED)
			GLOB.faction_datum[faction].objectives_controller.stop_processing_objective(objective)

		if(MC_TICK_CHECK)
			return

/// Allows to perform objective initialization later on in case of map changes
/datum/controller/subsystem/objectives/proc/initialize_objectives()
	SHOULD_NOT_SLEEP(TRUE)
	for(var/datum/objectives_datum/objectives_controller in GLOB.objective_controller)
		objectives_controller.generate_objectives()
		connect_objectives(objectives_controller)
		objectives_controller.corpsewar.generate_corpses(CORPSES_TO_SPAWN)

/datum/controller/subsystem/objectives/proc/pre_round_start()
	SIGNAL_HANDLER
	initialize_objectives()
	for(var/datum/objectives_datum/objectives_controller in GLOB.objective_controller)
		for(var/datum/cm_objective/objective in objectives_controller.objectives)
			objective.pre_round_start()

/datum/controller/subsystem/objectives/proc/post_round_start()
	SIGNAL_HANDLER
	for(var/datum/objectives_datum/objectives_controller in GLOB.objective_controller)
		for(var/datum/cm_objective/objective in objectives_controller.objectives)
			objective.post_round_start()

/datum/controller/subsystem/objectives/proc/connect_objectives(datum/objectives_datum/objectives_controller)
	// Sets up the objective interdependance faction
	// Every objective (which isn't a dead end) gets one guaranteed objective it unlocks.
	// Every objective gets x random objectives that unlock it based on variable 'number_of_clues_to_generate'

	var/list/low_value = list()
	var/list/medium_value = list()
	var/list/high_value = list()
	var/list/extreme_value = list()
	var/list/absolute_value = list()
	// Sort objectives into categories
	for(var/datum/cm_objective/objective in objectives_controller.objectives)
		if(objective.objective_flags & OBJECTIVE_DO_NOT_TREE)
			continue // exempt from the tree
		switch(objective.value)
			if(OBJECTIVE_LOW_VALUE)
				low_value += objective
			if(OBJECTIVE_MEDIUM_VALUE)
				medium_value += objective
			if(OBJECTIVE_HIGH_VALUE)
				high_value += objective
			if(OBJECTIVE_EXTREME_VALUE)
				extreme_value += objective
			if(OBJECTIVE_ABSOLUTE_VALUE)
				absolute_value += objective

	// Set up preqrequisites:
	// Low
	for(var/datum/cm_objective/objective in low_value)
		// Add at least one guaranteed clue for this objective to unlock.
		if(!(objective.objective_flags & OBJECTIVE_DEAD_END) && length(medium_value))
			var/datum/cm_objective/enables = pick(medium_value)
			link_objectives(objective, enables)

	// Medium
	for(var/datum/cm_objective/objective in medium_value)
		while(length(objective.required_objectives) < objective.number_of_clues_to_generate && length(low_value))
			var/datum/cm_objective/req = pick(low_value)
			if(req in objective.required_objectives || (req.objective_flags & OBJECTIVE_DEAD_END))
				continue //don't want to pick the same thing twice OR use a dead-end objective.
			link_objectives(req, objective)

		// Add at least one guaranteed clue for this objective to unlock.
		if(!(objective.objective_flags & OBJECTIVE_DEAD_END) && length(high_value))
			var/datum/cm_objective/enables = pick(high_value)
			link_objectives(objective, enables)

	// High
	for(var/datum/cm_objective/objective in high_value)
		while(length(objective.required_objectives) < objective.number_of_clues_to_generate && length(medium_value))
			var/datum/cm_objective/req = pick(medium_value)
			if(req in objective.required_objectives || (req.objective_flags & OBJECTIVE_DEAD_END))
				continue //don't want to pick the same thing twice OR use a dead-end objective.
			link_objectives(req, objective)

		// Add at least one guaranteed clue for this objective to unlock.
		if(!(objective.objective_flags & OBJECTIVE_DEAD_END) && length(extreme_value))
			var/datum/cm_objective/enables = pick(extreme_value)
			link_objectives(objective, enables)

	// Extreme
	for(var/datum/cm_objective/objective in extreme_value)
		while(length(objective.required_objectives) < objective.number_of_clues_to_generate && length(high_value))
			var/datum/cm_objective/req = pick(high_value)
			if(req in objective.required_objectives || (req.objective_flags & OBJECTIVE_DEAD_END))
				continue //don't want to pick the same thing twice OR use a dead-end objective.
			link_objectives(req, objective)

		// Add at least one guaranteed clue for this objective to unlock.
		if(!(objective.objective_flags & OBJECTIVE_DEAD_END) && length(absolute_value))
			var/datum/cm_objective/enables = pick(absolute_value)
			link_objectives(objective, enables)

	// Absolute
	for(var/datum/cm_objective/objective in absolute_value)
		while(length(objective.required_objectives) < objective.number_of_clues_to_generate && length(extreme_value))
			var/datum/cm_objective/req = pick(extreme_value)
			if(req in objective.required_objectives || (req.objective_flags & OBJECTIVE_DEAD_END))
				continue //don't want to pick the same thing twice OR use a dead-end objective.
			link_objectives(req, objective)

// For linking 2 objectives together in the objective tree
/datum/controller/subsystem/objectives/proc/link_objectives(datum/cm_objective/required_objective, datum/cm_objective/enabled_objective)
	LAZYADD(enabled_objective.required_objectives, required_objective)
	LAZYADD(required_objective.enables_objectives, enabled_objective)

/datum/controller/subsystem/objectives/proc/get_objectives_progress(faction)
	var/point_total = 0
	var/complete = 0

	var/list/categories = list()
	var/list/notable_objectives = list()

	for(var/datum/cm_objective/C as anything in GLOB.faction_datum[faction].objectives_controller.objectives)
		if(!C.observable_by_faction(faction))
			continue
		if(C.display_category)
			if(!(C.display_category in categories))
				categories += C.display_category
				categories[C.display_category] = list("count" = 0, "total" = 0, "complete" = 0)
			categories[C.display_category]["count"]++
			categories[C.display_category]["total"] += C.total_point_value(faction)
			categories[C.display_category]["complete"] += C.get_point_value(faction)

		if(C.objective_flags & OBJECTIVE_DISPLAY_AT_END)
			notable_objectives += C

		point_total += C.total_point_value(faction)
		complete += C.get_point_value(faction)

	var/dat = ""
	if(length(GLOB.faction_datum[faction].objectives_controller.objectives)) // protect against divide by zero
		dat = "<b>Total Objectives:</b> [complete]pts achieved<br>"
		if(length(categories))
			var/total = 1 //To avoid divide by zero errors, just in case...
			var/compl
			for(var/cat in categories)
				total = categories[cat]["total"]
				compl = categories[cat]["complete"]
				if(total == 0)
					total = 1 //To avoid divide by zero errors, just in case...
				dat += "<b>[cat]: </b> [compl]pts achieved<br>"

		for(var/datum/cm_objective/objective as anything in notable_objectives)
			if(!objective.observable_by_faction(faction))
				continue
			dat += objective.get_readable_progress(faction)

	return dat

/datum/controller/subsystem/objectives/proc/get_scored_points(faction)
	var/scored_points = 0

	for(var/datum/cm_objective/L as anything in GLOB.faction_datum[faction].objectives_controller.objectives)
		if(!L.observable_by_faction(faction))
			continue
		scored_points += L.get_point_value(faction)

	return scored_points

/datum/controller/subsystem/objectives/proc/get_total_points(faction)
	var/total_points = 0

	for(var/datum/cm_objective/L as anything in GLOB.faction_datum[faction].objectives_controller.objectives)
		if(!L.observable_by_faction(faction))
			continue
		total_points += L.total_point_value(faction)

	return total_points

/datum/controller/subsystem/objectives/proc/announce_stats()
	to_chat(GLOB.observer_list, "<h2 class='alert'>Отчет по задачам</h2>")
	for(var/faction_to_get in FACTION_LIST_ALL)
		var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
		if(!faction.objectives_active)
			continue
		var/list/objectives_status = faction.objectives_controller.check_defcon_level()
		var/message = "Статус цели: [objectives_status["scored_points"]] / [objectives_status["player_points_defcon"]] ([objectives_status["objectives_percentage"]]%)."
		if(faction.faction_name == FACTION_MARINE)
			ai_silent_announcement(message, ":i", TRUE)
			ai_silent_announcement(message, ":t", TRUE)
		else if(istype(faction, /datum/faction/xenomorph))
			xeno_announcement(SPAN_XENOANNOUNCE(message), faction, XENO_GENERAL_ANNOUNCE)
		else
			faction_announcement(message, "Цели", 'sound/AI/commandreport.ogg', faction)
		message_admins("[faction.name] [message]")
		to_chat(GLOB.observer_list, SPAN_WARNING("[faction.name] [message]"))
