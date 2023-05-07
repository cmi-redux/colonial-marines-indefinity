#define STATE_DEFAULT 1
#define STATE_EVACUATION 2
#define STATE_EVACUATION_CANCEL 3
#define STATE_DISTRESS 4
#define STATE_DESTROY 5
#define STATE_DEFCONLIST 6

#define STATE_MESSAGELIST 7
#define STATE_VIEWMESSAGE 8
#define STATE_DELMESSAGE 9



#define COMMAND_SHIP_ANNOUNCE "Command Ship Announcement"

#define COMMAND_HQ_ANNOUNCE			"USCM High Command Announcement"

/obj/structure/machinery/computer/almayer_control
	name = "Консоль Управления 'Алмаером'"
	desc = "Используется для управления кораблем и использованием разных функций."
	icon_state = "comm_alt"
	req_access = list(ACCESS_MARINE_SENIOR)
	unslashable = TRUE
	unacidable = TRUE

	var/controled_ship = "USS \"Almayer\""

	var/state = STATE_DEFAULT

	var/is_announcement_active = TRUE

	var/cooldown_request = 0
	var/cooldown_destruct = 0
	var/cooldown_central = 0

	var/super_energetic_rele_active = TRUE

	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0

	faction_to_get = FACTION_MARINE

/obj/structure/machinery/computer/almayer_control/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/almayer_control/attack_hand(mob/user as mob)
	if(..() || !allowed(user) || inoperable())
		return

	ui_interact(user)

/obj/structure/machinery/computer/almayer_control/ui_interact(mob/user as mob)
	user.set_interaction(src)

	var/dat = "<head><title>Консоль Управления [controled_ship]</title></head><body>"
	dat += "<B>Задержка связи</B>: [duration2text_hour_min_sec(GLOB.ship_hc_delay, "hh:mm:ss")]<BR>"
	dat += "<B>Статус Эвакуации</B>: [SSevacuation.get_evac_status_panel_eta()]<BR>"
	dat += "<B>Стадия Операции</B>: [SSevacuation.get_ship_operation_stage_status_panel_eta()]<BR>"
	dat += "<BR><hr>"
	switch(state)
		if(STATE_DEFAULT)
			dat += "Alert Level: <A href='?src=\ref[src];operation=changeseclevel'>[get_security_level()]</A><BR>"
			dat += "<BR><A HREF='?src=\ref[src];operation=ship_announce'>[is_announcement_active ? "Сделать Корабельное Оповещение" : "*Недоступно*"]</A>"
			dat += super_energetic_rele_active ? "<BR><A HREF='?src=\ref[src];operation=messageUSCM'>Отправить Сообщение Высшему Командыванию USCM</A>" : "<BR>USCM высокоэнергетическое реле повреждено"
			dat += "<BR><A HREF='?src=\ref[src];operation=award'>Выдать Награду</A>"

			dat += "<BR><hr>"
			if(!isnull(SSticker.mode) && !isnull(SSticker.mode.active_lz) && !isnull(SSticker.mode.active_lz.loc))
				dat += "<BR>Основная ЗВ [SSticker.mode.active_lz.loc.loc]"
			dat += "<BR>Взаимодействие с прогрессом операции:"
			switch(SSevacuation.ship_operation_stage_status)
				if(OPERATION_DECRYO)
					dat += "<BR>Поднятие морпехов из крио"
				if(OPERATION_BRIEFING)
					dat += "<BR>Проведение инструктажа"
					if(isnull(SSticker.mode.active_lz))
						dat += "<BR><A HREF='?src=\ref[src];operation=selectlz'>Выбрать Основную ЗВ</A>"
				if(OPERATION_FIRST_LANDING)
					dat += "<BR>Первая высадка"
					dat += "<BR>DEFCON [faction.objectives_controller.current_level]: [faction.objectives_controller.last_objectives_completion_percentage]%"
					dat += "<BR>Оставшийся бюджет на DEFCON активы: [faction.objectives_controller.remaining_reward_points] поинтов."
					dat += "<BR><A href='?src=\ref[src];operation=defcon'>Акивировать DEFCON Активы</A>"
					dat += "<BR><A href='?src=\ref[src];operation=defconlist'>Список DEFCON Активы</A><BR>"
				if(OPERATION_IN_PROGRESS)
					dat += "<BR>Выполнение задач операции"
					dat += "<BR><A HREF='?src=\ref[src];operation=escape'>Закончить Операцию (аварийная причина)</A><BR>"
					dat += "<BR>DEFCON [faction.objectives_controller.current_level]: [faction.objectives_controller.last_objectives_completion_percentage]%"
					dat += "<BR>Оставшийся бюджет на DEFCON активы: [faction.objectives_controller.remaining_reward_points] поинтов."
					dat += "<BR><A href='?src=\ref[src];operation=defcon'>Акивировать DEFCON Активы</A>"
					dat += "<BR><A href='?src=\ref[src];operation=defconlist'>Список DEFCON Активы</A><BR>"
					dat += "<BR><A HREF='?src=\ref[src];operation=distress'>Запустить Аварийный Маяк</A>"
					dat += "<BR><A HREF='?src=\ref[src];operation=destroy'>Активировать Самоуничтожение</A>"
					switch(SSevacuation.evac_status)
						if(EVACUATION_STATUS_STANDING_BY)
							dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_start'>Начать аварийную эвакуацию</A>"
						if(EVACUATION_STATUS_INITIATING)
							dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_cancel'>Отменить аварийную эвакуацию</A>"
				if(OPERATION_ENDING)
					dat += "<BR>Завершение операции"
					dat += "<BR><A HREF='?src=\ref[src];operation=escape'>Закончить Операцию Преждевременно</A>"
				if(OPERATION_LEAVING_OPERATION_PLACE)
					dat += "<BR>Покидание зоны операции"
					dat += "<A HREF='?src=\ref[src];operation=escape_cancel'>Вернуться в Зону операции</A>"
				if(OPERATION_DEBRIEFING)
					dat += "<BR>Подведение итогов"
				if(OPERATION_CRYO)
					dat += "<BR>Перемещение экипажа в крио"

			dat += "<BR><hr>"
			dat += "<BR><A HREF='?src=\ref[src];operation=messagelist'>Сообщения</A>"

		if(STATE_EVACUATION)
			dat += "Вы уверены, что хотите эвакуировать [controled_ship]? <A HREF='?src=\ref[src];operation=evacuation_start'>Подтвердить</A>"

		if(STATE_EVACUATION_CANCEL)
			dat += "Вы уверены, что хотите отменить эвакуацию [controled_ship]? <A HREF='?src=\ref[src];operation=evacuation_cancel'>Подтвердить</A>"

		if(STATE_DISTRESS)
			dat += "Вы уверены, что хотите запустить аварийный маяк? Сигнал может быть услышан кем угодно, дружелюбными или нет. <A HREF='?src=\ref[src];operation=distress'>Подтвердить</A>"

		if(STATE_DESTROY)
			dat += "Вы уверены, что хотите активировать самоуничтожение? Вам придеться покинуть корабль. <A HREF='?src=\ref[src];operation=destroy'>Подтвердить</A>"

		if(STATE_MESSAGELIST)
			dat += "Сообщения:"
			for(var/i = 1; i<=messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=viewmessage;message-num=[i]'>[messagetitle[i]]</A>"

		if(STATE_VIEWMESSAGE)
			if(currmsg)
				dat += "<B>[messagetitle[currmsg]]</B><BR><BR>[messagetext[currmsg]]"
				dat += "<BR><BR><A HREF='?src=\ref[src];operation=delmessage'>Удалить"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_DELMESSAGE)
			if(currmsg)
				dat += "Вы уверены, что хотите это сделать? <A HREF='?src=\ref[src];operation=delmessage2'>ОК</A>|<A HREF='?src=\ref[src];operation=viewmessage'>Отменить</A>"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_DEFCONLIST)
			for(var/i in faction.objectives_controller.purchased_rewards)
				dat += "[i]"

	dat += "<BR>[(state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Главное Меню</A>|" : ""]<A HREF='?src=\ref[user];mach_close=almayer_control'>Закрыть</A>"

	show_browser(user, dat, name, "almayer_control")
	onclose(user, "almayer_control")

/obj/structure/machinery/computer/almayer_control/Topic(href, href_list)
	if(..())
		return FALSE

	usr.set_interaction(src)

	switch(href_list["operation"])
		if("main")
			state = STATE_DEFAULT

		if("defcon")
			faction.objectives_controller.list_and_purchase_rewards()
			return

		if("defconlist")
			state = STATE_DEFCONLIST

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
			message_admins("[key_name(usr)] создал корабельное оповещение.")
			log_announcement("[key_name(usr)] создал корабельное оповещение: [input]")

		if("escape")
			if(SSevacuation.initiate_ship_evacuation())
				to_chat(usr, SPAN_WARNING("[controled_ship] покинит радиус досигаймости сигнала с колонией через: [duration2text_hour_min_sec(SSevacuation.ship_evac_time + SHIP_EVACUATION_AUTOMATIC_DEPARTURE - world.time, "hh:mm:ss")], АРЕС все еще имеет право остановить завершение операции в случае нарушения протокола!"))
				log_game("[key_name(usr)] начал свертывание операции.")
				message_admins("[key_name_admin(usr)] начал свертывание операции.")
				return TRUE
			to_chat(usr, SPAN_WARNING("ОШИБКА, [MAIN_AI_SYSTEM] НЕ МОЖЕТ ПОДТВЕРДИТЬ ПРЕЖДЕВРЕМЕННОЕ ЗАВЕРШЕНИЕ ОПЕРАЦИИ, ПЕРЕПРОВЕРЬТЕ ПРОТОКОЛ ЗАВЕРШЕНИЯ ОПЕРАЦИИ!"))

		if("escape_cancel")
			var/input = stripped_multiline_input(usr, "Пожалуйста введите сообщение экипажу.", "Приоритетное Оповещение Для Экипажа", "")
			if(!input || !(usr in view(1,src)))
				return FALSE
			if(SSevacuation.cancel_ship_evacuation(input) && !SSevacuation.ship_evacuating_forced)
				to_chat(usr, SPAN_WARNING("Вы продолжили операцию, [controled_ship] возвращается на позицию!"))
				log_game("[key_name(usr)] отменил свертывание операции.")
				message_admins("[key_name_admin(usr)] отменил свертывание операции.")
				return TRUE
			to_chat(usr, SPAN_WARNING("ОШИБКА, [MAIN_AI_SYSTEM] НЕ МОЖЕТ ПОДТВЕРДИТЬ ДАННОЕ ДЕЙСТВИЕ!"))

		if("selectlz")
			if(!SSticker.mode.active_lz)
				var/lz_choices = list()
				for(var/obj/structure/machinery/computer/shuttle_control/console in machines)
					if(is_ground_level(console.z) && !console.onboard && console.shuttle_type == SHUTTLE_DROPSHIP)
						lz_choices += console
				var/new_lz = input(usr, "Выберите зону высадки", "Стадия Операции")  as null|anything in lz_choices
				if(new_lz)
					SSticker.mode.select_lz(new_lz)

		if("evacuation_start")
			if(state == STATE_EVACUATION)
				if(security_level < SEC_LEVEL_RED)
					to_chat(usr, SPAN_WARNING("The ship must be under red alert in order to enact evacuation procedures."))
					return FALSE

				if(SSevacuation.flags_scuttle & FLAGS_EVACUATION_DENY)
					to_chat(usr, SPAN_WARNING("The USCM has placed a lock on deploying the evacuation pods."))
					return FALSE

				if(!SSevacuation.initiate_evacuation())
					to_chat(usr, SPAN_WARNING("You are unable to initiate an evacuation procedure right now!"))
					return FALSE

				log_game("[key_name(usr)] начал аварийную эвакуацию.")
				message_admins("[key_name_admin(usr)] начал аварийную эвакуацию.")
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
				return TRUE

			state = STATE_EVACUATION_CANCEL

		if("distress")
			if(state == STATE_DISTRESS)
				if(world.time < DISTRESS_TIME_LOCK)
					to_chat(usr, SPAN_WARNING("Вы не можете запустить аварийный маяк, АРЕС отменил ваш ордер из-за соображений оперативной безопасности, функция будет доступна через [time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)] минут попробуйте опять."))
					return FALSE

				if(!SSticker.mode)
					return FALSE //Not a game mode?

				if(SSticker.mode.force_end_at == 0)
					to_chat(usr, SPAN_WARNING("АРЕС отменил ваш ордер из-за соображений оперативной безопасности."))
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
				to_chat(usr, SPAN_NOTICE("Запрос на запуск аварийного маяка отправлен USCM Центральное Командование."))
				message_admins("[key_name(usr)] запрашивает запуск аварийного маяка! (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccmark=\ref[usr]'>Пометить</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress=\ref[usr]'>ПОДТВЕРДИТЬ</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccdeny=\ref[usr]'>ОТМЕНИТЬ</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[usr]'>НАБЛЮДАТЬ</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CentcommReply=\ref[usr]'>ОТВЕТИТ</A>)")

				cooldown_request = world.time
				return TRUE

			state = STATE_DISTRESS

		if("destroy")
			if(state == STATE_DESTROY)
				//Comment to test
				if(world.time < DISTRESS_TIME_LOCK)
					to_chat(usr, SPAN_WARNING("Вы не можете активировать самоуничтожение, АРЕС отменил ваш ордер из-за соображений оперативной безопасности, функция будет доступна через [time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)] минут попробуйте опять."))
					return FALSE

				if(!SSticker.mode)
					return FALSE //Not a game mode?

				if(SSticker.mode.force_end_at == 0)
					to_chat(usr, SPAN_WARNING("АРЕС отменил ваш ордер из-за соображений оперативной безопасности."))
					return FALSE

				if(world.time < cooldown_destruct + COOLDOWN_COMM_DESTRUCT)
					to_chat(usr, SPAN_WARNING("Запрос на активацию механизма самоуничтожения уже отправлен высшему командыванию. Пожалуйста ждите."))
					return FALSE

				if(get_security_level() == "delta")
					to_chat(usr, SPAN_WARNING("[controled_ship] механизм самоуничтожения уже активирован."))
					return FALSE

				for(var/client/C in GLOB.admins)
					if((R_ADMIN|R_MOD) & C.admin_holder.rights)
						C << 'sound/effects/sos-morse-code.ogg'
				message_admins("[key_name(usr)] запрашивает активацию самоуничтожения корабля! (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccmark=\ref[usr]'>Пометить</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];destroyship=\ref[usr]'>ПОДТВЕРДИТЬ</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sddeny=\ref[usr]'>ОТМЕНИТЬ</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[usr]'>НАБЛЮДАТЬ</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CentcommReply=\ref[usr]'>ОТВЕТИТЬ</A>)")
				to_chat(usr, SPAN_NOTICE("Запрос на активацию механизма самоунитчтожения отправлен USCM Центральное Командование."))
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
			if(currmsg)
				var/title = messagetitle[currmsg]
				var/text  = messagetext[currmsg]
				messagetitle.Remove(title)
				messagetext.Remove(text)
				if(currmsg == aicurrmsg) aicurrmsg = 0
				currmsg = 0
			state = STATE_MESSAGELIST

		if("messageUSCM")
			if(world.time < cooldown_central + COOLDOWN_COMM_CENTRAL)
				to_chat(usr, SPAN_WARNING("Обработка массивов.  Пожалуйста ожидайте."))
				return FALSE
			var/input = stripped_input(usr, "Пожалуйста, выберите сообщение для передачи в USCM.  Пожалуйста, имейте в виду, что этот процесс очень дорогостоящий, и злоупотребление им приведет к прекращению работы.  Передача сообщения не гарантирует ответа. Существует небольшая задержка, прежде чем вы сможете отправить другое сообщение. Будьте ясны и лаконичны.", "Чтобы прервать процесс, отправьте пустое сообщение.", "")
			if(!input || !(usr in view(1,src)) || world.time < cooldown_central + COOLDOWN_COMM_CENTRAL) return FALSE

			high_command_announce(input, usr)
			to_chat(usr, SPAN_NOTICE("Сообщение передано."))
			log_announcement("[key_name(usr)] сделал USCM оповещение: [input]")
			cooldown_central = world.time

		if("changeseclevel")
			var/list/alert_list = list(num2seclevel(SEC_LEVEL_GREEN), num2seclevel(SEC_LEVEL_BLUE))
			switch(security_level)
				if(SEC_LEVEL_GREEN)
					alert_list -= num2seclevel(SEC_LEVEL_GREEN)
				if(SEC_LEVEL_BLUE)
					alert_list -= num2seclevel(SEC_LEVEL_BLUE)
				if(SEC_LEVEL_DELTA)
					return

			var/level_selected = tgui_input_list(usr, "Какой уровень вы хотите установить?", "Уровень Тревоги", alert_list)
			if(!level_selected)
				return

			set_security_level(seclevel2num(level_selected))

			log_game("[key_name(usr)] изменил уровень безопасности на [get_security_level()].")
			message_admins("[key_name_admin(usr)] изменил уровень безопасности на [get_security_level()].")

		if("award")
			print_medal(usr, src)

	updateUsrDialog()

/obj/structure/machinery/computer/almayer_control/proc/reactivate_announcement(mob/user)
	is_announcement_active = TRUE
	updateUsrDialog()

/obj/structure/machinery/computer/almayer_control/hq_uscm
	name = "Компьютер для удаленного управления систем"
	desc = "Повзовляет удаленно управлять система корабля."
	unslashable = TRUE
	unacidable = TRUE
	exproof = TRUE

/obj/structure/machinery/computer/almayer_control/hq_uscm/attack_hand(mob/user as mob)
	if(..() || !allowed(user) || inoperable())
		return

	ui_interact(user)

/obj/structure/machinery/computer/almayer_control/hq_uscm/ui_interact(mob/user as mob)
	user.set_interaction(src)

	var/dat = "<head><title>Консоль Дистанционного Управления</title></head><body>"



	dat += "<B>Статус Эвакуации</B>: [SSevacuation.get_evac_status_panel_eta()]<BR>"
	dat += "<B>Стадия Операции</B>: [SSevacuation.get_ship_operation_stage_status_panel_eta()]<BR>"
	dat += "<BR>Контролируемый корабль [controled_ship]<BR>"

	switch(state)
		if(STATE_DEFAULT)
			dat += "<BR>DEFCON [faction.objectives_controller.current_level]: [faction.objectives_controller.last_objectives_completion_percentage]%"
			dat += "<BR>Оставшийся бюджет на DEFCON активы: [faction.objectives_controller.remaining_reward_points] поинтов."
			dat += "<BR><A href='?src=\ref[src];operation=defcon'>Акивировать DEFCON Активы</A>"
			dat += "<BR><A href='?src=\ref[src];operation=defconlist'>Список DEFCON Активы</A><BR>"
			dat += "<BR><hr>"

			dat += "<BR><A HREF='?src=\ref[src];operation=destroy'>Активировать Самоуничтожение</A>"
			switch(SSevacuation.evac_status)
				if(EVACUATION_STATUS_STANDING_BY)
					dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_start'>Начать аварийную эвакуацию</A>"
				if(EVACUATION_STATUS_INITIATING)
					dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_cancel'>Отменить аварийную эвакуацию</A>"

		if(STATE_EVACUATION)
			dat += "Вы уверены, что хотите эвакуировать [controled_ship]? <A HREF='?src=\ref[src];operation=evacuation_start'>Подтвердить</A>"

		if(STATE_EVACUATION_CANCEL)
			dat += "Вы уверены, что хотите отменить эвакуацию [controled_ship]? <A HREF='?src=\ref[src];operation=evacuation_cancel'>Подтвердить</A>"

		if(STATE_DESTROY)
			dat += "Вы уверены, что хотите активировать самоуничтожение? Вам придеться покинуть корабль. <A HREF='?src=\ref[src];operation=destroy'>Подтвердить</A>"

	dat += "<BR>[(state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Главное Меню</A>|" : ""]<A HREF='?src=\ref[user];mach_close=almayer_control'>Закрыть</A>"

	show_browser(user, dat, name, "almayer_control")
	onclose(user, "almayer_control")

/obj/structure/machinery/computer/almayer_control/hq_uscm/Topic(href, href_list)
	if(..())
		return FALSE

	usr.set_interaction(src)

	switch(href_list["operation"])
		if("announce")
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

			shipwide_ai_announcement(input, COMMAND_HQ_ANNOUNCE, signature = signed)
			addtimer(CALLBACK(src, PROC_REF(reactivate_announcement), usr), COOLDOWN_COMM_MESSAGE)
			message_admins("[key_name(usr)] создал корабельное оповещение.")
			log_announcement("[key_name(usr)] создал корабельное оповещение: [input]")


#undef STATE_DEFAULT
#undef STATE_EVACUATION
#undef STATE_EVACUATION_CANCEL
#undef STATE_DISTRESS
#undef STATE_DESTROY
#undef STATE_DEFCONLIST

#undef STATE_MESSAGELIST
#undef STATE_VIEWMESSAGE
#undef STATE_DELMESSAGE
