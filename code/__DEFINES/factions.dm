//FACTION NAMES
#define FACTION_NEUTRAL "neutral"
//USCM
#define FACTION_USCM "uscm"
#define FACTION_MARINE "cm"
#define FACTION_CMB "cmb"
#define FACTION_MARSOC "msoc"
//CONTRACTOR
#define FACTION_CONTRACTOR "contractor"
//WY
#define FACTION_WY "wey_yu"
#define FACTION_PMC "pmc"
#define FACTION_WY_DEATHSQUAD "wy_death_sqaud"
//UPP
#define FACTION_UPP "upp"
//CLF
#define FACTION_CLF "clf"
//COLON
#define FACTION_COLONIST "colonist"
//OTHER
#define FACTION_RESS "ress"
#define FACTION_TWE "twe"
#define FACTION_MERCENARY "mercenary"
#define FACTION_FREELANCER "freelancer"
#define FACTION_HEFA "hefa_order"
#define FACTION_DUTCH "dutch's_dozen"
#define FACTION_PIRATE "pirate"
#define FACTION_GLADIATOR "gladiator"
#define FACTION_PIZZA "pizza_delivery"
#define FACTION_SOUTO "souto"
#define FACTION_THREEWE "threewe"
//ZOMBIE
#define FACTION_ZOMBIE "zombie"
//YAUTJA
#define FACTION_YAUTJA "yautja"
//XENOS
#define FACTION_XENOMORPH "xeno"
#define FACTION_XENOMORPH_NORMAL "xenomorph"
#define FACTION_XENOMORPH_CORRUPTED "corrupted_xenomoprh"
#define FACTION_XENOMORPH_ALPHA "alpha_xenomorph"
#define FACTION_XENOMORPH_BRAVO "bravo_xenomorph"
#define FACTION_XENOMORPH_CHARLIE "charlie_xenomorph"
#define FACTION_XENOMORPH_DELTA "delta_xenomorph"
#define FACTION_XENOMORPH_FERAL "feral_xenomorph"
#define FACTION_XENOMORPH_FORSAKEN "forsaken_xenomorph"
#define FACTION_XENOMORPH_TAMED "tamed_xenomorph"
#define FACTION_XENOMORPH_MUTATED "mutated_xenomorph"
#define FACTION_XENOMORPH_YAUTJA "yautja_xenomorph"
#define FACTION_XENOMORPH_RENEGADE "renegade_xenomorph"

#define FACTION_LIST_MARINE			list(FACTION_USCM, FACTION_MARINE, FACTION_CMB, FACTION_MARSOC)
#define FACTION_LIST_WY				list(FACTION_WY, FACTION_PMC, FACTION_WY_DEATHSQUAD)
#define FACTION_LIST_HUMANOID		list(FACTION_NEUTRAL, FACTION_CONTRACTOR, FACTION_CLF, FACTION_UPP, FACTION_FREELANCER, FACTION_COLONIST, FACTION_MERCENARY, FACTION_DUTCH, FACTION_HEFA, FACTION_GLADIATOR, FACTION_PIRATE, FACTION_PIZZA, FACTION_SOUTO, FACTION_YAUTJA) + FACTION_LIST_MARINE + FACTION_LIST_WY
#define FACTION_LIST_XENOMORPH		list(FACTION_XENOMORPH_NORMAL, FACTION_XENOMORPH_CORRUPTED, FACTION_XENOMORPH_ALPHA, FACTION_XENOMORPH_BRAVO, FACTION_XENOMORPH_CHARLIE, FACTION_XENOMORPH_DELTA, FACTION_XENOMORPH_FERAL, FACTION_XENOMORPH_FORSAKEN, FACTION_XENOMORPH_TAMED, FACTION_XENOMORPH_MUTATED, FACTION_XENOMORPH_YAUTJA, FACTION_XENOMORPH_RENEGADE)
#define FACTION_LIST_ALL			FACTION_LIST_HUMANOID + FACTION_LIST_XENOMORPH
/// This is factions handle defcons
#define FACTION_LIST_DEFCONED		list(FACTION_USCM, FACTION_MARINE, FACTION_UPP)

//FACTIONS RELATIONS
#define RELATIONS_FACTION_NEUTRAL	list(FACTION_USCM = RELATIONS_NEUTRAL, FACTION_WY = RELATIONS_NEUTRAL, FACTION_UPP = RELATIONS_NEUTRAL, FACTION_CLF = RELATIONS_NEUTRAL, FACTION_COLONIST = RELATIONS_NEUTRAL, FACTION_RESS = RELATIONS_NEUTRAL, FACTION_TWE = RELATIONS_NEUTRAL, FACTION_MERCENARY = RELATIONS_NEUTRAL, FACTION_FREELANCER = RELATIONS_NEUTRAL, FACTION_THREEWE = RELATIONS_NEUTRAL)
#define RELATIONS_FACTION_USCM		list(FACTION_WY = RELATIONS_FRIENDLY, FACTION_UPP = RELATIONS_HOSTILE, FACTION_CLF = RELATIONS_HOSTILE, FACTION_COLONIST = RELATIONS_NEUTRAL, FACTION_RESS = RELATIONS_FRIENDLY, FACTION_TWE = RELATIONS_FRIENDLY, FACTION_MERCENARY = RELATIONS_NEUTRAL, FACTION_FREELANCER = RELATIONS_NEUTRAL, FACTION_THREEWE = RELATIONS_TENSE, FACTION_NEUTRAL = RELATIONS_NEUTRAL)
#define RELATIONS_FACTION_WY		list(FACTION_USCM = RELATIONS_FRIENDLY, FACTION_UPP = RELATIONS_NEUTRAL, FACTION_CLF = RELATIONS_HOSTILE, FACTION_COLONIST = RELATIONS_NEUTRAL, FACTION_RESS = RELATIONS_FRIENDLY, FACTION_TWE = RELATIONS_HOSTILE, FACTION_MERCENARY = RELATIONS_NEUTRAL, FACTION_FREELANCER = RELATIONS_NEUTRAL, FACTION_THREEWE = RELATIONS_NEUTRAL, FACTION_NEUTRAL = RELATIONS_NEUTRAL)
#define RELATIONS_FACTION_CLF		list(FACTION_USCM = RELATIONS_HOSTILE, FACTION_WY = RELATIONS_NEUTRAL, FACTION_UPP = RELATIONS_HOSTILE, FACTION_COLONIST = RELATIONS_NEUTRAL, FACTION_RESS = RELATIONS_HOSTILE, FACTION_TWE = RELATIONS_HOSTILE, FACTION_MERCENARY = RELATIONS_HOSTILE, FACTION_FREELANCER = RELATIONS_HOSTILE, FACTION_THREEWE = RELATIONS_HOSTILE, FACTION_NEUTRAL = RELATIONS_NEUTRAL)
#define RELATIONS_FACTION_UPP		list(FACTION_USCM = RELATIONS_HOSTILE, FACTION_WY = RELATIONS_FRIENDLY, FACTION_CLF = RELATIONS_HOSTILE, FACTION_COLONIST = RELATIONS_NEUTRAL, FACTION_RESS = RELATIONS_HOSTILE, FACTION_TWE = RELATIONS_FRIENDLY, FACTION_MERCENARY = RELATIONS_HOSTILE, FACTION_FREELANCER = RELATIONS_HOSTILE, FACTION_THREEWE = RELATIONS_HOSTILE, FACTION_NEUTRAL = RELATIONS_NEUTRAL)
#define RELATIONS_FACTION_XENOMORPH	list(FACTION_XENOMORPH_NORMAL = RELATIONS_HOSTILE, FACTION_XENOMORPH_CORRUPTED = RELATIONS_HOSTILE, FACTION_XENOMORPH_ALPHA = RELATIONS_HOSTILE, FACTION_XENOMORPH_BRAVO = RELATIONS_HOSTILE, FACTION_XENOMORPH_CHARLIE = RELATIONS_HOSTILE, FACTION_XENOMORPH_DELTA = RELATIONS_HOSTILE, FACTION_XENOMORPH_FERAL = RELATIONS_HOSTILE, FACTION_XENOMORPH_FORSAKEN = RELATIONS_HOSTILE, FACTION_XENOMORPH_TAMED = RELATIONS_HOSTILE, FACTION_XENOMORPH_MUTATED = RELATIONS_HOSTILE, FACTION_XENOMORPH_YAUTJA = RELATIONS_HOSTILE, FACTION_XENOMORPH_RENEGADE = RELATIONS_HOSTILE, FACTION_NEUTRAL = RELATIONS_NEUTRAL)

#define RELATIONS_MAP				list(FACTION_NEUTRAL = null, FACTION_USCM = null, FACTION_MARINE = null, FACTION_CMB = null, FACTION_MARSOC = null, FACTION_CONTRACTOR = null, FACTION_WY = null, FACTION_PMC = null, FACTION_WY_DEATHSQUAD = null, FACTION_CLF = null, FACTION_UPP = null, FACTION_FREELANCER = null, FACTION_COLONIST = null, FACTION_MERCENARY = null, FACTION_DUTCH = null, FACTION_HEFA = null, FACTION_GLADIATOR = null, FACTION_PIRATE = null, FACTION_PIZZA = null, FACTION_SOUTO = null, FACTION_YAUTJA = null, FACTION_XENOMORPH_NORMAL = null, FACTION_XENOMORPH_CORRUPTED = null, FACTION_XENOMORPH_ALPHA = null, FACTION_XENOMORPH_BRAVO = null, FACTION_XENOMORPH_CHARLIE = null, FACTION_XENOMORPH_DELTA = null, FACTION_XENOMORPH_FERAL = null, FACTION_XENOMORPH_FORSAKEN = null, FACTION_XENOMORPH_TAMED = null, FACTION_XENOMORPH_MUTATED = null, FACTION_XENOMORPH_YAUTJA = null)
#define RELATIONS_MAP_HOSTILE		list(FACTION_USCM = RELATIONS_HOSTILE, FACTION_WY = RELATIONS_HOSTILE, FACTION_UPP = RELATIONS_HOSTILE, FACTION_CLF = RELATIONS_HOSTILE, FACTION_COLONIST = RELATIONS_HOSTILE, FACTION_RESS = RELATIONS_HOSTILE, FACTION_TWE = RELATIONS_HOSTILE, FACTION_MERCENARY = RELATIONS_HOSTILE, FACTION_FREELANCER = RELATIONS_HOSTILE, FACTION_THREEWE = RELATIONS_HOSTILE, FACTION_XENOMORPH_NORMAL = RELATIONS_HOSTILE, FACTION_XENOMORPH_CORRUPTED = RELATIONS_HOSTILE, FACTION_XENOMORPH_ALPHA = RELATIONS_HOSTILE, FACTION_XENOMORPH_BRAVO = RELATIONS_HOSTILE, FACTION_XENOMORPH_CHARLIE = RELATIONS_HOSTILE, FACTION_XENOMORPH_DELTA = RELATIONS_HOSTILE, FACTION_XENOMORPH_FERAL = RELATIONS_HOSTILE, FACTION_XENOMORPH_FORSAKEN = RELATIONS_HOSTILE, FACTION_XENOMORPH_TAMED = RELATIONS_HOSTILE, FACTION_XENOMORPH_MUTATED = RELATIONS_HOSTILE, FACTION_XENOMORPH_YAUTJA = RELATIONS_HOSTILE, FACTION_NEUTRAL = RELATIONS_HOSTILE)

#define RELATIONS_UNKNOWN	null
#define RELATIONS_DISABLED	list(0, 0)
#define RELATIONS_WAR		list(1, 200)
#define RELATIONS_HOSTILE	list(201, 400)
#define RELATIONS_TENSE		list(401, 500)
#define RELATIONS_NEUTRAL	list(501, 700)
#define RELATIONS_FRIENDLY	list(701, 900)
#define RELATIONS_VERY_GOOD	list(901, 1000)
#define RELATIONS_SELF		1100
#define RELATIONS_MAX		1000

//FACTION TREES
#define SIDE_FACTION_NEUTRAL	"NEUTRAL_T"
#define SIDE_FACTION_USCM		"USCM_T"
#define SIDE_FACTION_WY			"W-Y_T"
#define SIDE_FACTION_CLF		"CLF_T"
#define SIDE_FACTION_UPP		"UPP_T"
#define SIDE_FACTION_ZOMBIE		"ZOMBIE_T"
#define SIDE_FACTION_YAUTJA		"YAUTJA_T"
#define SIDE_FACTION_XENOMORPH	"XENOMORPH_T"

#define SIDE_ORGANICAL_DOM		list(SIDE_FACTION_ZOMBIE, SIDE_FACTION_XENOMORPH)

#define SITREP_INTERVAL 15 MINUTES

//NAMES
#define NAME_FACTION_NEUTRAL "Neutral Faction"
//USCM
#define NAME_FACTION_USCM "United States Colonial Marines"
#define NAME_FACTION_MARINE "Colonial Marines"
#define NAME_FACTION_CMB "Colonial Marshal Bureau"
#define NAME_FACTION_MARSOC "Marine Special Operations Command"
//CONTRACTOR
#define NAME_FACTION_CONTRACTOR "Vanguard's Arrow Incorporated"
//WY
#define NAME_FACTION_WY "Weyland-Yutani"
#define NAME_FACTION_PMC "Private Military Company"
#define NAME_FACTION_WY_DEATHSQUAD "Corporate Commandos"
//UPP
#define NAME_FACTION_UPP "Union of Progressive Peoples"
//CLF
#define NAME_FACTION_CLF "Colonial Liberation Front"
//COLON
#define NAME_FACTION_COLONIST "Colonists"
//OTHER
#define NAME_FACTION_RESS "Royal Empire of the Shining Sun"
#define NAME_FACTION_TWE "Royal Marines Commando"
#define NAME_FACTION_MERCENARY "Mercenary Group"
#define NAME_FACTION_FREELANCER "Freelancer Mercenaries"
#define NAME_FACTION_HEFA "HEFA Knights"
#define NAME_FACTION_DUTCH "Dutch's Dozen"
#define NAME_FACTION_PIRATE "Pirates of Free Space"
#define NAME_FACTION_GLADIATOR "Gladiators"
#define NAME_FACTION_PIZZA "Pizza Galaxy"
#define NAME_FACTION_SOUTO "Souto Space"
#define NAME_FACTION_THREEWE "Three World Empire"
//ZOMBIE
#define NAME_FACTION_ZOMBIE "Zombie Horde"
//YAUTJA
#define NAME_FACTION_YAUTJA "Yautja Hanting Groop"
//XENOS
#define NAME_FACTION_XENOMORPH "Xenomorphs"
#define NAME_FACTION_XENOMORPH_NORMAL "Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_CORRUPTED "Corrupted Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_ALPHA "Alpha Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_BRAVO "Bravo Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_CHARLIE "Charlie Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_DELTA "Delta Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_FERAL "Feral Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_FORSAKEN "Forsaken Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_TAMED "Tamed Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_MUTATED "Mutated Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_YAUTJA "Yautja Xenomorph Hive"
#define NAME_FACTION_XENOMORPH_RENEGADE "Renegade Xenomorph Hive"

#define NAME_FACTION_LIST_MARINE		list(NAME_FACTION_USCM, NAME_FACTION_MARINE, NAME_FACTION_MARSOC)
#define NAME_FACTION_LIST_WY			list(NAME_FACTION_WY, NAME_FACTION_PMC, NAME_FACTION_WY_DEATHSQUAD)
#define NAME_FACTION_LIST_HUMANOID		list(NAME_FACTION_NEUTRAL, NAME_FACTION_CLF, NAME_FACTION_UPP, NAME_FACTION_FREELANCER, NAME_FACTION_COLONIST, NAME_FACTION_MERCENARY, NAME_FACTION_DUTCH, NAME_FACTION_HEFA, NAME_FACTION_GLADIATOR, NAME_FACTION_PIRATE, NAME_FACTION_PIZZA, NAME_FACTION_SOUTO, NAME_FACTION_ZOMBIE, NAME_FACTION_YAUTJA) + NAME_FACTION_LIST_MARINE + NAME_FACTION_LIST_WY
#define NAME_FACTION_LIST_XENOMORPH		list(NAME_FACTION_XENOMORPH_NORMAL, NAME_FACTION_XENOMORPH_CORRUPTED, NAME_FACTION_XENOMORPH_ALPHA, NAME_FACTION_XENOMORPH_BRAVO, NAME_FACTION_XENOMORPH_CHARLIE, NAME_FACTION_XENOMORPH_DELTA, NAME_FACTION_XENOMORPH_FERAL, NAME_FACTION_XENOMORPH_FORSAKEN, NAME_FACTION_XENOMORPH_TAMED, NAME_FACTION_XENOMORPH_MUTATED, NAME_FACTION_XENOMORPH_YAUTJA, NAME_FACTION_XENOMORPH_YAUTJA)
#define NAME_FACTION_LIST_ALL			NAME_FACTION_LIST_HUMANOID + NAME_FACTION_LIST_XENOMORPH

//ANNOUNCES
#define COMMAND_ANNOUNCE				"Command Announcement"
#define UPP_COMMAND_ANNOUNCE			"UPP Command Announcement"
#define CLF_COMMAND_ANNOUNCE			"CLF Command Announcement"
#define WY_COMMAND_ANNOUNCE				"WY Command Announcement"
#define QUEEN_ANNOUNCE					"The words of the Queen reverberate in your head..."
#define QUEEN_MOTHER_ANNOUNCE			"Queen Mother Psychic Directive"
#define XENO_GENERAL_ANNOUNCE			"You sense something unusual..."
#define YAUTJA_ANNOUNCE					"You receive a message from your ship AI..."
#define HIGHER_FORCE_ANNOUNCE 			SPAN_ANNOUNCEMENT_HEADER_BLUE("Unknown Higher Force")

//TASKS
#define FACTION_TASKS_DOMINATE			"Dominate"
#define FACTION_TASKS_DESTROY			"Destroy"
#define FACTION_TASKS_SECTOR_OCCUPY		"Occupy Sector"
#define FACTION_TASKS_SECTOR_PROTECT	"Protect Sector"
#define FACTION_TASKS_SECTOR_HOLD		"Hold Sector"
#define FACTION_TASKS_SECTOR_CONTROL	"Sector Control"
#define FACTION_TASKS_KILL				"Kill"
#define FACTION_TASKS_PROTECT			"Protect"
#define FACTION_TASKS_HOLD_TIME			"Hold Time"
#define FACTION_TASKS_LIST_ALL			list(FACTION_TASKS_DOMINATE, FACTION_TASKS_DESTROY, FACTION_TASKS_SECTOR_OCCUPY, FACTION_TASKS_SECTOR_PROTECT, FACTION_TASKS_SECTOR_CONTROL, FACTION_TASKS_PROTECT, FACTION_TASKS_KILL, FACTION_TASKS_HOLD_TIME)

// Faction allegiances within a certain faction.
#define FACTION_ALLEGIANCE_USCM_COMMANDER list("Doves", "Hawks", "Magpies", "Unaligned")
