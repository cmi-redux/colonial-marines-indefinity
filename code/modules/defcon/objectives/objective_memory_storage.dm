//A datum for storing objective data in the mind in an organised fashion
/datum/objective_memory_storage
	var/list/datum/cm_objective/folders = list()
	var/list/datum/cm_objective/progress_reports = list()
	var/list/datum/cm_objective/technical_manuals = list()
	var/list/datum/cm_objective/terminals = list()
	var/list/datum/cm_objective/disks = list()
	var/list/datum/cm_objective/retrieve_items = list()
	var/list/datum/cm_objective/other = list()

//this is an objective that the player has just completed
//and we want to store the objective clues generated based on it -spookydonut
/datum/objective_memory_storage/proc/store_objective(datum/cm_objective/O)
	for(var/datum/cm_objective/R in O.enables_objectives)
		store_single_objective(R)

/datum/objective_memory_storage/proc/store_single_objective(datum/cm_objective/O)
	if(!istype(O))
		return
	if(O.state == OBJECTIVE_COMPLETE)
		return
	if(istype(O, /datum/cm_objective/document/folder))
		addToListNoDupe(folders, O)
	else if(istype(O, /datum/cm_objective/document/progress_report))
		addToListNoDupe(progress_reports, O)
	else if(istype(O, /datum/cm_objective/document/technical_manual))
		addToListNoDupe(technical_manuals, O)
	else if(istype(O, /datum/cm_objective/retrieve_data/terminal))
		addToListNoDupe(terminals, O)
	else if(istype(O, /datum/cm_objective/retrieve_data/disk))
		addToListNoDupe(disks, O)
	else if(istype(O, /datum/cm_objective/retrieve_item))
		addToListNoDupe(retrieve_items, O)
	else
		addToListNoDupe(other, O)

//returns TRUE if we have the objective already
/datum/objective_memory_storage/proc/has_objective(datum/cm_objective/O)
	if(O in folders)
		return TRUE
	if(O in progress_reports)
		return TRUE
	if(O in technical_manuals)
		return TRUE
	if(O in terminals)
		return TRUE
	if(O in disks)
		return TRUE
	if(O in retrieve_items)
		return TRUE
	if(O in other)
		return TRUE
	return FALSE

/datum/objective_memory_storage/proc/clean_objectives()
	for(var/datum/cm_objective/O in folders)
		if(O.state == OBJECTIVE_COMPLETE)
			folders -= O
	for(var/datum/cm_objective/O in progress_reports)
		if(O.state == OBJECTIVE_COMPLETE)
			progress_reports -= O
	for(var/datum/cm_objective/O in technical_manuals)
		if(O.state == OBJECTIVE_COMPLETE)
			technical_manuals -= O
	for(var/datum/cm_objective/O in terminals)
		if(O.state == OBJECTIVE_COMPLETE)
			terminals -= O
	for(var/datum/cm_objective/O in disks)
		if(O.state == OBJECTIVE_COMPLETE)
			disks -= O
	for(var/datum/cm_objective/O in retrieve_items)
		if(O.state == OBJECTIVE_COMPLETE)
			retrieve_items -= O
	for(var/datum/cm_objective/O in other)
		if(O.state == OBJECTIVE_COMPLETE)
			other -= O

/datum/objective_memory_storage/proc/synchronize_objectives()
	clean_objectives()
	if(!intel_system || !intel_system.oms)
		return
	intel_system.oms.clean_objectives()

	for(var/datum/cm_objective/O in intel_system.oms.folders)
		addToListNoDupe(folders, O)
	for(var/datum/cm_objective/O in intel_system.oms.progress_reports)
		addToListNoDupe(progress_reports, O)
	for(var/datum/cm_objective/O in intel_system.oms.technical_manuals)
		addToListNoDupe(technical_manuals, O)
	for(var/datum/cm_objective/O in intel_system.oms.terminals)
		addToListNoDupe(terminals, O)
	for(var/datum/cm_objective/O in intel_system.oms.disks)
		addToListNoDupe(disks, O)
	for(var/datum/cm_objective/O in intel_system.oms.retrieve_items)
		addToListNoDupe(retrieve_items, O)
	for(var/datum/cm_objective/O in intel_system.oms.other)
		addToListNoDupe(other, O)

var/global/datum/intel_system/intel_system = new()

/datum/intel_system
	var/datum/objective_memory_storage/oms = new()

/datum/intel_system/proc/store_objective(datum/cm_objective/O)
	oms.store_objective(O)

/datum/intel_system/proc/store_single_objective(datum/cm_objective/O)
	oms.store_single_objective(O)


// --------------------------------------------
// *** Upload clues with the computer ***
// --------------------------------------------
/obj/structure/machinery/computer/intel
	name = "Intel Computer"
	var/label = ""
	desc = "An USCM Intel Computer for data cataloguing and distribution."
	icon_state = "terminal1_old"
	unslashable = TRUE
	unacidable = TRUE
	var/typing_time = 20


/obj/structure/machinery/computer/intel/attack_hand(mob/living/user)
	if(!user || !istype(user) || !user.mind || !user.mind.objective_memory)
		return FALSE
	if(!powered())
		to_chat(user, SPAN_WARNING("This computer has no power!"))
		return FALSE
	if(!intel_system)
		to_chat(user, SPAN_WARNING("The computer doesn't seem to be connected to anything..."))
		return FALSE
	if(user.action_busy)
		return FALSE

	to_chat(user, SPAN_NOTICE("You start typing in intel into the computer..."))

	var/total_transferred = 0
	var/outcome = 0 //outcome of an individual upload - if something interrupts us, we cancel the rest

	user.mind.objective_memory.clean_objectives() // Don't upload completed objectives, there's no point.

	for(var/datum/cm_objective/O in user.mind.objective_memory.folders)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return FALSE
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.progress_reports)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return FALSE
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.technical_manuals)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return FALSE
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.terminals)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return FALSE
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.disks)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return FALSE
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.retrieve_items)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return FALSE
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.other)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return FALSE
		if(outcome > 0)
			total_transferred++

	if(total_transferred > 0)
		to_chat(user, SPAN_NOTICE("...and done! You uploaded [total_transferred] entries!"))
	else
		to_chat(user, SPAN_NOTICE("...and you have nothing new to add..."))

	return TRUE

/obj/structure/machinery/computer/intel/proc/transfer_intel(mob/living/user, datum/cm_objective/O)
	if(!intel_system || !intel_system.oms)
		return 0
	if(intel_system.oms.has_objective(O))
		return 0
	if(user.action_busy)
		return 0

	var/clue = O.get_clue()
	if(!clue) // Not all objectives have clues.
		return 0

	playsound(user, pick('sound/machines/computer_typing4.ogg', 'sound/machines/computer_typing5.ogg', 'sound/machines/computer_typing6.ogg'), 5, 1)

	if(!do_after(user, typing_time * user.get_skill_duration_multiplier(SKILL_INTEL), INTERRUPT_ALL, BUSY_ICON_GENERIC)) // Can't move from the spot
		to_chat(user, SPAN_WARNING("You get distracted and lose your train of thought, you'll have to start the typing over..."))
		return -1

	to_chat(user, SPAN_NOTICE("...something about \"[clue]\"..."))
	intel_system.store_single_objective(O)
	return 1

// --------------------------------------------
// *** View objectives with the computer ***
// --------------------------------------------

/obj/structure/machinery/computer/view_objectives
	name = "Intel Database Computer"
	desc = "An USCM Intel Database Computer used for consulting the current intel database."
	icon_state = "terminal1_old"
	unslashable = TRUE
	unacidable = TRUE


/obj/structure/machinery/computer/view_objectives/attack_hand(mob/living/user)
	if(!user || !istype(user) || !user.mind || !user.mind.objective_memory)
		return FALSE
	if(!powered())
		to_chat(user, SPAN_WARNING("This computer has no power!"))
		return FALSE
	if(!intel_system)
		to_chat(user, SPAN_WARNING("The computer doesn't seem to be connected to anything..."))
		return FALSE
	if(user.action_busy)
		return FALSE

	user.mind.view_objective_memories(src)


/datum/objective_memory_interface
	var/datum/objectives_datum/controller

/datum/objective_memory_interface/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		controller = GLOB.objective_controller[user.faction.faction_name]
		ui = new(user, src, "ObjectivesMemories", "[user.faction] Objectives")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/objective_memory_interface/proc/get_clues(mob/user)
	var/datum/objective_memory_storage/memories = user.mind.objective_memory
	var/list/clue_categories = list()


	// Progress reports
	var/list/clue_category = list()
	clue_category["name"] = "Reports"
	clue_category["icon"] = "scroll"
	clue_category["clues"] = list()
	for (var/datum/cm_objective/document/progress_report/report in memories.progress_reports)
		if(report.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(report.get_tgui_data())
	clue_categories += list(clue_category)


	// Folders
	clue_category = list()
	clue_category["name"] = "Folders"
	clue_category["icon"] = "folder"
	clue_category["clues"] = list()
	for (var/datum/cm_objective/document/folder/folder in memories.folders)
		if(folder.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(folder.get_tgui_data())
	clue_categories += list(clue_category)


	// Technical manuals
	clue_category = list()
	clue_category["name"] = "Manuals"
	clue_category["icon"] = "book"
	clue_category["clues"] = list()
	for (var/datum/cm_objective/document/technical_manual/manual in memories.technical_manuals)
		if(manual.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(manual.get_tgui_data())
	clue_categories += list(clue_category)


	// Data (disks + terminals)
	clue_category = list()
	clue_category["name"] = "Data"
	clue_category["icon"] = "save"
	clue_category["clues"] = list()
	for(var/datum/cm_objective/retrieve_data/disk/disk in memories.disks)
		if(disk.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(disk.get_tgui_data())
	for(var/datum/cm_objective/retrieve_data/terminal/terminal in memories.terminals)
		if(terminal.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(terminal.get_tgui_data())
	clue_categories += list(clue_category)


	// Retrieve items (devices + documents)
	clue_category = list()
	clue_category["name"] = "Retrieve"
	clue_category["icon"] = "box"
	clue_category["compact"] = TRUE
	clue_category["clues"] = list()
	for(var/datum/cm_objective/retrieve_item/objective in memories.retrieve_items)
		if(objective.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(objective.get_tgui_data())
	clue_categories += list(clue_category)


	// Other (safes)
	clue_category = list()
	clue_category["name"] = "Other"
	clue_category["icon"] = "ellipsis-h"
	clue_category["clues"] = list()
	for (var/datum/cm_objective/objective in memories.other)

		// Safes
		if(istype(objective, /datum/cm_objective/crack_safe))
			var/datum/cm_objective/crack_safe/safe = objective
			if(safe.state == OBJECTIVE_ACTIVE)
				clue_category["clues"] += list(safe.get_tgui_data())
			continue

	clue_categories += list(clue_category)

	return clue_categories

/datum/objective_memory_interface/proc/get_objective(label, completed, instances, points_earned, custom_color = FALSE, custom_status = FALSE)
	var/list/objective = list()
	objective["label"] = label
	objective["content_credits"] = (points_earned ? "([points_earned])" : "")

	if(!custom_status)
		objective["content"] = "[completed] / [(instances ? instances : "∞")]"
	else
		objective["content"] = custom_status

	if(custom_color)
		objective["content_color"] = custom_color
	else
		if(!completed)
			objective["content_color"] = "red"
		else if(completed == instances)
			objective["content_color"] = "green"
		else
			objective["content_color"] = "orange"

	return objective

// Get our progression for each objective.
/datum/objective_memory_interface/proc/get_objectives()
	var/list/objectives = list()

	// Documents (papers + reports + folders + manuals)
	objectives += list(get_objective(
		"Documents",
		SSobjectives.statistics["documents_completed"],
		SSobjectives.statistics["documents_total_instances"],
		SSobjectives.statistics["documents_total_points_earned"]
	))

	// Data (disks + terminals)
	objectives += list(get_objective(
		"Upload data",
		SSobjectives.statistics["data_retrieval_completed"],
		SSobjectives.statistics["data_retrieval_total_instances"],
		SSobjectives.statistics["data_retrieval_total_points_earned"]
	))

	// Retrieve items (devices + documents + fultons)
	objectives += list(get_objective(
		"Retrieve items",
		SSobjectives.statistics["item_retrieval_completed"],
		SSobjectives.statistics["item_retrieval_total_instances"],
		SSobjectives.statistics["item_retrieval_total_points_earned"]
	))

	// Miscellaneous (safes)
	objectives += list(get_objective(
		"Miscellaneous",
		SSobjectives.statistics["miscellaneous_completed"],
		SSobjectives.statistics["miscellaneous_total_instances"],
		SSobjectives.statistics["miscellaneous_total_points_earned"]
	))

	// Chemicals
	objectives += list(get_objective(
		"Analyze chemicals",
		SSobjectives.statistics["chemicals_completed"],
		FALSE,
		SSobjectives.statistics["chemicals_total_points_earned"],
		"white"
	))

	// Corpses (human + xeno)
	objectives += list(get_objective(
		"Recover corpses",
		SSobjectives.statistics["corpses_recovered"],
		FALSE,
		SSobjectives.statistics["corpses_total_points_earned"],
		"white"
	))

	// Communications
	objectives += list(get_objective(
		"Colony communications",
		FALSE,
		FALSE,
		(controller.comms.state == OBJECTIVE_COMPLETE ? controller.comms.value : FALSE),
		(controller.comms.state == OBJECTIVE_COMPLETE ? "green" : "red"),
		(controller.comms.state == OBJECTIVE_COMPLETE ? "Online" : "Offline"),
	))

	// Power (smes)
	var/message
	var/color
	if(!controller.first_drop_complete)
		message = "Unable to remotely interface with powernet"
		color = "white"
	else if(controller.power.state == OBJECTIVE_COMPLETE)
		message = "Online"
		color = "green"
	else if(controller.power.last_power_output)
		message = "[controller.power.last_power_output]W, [controller.power.minimum_power_required]W required"
		color = "orange"
	else
		message = "Offline"
		color = "red"

	objectives += list(get_objective(
		"Colony power",
		FALSE,
		FALSE,
		(controller.power.state == OBJECTIVE_COMPLETE ? controller.power.value : FALSE),
		color,
		message,
	))

	return objectives

/datum/objective_memory_interface/ui_data(mob/user)
	. = list()
	.["reward_points"] = controller.remaining_reward_points
	.["total_objectives_points"] = controller.last_objectives_scored_points
	.["objectives"] = get_objectives(user)
	.["clue_categories"] = get_clues(user)

/datum/objective_memory_interface/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/objective_memory_interface/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE
