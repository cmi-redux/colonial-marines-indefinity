SUBSYSTEM_DEF(playtime)
	name = "Playtime"
	wait = 1 MINUTES
	init_order	= SS_INIT_PLAYTIME
	priority = SS_PRIORITY_PLAYTIME
	flags = SS_KEEP_TIMING

	var/list/best_playtimes = list()
	var/list/currentrun = list()

/datum/controller/subsystem/playtime/Initialize()
	get_best_playtimes()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/playtime/proc/get_best_playtimes()
	set waitfor = FALSE

	WAIT_DB_READY

	var/list/datum/view_record/playtime/PTs = DB_VIEW(/datum/view_record/playtime/)
	var/list/real_best_playtimes = list()
	for(var/datum/view_record/playtime/PT as anything in PTs)
		var/role_id = PT.role_id
		var/role_time = round(PT.total_minutes / 60, 0.1)
		if(!(role_id in real_best_playtimes))
			real_best_playtimes[role_id] = list(role_time, PT)
			continue
		if(real_best_playtimes[role_id][1] > role_time)
			continue
		real_best_playtimes[role_id] = list(role_time, PT)

	for(var/role_name in real_best_playtimes)
		var/list/info_list = real_best_playtimes[role_name]
		var/datum/view_record/playtime/PT = info_list[2]
		if(!PT)
			continue
		var/datum/view_record/players/player = SAFEPICK(DB_VIEW(/datum/view_record/players, DB_COMP("id", DB_EQUALS, PT.player_id)))
		if(!player)
			continue
		best_playtimes += list(list("ckey" = player.ckey) + PT.get_nanoui_data())

/datum/controller/subsystem/playtime/fire(resumed = FALSE)
	if(!resumed)
		src.currentrun = GLOB.clients.Copy()

	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/client/C = currentrun[currentrun.len]
		currentrun.len--

		var/mob/M = C.mob
		var/datum/entity/player/P = C.player_data

		var/effective_job

		// skip if player invalid
		if(!M || !P || !P.playtime_loaded)
			effective_job = null
		// assign as observer if ghost or dead
		else if(isobserver(M) || ((M.stat == DEAD) && isliving(M)))
			effective_job = JOB_OBSERVER
		// assign the mob job if it's applicable
		else if(M.job && M.stat != DEAD && !M.statistic_exempt)
			effective_job = M.job
		// else, invalid job or statistic exempt

		if(!effective_job)
			if(MC_TICK_CHECK)
				return
			continue

		var/datum/entity/player_time/PTime = LAZYACCESS(P.playtimes, effective_job)

		if(!PTime)
			PTime = DB_ENTITY(/datum/entity/player_time)
			PTime.player_id = P.id
			PTime.role_id = effective_job
			LAZYSET(P.playtimes, effective_job, PTime)

		PTime.total_minutes++
		PTime.save()

		if(MC_TICK_CHECK)
			return
