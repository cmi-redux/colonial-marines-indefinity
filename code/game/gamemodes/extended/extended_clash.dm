/datum/game_mode/extended/faction_clash
	name = MODE_NAME_FACTION_CLASH
	config_tag = MODE_NAME_FACTION_CLASH
	flags_round_type = MODE_HVH_BALANCE
	toggleable_flags = MODE_NO_SNIPER_SENTRY|MODE_NO_ATTACK_DEAD|MODE_NO_STRIPDRAG_ENEMY|MODE_STRONG_DEFIBS|MODE_BLOOD_OPTIMIZATION|MODE_NO_COMBAT_CAS
	taskbar_icon = 'icons/taskbar/gml_hvh.png'

/datum/game_mode/extended/faction_clash/post_setup()
	. = ..()
