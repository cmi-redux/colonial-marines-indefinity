// --------------------------------------------
// *** The core objective interface to allow generic handling of objectives ***
// --------------------------------------------
/datum/cm_objective
	var/name = "An objective to complete"
	var/state = OBJECTIVE_INACTIVE // Whether the objective is inactive, active or complete.
	var/value = OBJECTIVE_NO_VALUE // The point value of this objective.
	var/list/required_objectives //List of objectives that are required to complete this objectives.
	var/list/enables_objectives //List of objectives that require this objective to complete.
	var/objective_flags = NO_FLAGS // functionality related flags.
	var/number_of_clues_to_generate = 1 // miminum number of clues we generate for the objective(aka how many things will point to this objective).
	var/controller = FACTION_NEUTRAL
	var/display_category // group objectives for round end display

/datum/cm_objective/New(faction_to_get)
	if(faction_to_get)
		controller = faction_to_get
	SSobjectives.add_objective(src)

/datum/cm_objective/Destroy()
	SSobjectives.stop_processing_objective(src)
	SSobjectives.remove_objective(src)
	for(var/datum/cm_objective/R as anything in required_objectives)
		LAZYREMOVE(R.enables_objectives, src)
	for(var/datum/cm_objective/E as anything in enables_objectives)
		LAZYREMOVE(E.required_objectives, src)
	required_objectives = null
	enables_objectives = null
	return ..()

// initial setup after the map has loaded
/datum/cm_objective/proc/Initialize()

// called by game mode just before the round starts
/datum/cm_objective/proc/pre_round_start()

// called by game mode on a short delay after round starts
/datum/cm_objective/proc/post_round_start()

// Get the objective data to display on the TGUI interface.
/datum/cm_objective/proc/get_tgui_data()

/datum/cm_objective/proc/get_clue()

//For returning labels of related items (folders, discs, etc.)
/datum/cm_objective/proc/get_related_label()

// Set this objective to complete.
/datum/cm_objective/proc/complete()

// Check if the objective's aim are met.
/datum/cm_objective/proc/check_completion()

// Make this objective call process() and check_completion() every SS tick.
/datum/cm_objective/proc/activate()
	SSobjectives.start_processing_objective(src)

// Stops the Objective from processing
/datum/cm_objective/proc/deactivate()
	SSobjectives.stop_processing_objective(src)

/datum/cm_objective/proc/get_completion_status()
	if(state & OBJECTIVE_COMPLETE)
		return "<span class='objectivesuccess'>Succeeded!</span>"
	return "<span class='objectivebig'>In Progress!</span>"

/datum/cm_objective/proc/get_readable_progress()
	var/dat = "<b>[name]:</b> "
	return dat + get_completion_status() + "<br>"

/datum/cm_objective/proc/get_point_value()
	if(state & OBJECTIVE_COMPLETE)
		return value
	return FALSE

/datum/cm_objective/proc/total_point_value()
	return value

/datum/cm_objective/proc/observable_by_faction(faction)
	if(controller == faction || objective_flags & OBJECTIVE_DO_NOT_TREE)
		return TRUE
	return FALSE
