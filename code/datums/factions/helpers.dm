GLOBAL_LIST_INIT_TYPED(faction_datum, /datum/faction, setup_faction_list())

/proc/setup_faction_list()
	var/list/faction_datums_list = list()
	for(var/T in typesof(/datum/faction))
		var/datum/faction/F = new T
		faction_datums_list[F.faction_name] = F
		F.generate_relations_helper()
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

//FACTION ALLIANCES
/mob/living/carbon/verb/faction_alliance_status()
	set name = "Faction Alliance Status"
	set desc = "Check the status of your alliances."
	set category = "IC"

	if(!faction || !faction.faction_ui)
		return

	faction.faction_ui.tgui_interact(src)

GLOBAL_LIST_INIT(alliable_factions, generate_alliable_factions())

/proc/generate_alliable_factions()
	. = list()

	.["Xenomorph"] = GLOB.faction_datum[FACTION_LIST_XENOMORPH]

	.["Human"] = GLOB.faction_datum[FACTION_LIST_HUMANOID]

	.["Raw"] = .["Human"] + .["Xenomorph"]

/datum/alliance_faction_ui
	var/name = "Factions"

	var/datum/faction/assoc_hive = null

/datum/alliance_faction_ui/New(datum/faction/hive_to_assign)
	. = ..()
	assoc_hive = hive_to_assign

/datum/alliance_faction_ui/ui_state(mob/user)
	return GLOB.hive_state_queen[assoc_hive]

/datum/alliance_faction_ui/tgui_interact(mob/user, datum/tgui/ui)
	if(!assoc_hive)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HiveFaction", "[assoc_hive.name] Faction Panel")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/alliance_faction_ui/ui_data(mob/user)
	. = list()
	.["current_allies"] = assoc_hive.allies

/datum/alliance_faction_ui/ui_static_data(mob/user)
	. = list()
	.["glob_factions"] = GLOB.alliable_factions

/datum/alliance_faction_ui/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_ally")
			if(isnull(params["should_ally"]) || isnull(params["target_faction"]))
				return

			if(!(params["target_faction"] in GLOB.alliable_factions["Raw"]))
				return

			var/should_ally = text2num(params["should_ally"])
			assoc_hive.allies[params["target_faction"]] = should_ally
			. = TRUE

