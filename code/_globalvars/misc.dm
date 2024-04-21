GLOBAL_VAR_INIT(game_year, 2182)

GLOBAL_VAR_INIT(ooc_allowed, TRUE)
GLOBAL_VAR_INIT(looc_allowed, TRUE)
GLOBAL_VAR_INIT(dsay_allowed, TRUE)
GLOBAL_VAR_INIT(dooc_allowed, TRUE)
GLOBAL_VAR_INIT(dlooc_allowed, FALSE)

GLOBAL_VAR_INIT(enter_allowed, TRUE)

GLOBAL_LIST_EMPTY(admin_log)
GLOBAL_LIST_EMPTY(asset_log)

// multiplier for watts per tick <> cell storage (eg: 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
//It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
#define CELLRATE 0.006

// Cap for how fast cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)
#define CHARGELEVEL 0.001

GLOBAL_VAR(VehicleElevatorConsole)
GLOBAL_VAR(VehicleGearConsole)

//Spawnpoints.
GLOBAL_LIST_EMPTY(fallen_list)
/// This is for dogtags placed on crosses- they will show up at the end-round memorial.
GLOBAL_LIST_EMPTY(fallen_list_cross)

GLOBAL_VAR(join_motd)
GLOBAL_VAR(current_tms)

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
GLOBAL_VAR_INIT(fileaccess_timer, 0)

GLOBAL_LIST_INIT(almayer_ship_sections, list(
	"Upper deck Foreship",
	"Upper deck Midship",
	"Upper deck Aftship",
	"Lower deck Foreship",
	"Lower deck Midship",
	"Lower deck Aftship"
))


GLOBAL_VAR_INIT(internal_tick_usage, 0.2 * world.tick_lag)

/// Global performance feature toggle flags
GLOBAL_VAR_INIT(perf_flags, NO_FLAGS)

GLOBAL_LIST_INIT(bitflags, list((1<<0), (1<<1), (1<<2), (1<<3), (1<<4), (1<<5), (1<<6), (1<<7), (1<<8), (1<<9), (1<<10), (1<<11), (1<<12), (1<<13), (1<<14), (1<<15), (1<<16), (1<<17), (1<<18), (1<<19), (1<<20), (1<<21), (1<<22), (1<<23)))

GLOBAL_VAR_INIT(master_mode, MODE_NAME_DISTRESS_SIGNAL)

GLOBAL_VAR_INIT(timezoneOffset, 0)

GLOBAL_LIST_INIT(pill_icon_mappings, map_pill_icons())

/// In-round override to default OOC color
GLOBAL_VAR(ooc_color_override)

GLOBAL_VAR_INIT(last_time_qued, 0)

GLOBAL_VAR(xenomorph_attack_delay)

GLOBAL_VAR_INIT(ship_hc_delay, setup_hc_delay())

GLOBAL_DATUM_INIT(item_to_box_mapping, /datum/item_to_box_mapping, init_item_to_box_mapping())

/proc/setup_hc_delay()
	var/value = rand(3000, 15000)
	return value
