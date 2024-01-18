#define DONATER_NONE "None"
#define DONATER_ROOKIE "Rookie"
#define DONATER_MARINE "Marine"
#define DONATER_VIETNAM "Vietnamese"
#define DONATER_ZAGRADOTRUDNICHESTVO "Zagradotrudnichestvo"

GLOBAL_LIST_INIT(donaters_ranks, list(
	DONATER_NONE = 0,
	DONATER_ROOKIE = 1,
	DONATER_MARINE = 2,
	DONATER_VIETNAM = 3,
	DONATER_ZAGRADOTRUDNICHESTVO = 4,
))

GLOBAL_LIST_INIT(donaters_functions, list(
	DONATER_NONE = list("occ_color" = 0, "emoji" = 0, "respawn" = 0, "queue" = 0),
	DONATER_ROOKIE = list("occ_color" = 1, "emoji" = 1, "respawn" = 0, "queue" = 0),
	DONATER_MARINE = list("occ_color" = 1, "emoji" = 1, "respawn" = 1, "queue" = 4),
	DONATER_VIETNAM = list("occ_color" = 1, "emoji" = 1, "respawn" = 1, "queue" = 3),
	DONATER_ZAGRADOTRUDNICHESTVO = list("occ_color" = 1, "emoji" = 1, "respawn" = 1, "queue" = 2),
))

#define DONATER_TIERS list(DONATER_NONE, DONATER_ROOKIE, DONATER_MARINE, DONATER_VIETNAM, DONATER_ZAGRADOTRUDNICHESTVO)
