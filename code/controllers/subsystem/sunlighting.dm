#define WAIT_SUNLIGHT_READY while(!SSsunlighting.initialized) {stoplag();}

//TODO: Change verbiage to outdoor_effects rather than sunlight
/datum/time_of_day
	var/name = ""
	var/color = ""
	var/start_at = 0.25	// 06:00:00
	var/position_number = FALSE

/datum/time_of_day/New()
	..()
	if(SSmapping.configs[GROUND_MAP].map_day_night_modificator[name])
		start_at = SSmapping.configs[GROUND_MAP].map_day_night_modificator[name]
	if(SSmapping.configs[GROUND_MAP].custom_day_night_colors[name])
		color = SSmapping.configs[GROUND_MAP].custom_day_night_colors[name]

/datum/time_of_day/midnight
	name = "Midnight"
	color = "#000000"
	start_at = 1		//12:00:00
	position_number = 1

/datum/time_of_day/night
	name = "Night"
	color = "#050D29"
	start_at = 0.083	//02:00:00
	position_number = 2

/datum/time_of_day/dawn
	name = "Dawn"
	color = "#31211b"
	start_at = 0.16		//04:00:00
	position_number = 3

/datum/time_of_day/sunrise
	name = "Sunrise"
	color = "#F598AB"
	start_at = 0.25		//06:00:00
	position_number = 4

/datum/time_of_day/sunrise_morning
	name = "Sunrise-Morning"
	color = "#7e874a"
	start_at = 0.29		//07:00:00
	position_number = 5

/datum/time_of_day/morning
	name = "Morning"
	color = "#808599"
	start_at = 0.33		//08:00:00
	position_number = 6

/datum/time_of_day/daytime
	name = "Daytime"
	color = "#FFFFFF"
	start_at = 0.416	//10:00:00
	position_number = 7

/datum/time_of_day/evening
	name = "Evening"
	color = "#AFAFAF"
	start_at = 0.66		//14:00:00
	position_number = 8

/datum/time_of_day/sunset
	name = "Sunset"
	color = "#ff8a63"
	start_at = 0.7916	//17:00:00
	position_number = 9

/datum/time_of_day/dusk
	name = "Dusk"
	color = "#221f33"
	start_at = 0.916	//22:00:00
	position_number = 10

GLOBAL_VAR_INIT(GLOBAL_LIGHT_RANGE, 5)
GLOBAL_LIST_EMPTY(SUNLIGHT_QUEUE_WORK)
GLOBAL_LIST_EMPTY(SUNLIGHT_QUEUE_UPDATE)
GLOBAL_LIST_EMPTY(SUNLIGHT_QUEUE_CORNER)

SUBSYSTEM_DEF(sunlighting)
	name = "Sun Lighting"
	wait = 2 SECONDS
	priority = SS_PRIORITY_SUNLIGHTING
	flags = SS_TICKER

	var/atom/movable/sun_color

	var/datum/time_of_day/current_step_datum
	var/datum/time_of_day/next_step_datum
	var/datum/particle_weather/weather_datum
	var/datum/weather_event/weather_light_affecting_event
	var/list/mutable_appearance/sunlight_overlays
	var/list/atom/movable/screen/plane_master/weather_effect/weather_planes_need_vis = list()

	var/list/datum/time_of_day/steps = list()

	var/allow_updates = TRUE
	var/next_day = FALSE
	var/current_color = ""
	var/weather_blend_ammount = 0.3

	var/game_time_length = 24 HOURS
	var/custom_time_offset = 0

/datum/controller/subsystem/sunlighting/stat_entry(msg)
	msg = "W:[GLOB.SUNLIGHT_QUEUE_WORK.len]|U:[GLOB.SUNLIGHT_QUEUE_UPDATE.len]|C:[GLOB.SUNLIGHT_QUEUE_CORNER.len]"
	return ..()

/datum/controller/subsystem/sunlighting/proc/Initialize_Turfs()
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_GROUND))
		for(var/turf/T in block(locate(1,1,z), locate(world.maxx,world.maxy,z)))
			var/area/TArea = T.loc
			if(TArea.static_lighting)
				GLOB.SUNLIGHT_QUEUE_WORK += T

/datum/controller/subsystem/sunlighting/Initialize(timeofday)
	Initialize_Turfs()
	game_time_length = SSmapping.configs[GROUND_MAP].custom_time_length
	custom_time_offset = rand(0, game_time_length)
	create_steps()
	set_time_of_day()
	sun_color = new /atom/movable()
	sun_color.color = current_step_datum.color
	sun_color.appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM
	sun_color.vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_LAYER
	sun_color.blend_mode = BLEND_ADD
	sun_color.filters += filter(type = "layer", render_source = S_LIGHTING_VISUAL_RENDER_TARGET)
	initialized = TRUE
	fire(FALSE, TRUE)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/sunlighting/proc/set_game_time_length(new_value)
	game_time_length = new_value

/datum/controller/subsystem/sunlighting/proc/set_game_time_offset(new_value)
	custom_time_offset = new_value

/datum/controller/subsystem/sunlighting/proc/game_time_offseted()
	return (game_time() + custom_time_offset) % SSsunlighting.game_time_length

/datum/controller/subsystem/sunlighting/proc/create_steps()
	for(var/path in typesof(/datum/time_of_day))
		var/datum/time_of_day/time_of_day = new path()
		if(time_of_day.position_number)
			steps["[time_of_day.position_number]"] = time_of_day

/datum/controller/subsystem/sunlighting/proc/check_cycle()
	if(!next_step_datum)
		set_time_of_day()
		return TRUE

	if(game_time_length * game_time_offseted() > next_step_datum.start_at )
		if(next_day)
			return FALSE
		set_time_of_day()
		return TRUE
	else if(next_day) // It is now the next morning, reset our next day
		next_day = FALSE
	return FALSE

/datum/controller/subsystem/sunlighting/proc/set_time_of_day()
	var/time = game_time_length * game_time_offseted()
	var/datum/time_of_day/new_step = null

	for(var/i = 1 to length(steps))
		if(time >= steps["[i]"].start_at)
			new_step = steps["[i]"]
			next_step_datum = i == length(steps) ? steps["1"] : steps["[i + 1]"]

	if(!new_step)
		new_step = steps["[length(steps)]"]
		next_step_datum = steps["1"]

	current_step_datum = new_step

	if(next_step_datum.start_at <= current_step_datum.start_at)
		next_day = TRUE

/datum/controller/subsystem/sunlighting/proc/update_color()
	if(!weather_light_affecting_event)
		var/time = game_time_length * game_time_offseted()
		var/time_to_animate = daytimeDiff(time, next_step_datum.start_at)
		var/blend_amount = (time - current_step_datum.start_at) / (next_step_datum.start_at - current_step_datum.start_at)
		current_color = BlendRGB(current_step_datum.color, next_step_datum.color, blend_amount)
		if(weather_datum && weather_datum.weather_color_offset)
			var/weather_blend_amount = time - weather_datum.weather_start_time / weather_datum.weather_start_time + (weather_datum.weather_duration / 12) - weather_datum.weather_start_time
			current_color = BlendRGB(current_color, weather_datum.weather_color_offset, min(weather_blend_amount, weather_blend_ammount))
		animate(sun_color, color = current_color, time = time_to_animate)

/datum/controller/subsystem/sunlighting/fire(resumed, init_tick_checks)
	if(sun_color)
		sun_color.name = "SUN_COLOR_[rand()*rand(1,9999999)]" // force rendering refresh because byond is a bitch

	update_color()

	MC_SPLIT_TICK_INIT(3)
	if(!init_tick_checks)
		MC_SPLIT_TICK
	var/i = 0

	//Add our weather particle obj to any new weather screens
	if(SSparticle_weather.initialized)
		for(i in 1 to weather_planes_need_vis.len)
			var/atom/movable/screen/plane_master/weather_effect/W = weather_planes_need_vis[i]
			if(W)
				W.vis_contents = list(SSparticle_weather.get_weather_effect())
			if(init_tick_checks)
				CHECK_TICK
			else if(MC_TICK_CHECK)
				break
		if(i)
			weather_planes_need_vis.Cut(1, i+1)
			i = 0

	for(i in 1 to GLOB.SUNLIGHT_QUEUE_WORK.len)
		var/turf/T = GLOB.SUNLIGHT_QUEUE_WORK[i]
		if(T)
			T.get_sky_and_weather_states()
			if(T.outdoor_effect)
				GLOB.SUNLIGHT_QUEUE_UPDATE += T.outdoor_effect

		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			break
	if(i)
		GLOB.SUNLIGHT_QUEUE_WORK.Cut(1, i+1)
		i = 0


	if(!init_tick_checks)
		MC_SPLIT_TICK

	for(i in 1 to GLOB.SUNLIGHT_QUEUE_UPDATE.len)
		var/atom/movable/outdoor_effect/U = GLOB.SUNLIGHT_QUEUE_UPDATE[i]
		if(U)
			U.process_state()
			update_outdoor_effect_overlays(U)

		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			break
	if(i)
		GLOB.SUNLIGHT_QUEUE_UPDATE.Cut(1, i+1)
		i = 0


	if(!init_tick_checks)
		MC_SPLIT_TICK

	for(i in 1 to GLOB.SUNLIGHT_QUEUE_CORNER.len)
		var/turf/T = GLOB.SUNLIGHT_QUEUE_CORNER[i]
		var/atom/movable/outdoor_effect/U = T.outdoor_effect

		/* if we haven't initialized but we are affected, create new and check state */
		if(!U)
			T.outdoor_effect = new /atom/movable/outdoor_effect(T)
			T.get_sky_and_weather_states()
			U = T.outdoor_effect

			/* in case we aren't indoor somehow, wack us into the proc queue, we will be skipped on next indoor check */
			if(U.state != SKY_BLOCKED)
				GLOB.SUNLIGHT_QUEUE_UPDATE += T.outdoor_effect

		if(U.state != SKY_BLOCKED)
			continue

		//This might need to be run more liberally
		update_outdoor_effect_overlays(U)


		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			break

	if(i)
		GLOB.SUNLIGHT_QUEUE_CORNER.Cut(1, i+1)
		i = 0

	check_cycle()

//get our weather overlay
/datum/controller/subsystem/sunlighting/proc/get_weather_overlay()
	var/mutable_appearance/MA = new /mutable_appearance()

	MA.icon			= 'icons/effects/weather_overlay.dmi'
	MA.icon_state	= "weather_overlay"
	MA.plane		= WEATHER_OVERLAY_PLANE /* we put this on a lower level than lighting so we dont multiply anything */
	MA.invisibility	= INVISIBILITY_LIGHTING
	MA.blend_mode	= BLEND_OVERLAY
	return MA

// Updates overlays and vis_contents for outdoor effects
/datum/controller/subsystem/sunlighting/proc/update_outdoor_effect_overlays(atom/movable/outdoor_effect/OE)
	if(!is_ground_level(OE.z) && !is_mainship_level(OE.z))
		return

	var/mutable_appearance/MA
	if(OE.state != SKY_BLOCKED)
		MA = get_sunlight_overlay(1,1,1,1) /* fully lit */
	else //Indoor - do proper corner checks
		/* check if we are globally affected or not */
		var/static/datum/lighting_corner/dummy/dummy_lighting_corner = new

		var/datum/lighting_corner/cr = OE.source_turf.lighting_corner_SW || dummy_lighting_corner
		var/datum/lighting_corner/cg = OE.source_turf.lighting_corner_SE || dummy_lighting_corner
		var/datum/lighting_corner/cb = OE.source_turf.lighting_corner_NW || dummy_lighting_corner
		var/datum/lighting_corner/ca = OE.source_turf.lighting_corner_NE || dummy_lighting_corner

		var/fr = cr.sun_falloff
		var/fg = cg.sun_falloff
		var/fb = cb.sun_falloff
		var/fa = ca.sun_falloff

		MA = get_sunlight_overlay(fr, fg, fb, fa)

	OE.sunlight_overlay = MA
	if(is_ground_level(OE.z) && !OE.weatherproof)
		OE.overlays = list(OE.sunlight_overlay, get_weather_overlay())
	else
		OE.overlays = list(OE.sunlight_overlay)

	OE.luminosity = MA.luminosity

//Retrieve an overlay from the list - create if necessary
/datum/controller/subsystem/sunlighting/proc/get_sunlight_overlay(fr, fg, fb, fa)
	var/index = "[fr]|[fg]|[fb]|[fa]"
	LAZYINITLIST(sunlight_overlays)
	if(!sunlight_overlays[index])
		sunlight_overlays[index] = create_sunlight_overlay(fr, fg, fb, fa)
	return sunlight_overlays[index]

//Create an overlay appearance from corner values
/datum/controller/subsystem/sunlighting/proc/create_sunlight_overlay(fr, fg, fb, fa)
	var/mutable_appearance/MA = new /mutable_appearance()

	MA.blend_mode	= BLEND_OVERLAY
	MA.icon			= LIGHTING_ICON
	MA.icon_state	= null
	MA.plane		= S_LIGHTING_VISUAL_PLANE /* we put this on a lower level than lighting so we dont multiply anything */
	MA.invisibility	= INVISIBILITY_LIGHTING


	//MA gets applied as an overlay, but we pull luminosity out to set our outdoor_effect object's lum
	#if LIGHTING_SOFT_THRESHOLD != 0
	MA.luminosity = max(fr, fg, fb, fa) > LIGHTING_SOFT_THRESHOLD
	#else
	MA.luminosity = max(fr, fg, fb, fa) > 1e-6
	#endif

	if((fr & fg & fb & fa) && (fr + fg + fb + fa == 4)) /* this will likely never happen */
		MA.color = LIGHTING_BASE_MATRIX
	else if(!MA.luminosity)
		MA.color = LIGHTING_DARK_MATRIX
	else
		MA.color = list(
					fr, fr, fr,  00 ,
					fg, fg, fg,  00 ,
					fb, fb, fb,  00 ,
					fa, fa, fa,  00 ,
					00, 00, 00,  01 )
	return MA
