/datum/cause_data
	var/datum/weakref/weak_mob
	var/ckey
	var/role
	var/faction
	var/cause_name
	var/datum/weakref/weak_cause

/datum/cause_data/proc/resolve_mob()
	if(!weak_mob)
		return null
	return weak_mob.resolve()

/datum/cause_data/proc/resolve_cause()
	if(!weak_cause)
		return null
	return weak_cause.resolve()

/proc/create_cause_data(new_cause, mob/cause_mob = null, obj/cause_weapon = null)
	if(!new_cause)
		return null
	var/datum/cause_data/new_data = new()
	new_data.cause_name = new_cause
	if(cause_weapon)
		new_data.weak_cause = WEAKREF(cause_weapon)
	if(istype(cause_mob))
		new_data.weak_mob = WEAKREF(cause_mob)
		if(cause_mob.mind)
			new_data.ckey = cause_mob.mind.ckey
		new_data.role = cause_mob.get_role_name()
		new_data.faction = cause_mob.faction.name
	return new_data
