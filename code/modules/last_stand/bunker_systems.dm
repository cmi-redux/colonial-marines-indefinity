GLOBAL_LIST_EMPTY(door_control_module)
GLOBAL_LIST_EMPTY(bunker_doors)
GLOBAL_LIST_EMPTY(bunker_poddors)
GLOBAL_LIST_EMPTY(bunker_vents_poddors)
GLOBAL_LIST_EMPTY(life_support)
GLOBAL_LIST_EMPTY(power)
GLOBAL_LIST_EMPTY(telecoms_bunker_tower)
GLOBAL_LIST_EMPTY(bunker_enter_doors)
GLOBAL_LIST_EMPTY(water_intake)

#define BUNKER_SYSTEM_WORKIGN			1
#define BUNKER_SYSTEM_UNPOWERED			2
#define BUNKER_SYSTEM_UNREACHABLE		3
#define BUNKER_SYSTEM_PROBLEMS			4
#define BUNKER_SYSTEM_MALF				5
#define BUNKER_SYSTEM_DESTROYED			6

#define STATE_BUNKER_DEFAULT 1
#define STATE_BUNKER_DOORS 2
#define STATE_BUNKER_BASE_DOORS 3
#define STATE_BUNKER_DEFENCE_DOORS 4
#define STATE_BUNKER_VENT_DOORS 5
#define STATE_BUNKER_MESSAGELIST 6
#define STATE_BUNKER_VIEWMESSAGE 7
#define STATE_BUNKER_DELMESSAGE 8

#define BUNKER_COOLDOWN_COMM_MESSAGE 30 SECONDS

#define BUNKER_COMMAND_SHIP_ANNOUNCE		"Command Bunker Announcement"

/obj/structure/machinery/computer/bunker_primary_control
	name = "Компьютер управления бункером"
	desc = "Позволяет управлять всеми системами бункера."
	icon_state = "comm_alt"
	req_access = list()
	unslashable = TRUE
	unacidable = TRUE

	var/state = STATE_BUNKER_DEFAULT

	var/control_system = BUNKER_SYSTEM_WORKIGN
	var/bunker_state = 100

	var/list/LS_MODULE = list()
	var/list/LS_MODULE_SECOND = list()
	var/ls_module_status
	var/turbine_1_status
	var/turbine_2_status
	var/turbine_1_health
	var/turbine_2_health
	var/power

	var/weapons

	var/doors
	var/list/DC_MODULE = list()
	var/door_mode = 0
	var/list/CD = list()
	var/list/CL = list()
	var/list/CVL = list()

	var/radio_station
	var/list/RS = list()

	var/is_announcement_active = TRUE

	var/cooldown_central = 0

	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0

/obj/structure/machinery/computer/bunker_primary_control/proc/detect_connections(forced = FALSE)
	if(forced)
		CD = list()
		CL = list()
		CVL = list()
		RS = list()

	for(var/obj/structure/machinery/door/airlock/bunker/D in GLOB.bunker_doors)
		if(D.door_state != BUNKER_SYSTEM_DESTROYED && D.door_state != BUNKER_SYSTEM_UNREACHABLE && (!D.connection || forced))
			D.connection += src
			CD += D

	for(var/obj/structure/machinery/door/poddoor/bunker/D in GLOB.bunker_poddors)
		if(D.door_state != BUNKER_SYSTEM_DESTROYED && D.door_state != BUNKER_SYSTEM_UNREACHABLE && (!D.connection|| forced))
			D.connection += src
			CL += D

	for(var/obj/structure/machinery/door/poddoor/bunker/vents/D in GLOB.bunker_vents_poddors)
		if(D.door_state != BUNKER_SYSTEM_DESTROYED && D.door_state != BUNKER_SYSTEM_UNREACHABLE && (!D.connection || forced))
			D.connection += src
			CVL += D

	for(var/obj/structure/machinery/telecomms/relay/preset/tower/bunker/T in GLOB.telecoms_bunker_tower)
		if(T.tower_state != BUNKER_SYSTEM_DESTROYED && T.tower_state != BUNKER_SYSTEM_UNREACHABLE && (!T.connection || forced))
			T.connection += src
			RS += T

	for(var/obj/structure/prop/bunker/turbine/M in GLOB.life_support)
		if(M.module_state != BUNKER_SYSTEM_DESTROYED && M.module_state != BUNKER_SYSTEM_UNREACHABLE && (!M.connection || forced))
			M.connection += src
			LS_MODULE_SECOND += M

	for(var/obj/structure/prop/bunker/turbine/M in GLOB.life_support)
		if(M.module_state != BUNKER_SYSTEM_DESTROYED && M.module_state != BUNKER_SYSTEM_UNREACHABLE && (!M.connection || forced))
			M.connection += src
			LS_MODULE += M

	for(var/obj/structure/prop/bunker/turbine/M in GLOB.life_support)
		if(M.module_state != BUNKER_SYSTEM_DESTROYED && M.module_state != BUNKER_SYSTEM_UNREACHABLE && (!M.connection || forced))
			M.connection += src
			LS_MODULE += M

/obj/structure/machinery/computer/bunker_primary_control/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/computer/bunker_primary_control/LateInitialize()
	. = ..()
	detect_connections()
	start_processing()

/obj/structure/machinery/computer/bunker_primary_control/process()
//	for(i in DC_MODULE)
//		var/HERE/M = i
//		doors = M.dc_tate

	for(var/i in LS_MODULE_SECOND)
		var/obj/structure/prop/bunker/turbine/M = i
		if(M.id == 1)
			turbine_1_status = M.module_state
			turbine_1_health = M.health
		else if(M.id == 2)
			turbine_2_status = M.module_state
			turbine_2_health = M.health

	for(var/i in LS_MODULE)
		var/obj/structure/prop/bunker/turbine/M = i
		ls_module_status = M.module_state

	for(var/i in RS)
		var/obj/structure/machinery/telecomms/relay/preset/tower/bunker/T = i
		radio_station = T.tower_state

/obj/structure/machinery/computer/bunker_primary_control/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/bunker_primary_control/attack_hand(mob/user as mob)
	if(..() || !allowed(user) || inoperable())
		return

	ui_interact(user)

/obj/structure/machinery/computer/bunker_primary_control/ui_interact(mob/user as mob)
	user.set_interaction(src)

	var/dat = "<head><title>Управление системами бункера</title></head><body>"

	switch(state)
		if(STATE_BUNKER_DEFAULT)
			dat += "Состояние бункера [bunker_state]%<BR>"
			dat += "<BR><A HREF='?src=\ref[src];operation=ship_announce'>[is_announcement_active ? "Сделать Корабельное Оповещение" : "*Недоступно*"]</A>"
			dat += RS ? "<BR><A HREF='?src=\ref[src];operation=messageUSCM'>Отправить Сообщение Высшему Командыванию USCM</A>" : "<BR>USCM коммуникации выключены"
			dat += "<BR><A HREF='?src=\ref[src];operation=award'>Выдать Награду</A>"
			dat += "<BR><A HREF='?src=\ref[src];operation=messagelist'>Сообщения</A>"

			dat += "<BR><hr>"
			dat += "<BR><A HREF='?src=\ref[src];operation=doors'>Управление дверьми</A>"
			dat += "<BR>Статус модуля вентеляции:"
			switch(ls_module_status)
				if(BUNKER_SYSTEM_WORKIGN)
					dat += "Работает"
				if(BUNKER_SYSTEM_UNPOWERED)
					dat += "Нет питания"
				if(BUNKER_SYSTEM_UNREACHABLE)
					dat += "Невозможно связаться"
				if(BUNKER_SYSTEM_PROBLEMS)
					dat += "Технические проблемы"
				if(BUNKER_SYSTEM_MALF)
					dat += "Критическая ошибка системы"
				if(BUNKER_SYSTEM_DESTROYED)
					dat += "Модуль УНИЧТОЖЕН"
			dat += "<BR>Статус турбин:"
			dat += "<BR>Первая:"
			dat += "[turbine_1_health]%"
			switch(turbine_1_status)
				if(BUNKER_SYSTEM_WORKIGN)
					dat += "Работает"
				if(BUNKER_SYSTEM_UNPOWERED)
					dat += "Нет питания"
				if(BUNKER_SYSTEM_UNREACHABLE)
					dat += "Невозможно связаться"
				if(BUNKER_SYSTEM_PROBLEMS)
					dat += "Технические проблемы"
				if(BUNKER_SYSTEM_MALF)
					dat += "Критическая ошибка системы"
				if(BUNKER_SYSTEM_DESTROYED)
					dat += "Турбина УНИЧТОЖЕНА"
			dat += "<BR>Вторая:"
			dat += "Состояние: [turbine_2_health]%"
			switch(turbine_2_status)
				if(BUNKER_SYSTEM_WORKIGN)
					dat += "Работает"
				if(BUNKER_SYSTEM_UNPOWERED)
					dat += "Нет питания"
				if(BUNKER_SYSTEM_UNREACHABLE)
					dat += "Невозможно связаться"
				if(BUNKER_SYSTEM_PROBLEMS)
					dat += "Технические проблемы"
				if(BUNKER_SYSTEM_MALF)
					dat += "Критическая ошибка системы"
				if(BUNKER_SYSTEM_DESTROYED)
					dat += "Турбина УНИЧТОЖЕНА"

		if(STATE_BUNKER_DOORS)
			dat += "Состояние модуля дверей:"
			switch(doors)
				if(BUNKER_SYSTEM_WORKIGN)
					dat += "Работает"
				if(BUNKER_SYSTEM_UNPOWERED)
					dat += "Нет питания"
				if(BUNKER_SYSTEM_UNREACHABLE)
					dat += "Невозможно связаться"
				if(BUNKER_SYSTEM_PROBLEMS)
					dat += "Технические проблемы"
				if(BUNKER_SYSTEM_MALF)
					dat += "Критическая ошибка системы"
				if(BUNKER_SYSTEM_DESTROYED)
					dat += "Модуль УНИЧТОЖЕН"
			if(doors == BUNKER_SYSTEM_WORKIGN)
				dat += "<BR><A HREF='?src=\ref[src];operation=base_doors'>Управление дверями бункера</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=lockdown_doors'>Управление защитными экранами бункера</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=vent_doors'>Управление защитными экранами вентеляции бункера</A>"

		if(STATE_BUNKER_BASE_DOORS)
			dat += "Управление дверьми бункера:"
			if(door_mode)
				dat += "<BR><A HREF='?src=\ref[src];operation=emergency_doors_mode'>Выключить аварийный режим</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=od'>Принудительно открыть двери</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=cd'>Принудительно закрыть двери</A>"
			else
				dat += "<BR><A HREF='?src=\ref[src];operation=emergency_doors_mode'>Включить аварийный режим</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=od'>Открыть двери</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=cd'>Закрыть двери</A>"

		if(STATE_BUNKER_DEFENCE_DOORS)
			dat += "Управление защитными экранами бункера:"
			dat += "<BR><A HREF='?src=\ref[src];operation=close_lockdown'>Опустить защитные экраны</A>"
			dat += "<BR><A HREF='?src=\ref[src];operation=open_lockdown'>Поднять защитные экраны</A>"

		if(STATE_BUNKER_VENT_DOORS)
			dat += "Управление защитными экранами вентеляции бункера:"
			dat += "<BR><A HREF='?src=\ref[src];operation=close_lockdown_vent'>Опустить защитные экраны</A>"
			dat += "<BR><A HREF='?src=\ref[src];operation=open_lockdown_vent'>Поднять защитные экраны</A>"

		if(STATE_BUNKER_MESSAGELIST)
			dat += "Сообщения:"
			for(var/i = 1; i<=messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=viewmessage;message-num=[i]'>[messagetitle[i]]</A>"

		if(STATE_BUNKER_VIEWMESSAGE)
			if(currmsg)
				dat += "<B>[messagetitle[currmsg]]</B><BR><BR>[messagetext[currmsg]]"
				dat += "<BR><BR><A HREF='?src=\ref[src];operation=delmessage'>Удалить"
			else
				state = STATE_BUNKER_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_BUNKER_DELMESSAGE)
			if(currmsg)
				dat += "Вы уверены, что хотите это сделать? <A HREF='?src=\ref[src];operation=delmessage2'>ОК</A>|<A HREF='?src=\ref[src];operation=viewmessage'>Отменить</A>"
			else
				state = STATE_BUNKER_MESSAGELIST
				attack_hand(user)
				return FALSE

	dat += "<BR>[(state != STATE_BUNKER_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Главное Меню</A>|" : ""]<A HREF='?src=\ref[user];mach_close=bunker_control'>Закрыть</A>"

	show_browser(user, dat, name, "bunker_control")
	onclose(user, "bunker_control")

/obj/structure/machinery/computer/bunker_primary_control/Topic(href, href_list)
	if(..())
		return FALSE

	usr.set_interaction(src)

	switch(href_list["operation"])
		if("main")
			state = STATE_BUNKER_DEFAULT

		if("ship_announce")
			if(!is_announcement_active)
				to_chat(usr, SPAN_WARNING("Пожалуйста подождите [COOLDOWN_COMM_MESSAGE*0.1] секунд."))
				return FALSE
			var/input = stripped_multiline_input(usr, "Пожалуйста введите сообщение.", "Приоритетное Оповещение", "")
			if(!input || !is_announcement_active || !(usr in view(1,src)))
				return FALSE

			is_announcement_active = FALSE

			var/signed = null
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/id = H.wear_id
				if(istype(id))
					var/paygrade = get_paygrades(id.paygrade, FALSE, H.gender)
					signed = "[paygrade] [id.registered_name]"

			shipwide_ai_announcement(input, COMMAND_SHIP_ANNOUNCE, signature = signed)
			addtimer(CALLBACK(src, PROC_REF(reactivate_announcement), usr), COOLDOWN_COMM_MESSAGE)
			message_admins("[key_name(usr)] создал бункерное оповещение.")
			log_announcement("[key_name(usr)] создал бункерное оповещение: [input]")

		if("doors")
			state = STATE_BUNKER_DOORS

		if("base_doors")
			state = STATE_BUNKER_BASE_DOORS

		if("emergency_doors_mode")
			door_mode = !door_mode
			if(door_mode)
				for(var/i in CD)
					var/obj/structure/machinery/door/airlock/bunker/D = i
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/bunker, lock))
			else
				for(var/i in CD)
					var/obj/structure/machinery/door/airlock/bunker/D = i
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/bunker, unlock))

		if("od")
			if(door_mode)
				for(var/i in CD)
					var/obj/structure/machinery/door/airlock/bunker/D = i
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/bunker, force_open))
			else
				for(var/i in CD)
					var/obj/structure/machinery/door/airlock/bunker/D = i
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/bunker, open))

		if("cd")
			if(door_mode)
				for(var/i in CD)
					var/obj/structure/machinery/door/airlock/bunker/D = i
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/bunker, force_close))
			else
				for(var/i in CD)
					var/obj/structure/machinery/door/airlock/bunker/D = i
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/bunker, close))

		if("lockdown_doors")
			state = STATE_BUNKER_DEFENCE_DOORS

		if("close_lockdown")
			for(var/i in CL)
				var/obj/structure/machinery/door/poddoor/bunker/D = i
				INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door, close))

		if("open_lockdown")
			for(var/i in CL)
				var/obj/structure/machinery/door/poddoor/bunker/D = i
				INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door, open))

		if("vent_doors")
			state = STATE_BUNKER_VENT_DOORS

		if("close_lockdown_vent")
			for(var/i in CVL)
				var/obj/structure/machinery/door/poddoor/bunker/D = i
				INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door, close))

		if("open_lockdown_vent")
			for(var/i in CVL)
				var/obj/structure/machinery/door/poddoor/bunker/D = i
				INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door, open))

		if("messagelist")
			currmsg = 0
			state = STATE_BUNKER_MESSAGELIST

		if("viewmessage")
			state = STATE_BUNKER_VIEWMESSAGE
			if(!currmsg)
				if(href_list["message-num"])
					currmsg = text2num(href_list["message-num"])
				else
					state = STATE_BUNKER_MESSAGELIST

		if("delmessage")
			state = (currmsg) ? STATE_BUNKER_DELMESSAGE : STATE_BUNKER_MESSAGELIST

		if("delmessage2")
			if(currmsg)
				var/title = messagetitle[currmsg]
				var/text  = messagetext[currmsg]
				messagetitle.Remove(title)
				messagetext.Remove(text)
				if(currmsg == aicurrmsg) aicurrmsg = 0
				currmsg = 0
			state = STATE_BUNKER_MESSAGELIST

		if("messageUSCM")
			if(world.time < cooldown_central + BUNKER_COOLDOWN_COMM_MESSAGE)
				to_chat(usr, SPAN_WARNING("Обработка массивов.  Пожалуйста ожидайте."))
				return FALSE
			var/input = stripped_input(usr, "Пожалуйста, выберите сообщение для передачи в USCM.  Пожалуйста, имейте в виду, что этот процесс очень дорогостоящий, и злоупотребление им приведет к прекращению работы.  Передача сообщения не гарантирует ответа. Существует небольшая задержка, прежде чем вы сможете отправить другое сообщение. Будьте ясны и лаконичны.", "Чтобы прервать процесс, отправьте пустое сообщение.", "")
			if(!input || !(usr in view(1,src)) || world.time < cooldown_central + BUNKER_COOLDOWN_COMM_MESSAGE) return FALSE

			high_command_announce(input, usr)
			to_chat(usr, SPAN_NOTICE("Сообщение передано."))
			log_announcement("[key_name(usr)] сделал USCM оповещение: [input]")
			cooldown_central = world.time

		if("award")
			if(usr.job != "Commanding Officer")
				to_chat(usr, SPAN_WARNING("Только Commanding Officer может награждать медалями."))
				return
			if(give_medal_award(loc))
				visible_message(SPAN_NOTICE("[src] печатает медаль."))


	updateUsrDialog()

/obj/structure/machinery/computer/bunker_primary_control/proc/reactivate_announcement(mob/user)
	is_announcement_active = TRUE
	updateUsrDialog()



//BUNKER LOCKDOWN

/obj/structure/machinery/door/poddoor/bunker
	icon = 'icons/obj/structures/doors/blastdoors_shutters.dmi'
	icon_state = "almayer_pdoor"
	name = "Heavy LockDown Doors"
	desc = "Used to keep shelter safe"
	openspeed = 3.5 //shorter open animation.
	tiles_with = list(
		/obj/structure/window/framed/bunker,
		/obj/structure/machinery/door/airlock)
	unslashable = TRUE
	unacidable = TRUE

	var/door_state = BUNKER_SYSTEM_WORKIGN
	var/list/connection = list()

/obj/structure/machinery/door/poddoor/bunker/open
	density = FALSE

/obj/structure/machinery/door/poddoor/bunker/Initialize()
	. = ..()
	GLOB.bunker_poddors += src
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, relativewall_neighbours)), 10)

/obj/structure/machinery/door/poddoor/bunker/locked
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/bunker/locked/attackby(obj/item/C as obj, mob/user as mob)
	if(HAS_TRAIT(C, TRAIT_TOOL_CROWBAR))
		return
	..()

/obj/structure/machinery/door/poddoor/bunker/closed
	density = TRUE
	opacity = TRUE


//BUNKER VENTS

/obj/structure/machinery/door/poddoor/bunker/vents
	name = "Vents LockDown"
	desc = "Used to blok bunker vents"
	openspeed = 1.5 //longer open animation.
	density = FALSE
	unacidable = FALSE

/obj/structure/machinery/door/poddoor/bunker/Initialize()
	. = ..()
	GLOB.bunker_vents_poddors += src
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, relativewall_neighbours)), 10)


//BUNKER AIRLOCKS

/obj/structure/machinery/door/airlock/bunker
	name = "Door"
	icon = 'icons/obj/structures/doors/comdoor.dmi' //Tiles with is here FOR SAFETY PURPOSES
	openspeed = 3.5 //shorter open animation.
	tiles_with = list(
		/obj/structure/window/framed/bunker,
		/obj/structure/machinery/door/airlock)
	unslashable = TRUE
	unacidable = TRUE

	var/door_state = BUNKER_SYSTEM_WORKIGN
	var/list/connection = list()

/obj/structure/machinery/door/airlock/bunker/Initialize()
	. = ..()
	GLOB.bunker_doors += src
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/airlock/bunker/LateInitialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/airlock/bunker/take_damage(dam, mob/M)
	var/damage_check = max(0, damage + dam)
	if(damage_check >= damage_cap && M && is_mainship_level(z))
		SSclues.create_print(get_turf(M), M, "The fingerprint contains bits of wire and metal specks.")

	..()

/obj/structure/machinery/door/airlock/bunker/proc/force_open()
	if(!density)
		return
	unlock()
	open()
	lock()

/obj/structure/machinery/door/airlock/bunker/proc/force_close()
	if(density)
		return
	unlock()
	close()
	lock()

/obj/structure/machinery/door/airlock/bunker/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/bunker/primary
	name = "Bunker Door"
	icon = 'icons/obj/structures/doors/securedoor.dmi'
	req_access = list()

/obj/structure/machinery/door/airlock/bunker/primary/autoname
	autoname = TRUE


//BUNKER MULTI TILE PRIMARY ENTER DOOR

/obj/structure/machinery/door/airlock/multi_tile/bunker_door
	name = "Bunker Entery Door"
	icon = 'icons/obj/structures/doors/4x1_elevator.dmi'
	icon_state = "door_closed"
	width = 4
	openspeed = 20
	id_tag = 0

/obj/structure/machinery/door/airlock/multi_tile/bunker_door/Initialize()
	. = ..()
	GLOB.bunker_enter_doors += src


//BUNKER BUTTON
/obj/structure/machinery/door_control/brbutton/bunker
	icon_state = "big_red_button_tablev"
	normaldoorcontrol = CONTROL_NORMAL_DOORS
	id = 0

/obj/structure/machinery/door_control/brbutton/bunker/handle_door()
	for(var/obj/structure/machinery/door/airlock/multi_tile/bunker_door/D in GLOB.bunker_enter_doors)
		if(D.id == src.id)
			if(specialfunctions & OPEN)
				if(D.density)
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/bunker_door, force_open))
				else
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/bunker_door, force_close))
			if(desiredstate == 1)
				if(specialfunctions & IDSCAN)
					D.remoteDisabledIdScanner = 1
				if(specialfunctions & BOLTS)
					D.lock()
				if(specialfunctions & SHOCK)
					D.secondsElectrified = -1
				if(specialfunctions & SAFE)
					D.safe = 0
			else
				if(specialfunctions & IDSCAN)
					D.remoteDisabledIdScanner = 0
				if(specialfunctions & BOLTS)
					if(!D.isWireCut(4) && D.arePowerSystemsOn())
						D.unlock()
				if(specialfunctions & SHOCK)
					D.secondsElectrified = 0
				if(specialfunctions & SAFE)
					D.safe = 1


//BUNKER ANTENA

/obj/structure/machinery/telecomms/relay/preset/tower/bunker
	name = "TC-5T EXPEREMENTAL telecommunications tower"
	icon = 'icons/obj/structures/machinery/comm_tower2.dmi'
	icon_state = "comm_tower"
	desc = "A compact TC-5T telecommunications tower. Used to set up subspace communications lines between planetary and extra-planetary locations. Red mark on side: UPGRADED FOR EXPEREMENTAL DEEP SPACE COMMUNICATIONS"
	id = "Station Relay"
	listening_level = TELECOMM_GROUND_Z
	autolinkers = list("s_relay")
	layer = ABOVE_FLY_LAYER
	use_power = 0
	idle_power_usage = 0
	unslashable = FALSE
	unacidable = TRUE
	health = 450
	tcomms_machine = TRUE
	sensor_radius = 80
	faction_to_get = FACTION_MARINE

	var/tower_state = BUNKER_SYSTEM_WORKIGN
	var/list/connection = list()

/obj/structure/machinery/telecomms/relay/preset/tower/bunker/Initialize()
	. = ..()
	GLOB.telecoms_bunker_tower += src


// doesn't need power, instead uses health
/obj/structure/machinery/telecomms/relay/preset/tower/bunker/inoperable(additional_flags)
	if(stat & (additional_flags|BROKEN))
		return TRUE
	if(health <= 0)
		return TRUE
	return FALSE

/obj/structure/machinery/telecomms/relay/preset/tower/bunker/tcomms_startup()
	. = ..()
	if(on)
		playsound(src, 'sound/machines/tcomms_on.ogg', vol = 80, vary = FALSE, sound_range = 16, falloff = 0.5)
		msg_admin_niche("Portable communication relay started for Z-Level [src.z] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
		GLOB.towers += src
		tower_state = BUNKER_SYSTEM_WORKIGN

/obj/structure/machinery/telecomms/relay/preset/tower/bunker/tcomms_shutdown()
	. = ..()
	if(!on)
		msg_admin_niche("Portable communication relay shut down for Z-Level [src.z] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
		tower_state = BUNKER_SYSTEM_UNPOWERED

/obj/structure/machinery/telecomms/relay/preset/tower/bunker/update_health(damage = 0)
	if(!damage)
		return
	if(damage > 0 && health <= 0)
		return // Leave the poor thing alone

	health -= damage
	health = Clamp(health, 0, initial(health))

	if(health <= 0)
		tower_state = BUNKER_SYSTEM_PROBLEMS
		toggled = FALSE		// requires flipping on again once repaired
	if(health < initial(health))
		desc = "[initial(desc)] [SPAN_WARNING(" It is damaged and needs a welder for repairs!")]"
	else
		desc = initial(desc)
	update_state()

/obj/structure/machinery/telecomms/relay/preset/tower/bunker/toggle_state(mob/user)
	if(!toggled && (inoperable() || (health <= initial(health) / 2)))
		to_chat(user, SPAN_WARNING("The [src.name] needs repairs to be turned back on!"))
		return
	tower_state = BUNKER_SYSTEM_WORKIGN
	..()


//BUNKER VENT TURBINE

/obj/structure/prop/bunker/turbine //maybe turn this into an actual power generation device? Would be cool!
	name = "Vents Turbine"
	icon = 'icons/obj/structures/props/biomass_turbine.dmi'
	icon_state = "biomass_turbine"
	desc = "A gigantic turbine that pump fresh air to bunker."
	density = 1
	breakable = TRUE
	indestructible = TRUE
	unslashable = FALSE
	unacidable = TRUE
	var/on = FALSE
	bound_width = 32
	bound_height = 96

	health = 1000
	var/destoyed = 0

	var/id = 0
	var/module_state = BUNKER_SYSTEM_UNPOWERED
	var/list/connection = list()

/obj/structure/prop/bunker/turbine/attackby(obj/item/W, mob/user)
	. = ..()
	if(isxeno(user))
		update_damage(user)
		return

	else if(ishuman(user) && istype(W, /obj/item/tool/crowbar))
		on = !on
		visible_message("You pry at the control valve on [src]. The machine shudders." , "[user] pries at the control valve on [src]. The entire machine shudders.")
		Update()

	else if(ishuman(user) && istype(W, /obj/item/tool/weldingtool) && !destoyed && !on)
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(3, user))
			update_damage(-50)
			to_chat(user, SPAN_NOTICE("Вы чините [src]."))
		return

/obj/structure/prop/bunker/turbine/proc/Update()
	icon_state = "biomass_turbine[on ? "-on" : ""]"
	if(on)
		density = 0
		module_state = BUNKER_SYSTEM_WORKIGN
		set_light_on(TRUE)
		playsound(src, 'sound/machines/turbine_on.ogg')
	else
		density = 1
		module_state = BUNKER_SYSTEM_UNPOWERED
		set_light_on(FALSE)
		playsound(src, 'sound/machines/turbine_off.ogg')
	return

/obj/structure/prop/bunker/turbine/proc/update_damage(damage)
	if(destoyed)
		return
	if(!damage)
		return
	if(damage > 0 && health <= 0)
		return // Leave the poor thing alone
	health -= damage
	health = Clamp(health, 0, initial(health))
	if(health == 0)
		if(on)
			Update()
		icon_state = "biomass_turbine" //DESTROYED STATE NEED MAKE
		module_state = BUNKER_SYSTEM_PROBLEMS
		destoyed = 1
		desc = "A gigantic turbine that pump fresh air to bunker. But destroyed"

/obj/structure/prop/bunker/turbine/ex_act(severity, direction)
	return

/obj/structure/prop/bunker/turbine/Initialize()
	. = ..()
	GLOB.life_support += src


// COOLING SYSTEM
/obj/structure/prop/bunker/water_system
	icon = 'icons/obj/structures/props/96x96.dmi'
	density = 1
	anchored = 1
	bound_width = 96
	bound_height = 96

/obj/structure/filtration/machine_96x96/indestructible
	unacidable = FALSE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/prop/bunker/turbine/Initialize()
	. = ..()
	GLOB.water_intake += src


/*LANDMARK SPAWNS*/

//Yes, I know that for landmarks you only need the name for it to work. This is for ease of access when spawning in the landmarks for events.
/obj/effect/landmark/battle_field
	icon_state = "x3"
	invisibility = 0
	var/additional_info = "base"
	var/sector = 0

/obj/effect/landmark/battle_field/enemy_spawn
	name = "enemy_spawn_pos"
	icon_state = "o_red"
	additional_info = "test"
	sector = 0

/obj/effect/landmark/battle_field/event_spawn
	name = "event_spawn_pos"
	icon_state = "x"
	additional_info = "primary_mission"
	sector = 0

/obj/effect/landmark/battle_field/event_spawn/supply
	name = "event_spawn_pos"
	icon_state = "o_green"
	additional_info = "supply"

/obj/effect/landmark/battle_field/event_spawn/objective
	name = "event_spawn_pos"
	icon_state = "o_yellow"
	additional_info = "objective"

/obj/effect/landmark/battle_field/event_spawn/target
	name = "event_spawn_pos"
	icon_state = "o_blue"
	additional_info = "target"

//shovel_big_brain_trenches
/obj/item/tool/shovel/etool/trench
	name = "Trench Shovel"
	desc = "A large tool for digging and moving dirt."
	icon_state = "shovel"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 8
	throwforce = 4
	w_class = SIZE_MEDIUM
	matter = list("metal" = 50)
	shovelspeed = 300
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")

/obj/item/tool/shovel/etool/trench/afterattack(atom/target, mob/user, proximity)
	if(!proximity || folded || !isturf(target))
		return

	if(user.action_busy)
		return

	var/turf/T = target
	if(T.turf_flags & TURF_TRENCHING && !(T.turf_flags & TURF_TRENCH))
		to_chat(user, SPAN_NOTICE("You start digging trench."))
		playsound(user.loc, 'sound/effects/thud.ogg', 40, 1, 6)
		if(!do_after(user, shovelspeed * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("You stop digging."))
			return
		T.ChangeTurf(/turf/open/trench)
		to_chat(user, SPAN_NOTICE("You dig trench."))
	else
		to_chat(user, SPAN_NOTICE("This is place bad for trench."))


#undef STATE_BUNKER_DEFAULT
#undef STATE_BUNKER_DOORS
#undef STATE_BUNKER_BASE_DOORS
#undef STATE_BUNKER_DEFENCE_DOORS
#undef STATE_BUNKER_VENT_DOORS
#undef STATE_BUNKER_MESSAGELIST
#undef STATE_BUNKER_VIEWMESSAGE
#undef STATE_BUNKER_DELMESSAGE

#undef BUNKER_SYSTEM_WORKIGN
#undef BUNKER_SYSTEM_UNPOWERED
#undef BUNKER_SYSTEM_UNREACHABLE
#undef BUNKER_SYSTEM_PROBLEMS
#undef BUNKER_SYSTEM_MALF
#undef BUNKER_SYSTEM_DESTROYED
