// --------------------------------------------
// *** Basic retrieve item and get it to an area ***
// --------------------------------------------
/datum/cm_objective/retrieve_item
	var/obj/target_item
	var/area/initial_area
	var/area_flags = AREA_RECOVER_ITEMS
	objective_flags = OBJECTIVE_START_PROCESSING_ON_DISCOVERY|OBJECTIVE_DISPLAY_AT_END
	display_category = "Item Retrieval"

/datum/cm_objective/retrieve_item/New(faction_to_get, target)
	..()
	if(target)
		target_item = target
		initial_area = get_area(target_item)
	RegisterSignal(target_item, COMSIG_PARENT_PREQDELETED, PROC_REF(clean_up_ref))

/datum/cm_objective/retrieve_item/Destroy()
	target_item = null
	initial_area = null
	return ..()

/datum/cm_objective/retrieve_item/proc/clean_up_ref()
	SIGNAL_HANDLER

	qdel(src)

/datum/cm_objective/retrieve_item/get_clue()
	return SPAN_DANGER("[target_item] in <u>[initial_area]</u>")

/datum/cm_objective/retrieve_item/check_completion()
	var/area/A = get_area(target_item)
	if(A.flags_area & area_flags)
		controller = A.faction_to_get
		complete()
		return TRUE

/datum/cm_objective/retrieve_item/complete()
	objective_state = OBJECTIVE_COMPLETE
	SSobjectives.statistics["item_retrieval_total_points_earned"] += value

/datum/cm_objective/retrieve_item/get_tgui_data()
	var/list/clue = list()

	clue["text"] = target_item.name
	clue["location"] = initial_area.name

	return clue

// --------------------------------------------
// *** Fulton retrieval ***
// --------------------------------------------

/datum/cm_objective/retrieve_item/fulton
	name = "Recover a lost fulton"
	objective_state = OBJECTIVE_ACTIVE
	objective_flags = OBJECTIVE_DO_NOT_TREE
	area_flags = AREA_RECOVER_FULTON_ITEMS

/datum/cm_objective/retrieve_item/fulton/proc/clean_up_fulton()
	SIGNAL_HANDLER
	objective_state = OBJECTIVE_COMPLETE
	GLOB.failed_fultons -= target_item
	qdel(src)
	return

/datum/cm_objective/retrieve_item/fulton/New(faction_to_get)
	. = ..()
	GLOB.failed_fultons += target_item
	activate()

/datum/cm_objective/retrieve_item/fulton/get_clue()
	return SPAN_DANGER("Retrieve lost fulton of [target_item] in [initial_area]")

/datum/cm_objective/retrieve_item/fulton/get_tgui_data()
	RegisterSignal(target_item, COMSIG_PARENT_PREQDELETED, PROC_REF(clean_up_fulton), override = TRUE)

	var/list/clue = list()

	clue["text"] = "Retrieve lost fulton"
	clue["itemID"] = "([target_item.name])"
	clue["location"] = initial_area.name

	return clue

/datum/cm_objective/retrieve_item/fulton/complete()
	..()


// -----------------------------------------------------------
// *** Documents and data disks after they have been read ***
// -----------------------------------------------------------

/datum/cm_objective/retrieve_item/document
	name = "Store document in ship lab"
	value = OBJECTIVE_LOW_VALUE
	objective_flags = OBJECTIVE_DO_NOT_TREE | OBJECTIVE_START_PROCESSING_ON_DISCOVERY

/datum/cm_objective/retrieve_item/document/pre_round_start()
	SSobjectives.statistics["item_retrieval_total_instances"]++

/datum/cm_objective/retrieve_item/document/complete()
	..()
	SSobjectives.statistics["item_retrieval_completed"]++

/datum/cm_objective/retrieve_item/document/get_clue()
	return
