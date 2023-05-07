/* smoothing_flags */
/// Smoothing system in where adjacencies are calculated and used to build an image by mounting each corner at runtime.
#define SMOOTH_CORNERS (1<<0)
/// Smoothing system in where adjacencies are calculated and used to select a pre-baked icon_state, encoded by bitmasking.
#define SMOOTH_BITMASK (1<<1)
/// Atom has diagonal corners, with underlays under them.
#define SMOOTH_DIAGONAL_CORNERS (1<<2)
/// Atom will smooth with the borders of the map.
#define SMOOTH_BORDER (1<<3)
/// Atom is currently queued to smooth.
#define SMOOTH_QUEUED (1<<4)
/// Smooths with objects, and will thus need to scan turfs for contents.
#define SMOOTH_OBJ (1<<5)

DEFINE_BITFIELD(smoothing_flags, list(
	"SMOOTH_CORNERS" = SMOOTH_CORNERS,
	"SMOOTH_BITMASK" = SMOOTH_BITMASK,
	"SMOOTH_DIAGONAL_CORNERS" = SMOOTH_DIAGONAL_CORNERS,
	"SMOOTH_BORDER" = SMOOTH_BORDER,
	"SMOOTH_QUEUED" = SMOOTH_QUEUED,
	"SMOOTH_OBJ" = SMOOTH_OBJ,
))

/*smoothing macros*/

#define QUEUE_SMOOTH(thing_to_queue) if(thing_to_queue.smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)) {SSicon_smooth.add_to_queue(thing_to_queue)}

#define QUEUE_SMOOTH_NEIGHBORS(thing_to_queue) for(var/neighbor in orange(1, thing_to_queue)) {var/atom/atom_neighbor = neighbor; QUEUE_SMOOTH(atom_neighbor)}


/**SMOOTHING GROUPS
 * Groups of things to smooth with.
 * * Contained in the `list/smoothing_groups` variable.
 * * Matched with the `list/canSmoothWith` variable to check whether smoothing is possible or not.
 */

#define S_TURF(num) ((24 * 0) + num) //Not any different from the number itself, but kept this way in case someone wants to expand it by adding stuff before it.
/* /turf only */

#define SMOOTH_GROUP_TURF_OPEN S_TURF(0) ///turf/open
#define SMOOTH_GROUP_TURF_CHASM S_TURF(1) ///turf/open/chasm, /turf/open/floor/fakepit
#define SMOOTH_GROUP_FLOOR_LAVA S_TURF(2) ///turf/open/lava/smooth
#define SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS S_TURF(3) ///turf/open/floor/glass

#define SMOOTH_GROUP_OPEN_FLOOR S_TURF(4) ///turf/open/floor

#define SMOOTH_GROUP_FLOOR_GRASS S_TURF(5) ///turf/open/floor/plating/grass
#define SMOOTH_GROUP_FLOOR_ICE S_TURF(6) ///turf/open/floor/plating/ice
#define SMOOTH_GROUP_FLOOR_SNOWED S_TURF(7) ///turf/open/floor/plating/snowed

#define SMOOTH_GROUP_CARPET S_TURF(8) ///turf/open/floor/carpet

#define SMOOTH_GROUP_CLOSED_TURFS S_TURF(9) ///turf/closed
#define SMOOTH_GROUP_MATERIAL_WALLS S_TURF(10) ///turf/closed/wall/material
#define SMOOTH_GROUP_MINERAL_WALLS S_TURF(11) ///turf/closed/mineral, /turf/closed/indestructible

#define MAX_S_TURF SMOOTH_GROUP_MINERAL_WALLS //Always match this value with the one above it.


#define S_OBJ(num) (MAX_S_TURF + 1 + num)
/* /obj included */

#define SMOOTH_GROUP_WALLS S_OBJ(0) ///turf/closed/wall, /obj/structure/falsewall

#define SMOOTH_GROUP_WINDOW_FULLTILE S_OBJ(21) ///turf/closed/indestructible/fakeglass, /obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/plasma/fulltile, /obj/structure/window/reinforced/plasma/fulltile
#define SMOOTH_GROUP_WINDOW_FULLTILE_BRONZE S_OBJ(22) ///obj/structure/window/bronze/fulltile
#define SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM S_OBJ(23) ///turf/closed/indestructible/opsglass, /obj/structure/window/reinforced/plasma/plastitanium
#define SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE S_OBJ(24) ///obj/structure/window/reinforced/shuttle
#define SMOOTH_GROUP_ROOF_NORMAL S_OBJ(26)			////turf/open/floor/plating/roof

#define SMOOTH_GROUP_LATTICE  S_OBJ(30) ///obj/structure/lattice
#define SMOOTH_GROUP_CATWALK  S_OBJ(31) ///obj/structure/lattice/catwalk

#define SMOOTH_GROUP_AIRLOCK S_OBJ(40) ///obj/machinery/door/airlock

#define SMOOTH_GROUP_TABLES S_OBJ(50) ///obj/structure/table
#define SMOOTH_GROUP_WOOD_TABLES S_OBJ(51) ///obj/structure/table/wood
#define SMOOTH_GROUP_FANCY_WOOD_TABLES S_OBJ(52) ///obj/structure/table/wood/fancy
#define SMOOTH_GROUP_BRONZE_TABLES S_OBJ(53) ///obj/structure/table/bronze
#define SMOOTH_GROUP_ABDUCTOR_TABLES S_OBJ(54) ///obj/structure/table/abductor
#define SMOOTH_GROUP_GLASS_TABLES S_OBJ(55) ///obj/structure/table/glass

#define SMOOTH_GROUP_ALIEN_NEST S_OBJ(59) ///obj/structure/bed/nest
#define SMOOTH_GROUP_ALIEN_RESIN S_OBJ(60) ///obj/structure/alien/resin
#define SMOOTH_GROUP_ALIEN_WALLS S_OBJ(61) ///obj/structure/alien/resin/wall, /obj/structure/alien/resin/membrane
#define SMOOTH_GROUP_ALIEN_WEEDS S_OBJ(62) ///obj/structure/alien/weeds

#define SMOOTH_GROUP_SECURITY_BARRICADE S_OBJ(63) ///obj/structure/barricade/security
#define SMOOTH_GROUP_SANDBAGS S_OBJ(64) ///obj/structure/barricade/sandbags

#define SMOOTH_GROUP_HEDGE_FLUFF S_OBJ(65) ///obj/structure/hedge

#define SMOOTH_GROUP_SHUTTLE_PARTS S_OBJ(66) ///obj/structure/window/reinforced/shuttle, /obj/structure/window/reinforced/plasma/plastitanium, /turf/closed/indestructible/opsglass, /obj/structure/shuttle

#define SMOOTH_GROUP_CLEANABLE_DIRT S_OBJ(67) ///obj/effect/decal/cleanable/dirt

#define SMOOTH_GROUP_SNOW S_TURF(68)

#define MAX_S_OBJ SMOOTH_GROUP_SNOW //Always match this value with the one above it.

///Floors inverse-masking frills.
#define FRILL_FLOOR_CUT "frill floor cut"
///Game plane inverse-masking frills.
#define FRILL_GAME_CUT "frill game cut"

#define FRILL_MOB_MASK "frill mob mask"
