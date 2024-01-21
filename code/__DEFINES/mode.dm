//=================================================
//Self-destruct, nuke, and evacuation.
#define EVACUATION_TIME_LOCK 			1 HOURS
#define DISTRESS_TIME_LOCK 				6 MINUTES
#define SHUTTLE_TIME_LOCK 				15 MINUTES
#define SHUTTLE_LOCK_COOLDOWN 			10 MINUTES
#define MONORAIL_LOCK_COOLDOWN			3 MINUTES
#define SHUTTLE_LOCK_TIME_LOCK 			1 MINUTES
#define EVACUATION_AUTOMATIC_DEPARTURE 	10 MINUTES //All pods automatically depart in 10 minutes, unless they are full or unable to launch for some reason.
#define EVACUATION_ESTIMATE_DEPARTURE 	(SSevacuation.evac_time + EVACUATION_AUTOMATIC_DEPARTURE - world.time)

#define EVACUATION_STATUS_STANDING_BY 0
#define EVACUATION_STATUS_INITIATING 1
#define EVACUATION_STATUS_IN_PROGRESS 2
#define EVACUATION_STATUS_COMPLETE 3

#define SHIP_EVACUATION_AUTOMATIC_DEPARTURE 5 MINUTES
#define SHIP_ESCAPE_ESTIMATE_DEPARTURE 	(ship_evac_time + SHIP_EVACUATION_AUTOMATIC_DEPARTURE - world.time)
#define NUCLEAR_TIME_LOCK 90 MINUTES

#define OPERATION_DECRYO 0
#define OPERATION_BRIEFING 1
#define OPERATION_FIRST_LANDING 2
#define OPERATION_IN_PROGRESS 3
#define OPERATION_ENDING 4
#define OPERATION_LEAVING_OPERATION_PLACE 5
#define OPERATION_DEBRIEFING 6
#define OPERATION_CRYO 7

#define NUKE_EXPLOSION_INACTIVE 0
#define NUKE_EXPLOSION_ACTIVE 1
#define NUKE_EXPLOSION_IN_PROGRESS 2
#define NUKE_EXPLOSION_FINISHED 4
#define NUKE_EXPLOSION_GROUND_FINISHED 8

#define FLAGS_EVACUATION_DENY 1
#define FLAGS_SELF_DESTRUCT_DENY 2

#define LIFEBOAT_LOCKED -1
#define LIFEBOAT_INACTIVE 0
#define LIFEBOAT_ACTIVE 1

#define ESCAPE_STATE_IDLE			4 //Pod is idle, not ready to launch.
#define ESCAPE_STATE_BROKEN			5 //Pod failed to launch, is now broken.
#define ESCAPE_STATE_READY			6 //Pod is armed and ready to go.
#define ESCAPE_STATE_DELAYED		7 //Pod is being delayed from launching automatically.
#define ESCAPE_STATE_LAUNCHING		8 //Pod is about to launch.
#define ESCAPE_STATE_LAUNCHED		9 //Pod has successfully launched.

#define XENO_ROUNDSTART_PROGRESS_AMOUNT 			2
#define XENO_ROUNDSTART_PROGRESS_TIME_1 			0
#define XENO_ROUNDSTART_PROGRESS_TIME_2 			15 MINUTES

#define ROUND_TIME (world.time - SSticker.round_start_time)

//=================================================

#define MODE_NAME_EXTENDED			"Extended"
#define MODE_NAME_DISTRESS_SIGNAL	"Distress Signal"
#define MODE_NAME_FACTION_CLASH		"Faction Clash"
#define MODE_NAME_HUMAN_WARS		"HvH Event (test)"
#define MODE_NAME_CRASH				"Crash"
#define MODE_NAME_BATTLE_FIELD		"Battle Field"
#define MODE_NAME_WISKEY_OUTPOST	"Whiskey Outpost"
#define MODE_NAME_HUNTER_GAMES		"Hunter Games"
#define MODE_NAME_HIVE_WARS			"Hive Wars"
#define MODE_NAME_INFECTION			"Infection"

//=================================================

#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/"+(MODE))))

#define MODE_HAS_FLAG(flag) (SSticker?.mode?.flags_round_type & flag)
#define MODE_HAS_TOGGLEABLE_FLAG(flag) (SSticker?.mode?.toggleable_flags & flag)

// Gamemode Flags
#define MODE_INFESTATION		(1<<0)
#define MODE_PREDATOR			(1<<1)
#define MODE_NO_LATEJOIN		(1<<2)
#define MODE_HAS_FINISHED		(1<<3)
#define MODE_FOG_ACTIVATED		(1<<4)
#define MODE_INFECTION			(1<<5)
#define MODE_HUMAN_ANTAGS		(1<<6)
/// Disables marines from spawning in normally
#define MODE_NO_SPAWN			(1<<7)
/// Affects several castes for XvX, as well as other things (e.g. spawnpool)
#define MODE_XVX				(1<<8)
/// Enables the new spawning, only works for Distress currently
#define MODE_NEW_SPAWN			(1<<9)
#define MODE_DS_LANDED			(1<<10)
#define MODE_BASIC_RT			(1<<11)
/// Makes Join-as-Xeno choose a hive to join as pooled larva at random rather than at user's input..
#define MODE_RANDOM_HIVE		(1<<12)
/// Disables scopes, sniper sentries, OBs, shooting corpses, dragging enemy corpses, stripping enemy corpses
#define MODE_HVH_BALANCE		(1<<13)
#define MODE_NO_SHIP_MAP		(1<<14)
#define MODE_HARDCORE			(1<<15)

// Gamemode Toggleable Flags
#define MODE_NO_SNIPER_SENTRY (1<<0) /// Upgrade kits will no longer allow you to select long-range upgrades
#define MODE_NO_ATTACK_DEAD (1<<1) /// People will not be able to shoot at corpses
#define MODE_NO_STRIPDRAG_ENEMY (1<<2) /// Can't strip or drag dead enemies
#define MODE_STRIP_NONUNIFORM_ENEMY (1<<3) /// Can strip enemy, but not their boots, uniform, armor, helmet, or ID
#define MODE_STRONG_DEFIBS (1<<4) /// Defibs Ignore Armor
#define MODE_BLOOD_OPTIMIZATION (1<<5) /// Blood spawns without a dry timer, and do not cause footprints
#define MODE_NO_COMBAT_CAS (1<<6) /// Prevents POs and DCCs from creating combat CAS equipment
#define MODE_LZ_PROTECTION (1<<7) /// Prevents the LZ from being mortared
#define MODE_SHIPSIDE_SD (1<<8) /// Toggles whether Predators can big SD when not on the groundmap
#define MODE_HARDCORE_PERMA (1<<9) /// Toggles Hardcore for all marines, meaning they instantly perma upon death
#define MODE_DISPOSABLE_MOBS (1<<10) // Toggles if mobs fit in disposals or not. Off by default.
#define MODE_BYPASS_JOE (1<<11) // Toggles if ghosts can bypass Working Joe spawn limitations, does NOT bypass WL requirement. Off by default.

#define ROUNDSTATUS_FOG_DOWN 1
#define ROUNDSTATUS_PODDOORS_OPEN 2

#define LATEJOIN_MARINES_PER_LATEJOIN_LARVA 4

//=================================================
#define SHOW_ITEM_ANIMATIONS_NONE 0 //Do not show any item pickup animations
#define SHOW_ITEM_ANIMATIONS_HALF 1 //Toggles tg-style item animations on and off, default on.
#define SHOW_ITEM_ANIMATIONS_ALL 2 //Toggles being able to see animations that occur on the same tile.
//=================================================

//=================================================
#define PAIN_OVERLAY_BLURRY 0 //Blurs your screen a varying amount depending on eye_blur.
#define PAIN_OVERLAY_IMPAIR 1 //Impairs your screen like a welding helmet does depending on eye_blur.
#define PAIN_OVERLAY_LEGACY 2 //Creates a legacy blurring effect over your screen if you have any eye_blur at all. Not recommended.
//=================================================


//Number of marine players against which the Marine's gear scales
#define MARINE_GEAR_SCALING_NORMAL 30

#define RESOURCE_NODE_SCALE 95 //How many players minimum per extra set of resource nodes
#define RESOURCE_NODE_QUANTITY_PER_POP 11 //How many resources total per pop
#define RESOURCE_NODE_QUANTITY_MINIMUM 1120 //How many resources at the minimum

//=================================================

#define ROLE_ADMIN_NOTIFY (1<<0)
#define ROLE_ADD_TO_SQUAD (1<<1)
#define ROLE_WHITELISTED (1<<2)
#define ROLE_NO_ACCOUNT (1<<3)
#define ROLE_CUSTOM_SPAWN (1<<4)
//=================================================

//Role defines, specifically lists of roles for job bans, crew manifests and the like.
#define ROLES_COMMAND		list(JOB_CO, JOB_XO, JOB_SO, JOB_AUXILIARY_OFFICER, JOB_INTEL, JOB_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_CREWMAN, JOB_POLICE, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_CHIEF_REQUISITION, JOB_CHIEF_ENGINEER, JOB_CMO, JOB_CHIEF_POLICE, JOB_SEA, JOB_SYNTH, JOB_WARDEN)

#define ROLES_OFFICERS		list(JOB_CO, JOB_XO, JOB_SO, JOB_AUXILIARY_OFFICER, JOB_INTEL, JOB_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_CREWMAN, JOB_SEA, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_SYNTH, JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE)
#define ROLES_CIC			list(JOB_CO, JOB_XO, JOB_SO, JOB_WO_CO, JOB_WO_XO, JOB_CRASH_CO, JOB_CRASH_SYNTH)
#define ROLES_AUXIL_SUPPORT	list(JOB_AUXILIARY_OFFICER, JOB_INTEL, JOB_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_CREWMAN, JOB_WO_CHIEF_POLICE, JOB_WO_SO, JOB_WO_CREWMAN, JOB_WO_POLICE, JOB_WO_PILOT)
#define ROLES_MISC			list(JOB_SYNTH, JOB_WORKING_JOE, JOB_SEA, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_MESS_SERGEANT, JOB_COMBAT_REPORTER_CORPORATE_LIAISON, JOB_WO_SYNTH)
#define ROLES_POLICE		list(JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE)
#define ROLES_ENGINEERING 	list(JOB_CHIEF_ENGINEER, JOB_ORDNANCE_TECH, JOB_MAINT_TECH, JOB_WO_CHIEF_ENGINEER, JOB_WO_ORDNANCE_TECH, JOB_CRASH_CHIEF_ENGINEER)
#define ROLES_REQUISITION 	list(JOB_CHIEF_REQUISITION, JOB_CARGO_TECH, JOB_WO_CHIEF_REQUISITION, JOB_WO_REQUISITION)
#define ROLES_MEDICAL		list(JOB_CMO, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE, JOB_WO_CMO, JOB_WO_RESEARCHER, JOB_WO_DOCTOR, JOB_CRASH_CMO)
#define ROLES_MARINES		list(JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE)
#define ROLES_SQUAD_ALL		list(SQUAD_MARINE_1, SQUAD_MARINE_2, SQUAD_MARINE_3, SQUAD_MARINE_4, SQUAD_MARINE_5, SQUAD_MARINE_6, SQUAD_MARINE_7)

#define ROLES_REGULAR_USCM	list(JOB_CO, JOB_XO, JOB_SO, JOB_INTEL, JOB_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_CREWMAN, JOB_POLICE, JOB_CORPORATE_LIAISON, JOB_CHIEF_REQUISITION, JOB_CHIEF_ENGINEER, JOB_CMO, JOB_CHIEF_POLICE, JOB_SEA, JOB_SYNTH, JOB_WARDEN, JOB_ORDNANCE_TECH, JOB_MAINT_TECH, JOB_WORKING_JOE, JOB_MESS_SERGEANT, JOB_CARGO_TECH, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE, JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE)
#define ROLES_REGULAR_XENO	list(JOB_XENOMORPH_QUEEN, JOB_XENOMORPH)
#define ROLES_REGULAR_SURV	list(JOB_SYNTH_SURVIVOR, JOB_CO_SURVIVOR, JOB_SURVIVOR)
#define ROLES_REGULAR_YAUT	list(JOB_PREDATOR)

#define ROLES_WO_USCM		list(JOB_WO_CO, JOB_WO_XO, JOB_COMBAT_REPORTER_CORPORATE_LIAISON, JOB_WO_SYNTH, JOB_WO_CHIEF_POLICE, JOB_WO_SO, JOB_WO_CREWMAN, JOB_WO_POLICE, JOB_WO_PILOT, JOB_WO_CHIEF_ENGINEER, JOB_WO_ORDNANCE_TECH, JOB_WO_CHIEF_REQUISITION, JOB_WO_REQUISITION, JOB_WO_CMO, JOB_WO_DOCTOR, JOB_WO_RESEARCHER, JOB_WO_SQUAD_MARINE, JOB_WO_SQUAD_MEDIC, JOB_WO_SQUAD_ENGINEER, JOB_WO_SQUAD_SMARTGUNNER, JOB_WO_SQUAD_SPECIALIST, JOB_WO_SQUAD_LEADER)
#define ROLES_CRASH_USCM	list(JOB_CRASH_CO, JOB_CRASH_SYNTH, JOB_CRASH_CHIEF_ENGINEER, JOB_CRASH_CMO, JOB_CRASH_SQUAD_MARINE, JOB_CRASH_SQUAD_SPECIALIST, JOB_CRASH_SQUAD_SMARTGUNNER, JOB_CRASH_SQUAD_MEDIC, JOB_CRASH_SQUAD_ENGINEER, JOB_CRASH_SQUAD_MARINE)
#define ROLES_HVH_USCM		list(JOB_CO, JOB_XO, JOB_SO, JOB_INTEL, JOB_CREWMAN, JOB_POLICE, JOB_CORPORATE_LIAISON, JOB_CMO, JOB_CHIEF_POLICE, JOB_SEA, JOB_SYNTH, JOB_WARDEN, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE, JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE)

#define ROLES_REGULAR_ALL	ROLES_REGULAR_USCM + ROLES_REGULAR_XENO + ROLES_REGULAR_SURV + ROLES_REGULAR_YAUT

//Role lists used for switch() checks in show_blurb_uscm(). Cosmetic, determines ex. "Engineering, USS Almayer", "2nd Bat. 'Falling Falcons'" etc.
#define BLURB_USCM_COMBAT	JOB_CO, JOB_XO, JOB_SO, JOB_INTEL, JOB_CREWMAN, JOB_SEA, JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE
#define BLURB_USCM_FLIGHT	JOB_PILOT, JOB_DROPSHIP_CREW_CHIEF
#define BLURB_USCM_MP		JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE
#define BLURB_USCM_ENGI		JOB_CHIEF_ENGINEER, JOB_ORDNANCE_TECH, JOB_MAINT_TECH, JOB_CRASH_CHIEF_ENGINEER
#define BLURB_USCM_MEDICAL	JOB_CMO, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE
#define BLURB_USCM_REQ		JOB_CHIEF_REQUISITION, JOB_CARGO_TECH
#define BLURB_USCM_WY		JOB_CORPORATE_LIAISON, JOB_UPP_CORPORATE_LIAISON

//=================================================

#define WHITELIST_NORMAL	"Normal"
#define WHITELIST_COUNCIL	"Council"
#define WHITELIST_LEADER	"Leader"

#define WHITELIST_HIERARCHY	list(WHITELIST_NORMAL, WHITELIST_COUNCIL, WHITELIST_LEADER)

//=================================================
#define WHITELIST_YAUTJA (1<<0)
#define WHITELIST_YAUTJA_COUNCIL (1<<1)
#define WHITELIST_YAUTJA_LEADER (1<<2)
#define WHITELIST_PREDATOR (WHITELIST_YAUTJA|WHITELIST_YAUTJA_COUNCIL|WHITELIST_YAUTJA_LEADER)

#define WHITELIST_COMMANDER (1<<3)
#define WHITELIST_COMMANDER_COUNCIL (1<<4)
#define WHITELIST_COMMANDER_LEADER (1<<5)

#define WHITELIST_JOE (1<<6)
#define WHITELIST_SYNTHETIC (1<<7)
#define WHITELIST_SYNTHETIC_COUNCIL (1<<8)
#define WHITELIST_SYNTHETIC_LEADER (1<<9)

#define WHITELIST_MENTOR (1<<10)
#define WHITELISTS_GENERAL (WHITELIST_YAUTJA|WHITELIST_COMMANDER|WHITELIST_SYNTHETIC|WHITELIST_MENTOR|WHITELIST_JOE)
#define WHITELISTS_COUNCIL (WHITELIST_YAUTJA_COUNCIL|WHITELIST_COMMANDER_COUNCIL|WHITELIST_SYNTHETIC_COUNCIL)
#define WHITELISTS_LEADER (WHITELIST_YAUTJA_LEADER|WHITELIST_COMMANDER_LEADER|WHITELIST_SYNTHETIC_LEADER)

#define WHITELIST_EVERYTHING (WHITELISTS_GENERAL|WHITELISTS_COUNCIL|WHITELISTS_LEADER)

#define isCouncil(A) (A?.player_data?.whitelist.whitelist_flags & (WHITELIST_YAUTJA_COUNCIL | WHITELIST_SYNTHETIC_COUNCIL | WHITELIST_COMMANDER_COUNCIL))

//=================================================

// Objective priorities
#define OBJECTIVE_NO_VALUE 0
#define OBJECTIVE_LOW_VALUE 25
#define OBJECTIVE_MEDIUM_VALUE 76
#define OBJECTIVE_HIGH_VALUE 150
#define OBJECTIVE_EXTREME_VALUE 300
#define OBJECTIVE_ABSOLUTE_VALUE 600
#define OBJECTIVE_POWER_VALUE 5

// Objective states
#define OBJECTIVE_INACTIVE		(1<<0)
#define OBJECTIVE_ACTIVE		(1<<1)
#define OBJECTIVE_IN_PROGRESS	(1<<2)
#define OBJECTIVE_COMPLETE		(1<<3)
#define OBJECTIVE_FAILED		(1<<4)

// Functionality flags
#define OBJECTIVE_DO_NOT_TREE (1<<0) // Not part of the 'clue' tree
#define OBJECTIVE_DEAD_END (1<<1) // Should this objective unlock zero clues?
#define OBJECTIVE_START_PROCESSING_ON_DISCOVERY (1<<2) // Should this objective process() every subsystem 'tick' once its breadcrumb trail of clues have been finished?
#define OBJECTIVE_DISPLAY_AT_END (1<<3)
#define OBJECTIVE_OBSERVABLE (1<<4)
#define OBJECTIVE_NO_FACTION_LINK (1<<5)

#define CLUE_OBJECTIVE 70
#define CLUE_CLOSE 50
#define CLUE_MEDIUM 25
#define CLUE_FAR 15
#define CLUE_SCIENCE 10

#define REWARD_COST_CHEAP 1
#define REWARD_COST_MODERATE 2
#define REWARD_COST_PRICEY 4
#define REWARD_COST_EXPENSIVE 6
#define REWARD_COST_LUDICROUS 10
#define REWARD_COST_MAX 12

#define REWARD_POINT_GAIN_PER_LEVEL 2

//=================================================

#define CRASH_POP_LOCK 25
// global vars to prevent spam of the "one xyz alive" messages

var/global/last_ares_callout

var/global/last_qm_callout
