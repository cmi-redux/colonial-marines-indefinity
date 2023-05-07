///mob_overlay_effect component. adds and removes
/datum/component/mob_overlay_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/effects/mob_overlay_effect/mob_overlay_effect
	var/target_type //! Turf type the effect applies to
	var/ttl = 1

/datum/component/mob_overlay_effect/Initialize(type_to_set, y_offset, will_alter_layerings = TRUE)
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	target_type = type_to_set
	mob_overlay_effect = new(parent)
	mob_overlay_effect.pixel_y_offset = y_offset
	mob_overlay_effect.will_alter_layerings = will_alter_layerings

/datum/component/mob_overlay_effect/Destroy()
	. = ..()
	QDEL_NULL(mob_overlay_effect)

/datum/component/mob_overlay_effect/proc/update_turf_overlays_effects(parent_source, oldloc, direction, forced)
	SIGNAL_HANDLER

	if(!ttl || forced)
		qdel(src)
		return
	ttl = 0
	mob_overlay_effect.update_icons(get_turf(parent))

/datum/component/mob_overlay_effect/RegisterWithParent(datum/target)
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(update_turf_overlays_effects))

/datum/component/mob_overlay_effect/UnregisterFromParent(datum/source, force)
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/mob_overlay_effect/InheritComponent(datum/component/C, i_am_original, type_to_set, y_offset)
	. = ..()

	ttl = 1
	target_type = type_to_set
	mob_overlay_effect.pixel_y_offset = y_offset
	mob_overlay_effect.update_icons(get_turf(parent))
