SUBSYSTEM_DEF(fail_to_topic)
	name = "Fail to Topic"
	init_order = SS_INIT_FAIL_TO_TOPIC
	flags = SS_BACKGROUND|SS_NO_FIRE
	runlevels = ALL

	var/list/rate_limiting = list()
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

	if(isnull(rate_limiting[ip]) || world.realtime - rate_limiting[ip] > rate_limit)
		rate_limiting[ip] = world.realtime
		return 2
	else
		active_bans[ip] = TRUE
		rate_limiting -= ip
		return 1
