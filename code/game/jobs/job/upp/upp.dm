/datum/job/upp
	supervisors = "the acting upp commanding_officer"
	selection_class = "job_upp"
	total_positions = 8
	spawn_positions = 8
	allow_additional = TRUE

/datum/job/upp/command
	supervisors = "the acting commanding officer"
	selection_class = "job_command"
	total_positions = 8
	spawn_positions = 8
	allow_additional = TRUE
	flags_startup_parameters = NO_FLAGS
	balance_formulas = list(BALANCE_FORMULA_COMMANDING, BALANCE_FORMULA_MISC, BALANCE_FORMULA_SUPPORT)

//------------Police-----------------//
/datum/job/upp/command/police
	title = JOB_UPP_POLICE
	total_positions = 5
	spawn_positions = 5
	allow_additional = TRUE
	scaled = TRUE
	selection_class = "job_mp"
	gear_preset = /datum/equipment_preset/upp/military_police
	entry_message_body = "<a href='%WIKIURL%'>You</a> are held by a higher standard and are required to obey not only the server rules but the <a href='%WIKIURL%'>Marine Law</a>. Failure to do so may result in a job ban or server ban. Your primary job is to maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the security of high-ranking personnel, including the command staff. Keep them safe!"

/datum/job/upp/command/police/set_spawn_positions(count)
	spawn_positions = mp_slot_formula(count)

/datum/job/upp/command/police/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = mp_slot_formula(get_total_population(FACTION_MARINE))
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

AddTimelock(/datum/job/upp/command/police, list(
	JOB_SQUAD_ROLES = 10 HOURS
))

/obj/effect/landmark/start/upp/police
	name = JOB_UPP_POLICE
	job = /datum/job/upp/command/police

//------------Doctor-----------------//
/datum/job/upp/command/leytenant_doctor
	title = JOB_UPP_LT_DOKTOR
	total_positions = 5
	spawn_positions = 5
	allow_additional = TRUE
	scaled = TRUE
	selection_class = "job_doctor"
	flags_startup_parameters = NO_FLAGS
	gear_preset = /datum/equipment_preset/upp/doctor
	entry_message_body = "You're a commissioned officer of the UPP. <a href='%WIKIURL%'>You are tasked with keeping the UPP healthy and strong, usually in the form of surgery.</a> You are also an expert when it comes to medication and treatment. If you do not know what you are doing, mentorhelp so a mentor can assist you."
	balance_formulas = list("misc", BALANCE_FORMULA_OPERATIONS, BALANCE_FORMULA_MEDIC)

/datum/job/upp/command/leytenant_doctor/set_spawn_positions(count)
	spawn_positions = doc_slot_formula(count)

/datum/job/upp/command/leytenant_doctor/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = doc_slot_formula(get_total_population(FACTION_MARINE))
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

AddTimelock(/datum/job/upp/command/leytenant_doctor, list(
	JOB_COMMAND_ROLES = 2 HOURS,
	JOB_MEDIC_ROLES = 5 HOURS
))

/obj/effect/landmark/start/upp/leytenant_doctor
	name = JOB_UPP_LT_DOKTOR
	job = /datum/job/upp/command/leytenant_doctor

//------------Crewman----------------//
/datum/job/upp/command/crewman
	title = JOB_UPP_CREWMAN
	total_positions = 2
	spawn_positions = 2
	scaled = FALSE
	gear_preset = /datum/equipment_preset/upp/tank
	entry_message_body = "<a href='%WIKIURL%'>Your job is to operate and maintain the ship's armored vehicles.</a> You are in charge of representing the armored presence amongst the marines during the operation, as well as maintaining and repairing your own vehicles."
	balance_formulas = list(BALANCE_FORMULA_COMMANDING, BALANCE_FORMULA_MISC, BALANCE_FORMULA_FIELD)

/datum/job/upp/command/crewman/set_spawn_positions(count)
	spawn_positions = so_slot_formula(count)

/datum/job/upp/command/crewman/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = so_slot_formula(get_total_population(FACTION_MARINE))
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/upp/command/crewman/generate_entry_message(mob/living/carbon/human/H)
	return ..()

AddTimelock(/datum/job/upp/command/crewman, list(
	JOB_SQUAD_ROLES = 10 HOURS,
	JOB_ENGINEER_ROLES = 5 HOURS
))

/obj/effect/landmark/start/upp/crewman
	name = JOB_UPP_CREWMAN
	job = /datum/job/upp/command/crewman

//------------Recon Officer----------//
/datum/job/upp/command/recon_officer
	title = JOB_UPP_INTEL
	total_positions = 4
	spawn_positions = 4
	allow_additional = TRUE
	scaled = FALSE
	gear_preset = /datum/equipment_preset/upp/reconnaissance
	entry_message_body = "<a href='%WIKIURL%'>Your job is to assist the UPP in collecting intelligence related</a> to the current operation to better inform command of their opposition. You are in charge of gathering any data disks, folders, and notes you may find on the operational grounds and decrypt them to grant the USCM additional resources."
	balance_formulas = list(BALANCE_FORMULA_COMMANDING, BALANCE_FORMULA_MISC, BALANCE_FORMULA_SUPPORT, BALANCE_FORMULA_FIELD)

/datum/job/upp/command/recon_officer/set_spawn_positions(count)
	spawn_positions = so_slot_formula(count)

/datum/job/upp/command/recon_officer/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = so_slot_formula(get_total_population(FACTION_MARINE))
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/upp/command/recon_officer/generate_entry_message(mob/living/carbon/human/H)
	return ..()

AddTimelock(/datum/job/upp/command/recon_officer, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/upp/recon_officer
	name = JOB_UPP_INTEL
	job = /datum/job/upp/command/recon_officer

//------------Officer----------------//
/datum/job/upp/command/officer
	title = JOB_UPP_LT_OFFICER
	total_positions = 4
	spawn_positions = 4
	allow_additional = TRUE
	scaled = FALSE
	gear_preset = /datum/equipment_preset/upp/officer
	entry_message_body = "<a href='%WIKIURL%'>Your job is to control squads, man the CIC, and listen to your superior officers.</a> You are in charge of logistics and the overwatch system. You are also in line to take command after other eligible superior commissioned officers."

/datum/job/upp/command/officer/set_spawn_positions(count)
	spawn_positions = so_slot_formula(count)

/datum/job/upp/command/officer/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = so_slot_formula(get_total_population(FACTION_MARINE))
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/upp/command/officer/generate_entry_message(mob/living/carbon/human/H)
	return ..()

AddTimelock(/datum/job/upp/command/officer, list(
	JOB_SQUAD_LEADER_LIST = 1 HOURS,
	JOB_HUMAN_ROLES = 10 HOURS
))

/obj/effect/landmark/start/upp/officer
	name = JOB_UPP_LT_OFFICER
	job = /datum/job/upp/command/officer

//------------Senior Officer---------//
/datum/job/upp/command/senior_officer
	title = JOB_UPP_SRLT_OFFICER
	total_positions = 2
	spawn_positions = 2
	allow_additional = TRUE
	scaled = FALSE
	gear_preset = /datum/equipment_preset/upp/officer/senior
	entry_message_body = "<a href='%WIKIURL%'>Your job is to control squads, man the CIC, and listen to your superior officers.</a> You are in charge of logistics and the overwatch system. You are also in line to take command after other eligible superior commissioned officers."

/datum/job/upp/command/senior_officer/set_spawn_positions(count)
	spawn_positions = so_slot_formula(count)

/datum/job/upp/command/senior_officer/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = so_slot_formula(get_total_population(FACTION_MARINE))
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/upp/command/senior_officer/generate_entry_message(mob/living/carbon/human/H)
	return ..()

AddTimelock(/datum/job/upp/command/senior_officer, list(
	JOB_COMMAND_ROLES = 2 HOURS,
	JOB_HUMAN_ROLES = 15 HOURS
))

/obj/effect/landmark/start/upp/senior_officer
	name = JOB_UPP_SRLT_OFFICER
	job = /datum/job/upp/command/senior_officer

//------------Mayjor-----------------//
/datum/job/upp/command/major
	title = JOB_UPP_MAY_OFFICER
	flags_startup_parameters = ROLE_ADMIN_NOTIFY
	gear_preset = /datum/equipment_preset/upp/officer/major
	entry_message_body = "<a href='%WIKIURL%'>You are second in command aboard the ship,</a> and are in next in the chain of command after the commanding officer. You may need to fill in for other duties if areas are understaffed, and you are given access to do so. Make the UPP proud!"

AddTimelock(/datum/job/upp/command/major, list(
	JOB_COMMAND_ROLES = 10 HOURS,
	JOB_POLICE_ROLES = 5 HOURS
))

/datum/job/upp/command/major/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	M.faction.faction_leaders["officer"] = M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/upp/command/major/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	M.faction.faction_leaders["officer"] = null

/obj/effect/landmark/start/upp/major
	name = JOB_UPP_MAY_OFFICER
	job = /datum/job/upp/command/major

//------------Kolonel----------------//
/datum/job/upp/command/kolonel
	title = JOB_UPP_KOL_OFFICER
	supervisors = "UPP main command"
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER
	gear_preset = /datum/equipment_preset/upp/officer/kolonel
	entry_message_body = "<a href='%WIKIURL%'>You are the Kolonel of the operation buttle groop 'NINE'.</a> Your goal is to lead the UPP on their mission as well as protect and command the ship and her crew. Your job involves heavy roleplay and requires you to behave like a high-ranking officer and to stay in character at all times. As the Kolonel your only superior is Main Command itself. You must abide by the <a href='"+URL_WIKI_CO_RULES+"'>Captain's Code of Conduct</a>. Failure to do so may result in punitive action against you. Godspeed."
	balance_formulas = list(BALANCE_FORMULA_COMMANDING, BALANCE_FORMULA_MISC, BALANCE_FORMULA_ENGINEER, BALANCE_FORMULA_SUPPORT, BALANCE_FORMULA_OPERATIONS, BALANCE_FORMULA_MEDIC, BALANCE_FORMULA_FIELD)

/datum/job/upp/command/kolonel/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_UPP_KOL_OFFICER][WHITELIST_NORMAL]" = /datum/equipment_preset/upp/officer/kolonel,
		"[JOB_UPP_KOL_OFFICER][WHITELIST_COUNCIL]" = /datum/equipment_preset/upp/officer/kolonel,
		"[JOB_UPP_KOL_OFFICER][WHITELIST_LEADER]" = /datum/equipment_preset/upp/officer/kolonel
	)

/datum/job/upp/command/kolonel/get_whitelist_status(list/roles_whitelist, client/player)
	. = ..()
	if(!.)
		return

	if(roles_whitelist[player.ckey] & WHITELIST_COMMANDER_LEADER)
		return get_desired_status(player.prefs.commander_status, WHITELIST_LEADER)
	else if(roles_whitelist[player.ckey] & (WHITELIST_COMMANDER_COUNCIL|WHITELIST_COMMANDER_COUNCIL_LEGACY))
		return get_desired_status(player.prefs.commander_status, WHITELIST_COUNCIL)
	else if(roles_whitelist[player.ckey] & WHITELIST_COMMANDER)
		return get_desired_status(player.prefs.commander_status, WHITELIST_NORMAL)

/datum/job/upp/command/kolonel/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	M.faction.faction_leaders["commander"] = M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/upp/command/kolonel/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	M.faction.faction_leaders["commander"] = null

/obj/effect/landmark/start/upp/kolonel
	name = JOB_UPP_KOL_OFFICER
	job = /datum/job/upp/command/kolonel

//------------Synth------------------//
/datum/job/upp/synthetic
	title = JOB_UPP_COMBAT_SYNTH
	total_positions = 2
	spawn_positions = 1
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "the acting commanding officer"
	selection_class = "job_synth"
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_SYNTHETIC
	gear_preset = /datum/equipment_preset/upp/synth
	entry_message_body = "You are a <a href='%WIKIURL%'>Synthetic!</a> You are held to a higher standard and are required to obey not only the Server Rules but Marine Law and Synthetic Rules. Failure to do so may result in your White-list Removal. Your primary job is to support and assist all USCM Departments and Personnel on-board. In addition, being a Synthetic gives you knowledge in every field and specialization possible on-board the ship. As a Synthetic you answer to the acting commanding officer. Special circumstances may change this!"

/datum/job/upp/synthetic/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_UPP_COMBAT_SYNTH][WHITELIST_NORMAL]" = /datum/equipment_preset/upp/synth,
		"[JOB_UPP_COMBAT_SYNTH][WHITELIST_COUNCIL]" = /datum/equipment_preset/upp/synth,
		"[JOB_UPP_COMBAT_SYNTH][WHITELIST_LEADER]" = /datum/equipment_preset/upp/synth
	)

/datum/job/upp/synthetic/get_whitelist_status(list/roles_whitelist, client/player)
	. = ..()
	if(!.)
		return

	if(roles_whitelist[player.ckey] & WHITELIST_SYNTHETIC_LEADER)
		return get_desired_status(player.prefs.synth_status, WHITELIST_LEADER)
	else if(roles_whitelist[player.ckey] & (WHITELIST_SYNTHETIC_COUNCIL|WHITELIST_SYNTHETIC_COUNCIL_LEGACY))
		return get_desired_status(player.prefs.synth_status, WHITELIST_COUNCIL)
	else if(roles_whitelist[player.ckey] & WHITELIST_SYNTHETIC)
		return get_desired_status(player.prefs.synth_status, WHITELIST_NORMAL)

/datum/job/upp/synthetic/set_spawn_positions(count)
	spawn_positions = synth_slot_formula(count)

/datum/job/upp/synthetic/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = synth_slot_formula(get_total_population(FACTION_UPP))
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/upp/synthetic
	name = JOB_UPP_COMBAT_SYNTH
	job = /datum/job/upp/synthetic
