SUBSYSTEM_DEF(fail_to_topic)
	name = "Fail to Topic"
	init_order = SS_INIT_FAIL_TO_TOPIC
	flags = SS_BACKGROUND|SS_NO_FIRE
	runlevels = ALL

	var/list/rate_limiting = list()
	var/list/fail_counts = list()
	var/list/active_bans = list()

	var/rate_limit = 10

/datum/controller/subsystem/fail_to_topic/Initialize(timeofday)
	rate_limit = CONFIG_GET(number/topic_rate_limit)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/fail_to_topic/proc/IsRateLimited(ip)
	if(config.fail_to_topic_whitelisted_ips[ip])
		return 2

	if(active_bans[ip])
		return 0

	if(isnull(rate_limiting[ip]) || world.timeofday - rate_limiting[ip] > rate_limit)
		rate_limiting[ip] = world.timeofday
	else
		if(isnull(active_bans[ip]))
			rate_limiting[ip] = world.timeofday
			active_bans[ip] = 0
			spawn(rate_limit)
				if(!active_bans[ip])
					active_bans -= ip
		else
			active_bans[ip] = 1
			rate_limiting -= ip
			return 1
	return 2
