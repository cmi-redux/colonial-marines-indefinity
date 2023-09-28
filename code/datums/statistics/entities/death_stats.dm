/datum/entity/statistic_death
	var/player_id
	var/round_id

	var/role_name
	var/faction_name
	var/mob_name
	var/area_name

	var/cause_name
	var/cause_player_id
	var/cause_role_name
	var/cause_faction_name

	var/total_steps = 0
	var/total_kills = 0
	var/time_of_death
	var/total_time_alive
	var/total_damage_taken
	var/total_revives_done = 0

	var/total_brute = 0
	var/total_burn = 0
	var/total_oxy = 0
	var/total_tox = 0

	var/x
	var/y
	var/z

BSQL_PROTECT_DATUM(/datum/entity/statistic_death)

/datum/entity_meta/statistic_death
	entity_type = /datum/entity/statistic_death
	table_name = "log_player_statistic_death"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"round_id" = DB_FIELDTYPE_BIGINT,

		"role_name" = DB_FIELDTYPE_STRING_LARGE,
		"faction_name" = DB_FIELDTYPE_STRING_LARGE,
		"mob_name" = DB_FIELDTYPE_STRING_LARGE,
		"area_name" = DB_FIELDTYPE_STRING_LARGE,

		"cause_name" = DB_FIELDTYPE_STRING_LARGE,
		"cause_player_id" = DB_FIELDTYPE_BIGINT,
		"cause_role_name" = DB_FIELDTYPE_STRING_LARGE,
		"cause_faction_name" = DB_FIELDTYPE_STRING_LARGE,

		"total_steps" = DB_FIELDTYPE_INT,
		"total_kills" = DB_FIELDTYPE_INT,
		"time_of_death" = DB_FIELDTYPE_BIGINT,
		"total_time_alive" = DB_FIELDTYPE_BIGINT,
		"total_damage_taken" = DB_FIELDTYPE_INT,
		"total_revives_done" = DB_FIELDTYPE_INT,

		"total_brute" = DB_FIELDTYPE_INT,
		"total_burn" = DB_FIELDTYPE_INT,
		"total_oxy" = DB_FIELDTYPE_INT,
		"total_tox" = DB_FIELDTYPE_INT,

		"x" = DB_FIELDTYPE_INT,
		"y" = DB_FIELDTYPE_INT,
		"z" = DB_FIELDTYPE_INT,
	)

/datum/view_record/statistic_death
	var/player_id
	var/round_id

	var/role_name
	var/faction_name
	var/mob_name
	var/area_name

	var/cause_name
	var/cause_player_id
	var/cause_role_name
	var/cause_faction_name

	var/total_steps = 0
	var/total_kills = 0
	var/time_of_death
	var/total_time_alive

	var/total_brute = 0
	var/total_burn = 0
	var/total_oxy = 0
	var/total_tox = 0

	var/x
	var/y
	var/z

/datum/entity_view_meta/statistic_death_ordered
	root_record_type = /datum/entity/statistic_death
	destination_entity = /datum/view_record/statistic_death
	fields = list(
		"player_id",
		"round_id",

		"role_name",
		"faction_name",
		"mob_name",
		"area_name",

		"cause_name",
		"cause_player_id",
		"cause_role_name",
		"cause_faction_name",

		"total_steps",
		"total_kills",
		"time_of_death",
		"total_time_alive",

		"total_brute",
		"total_burn",
		"total_oxy",
		"total_tox",

		"x",
		"y",
		"z",
	)
	order_by = list("round_id" = DB_ORDER_BY_DESC)

/mob/proc/track_mob_death(datum/cause_data/cause_data, turf/death_loc)
	if(cause_data && !istype(cause_data))
		stack_trace("track_mob_death called with string cause ([cause_data]) instead of datum")
		cause_data = create_cause_data(cause_data)

	var/log_message = "\[[time_stamp()]\] [key_name(src)] died to "
	if(cause_data)
		log_message += "[cause_data.cause_name]"
	else
		log_message += "unknown causes"

	var/mob/cause_mob = cause_data?.resolve_mob()
	if(cause_mob)
		log_message += " from [key_name(cause_data.resolve_mob())]"
		cause_mob.attack_log += "\[[time_stamp()]\] [key_name(cause_mob)] killed [key_name(src)] with [cause_data.cause_name]."

	attack_log += "[log_message]."

	if(!mind || statistic_exempt)
		return

	var/datum/entity/statistic_death/Dlog = DB_ENTITY(/datum/entity/statistic_death)
	var/datum/entity/player/player_entity = get_player_from_key(mind.ckey)
	if(player_entity)
		Dlog.player_id = player_entity.id

	Dlog.round_id = SSperf_logging.round?.id

	Dlog.role_name = get_role_name()
	Dlog.mob_name = real_name
	Dlog.faction_name = faction?.name

	var/area/A = get_area(death_loc)
	Dlog.area_name = A.name

	Dlog.cause_name = cause_data?.cause_name
	var/datum/entity/player/cause_player = get_player_from_key(cause_data?.ckey)
	if(cause_player)
		Dlog.cause_player_id = cause_player.id
	Dlog.cause_role_name = cause_data?.role
	Dlog.cause_faction_name = cause_data?.faction

	if(cause_mob)
		cause_mob.life_kills_total += life_value

	if(getBruteLoss())
		Dlog.total_brute = round(getBruteLoss())
	if(getFireLoss())
		Dlog.total_burn = round(getFireLoss())
	if(getOxyLoss())
		Dlog.total_oxy = round(getOxyLoss())
	if(getToxLoss())
		Dlog.total_tox = round(getToxLoss())

	Dlog.time_of_death = duration2text(world.time)

	Dlog.x = death_loc.x
	Dlog.y = death_loc.y
	Dlog.z = death_loc.z

	Dlog.total_steps = life_steps_total
	Dlog.total_kills = life_kills_total
	Dlog.total_time_alive = life_time_total
	Dlog.total_damage_taken = life_damage_taken_total
	Dlog.total_revives_done = life_revives_total

	var/observer_message = "<b>[real_name]</b> умер"
	if(Dlog.cause_name)
		observer_message += " от <b>[Dlog.cause_name]</b>"
	if(A.name)
		observer_message += " в <b>[A.name]</b>"

	msg_admin_attack(observer_message, death_loc.x, death_loc.y, death_loc.z)

	if(src)
		to_chat(src, SPAN_DEADSAY(observer_message))
	for(var/mob/dead/observer/g in GLOB.observer_list)
		to_chat(g, SPAN_DEADSAY("[observer_message] [OBSERVER_JMP(g, death_loc)]"))

	var/ff_type = Dlog.cause_faction_name == Dlog.faction_name ? 1 : 0
	if(SSticker.mode.round_statistics)
		SSticker.mode.round_statistics.track_dead_participant(Dlog.faction_name)
		if(ff_type)
			SSticker.mode.round_statistics.total_friendly_kills++

	if(isxeno(cause_mob))
		track_statistic_earned(Dlog.cause_faction_name, STATISTIC_TYPE_CASTE, Dlog.cause_role_name, ff_type ? STATISTICS_KILL_FF : STATISTICS_KILL, 1, Dlog.cause_player_id)
	else if(ishuman(cause_mob))
		track_statistic_earned(Dlog.cause_faction_name, STATISTIC_TYPE_JOB, Dlog.cause_role_name, ff_type ? STATISTICS_KILL_FF : STATISTICS_KILL, 1, Dlog.cause_player_id)
		if(Dlog.cause_role_name)
			track_statistic_earned(Dlog.cause_faction_name, STATISTIC_TYPE_WEAPON, Dlog.cause_role_name, ff_type ? STATISTICS_KILL_FF : STATISTICS_KILL, 1, Dlog.cause_player_id)

	if(isxeno(src))
		track_statistic_earned(Dlog.faction_name, STATISTIC_TYPE_JOB, Dlog.role_name, ff_type ? STATISTICS_DEATH_FF : STATISTICS_DEATH, 1, Dlog.player_id)
	else if(ishuman(src))
		track_statistic_earned(Dlog.faction_name, STATISTIC_TYPE_JOB, Dlog.cause_name, ff_type ? STATISTICS_DEATH_FF : STATISTICS_DEATH, 1, Dlog.player_id)
		if(Dlog.cause_name)
			track_statistic_earned(Dlog.faction_name, STATISTIC_TYPE_WEAPON, Dlog.cause_name, ff_type ? STATISTICS_DEATH_FF : STATISTICS_DEATH, 1, Dlog.player_id)

	if(SSticker.mode && SSticker.mode.round_statistics)
		SSticker.mode.round_statistics.death_stats_list += Dlog

	Dlog.save()
	Dlog.detach()
	return Dlog
