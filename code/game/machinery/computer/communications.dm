#define STATE_DEFAULT 1
#define STATE_EVACUATION 2
#define STATE_EVACUATION_CANCEL 3
#define STATE_DISTRESS 4
#define STATE_MESSAGELIST 5
#define STATE_VIEWMESSAGE 6
#define STATE_DELMESSAGE 7
#define STATE_STATUSDISPLAY 8
#define STATE_ALERT_LEVEL 9
#define STATE_CONFIRM_LEVEL 10
#define STATE_DESTROY 11
#define STATE_DEFCONLIST 12

//Note: Commented out procs are things I left alone and did not revise. Usually AI-related interactions.

// The communications computer
/obj/structure/machinery/computer/communications
	name = "Консоль Коммуникаций"
	desc = "Может использоваться для разных предназначений."
	icon_state = "comm"
	req_access = list(ACCESS_MARINE_COMMAND)
	circuit = /obj/item/circuitboard/computer/communications
	unslashable = TRUE
	unacidable = TRUE

	var/prints_intercept = 1
	var/authenticated = 0
	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0
	var/state = STATE_DEFAULT
	var/aistate = STATE_DEFAULT

	var/cooldown_message = 0 //Based on world.time.

	var/cooldown_request = 0
	var/cooldown_destruct = 0
	var/cooldown_central = 0
	var/tmp_alertlevel = 0

	var/status_display_freq = "1435"
	var/stat_msg1
	var/stat_msg2

	processing = TRUE

	faction_to_get = FACTION_MARINE

	var/minimap_name = "Marine Tactical Map"
	var/current_mapviewer
	var/list/datum/ui_minimap/minimap = list()

/obj/structure/machinery/computer/communications/Initialize()
	. = ..()
	start_processing()
	link_minimap()

/obj/structure/machinery/computer/communications/proc/link_minimap()
	set waitfor = FALSE
	WAIT_MAPVIEW_READY
	for(var/i in ALL_MAPVIEW_MAPTYPES)
		var/datum/ui_minimap/new_minimap = SSmapview.get_minimap_ui(faction, i, minimap_name)
		minimap += list("[i]" = new_minimap)

/obj/structure/machinery/computer/communications/process()
	if(..() && state != STATE_STATUSDISPLAY)
		updateDialog()

/obj/structure/machinery/computer/communications/proc/mapview(map_to_view)
	if(!Adjacent(current_mapviewer))
		return
	var/datum/ui_minimap/chosed = minimap["[map_to_view]"]
	chosed.tgui_interact(current_mapviewer)

/obj/structure/machinery/computer/communications/Topic(href, href_list)
	if(..()) return FALSE

	if(!Adjacent(usr))
		return FALSE

	usr.set_interaction(src)
	var/datum/ares_link/link = GLOB.ares_link
	switch(href_list["operation"])
		if("mapview_ground")
			current_mapviewer = usr
			mapview("[GROUND_MAP_Z]")
			return

		if("mapview_ship")
			current_mapviewer = usr
			mapview("[SHIP_MAP_Z]")

		if("main")
			state = STATE_DEFAULT

		if("login")
			if(isRemoteControlling(usr))
				return
			var/mob/living/carbon/human/C = usr
			var/obj/item/card/id/I = C.get_active_hand()
			if(istype(I))
				if(check_access(I)) authenticated = 1
				if(ACCESS_MARINE_SENIOR in I.access)
					authenticated = 2
			else
				I = C.wear_id
				if(istype(I))
					if(check_access(I)) authenticated = 1
					if(ACCESS_MARINE_SENIOR in I.access)
						authenticated = 2
		if("logout")
			authenticated = 0

		if("swipeidseclevel")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_active_hand()
			if(istype(I))
				if((ACCESS_MARINE_SENIOR in I.access) || (ACCESS_MARINE_COMMAND in I.access)) //Let heads change the alert level.
					switch(tmp_alertlevel)
						if(-INFINITY to SEC_LEVEL_GREEN) tmp_alertlevel = SEC_LEVEL_GREEN //Cannot go below green.
						if(SEC_LEVEL_BLUE to INFINITY) tmp_alertlevel = SEC_LEVEL_BLUE //Cannot go above blue.

					var/old_level = security_level
					set_security_level(tmp_alertlevel)
					if(security_level != old_level)
						//Only notify the admins if an actual change happened
						log_game("[key_name(usr)] сменил уровень тревоги на [get_security_level()].")
						message_admins("[key_name_admin(usr)] сменил уровень тревоги на [get_security_level()].")
				else
					to_chat(usr, SPAN_WARNING("Вы не имеете доступа для этой операции."))
				tmp_alertlevel = SEC_LEVEL_GREEN //Reset to green.
				state = STATE_DEFAULT
			else
				to_chat(usr, SPAN_WARNING("Вам надо приложить свою ID."))

		if("announce")
			if(authenticated == 2)
				if(usr.client.prefs.muted & MUTE_IC)
					to_chat(usr, SPAN_DANGER("You cannot send Announcements (muted)."))
					return

				if(world.time < cooldown_message + COOLDOWN_COMM_MESSAGE_LONG)
					to_chat(usr, SPAN_WARNING("Пожалуйста подождите [COOLDOWN_COMM_MESSAGE*0.1] секунд\s."))
					return FALSE
				var/input = stripped_multiline_input(usr, "Пожалуйста введите сообщение.", "Приоритетное Оповещение", "")
				if(!input || authenticated != 2 || world.time < cooldown_message + COOLDOWN_COMM_MESSAGE_LONG || !(usr in view(1,src)))
					return FALSE

				faction_announcement(input)
				message_admins("[key_name(usr)] создал оповещение.")
				log_announcement("[key_name(usr)] создал оповещение: [input]")
				cooldown_message = world.time

		if("award")
			print_medal(usr, src)

		if("evacuation_start")
			if(state == STATE_EVACUATION)
				if(security_level < SEC_LEVEL_DELTA)
					to_chat(usr, SPAN_WARNING("Корабль должен находиться в критическом состояние для начала эвакуации."))
					return FALSE

				if(SSevacuation.flags_scuttle & FLAGS_EVACUATION_DENY)
					to_chat(usr, SPAN_WARNING("USCM наложили блокировку на эвакуационные капсулы."))
					return FALSE

				if(!SSevacuation.initiate_evacuation())
					to_chat(usr, SPAN_WARNING("Вы не можете сейчас начать аварийную эвакуацию!"))
					return FALSE

				if(!SSevacuation.dest_master)
					SSevacuation.prepare()

				log_game("[key_name(usr)] начал аварийную эвакуацию.")
				message_admins("[key_name_admin(usr)] начал аварийную эвакуацию.")
				link.log_ares_security("Initiate Evacuation", "[usr] has called for an emergency evacuation.")
				return TRUE

			state = STATE_EVACUATION

		if("evacuation_cancel")
			if(state == STATE_EVACUATION_CANCEL)
				if(!SSevacuation.cancel_evacuation())
					to_chat(usr, SPAN_WARNING("Вы не можете сейчас отменить эвакуацию!"))
					return FALSE

				spawn(35)//some time between AI announcements for evac cancel and SD cancel.
					if(SSevacuation.evac_status == EVACUATION_STATUS_STANDING_BY)//nothing changed during the wait
						 //if the self_destruct is active we try to cancel it (which includes lowering alert level to red)
						if(!SSevacuation.cancel_self_destruct(1))
							//if SD wasn't active (likely canceled manually in the SD room), then we lower the alert level manually.
							set_security_level(SEC_LEVEL_RED, TRUE) //both SD and evac are inactive, lowering the security level.

				log_game("[key_name(usr)] отменил аварийную эвакуацию.")
				message_admins("[key_name_admin(usr)] отменил аварийную эвакуацию.")
				link.log_ares_security("Cancel Evacuation", "[usr] has cancelled the emergency evacuation.")
				return TRUE

			state = STATE_EVACUATION_CANCEL

		if("distress")
			if(state == STATE_DISTRESS)
				//Comment to test
				if(world.time < DISTRESS_TIME_LOCK)
					to_chat(usr, SPAN_WARNING("Вы не можете запустить аварийный маяк, [MAIN_AI_SYSTEM] отменил ваш ордер из-за соображений оперативной безопасности, функция будет доступна через [time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)] минут попробуйте опять."))
					return FALSE

				if(!SSticker.mode)
					return FALSE //Not a game mode?

				if(SSticker.mode.force_end_at == 0)
					to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] отменил ваш ордер из-за соображений оперативной безопасности."))
					return FALSE

				if(world.time < cooldown_request + COOLDOWN_COMM_REQUEST)
					to_chat(usr, SPAN_WARNING("Маяк бедствия недавно передал сообщение. Повторная подача не имеет смысла. Пожалуйста, подождите."))
					return FALSE

				if(security_level == SEC_LEVEL_DELTA)
					to_chat(usr, SPAN_WARNING("На корабле уже запущена процедура самоуничтожения!"))
					return FALSE

				for(var/client/C in GLOB.admins)
					if((R_ADMIN|R_MOD) & C.admin_holder.rights)
						C << 'sound/effects/sos-morse-code.ogg'

				SSticker.mode.request_ert(usr)
				to_chat(usr, SPAN_NOTICE("Запрос на запуск аварийного маяка отправлен USCM Центральное Командование."))

				cooldown_request = world.time
				return TRUE

			state = STATE_DISTRESS

		if("destroy")
			if(state == STATE_DESTROY)
				//Comment to test
				if(world.time < DISTRESS_TIME_LOCK)
					to_chat(usr, SPAN_WARNING("Вы не можете активировать самоуничтожение, [MAIN_AI_SYSTEM] отменил ваш ордер из-за соображений оперативной безопасности, функция будет доступна через [time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)] минут попробуйте опять."))
					return FALSE

				if(!SSticker.mode)
					return FALSE //Not a game mode?

				if(SSticker.mode.force_end_at == 0)
					to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] отменил ваш ордер из-за соображений оперативной безопасности."))
					return FALSE

				if(world.time < cooldown_destruct + COOLDOWN_COMM_DESTRUCT)
					to_chat(usr, SPAN_WARNING("Запрос на активацию механизма самоуничтожения уже отправлен высшему командыванию. Пожалуйста ждите."))
					return FALSE

				if(get_security_level() == "delta")
					to_chat(usr, SPAN_WARNING("[MAIN_SHIP_NAME]'s механизм самоуничтожения уже активирован."))
					return FALSE

				for(var/client/C in GLOB.admins)
					if((R_ADMIN|R_MOD) & C.admin_holder.rights)
						C << 'sound/effects/sos-morse-code.ogg'

				to_chat(usr, SPAN_NOTICE("Запрос на активацию механизма самоунитчтожения отправлен USCM Центральное Командование."))
				message_admins("[key_name(usr)] запрашивает активацию самоуничтожения корабля! [CC_MARK(usr)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];destroyship=\ref[usr]'>GRANT</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sddeny=\ref[usr]'>DENY</A>) [ADMIN_JMP_USER(usr)] [CC_REPLY(usr)]")

				cooldown_destruct = world.time
				return TRUE

			state = STATE_DESTROY

		if("messagelist")
			currmsg = 0
			state = STATE_MESSAGELIST

		if("viewmessage")
			state = STATE_VIEWMESSAGE
			if(!currmsg)
				if(href_list["message-num"])
					currmsg = text2num(href_list["message-num"])
				else
					state = STATE_MESSAGELIST

		if("delmessage")
			state = (currmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST

		if("delmessage2")
			if(authenticated)
				if(currmsg)
					var/title = messagetitle[currmsg]
					var/text  = messagetext[currmsg]
					messagetitle.Remove(title)
					messagetext.Remove(text)
					if(currmsg == aicurrmsg) aicurrmsg = 0
					currmsg = 0
				state = STATE_MESSAGELIST
			else state = STATE_VIEWMESSAGE


		if("status")
			state = STATE_STATUSDISPLAY

		if("setmsg1")
			stat_msg1 = reject_bad_text(trim(copytext(sanitize(input("Линия 1", "Напишите текст сообщения", stat_msg1) as text|null), 1, 40)), 40)
			updateDialog()

		if("setmsg2")
			stat_msg2 = reject_bad_text(trim(copytext(sanitize(input("Линия 2", "Напишите текст сообщения", stat_msg2) as text|null), 1, 40)), 40)
			updateDialog()

		if("messageUSCM")
			if(authenticated == 2)
				if(world.time < cooldown_central + COOLDOWN_COMM_CENTRAL)
					to_chat(usr, SPAN_WARNING("Обработка массивов.  Пожалуйста ожидайте."))
					return FALSE
				var/input = stripped_input(usr, "Пожалуйста, выберите сообщение для передачи в USCM.  Пожалуйста, имейте в виду, что этот процесс очень дорогостоящий, и злоупотребление им приведет к прекращению работы.  Передача сообщения не гарантирует ответа. Существует небольшая задержка, прежде чем вы сможете отправить другое сообщение. Будьте ясны и лаконичны.", "Чтобы прервать процесс, отправьте пустое сообщение.", "")
				if(!input || !(usr in view(1,src)) || authenticated != 2 || world.time < cooldown_central + COOLDOWN_COMM_CENTRAL) return FALSE

				high_command_announce(input, usr)
				to_chat(usr, SPAN_NOTICE("Сообщение отправлено."))
				log_announcement("[key_name(usr)] создал USCM оповещение: [input]")
				cooldown_central = world.time

		if("securitylevel")
			tmp_alertlevel = text2num( href_list["newalertlevel"] )
			if(!tmp_alertlevel) tmp_alertlevel = 0
			state = STATE_CONFIRM_LEVEL

		if("changeseclevel")
			state = STATE_ALERT_LEVEL

		if("selectlz")
			if(!SSticker.mode.active_lz)
				var/list/lz_choices = list()
				var/obj/structure/machinery/computer/shuttle/dropship/flight/lz1 = SSticker.mode.select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1))
				var/obj/structure/machinery/computer/shuttle/dropship/flight/lz2 = SSticker.mode.select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz2))
				if(lz1)
					lz_choices += list("lz1" = lz1)
				if(lz2)
					lz_choices += list("lz2" = lz2)

				var/new_lz = tgui_input_list(usr, "Выберите зону высадки", "Стадия Операции", lz_choices)
				if(!new_lz)
					return
				lz_choices = lz_choices[new_lz]

		else return FALSE

	updateUsrDialog()

/obj/structure/machinery/computer/communications/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/communications/attack_hand(mob/user as mob)
	if(..()) return FALSE

	user.set_interaction(src)
	var/dat = "<head><title>Консоль Коммуникаций</title></head><body>"
	dat += "<B>Статус Эвакуации</B>: [SSevacuation.get_evac_status_panel_eta()]<BR>"
	dat += "<B>Стадия Операции</B>: [SSevacuation.get_ship_operation_stage_status_panel_eta()]<BR>"
	switch(state)
		if(STATE_DEFAULT)
			if(authenticated)
				dat += "<BR><A HREF='?src=\ref[src];operation=logout'>ВЫЙТИ</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=changeseclevel'>Изменить уровень кода тревоги</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=status'>Изменить дисплей ситуации</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=messagelist'>Сообщения</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=mapview_ground'>Тактическая Карта Колонии</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=mapview_ship'>Тактическая Карта Корабля</A>"
				dat += "<BR><hr>"

				if(authenticated == 2)
					dat += "<BR>Основная ЗВ"
					if(!isnull(SSticker.mode) && !isnull(SSticker.mode.active_lz) && !isnull(SSticker.mode.active_lz.loc))
						dat += "<BR>[SSticker.mode.active_lz.loc.loc]"
					else if(SSevacuation.ship_operation_stage_status == OPERATION_BRIEFING)
						dat += "<BR><A HREF='?src=\ref[src];operation=selectlz'>Выбрать Основную ЗВ</A>"
					dat += "<BR><hr>"
					dat += "<BR><A HREF='?src=\ref[src];operation=announce'>Сделать Оповещение</A>"
					dat += GLOB.admins.len > 0 ? "<BR><A HREF='?src=\ref[src];operation=messageUSCM'>Отправить Сообщение USCM</A>" : "<BR>USCM коммуникации выключены"
					dat += "<BR><A HREF='?src=\ref[src];operation=award'>Выдать Награду</A>"
					dat += "<BR><A HREF='?src=\ref[src];operation=distress'>Выслать Аварийный Маяк</A>"
					dat += "<BR><A HREF='?src=\ref[src];operation=destroy'>Активировать Самоуничтожение</A>"
					switch(SSevacuation.evac_status)
						if(EVACUATION_STATUS_STANDING_BY) dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_start'>Начать аварийную эвакуацию</A>"
						if(EVACUATION_STATUS_INITIATING) dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_cancel'>Отменить аварийную жвакуацию</A>"

			else
				dat += "<BR><A HREF='?src=\ref[src];operation=login'>ВОЙТИ</A>"

		if(STATE_EVACUATION)
			dat += "Are you sure you want to evacuate the [MAIN_SHIP_NAME]? <A HREF='?src=\ref[src];operation=evacuation_start'>Подтвердить</A>"

		if(STATE_EVACUATION_CANCEL)
			dat += "Are you sure you want to cancel the evacuation of the [MAIN_SHIP_NAME]? <A HREF='?src=\ref[src];operation=evacuation_cancel'>Подтвердить</A>"

		if(STATE_DISTRESS)
			dat += "Are you sure you want to trigger a distress signal? The signal can be picked up by anyone listening, friendly or not. <A HREF='?src=\ref[src];operation=distress'>Подтвердить</A>"

		if(STATE_DESTROY)
			dat += "Вы уверены, что хотите запустить самоуничтожение? Это приведет к эвакуации экипажа и уничтожению корабля. <A HREF='?src=\ref[src];operation=destroy'>Подтвердить</A>"

		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=viewmessage;message-num=[i]'>[messagetitle[i]]</A>"

		if(STATE_VIEWMESSAGE)
			if(currmsg)
				dat += "<B>[messagetitle[currmsg]]</B><BR><BR>[messagetext[currmsg]]"
				if(authenticated)
					dat += "<BR><BR><A HREF='?src=\ref[src];operation=delmessage'>Delete"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_DELMESSAGE)
			if(currmsg)
				dat += "Are you sure you want to delete this message? <A HREF='?src=\ref[src];operation=delmessage2'>ОК</A>|<A HREF='?src=\ref[src];operation=viewmessage'>Отменить</A>"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "<A HREF='?src=\ref[src];operation=setstat;statdisp=blank'>Очистить</A><BR>"
			dat += "<A HREF='?src=\ref[src];operation=setstat;statdisp=time'>Корабельное время</A><BR>"
			dat += "<A HREF='?src=\ref[src];operation=setstat;statdisp=shuttle'>Время до эвакуации</A><BR>"
			dat += "<A HREF='?src=\ref[src];operation=setstat;statdisp=message'>Сообщение</A>"
			dat += "<ul><li> Line 1: <A HREF='?src=\ref[src];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A HREF='?src=\ref[src];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>Нету</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Красная Тревога</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Блокировака</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Биологическая Угроза</A> \]<BR><HR>"

		if(STATE_ALERT_LEVEL)
			dat += "В данный момент уровень тревоги: [get_security_level()]<BR>"
			if(security_level == SEC_LEVEL_DELTA)
				if(SSevacuation.dest_status >= NUKE_EXPLOSION_ACTIVE)
					dat += SET_CLASS("<b>Механизм самоуничтожения активен. [SSevacuation.evac_status != EVACUATION_STATUS_INITIATING ? "Вы должны вручную деактивировать механизм самоуничтожения." : ""]</b>", INTERFACE_RED)
					dat += "<BR>"
				switch(SSevacuation.evac_status)
					if(EVACUATION_STATUS_INITIATING)
						dat += SET_CLASS("<b>Начата эвакуация. Эвакуировать или отменить приказ об эвакуации.</b>", INTERFACE_RED)
					if(EVACUATION_STATUS_IN_PROGRESS)
						dat += SET_CLASS("<b>Эвакуация в процессе.</b>", INTERFACE_RED)
					if(EVACUATION_STATUS_COMPLETE)
						dat += SET_CLASS("<b>Эвакуация закончена.</b>", INTERFACE_RED)
			else
				dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_BLUE]'>Синий</A><BR>"
				dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_GREEN]'>Зеленый</A>"

		if(STATE_CONFIRM_LEVEL)
			dat += "В данный момент уровень тревоги: [get_security_level()]<BR>"
			dat += "Подтвердите изменение на: [num2seclevel(tmp_alertlevel)]<BR>"
			dat += "<A HREF='?src=\ref[src];operation=swipeidseclevel'>Приложите ID</A> чтобы подтвердить изменения.<BR>"

	dat += "<BR>[(state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Главное Меню</A>|" : ""]<A HREF='?src=\ref[user];mach_close=communications'>Закрыть</A>"
	show_browser(user, dat, name, "communications")
	onclose(user, "communications")

//A simpler version that doesn't have everything the other one has
/obj/structure/machinery/computer/communications/simple
	circuit = null

/obj/structure/machinery/computer/communications/simple/attack_hand(mob/user as mob)
	user.set_interaction(src)
	var/dat = "<body>"

	switch(state)
		if(STATE_DEFAULT)
			if(authenticated)
				dat += "<BR><A HREF='?src=\ref[src];operation=logout'>ВЫЙТИ</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=messagelist'>Сообщения</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=mapview'>Включить тактическую карту</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=selectloctacmap'>Сменить Локацию ТК</A>"
				dat += "<BR>DEFCON [faction.objectives_controller.current_level]: [faction.objectives_controller.last_objectives_completion_percentage]%"
				dat += "<BR>Remaining DEFCON asset budget: [faction.objectives_controller.remaining_reward_points] поинтов."
				dat += "<BR><hr>"

				if(authenticated == 2)
					dat += "<BR><A HREF='?src=\ref[src];operation=announce'>Сделать оповещение</A>"
					dat += "<BR><A HREF='?src=\ref[src];operation=award'>Выдать награду</A>"

			else
				dat += "<BR><A HREF='?src=\ref[src];operation=login'>ВОЙТИ</A>"

		if(STATE_MESSAGELIST)
			dat += "Сообщения:"
			for(var/i = 1; i<=messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=viewmessage;message-num=[i]'>[messagetitle[i]]</A>"

		if(STATE_VIEWMESSAGE)
			if(currmsg)
				dat += "<B>[messagetitle[currmsg]]</B><BR><BR>[messagetext[currmsg]]"
				if(authenticated)
					dat += "<BR><BR><A HREF='?src=\ref[src];operation=delmessage'>Удалить"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_DELMESSAGE)
			if(currmsg)
				dat += "Вы точно уверены, что хотите удалить сообщение? <A HREF='?src=\ref[src];operation=delmessage2'>Да</A>|<A HREF='?src=\ref[src];operation=viewmessage'>Отменить</A>"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

	dat += "<BR>[(state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A>|" : ""]<A HREF='?src=\ref[user];mach_close=communications'>Закрыть</A>"
	show_browser(user, dat, "Консоль Коммуникаций", "communications", "size=400x500")
	onclose(user, "communications")

#undef STATE_DEFAULT
#undef STATE_MESSAGELIST
#undef STATE_VIEWMESSAGE
#undef STATE_DELMESSAGE
#undef STATE_STATUSDISPLAY
#undef STATE_ALERT_LEVEL
#undef STATE_CONFIRM_LEVEL
