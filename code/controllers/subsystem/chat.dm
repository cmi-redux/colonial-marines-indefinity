/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

SUBSYSTEM_DEF(chat)
	name = "Chat"
	flags = SS_TICKER
	wait = 0.1 SECONDS
	priority = SS_PRIORITY_CHAT
	init_order = SS_INIT_CHAT

	var/list/payload_by_client = list()

/datum/controller/subsystem/chat/Initialize()
	// Just used by chat system to know that initialization is nearly finished.
	// The to_chat checks could probably check the runlevel instead, but would require testing.
	return SS_INIT_SUCCESS

/datum/controller/subsystem/chat/fire()
	for(var/key in payload_by_client)
		var/client/client = key
		var/payload = payload_by_client[key]
		payload_by_client -= key
		if(client)
			client.tgui_panel?.window.send_message("chat/message", payload)
			for(var/message in payload)
				SEND_TEXT(client, message_to_html(message))
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/chat/proc/queue(target, message)
	if(islist(target))
		for(var/_target in target)
			var/client/client = CLIENT_FROM_VAR(_target)
			if(client)
				LAZYADD(payload_by_client[client], list(length(message) > 1 ? message[client.language] : message["normal"]))
		return
	var/client/client = CLIENT_FROM_VAR(target)
	if(client)
		LAZYADD(payload_by_client[client], list(length(message) > 1 ? message[client.language] : message["normal"]))
