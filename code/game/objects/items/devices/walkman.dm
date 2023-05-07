/obj/item/device/walkman
	name = "walkman"
	desc = "A cassette player that first hit the market over 200 years ago. Crazy how these never went out of style."
	icon = 'icons/obj/items/walkman.dmi'
	icon_state = "walkman"
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_WAIST | SLOT_EAR
	actions_types = list(/datum/action/item_action/walkman/play_pause,/datum/action/item_action/walkman/next_song,/datum/action/item_action/walkman/restart_song)
	var/obj/item/device/cassette_tape/tape
	var/paused = TRUE
	var/list/current_playlist = list()
	var/list/current_songnames = list()
	var/sound/current_song
	var/mob/current_listener
	var/pl_index = 1
	var/volume = 25
	var/design = 1 // What kind of walkman design style to use
	var/time_to_next_song = 0
	item_icons = list(
		WEAR_L_EAR = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_R_EAR = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_WAIST = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_IN_J_STORE = 'icons/mob/humans/onmob/ears.dmi'
		)
	black_market_value = 15

/obj/item/device/walkman/Initialize()
	. = ..()
	design = rand(1, 5)
	update_icon()

/obj/item/device/walkman/Destroy()
	QDEL_NULL(tape)
	break_sound()
	current_song = null
	current_listener = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/device/walkman/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/device/cassette_tape))
		if(W == user.get_active_hand() && (src in user))
			if(!tape)
				insert_tape(W)
				playsound(src,'sound/weapons/handcuffs.ogg',20,1)
				to_chat(user,SPAN_INFO("You insert \the [W] into \the [src]"))
			else
				to_chat(user,SPAN_WARNING("Remove the other tape first!"))

/obj/item/device/walkman/attack_self(mob/user)
	..()

	if(!current_listener)
		current_listener = user
		START_PROCESSING(SSobj, src)
	if(istype(tape))
		if(paused)
			play()
			to_chat(user,SPAN_INFO("You press [src]'s 'play' button"))
		else
			pause()
			to_chat(user,SPAN_INFO("You pause [src]"))
		update_icon()
	else
		to_chat(user,SPAN_INFO("There's no tape to play"))
	playsound(src,'sound/machines/click.ogg',20,1)

/obj/item/device/walkman/attack_hand(mob/user)
	if(tape && src == user.get_inactive_hand())
		eject_tape(user)
		return
	else
		..()


/obj/item/device/walkman/proc/break_sound()
	var/sound/break_sound = sound(null, 0, 0, SOUND_CHANNEL_WALKMAN)
	break_sound.priority = 255
	update_song(break_sound, current_listener, 0)

/obj/item/device/walkman/proc/update_song(sound/S, mob/M, flags = SOUND_UPDATE)
	if(!istype(M) || !istype(S)) return
	if(M.ear_deaf > 0)
		flags |= SOUND_MUTE
	S.status = flags
	S.volume = src.volume
	S.channel = SOUND_CHANNEL_WALKMAN
	sound_to(M,S)

/obj/item/device/walkman/proc/pause(mob/user)
	if(!current_song) return
	paused = TRUE
	update_song(current_song,current_listener, SOUND_PAUSED | SOUND_UPDATE)

/obj/item/device/walkman/proc/play()
	if(!current_song)
		if(current_playlist.len > 0)
			current_song = sound(current_playlist[pl_index], 0, 0, SOUND_CHANNEL_WALKMAN, volume)
			current_song.status = SOUND_STREAM
		else
			return
	paused = FALSE
	if(current_song.status & SOUND_PAUSED)
		to_chat(current_listener,SPAN_INFO("Resuming [pl_index] of [current_playlist.len]"))
		update_song(current_song,current_listener)
	else
		to_chat(current_listener,SPAN_INFO("Now playing [pl_index] of [current_playlist.len]"))
		update_song(current_song,current_listener,0)

	update_song(current_song,current_listener)

/obj/item/device/walkman/proc/insert_tape(obj/item/device/cassette_tape/CT)
	if(tape || !istype(CT)) return

	tape = CT
	if(ishuman(CT.loc))
		var/mob/living/carbon/human/H = CT.loc
		H.drop_held_item(CT)
	CT.forceMove(src)

	update_icon()
	paused = TRUE
	pl_index = 1
	if(tape.songs["side1"] && tape.songs["side2"])
		var/list/L = tape.songs["[tape.flipped ? "side2" : "side1"]"]
		for(var/S in L)
			current_playlist += S
			current_songnames += L[S]


/obj/item/device/walkman/proc/eject_tape(mob/user)
	if(!tape) return

	break_sound()

	current_song = null
	current_playlist.Cut()
	current_songnames.Cut()
	user.put_in_hands(tape)
	paused = TRUE
	tape = null
	update_icon()
	playsound(src,'sound/weapons/handcuffs.ogg',20,1)
	to_chat(user,SPAN_INFO("You eject the tape from [src]"))

/obj/item/device/walkman/proc/next_song(mob/user)

	if(user.is_mob_incapacitated() || current_playlist.len == 0)
		return

	break_sound()

	if(pl_index + 1 <= current_playlist.len)
		pl_index++
	else
		pl_index = 1
	current_song = sound(current_playlist[pl_index], 0, 0, SOUND_CHANNEL_WALKMAN, volume)
	current_song.status = SOUND_STREAM
	play()
	to_chat(user,SPAN_INFO("You change the song"))


/obj/item/device/walkman/update_icon()
	..()
	overlays.Cut()
	if(design)
		overlays += "+[design]"
	if(tape)
		if(!paused)
			overlays += "+playing"
	else
		overlays += "+empty"

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.regenerate_icons()

/obj/item/device/walkman/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if((slot == WEAR_L_EAR || slot == WEAR_R_EAR) && !paused)
		var/image/I = overlay_image(ret.icon, "+music", color, RESET_COLOR)
		ret.overlays += I
	return ret

/obj/item/device/walkman/process()
	if(!(src in current_listener.GetAllContents(3)) || current_listener.stat & DEAD)
		if(current_song)
			current_song = null
		break_sound()
		paused = TRUE
		current_listener = null
		update_icon()
		STOP_PROCESSING(SSobj, src)
		return

	if(current_listener)
		for(var/sound/S in current_listener.client.SoundQuery())
			if(S.file == current_song.file)
				var/sound/CS = S
				time_to_next_song = (CS.len * 10 - CS.offset * 10) + world.time
	if(world.time > time_to_next_song)
		next_song(current_listener)

	if(current_listener.ear_deaf > 0 && current_song && !(current_song.status & SOUND_MUTE))
		update_song(current_song, current_listener)
	if(current_listener.ear_deaf == 0 && current_song && current_song.status & SOUND_MUTE)
		update_song(current_song, current_listener)

/obj/item/device/walkman/verb/play_pause()
	set name = "Play/Pause"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	attack_self(usr)

/obj/item/device/walkman/verb/eject_cassetetape()
	set name = "Eject tape"
	set category = "Object"
	set src in usr

	eject_tape(usr)

/obj/item/device/walkman/verb/next_pl_song()
	set name = "Next song"
	set category = "Object"
	set src in usr

	next_song(usr)

/obj/item/device/walkman/verb/change_volume()
	set name = "Change Walkman volume"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated() || !current_song) return

	var/tmp = tgui_input_number(usr,"Change the volume (0 - 100)","Volume", volume, 100, 0)
	if(tmp == null) return
	if(tmp > 100) tmp = 100
	if(tmp < 0) tmp = 0
	volume = tmp
	update_song(current_song, current_listener)

/obj/item/device/walkman/proc/restart_song(mob/user)
	if(user.is_mob_incapacitated() || !current_song) return

	update_song(current_song, current_listener, 0)
	to_chat(user,SPAN_INFO("You restart the song"))

/obj/item/device/walkman/verb/restart_current_song()
	set name = "Restart Song"
	set category = "Object"
	set src in usr

	restart_song(usr)

/*

	ACTION BUTTONS

*/

/datum/action/item_action/walkman

/datum/action/item_action/walkman/New()
	..()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/walkman/play_pause
	action_icon_state = "walkman_playpause"

/datum/action/item_action/walkman/play_pause/New()
	..()
	name = "Play/Pause"
	button.name = name

/datum/action/item_action/walkman/play_pause/action_activate()
	if(target)
		var/obj/item/device/walkman/WM = target
		WM.play_pause()

/datum/action/item_action/walkman/next_song
	action_icon_state = "walkman_next"

/datum/action/item_action/walkman/next_song/New()
	..()
	name = "Next song"
	button.name = name

/datum/action/item_action/walkman/next_song/action_activate()
	if(target)
		var/obj/item/device/walkman/WM = target
		WM.next_pl_song()

/datum/action/item_action/walkman/restart_song
	action_icon_state = "walkman_restart"

/datum/action/item_action/walkman/restart_song/New()
	..()
	name = "Restart song"
	button.name = name

/datum/action/item_action/walkman/restart_song/action_activate()
	if(target)
		var/obj/item/device/walkman/WM = target
		WM.restart_current_song()

/*
	TAPES
*/
/obj/item/device/cassette_tape
	name = "cassette Tape"
	desc = "A cassette tape"
	icon = 'icons/obj/items/walkman.dmi'
	icon_state = "cassette_flip"
	w_class = SIZE_SMALL
	black_market_value = 15
	var/side1_icon = "cassette"
	var/flipped = FALSE //Tape side
	var/list/songs = list()
	var/id = 1

/obj/item/device/cassette_tape/attack_self(mob/user)
	..()

	if(flipped == TRUE)
		flipped = FALSE
		icon_state = side1_icon
	else
		flipped = TRUE
		icon_state = "cassette_flip"
	to_chat(user,"You flip [src]")

/obj/item/device/cassette_tape/verb/flip()
	set name = "Flip tape"
	set category = "Object"
	set src in usr

	attack_self()

/obj/item/device/cassette_tape/lybe
	name = "old cassette"
	id = 2
	desc = "A plastic cassette tape with lybe named sticker."
	icon_state = "cassette_blue"
	side1_icon = "cassette_blue"
	songs = list("side1" = list("sound/music/walkman/lybe/1-1-1.ogg",\
								"sound/music/walkman/lybe/1-1-2.ogg",\
								"sound/music/walkman/lybe/1-1-3.ogg"),\
				 "side2" = list("sound/music/walkman/lybe/1-2-1.ogg",\
								"sound/music/walkman/lybe/1-2-2.ogg",\
								"sound/music/walkman/lybe/1-2-3.ogg"))

/obj/item/device/cassette_tape/sad
	name = "black cassette"
	id = 3
	desc = "A plastic cassette tape with a rainbow-colored sticker."
	desc = "A plastic cassette tape with a sad sticker."
	icon_state = "cassette_rainbow"
	side1_icon = "cassette_rainbow"
	songs = list("side1" = list("sound/music/walkman/sad/2-1-1.ogg",\
								"sound/music/walkman/sad/2-1-2.ogg",\
								"sound/music/walkman/sad/2-1-3.ogg"),\
				 "side2" = list("sound/music/walkman/sad/2-2-1.ogg",\
								"sound/music/walkman/sad/2-2-2.ogg",\
								"sound/music/walkman/sad/2-2-3.ogg"))

/obj/item/device/cassette_tape/sovietwave
	name = "red cassette"
	id = 4
	desc = "A plastic cassette tape with a red star."
	icon_state = "cassette_red_black"
	side1_icon = "cassette_red_black"
	songs = list("side1" = list("sound/music/walkman/sovietwave/3-1-1.ogg",\
								"sound/music/walkman/sovietwave/3-1-2.ogg",\
								"sound/music/walkman/sovietwave/3-1-3.ogg"),\
				 "side2" = list("sound/music/walkman/sovietwave/3-2-1.ogg",\
								"sound/music/walkman/sovietwave/3-2-2.ogg",\
								"sound/music/walkman/sovietwave/3-2-3.ogg"))
