GLOBAL_LIST_INIT(cardinals, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
))
GLOBAL_LIST_INIT(cardinals_multiz, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	UP,
	DOWN,
))
GLOBAL_LIST_INIT(diagonals, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,
))
GLOBAL_LIST_INIT(corners_multiz, list(
	UP|NORTHEAST,
	UP|NORTHWEST,
	UP|SOUTHEAST,
	UP|SOUTHWEST,
	DOWN|NORTHEAST,
	DOWN|NORTHWEST,
	DOWN|SOUTHEAST,
	DOWN|SOUTHWEST,
))
GLOBAL_LIST_INIT(diagonals_multiz, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,

	UP|NORTH,
	UP|SOUTH,
	UP|EAST,
	UP|WEST,
	UP|NORTHEAST,
	UP|NORTHWEST,
	UP|SOUTHEAST,
	UP|SOUTHWEST,

	DOWN|NORTH,
	DOWN|SOUTH,
	DOWN|EAST,
	DOWN|WEST,
	DOWN|NORTHEAST,
	DOWN|NORTHWEST,
	DOWN|SOUTHEAST,
	DOWN|SOUTHWEST,
))
GLOBAL_LIST_INIT(alldirs_multiz, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,

	UP,
	UP|NORTH,
	UP|SOUTH,
	UP|EAST,
	UP|WEST,
	UP|NORTHEAST,
	UP|NORTHWEST,
	UP|SOUTHEAST,
	UP|SOUTHWEST,

	DOWN,
	DOWN|NORTH,
	DOWN|SOUTH,
	DOWN|EAST,
	DOWN|WEST,
	DOWN|NORTHEAST,
	DOWN|NORTHWEST,
	DOWN|SOUTHEAST,
	DOWN|SOUTHWEST,
))
GLOBAL_LIST_INIT(alldirs, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,
))

GLOBAL_LIST_INIT(reverse_dir, list(
	2, 1, 3, 8, 10, 9, 11, 4, 6, 5, 7,
	12, 14, 13, 15, 32, 34, 33, 35, 40,
	42, 41, 43, 36, 38, 37, 39, 44, 46,
	45, 47, 16, 18, 17, 19, 24, 26, 25,
	27, 20, 22, 21, 23, 28, 30, 29, 31,
	48, 50, 49, 51, 56, 58, 57, 59, 52,
	54, 53, 55, 60, 62, 61, 63
))


GLOBAL_LIST_EMPTY(sorted_areas)
/// An association from typepath to area instance. Only includes areas with `unique` set.
GLOBAL_LIST_EMPTY_TYPED(areas_by_type, /area)

GLOBAL_DATUM(supply_elevator, /turf)
GLOBAL_DATUM(vehicle_elevator, /turf)
GLOBAL_LIST_EMPTY(spawns_by_job)
GLOBAL_LIST_EMPTY(spawns_by_squad_and_job)
GLOBAL_LIST_EMPTY(queen_spawns)
GLOBAL_LIST_EMPTY(xeno_spawns)
GLOBAL_LIST_EMPTY(xeno_hive_spawns)
GLOBAL_LIST_EMPTY(survivor_spawns_by_priority)
GLOBAL_LIST_EMPTY(corpse_spawns)

GLOBAL_LIST_EMPTY(mainship_yautja_teleports)
GLOBAL_LIST_EMPTY(mainship_yautja_desc)
GLOBAL_LIST_EMPTY(yautja_teleports)
GLOBAL_LIST_EMPTY(yautja_teleport_descs)

GLOBAL_LIST_EMPTY(thunderdome_one)
GLOBAL_LIST_EMPTY(thunderdome_two)
GLOBAL_LIST_EMPTY(thunderdome_admin)
GLOBAL_LIST_EMPTY(thunderdome_observer)

GLOBAL_LIST_EMPTY(defcon_drop_point)

GLOBAL_LIST_EMPTY(zombie_landmarks)

GLOBAL_LIST_EMPTY(newplayer_start)
GLOBAL_LIST_EMPTY_TYPED(observer_starts, /obj/effect/landmark/observer_start)

GLOBAL_LIST_EMPTY(map_items)
GLOBAL_LIST_EMPTY(xeno_tunnels)
GLOBAL_LIST_EMPTY(crap_items)
GLOBAL_LIST_EMPTY(good_items)
GLOBAL_LIST_EMPTY_TYPED(structure_spawners, /obj/effect/landmark/structure_spawner)
GLOBAL_LIST_EMPTY(hunter_primaries)
GLOBAL_LIST_EMPTY(hunter_secondaries)

GLOBAL_LIST_EMPTY(monkey_spawns)

GLOBAL_LIST_EMPTY(ert_spawns)

GLOBAL_LIST_EMPTY(simulator_targets)
GLOBAL_LIST_EMPTY(simulator_cameras)

GLOBAL_LIST_EMPTY(teleporter_landmarks)

GLOBAL_LIST_EMPTY(nightmare_landmarks)

GLOBAL_LIST_EMPTY(ship_areas)

// Objective landmarks. Value is TRUE if it contains documents
GLOBAL_LIST_EMPTY_TYPED(objective_landmarks_close, /obj/effect/landmark/objective_landmark/close)
GLOBAL_LIST_EMPTY_TYPED(objective_landmarks_medium, /obj/effect/landmark/objective_landmark/medium)
GLOBAL_LIST_EMPTY_TYPED(objective_landmarks_far, /obj/effect/landmark/objective_landmark/far)
GLOBAL_LIST_EMPTY_TYPED(objective_landmarks_science, /obj/effect/landmark/objective_landmark/science)

GLOBAL_LIST_EMPTY(comm_tower_landmarks_net_one)
GLOBAL_LIST_EMPTY(comm_tower_landmarks_net_two)

GLOBAL_LIST_EMPTY(landmarks_list) //list of all landmarks created
