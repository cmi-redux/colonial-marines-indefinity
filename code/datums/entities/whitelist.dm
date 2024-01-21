/datum/entity/whitelist_player
	var/player_id
	var/whitelist_flags = NO_FLAGS

BSQL_PROTECT_DATUM(/datum/entity/whitelist_player)

/datum/entity_meta/whitelist_player
	entity_type = /datum/entity/whitelist_player
	table_name = "whitelist_player"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"whitelist_flags" = DB_FIELDTYPE_INT,
	)
	key_field = "player_id"

/datum/entity_link/player_to_whitelist_player
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/whitelist_player
	child_field = "player_id"

	parent_name = "player"
	child_name = "whitelist_player"

/datum/view_record/whitelist_player_view
	var/player_id
	var/whitelist_flags

/datum/entity_view_meta/whitelist_player_view
	root_record_type = /datum/entity/whitelist_player
	destination_entity = /datum/view_record/whitelist_player_view
	fields = list(
		"player_id",
		"whitelist_flags",
	)
	order_by = list("player_id" = DB_ORDER_BY_DESC)
