//There has to be a better way to define this shit. ~ Z
//can't equip anything
/mob/living/carbon/xenomorph/attack_ui(slot_id)
	return

/mob/living/carbon/xenomorph/attack_animal(mob/living/living as mob)

	if(isanimal(living))
		var/mob/living/simple_animal/S = living
		if(!S.melee_damage_upper)
			S.emote("[S.friendly] [src]")
		else
			living.animation_attack_on(src)
			living.flick_attack_overlay(src, "punch")
			visible_message(SPAN_DANGER("[S] [S.attacktext] [src]!"), null, null, 5, CHAT_TYPE_MELEE_HIT)
			var/damage = rand(S.melee_damage_lower, S.melee_damage_upper)
			apply_damage(damage, BRUTE)
			last_damage_data = create_cause_data(initial(living.name), living)
			S.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [key_name(src)]</font>")
			attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [key_name(S)]</font>")
			updatehealth()

/mob/living/carbon/xenomorph/attack_hand(mob/living/carbon/human/human)
	if(..())
		return TRUE

	switch(human.a_intent)

		if(INTENT_HELP)
			if(back && Adjacent(human))
				back.add_fingerprint(human)
				var/obj/item/storage/backpack = back
				if(backpack && !human.action_busy)
					if(stat != DEAD) // If the Xeno is alive, fight back
						if(!human.ally(faction))
							human.KnockDown(rand(caste.tacklestrength_min, caste.tacklestrength_max))
							playsound(human.loc, 'sound/weapons/pierce.ogg', 25, TRUE)
							human.visible_message(SPAN_WARNING("\The [human] tried to open \the [backpack] on [src] but instead gets a tail swipe to the head!"))
							return FALSE

					human.visible_message(SPAN_NOTICE("\The [human] starts opening \the [backpack] on [src]"), \
					SPAN_NOTICE("You begin to open \the [backpack] on [src], so you can check its contents."), null, 5, CHAT_TYPE_FLUFF_ACTION)
					if(!do_after(human, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_GENERIC)) //Timed opening.
						to_chat(human, SPAN_WARNING("You were interrupted!"))
						return FALSE
					if(!Adjacent(human))
						to_chat(human, SPAN_WARNING("You were interrupted!"))
						return FALSE
					backpack.open(human)
					return
			if(stat == DEAD)
				human.visible_message(SPAN_WARNING("\The [human] pokes \the [src], but nothing happens."), \
				SPAN_WARNING("You poke \the [src], but nothing happens."), null, 5, CHAT_TYPE_FLUFF_ACTION)
			else
				human.visible_message(SPAN_WARNING("\The [human] pokes \the [src]."), \
				SPAN_WARNING("You poke \the [src]."), null, 5, CHAT_TYPE_FLUFF_ACTION)

		if(INTENT_GRAB)
			if(human == src || anchored)
				return 0

			if(stat != DEAD && ishuman_strict(human))
				return 0

			human.start_pulling(src)

		else
			var/datum/unarmed_attack/attack = human.species.unarmed
			if(!attack.is_usable(human)) attack = human.species.secondary_unarmed
			if(!attack.is_usable(human))
				return 0

			human.animation_attack_on(src)
			human.flick_attack_overlay(src, "punch")

			var/damage = rand(1, 3)
			if(prob(85))
				damage += attack.damage > 5 ? attack.damage : 0

				playsound(loc, attack.attack_sound, 25, 1)
				visible_message(SPAN_DANGER("[human] [pick(attack.attack_verb)]ed [src]!"), null, null, 5, CHAT_TYPE_MELEE_HIT)
				apply_damage(damage, BRUTE)
				updatehealth()
			else
				playsound(loc, attack.miss_sound, 25, 1)
				visible_message(SPAN_DANGER("[human] tried to [pick(attack.attack_verb)] [src]!"), null, null, 5, CHAT_TYPE_MELEE_HIT)

	return

/mob/living/carbon/xenomorph/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.fortify || xeno.burrow)
		return XENO_NO_DELAY_ACTION

	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return XENO_NO_DELAY_ACTION

	if(islarva(xeno)) //Larvas can't eat people
		xeno.visible_message(SPAN_DANGER("[xeno] nudges its head against \the [src]."), \
		SPAN_DANGER("You nudge your head against \the [src]."), null, null, CHAT_TYPE_XENO_FLUFF)
		return

	switch(xeno.a_intent)
		if(INTENT_HELP)
			if(on_fire)
				extinguish_mob(xeno)
			else if(xeno.zone_selected == "head")
				xeno.attempt_headbutt(src)
				return XENO_NONCOMBAT_ACTION
			else if(xeno.zone_selected == "groin")
				xeno.attempt_tailswipe(src)
				return XENO_NONCOMBAT_ACTION
			else
				xeno.visible_message(SPAN_NOTICE("\The [xeno] caresses \the [src] with its claws."), \
				SPAN_NOTICE("You caress \the [src] with your claws."), null, 5, CHAT_TYPE_XENO_FLUFF)

		if(INTENT_GRAB)
			if(xeno == src || anchored)
				return XENO_NO_DELAY_ACTION

			if(Adjacent(xeno)) //Logic!
				xeno.start_pulling(src)

				xeno.visible_message(SPAN_WARNING("[xeno] grabs \the [src]!"), \
				SPAN_WARNING("You grab \the [src]!"), null, 5, CHAT_TYPE_XENO_FLUFF)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)

		if(INTENT_HARM)
			if(xeno.behavior_delegate && xeno.behavior_delegate.handle_slash(src))
				return XENO_NO_DELAY_ACTION

			if(stat == DEAD)
				to_chat(xeno, SPAN_WARNING("[src] is dead, why would you want to touch it?"))
				return XENO_NO_DELAY_ACTION

			if(xeno.can_not_harm(src))
				return XENO_NO_DELAY_ACTION

			xeno.animation_attack_on(src)

			// copypasted from attack_alien.dm
			//From this point, we are certain a full attack will go out. Calculate damage and modifiers
			xeno.track_slashes(xeno.caste_type) //Adds to slash stat.
			var/damage = get_xeno_damage_slash(src, rand(xeno.melee_damage_lower, xeno.melee_damage_upper))

			if(xeno.behavior_delegate)
				damage = xeno.behavior_delegate.melee_attack_modify_damage(damage, src)

			//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
			if(xeno.frenzy_aura > 0)
				damage += (xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)

			//Somehow we will deal no damage on this attack
			if(!damage)
				playsound(xeno.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
				xeno.visible_message(SPAN_DANGER("\The [xeno] lunges at [src]!"), \
				SPAN_DANGER("You lunge at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				return XENO_ATTACK_ACTION

			xeno.visible_message(SPAN_DANGER("\The [xeno] [slashes_verb] [src]!"), \
			SPAN_DANGER("You [slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			last_damage_data = create_cause_data(initial(xeno.name), xeno)
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was [slash_verb]ed by [key_name(xeno)]</font>")
			xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>[slash_verb]ed [key_name(src)]</font>")
			log_attack("[key_name(xeno)] [slash_verb]ed [key_name(src)]")
			xeno.flick_attack_overlay(src, "slash")
			if(custom_slashed_sound)
				playsound(loc, custom_slashed_sound, 25, 1)
			else
				playsound(loc, slash_sound, 25, 1)
			apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, effectiveness_mult = XVX_ARMOR_EFFECTIVEMULT)

			if(xeno.behavior_delegate)
				var/datum/behavior_delegate/MD = xeno.behavior_delegate
				MD.melee_attack_additional_effects_target(src)
				MD.melee_attack_additional_effects_self()

			SEND_SIGNAL(xeno, COMSIG_XENO_ALIEN_ATTACK, src)

		if(INTENT_DISARM)
			xeno.animation_attack_on(src)
			xeno.flick_attack_overlay(src, "disarm")
			var/is_shover_queen = isqueen(xeno)
			var/can_resist_shove = xeno.faction != faction || ((isqueen(src) || IS_XENO_LEADER(src)) && !is_shover_queen)
			var/can_mega_shove = is_shover_queen || IS_XENO_LEADER(xeno)
			if(can_mega_shove && !can_resist_shove || (mob_size < MOB_SIZE_XENO_SMALL && xeno.mob_size >= MOB_SIZE_XENO_SMALL))
				playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
				xeno.visible_message(SPAN_WARNING("\The [xeno] shoves \the [src] out of her way!"), \
				SPAN_WARNING("You shove \the [src] out of your way!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				src.apply_effect(1, WEAKEN)
			else
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
				xeno.visible_message(SPAN_WARNING("\The [xeno] shoves \the [src]!"), \
				SPAN_WARNING("You shove \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/mob/living/carbon/xenomorph/proc/attempt_headbutt(mob/living/carbon/xenomorph/target)
	//Responding to a raised head
	if(target.flags_emote & EMOTING_HEADBUTT && do_after(src, 5, INTERRUPT_MOVED, EMOTE_ICON_HEADBUTT))
		if(!(target.flags_emote & EMOTING_HEADBUTT)) //Additional check for if the target moved or was already headbutted.
			to_chat(src, SPAN_NOTICE("Too slow!"))
			return
		target.flags_emote &= ~EMOTING_HEADBUTT
		visible_message(SPAN_NOTICE("[src] slams their head into [target]!"), \
			SPAN_NOTICE("You slam your head into [target]!"), null, 4)
		playsound(src, pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'), 50, 1)
		animation_attack_on(target)
		target.animation_attack_on(src)
		start_audio_emote_cooldown()
		target.start_audio_emote_cooldown()
		return

	//Initiate headbutt
	if(recent_audio_emote)
		to_chat(src, "You just did an audible emote. Wait a while.")
		return

	visible_message(SPAN_NOTICE("[src] raises their head for a headbutt from [target]."), \
		SPAN_NOTICE("You raise your head for a headbutt from [target]."), null, 4)
	flags_emote |= EMOTING_HEADBUTT
	if(do_after(src, 50, INTERRUPT_ALL|INTERRUPT_EMOTE, EMOTE_ICON_HEADBUTT) && flags_emote & EMOTING_HEADBUTT)
		to_chat(src, SPAN_NOTICE("You were left hanging!"))
	flags_emote &= ~EMOTING_HEADBUTT

/mob/living/carbon/xenomorph/proc/attempt_tailswipe(mob/living/carbon/xenomorph/target)
	//Responding to a raised tail
	if(target.flags_emote & EMOTING_TAIL_SWIPE && do_after(src, 5, INTERRUPT_MOVED, EMOTE_ICON_TAILSWIPE))
		if(!(target.flags_emote & EMOTING_TAIL_SWIPE)) //Additional check for if the target moved or was already tail swiped.
			to_chat(src, SPAN_NOTICE("Too slow!"))
			return
		target.flags_emote &= ~EMOTING_TAIL_SWIPE
		visible_message(SPAN_NOTICE("[src] clashes their tail with [target]!"), \
			SPAN_NOTICE("You clash your tail with [target]!"), null, 4)
		playsound(src, 'sound/weapons/alien_claw_block.ogg', 50, 1)
		spin_circle()
		target.spin_circle()
		start_audio_emote_cooldown()
		target.start_audio_emote_cooldown()
		return

	//Initiate tail swipe
	if(recent_audio_emote)
		to_chat(src, "You just did an audible emote. Wait a while.")
		return

	visible_message(SPAN_NOTICE("[src] raises their tail out for a swipe from [target]."), \
		SPAN_NOTICE("You raise your tail out for a tail swipe from [target]."), null, 4)
	flags_emote |= EMOTING_TAIL_SWIPE
	if(do_after(src, 50, INTERRUPT_ALL|INTERRUPT_EMOTE, EMOTE_ICON_TAILSWIPE) && flags_emote & EMOTING_TAIL_SWIPE)
		to_chat(src, SPAN_NOTICE("You were left hanging!"))
	flags_emote &= ~EMOTING_TAIL_SWIPE
