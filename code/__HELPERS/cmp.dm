/proc/cmp_numeric_dsc(a, b)
	return b - a

/proc/cmp_numeric_asc(a, b)
	return a - b

/proc/cmp_text_asc(a, b)
	return sorttext(b, a)

/proc/cmp_text_dsc(a, b)
	return sorttext(a, b)

/proc/cmp_typepaths_asc(a, b)
	return sorttext("[b]","[a]")

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

var/cmp_field = "name"
/proc/cmp_records_asc(datum/data/record/a, datum/data/record/b)
	return sorttext((b ? b.fields[cmp_field] : ""), (a ? a.fields[cmp_field] : a))

/proc/cmp_records_dsc(datum/data/record/a, datum/data/record/b)
	return sorttext(a.fields[cmp_field], b.fields[cmp_field])

/proc/cmp_ckey_asc(client/a, client/b)
	return sorttext(b.ckey, a.ckey)

/proc/cmp_ckey_dsc(client/a, client/b)
	return sorttext(a.ckey, b.ckey)

/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return initial(b.init_order) - initial(a.init_order) //uses initial() so it can be used on types

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

/proc/cmp_filter_data_priority(list/a, list/b)
	return a["priority"] - b["priority"]

/proc/cmp_timer(datum/timedevent/a, datum/timedevent/b)
	return a.timeToRun - b.timeToRun

/proc/cmp_qdel_item_time(datum/qdel_item/a, datum/qdel_item/b)
	. = b.hard_delete_time - a.hard_delete_time
	if(!.)
		. = b.destroy_time - a.destroy_time
	if(!.)
		. = b.failures - a.failures
	if(!.)
		. = b.qdels - a.qdels

var/atom/cmp_dist_origin = null

/// Compares mobs based on their timeofdeath value in ascending order
/proc/cmp_mob_deathtime_asc(mob/a, mob/b)
	return a.timeofdeath - b.timeofdeath

/// Compares observers based on their larva_queue_time value in ascending order
/// Assumes the client on the observer is not null
/proc/cmp_obs_larvaqueuetime_asc(mob/dead/observer/a, mob/dead/observer/b)
	return a.client.player_details.larva_queue_time - b.client.player_details.larva_queue_time
