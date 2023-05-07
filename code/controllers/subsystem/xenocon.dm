SUBSYSTEM_DEF(xenocon)
	name = "XENOCON"
	wait = 5 SECONDS
	priority = SS_PRIORITY_INACTIVITY
	flags = SS_NO_INIT
	var/rewarded = FALSE

/datum/controller/subsystem/xenocon/fire(resumed = FALSE)
	if(rewarded)
		return

	for(var/faction_to_get in FACTION_LIST_XENOMORPH)
		var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
		if(faction.xenocon_points >= XENOCON_THRESHOLD)
			var/datum/emergency_call/em_call = new /datum/emergency_call/xenos/platoon()
			em_call.activate()
			rewarded = TRUE
