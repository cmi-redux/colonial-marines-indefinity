/datum/admins/proc/restart()
	set name = "Restart Server"
	set desc = "Restarts the world"
	set category = "Server"

	if(!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		return

	if(!check_rights(R_DEBUG, FALSE) && SSticker.current_state != GAME_STATE_FINISHED)
		to_chat(usr, "Вы не можете перезапустить пока игра не закончилась!")
		return

	var/confirm = alert("Перезагрузить мир?", "Перезагрузка", "Подтвердить", "Отменить")
	if(confirm == "Отменить")
		return
	if(confirm == "Подтвердить")
		to_world(SPAN_DANGER("<b>Перезагрузка Мира!</b> [SPAN_NOTICE("Запустил [usr.client.admin_holder.fakekey ? "Администратор" : usr.key]!")]"))
		log_admin("[key_name(usr)] инициировал рестарт.")

		sleep(50)
		world.Reboot(GLOB.href_token, SSticker.graceful)

/datum/admins/proc/shutdown_server()
	set name = "Shutdown Server"
	set desc = "Shuts the server down."
	set category = "Server"

	var/static/shuttingdown = null
	var/static/timeouts = list()
	var/waitforroundend = FALSE
	if(!CONFIG_GET(flag/allow_shutdown))
		to_chat(usr, SPAN_DANGER("Эта функция отключена оператором."))
		return

	if(!check_rights(R_SERVER))
		return

	if(shuttingdown)
		if(alert("Вы уверены что хотите отменить выключение сервера от [shuttingdown]?", "Отменить выключение?", "Нет", "Да, Отменить выключение") != "Да, Отменить выключение")
			return
		message_admins("[SPAN_NOTICE(usr)] Отменение выключение сервера, которое [shuttingdown] начал.")
		timeouts[shuttingdown] = world.time
		shuttingdown = FALSE
		return

	if(timeouts[usr.ckey] && timeouts[usr.ckey] + 2 MINUTES > world.time)
		var/remaining_time = (timeouts[usr.ckey] + 2 MINUTES - world.time) / 10
		to_chat(usr, SPAN_DANGER("Вам надо подождать [remaining_time] секунд."))
		return

	if(alert("Вы уверены что хотите выключить сервер? Только тот у кого есть доступ к серверу на прямую может его включить.", "Выключить сервер?", "Отмена", "Выключить сервер") != "Выключить сервер")
		return

	to_chat(usr, SPAN_DANGER("Предупреждение: Отложеное подтверждение требуется. Вас опять спросят о подтверждении через 30 секунд."))
	message_admins("[SPAN_NOTICE(usr)] запустил процесс выключения. Вы можете отменить этот процесс повторным нажатием на кнопку выключения сервера.")
	shuttingdown = usr.ckey

	sleep(30 SECONDS)

	if(!shuttingdown || shuttingdown != usr.ckey)
		return

	if(!usr?.client)
		message_admins("[SPAN_NOTICE(usr)] вышел с сервера до момента подтверждения выключения.")
		shuttingdown = null
		return

	if(alert("Вы уверены что хотите выключить сервер? Только тот у кого есть доступ к серверу на прямую может его включить.", "Выключить сервер?", "Отмена", "Да! Выключить сервер!") != "Да! Выключить сервер!")
		message_admins("[SPAN_NOTICE(usr)] отменил выключение сервера.")
		shuttingdown = null

	if(alert("Включить отложенный рестарт.", "Выключить сервер после конца раунда?", "Нет", "Да") == "Да")
		message_admins("[SPAN_NOTICE(usr)] включил отложенный рестарт.")
		waitforroundend = TRUE
	if(!waitforroundend)
		to_world(SPAN_DANGER("Сервер выключиться [waitforroundend ? "после этого раунда" : "через 30 секунд!"]. [SPAN_NOTICE("Запустил: [usr.key]")]"))
	message_admins("[SPAN_NOTICE(usr)] выключает сервер [waitforroundend ? "после этого раунда" : "через 30 секунд"]. Вы можете это отменить, нажав на кнопку выключения сервера еще раз в эти 30 секунд.")

	sleep(31 SECONDS) //to give the admins that final second to hit the confirm button on the cancel prompt.

	if(!shuttingdown)
		to_world(SPAN_NOTICE("Выключение сервера отменено"))
		return

	if(shuttingdown != usr.ckey) //somebody cancelled but then somebody started again.
		return

	to_world(SPAN_DANGER("Сервер выключиться [waitforroundend ? "после этого раунда" : "сейчас"]. [SPAN_NOTICE("Запустил: [shuttingdown]")]"))
	log_admin("Сервер выключиться [waitforroundend ? "после этого раунда" : "сейчас"]. Запустил: [shuttingdown]")
	SSticker.graceful = TRUE
	if(waitforroundend)
		return
	sleep(50)
	world.Reboot(GLOB.href_token, TRUE)

/datum/admins/proc/servermode()
	set name = "Toggle Players Joining"
	set desc = "Players mode joining."
	set category = "Server"

	locked_conect = !locked_conect
	if(!locked_conect)
		to_world("<B>Players may now join to server.</B>")
	else
		to_world("<B>Players may no longer join to server.</B>")
	message_admins("[key_name_admin(usr)] toggled players joining mode.")
	world.update_status()

/datum/admins/proc/togglejoin()
	set name = "Toggle Joining Round"
	set desc = "Players can still log into the server, but players won't be able to join the game as a new mob."
	set category = "Server"

	GLOB.enter_allowed = !GLOB.enter_allowed
	if(!GLOB.enter_allowed)
		to_world("<B>New players may no longer join the game.</B>")
	else
		to_world("<B>New players may now join the game.</B>")
	message_admins("[key_name_admin(usr)] toggled new player game joining.")
	world.update_status()

/datum/admins/proc/toggledsay()
	set name = "Toggle Server Deadchat"
	set desc = "Globally Toggles Deadchat"
	set category = "Server"

	GLOB.dsay_allowed = !GLOB.dsay_allowed
	if(GLOB.dsay_allowed)
		to_world("<B>Deadchat has been globally enabled!</B>")
	else
		to_world("<B>Deadchat has been globally disabled!</B>")
	message_admins("[key_name_admin(usr)] toggled deadchat.")

/datum/admins/proc/toggleooc()
	set name = "Toggle OOC"
	set desc = "Globally Toggles OOC"
	set category = "Server"

	GLOB.ooc_allowed = !GLOB.ooc_allowed
	if(GLOB.ooc_allowed)
		to_world("<B>The OOC channel has been globally enabled!</B>")
	else
		to_world("<B>The OOC channel has been globally disabled!</B>")
	message_admins("[key_name_admin(usr)] toggled OOC.")

/datum/admins/proc/togglelooc()
	set name = "Toggle LOOC"
	set desc = "Globally Toggles LOOC"
	set category = "Server"

	GLOB.looc_allowed = !GLOB.looc_allowed
	if(GLOB.looc_allowed)
		to_world("<B>The LOOC channel has been globally enabled!</B>")
	else
		to_world("<B>The LOOC channel has been globally disabled!</B>")
	message_admins("[key_name_admin(usr)] toggled LOOC.")
