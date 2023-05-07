/proc/to_chat_spaced(target, html, type, text, avoid_highlighting = FALSE, margin_top = 1, margin_bottom = 1, margin_left = 0)
	var/new_html
	if(islist(html))
		new_html = list()
		for(var/i in html)
			new_html[i] = "<span style='display: block; margin: [margin_top]em 0 [margin_bottom]em [margin_left]em;'>[html[i]]</span>"
	else if(html)
		new_html = "<span style='display: block; margin: [margin_top]em 0 [margin_bottom]em [margin_left]em;'>[html]</span>"
	return to_chat(target, new_html, type, text, avoid_highlighting)

/proc/to_chat(target, html, type = null, text = null, avoid_highlighting = FALSE, immediate = FALSE, handle_whitespace = TRUE, trailing_newline = TRUE, confidential = FALSE)
	if(!target)
		return
	if(!html && !text)
		CRASH("Empty or null string in to_chat proc call.")
	if(target == world)
		target = GLOB.clients
	var/message = list("normal" = list("type" = type ? type : null, "text" = text ? text : null, "html" = html ? html : null, "avoidHighlighting" = avoid_highlighting))
	if(islist(text))
		for(var/i in text)
			message[i] = list("type" = message["normal"]["type"], "text" = text[i], "html" = message["normal"]["html"], "avoidHighlighting" = message["normal"]["avoidHighlighting"])
	else if(islist(html))
		for(var/i in html)
			message[i] = list("type" = message["normal"]["type"], "text" = message["normal"]["text"], "html" = html[i], "avoidHighlighting" = message["normal"]["avoidHighlighting"])

	if(Master.current_runlevel == RUNLEVEL_INIT || !SSchat?.initialized || immediate)
		if(islist(target))
			for(var/_target in target)
				var/client/client = CLIENT_FROM_VAR(_target)
				if(client)
					var/message_to_send = length(message) > 1 ? message[client.language] : message["normal"]
					client.tgui_panel?.window.send_message("chat/message", message_to_send)
					SEND_TEXT(client, message_to_html(message_to_send))
			return
		var/client/client = CLIENT_FROM_VAR(target)
		if(client)
			var/message_to_send = length(message) > 1 ? message[client.language] : message["normal"]
			client.tgui_panel?.window.send_message("chat/message", message_to_send)
			SEND_TEXT(client, message_to_html(message_to_send))

	else
		SSchat.queue(target, message)

/proc/announce_dchat(message, atom/target)
	var/jmp_message = message
	for(var/mob/dead/observer/observer as anything in GLOB.observer_list)
		if(target)
			jmp_message = "[message] (<a href='?src=\ref[observer];jumptocoord=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)"
		to_chat(observer, FONT_SIZE_LARGE(SPAN_DEADSAY("<b>ALERT:</b> [jmp_message]")))
