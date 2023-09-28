//Commander
/datum/job/command/commander
	title = JOB_CO
	supervisors = "USCM high command"
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER
	gear_preset = /datum/equipment_preset/uscm_ship/commander
	balance_formulas = list(BALANCE_FORMULA_COMMANDING, BALANCE_FORMULA_MISC, BALANCE_FORMULA_ENGINEER, BALANCE_FORMULA_SUPPORT, BALANCE_FORMULA_OPERATIONS, BALANCE_FORMULA_MEDIC, BALANCE_FORMULA_FIELD)
=======
/datum/job/command/commander/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_CO][WHITELIST_NORMAL]" = /datum/equipment_preset/uscm_ship/commander,
		"[JOB_CO][WHITELIST_COUNCIL]" = /datum/equipment_preset/uscm_ship/commander/council,
		"[JOB_CO][WHITELIST_LEADER]" = /datum/equipment_preset/uscm_ship/commander/council/plus
	)

/datum/job/command/commander/generate_entry_message()
	entry_message_body = "<a href='%WIKIPAGE%'>You are the Commanding Officer of the [MAIN_SHIP_NAME] as well as the operation.</a> Your goal is to lead the Marines on their mission as well as protect and command the ship and her crew. Your job involves heavy roleplay and requires you to behave like a high-ranking officer and to stay in character at all times. As the Commanding Officer your only superior is High Command itself. You must abide by the <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_CO_RULES]'>Commanding Officer Code of Conduct</a>. Failure to do so may result in punitive action against you. Godspeed."
	return ..()

/datum/job/command/commander/get_whitelist_status(list/roles_whitelist, client/player)
	. = ..()
	if(!.)
		return

	if(roles_whitelist[player.ckey] & WHITELIST_COMMANDER_LEADER)
		return get_desired_status(player.prefs.commander_status, WHITELIST_LEADER)
	else if(roles_whitelist[player.ckey] & (WHITELIST_COMMANDER_COUNCIL|WHITELIST_COMMANDER_COUNCIL_LEGACY))
		return get_desired_status(player.prefs.commander_status, WHITELIST_COUNCIL)
	else if(roles_whitelist[player.ckey] & WHITELIST_COMMANDER)
		return get_desired_status(player.prefs.commander_status, WHITELIST_NORMAL)

/datum/job/command/commander/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(src, PROC_REF(do_announce_entry_message), H), 1.5 SECONDS)
	return ..()

/datum/job/command/commander/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	M.faction.faction_leaders["commander"] = M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/command/commander/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	M.faction.faction_leaders["commander"] = null

/datum/job/command/commander/proc/do_announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(all_hands_on_deck), "Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!"), 5 SECONDS)
	return

/obj/effect/landmark/start/captain
	name = JOB_CO
	icon_state = "co_spawn"
	job = /datum/job/command/commander
