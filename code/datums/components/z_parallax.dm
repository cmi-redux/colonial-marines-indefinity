/**
 * Component that hooks into the client, listens for COMSIG_MOVABLE_Z_CHANGED, and depending on whether or not the
 * Z-level has ZTRAIT_NOPARALLAX enabled, disable or reenable parallax.
 */

/datum/component/zparallax
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/client/tracked
	var/mob/tracked_mob

/datum/component/zparallax/Initialize(client/tracked)
	. = ..()
	if(!istype(tracked))
		stack_trace("Component zparallax has been initialized outside of a client. Deleting.")
		return COMPONENT_INCOMPATIBLE

	src.tracked = tracked
	tracked_mob = tracked.mob

	var/static/list/connections = list(
		COMSIG_MOB_LOGOUT = PROC_REF(mob_change),
	)
	AddComponent(/datum/component/connect_mob_behalf, tracked, connections)
	RegisterSignal(tracked_mob, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(ztrait_checks))

/datum/component/zparallax/Destroy()
	. = ..()
	unregister_signals()

	tracked_mob = null

/datum/component/zparallax/proc/unregister_signals()
	if(!tracked_mob)
		return

	UnregisterSignal(tracked_mob, list(COMSIG_MOB_LOGIN, COMSIG_MOB_LOGOUT, COMSIG_MOVABLE_Z_CHANGED))

/datum/component/zparallax/proc/mob_change(mob/user)
	SIGNAL_HANDLER
	if(!tracked)
		qdel(src)
		return

	unregister_signals()

	tracked_mob = tracked.mob

	var/static/list/connections = list(
		COMSIG_MOB_LOGOUT = PROC_REF(mob_change),
	)
	AddComponent(/datum/component/connect_mob_behalf, tracked, connections)
	RegisterSignal(tracked_mob, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(ztrait_checks))

/datum/component/zparallax/proc/ztrait_checks()
	SIGNAL_HANDLER

	var/datum/hud/hud = tracked_mob.hud_used

	hud.update_parallax_pref(tracked_mob)
