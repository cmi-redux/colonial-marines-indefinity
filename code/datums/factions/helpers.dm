GLOBAL_LIST_INIT(task_gen_list, list("sector_control" = list(/datum/faction_task/sector_control/occupy, /datum/faction_task/sector_control/occupy/hold)))
GLOBAL_LIST_INIT(task_gen_list_game_enders, list("game_enders" = list(/datum/faction_task/dominate, /datum/faction_task/hold)))

GLOBAL_LIST_INIT_TYPED(faction_datum, /datum/faction, setup_faction_list())

/proc/setup_faction_list()
	var/list/faction_datums_list = list()
	for(var/path in typesof(/datum/faction))
		var/datum/faction/faction = new path
		faction_datums_list[faction.faction_name] = faction
		faction.relations_datum.generate_relations_helper()
	return faction_datums_list

GLOBAL_LIST_INIT_TYPED(custom_event_info_list, /datum/custom_event_info, setup_custom_event_info())

/proc/setup_custom_event_info()
	//faction event messages
	var/list/custom_event_info_list = list()
	var/datum/custom_event_info/CEI = new()
	CEI.faction_name = "Global"
	custom_event_info_list[CEI.faction_name] = CEI
	var/list/factions = GLOB.faction_datum
	for(var/faction_to_get in factions)
		var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
		CEI = new()
		CEI.faction_name = faction.name
		CEI.faction = faction
		custom_event_info_list[CEI.faction_name] = CEI
	return custom_event_info_list
