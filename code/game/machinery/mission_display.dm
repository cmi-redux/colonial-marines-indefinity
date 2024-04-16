
/obj/structure/machinery/mission_display
	icon = 'icons/obj/structures/machinery/mission_display.dmi'
	icon_state = "default"
	name = "mission display"
	desc = "A monitor showing details about various mission assets."
	anchored = 1
	density = 0
	use_power = TRUE

/* TODO: Redo that fully copypasted shit from closed PR on upstream, cool idea but fucking shit

//MODE DEFINES
#define MISSION_DISPLAY_OFF 0
#define MISSION_DISPLAY_SHIP 1
#define MISSION_DISPLAY_CANNON 2
#define MISSION_DISPLAY_SCAN 3
#define MISSION_DISPLAY_APC 4

//UI DEFINES
#define UI_DISPLAY_DEFAULT "D"
#define UI_DISPLAY_USCM "Y"
#define UI_DISPLAY_MERC "G"

//STATE DEFINES
#define X_COORDINATE 1
#define Y_COORDINATE 2
#define STATE_IMAGE 3
#define STATE1 1	//State of shuttle1 infront of "DS1"
#define STATE2 2	//State of shuttle2 infront of "DS2"
#define STATE3 3	//State of shuttle1 behind of "DS1"
#define STATE4 4	//State of shuttle2 behind of "DS1"
#define STATE5 5	//Shuttle1
#define STATE6 6	//Shuttle2
#define STATE7 7	//OB Cannon Status
#define STATE8 8	//OB Cannon Shell
#define STATE9 9	//OB Cannon Cooldown
#define STATE10 10	//Scan Alpha
#define STATE11 11	//Scan Bravo
#define STATE12 12	//Scan Charlie
#define STATE13 13	//Scan Delta
#define STATE14 14	//Scan Tcomms
#define STATE15 15	//APC Health
#define STATE16 16	//APC Type
#define STATE17 17	//APC Hardpoint 1
#define STATE18 18	//APC Hardpoint 2
#define STATE19 19	//APC Hardpoint 3
#define STATE20 20	//APC Hardpoint 4

//SHIP MODE DEFINES
#define SHIP_ALAMO 1
#define SHIP_NORMANDY 2
#define SHIP_STATE1_X 32	//Adjustments for state pixel locations here(STATE1 is infront of "DS1" while STATE2 behind "DS1" and STATE3 infront of "DS2" while STATE 4 behind "DS2")
#define SHIP_STATE1_Y -16
#define SHIP_STATE2_X 32
#define SHIP_STATE2_Y -22
#define SHIP_STATE3_X 54
#define SHIP_STATE3_Y -16
#define SHIP_STATE4_X 54
#define SHIP_STATE4_Y -22
#define SHIP_SHUTTLE_MOTHERSHIP_X 30
#define SHIP_SHUTTLE_MOTHERSHIP_Y -12
#define SHIP_SHUTTLE_PLANET_X 8
#define SHIP_SHUTTLE_PLANET_Y -20
#define SHIP_SHUTTLE_CAS_X 6
#define SHIP_SHUTTLE_CAS_Y -17

//CANNON MODE DEFINES
#define CANNON_STATE1_X 35
#define CANNON_STATE1_Y -5
#define CANNON_STATE2_X 43
#define CANNON_STATE2_Y -13
#define CANNON_STATE3_X 41
#define CANNON_STATE3_Y -22

//SCAN MODE DEFINES
#define SCAN_STATE1_X 35
#define SCAN_STATE1_Y -5
#define SCAN_STATE2_X 35
#define SCAN_STATE2_Y -12
#define SCAN_STATE3_X 51
#define SCAN_STATE3_Y -5
#define SCAN_STATE4_X 51
#define SCAN_STATE4_Y -12
#define SCAN_STATE5_X 32
#define SCAN_STATE5_Y -22

//APC MODE DEFINES
#define APC_STATE1_X 11
#define APC_STATE1_Y -11
#define APC_STATE2_X 5
#define APC_STATE2_Y -21
#define APC_STATE3_X 45
#define APC_STATE3_Y -4
#define APC_STATE4_X 45
#define APC_STATE4_Y -10
#define APC_STATE5_X 45
#define APC_STATE5_Y -17
#define APC_STATE6_X 45
#define APC_STATE6_Y -23

/obj/structure/machinery/mission_display
	icon = 'icons/obj/structures/machinery/mission_display.dmi'
	icon_state = "default"
	name = "mission display"
	desc = "A monitor showing details about various mission assets."
	anchored = 1
	density = 0
	use_power = TRUE
	var/mode = 0	//0 = Off
					//1 = Ship
					//2 = Cannon
					//3 = Scan
					//4 = APC
	var/ui = "D"	//D = Default
					//Y = Uscm
					//G = Merc
	var/list/mode_list = list("Off", "Ship", "Cannon", "Scan", "Apc", "Default", "Uscm", "Merc")

	//List containing the different states with coordinates on the display and the corresponding image
	var/obj/state[20][7]

	//Vars shuttle
	var/obj/docking_port/mobile/marine_dropship/shuttle1
	var/obj/docking_port/mobile/marine_dropship/shuttle2

	var/planet = "lv624"
	var/datum/squad/selected_squad
	var/list/squad_list = list()
	var/living_count = 0
	var/f = 0

/obj/structure/machinery/mission_display/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/mission_display/LateInitialize()
	mode = MISSION_DISPLAY_OFF
	start_processing()
	populate()
	set_display("frame_default")

/obj/structure/machinery/mission_display/ship/LateInitialize()
	mode = MISSION_DISPLAY_SHIP
	populate()
	set_display("display_ship_default")
	set_display(SSmapping.configs[GROUND_MAP].map_name)

/obj/structure/machinery/mission_display/cannon/LateInitialize()
	mode = MISSION_DISPLAY_CANNON
	populate()
	set_display("display_cannon_default")

/obj/structure/machinery/mission_display/scan/LateInitialize()
	mode = MISSION_DISPLAY_SCAN
	populate()
	set_display("display_scan_default")
	set_display(SSmapping.configs[GROUND_MAP].map_name)
	set_display("scan_arrow")

/obj/structure/machinery/mission_display/apc/LateInitialize()
	mode = MISSION_DISPLAY_APC
	populate()
	set_display("display_apc_default")

/obj/structure/machinery/mission_display/attack_hand(mob/user)
	var/input_mode = "Cancel"
	input_mode = tgui_input_list(usr, "Choose a display mode","Display", mode_list + ("Cancel"))
	if(input_mode == "Cancel")
		return
	update_display(mode2num(input_mode))

/obj/structure/machinery/mission_display/proc/update_display(status)
	switch(status)
		if(UI_DISPLAY_DEFAULT)
			for(var/obj/structure/machinery/mission_display/M in GLOB.machines)
				M.ui = "D"
				M.update_display(M.mode)
		if(UI_DISPLAY_USCM)
			for(var/obj/structure/machinery/mission_display/M in GLOB.machines)
				M.ui = "Y"
				M.update_display(M.mode)
		if(UI_DISPLAY_MERC)
			for(var/obj/structure/machinery/mission_display/M in GLOB.machines)
				M.ui = "G"
				M.update_display(M.mode)
		if(MISSION_DISPLAY_OFF)
			mode = MISSION_DISPLAY_OFF
			remove_display()
			switch(ui)
				if(UI_DISPLAY_DEFAULT)
					set_display("frame_default")
				if(UI_DISPLAY_USCM)
					set_display("frame_yellow")
				if(UI_DISPLAY_MERC)
					set_display("frame_green")
		if(MISSION_DISPLAY_SHIP)
			mode = MISSION_DISPLAY_SHIP
			remove_display()
			switch(ui)
				if(UI_DISPLAY_DEFAULT)
					set_display("display_ship_default")
				if(UI_DISPLAY_USCM)
					set_display("display_ship_yellow")
				if(UI_DISPLAY_MERC)
					set_display("display_ship_green")
			switch(SSmapping.configs[GROUND_MAP].map_name)
				if(MAP_BIG_RED)
					set_display("bigred")
					return
				if(MAP_SKY_SCRAPER)
					set_display("bigred")
					return
				if(MAP_ICE_COLONY)
					set_display("shiva")
					return
			set_display("lv624")
		if(MISSION_DISPLAY_CANNON)
			mode = MISSION_DISPLAY_CANNON
			remove_display()
			switch(ui)
				if(UI_DISPLAY_DEFAULT)
					set_display("display_cannon_default")
				if(UI_DISPLAY_USCM)
					set_display("display_cannon_yellow")
				if(UI_DISPLAY_MERC)
					set_display("display_cannon_green")
		if(MISSION_DISPLAY_SCAN)
			mode = MISSION_DISPLAY_SCAN
			remove_display()
			f = 0
			switch(ui)
				if(UI_DISPLAY_DEFAULT)
					set_display("display_scan_default")
				if(UI_DISPLAY_USCM)
					set_display("display_scan_yellow")
				if(UI_DISPLAY_MERC)
					set_display("display_scan_green")
			switch(SSmapping.configs[GROUND_MAP].map_name)
				if(MAP_BIG_RED)
					set_display("scanbigred")
					set_display("scan_arrow")
					return
				if(MAP_SKY_SCRAPER)
					set_display("bigred")
					return
				if(MAP_ICE_COLONY)
					set_display("scanshiva")
					set_display("scan_arrow")
					return
			set_display("scanlv624")
			set_display("scan_arrow")
		if(MISSION_DISPLAY_APC)
			mode = MISSION_DISPLAY_APC
			remove_display()
			switch(ui)
				if(UI_DISPLAY_DEFAULT)
					set_display("display_apc_default")
				if(UI_DISPLAY_USCM)
					set_display("display_apc_yellow")
				if(UI_DISPLAY_MERC)
					set_display("display_apc_green")

/obj/structure/machinery/mission_display/proc/set_display(name)
	overlays += image('icons/obj/structures/machinery/mission_display.dmi', name)

/obj/structure/machinery/mission_display/proc/remove_display()
	overlays.Cut()

/obj/structure/machinery/mission_display/proc/set_state(index, name, color)
	remove_state(index)
	state[index][STATE_IMAGE] = image('icons/obj/structures/machinery/mission_display.dmi', name)
	state[index][STATE_IMAGE].color = color
	state[index][STATE_IMAGE].pixel_x = state[index][X_COORDINATE]
	state[index][STATE_IMAGE].pixel_y = state[index][Y_COORDINATE]
	overlays += state[index][STATE_IMAGE]

/obj/structure/machinery/mission_display/proc/remove_state(index)
	overlays -= state[index][STATE_IMAGE]

/obj/structure/machinery/mission_display/proc/move_shuttle(index, number, time, totaltime)
	var/shuttle_location
	var/shuttle_locked
	if(number == SHIP_ALAMO)
		shuttle_location = FALSE //shuttle1.location
		shuttle_locked = shuttle1.is_hijacked
	else
		shuttle_location = FALSE //shuttle2.location
		shuttle_locked = shuttle2.is_hijacked
	remove_state(index)
	if(!shuttle_location)
		state[index][STATE_IMAGE] = image('icons/obj/structures/machinery/mission_display.dmi', planet2name(planet) + "_shuttle" + num2text(number) + "_down" )
		state[index][STATE_IMAGE].pixel_x = (SHIP_SHUTTLE_MOTHERSHIP_X - SHIP_SHUTTLE_PLANET_X)/100*time/10 + SHIP_SHUTTLE_PLANET_X //(Distance)/100*traveltime of shuttle divided by 10 to revert realtime mult and addition of target destination results in pixel location on the display for the shuttle movement
		state[index][STATE_IMAGE].pixel_y = (SHIP_SHUTTLE_MOTHERSHIP_Y - SHIP_SHUTTLE_PLANET_Y)/100*time/10 + SHIP_SHUTTLE_PLANET_Y
		overlays += state[index][STATE_IMAGE]
	else
		if(!shuttle_locked)
			state[index][STATE_IMAGE] = image('icons/obj/structures/machinery/mission_display.dmi', planet2name(planet) + "_shuttle" + num2text(number) + "_up")
			overlays -= state[index][STATE_IMAGE]
			state[index][STATE_IMAGE].pixel_x = SHIP_SHUTTLE_MOTHERSHIP_X - (SHIP_SHUTTLE_MOTHERSHIP_X - SHIP_SHUTTLE_PLANET_X)/100*time/10
			state[index][STATE_IMAGE].pixel_y = - (-SHIP_SHUTTLE_MOTHERSHIP_Y + (SHIP_SHUTTLE_MOTHERSHIP_Y - SHIP_SHUTTLE_PLANET_Y)/100*time/10)
			overlays += state[index][STATE_IMAGE]
		else
			state[index][STATE_IMAGE] = image('icons/obj/structures/machinery/mission_display.dmi', planet2name(planet) +  "_shuttle"+ num2text(number) + "_up")
			state[index][STATE_IMAGE].color = "red"
			overlays -= state[index][STATE_IMAGE]
			state[index][STATE_IMAGE].pixel_x = SHIP_SHUTTLE_MOTHERSHIP_X - (SHIP_SHUTTLE_MOTHERSHIP_X - SHIP_SHUTTLE_PLANET_X)/100*time/10
			state[index][STATE_IMAGE].pixel_y = - (-SHIP_SHUTTLE_MOTHERSHIP_Y + (SHIP_SHUTTLE_MOTHERSHIP_Y - SHIP_SHUTTLE_PLANET_Y)/100*time/10)
			overlays += state[index][STATE_IMAGE]

//CAS mission shows shuttle over planet and when half of the time is reached shuttle returns
/obj/structure/machinery/mission_display/proc/cas_mission(index, number, time, totaltime)
	var/shuttle_location
	if(number == SHIP_ALAMO)
		shuttle_location = FALSE //shuttle1.location
	else
		shuttle_location = FALSE //shuttle2.location
	if(!shuttle_location)
		remove_state(index)
		if(time > totaltime/2)
			state[index][STATE_IMAGE] = image('icons/obj/structures/machinery/mission_display.dmi', planet2name(planet) + "_shuttle"+ num2text(number) + "_down")
			if(number == SHIP_NORMANDY)
				state[index][STATE_IMAGE].pixel_x = (SHIP_SHUTTLE_MOTHERSHIP_X + 8 - SHIP_SHUTTLE_CAS_X)/100*time/10 + SHIP_SHUTTLE_CAS_X
			else
				state[index][STATE_IMAGE].pixel_x = (SHIP_SHUTTLE_MOTHERSHIP_X - SHIP_SHUTTLE_CAS_X)/100*time/10 + SHIP_SHUTTLE_CAS_X
			state[index][STATE_IMAGE].pixel_y = (SHIP_SHUTTLE_MOTHERSHIP_Y - SHIP_SHUTTLE_CAS_Y)/100*time/10 + SHIP_SHUTTLE_CAS_Y
			overlays += state[index][STATE_IMAGE]
		else
			state[index][STATE_IMAGE] = image('icons/obj/structures/machinery/mission_display.dmi', planet2name(planet) + "_shuttle"+ num2text(number) + "_up")
			if(number == SHIP_NORMANDY)
				state[index][STATE_IMAGE].pixel_x = SHIP_SHUTTLE_MOTHERSHIP_X + 8 - (SHIP_SHUTTLE_MOTHERSHIP_X + 8 - SHIP_SHUTTLE_CAS_X)/100*time/10
			else
				state[index][STATE_IMAGE].pixel_x = SHIP_SHUTTLE_MOTHERSHIP_X - (SHIP_SHUTTLE_MOTHERSHIP_X - SHIP_SHUTTLE_CAS_X)/100*time/10
			state[index][STATE_IMAGE].pixel_y = - (-SHIP_SHUTTLE_MOTHERSHIP_Y + (SHIP_SHUTTLE_MOTHERSHIP_Y - SHIP_SHUTTLE_CAS_Y)/100*time/10)
			overlays += state[index][STATE_IMAGE]

/obj/structure/machinery/mission_display/proc/set_text(index, text, color)
	remove_text(index)
	var/j = 0
	for(var/i = 1, i <= length(text), i++)
		state[index][STATE_IMAGE + i] = image('icons/obj/structures/machinery/mission_display.dmi', text[i])
		state[index][STATE_IMAGE + i].color = color
		state[index][STATE_IMAGE + i].pixel_x = state[index][X_COORDINATE] + j
		state[index][STATE_IMAGE + i].pixel_y = state[index][Y_COORDINATE]
		overlays += state[index][STATE_IMAGE + i]
		j += 4

/obj/structure/machinery/mission_display/proc/remove_text(index)
	for(var/i = 1, i <= 4, i++)
		if(state[index][STATE_IMAGE + i])
			overlays -= state[index][STATE_IMAGE + i]

/obj/structure/machinery/mission_display/process()
	switch(mode)
		if(MISSION_DISPLAY_SHIP)
/*
			if(shuttle1.automated_delay)
				set_state(STATE1, "auto")
			else
				remove_state(STATE1)
			if(shuttle2.automated_delay)
				set_state(STATE2, "auto")
			else
				remove_state(STATE2)
			switch(shuttle1.mode)
				if(SHUTTLE_IDLE)
					if(!shuttle1.location)
						set_state(STATE3, "holding_ship")
					else
						set_state(STATE3, "holding_planet")
				if(SHUTTLE_RECHARGING)
					set_state(STATE3, "recharging")
					if(!shuttle2.location)
						set_state(STATE4, "holding_ship")
					else
						set_state(STATE4, "holding_planet")
				if(SHUTTLE_IGNITING)
					set_state(STATE3, "spinning")
				if(SHUTTLE_RECHARGING)
					set_state(STATE3, "dropping")
					remove_state(STATE5)
				else
					//Transport
					if(shuttle1.mode == SHUTTLE_INTRANSIT && !shuttle1.in_flyby && !shuttle1.is_hijacked)
						set_state(STATE3, "transit")
						if(shuttle1.in_transit_time_left > 0)
							move_shuttle(STATE5, SHIP_ALAMO, shuttle1.in_transit_time_left, shuttle1.move_time)
					//CAS
					if(shuttle1.mode == SHUTTLE_INTRANSIT && shuttle1.in_flyby && !shuttle1.is_hijacked)
						set_state(STATE3, "cas")
						if(shuttle1.in_transit_time_left > 0)
							cas_mission(STATE5, SHIP_ALAMO, shuttle1.in_transit_time_left, shuttle1.move_time)
					if(shuttle1.mode == SHUTTLE_INTRANSIT && !shuttle1.in_flyby && shuttle1.is_hijacked)
						set_state(STATE3, "crash")
						if(shuttle1.in_transit_time_left > 0)
							move_shuttle(STATE5, SHIP_ALAMO, shuttle1.in_transit_time_left, shuttle1.move_time)
			switch(shuttle2.process_state)
				if(SHUTTLE_IDLE)
					if(!shuttle2.location)
						set_state(STATE4, "holding_ship")
					else
						set_state(STATE4, "holding_planet")
				if(SHUTTLE_RECHARGING)
					set_state(STATE3, "recharging")
					if(!shuttle2.location)
						set_state(STATE4, "holding_ship")
					else
						set_state(STATE4, "holding_planet")
				if(SHUTTLE_IGNITING)
					set_state(STATE4, "spinning")
				if(SHUTTLE_RECHARGING)
					remove_state(STATE6)
					set_state(STATE4, "dropping")
				else
					//Transport
					if(shuttle2.mode == SHUTTLE_INTRANSIT && shuttle2.in_flyby == 0 && !shuttle2.is_hijacked)
						set_state(STATE4, "transit")
						if(shuttle2.in_transit_time_left > 0)
							move_shuttle(STATE6, SHIP_NORMANDY, shuttle2.in_transit_time_left, shuttle1.move_time)
					//CAS
					if(shuttle2.mode == SHUTTLE_INTRANSIT && shuttle2.in_flyby == 1 && !shuttle2.is_hijacked)
						set_state(STATE4, "cas")
						if(shuttle2.in_transit_time_left > 0)
							cas_mission(STATE6, SHIP_NORMANDY, shuttle2.in_transit_time_left, shuttle2.move_time)
					if(shuttle2.mode == SHUTTLE_INTRANSIT && shuttle2.in_flyby == 0 && shuttle2.is_hijacked)
						set_state(STATE4, "crash")
						if(shuttle2.in_transit_time_left > 0)
							move_shuttle(STATE6, SHIP_NORMANDY, shuttle2.in_transit_time_left, shuttle1.move_time)
*/
		if(MISSION_DISPLAY_CANNON)
			set_state(STATE7, "reload")
			if(shuttle1.is_hijacked || shuttle2.is_hijacked)
				set_state(STATE7, "locked")
				return
			if(almayer_orbital_cannon.chambered_tray)
				set_state(STATE7, "loaded")
				if(almayer_orbital_cannon.tray.warhead.warhead_kind == "explosive")
					set_state(STATE8, "he")
				if(almayer_orbital_cannon.tray.warhead.warhead_kind == "incendiary")
					set_state(STATE8, "in")
				if(almayer_orbital_cannon.tray.warhead.warhead_kind == "cluster")
					set_state(STATE8, "cl")
			if(almayer_orbital_cannon.ob_firing_cooldown > 0)
				var/cooldown_left_cannon = almayer_orbital_cannon.ob_firing_cooldown
				var/cooldown_left_console = almayer_orbital_cannon.ob_firing_cooldown
				if(cooldown_left_cannon > 0)
					remove_state(STATE8)
					remove_state(STATE9)
					set_text(STATE9, num2text(round(cooldown_left_cannon/10)), rgb(0, 113, 240))
					return
				if(cooldown_left_console > 0)
					set_text(STATE9, num2text(round(cooldown_left_console/10)), rgb(255,255,0))
					return
				remove_text(STATE9)
		if(MISSION_DISPLAY_SCAN)
			if(f >= 4)
				f = 0
			living_count = 0
			selected_squad = get_squad_by_name(squad_list[f + 1])
			for(var/E in selected_squad.marines_list)
				if(!E)
					continue
				if(ishuman(E))
					var/mob/living/carbon/human/H = E
					if(!get_turf(H))
						continue
					if(is_mainship_level(H.z))
						continue
					if(H.stat == DEAD)
						continue
					living_count++
			spawn(20) // Without this ping will increase by 2-4 ms
				if(mode != MISSION_DISPLAY_SCAN) // Escape when mode is switched
					return
				var/color
				if(living_count < 5)
					color = rgb(135, 12, 12)
				else if(living_count >= 5 && living_count <= 10)
					color = rgb(255,165,0)
				else
					color = rgb(0, 255, 21)
				set_text(STATE10 + f, num2text(living_count), color)
				f++
				for(var/obj/structure/machinery/telecomms/relay/T in GLOB.machines)
					if(is_ground_level(T.loc.z) && T.operable() && T.on)
						set_state(STATE14, "comms")
						break
					set_state(STATE14, "no_comms")
		if(MISSION_DISPLAY_APC)
			set_state(STATE16, "none")
			for(var/obj/vehicle/multitile/V as anything in GLOB.all_multi_vehicles)
				if(!istype(V, /obj/vehicle/multitile/apc) && !istype(V, /obj/vehicle/multitile/tank))
					continue
				var/list/hps = V.get_hardpoints_copy()
				var/apc_state = STATE17
				var/health = round(100.0 * V.health / initial(V.health))
				if(health >= 90)
					set_text(STATE15, num2text(health) + "%", rgb(68, 255, 0))
				else if(health >= 75 && health < 90)
					set_text(STATE15, num2text(health) + "%", rgb(251, 255, 0))
				else if(health >= 50 && health < 75)
					set_text(STATE15, num2text(health) + "%", rgb(255, 210, 0))
				else if(health >= 10 && health < 50)
					set_text(STATE15, num2text(health) + "%", rgb(255, 136, 0))
				else
					set_text(STATE15, num2text(health) + "%", rgb(255, 0, 0))
				for(var/obj/item/hardpoint/H in hps)
					if(istype(H, /obj/item/hardpoint/special/firing_port_weapon))
						continue
					if(istype(H, /obj/item/hardpoint/primary))
						apc_state = STATE17
					if(istype(H, /obj/item/hardpoint/secondary))
						apc_state = STATE18
					if(istype(H, /obj/item/hardpoint/support))
						apc_state = STATE19
					if(istype(H, /obj/item/hardpoint/locomotion/apc_wheels))
						apc_state = STATE20
					health = round(100.0 * H.health / initial(H.health))
					if(health >= 90)
						set_text(apc_state, num2text(health) + "%", rgb(68, 255, 0))
					else if(health >= 75 && health < 90)
						set_text(apc_state, num2text(health) + "%", rgb(251, 255, 0))
					else if(health >= 50 && health < 75)
						set_text(apc_state, num2text(health) + "%", rgb(255, 210, 0))
					else if(health >= 10 && health < 50)
						set_text(apc_state, num2text(health) + "%", rgb(255, 136, 0))
					else
						set_text(apc_state, num2text(health) + "%", rgb(255, 0, 0))
				if(istype(V, /obj/vehicle/multitile/apc/medical))
					set_state(STATE16, "apc_medical")
					return
				if(istype(V, /obj/vehicle/multitile/apc/command))
					set_state(STATE16, "apc_command")
					return
				if(istype(V, /obj/vehicle/multitile/apc))
					set_state(STATE16, "apc_transport")
					return
				set_state(STATE16, "tank")

/obj/structure/machinery/mission_display/proc/populate()
	set waitfor = FALSE
	for(var/datum/squad/squad as anything in SSticker.role_authority.squads)
		squad_list += squad.name
	planet = SSmapping.configs[GROUND_MAP].map_name
	state[STATE1][X_COORDINATE] = SHIP_STATE1_X
	state[STATE1][Y_COORDINATE] = SHIP_STATE1_Y
	state[STATE2][X_COORDINATE] = SHIP_STATE2_X
	state[STATE2][Y_COORDINATE] = SHIP_STATE2_Y
	state[STATE3][X_COORDINATE] = SHIP_STATE3_X
	state[STATE3][Y_COORDINATE] = SHIP_STATE3_Y
	state[STATE4][X_COORDINATE] = SHIP_STATE4_X
	state[STATE4][Y_COORDINATE] = SHIP_STATE4_Y
	state[STATE5][X_COORDINATE] = SHIP_SHUTTLE_MOTHERSHIP_X
	state[STATE5][Y_COORDINATE] = SHIP_SHUTTLE_MOTHERSHIP_Y
	state[STATE6][X_COORDINATE] = SHIP_SHUTTLE_PLANET_X
	state[STATE6][Y_COORDINATE] = SHIP_SHUTTLE_PLANET_Y
	state[STATE7][X_COORDINATE] = CANNON_STATE1_X
	state[STATE7][Y_COORDINATE] = CANNON_STATE1_Y
	state[STATE8][X_COORDINATE] = CANNON_STATE2_X
	state[STATE8][Y_COORDINATE] = CANNON_STATE2_Y
	state[STATE9][X_COORDINATE] = CANNON_STATE3_X
	state[STATE9][Y_COORDINATE] = CANNON_STATE3_Y
	state[STATE10][X_COORDINATE] = SCAN_STATE1_X
	state[STATE10][Y_COORDINATE] = SCAN_STATE1_Y
	state[STATE11][X_COORDINATE] = SCAN_STATE2_X
	state[STATE11][Y_COORDINATE] = SCAN_STATE2_Y
	state[STATE12][X_COORDINATE] = SCAN_STATE3_X
	state[STATE12][Y_COORDINATE] = SCAN_STATE3_Y
	state[STATE13][X_COORDINATE] = SCAN_STATE4_X
	state[STATE13][Y_COORDINATE] = SCAN_STATE4_Y
	state[STATE14][X_COORDINATE] = SCAN_STATE5_X
	state[STATE14][Y_COORDINATE] = SCAN_STATE5_Y
	state[STATE15][X_COORDINATE] = APC_STATE1_X
	state[STATE15][Y_COORDINATE] = APC_STATE1_Y
	state[STATE16][X_COORDINATE] = APC_STATE2_X
	state[STATE16][Y_COORDINATE] = APC_STATE2_Y
	state[STATE17][X_COORDINATE] = APC_STATE3_X
	state[STATE17][Y_COORDINATE] = APC_STATE3_Y
	state[STATE18][X_COORDINATE] = APC_STATE4_X
	state[STATE18][Y_COORDINATE] = APC_STATE4_Y
	state[STATE19][X_COORDINATE] = APC_STATE5_X
	state[STATE19][Y_COORDINATE] = APC_STATE5_Y
	state[STATE20][X_COORDINATE] = APC_STATE6_X
	state[STATE20][Y_COORDINATE] = APC_STATE6_Y

	UNTIL(SSshuttle.initialized)
	shuttle1 = SSshuttle.getShuttle(DROPSHIP_ALAMO)
	shuttle2 = SSshuttle.getShuttle(DROPSHIP_NORMANDY)

/obj/structure/machinery/mission_display/proc/planet2name(name)
	switch(name)
		if("Solaris Ridge")
			return "bigred"
		if("Ice Colony")
			return "shiva"
		else
			return "lv624"

//Convert text back to definition
/obj/structure/machinery/mission_display/proc/mode2num(mode)
	switch(mode)
		if("Off")
			return MISSION_DISPLAY_OFF
		if("Ship")
			return MISSION_DISPLAY_SHIP
		if("Cannon")
			return MISSION_DISPLAY_CANNON
		if("Scan")
			return MISSION_DISPLAY_SCAN
		if("Apc")
			return MISSION_DISPLAY_APC
		if("Default")
			return UI_DISPLAY_DEFAULT
		if("Uscm")
			return UI_DISPLAY_USCM
		if("Merc")
			return UI_DISPLAY_MERC

*/
