#define CHANGETURF_DEFER_CHANGE (1<<0)
/// This flag prevents changeturf from gathering air from nearby turfs to fill the new turf with an approximation of local air
#define CHANGETURF_IGNORE_AIR (1<<1)
#define CHANGETURF_FORCEOP (1<<2)
/// A flag for PlaceOnTop to just instance the new turf instead of calling ChangeTurf. Used for uninitialized turfs NOTHING ELSE
#define CHANGETURF_SKIP (1<<3)

#define IS_OPAQUE_TURF(turf) (turf.directional_opacity == ALL_CARDINALS)

/// Marks a turf as organic. Used for alien wall and membranes.
#define TURF_DEBRISED					(1<<0)
#define TURF_WEATHER					(1<<1)
#define TURF_MULTIZ						(1<<2)
#define TURF_TRENCHING					(1<<3)
#define TURF_TRENCH						(1<<4)
#define TURF_ORGANIC					(1<<5)
#define TURF_NOJAUNT					(1<<6)
#define TURF_UNUSED_RESERVATION			(1<<7)
#define TURF_CAN_BE_DIRTY				(1<<8)
#define TURF_WEATHE_RPROOF				(1<<9)
#define TURF_EFFECT_AFFECTABLE			(1<<10)
#define TURF_HULL						(1<<11)
#define TURF_BURNABLE					(1<<12)
#define TURF_BREAKABLE					(1<<13)

#define REMOVE_CROWBAR  (1<<0)
#define BREAK_CROWBAR   (1<<1)
#define REMOVE_SCREWDRIVER (1<<2)
