#define FUEL_ENERGY_CAPACITY *1
#define SPENT_FUEL_ENERGY_CAPACITY *0.25
#define COOLANT_ENERGY_CAPACITY *8

#define GET_FULL_NUMBER *(10^9)

/obj/structure/machinery/power/dragon_core
	name = "Dragon Core"
	desc = "Reactor edging technologies, allowing us to generate a lot of energy, by generating itself degenerated matter and supporting reaction. On in red writed on black: \"Warning, use with care, can callaps in black hole or fully annihilate system!\", this is reactor also can work with plasma in stundby mode.\n This is test example, any case of damage can happen."
	icon = 'icons/obj/structures/machinery/fusion.dmi'
	icon_state = "offline"
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	unacidable = TRUE
	health = 10000
	directwired = FALSE
	power_machine = TRUE
	indestructible = TRUE
	layer = ABOVE_TURF_LAYER

	pixel_x = -64
	pixel_y = -64
	bound_width = 128
	bound_height = 128
	bound_x = -64
	bound_y = -64

	light_system = STATIC_LIGHT
	light_range = 7
	light_power = 0.5
	light_color = LIGHT_COLOR_ELECTRIC_CYAN
	light_on = FALSE
	var/light_status = 0

	//Reactor operating temp values
	var/temperature_operating = 40
	var/temperature_pre_critical = 70
	var/temperature_critical = 90
	var/temperature_meltdown = 110 //1.1 trillion, just make BOOM

	//Reactor processing values
	var/reactor_capacity = 10000 // L ? I think so...
	var/current_fuel_k = 0
	var/current_k = 0 //If this is parameter very big, that bad, because reactor itself overheating
	var/last_temperature = 0
	var/last_vessel_temperature = 0
	var/last_vessel_cooled = 0
	var/power = 0
	var/last_power_produced = 0
	var/base_power_modifier = 5000

	var/next_slowprocess = 0

	var/next_warning = 0 //To avoid spam.
	var/alerts = list("Overheat" = FALSE, "Energydrain" = FALSE, "Vesselconsumption" = FALSE)

	var/power_stored = 0 //Power stored for prepare jum, yep crystalic got brain issue, and going very scifi, in future traveling between loks on map

	var/flags_reactor = REACTOR_FUEL_ACTIONS
	var/id = null
	var/datum/cause_data/cause_data

	//Max controlable reactor values
	var/max_shield_projection = 100
	var/max_shield_power = 500000
	var/max_magnet_impulsion = 100
	var/max_compression = 100
	var/max_fuel_injection = 12
	var/max_coolant_injection = 4
	var/max_contained_ejection = 48
	var/max_heating_rate = 100
	var/max_energy_absorbtion_rate = 100
	var/max_reactor_cooling_rate = 100

	//Controlable reactor values
	var/shield_projection = 0 //Additional barrier for containing, preventing reactor from eating itself (use a lot of energy), but if you get enough energy in moment of explosion, ship can survive.
	var/shield_power = 0
	var/magnet_impulsion = 0 //How strong we powering magnets, for contain fuel (use a lot of energy)
	var/compression = 0 //How strong we compressing fusion
	var/fuel_compression = 0 //Bigger value, take more heat but can very fast produce more if condition for fusion meet
	var/fuel_compression_percentage = 0
	var/fuel_injection = 0 //How many fuel we feeding to reactor
	var/coolant_injection = 0 //How many fuel we feeding to reactor
	var/contained_ejection = 0 //Ejecting used fuel, if don't have spent fuel, ejecting normal fuel
	var/heating_rate = 0 //Additional heating of reactor, for starting fusion or assist fusion in small amount of fuel
	var/energy_absorbtion_rate = 0 //How strong our energy absobtion, of one that reaction proced (if this is value not enough, all contained fuel in reactor start heating faster and reactor heating itself)
	var/reactor_cooling_rate = 0 //How fast we cooling reactor

	//Chamber parametrs
	var/chambered_fuel = 0
	var/chambered_spent_fuel = 0
	var/chambered_coolant = 0

	var/max_fuel_cells = 2
	var/list/obj/item/dcore_reactor_supply_cell/fuel/fuel_cells = list()
	var/max_coolant_cells = 2
	var/list/obj/item/dcore_reactor_supply_cell/coolant/coolant_cells = list()

	//Custom rods, that make special effects, WIP
	var/max_rods = 8
	var/list/rods = list()

/obj/structure/machinery/power/dragon_core/Initialize(mapload)
	. = ..()
	cause_data = create_cause_data("взрыв дегенеративной материи", src)
	if(!id)
		id = "[pick(alphabet_uppercase)][pick(alphabet_uppercase)]-[rand(0,9)][rand(0,9)][rand(0,9)]"
	GLOB.dragon_cores += src
	connect_to_network() //Should start with a cable piece underneath, if it doesn't, something's messed up in mapping
	lazy_startup()

/obj/structure/machinery/power/dragon_core/proc/lazy_startup()
	flags_reactor &= ~REACTOR_SLAGGED
	var/rod = 0
	for(rod in 1 to max_fuel_cells)
		fuel_cells += new /obj/item/dcore_reactor_supply_cell/fuel(src)
	rod = 0
	for(rod in 1 to max_coolant_cells)
		coolant_cells += new /obj/item/dcore_reactor_supply_cell/coolant(src)
	fuel_injection = 1
	contained_ejection = 1
	heating_rate = 1
	energy_absorbtion_rate = 1
	reactor_cooling_rate = 1
	start_up()

/obj/structure/machinery/power/dragon_core/power_change()
	return

/obj/structure/machinery/power/dragon_core/update_icon()
	if(!has_fuel())
		icon_state = "offline"
	else if(flags_reactor & REACTOR_SLAGGED)
		icon_state = "slagged"
	else if(current_fuel_k > temperature_operating GET_FULL_NUMBER)
		icon_state = "online"
	else if(current_fuel_k > temperature_pre_critical GET_FULL_NUMBER)
		icon_state = "hot"
	else if(current_fuel_k > temperature_critical GET_FULL_NUMBER)
		icon_state = "overheat"
	else if(current_fuel_k > temperature_meltdown GET_FULL_NUMBER) //Point of no return.
		icon_state = "meltdown"
	else
		icon_state = "loaded"

/obj/structure/machinery/power/dragon_core/proc/start_up()
	if(flags_reactor & REACTOR_SLAGGED || !has_fuel())
		return
	shipwide_ai_announcement("Warning, reactor start up, gravitational impulse expected", "[MAIN_AI_SYSTEM]", 'sound/effects/rbmk/alarm.ogg')
	start_processing()
	set_light_on(TRUE)
	var/startup_sound = pick('sound/effects/rbmk/startup.ogg', 'sound/effects/rbmk/startup2.ogg')
	playsound(loc, startup_sound, 100)
	shakeship(5, 5, FALSE, TRUE)

//Shuts off the fuel rods, ambience, etc. Keep in mind that your temperature may still go up!
/obj/structure/machinery/power/dragon_core/proc/shut_down()
	shipwide_ai_announcement("Warning, reactor shutdown, gravitational impulse expected", "[MAIN_AI_SYSTEM]", 'sound/effects/rbmk/alarm.ogg')
	stop_processing()
	set_light_on(FALSE)
	update_icon()
	shakeship(5, 5, FALSE, TRUE)

/obj/structure/machinery/power/dragon_core/ex_act(severity)
	health -= severity

/obj/structure/machinery/power/dragon_core/process()
	if(next_slowprocess < world.time)
		slowprocess()
		next_slowprocess = world.time + 5 SECONDS

/obj/structure/machinery/power/dragon_core/proc/has_fuel()
	var/fuel_amount_stored = chambered_fuel
	for(var/obj/item/dcore_reactor_supply_cell/cell as anything in fuel_cells)
		fuel_amount_stored += cell.fuel
	return fuel_amount_stored

/obj/structure/machinery/power/dragon_core/proc/slowprocess()
	if(flags_reactor & REACTOR_SLAGGED)
		stop_processing()
		return

	if(shield_projection)
		shield_power = min(shield_power + max_shield_power / 120 * (shield_projection * 0.01), max_shield_power)
	else
		shield_power = max(shield_power - max_shield_power / 120, 0)

	if(current_fuel_k < 0)
		current_fuel_k = 0

	var/total_energy_capacity = chambered_fuel FUEL_ENERGY_CAPACITY + chambered_spent_fuel SPENT_FUEL_ENERGY_CAPACITY + chambered_coolant COOLANT_ENERGY_CAPACITY

	var/fuel_to_inject = 0
	for(var/obj/item/dcore_reactor_supply_cell/cell as anything in fuel_cells)
		fuel_to_inject += cell.get_fuel(fuel_injection)
	if(total_energy_capacity && total_energy_capacity)
		current_fuel_k -= current_fuel_k / total_energy_capacity * (fuel_to_inject FUEL_ENERGY_CAPACITY) * 0.5
	chambered_fuel += fuel_to_inject

	total_energy_capacity = chambered_fuel FUEL_ENERGY_CAPACITY + chambered_spent_fuel SPENT_FUEL_ENERGY_CAPACITY + chambered_coolant COOLANT_ENERGY_CAPACITY

	var/coolant_to_inject = 0
	for(var/obj/item/dcore_reactor_supply_cell/cell as anything in coolant_cells)
		coolant_to_inject += cell.get_fuel(coolant_injection)
	if(total_energy_capacity && total_energy_capacity)
		current_fuel_k -= current_fuel_k / total_energy_capacity * (coolant_to_inject COOLANT_ENERGY_CAPACITY) * 0.5
	chambered_coolant += coolant_to_inject

	total_energy_capacity = chambered_fuel FUEL_ENERGY_CAPACITY + chambered_spent_fuel SPENT_FUEL_ENERGY_CAPACITY + chambered_coolant COOLANT_ENERGY_CAPACITY

	//TODO: do rods actions here, like controll, buffs and debuffs,

	fuel_compression_percentage = chambered_fuel + chambered_spent_fuel + chambered_coolant
	if(fuel_compression_percentage)
		fuel_compression_percentage = fuel_compression_percentage / reactor_capacity / max(0.02, compression / 50) * 100

	fuel_compression = fuel_compression * 0.9 + (fuel_compression_percentage * max(1, magnet_impulsion) * 0.1)

	if(rand(fuel_compression_percentage, fuel_compression_percentage * 2) > 100)
		shield_power -= current_fuel_k / 10000000000000 * fuel_compression
		if(shield_power < 0)
			shield_power = 0
			health -= fuel_compression_percentage * 10
			chambered_fuel += fuel_compression_percentage * 40
			alerts["Vesselconsumption"] = TRUE
	else
		alerts["Vesselconsumption"] = FALSE

	var/fuel_to_lose = 0
	if(current_fuel_k)
		fuel_to_lose = current_fuel_k / 10000000000000 * fuel_compression
		if(heating_rate)
			fuel_to_lose *= heating_rate
		if(reactor_cooling_rate)
			fuel_to_lose /= reactor_cooling_rate * 0.25
		fuel_to_lose = min(chambered_fuel, fuel_to_lose)

	chambered_spent_fuel += fuel_to_lose * 2
	chambered_fuel -= fuel_to_lose

	total_energy_capacity = chambered_fuel FUEL_ENERGY_CAPACITY + chambered_spent_fuel SPENT_FUEL_ENERGY_CAPACITY + chambered_coolant COOLANT_ENERGY_CAPACITY

	var/create_fuel_k = 0
	if(total_energy_capacity)
		create_fuel_k += heating_rate / total_energy_capacity
		if(fuel_to_lose > 0)
			create_fuel_k += fuel_to_lose * 1000000000000 / total_energy_capacity * (fuel_compression * 0.5)
	current_fuel_k += create_fuel_k

	var/k_for_transfer = (current_fuel_k - (current_k ^ 2 * 0.01)) * 0.000000001
	if(k_for_transfer)
		if(shield_projection)
			k_for_transfer /= shield_projection ^ 4
		if(magnet_impulsion)
			k_for_transfer /= magnet_impulsion
		k_for_transfer = k_for_transfer * total_energy_capacity ^ 2
		current_k += k_for_transfer
		current_fuel_k -= k_for_transfer * (max(1, energy_absorbtion_rate) / 50)

	if(total_energy_capacity)
		if(shield_projection)
			current_k += (total_energy_capacity / reactor_capacity + current_fuel_k * 0.0000000001) * shield_projection

		if(magnet_impulsion)
			current_k += magnet_impulsion * (current_fuel_k * 0.0000000001)

	var/cooled_down_k = 0
	if(reactor_cooling_rate)
		cooled_down_k = current_k * (rand(reactor_cooling_rate, reactor_cooling_rate * 10) / 1000)
	current_k -= cooled_down_k

	power = current_fuel_k / (temperature_critical GET_FULL_NUMBER) * 100

	last_power_produced = k_for_transfer * 10000
	last_power_produced *= (max(1, power) / 100) * (max(1, energy_absorbtion_rate) / 100)
	last_power_produced *= rand(50, 150) * 0.01

	current_fuel_k -= last_power_produced

	last_power_produced *= base_power_modifier

	//Using energy here
	last_power_produced -= heating_rate * (base_power_modifier * 0.1)
	last_power_produced -= shield_projection * (base_power_modifier * (fuel_compression) * total_energy_capacity) * 0.01
	last_power_produced -= magnet_impulsion * (base_power_modifier * total_energy_capacity)
	last_power_produced -= reactor_cooling_rate * cooled_down_k

	add_avail(last_power_produced)

	if(power > 80 && last_power_produced > 0)
		power_stored += 1
	else if (power_stored > 0)
		power_stored -= 1

	//Ejecting some percentage of fuel
	if(contained_ejection && total_energy_capacity)
		chambered_fuel -= min(chambered_fuel, total_energy_capacity / 100 * (contained_ejection / 100))
		chambered_spent_fuel -= min(chambered_spent_fuel, total_energy_capacity / 100 * (contained_ejection / 25))
		chambered_coolant -= min(chambered_coolant, total_energy_capacity / 100 * (contained_ejection / 100))

	last_temperature = current_fuel_k + rand(1, 100000) / 10
	last_vessel_temperature = current_k + rand(1, 1000) / 10
	last_vessel_cooled = cooled_down_k + rand(1, 100) / 10
	handle_alerts()
	update_icon()

//Method to handle sound effects, reactor warnings, all that jazz.
/obj/structure/machinery/power/dragon_core/proc/handle_alerts()
	if(current_k < 0)
		current_k = 0

	if(current_fuel_k < 0)
		current_fuel_k = 0

	if(!current_k && !current_fuel_k)
		shut_down()

	//First alerts condition: Overheat
	if(current_fuel_k >= temperature_critical GET_FULL_NUMBER || current_k >= temperature_critical * 10000)
		alerts["Overheat"] = TRUE
		var/temp_damage = 0
		if(current_fuel_k >= temperature_meltdown GET_FULL_NUMBER)
			temp_damage = current_fuel_k/10000000000

		else if(current_k >= temperature_meltdown * 10000)
			temp_damage = current_k/100

		if(temp_damage)
			health -= temp_damage
			if(health <= temp_damage)
				meltdown()
				return
	else
		alerts["Overheat"] = FALSE

	if(last_power_produced < 0)
		alerts["Energydrain"] = TRUE
	else
		alerts["Energydrain"] = FALSE

	light_range = 7
	light_power = 0.5
	light_color = LIGHT_COLOR_CYAN
	light_status = 0

	var/need_alert = FALSE
	for(var/alert in alerts)
		if(!alerts[alert])
			continue
		if(!need_alert && world.time > next_warning)
			next_warning = world.time + 60 SECONDS //To avoid engis pissing people off when reaaaally trying to stop the meltdown or whatever.
			need_alert = TRUE
		switch(alert)
			if("Overheat")
				if(need_alert)
					shipwide_ai_announcement("WARNING, reactor overheating, WARNING, required actions", "[MAIN_AI_SYSTEM]", 'sound/effects/rbmk/alarm.ogg')
					playsound(src, 'sound/effects/rbmk/alarm.ogg', 25, 1, 7)
				if(light_status < 1)
					light_range = 7
					light_power = 0.5
					light_color = LIGHT_COLOR_RED
					light_status = 1
			if("Energydrain")
				if(need_alert)
					shipwide_ai_announcement("WARNING, Reactor draining power, WARNING, check console for more precise cause", "[MAIN_AI_SYSTEM]", 'sound/effects/rbmk/alarm.ogg')
					playsound(src, 'sound/effects/rbmk/alarm.ogg', 25, 1, 7)
			if("Vesselconsumption")
				if(need_alert)
					shipwide_ai_announcement("WARNING, Reactor chamber started self consumption, WARNING, REQUIRED IMMEDIATLY ACTIONS", "[MAIN_AI_SYSTEM]", 'sound/effects/rbmk/alarm.ogg')
					playsound(src, 'sound/effects/rbmk/alarm.ogg', 25, 1, 7)
				if(light_status < 2)
					light_range = 14
					light_power = 1
					light_color = LIGHT_COLOR_BLOOD_MAGIC
					light_status = 2
		sleep(3 SECONDS)

	static_update_light()

/obj/structure/machinery/power/dragon_core/proc/meltdown()
	if(flags_reactor & REACTOR_SLAGGED)
		return
	flags_reactor |= REACTOR_SLAGGED
	update_icon()
	stop_processing()
	playsound('sound/effects/rbmk/meltdown.ogg', 25, 1, 7)
	visible_message(SPAN_USERDANGER("You hear a horrible metallic hissing."))
	if(current_fuel_k >= temperature_critical GET_FULL_NUMBER)
		enter_allowed = FALSE
		for(var/shuttle_id in list(DROPSHIP_ALAMO, DROPSHIP_NORMANDY))
			var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_id)
			var/obj/structure/machinery/computer/shuttle/dropship/flight/console = shuttle.getControlConsole()
			console.disable()
		to_chat_spaced(world, html = SPAN_ANNOUNCEMENT_HEADER_BLUE("Вы видите как на орбите рядом взрывается [MAIN_SHIP_NAME], его осколки охватывают всю орбиту, волна высококонцентрированной плазмы медленно распространяется по орбите, создавая эффект солнечного ветра...\n Как красиво, северное сияние распространяется над поверхностью, до того как это все уничтожит всю планету, убив флору и фауну загрязнением."))
		SSticker.mode.play_cinematic(cause_data = cause_data)
	else
		shipwide_ai_announcement("Составление аварийного отчета.\n Реактор получил критические повреждения, реакция была сдержана, корабль не уничтожен...\n Сигнал бедствия отправлен, примерное время до прилета союзного судна для буксировки ? часов.\n Внимание, оставшеся время работы жизнеобеспечения ? часов.\n Аварийные генераторы скоро будут включены...", "[MAIN_AI_SYSTEM]", 'sound/effects/rbmk/alarm.ogg')
		to_chat_spaced(world, html = SPAN_ANNOUNCEMENT_HEADER_BLUE("Вы видите как на орбите рядом [MAIN_SHIP_NAME] содрагается, от него летят в разные стороны всякого рода структурные детали.\n Волна плазмы выходит из примерного места где инженерный отсек, за ней следом вылетает огромное количество пены."))
		SSticker.mode.activate_distress()
		cell_explosion(src, 5000, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
		shakeship(20, 20, FALSE, TRUE)

/obj/structure/machinery/power/dragon_core/get_examine_text(mob/user)
	. = ..()
	if(Adjacent(src, user))
		if(do_after(user, 1 SECONDS))
			var/percent = health / initial(health) * 100
			. += SPAN_WARNING("The reactor looks operational.")
			switch(percent)
				if(0 to 10)
					. += SPAN_BOLDWARNING("[src]'s seals are dangerously warped and you can see cracks all over the reactor vessel!")
				if(10 to 40)
					. += SPAN_BOLDWARNING("[src]'s seals are heavily warped and cracked!")
				if(40 to 60)
					. += SPAN_WARNING("[src]'s seals are holding, but barely. You can see some micro-fractures forming in the reactor vessel.")
				if(60 to 80)
					. += SPAN_WARNING("[src]'s seals are in-tact, but slightly worn. There are no visible cracks in the reactor vessel.")
				if(80 to 90)
					. += SPAN_NOTICE("[src]'s seals are in good shape, and there are no visible cracks in the reactor vessel.")
				if(95 to 100)
					. += SPAN_NOTICE("[src]'s seals look factory new, and the reactor's in excellent shape.")

/obj/structure/machinery/power/dragon_core/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/dcore_reactor_supply_cell/fuel))
		if(flags_reactor & REACTOR_MELTDOWN)
			to_chat(user, SPAN_WARNING("[src] meldowning."))
			return FALSE
		if(!(flags_reactor & REACTOR_FUEL_ACTIONS))
			to_chat(user, SPAN_NOTICE("Кажется вы не можете никак взаимодествовать с погрузочным механизмом [src], он в безопасном режиме."))
			return FALSE
		if(length(fuel_cells) >= max_fuel_cells)
			to_chat(user, SPAN_WARNING("[src] is already at maximum fuel load."))
			return FALSE
		to_chat(user, SPAN_NOTICE("You start to insert [O] into [src]..."))
		if(do_after(user, 20 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.temp_drop_inv_item(O)
			fuel_cells += O
			O.forceMove(src)
		return TRUE

	else if(istype(O, /obj/item/dcore_reactor_supply_cell/coolant))
		if(flags_reactor & REACTOR_MELTDOWN)
			to_chat(user, SPAN_WARNING("[src] meldowning."))
			return FALSE
		if(!(flags_reactor & REACTOR_FUEL_ACTIONS))
			to_chat(user, SPAN_NOTICE("Кажется вы не можете никак взаимодествовать с погрузочным механизмом [src], он в безопасном режиме."))
			return FALSE
		if(length(coolant_cells) >= max_coolant_cells)
			to_chat(user, SPAN_WARNING("[src] is already at maximum coolant load."))
			return FALSE
		to_chat(user, SPAN_NOTICE("You start to insert [O] into [src]..."))
		if(do_after(user, 20 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.temp_drop_inv_item(O)
			fuel_cells += O
			O.forceMove(src)
		return TRUE

	else if(iswelder(O))
		if(flags_reactor & REACTOR_SLAGGED)
			to_chat(user, SPAN_NOTICE("You can't repair [src], it's completely slagged!"))
			return FALSE
		if(health > 0.5 * initial(health))
			to_chat(user, SPAN_NOTICE("[src] is free from cracks."))
			return FALSE
		var/obj/item/tool/weldingtool/weldingtool = O
		if(!weldingtool.remove_fuel(1, user))
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
		if(do_after(user, 20 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!weldingtool.isOn())
				return FALSE
			if(health > 0.5 * initial(health))
				to_chat(user, SPAN_NOTICE("[src] is free from cracks."))
				return FALSE
			health += 100
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("You weld together some of [src]'s cracks. This'll do for now."))
			return TRUE
		return FALSE

	else if(istype(O, /obj/item/stack/sheet/plasteel))
		if(flags_reactor & REACTOR_SLAGGED)
			to_chat(user, SPAN_NOTICE("You can't repair [src], it's completely slagged!"))
			return FALSE
		if(health > initial(health))
			to_chat(user, SPAN_NOTICE("[src] is free from cracks."))
			return FALSE
		var/obj/item/stack/sheet/plasteel/plasteel = O
		if(plasteel.get_amount() < STACK_10)
			to_chat(user, SPAN_WARNING("You don't have enough of [plasteel] to repair [src]."))
			return
		if(do_after(user, 20 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(health > initial(health))
				to_chat(user, SPAN_NOTICE("[src] is free from cracks."))
				return FALSE
			if(!plasteel.use(STACK_10))
				to_chat(user, SPAN_WARNING("You don't have enough of [plasteel] to repair [src]."))
				return
			health += 200
			to_chat(user, SPAN_NOTICE("You repaired some of [src]'s cracks. This'll do for now."))
			return TRUE
		return FALSE
	else
		return ..()

//Controlling the reactor.

/obj/structure/machinery/computer/dragon_core_reactor
	name = "reactor control console"
	desc = "Scream"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp2"
	light_color = "#55BA55"
	light_power = 1
	light_range = 3
	density = TRUE
	var/id = "default_reactor_for_lazy_mappers"
	var/obj/structure/machinery/power/dragon_core/reactor //Our reactor.

/obj/structure/machinery/computer/dragon_core_reactor/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(link_to_reactor)), 10 SECONDS)

/obj/structure/machinery/computer/dragon_core_reactor/power_change()
	return

/obj/structure/machinery/computer/dragon_core_reactor/proc/link_to_reactor()
	for(var/obj/structure/machinery/power/dragon_core/dragon_core in GLOB.dragon_cores)
		if(dragon_core.id && dragon_core.id == id)
			reactor = dragon_core
			return TRUE
	return FALSE

/obj/structure/machinery/computer/dragon_core_reactor/control_rods
	name = "control rod management computer"
	desc = "A computer which can remotely raise / lower the control rods of a reactor."

/obj/structure/machinery/computer/dragon_core_reactor/control_rods/attack_hand(mob/living/user)
	. = ..()
	tgui_interact(user)

/obj/structure/machinery/computer/dragon_core_reactor/control_rods/tgui_interact(mob/user, datum/tgui/ui)
	if(!reactor)
		reactor = tgui_input_list(user, "Select reactor to control.", "Reactors", GLOB.dragon_cores)
		if(!reactor)
			return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DragonCoreControl", "Reactor Control")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/structure/machinery/computer/dragon_core_reactor/control_rods/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(action == "input")
		reactor.vars[params["var"]] = Clamp(text2num(params["amount"]), 0, reactor.vars["max_[params["var"]]"])

/obj/structure/machinery/computer/dragon_core_reactor/control_rods/ui_data(mob/user)
	. = list()
	.["reactor"] = !!reactor
	if(reactor)
		.["shield_projection"] = reactor.shield_projection
		.["max_shield_power"] = reactor.max_shield_projection
		.["magnet_impulsion"] = reactor.magnet_impulsion
		.["max_magnet_impulsion"] = reactor.max_magnet_impulsion
		.["compression"] = reactor.compression
		.["max_compression"] = reactor.max_compression
		.["fuel_injection"] = reactor.fuel_injection
		.["max_fuel_injection"] = reactor.max_fuel_injection
		.["coolant_injection"] = reactor.coolant_injection
		.["max_coolant_injection"] = reactor.max_coolant_injection
		.["contained_ejection"] = reactor.contained_ejection
		.["max_contained_ejection"] = reactor.max_contained_ejection
		.["heating_rate"] = reactor.heating_rate
		.["max_heating_rate"] = reactor.max_heating_rate
		.["energy_absorbtion_rate"] = reactor.energy_absorbtion_rate
		.["max_energy_absorbtion_rate"] = reactor.max_energy_absorbtion_rate
		.["reactor_cooling_rate"] = reactor.reactor_cooling_rate
		.["max_reactor_cooling_rate"] = reactor.max_reactor_cooling_rate

/obj/structure/machinery/computer/dragon_core_reactor/stats
	name = "reactor statistics console"
	desc = "A console for monitoring the statistics of a nuclear reactor."
	var/next_stat_interval = 0
	var/reactor_prev_temp = 0
	var/list/powerData = list()
	var/list/temperatureData = list()
	var/list/vesseltemperatureData = list()
	var/list/vesselcoolingData = list()
	var/list/temdiffData = list()
	var/list/shieldData = list()

/obj/structure/machinery/computer/dragon_core_reactor/stats/attack_hand(mob/living/user)
	. = ..()
	tgui_interact(user)

/obj/structure/machinery/computer/dragon_core_reactor/stats/tgui_interact(mob/user, datum/tgui/ui)
	if(!reactor)
		reactor = tgui_input_list(user, "Select reactor to control.", "Reactors", GLOB.dragon_cores)
		if(!reactor)
			return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DragonCoreStats", "Reactor Stats")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/structure/machinery/computer/dragon_core_reactor/stats/process()
	if(world.time >= next_stat_interval)
		next_stat_interval = world.time + 1 SECONDS //You only get a slow tick.
		powerData += reactor ? reactor.power*10 : 0
		if(powerData.len > 100)
			powerData.Cut(1, 2)

		temperatureData += reactor ? reactor.last_temperature : 0
		if(temperatureData.len > 100)
			temperatureData.Cut(1, 2)

		vesseltemperatureData += reactor ? reactor.last_vessel_temperature : 0
		if(vesseltemperatureData.len > 100)
			vesseltemperatureData.Cut(1, 2)

		vesselcoolingData += reactor ? reactor.last_vessel_cooled : 0
		if(vesselcoolingData.len > 100)
			vesselcoolingData.Cut(1, 2)

		temdiffData += reactor ? reactor_prev_temp - reactor.last_temperature : 0
		reactor_prev_temp = reactor ? reactor.last_temperature : 0
		if(temdiffData.len > 100)
			temdiffData.Cut(1, 2)

		shieldData += reactor ? reactor.shield_power : 0
		if(shieldData.len > 100)
			shieldData.Cut(1, 2)

/obj/structure/machinery/computer/dragon_core_reactor/stats/ui_data(mob/user)
	. = list()
	.["power"] = reactor ? reactor.power : 0
	.["temperature"] = reactor ? reactor.last_temperature : 0
	.["vessel_temperature"] = reactor ? reactor.last_vessel_temperature : 0
	.["vessel_cooled"] = reactor ? reactor.last_vessel_cooled : 0
	.["max_shields"] = reactor ? reactor.max_shield_power : 0
	.["shields"] = reactor ? reactor.shield_power : 0
	.["powerData"] = powerData
	.["temperatureData"] = temperatureData
	.["vesseltemperatureData"] = vesseltemperatureData
	.["vesselcoolingData"] = vesselcoolingData
	.["temdiffData"] = temdiffData
	.["shieldData"] = shieldData

//Cells and Rods

/obj/item/dcore_reactor_supply_cell
	var/fuel = 0

/obj/item/dcore_reactor_supply_cell/proc/get_fuel(amount)
	var/fuel_to_move = min(amount, fuel)
	fuel -= fuel_to_move
	return fuel_to_move

/obj/item/dcore_reactor_supply_cell/fuel
	name = "Plasma Cell"
	desc = "A big cell filled with high pressure plasma, around it you can see a lot of magnits."
	icon = 'icons/obj/control_rod.dmi'
	icon_state = "irradiated"
	w_class = SIZE_MASSIVE
	fuel = 10000

/obj/item/dcore_reactor_supply_cell/coolant
	name = "Coolant Cell"
	desc = "A big cell filled with condensate boze, that one probably can very fast lower reactor temperature."
	icon = 'icons/obj/control_rod.dmi'
	icon_state = "inferior"
	w_class = SIZE_MASSIVE
	fuel = 1000

#undef FUEL_ENERGY_CAPACITY
#undef SPENT_FUEL_ENERGY_CAPACITY
#undef COOLANT_ENERGY_CAPACITY
