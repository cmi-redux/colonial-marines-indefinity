//xenomorph hive announcement
/proc/xeno_announcement(message, datum/faction/faction_to_display = GLOB.faction_datum[FACTION_XENOMORPH_NORMAL], title = QUEEN_ANNOUNCE)
	var/list/targets = GLOB.dead_mob_list
	if(faction_to_display == "Everyone")
		for(var/mob/living/carbon/xenomorph/X in GLOB.living_xeno_list)
			if(istype(X))	//filter out any potential non-xenomorphs/observers mobs
				targets.Add(X)

		announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))
	else
		for(var/mob/living/carbon/xenomorph/X in faction_to_display.totalMobs)
			targets.Add(X)

		announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))


//general faction announcement
/proc/faction_announcement(message, title = COMMAND_ANNOUNCE, sound_to_play = sound('sound/misc/notice2.ogg'), datum/faction/faction_to_display = GLOB.faction_datum[FACTION_MARINE], signature)
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	if(faction_to_display == GLOB.faction_datum[FACTION_MARINE])
		for(var/mob/M in targets)
			if(isobserver(M)) //observers see everything
				continue
			var/mob/living/carbon/human/H = M
			if(!istype(H) || H.stat != CONSCIOUS || isyautja(H)) //base human checks
				targets.Remove(H)
				continue
			if(is_mainship_level(H.z)) // People on ship see everything
				continue
			if(H.faction != faction_to_display)
				targets.Remove(H)

	else if(faction_to_display == "Everyone (-Yautja)")
		for(var/mob/M in targets)
			if(isobserver(M)) //observers see everything
				continue
			var/mob/living/carbon/human/H = M
			if(!istype(H) || H.stat != CONSCIOUS || isyautja(H))
				targets.Remove(H)

	else
		for(var/mob/M in targets)
			if(isobserver(M)) //observers see everything
				continue
			var/mob/living/carbon/human/H = M
			if(!istype(H) || H.stat != CONSCIOUS || isyautja(H))
				targets.Remove(H)
				continue
			if(H.faction != faction_to_display)
				targets.Remove(H)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"

	announcement_helper(message, title, targets, sound_to_play)

//yautja ship AI announcement
/proc/yautja_announcement(message, title = YAUTJA_ANNOUNCE, sound_to_play = sound('sound/misc/notice1.ogg'))
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/M in targets)
		if(isobserver(M)) //observers see everything
			continue
		var/mob/living/carbon/human/H = M
		if(!isyautja(H) || H.stat != CONSCIOUS)
			targets.Remove(H)

	announcement_helper(message, title, targets, sound_to_play)

//AI announcement that uses talking into comms
/proc/ai_announcement(message, sound_to_play = sound('sound/misc/interference.ogg'))
	for(var/mob/M in (GLOB.human_mob_list + GLOB.dead_mob_list))
		if(isobserver(M) || ishuman(M) && is_mainship_level(M.z))
			playsound_client(M.client, sound_to_play, M, vol = 45)

	for(var/mob/living/silicon/decoy/ship_ai/AI in ai_mob_list)
		INVOKE_ASYNC(AI, TYPE_PROC_REF(/mob/living/silicon/decoy/ship_ai, say), message)

/proc/ai_silent_announcement(message, channel_prefix, bypass_cooldown = FALSE)
	if(!message)
		return

	for(var/mob/living/silicon/decoy/ship_ai/AI in ai_mob_list)
		if(channel_prefix)
			message = "[channel_prefix][message]"
		INVOKE_ASYNC(AI, TYPE_PROC_REF(/mob/living/silicon/decoy/ship_ai, say), message)

/mob/proc/detectable_by_ai()
	return TRUE

/mob/living/carbon/human/detectable_by_ai()
	if(gloves && gloves.hide_prints)
		return FALSE
	. = ..()

//AI shipside announcement, that uses announcement mechanic instead of talking into comms
//to ensure that all humans on ship hear it regardless of comms and power
/proc/shipwide_ai_announcement(message, title = MAIN_AI_SYSTEM, sound_to_play = sound('sound/misc/interference.ogg'), signature)
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/mob in targets)
		if(isobserver(mob))
			continue
		if(!ishuman(mob) || isyautja(mob) || !is_mainship_level(mob.z))
			targets.Remove(mob)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"

	announcement_helper(message, title, targets, sound_to_play)
//Subtype of AI shipside announcement for "All Hands On Deck" alerts (COs and SEAs joining the game)
/proc/all_hands_on_deck(message, title = MAIN_AI_SYSTEM, sound_to_play = sound('sound/misc/sound_misc_boatswain.ogg'), signature)
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/mob in targets)
		if(isobserver(mob))
			continue
		if(!ishuman(mob) || isyautja(mob) || !is_mainship_level(mob.z))
			targets.Remove(mob)

	announcement_helper(message, title, targets, sound_to_play)

//the announcement proc that handles announcing for each mob in targets list
/proc/announcement_helper(message, title, list/targets, sound_to_play)
	if(!message || !title || !sound_to_play || !targets) //Shouldn't happen
		return
	for(var/mob/mob in targets)
		if(istype(mob, /mob/new_player))
			continue

		to_chat_spaced(mob, html = "[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(message)]")
		playsound_client(mob.client, sound_to_play, mob, vol = 45)
