/obj/structure/machinery/power/rbmk
	name = "Advanced Nuclear Reactor"
	desc = "A tried and tested design which can output stable power at an acceptably low risk. The moderator can be changed to provide different effects."
	icon = 'icons/obj/structures/machinery/rbmk.dmi'
	icon_state = "reactor_off"
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	unacidable = TRUE
	health = 10000
	directwired = FALSE
	power_machine = TRUE
	indestructible = TRUE
	layer = ABOVE_TURF_LAYER

	pixel_x = -32
	pixel_y = -32
	bound_width = 96
	bound_height = 96
	bound_x = -32
	bound_y = -32

	light_system = STATIC_LIGHT
	light_range = 7
	light_power = 0.5
	light_color = LIGHT_COLOR_ELECTRIC_CYAN
	light_on = FALSE

	var/flags_reactor = REACTOR_FUEL_ACTIONS
	var/id = null
	var/datum/cause_data/cause_data

	var/temperature_operating = 800
	var/temperature_pre_critical = 1100
	var/temperature_critical = 1400
	var/temperature_meltdown = 1800

	//Variables essential to operation
	var/temperature = 0 //Lose control of this -> Meltdown
	var/K = 0 //Rate of reaction.
	var/desired_k = 0
	var/base_control_rod_effectiveness = 2
	var/control_rod_effectiveness = 0 //Starts off with a lot of control over K. If you flood this thing with plasma, you lose your ability to control K as easily.
	var/power = 0 //0-100%. A function of the maximum heat you can achieve within operating temperature
	var/power_modifier = 1 //Upgrade me with parts, science! Flat out increase to physical power output when loaded with plasma.
	var/max_fuel_rods = 10
	var/list/fuel_rods = list()
	//Secondary variables.
	var/next_slowprocess = 0
	var/absorption_effectiveness = 0.5
	var/absorption_constant = 0.5 //We refer to this one as it's set on init, randomized.
	var/warning = FALSE //Have we begun warning the crew of their impending death?
	var/next_warning = 0 //To avoid spam.
	var/last_power_produced = 0 //For logging purposes
	var/next_flicker = 0 //Light flicker timer
	var/base_power_modifier = 4000
	//Console statistics.
	var/last_temperature = 0
	var/last_heat_delta = 0 //For administrative cheating only. Knowing the delta lets you know EXACTLY what to set K at.

	var/max_criticality = 25

/obj/structure/machinery/power/rbmk/Initialize(mapload)
	. = ..()
	icon_state = "reactor_off"
	cause_data = create_cause_data("взрыв реактора", src)
	absorption_effectiveness = rand(40, 60)/100
	absorption_constant = absorption_effectiveness //And set this up for the rest of the round.
	if(!id)
		id = "[pick(alphabet_uppercase)][pick(alphabet_uppercase)]-[rand(0,9)][rand(0,9)][rand(0,9)]"
	GLOB.fusion_cores += src
	connect_to_network() //Should start with a cable piece underneath, if it doesn't, something's messed up in mapping
	lazy_startup()

/obj/structure/machinery/power/rbmk/power_change()
	return

/obj/structure/machinery/power/rbmk/update_icon(state)
	icon_state = state

/obj/structure/machinery/power/rbmk/ex_act(severity)
	health -= severity*0.01
//Admin procs to mess with the reaction environment.

/obj/structure/machinery/power/rbmk/proc/lazy_startup()
	flags_reactor &= ~REACTOR_SLAGGED
	for(var/I=0;I<max_fuel_rods;I++)
		fuel_rods += new /obj/item/fuel_rod(src)
	start_up()
	desired_k = 5

/obj/structure/machinery/power/rbmk/proc/deplete()
	for(var/obj/item/fuel_rod/FR in fuel_rods)
		FR.depletion = 100

/obj/structure/machinery/power/rbmk/process()
	if(next_slowprocess < world.time)
		slowprocess()
		next_slowprocess = world.time + 1 SECONDS //Set to wait for another second before processing again, we don't need to process more than once a second

/obj/structure/machinery/power/rbmk/proc/has_fuel()
	return length(fuel_rods)

/obj/structure/machinery/power/rbmk/proc/slowprocess()
	if(flags_reactor & REACTOR_SLAGGED)
		stop_processing()
		return

	control_rod_effectiveness = base_control_rod_effectiveness
	last_heat_delta = absorption_effectiveness
	temperature -= absorption_effectiveness

	power = (temperature / temperature_critical) * 100
	var/depletion_modifier = 0.035 //How rapidly do your rods decay
	absorption_effectiveness = absorption_constant

	last_power_produced = 375
	last_power_produced *= (max(0,power)/100) //Aaaand here comes the cap. Hotter reactor => more power.
	last_power_produced *= base_power_modifier //Finally, we turn it into actual usable numbers.
	add_avail(last_power_produced)

	K += rand(10, 100)/50
	var/fuel_power = 0 //So that you can't magically generate K with your control rods.
	if(!has_fuel())  //Reactor must be fuelled and ready to go before we can heat it up boys.
		K = 0
	else
		for(var/obj/item/fuel_rod/FR in fuel_rods)
			K += FR.fuel_power
			fuel_power += FR.fuel_power
			control_rod_effectiveness += FR.control_rod_effectiveness
			FR.deplete(depletion_modifier)
	//Firstly, find the difference between the two numbers.
	var/difference = abs(K - desired_k)
	//Then, hit as much of that goal with our cooling per tick as we possibly can.
	difference = Clamp(difference, 0, control_rod_effectiveness) //And we can't instantly zap the K to what we want, so let's zap as much of it as we can manage....
	if(difference > fuel_power && desired_k > K)
		difference = fuel_power //Again, to stop you being able to run off of 1 fuel rod.
	if(K != desired_k)
		if(desired_k > K)
			K += difference
		else if(desired_k < K)
			K -= difference

	K = Clamp(K, 0, max_criticality)
	if(has_fuel())
		temperature += K
	else
		temperature -= 10 //Nothing to heat us up, so.
	absorption_effectiveness += temperature/max(K, 1) * 0.1
	last_temperature = temperature
	handle_alerts() //Let's check if they're about to die, and let them know.
	update_icon()
	if(power >= 90 && world.time >= next_flicker) //You're overloading the reactor. Give a more subtle warning that power is getting out of control.
		next_flicker = world.time + 1.5 MINUTES
		for(var/obj/structure/machinery/light/L in GLOB.machines)
			L.flicker()

//Method to handle sound effects, reactor warnings, all that jazz.
/obj/structure/machinery/power/rbmk/proc/handle_alerts()
	var/alert = FALSE //If we have an alert condition, we'd best let people know.
	if(K <= 0 && temperature <= 0)
		shut_down()
	//First alert condition: Overheat
	if(temperature >= temperature_critical)
		alert = TRUE
		if(temperature >= temperature_meltdown)
			var/temp_damage = temperature/100	//40 seconds to meltdown from full integrity, worst-case. Bit less than blowout since it's harder to spike heat that much.
			health -= temp_damage
			if(health <= temp_damage) //It wouldn't be able to tank another hit.
				meltdown() //Oops! All meltdown
				return
	else
		alert = FALSE
	if(temperature < 0) //That's as cold as I'm letting you get it, engineering.
		color = COLOR_CYAN
		temperature = 0
	else
		color = null

	if(warning)
		if(!alert) //Congrats! You stopped the meltdown / blowout.
			warning = FALSE
			set_light_on(FALSE)
			light_color = LIGHT_COLOR_CYAN
			set_light_on(TRUE)
	else
		if(!alert)
			return
		if(world.time < next_warning)
			return
		shipwide_ai_announcement("Warning, reactor overheating, required actions", "[MAIN_AI_SYSTEM]", 'sound/effects/rbmk/alarm.ogg')
		next_warning = world.time + 30 SECONDS //To avoid engis pissing people off when reaaaally trying to stop the meltdown or whatever.
		warning = TRUE //Start warning the crew of the imminent danger.
		playsound(src, 'sound/effects/rbmk/alarm.ogg', 25, 1, 7)
		set_light_on(FALSE)
		light_color = LIGHT_COLOR_RED
		set_light_on(TRUE)

//Failure condition 1: Meltdown. Achieved by having heat go over tolerances. This is less devastating because it's easier to achieve.
//Results: Engineering becomes unusable and your engine irreparable
/obj/structure/machinery/power/rbmk/proc/meltdown()
	if(flags_reactor & REACTOR_SLAGGED)
		return
	flags_reactor |= REACTOR_SLAGGED
	update_icon()
	stop_processing()
	icon_state = "reactor_slagged"
	playsound('sound/effects/rbmk/meltdown.ogg', 25, 1, 7)
	visible_message(SPAN_USERDANGER("You hear a horrible metallic hissing."))
	cell_explosion(src, 600, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
	GLOB.enter_allowed = FALSE
	SSticker.mode.play_cinematic(cause_data = create_cause_data("взрыв реактора", src))
	for(var/shuttle_id in list(DROPSHIP_ALAMO, DROPSHIP_NORMANDY))
		var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_id)
		var/obj/structure/machinery/computer/shuttle/dropship/flight/console = shuttle.getControlConsole()
		console.disable()
	to_chat_spaced(world, html = SPAN_ANNOUNCEMENT_HEADER_BLUE("Вы видите как на орбите рядом взрывается [MAIN_SHIP_NAME], его осколки охватывают всю орбиту"))

/obj/structure/machinery/power/rbmk/update_icon()
	icon_state = "reactor_off"
	if(!has_fuel())
		icon_state = "reactor_off"
	else if(flags_reactor & REACTOR_SLAGGED)
		icon_state = "reactor_slagged"
	else if(temperature <= 200)
		icon_state = "reactor_on"
	else if(temperature <= temperature_operating)
		icon_state = "reactor_hot"
	else if(temperature <= temperature_pre_critical)
		icon_state = "reactor_veryhot"
	else if(temperature <= temperature_critical) //Point of no return.
		icon_state = "reactor_overheat"
	else
		icon_state = "reactor_meltdown"


//Startup, shutdown

/obj/structure/machinery/power/rbmk/proc/start_up()
	if(flags_reactor & REACTOR_SLAGGED)
		return // No :)
	start_processing()
	desired_k = 1
	set_light_on(TRUE)
	var/startup_sound = pick('sound/effects/rbmk/startup.ogg', 'sound/effects/rbmk/startup2.ogg')
	playsound(loc, startup_sound, 100)

//Shuts off the fuel rods, ambience, etc. Keep in mind that your temperature may still go up!
/obj/structure/machinery/power/rbmk/proc/shut_down()
	stop_processing()
	set_light_on(FALSE)
	K = 0
	desired_k = 0
	temperature = 0
	update_icon()

/obj/structure/machinery/power/rbmk/get_examine_text(mob/user)
	. = ..()
	if(Adjacent(src, user))
		if(do_after(user, 1 SECONDS))
			var/percent = health / initial(health) * 100
			. += "<span class='warning'>The reactor looks operational.</span>"
			switch(percent)
				if(0 to 10)
					. += "<span class='boldwarning'>[src]'s seals are dangerously warped and you can see cracks all over the reactor vessel! </span>"
				if(10 to 40)
					. += "<span class='boldwarning'>[src]'s seals are heavily warped and cracked! </span>"
				if(40 to 60)
					. += "<span class='warning'>[src]'s seals are holding, but barely. You can see some micro-fractures forming in the reactor vessel.</span>"
				if(60 to 80)
					. += "<span class='warning'>[src]'s seals are in-tact, but slightly worn. There are no visible cracks in the reactor vessel.</span>"
				if(80 to 90)
					. += "<span class='notice'>[src]'s seals are in good shape, and there are no visible cracks in the reactor vessel.</span>"
				if(95 to 100)
					. += "<span class='notice'>[src]'s seals look factory new, and the reactor's in excellent shape.</span>"

/obj/structure/machinery/power/rbmk/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/fuel_rod))
		if(flags_reactor & REACTOR_MELTDOWN)
			to_chat(user, SPAN_WARNING("[src] meldowning."))
			return FALSE
		if(!(flags_reactor & REACTOR_FUEL_ACTIONS))
			to_chat(user, SPAN_NOTICE("Кажется вы не можете никак взаимодествовать с погрузочным механизмом топлива [src], он просто не реагирует."))
			return FALSE
		if(power >= 20)
			to_chat(user, "<span class='notice'>You cannot insert fuel into [src] when it has been raised above 20% power.</span>")
			return FALSE
		if(length(fuel_rods) >= max_fuel_rods)
			to_chat(user, "<span class='warning'>[src] is already at maximum fuel load.</span>")
			return FALSE
		to_chat(user, "<span class='notice'>You start to insert [O] into [src]...</span>")
		if(do_after(user, 20 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!length(fuel_rods))
				start_up() //That was the first fuel rod. Let's heat it up.
			user.temp_drop_inv_item(O)
			fuel_rods += O
			O.forceMove(src)
		return TRUE
	else if(iswelder(O))
		if(flags_reactor & REACTOR_SLAGGED)
			to_chat(user, SPAN_NOTICE("You can't repair [src], it's completely slagged!"))
			return FALSE
		if(power >= 20)
			to_chat(user, SPAN_NOTICE("You can't repair [src] while it is running at above 20% power."))
			return FALSE
		if(health > 0.5 * initial(health))
			to_chat(user, SPAN_NOTICE("[src] is free from cracks."))
			return FALSE
		var/obj/item/tool/weldingtool/weldingtool = O
		if(weldingtool.remove_fuel(1, user))
			if(do_after(user, 20 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(!weldingtool.isOn())
					return FALSE
				if(health > 0.5 * initial(health))
					to_chat(user, SPAN_NOTICE("[src] is free from cracks."))
					return FALSE
				health += 20
				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You weld together some of [src]'s cracks. This'll do for now."))
				return TRUE
		to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
		return FALSE
	else
		return ..()


//Controlling the reactor.

/obj/structure/machinery/computer/reactor
	name = "reactor control console"
	desc = "Scream"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp2"
	light_color = "#55BA55"
	light_power = 1
	light_range = 3
	density = TRUE
	var/id = "default_reactor_for_lazy_mappers"
	var/obj/structure/machinery/power/rbmk/reactor //Our reactor.

/obj/structure/machinery/computer/reactor/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(link_to_reactor)), 10 SECONDS)

/obj/structure/machinery/computer/reactor/power_change()
	return

/obj/structure/machinery/computer/reactor/proc/link_to_reactor()
	for(var/obj/structure/machinery/power/rbmk/rbmk in GLOB.fusion_cores)
		if(rbmk.id && rbmk.id == id)
			reactor = rbmk
			return TRUE
	return FALSE

#define FREQ_RBMK_CONTROL 1439.69

/obj/structure/machinery/computer/reactor/control_rods
	name = "control rod management computer"
	desc = "A computer which can remotely raise / lower the control rods of a reactor."

/obj/structure/machinery/computer/reactor/control_rods/attack_hand(mob/living/user)
	. = ..()
	tgui_interact(user)

/obj/structure/machinery/computer/reactor/control_rods/tgui_interact(mob/user, datum/tgui/ui)
	if(!reactor)
		reactor = tgui_input_list(user, "Select reactor to control.", "Reactors", GLOB.fusion_cores)
		if(!reactor)
			return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RbmkControlRods", "Reactor Control")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/structure/machinery/computer/reactor/control_rods/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(action == "input")
		var/input = text2num(params["target"])
		reactor.desired_k = Clamp(input / 10, 0, 10)

/obj/structure/machinery/computer/reactor/control_rods/ui_data(mob/user)
	var/list/data = list()
	data["control_rods"] = 0
	data["k"] = 0
	data["desiredK"] = 0
	if(reactor)
		data["control_rods"] = 100 - (reactor.desired_k * 10) //Rod insertion is extrapolated as a function of the percentage of K
		data["k"] = reactor.K * 4
		data["desiredK"] = reactor.desired_k * 10
	return data

/obj/structure/machinery/computer/reactor/stats
	name = "reactor statistics console"
	desc = "A console for monitoring the statistics of a nuclear reactor."
	var/next_stat_interval = 0
	var/list/powerData = list()
	var/list/temperatureData = list()

/obj/structure/machinery/computer/reactor/stats/Initialize()
	. = ..()
	start_processing()

/obj/structure/machinery/computer/reactor/stats/attack_hand(mob/living/user)
	. = ..()
	tgui_interact(user)

/obj/structure/machinery/computer/reactor/stats/tgui_interact(mob/user, datum/tgui/ui)
	if(!reactor)
		reactor = tgui_input_list(user, "Select reactor to control.", "Reactors", GLOB.fusion_cores)
		if(!reactor)
			return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RbmkStats", "Reactor Control")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/structure/machinery/computer/reactor/stats/process()
	if(world.time >= next_stat_interval)
		next_stat_interval = world.time + 1 SECONDS //You only get a slow tick.
		powerData += (reactor) ? reactor.power*10 : 0 //We scale up the figure for a consistent:tm: scale
		if(powerData.len > 100) //Only lets you track over a certain timeframe.
			powerData.Cut(1, 2)
		temperatureData += (reactor) ? reactor.last_temperature : 0 //We scale up the figure for a consistent:tm: scale
		if(temperatureData.len > 100) //Only lets you track over a certain timeframe.
			temperatureData.Cut(1, 2)

/obj/structure/machinery/computer/reactor/stats/ui_data(mob/user)
	var/list/data = list()
	data["powerData"] = powerData
	data["temperatureData"] = temperatureData
	data["temperature"] = reactor ? reactor.last_temperature : 0
	data["power"] = reactor ? reactor.power : 0
	return data

/obj/structure/machinery/computer/reactor/fuel_rods
	name = "Reactor Fuel Management Console"
	desc = "A console which can remotely raise fuel rods out of nuclear reactors."

/obj/structure/machinery/computer/reactor/fuel_rods/attack_hand(mob/living/user)
	. = ..()
	if(!reactor)
		reactor = tgui_input_list(user, "Select reactor to control.", "Reactors", GLOB.fusion_cores)
		return FALSE
	if(reactor.power > 20)
		to_chat(user, SPAN_WARNING("You cannot remove fuel from [reactor] when it is above 20% power."))
		return FALSE
	if(!reactor.fuel_rods.len)
		to_chat(user, SPAN_WARNING("[reactor] does not have any fuel rods loaded."))
		return FALSE
	var/atom/movable/fuel_rod = input(usr, "Select a fuel rod to remove", "[src]", null) as null|anything in reactor.fuel_rods
	if(!fuel_rod)
		return
	playsound(src, pick('sound/effects/rbmk/switch.ogg', 'sound/effects/rbmk/switch2.ogg', 'sound/effects/rbmk/switch3.ogg'), 100, FALSE)
	playsound(reactor, 'sound/effects/rbmk/crane_1.wav', 100, FALSE)
	fuel_rod.forceMove(get_turf(reactor))
	reactor.fuel_rods -= fuel_rod

//SPENT FUEL POOL
//FINALLY WE CAN RECREATE THE ROBLOX NUCLEAR DISASTER - 18/08/2020

/turf/open/indestructible/sound/pool/spentfuel
	name = "Spent fuel pool"
	desc = "A dumping ground for spent nuclear fuel, can you touch the bottom?"
	icon = 'icons/obj/pool.dmi'
	icon_state = "spentfuelpool"

/turf/open/indestructible/sound/pool/spentfuel/wall
	icon_state = "spentfuelpoolwall"

/obj/item/fuel_rod
	name = "uranium-238 fuel rod"
	desc = "A titanium sheathed rod containing a measure of enriched uranium-dioxide powder, used to kick off a fission reaction."
	icon = 'icons/obj/control_rod.dmi'
	icon_state = "irradiated"
	w_class = SIZE_MASSIVE

	var/depletion = 0 //Each fuel rod will deplete in around 30 minutes.
	var/fuel_power = 0.10
	var/control_rod_effectiveness = 0.15

	var/rad_strength = 500
	// The depletion where depletion_final() will be called (and does something)
	var/depletion_threshold = 100
	// How fast this rod will deplete
	var/depletion_speed_modifier = 1
	var/depleted_final = FALSE // depletion_final should run only once
	var/depletion_conversion_type = "plutonium"

/obj/item/fuel_rod/Destroy()
	var/obj/structure/machinery/power/rbmk/N = loc
	if(istype(N))
		N.fuel_rods -= src
	return ..()

// This proc will try to convert your fuel rod if you don't override this proc
// So, ideally, you should write an override of this for every fuel rod you want to create
/obj/item/fuel_rod/proc/depletion_final(result_rod)
	if(!result_rod)
		return
	var/obj/structure/machinery/power/rbmk/N = loc
	// Rod conversion is moot when you can't find the reactor
	if(istype(N))
		var/obj/item/fuel_rod/R
		// You can add your own depletion scheme and not override this proc if you are going to convert a fuel rod into another type
		switch(result_rod)
			if("plutonium")
				R = new /obj/item/fuel_rod/plutonium(loc)
				R.depletion = depletion
			if("depleted")
				if(fuel_power < 10)
					fuel_power = 0
					R = new /obj/item/fuel_rod/depleted(loc)
					R.depletion = depletion

		// Finalization of conversion
		if(istype(R))
			N.fuel_rods += R
			qdel(src)
	else
		depleted_final = FALSE // Maybe try again later?

/obj/item/fuel_rod/proc/deplete(amount=0.035)
	depletion += amount * depletion_speed_modifier
	if(depletion >= depletion_threshold && !depleted_final)
		depleted_final = TRUE
		depletion_final(depletion_conversion_type)

/obj/item/fuel_rod/plutonium
	fuel_power = 0.20
	control_rod_effectiveness = 0.05
	name = "plutonium-239 fuel rod"
	desc = "A highly energetic titanium sheathed rod containing a sizeable measure of weapons grade plutonium, it's highly efficient as nuclear fuel, but will cause the reaction to get out of control if not properly utilised."
	icon_state = "inferior"
	rad_strength = 1500
	depletion_threshold = 300
	depletion_conversion_type = "depleted"

/obj/item/fuel_rod/depleted
	fuel_power = 0.05
	name = "depleted fuel rod"
	desc = "A highly radioactive fuel rod which has expended most of it's useful energy."
	icon_state = "normal"
	rad_strength = 6000 // smelly
	depletion_conversion_type = null // we don't want it to turn into anything

/obj/effect/landmark/reactor_rods
	name = "Reactor fuel rod"
	icon_state = "reactor_fuel"

/obj/effect/landmark/reactor_rods/Initialize(mapload, ...)
	. = ..()
	var/fuel_rod = pick(/obj/item/fuel_rod, /obj/item/fuel_rod, /obj/item/fuel_rod, /obj/item/fuel_rod/plutonium)
	new fuel_rod(get_turf(src))
