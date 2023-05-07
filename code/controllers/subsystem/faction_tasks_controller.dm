SUBSYSTEM_DEF(tasks)
	name = "Tasks"
	init_order = SS_INIT_TASKS
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME
	wait = 1 MINUTES

	var/list/task_gen_list = list("sector_control" = list(/datum/faction_task/sector_control/occupy, /datum/faction_task/sector_control/occupy/hold))
	var/list/task_gen_list_game_enders = list("game_enders" = list(/datum/faction_task/dominate, /datum/faction_task/hold))
	var/list/sectors = list()

	var/list/tasks = list()
	var/list/processing_tasks = list()

	var/list/datum/cm_objective/current_active_run = list()

/datum/controller/subsystem/tasks/stat_entry(msg)
	msg = "T:[length(tasks)]|P:[length(processing_tasks)]"
	return ..()

/datum/controller/subsystem/tasks/fire()
	if(!current_active_run)
		current_active_run = processing_tasks.Copy()

	while(length(current_active_run))
		var/datum/faction_task/T = current_active_run[length(current_active_run)]

		current_active_run.len--
		T.process()
		T.check_completion()
		if(T.state & OBJECTIVE_COMPLETE|OBJECTIVE_FAILED)
			stop_processing_task(T)

		if(MC_TICK_CHECK)
			return

	try_to_set_task()

/datum/controller/subsystem/tasks/proc/try_to_set_task()
	set waitfor = FALSE

	if(length(processing_tasks) < length(SSticker.mode.factions_pool) || prob(1))
		for(var/faction_name in SSticker.mode.factions_pool)
			var/datum/faction/faction = GLOB.faction_datum[SSticker.mode.factions_pool[faction_name]]
			if(make_potential_tasks(faction))
				break

/datum/controller/subsystem/tasks/proc/make_potential_tasks(datum/faction/faction, use_game_enders = FALSE)
	var/datum/faction_task/faction_task
	var/list/list_to_pick = task_gen_list
	if(use_game_enders)
		list_to_pick = task_gen_list_game_enders
	var/picked_gen = pick(list_to_pick)
	switch(picked_gen)
		if("sector_control")
			for(var/obj/structure/prop/sector_center/sector in sectors)
				if(sector.faction != faction)
					continue

				for(var/obj/structure/prop/sector_center/border_sector in sector.bordered_sectors)
					if(border_sector.faction == faction || (border_sector.home_sector && faction.homes_sector_occupation))
						continue
					var/list/potential_task_list = task_gen_list[picked_gen]
					var/list/datum/faction_task/tasks_list = border_sector.get_faction_tasks(faction)
					for(var/datum/faction_task/task in tasks_list)
						potential_task_list -= task.type
					if(length(potential_task_list))
						var/type_to_gen = pick(potential_task_list)
						faction_task = new type_to_gen(faction, border_sector)
						break

				if(faction_task)
					break

		if("game_enders")
			var/list/potential_task_list = task_gen_list_game_enders[picked_gen]
			var/game_ender_type_to_gen = pick(potential_task_list)
			faction_task = new game_ender_type_to_gen(faction)

	if(faction_task)
		faction.active_tasks += faction_task
		return TRUE
	return FALSE

/datum/controller/subsystem/tasks/proc/build_sectors()
	var/list/sectors_by_id = list()
	for(var/obj/structure/prop/sector_center/sector in sectors)
		sectors_by_id[sector.sector_id] = sector

	for(var/obj/structure/prop/sector_center/sector in sectors)
		for(var/bordered_sector_id in sector.sector_connections)
			sector.bordered_sectors += sectors_by_id[bordered_sector_id]

/datum/controller/subsystem/tasks/proc/add_task(datum/faction_task/task)
	LAZYADD(tasks, task)

/datum/controller/subsystem/tasks/proc/remove_task(datum/faction_task/task)
	LAZYREMOVE(tasks, task)

/datum/controller/subsystem/tasks/proc/start_processing_task(datum/faction_task/task)
	processing_tasks += task

/datum/controller/subsystem/tasks/proc/stop_processing_task(datum/faction_task/task)
	processing_tasks -= task
	if(task.faction_owner)
		task.faction_owner.active_tasks -= task
