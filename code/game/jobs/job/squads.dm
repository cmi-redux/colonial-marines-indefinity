//This datum keeps track of individual squads. New squads can be added without any problem but to give them
//access you must add them individually to access.dm with the other squads. Just look for "access_alpha" and add the new one

//Note: some important procs are held by the job controller, in job_controller.dm.
//In particular, randomize_squad()
/datum/squad_type //Majority of this is for a follow-on PR to fully flesh the system out and add more bits for other factions.
	var/name = "Squad Type"
	var/lead_name
	var/lead_icon
	var/sub_squad
	var/sub_leader

/datum/squad_type/marine_squad
	name = "Squad"
	lead_name = "Squad Leader"
	lead_icon = "leader"
	sub_squad = "Fireteam"
	sub_leader = "Fireteam Leader"

/datum/squad_type/marsoc_team
	name = "Team"
	lead_name = "Team Leader"
	lead_icon = "soctl"
	sub_squad = "Strike Team"
	sub_leader = "Strike Leader"

/datum/squad
	/// Name of the squad
	var/name
	/// Squads ID that is set on New()
	var/tracking_id = null //Used for the tracking subsystem
	/// Maximum number allowed in a squad. Defaults to infinite
	var/max_positions = -1
	/// If uses the overlay
	var/use_stripe_overlay = TRUE
	/// Color for the squad marines gear overlays
	var/equipment_color = "#FFFFFF"
	/// The alpha for the armor overlay used by equipment color
	var/armor_alpha = 125
	/// Color for the squad marines langchat
	var/chat_color = "#FFFFFF"
	/// Which special access do we grant them
	var/list/access = list()
	/// Can use any squad vendor regardless of squad connection
	var/omni_squad_vendor = FALSE
	/// Squad slots
	var/max_leaders = 1 // maximum # of squad leaders allowed in the squad
	var/num_leaders = 0
	var/max_specialists = 1 // maximum # of specs allowed in the squad
	var/num_specialists = 0
	var/max_main_supports = 1 // maximum # of smartgunners allowed in the squad
	var/num_main_supports = 0
	var/max_supports = 2 // maximum # of fireteam leaders allowed in the suqad
	var/num_supports = 0
	var/max_medics = 4 // maximum # of squad medics allowed in the squad
	var/num_medics = 0
	var/max_engineers = 3 // maximum # of engineers allowed in the squad
	var/num_engineers = 0
	/// Squad lists of marines
	var/count = 0 // current # in the squad
	var/list/marines_list = list() // list of mobs (or name, not always a mob ref) in that squad.

	var/min_online_requered = null // Poplock

	/// Squad headsets default radio frequency
	var/radio_freq = 1461

	/// Whether this squad can be used by marines
	var/usable = FALSE
	/// Whether this squad can be picked at roundstart
	var/roundstart = TRUE
	// Whether the squad is available for squad management
	var/locked = FALSE
	/// Whether it is visible in overwatch
	var/active = FALSE
	/// Which faction the squad is in
	var/faction = FACTION_MARINE

	/// What will the assistant squad leader be called
	var/squad_type = "Squad" //Referenced for aSL details. Squad/Team/Cell etc.
	/// Squad leaders icon
	var/lead_icon //Referenced for SL's 'L' icon. If nulled, won't override icon for aSLs.

	//vvv Do not set these in squad defines
	var/mob/living/carbon/human/squad_leader = null //Who currently leads it.
	var/list/fireteam_leaders = list(
									"FT1" = null,
									"FT2" = null,
									"FT3" = null
									) //FT leaders stored here
	var/list/list/fireteams = list(
							"FT1" = list(),
							"FT2" = list(),
							"FT3" = list()
							) //3 FTs where references to marines stored.
	var/list/squad_info_data = list()

	var/mob/living/carbon/human/overwatch_officer = null //Who's overwatching this squad?
	COOLDOWN_DECLARE(next_supplydrop)

	///Text strings, not HTML safe so don't use it without encoding
	var/primary_objective = null
	var/secondary_objective = null

	var/obj/item/device/squad_beacon/sbeacon = null
	var/obj/item/device/squad_beacon/bomb/bbeacon = null
	var/obj/structure/supply_drop/drop_pad = null

	var/minimap_color = MINIMAP_SQUAD_UNKNOWN

	///Should we add the name of our squad in front of their name? Ex: Alpha Hospital Corpsman
	var/prepend_squad_name_to_assignment = TRUE


/datum/squad/marine
	name = "Root"
	usable = TRUE
	active = TRUE
	faction = FACTION_MARINE
	lead_icon = "leader"

/datum/squad/marine/alpha
	name = SQUAD_MARINE_1
	equipment_color = "#e61919"
	chat_color = "#e67d7d"
	access = list(ACCESS_MARINE_ALPHA)
	radio_freq = ALPHA_FREQ
	minimap_color = MINIMAP_SQUAD_ALPHA

/datum/squad/marine/bravo
	name = SQUAD_MARINE_2
	equipment_color = "#ffc32d"
	chat_color = "#ffe650"
	access = list(ACCESS_MARINE_BRAVO)
	min_online_requered = 30
	radio_freq = BRAVO_FREQ
	minimap_color = MINIMAP_SQUAD_BRAVO

/datum/squad/marine/charlie
	name = SQUAD_MARINE_3
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"
	access = list(ACCESS_MARINE_CHARLIE)
	min_online_requered = 60
	radio_freq = CHARLIE_FREQ
	minimap_color = MINIMAP_SQUAD_CHARLIE

/datum/squad/marine/delta
	name = SQUAD_MARINE_4
	equipment_color = "#4148c8"
	chat_color = "#828cff"
	access = list(ACCESS_MARINE_DELTA)
	min_online_requered = 90
	radio_freq = DELTA_FREQ
	minimap_color = MINIMAP_SQUAD_DELTA

/datum/squad/marine/echo
	name = SQUAD_MARINE_5
	equipment_color = "#67d692"
	chat_color = "#67d692"
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	radio_freq = ECHO_FREQ
	omni_squad_vendor = TRUE
	minimap_color = MINIMAP_SQUAD_ECHO

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/cryo
	name = SQUAD_MARINE_6
	equipment_color = "#c47a50"
	chat_color = "#c47a50"
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	minimap_color = MINIMAP_SQUAD_FOXTROT

	omni_squad_vendor = TRUE
	radio_freq = CRYO_FREQ

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/intel
	name = SQUAD_MARINE_7
	use_stripe_overlay = FALSE
	equipment_color = "#053818"
	minimap_color = MINIMAP_SQUAD_INTEL
	radio_freq = INTEL_FREQ

	roundstart = FALSE
	prepend_squad_name_to_assignment = FALSE

	max_leaders = 0
	max_specialists = 0
	max_main_supports = 0
	max_supports = 0
	max_medics = 0
	max_engineers = 0

/datum/squad/marine/sof
	name = SQUAD_MARINE_SOF
	equipment_color = "#400000"
	chat_color = "#400000"
	radio_freq = SOF_FREQ
	squad_type = "Team"
	lead_icon = "soctl"
	minimap_color = MINIMAP_SQUAD_SOF

	active = FALSE
	roundstart = FALSE
	locked = TRUE

//############################### UPP Squads
/datum/squad/upp
	name = "Root"
	usable = TRUE
	active = TRUE
	omni_squad_vendor = TRUE
	faction = FACTION_UPP
	squad_type = "Battalion"
	lead_icon = "leader"

/datum/squad/upp/red_daragon
	name = SQUAD_UPP_1
	equipment_color = "#e61919"
	chat_color = "#e67d7d"
	minimap_color = MINIMAP_SQUAD_ALPHA

/datum/squad/upp/sun_rise
	name = SQUAD_UPP_2
	equipment_color = "#ffc32d"
	chat_color = "#ffe650"
	min_online_requered = 30
	minimap_color = MINIMAP_SQUAD_BRAVO

/datum/squad/upp/veiled_threat
	name = SQUAD_UPP_3
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"
	min_online_requered = 60
	minimap_color = MINIMAP_SQUAD_CHARLIE

/datum/squad/upp/death_seekers
	name = SQUAD_UPP_4
	equipment_color = "#4148c8"
	chat_color = "#828cff"
	min_online_requered = 90
	minimap_color = MINIMAP_SQUAD_DELTA

/datum/squad/upp/echo
	name = SQUAD_UPP_5
	equipment_color = "#c47a50"
	chat_color = "#c47a50"

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/upp/cryo
	name = SQUAD_UPP_6
	equipment_color = "#c47a50"
	chat_color = "#c47a50"
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	minimap_color = MINIMAP_SQUAD_FOXTROT

	omni_squad_vendor = TRUE

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/upp/intel
	name = SQUAD_UPP_7
	use_stripe_overlay = FALSE
	equipment_color = "#053818"
	minimap_color = MINIMAP_SQUAD_INTEL

	roundstart = FALSE
	prepend_squad_name_to_assignment = FALSE

	max_leaders = 0
	max_specialists = 0
	max_main_supports = 0
	max_supports = 0
	max_medics = 0
	max_engineers = 0

/datum/squad/upp/soz
	name = SQUAD_UPP_SOZ
	equipment_color = "#c47a50"
	chat_color = "#c47a50"

	squad_type = "Team"
	locked = TRUE

//###############################
/datum/squad/pmc
	name = "Root"
	usable = TRUE
	active = TRUE
	omni_squad_vendor = TRUE
	faction = FACTION_PMC
	squad_type = "Team"

/datum/squad/pmc/upsilon
	name = "Team Upsilon"
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"

/datum/squad/pmc/gamma
	name = "Team Gamma"
	equipment_color = "#c47a50"
	chat_color = "#c47a50"

/datum/squad/pmc/wo
	name = "Taskforce White"
	locked = TRUE
	faction = FACTION_WY_DEATHSQUAD

//###############################
/datum/squad/clf
	name = "Root"
	squad_type = "Cell"
	faction = FACTION_CLF
	usable = TRUE
	omni_squad_vendor = TRUE

/datum/squad/clf/python
	name = SQUAD_CLF_1
	equipment_color = "#c47a50"
	chat_color = "#c47a50"
	minimap_color = MINIMAP_SQUAD_ALPHA

/datum/squad/clf/viper
	name = SQUAD_CLF_2
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"
	min_online_requered = 30
	minimap_color = MINIMAP_SQUAD_BRAVO

/datum/squad/clf/cobra
	name = SQUAD_CLF_3
	equipment_color = "#c47a50"
	chat_color = "#c47a50"
	min_online_requered = 60
	minimap_color = MINIMAP_SQUAD_CHARLIE

/datum/squad/clf/boa
	name = SQUAD_CLF_4
	equipment_color = "#ffc32d"
	chat_color = "#ffe650"
	min_online_requered = 90
	minimap_color = MINIMAP_SQUAD_DELTA

/datum/squad/clf/engagers
	name = SQUAD_CLF_5
	equipment_color = "#2d7aff"
	chat_color = "#2d7aff"

/datum/squad/clf/cryo
	name = SQUAD_CLF_6
	equipment_color = "#c47a50"
	chat_color = "#c47a50"
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	minimap_color = MINIMAP_SQUAD_FOXTROT

	omni_squad_vendor = TRUE

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/clf/intel
	name = SQUAD_CLF_7
	use_stripe_overlay = FALSE
	equipment_color = "#053818"
	minimap_color = MINIMAP_SQUAD_INTEL

	roundstart = FALSE
	prepend_squad_name_to_assignment = FALSE

	max_leaders = 0
	max_specialists = 0
	max_main_supports = 0
	max_supports = 0
	max_medics = 0
	max_engineers = 0

//###############################
/datum/squad/New()
	. = ..()

	tracking_id = SStracking.setup_trackers()
	SStracking.setup_trackers(null, "FT1")
	SStracking.setup_trackers(null, "FT2")
	SStracking.setup_trackers(null, "FT3")
	update_all_squad_info()

	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, PROC_REF(setup_supply_drop_list))

/datum/squad/proc/setup_supply_drop_list()
	SIGNAL_HANDLER

	for(var/i in GLOB.supply_drop_list)
		var/obj/structure/supply_drop/S = i
		if(name == S.squad)
			drop_pad = S
			break

/// Sets an overwatch officer for the squad, returning TRUE on success
/datum/squad/proc/assume_overwatch(mob/target_mob)
	var/mob/previous
	if(overwatch_officer)
		if(overwatch_officer == target_mob)
			return FALSE
		previous = overwatch_officer
		overwatch_officer = null
		clear_ref_tracking(previous)
	overwatch_officer = target_mob
	RegisterSignal(overwatch_officer, COMSIG_PARENT_QDELETING, PROC_REF(personnel_deleted), override = TRUE)
	return TRUE

/// Explicitely relinquish overwatch control
/datum/squad/proc/release_overwatch()
	if(!overwatch_officer)
		return FALSE
	var/mob/operator = overwatch_officer
	overwatch_officer = null
	clear_ref_tracking(operator)
	return TRUE

/// Clear deletion signal as needed for mob - to call *after* removal
/datum/squad/proc/clear_ref_tracking(mob/target_mob)
	if(!target_mob)
		return FALSE
	if(target_mob in marines_list)
		return FALSE
	if(overwatch_officer == target_mob)
		return FALSE
	UnregisterSignal(target_mob, COMSIG_PARENT_QDELETING)
	return TRUE

/// Clear references in squad listing upon deletion. Zap also erases the kept records.
/// NOTE: zap will be set true for a forced COMSIG_PARENT_QDELETING
/datum/squad/proc/personnel_deleted(mob/target_mob, zap = FALSE)
	SIGNAL_HANDLER
	if(target_mob == overwatch_officer)
		overwatch_officer = null
	if(target_mob == squad_leader)
		squad_leader = null
	SStracking.stop_tracking(tracking_id, target_mob)
	if(zap)
		marines_list.Remove(target_mob)
		return
	var/idx = marines_list.Find(target_mob)
	if(idx)
		marines_list[idx] = target_mob.name // legacy behavior, replace mob ref index by name. very weird

/*
 * Send a text message to the squad members following legacy overwatch usage
 *
 * input_text: raw user input as text
 * user: mob reference to whoever the message is sent on behalf of - adds sounds notification
 * displayed_icon: /atom or /icon to display by the message in chat
 * leader_only: if truthy sends only to the squad leader
 */
/datum/squad/proc/send_squad_message(input_text, mob/user, displayed_icon, leader_only = FALSE)
	var/message = sanitize_control_chars(strip_html(input_text))
	var/datum/sound_template/sfx

	if(user)
		message = "[user.name] transmits: [FONT_SIZE_LARGE("<b>[message]<b>")]"
		sfx = new()
		sfx.file = 'sound/effects/radiostatic.ogg'
		sfx.channel = get_free_channel()
		sfx.y = 3
	message = "[SPAN_BLUE("<B>[leader_only ? "SL " : ""]Overwatch:</b> [message]")]"

	var/list/client/targets = list()
	if(leader_only)
		targets = list(squad_leader)
	else
		for(var/mob/mob in marines_list)
			if(!mob.stat && mob.client)
				targets += mob.client

	if(displayed_icon)
		message = "[icon2html(displayed_icon, targets, dir = null)] [message]"
	if(sfx)
		SSsound.queue(sfx, targets)
	to_chat(targets, html = message, type = MESSAGE_TYPE_RADIO)

/// Displays a message to squad members directly on the game map
/datum/squad/proc/send_maptext(text = "", title_text = "", only_leader = 0)
	var/message_colour = chat_color
	if(only_leader)
		if(squad_leader)
			if(!squad_leader.stat && squad_leader.client)
				playsound_client(squad_leader.client, 'sound/effects/radiostatic.ogg', squad_leader.loc, 25, FALSE)
				squad_leader.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[title_text]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order, message_colour)
	else
		for(var/mob/living/carbon/human/marine in marines_list)
			if(!marine.stat && marine.client) //Only living and connected people in our squad
				playsound_client(marine.client, 'sound/effects/radiostatic.ogg', marine.loc, 25, FALSE)
				marine.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[title_text]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order, message_colour)

/// Displays a message to the squad members in chat
/datum/squad/proc/send_message(text = "", plus_name = 0, only_leader = 0)
	var/nametext = ""
	if(plus_name)
		nametext = "[usr.name] transmits: "
		text = "[FONT_SIZE_LARGE("<b>[text]<b>")]"

	if(only_leader)
		if(squad_leader)
			var/mob/living/carbon/human/sl = squad_leader
			if(!sl.stat && sl.client)
				if(plus_name)
					sl << sound('sound/effects/tech_notification.ogg')
				to_chat(sl, "[SPAN_BLUE("<B>SL Overwatch:</b> [nametext][text]")]", type = MESSAGE_TYPE_RADIO)
				return
	else
		for(var/mob/living/carbon/human/human in marines_list)
			if(!human.stat && human.client) //Only living and connected people in our squad
				if(plus_name)
					human << sound('sound/effects/tech_notification.ogg')
				to_chat(human, "[SPAN_BLUE("<B>Overwatch:</b> [nametext][text]")]", type = MESSAGE_TYPE_RADIO)


//Straight-up insert a marine into a squad.
//This sets their ID, increments the total count, and so on. Everything else is done in job_controller.dm.
//So it does not check if the squad is too full already, or randomize it, etc.
/datum/squad/proc/put_marine_in_squad(mob/living/carbon/human/human, obj/item/card/id/ID)
	if(!istype(human))
		return FALSE //Logic
	if(!usable)
		return FALSE
	if(!human.job)
		return FALSE //Not yet
	if(human.assigned_squad)
		return FALSE //already in a squad

	var/obj/item/card/id/id_card = ID
	if(!id_card)
		id_card = human.wear_id
	if(!id_card)
		id_card = human.get_active_hand()
	if(!istype(id_card))
		return FALSE //No ID found

	var/assignment = human.job
	var/paygrade

	var/list/extra_access = list()

	var/slot_check
	var/real_job = GET_DEFAULT_ROLE(human.job)
	if(real_job != "Reinforcements")
		if(real_job in JOB_SQUAD_LEADER_LIST)
			slot_check = "leaders"
		else if(real_job in JOB_SQUAD_SPEC_LIST)
			slot_check = "specialists"
		else if(real_job in JOB_SQUAD_MAIN_SUP_LIST)
			slot_check = "main_supports"
		else if(real_job in JOB_SQUAD_SUP_LIST)
			slot_check = "supports"
		else if(real_job in JOB_SQUAD_MEDIC_LIST)
			slot_check = "medics"
		else if(real_job in JOB_SQUAD_ENGI_LIST)
			slot_check = "engineers"
	vars["num_[slot_check]"]++
	if(slot_check == "engineers" || slot_check ==  "medics")
		id_card.claimedgear = FALSE
	else if(slot_check == "supports")
		human.important_radio_channels += radio_freq
	else if(slot_check == "leaders")
		if(squad_leader && !(list(GET_DEFAULT_ROLE(squad_leader.job)) & JOB_SQUAD_LEADER_LIST)) //field promoted SL
			var/old_lead = squad_leader
			demote_squad_leader() //replaced by the real one
			SStracking.start_tracking(tracking_id, old_lead)
		else
			vars["num_[slot_check]"]--
		assignment = squad_type + " Leader"
		squad_leader = human
		SStracking.set_leader(tracking_id, human)
		SStracking.start_tracking("marine_sl", human)

	if(human.job in list(JOB_MARINE_RAIDER))
		if(name == JOB_MARINE_RAIDER)
			assignment = "Special Operator"

	else if(human.job in list(JOB_MARINE_RAIDER_CMD))
		if(name == JOB_MARINE_RAIDER)
			assignment = "Officer"

	RegisterSignal(human, COMSIG_PARENT_QDELETING, PROC_REF(personnel_deleted), override = TRUE)
	if(assignment != JOB_SQUAD_LEADER)
		SStracking.start_tracking(tracking_id, human)

	count++ //Add up the tally. This is important in even squad distribution.

	if(!(GET_DEFAULT_ROLE(human.job) in JOB_SQUAD_NORMAL_LIST))
		log_admin("[key_name(human)] has been assigned as [name] [human.job]") // we don't want to spam squad marines but the others are useful
	marines_list += human
	human.assigned_squad = src //Add them to the squad
	id_card.access += (src.access + extra_access) //Add their squad access to their ID
	if(prepend_squad_name_to_assignment)
		id_card.assignment = "[name] [assignment]"
	else
		id_card.assignment = assignment

	SEND_SIGNAL(human, COMSIG_SET_SQUAD)

	if(paygrade)
		id_card.paygrade = paygrade
	id_card.name = "[id_card.registered_name]'s ID Card ([id_card.assignment])"

	var/obj/item/device/radio/headset/almayer/marine/headset = locate() in list(human.wear_l_ear, human.wear_r_ear)
	if(headset && radio_freq)
		headset.set_frequency(radio_freq)
	human.update_inv_head()
	human.update_inv_wear_suit()
	human.update_inv_gloves()
	return TRUE

//proc used by the overwatch console to transfer marine to another squad
/datum/squad/proc/remove_marine_from_squad(mob/living/carbon/human/human, obj/item/card/id/ID)
	if(human.assigned_squad != src)
		return //not assigned to the correct squad
	var/obj/item/card/id/id_card = ID
	if(!istype(id_card))
		id_card = human.wear_id
	if(!istype(id_card))
		return FALSE //Abort, no ID found

	id_card.access -= src.access
	id_card.assignment = human.job
	id_card.name = "[id_card.registered_name]'s ID Card ([id_card.assignment])"

	forget_marine_in_squad(human)

//gracefully remove a marine from squad system, alive, dead or otherwise
/datum/squad/proc/forget_marine_in_squad(mob/living/carbon/human/human)
	if(human.assigned_squad.squad_leader == human)
		if(GET_DEFAULT_ROLE(human.job) != JOB_SQUAD_LEADER) //a field promoted SL, not a real one
			demote_squad_leader()
		else
			human.assigned_squad.squad_leader = null
		update_squad_leader()
	else
		if(human.assigned_fireteam)
			if(fireteam_leaders[human.assigned_fireteam] == human)
				unassign_ft_leader(human.assigned_fireteam, TRUE, FALSE)
			unassign_fireteam(human, FALSE)

	count--
	marines_list -= human
	personnel_deleted(human, zap = TRUE) // Free all refs and Zap it entierly as this is on purpose
	clear_ref_tracking(human)
	update_free_mar()
	human.assigned_squad = null

	var/slot_check
	var/real_job = GET_DEFAULT_ROLE(human.job)
	if(real_job != "Reinforcements")
		if(real_job in JOB_SQUAD_LEADER_LIST)
			slot_check = "leaders"
		else if(real_job in JOB_SQUAD_SPEC_LIST)
			slot_check = "specialists"
		else if(real_job in JOB_SQUAD_MAIN_SUP_LIST)
			slot_check = "main_supports"
		else if(real_job in JOB_SQUAD_SUP_LIST)
			slot_check = "supports"
		else if(real_job in JOB_SQUAD_MEDIC_LIST)
			slot_check = "medics"
		else if(real_job in JOB_SQUAD_ENGI_LIST)
			slot_check = "engineers"
	vars["num_[slot_check]"]--

//proc for demoting current Squad Leader
/datum/squad/proc/demote_squad_leader(leader_killed)
	var/mob/living/carbon/human/old_lead = squad_leader

	SStracking.delete_leader(tracking_id)
	SStracking.stop_tracking("marine_sl", old_lead)

	squad_leader = null
	var/real_job = GET_DEFAULT_ROLE(old_lead.job)
	if(real_job in JOB_SQUAD_LEADER_LIST)
		if(!leader_killed)
			old_lead.comm_title = "Sgt"
	else if(real_job in JOB_SQUAD_SPEC_LIST)
		old_lead.comm_title = "Spc"
	else if(real_job in JOB_SQUAD_MAIN_SUP_LIST)
		old_lead.comm_title = "SG"
	else if(real_job in JOB_SQUAD_SUP_LIST)
		old_lead.comm_title = "TL"
	else if(real_job in JOB_SQUAD_MEDIC_LIST)
		old_lead.comm_title = "HM"
	else if(real_job in JOB_SQUAD_ENGI_LIST)
		old_lead.comm_title = "ComTech"
	else if(real_job in list(JOB_MARINE_RAIDER))
		old_lead.comm_title = "Op."
	else if(real_job in list(JOB_MARINE_RAIDER_SL))
		old_lead.comm_title = "TL."
	else if(real_job in list(JOB_MARINE_RAIDER_CMD))
		old_lead.comm_title = "CMD."
	else
		old_lead.comm_title = "RFN"

	if(!(real_job in JOB_SQUAD_LEADER_LIST) || !leader_killed)
		var/obj/item/device/radio/headset/almayer/marine/R = old_lead.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine)
		if(R)
			for(var/obj/item/device/encryptionkey/squadlead/acting/key in R.keys)
				R.keys -= key
				qdel(key)
			R.recalculateChannels()
		if(istype(old_lead.wear_id, /obj/item/card/id))
			var/obj/item/card/id/ID = old_lead.wear_id
			ID.access -= ACCESS_MARINE_LEADER
	REMOVE_TRAITS_IN(old_lead, TRAIT_SOURCE_SQUAD_LEADER)
	old_lead.hud_set_squad()
	old_lead.update_inv_head() //updating marine helmet leader overlays
	old_lead.update_inv_wear_suit()
	to_chat(old_lead, FONT_SIZE_BIG(SPAN_BLUE("You're no longer the [squad_type] Leader for [src]!")))

//Not a safe proc. Returns null if squads or jobs aren't set up.
//Mostly used in the marine squad console in marine_consoles.dm.
/proc/get_squad_by_name(text)
	if(!SSticker.role_authority || SSticker.role_authority.squads.len == 0)
		return null
	var/datum/squad/S
	for(S in SSticker.role_authority.squads)
		if(S.name == text)
			return S
	return null

/datum/squad/proc/engage_squad(toggle_lock = FALSE)
	active = TRUE//Shows up in Overwatch
	usable = TRUE//Shows up in most backend checks
	if(toggle_lock)//Allows adding new marines
		locked = FALSE

/datum/squad/proc/lock_squad(toggle_lock = FALSE)
	active = FALSE
	usable = FALSE
	if(toggle_lock)
		locked = TRUE


//below are procs used by acting SL to organize their squad
/datum/squad/proc/assign_fireteam(fireteam, mob/living/carbon/human/H, upd_ui = TRUE)
	if(H.assigned_fireteam)
		if(fireteam_leaders[H.assigned_fireteam])
			if(fireteam_leaders[H.assigned_fireteam] == H)
				unassign_ft_leader(H.assigned_fireteam, TRUE) //remove marine from TL position
			else
				SStracking.stop_tracking(H.assigned_fireteam, H) //remove from previous FT group
				if(H.stat == CONSCIOUS)
					to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was unassigned from your fireteam.")))
		fireteams[H.assigned_fireteam].Remove(H)
		var/ft = H.assigned_fireteam
		H.assigned_fireteam = fireteam
		fireteams[fireteam].Add(H) //adding to fireteam
		update_fireteam(ft)
		update_fireteam(fireteam)
		if(fireteam_leaders[fireteam]) //if TL exists -> FT group, otherwise -> SL group
			SStracking.start_tracking(fireteam, H)
			if(H.stat == CONSCIOUS)
				to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam]. Report to your Fireteam Leader ASAP.")))
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was assigned to your fireteam.")))
		else
			SStracking.start_tracking(tracking_id, H)
			if(H.stat == CONSCIOUS)
				to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam].")))
	else
		fireteams[fireteam].Add(H)
		H.assigned_fireteam = fireteam //adding to fireteam
		update_fireteam(fireteam)
		update_free_mar()
		if(fireteam_leaders[fireteam])
			SStracking.stop_tracking(tracking_id, H) //remove from previous FT group
			SStracking.start_tracking(fireteam, H)
			if(H.stat == CONSCIOUS)
				to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam]. Report to your Fireteam Leader ASAP.")))
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was assigned to your fireteam.")))
		if(H.stat == CONSCIOUS)
			to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam].")))
	H.hud_set_squad()

/datum/squad/proc/unassign_fireteam(mob/living/carbon/human/H, upd_ui = TRUE)
	fireteams[H.assigned_fireteam].Remove(H)
	var/ft = H.assigned_fireteam
	H.assigned_fireteam = 0
	update_fireteam(ft)
	update_free_mar()
	if(fireteam_leaders[ft])
		SStracking.stop_tracking(ft, H) //remove from FT group
		SStracking.start_tracking(tracking_id, H) //add to SL group
		to_chat(fireteam_leaders[ft], FONT_SIZE_HUGE(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was unassigned from your fireteam.")))
	if(!H.stat)
		to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were unassigned from [ft].")))
	H.hud_set_squad()

/datum/squad/proc/assign_ft_leader(fireteam, mob/living/carbon/human/H, upd_ui = TRUE)
	if(fireteam_leaders[fireteam])
		unassign_ft_leader(fireteam, FALSE, FALSE)
	fireteam_leaders[fireteam] = H
	H.hud_set_squad()
	update_fireteam(fireteam)
	SStracking.set_leader(H.assigned_fireteam, H) //Set FT leader as leader of this group
	SStracking.start_tracking("marine_sl", H)
	if(H.stat == CONSCIOUS)
		to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned as [fireteam] Team Leader.")))

/datum/squad/proc/unassign_ft_leader(fireteam, clear_group_id, upd_ui = TRUE)
	if(!fireteam_leaders[fireteam])
		return
	var/mob/living/carbon/human/H = fireteam_leaders[fireteam]
	fireteam_leaders[fireteam] = null
	H.hud_set_squad()
	if(clear_group_id)
		reassign_ft_tracker_group(fireteam, H.assigned_fireteam, tracking_id) //transfer whole FT to SL group
		update_fireteam(fireteam)
	if(!H.stat)
		to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were unassigned as [fireteam] Team Leader.")))

/datum/squad/proc/unassign_all_ft_leaders()
	for(var/team in fireteam_leaders)
		if(fireteam_leaders[team])
			unassign_ft_leader(team, TRUE, TRUE)

/datum/squad/proc/reassign_ft_tracker_group(fireteam, old_id, new_id)
	for(var/mob/living/carbon/human/H in fireteams[fireteam])
		SStracking.stop_tracking(old_id, H)
		SStracking.start_tracking(new_id, H)

//moved the main proc for ft management from human.dm here to make it support both examine and squad info way to edit fts
/datum/squad/proc/manage_fireteams(mob/living/carbon/human/target)
	var/obj/item/card/id/ID = target.get_idcard()
	if(!ID || !(ID.rank in ROLES_MARINES))
		return
	if(ID.rank == JOB_SQUAD_LEADER || squad_leader == target) //if SL/aSL are chosen
		var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Unassign Fireteam 1 Leader", "Unassign Fireteam 2 Leader", "Unassign Fireteam 3 Leader", "Unassign all Team Leaders"))
		if(target.assigned_squad != src)
			return //in case they somehow change squad while SL is choosing
		if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
			return //if SL got knocked out or demoted while choosing
		switch(choice)
			if("Unassign Fireteam 1 Leader") unassign_ft_leader("FT1", TRUE)
			if("Unassign Fireteam 2 Leader") unassign_ft_leader("FT2", TRUE)
			if("Unassign Fireteam 3 Leader") unassign_ft_leader("FT3", TRUE)
			if("Unassign all Team Leaders") unassign_all_ft_leaders()
			else return
		target.hud_set_squad()
		return
	if(target.assigned_fireteam)
		if(fireteam_leaders[target.assigned_fireteam] == target) //Check if person already is FT leader
			var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Unassign from Team Leader position"))
			if(target.assigned_squad != src)
				return
			if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
				return
			if(choice == "Unassign from Team Leader position")
				unassign_ft_leader(target.assigned_fireteam, TRUE)
			target.hud_set_squad()
			return

		var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Remove from Fireteam", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3", "Assign as Team Leader"))
		if(target.assigned_squad != src)
			return
		if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
			return
		switch(choice)
			if("Remove from Fireteam") unassign_fireteam(target)
			if("Assign to Fireteam 1") assign_fireteam("FT1", target)
			if("Assign to Fireteam 2") assign_fireteam("FT2", target)
			if("Assign to Fireteam 3") assign_fireteam("FT3", target)
			if("Assign as Team Leader") assign_ft_leader(target.assigned_fireteam, target)
			else return
		target.hud_set_squad()
		return

	var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3"))
	if(target.assigned_squad != src)
		return
	if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
		return
	switch(choice)
		if("Assign to Fireteam 1") assign_fireteam("FT1", target)
		if("Assign to Fireteam 2") assign_fireteam("FT2", target)
		if("Assign to Fireteam 3") assign_fireteam("FT3", target)
		else return
	target.hud_set_squad()
	return

//Managing MIA and KIA statuses for marines
/datum/squad/proc/change_squad_status(mob/living/carbon/human/target)
	if(target == squad_leader)
		return //you can't mark yourself KIA
	var/choice = tgui_input_list(squad_leader, "Marine status management: M.I.A. for missing marines, K.I.A. for confirmed unrevivable dead.", "Squad Management", list("Cancel", "Remove status", "M.I.A.", "K.I.A."))
	if(target.assigned_squad != src)
		return //in case they somehow change squad while SL is choosing
	if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
		return //if SL got knocked out or demoted while choosing
	switch(choice)
		if("Remove status") target.squad_status = null
		if("M.I.A.")
			target.squad_status = choice
			to_chat(squad_leader, FONT_SIZE_BIG(SPAN_BLUE("You set [target]'s status as Missing In Action.")))
			if(target.stat == CONSCIOUS)
				to_chat(target, FONT_SIZE_HUGE(SPAN_BLUE("You were marked as Missing In Action by Squad Leader.")))
		if("K.I.A.")
			target.squad_status = choice
			if(target.assigned_fireteam)
				if(fireteam_leaders[target.assigned_fireteam] == target)
					unassign_ft_leader(target.assigned_fireteam, TRUE, FALSE)
				unassign_fireteam(target, FALSE)
			to_chat(squad_leader, FONT_SIZE_BIG(SPAN_BLUE("You set [target]'s status as Killed In Action. If they were Team Leader or in fireteam, they were demoted and unassigned.")))
			if(target.stat == CONSCIOUS)
				to_chat(target, FONT_SIZE_HUGE(SPAN_BLUE("You were marked as Killed In Action by Squad Leader.")))
		else return
	if(target.assigned_fireteam)
		update_fireteam(target.assigned_fireteam)
	else
		update_free_mar()
	target.hud_set_squad()
	return
