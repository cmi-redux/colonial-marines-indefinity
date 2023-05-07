/datum/entity/discord
	var/name
	var/player_id
	var/discord_id
	var/discord_key
	var/data[0]

BSQL_PROTECT_DATUM(/datum/entity/discord)

/datum/entity_meta/discord
    entity_type = /datum/entity/discord
    table_name = "player_discord"
    field_types = list("player_id" = DB_FIELDTYPE_BIGINT,
    "discord_id" = DB_FIELDTYPE_STRING_LARGE,
    "discord_key" = DB_FIELDTYPE_STRING_LARGE)
    key_field = "player_id"

/datum/entity_link/player_to_discord
    parent_entity = /datum/entity/player
    child_entity = /datum/entity/discord
    child_field = "player_id"

    parent_name = "player"
    child_name = "discord"

/datum/view_record/discord_view
    var/player_id
    var/discord_view_id
    var/discord_id
    var/discord_key
    var/ckey

/datum/entity_view_meta/discord_view
    root_record_type = /datum/entity/discord
    destination_entity = /datum/view_record/discord_view
    fields = list(
        "player_id",
        "discord_id",
        "discord_key",
        "discord_view_id" = "id",
        "ckey" = "player.ckey"
    )
    order_by = list("discord_view_id" = DB_ORDER_BY_DESC)

/datum/entity/discord/proc/show_discord(mob/user, update_data = TRUE)
	if(update_data)
		update_panel_data()
	ui_interact(user)

/datum/entity/discord/proc/ui_interact(mob/user, ui_key = "discord", datum/nanoui/ui = null, force_open = 1)
	update_panel_data()
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "discord.tmpl", "Discord", 400, 400, null, -1)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/datum/entity/discord/Topic(href, href_list)
	var/mob/user = usr
	user.set_interaction(src)

	nanomanager.update_uis(src)

/datum/entity/discord/proc/update_panel_data(mob/user)
	if(discord_id)
		data["discord_id"] = discord_id

	if(discord_key)
		data["discord_key"] = discord_key

/datum/entity/discord/proc/save_discord(discord_id, discord_key, player_id)
	if(!discord_id || !discord_key || !player_id)
		return
	DB_FILTER(/datum/entity/discord, DB_AND( // find all records (hopefully just one)
		DB_COMP("player_id", DB_EQUALS, player_id),
		DB_COMP("discord_key", DB_EQUALS, discord_key)),
		CALLBACK(src, PROC_REF(discord_callback), discord_id, discord_key, player_id)) // call the thing when filter is done filtering

/datum/entity/discord/proc/discord_callback(discord_id, discord_key, player_id, list/datum/entity/discord/DS)
	var/result_length = length(DS)
	if(result_length == 0) // haven't found an item
		var/datum/entity/discord/S = DB_ENTITY(/datum/entity/discord) // this creates a new record
		S.discord_id = discord_id
		S.discord_key = discord_key
		S.player_id = player_id
		S.save() // save it
		return // we are done here
	var/datum/entity/discord/S = DS[1] // we ensured this is the only item
	S.discord_id = discord_id
	S.discord_key = discord_key
	S.save() // say we wanna save it


/datum/entity/discord/proc/show_discord_admin(mob/user, update_data = TRUE)
	if(update_data)
		update_admin_panel_data()
	admin_ui_interact(user)

/datum/entity/discord/proc/admin_ui_interact(mob/user, ui_key = "discord_admin", datum/nanoui/ui = null, force_open = 1)
	update_panel_data()
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "discord_admin.tmpl", "Discord Admin", 400, 400, null, -1)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/datum/entity/discord/proc/update_admin_panel_data(mob/user)
	var/list/discords = list()

	var/list/datum/view_record/discord_view/discord = DB_VIEW(/datum/view_record/discord_view/)

	for(var/datum/view_record/discord_view/S in discord)
		discords += list(list(
			"player_id" = S.player_id,
			"ckey" = S.ckey,
			"discord_id" = S.discord_id,
			"discord_key" = S.discord_key
		))

	data["discord"] = discords
