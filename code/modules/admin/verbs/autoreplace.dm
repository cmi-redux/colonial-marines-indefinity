var/list/datum/decorator/manual/admin_runtime/admin_runtime_decorators = list()

/client/proc/set_autoreplacer()
	set category = "Admin.Events"
	set name = "Set Autoreplacer"

	if(!admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(usr, "Only administrators may use this command.")
		return

	var/types = input(usr, "Enter the type you want to create an autoreplacement for", "Set Autoreplacer") as text|null
	if(!types)
		return

	var/subtypes = FALSE

	if(alert("Do we want to replace subtypes too?", usr.client.auto_lang(LANGUAGE_CONFIRM), usr.client.auto_lang(LANGUAGE_YES), usr.client.auto_lang(LANGUAGE_NO)) == usr.client.auto_lang(LANGUAGE_YES))
		subtypes = TRUE

	var/field = input(usr, "What field we want to change?", "Set Autoreplacer") as text|null
	if(!field)
		return

	var/value = mod_list_add_ass()

	var/hint_text = subtypes ? "types and subtypes of" : "all"

	if(alert("Please check: set for [hint_text] `[types]` for field `[field]` set value `[value]`. Correct?", usr.client.auto_lang(LANGUAGE_CONFIRM), usr.client.auto_lang(LANGUAGE_YES), usr.client.auto_lang(LANGUAGE_NO)) != usr.client.auto_lang(LANGUAGE_YES))
		return

	admin_runtime_decorators.Add(SSdecorator.add_decorator(/datum/decorator/manual/admin_runtime, types, subtypes, field, value))

	log_and_message_admins("[src] activated new decorator id: [admin_runtime_decorators.len] set for [hint_text] `[types]` for field `[field]` set value `[value]`")

/client/proc/deactivate_autoreplacer()
	set category = "Admin.Events"
	set name = "Deactivate Autoreplacer"

	if(!admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(usr, "Only administrators may use this command.")
		return

	var/num_value = tgui_input_real_number(src, "Enter new number:","Num")

	if(!num_value)
		return

	admin_runtime_decorators[num_value].enabled = FALSE

	log_and_message_admins("[src] deactivated decorator id: [num_value]")

/client/proc/rerun_decorators()
	set category = "Admin.Events"
	set name = "Rerun Decorators"

	if(!admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(usr, "Only administrators may use this command.")
		return

	if(alert("ARE YOU SURE? THIS MAY CAUSE A LOT OF LAG!", usr.client.auto_lang(LANGUAGE_CONFIRM), usr.client.auto_lang(LANGUAGE_YES), usr.client.auto_lang(LANGUAGE_NO)) != usr.client.auto_lang(LANGUAGE_YES))
		return

	SSdecorator.force_update()

	log_and_message_admins("[src] rerun all decorators.")
