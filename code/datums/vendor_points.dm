/datum/vendor_points
	var/mob/living/carbon/human/owner
	var/base_vendor_points = VENDOR_TOTAL_BUY_POINTS
	var/snowflake_vendor_points = VENDOR_TOTAL_SNOWFLAKE_POINTS
	var/ammunition_vendor_points = VENDOR_TOTAL_AMMUNITION_POINTS
	var/buy_flags = VENDOR_CAN_BUY_ALL

/datum/vendor_points/New(mob/living/carbon/human/owner_ref)
	owner = owner_ref
	point_calculation()

/datum/vendor_points/proc/point_calculation()
	set waitfor = FALSE
	WAIT_DB_READY
	if(owner.client)
		var/time_played = get_job_playtime(owner.client, owner.job)
		var/modificator = 0
		switch(time_played)
			if(JOB_PLAYTIME_TIER_1 to JOB_PLAYTIME_TIER_2)
				modificator = 0.25
			if(JOB_PLAYTIME_TIER_2 to JOB_PLAYTIME_TIER_3)
				modificator = 0.5
			if(JOB_PLAYTIME_TIER_3 to JOB_PLAYTIME_TIER_4)
				modificator = 1
			if(JOB_PLAYTIME_TIER_4 to INFINITY)
				modificator = 1.5
		base_vendor_points += VENDOR_TOTAL_BUY_POINTS * modificator
		snowflake_vendor_points += VENDOR_TOTAL_SNOWFLAKE_POINTS * modificator
		ammunition_vendor_points += VENDOR_TOTAL_AMMUNITION_POINTS * modificator
