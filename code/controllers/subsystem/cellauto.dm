var/list/cellauto_cells = list()

SUBSYSTEM_DEF(cellauto)
	name  = "Cellular Automata"
	wait  = 0.05 SECONDS
	priority = SS_PRIORITY_CELLAUTO
	flags = SS_NO_INIT|SS_POST_FIRE_TIMING
	runlevels = RUNLEVEL_LOBBY|RUNLEVEL_SETUP|RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	var/list/currentrun = list()

/datum/controller/subsystem/cellauto/stat_entry(msg)
	msg = "C: [cellauto_cells.len]"
	return ..()

/datum/controller/subsystem/cellauto/fire(resumed = FALSE)
	if(!resumed)
		currentrun = cellauto_cells.Copy()

	while(currentrun.len)
		var/datum/automata_cell/C = currentrun[currentrun.len]
		currentrun.len--

		if(!C || QDELETED(C))
			continue

		C.update_state()

		if(MC_TICK_CHECK)
			return
