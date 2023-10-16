/datum/effects/mob_overlay_effect //should make this generic and the water_overlay a seperate thing
	effect_name = "mob_effect_overlay"
	icon_path = 'icons/effects/mob_overlay_effects.dmi'
	flags = INF_DURATION|EFFECT_NO_PROCESS
	var/obj/effect/mob_overlay_effect/the_effect
	var/pixel_y_offset = 0
	var/mask_pixel_y_offset = 0

/datum/effects/mob_overlay_effect/New(atom/input_atom)
	.=..()

	the_effect = new /obj/effect/mob_overlay_effect()
	the_effect.owner = src

	update_icons(get_turf(input_atom))

/datum/effects/mob_overlay_effect/Destroy()
	QDEL_NULL(the_effect)

	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/affected_human = affected_atom
		animate(affected_human, pixel_y = initial(affected_human.pixel_y), 0.2 SECONDS)
		affected_human.update_effects()
		for(var/i in 1 to length(affected_human.vis_contents))
			if(istype(affected_human.vis_contents[i], /obj/effect/mob_overlay_effect))
				affected_human.vis_contents -= affected_human.vis_contents[i]

	return ..()

/datum/effects/mob_overlay_effect/proc/update_icons(turf/open/input_openturf)
	obj_icon_state_path = input_openturf.icon_state
	mob_icon_state_path = input_openturf.icon_state

	if(ishuman(affected_atom))

		var/mob/living/carbon/human/affected_human = affected_atom
		affected_human.update_effects(mask_pixel_y_offset ? ABOVE_MOB_LAYER : FALSE)

		if(!mask_pixel_y_offset)
			for(var/i in 1 to length(affected_human.vis_contents))
				if(istype(affected_human.vis_contents[i], /obj/effect/mob_overlay_effect))
					affected_human.vis_contents -= affected_human.vis_contents[i]
					qdel(the_effect)

		animate(affected_human, pixel_y = pixel_y_offset, 0.2 SECONDS)
		if(mask_pixel_y_offset)
			the_effect.set_up_icon(input_openturf, affected_atom, mask_pixel_y_offset)
		else
			the_effect.overlays.Cut()
		affected_human.vis_contents |= the_effect

/obj/effect/mob_overlay_effect
	name = ""
	mouse_opacity = FALSE
	alpha = 180
	blend_mode = BLEND_INSET_OVERLAY
	var/datum/effects/mob_overlay_effect/owner

/obj/effect/mob_overlay_effect/Destroy()
	. = ..()
	owner = null

/obj/effect/mob_overlay_effect/proc/adjust_transform(turf/open/input_openturf, mob/living/carbon/human/input_human, mask_pixel_y_offset = 0)
	set_up_icon(input_openturf, input_human, mask_pixel_y_offset)

/obj/effect/mob_overlay_effect/proc/set_up_icon(turf/open/input_openturf, mob/living/carbon/human/input_human, mask_pixel_y_offset = 0)
	if(input_human.lying)
		var/matrix/matrix = matrix() //all this to make their face actually face the floor... sigh... I hate resting code
		switch(input_human.transform.b)
			if(1)
				matrix.Turn(270)
			if(-1)
				matrix.Turn(90)
		mask_pixel_y_offset = -12
		apply_transform(matrix)
	else
		apply_transform()

	overlays.Cut()
	var/icon/output_texture = icon(input_openturf.icon, input_openturf.icon_state)
	output_texture.Shift(SOUTH, mask_pixel_y_offset, TRUE) //south since we want it opposite the + - of the value
	var/icon/subtraction_texture = icon(owner.icon_path, "culling_mask")
	subtraction_texture.Shift(SOUTH, (32 - abs(mask_pixel_y_offset)-3), FALSE)
	output_texture.AddAlphaMask(subtraction_texture)
	var/mutable_appearance/final_texture = mutable_appearance(output_texture)
	final_texture.layer = input_human.layer + 0.02
	final_texture.plane = input_human.plane
	overlays += final_texture
