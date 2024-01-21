/datum/entity/player_whitelist
	var/player_id
	var/whitelist_flags = NO_FLAGS

BSQL_PROTECT_DATUM(/datum/entity/player_whitelist)

/datum/entity_meta/player_whitelist
	entity_type = /datum/entity/player_whitelist
	table_name = "player_whitelist"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"whitelist_flags" = DB_FIELDTYPE_BIGINT,
	)
	key_field = "player_id"

/datum/entity_link/player_to_player_whitelist
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player_whitelist
	child_field = "player_id"

	parent_name = "player"
	child_name = "player_whitelist"

/datum/view_record/player_whitelist_view
	var/player_id
	var/whitelist_flags

/datum/entity_view_meta/player_whitelist_view
	root_record_type = /datum/entity/player_whitelist
	destination_entity = /datum/view_record/player_whitelist_view
	fields = list(
		"player_id",
		"whitelist_flags",
	)
	order_by = list("player_id" = DB_ORDER_BY_DESC)
