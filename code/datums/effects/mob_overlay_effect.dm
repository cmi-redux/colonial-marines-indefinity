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
	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/affected_human = affected_atom
		animate(affected_human, pixel_y = initial(affected_human.pixel_y), 0.2 SECONDS)
		affected_human.update_effects()
		affected_human.vis_contents -= the_effect

	QDEL_NULL(the_effect)

	return ..()

/datum/effects/mob_overlay_effect/proc/update_icons(turf/open/input_openturf)
	obj_icon_state_path = input_openturf.icon_state
	mob_icon_state_path = input_openturf.icon_state

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/affected_human = affected_atom
		if(!mask_pixel_y_offset)
			affected_human.vis_contents -= the_effect

		animate(affected_human, pixel_y = pixel_y_offset, 0.2 SECONDS)
		if(mask_pixel_y_offset)
			the_effect.set_up_icon(input_openturf, affected_atom, mask_pixel_y_offset)
		else
			the_effect.overlays.Cut()
		if(mask_pixel_y_offset)
			affected_human.vis_contents |= the_effect

/obj/effect/mob_overlay_effect
	name = ""
	mouse_opacity = FALSE
	alpha = 180
	blend_mode = BLEND_INSET_OVERLAY
	var/datum/effects/mob_overlay_effect/owner

/obj/effect/mob_overlay_effect/Initialize(mapload, ...)
	. = ..()
	add_filter("mob_efect_reverse_alpha_mask", 1, alpha_mask_filter(render_source = MOB_REVERSE_RENDER_TARGET, flags = MASK_INVERSE))

/obj/effect/mob_overlay_effect/Destroy()
	. = ..()
	owner = null

/obj/effect/mob_overlay_effect/proc/set_up_icon(turf/open/input_openturf, mob/living/carbon/human/input_human, mask_pixel_y_offset = 0)
	if(input_human.lying)
		var/matrix/matrix = matrix() //all this to make their face actually face the floor... sigh... I hate resting code
		switch(input_human.transform.b)
			if(1)
				matrix.Turn(315)
			if(-1)
				matrix.Turn(45)
		mask_pixel_y_offset = -12
		apply_transform(matrix)
	else
		apply_transform()

	overlays.Cut()
/*
	var/icon/output_texture = icon(input_openturf.icon, input_openturf.icon_state)
	output_texture.Shift(SOUTH, mask_pixel_y_offset, TRUE) //south since we want it opposite the + - of the value
	var/icon/subtraction_texture = icon(owner.icon_path, "culling_mask")
	subtraction_texture.Shift(SOUTH, (32 - abs(mask_pixel_y_offset)-3), FALSE)
	output_texture.AddAlphaMask(subtraction_texture)
	var/mutable_appearance/final_texture = mutable_appearance(output_texture)
	final_texture.layer = input_human.layer + 0.02
	final_texture.plane = input_human.plane
	var/icon/subtraction_texture = icon('icons/effects/mob_icon_cutter.dmi', "icon_cutter")
	subtraction_texture.Shift(SOUTH, (96 - abs(mask_pixel_y_offset)-3), FALSE)
	subtraction_texture.Shift(EAST, -32, FALSE)
	var/mutable_appearance/final_texture = mutable_appearance(subtraction_texture)
	final_texture.plane = MOB_REVERSE_OVERLAY_PLANE
	final_texture.invisibility = INVISIBILITY_LIGHTING
	final_texture.blend_mode = BLEND_OVERLAY
	overlays += final_texture
*/
