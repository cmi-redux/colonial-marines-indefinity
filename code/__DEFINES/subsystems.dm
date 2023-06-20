//! Defines for subsystems and overlays
//!
//! Lots of important stuff in here, make sure you have your brain switched on
//! when editing this file

//! ## Timing subsystem
/**
* Don't run if there is an identical unique timer active
*
* if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer,
* and returns the id of the existing timer
*/
#define TIMER_UNIQUE (1<<0)

///For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE (1<<1)

/**
* Timing should be based on how timing progresses on clients, not the server.
*
* Tracking this is more expensive,
* should only be used in conjuction with things that have to progress client side, such as
* animate() or sound()
*/
#define TIMER_CLIENT_TIME (1<<2)

///Timer can be stopped using deltimer()
#define TIMER_STOPPABLE (1<<3)

///prevents distinguishing identical timers with the wait variable
///
///To be used with TIMER_UNIQUE
#define TIMER_NO_HASH_WAIT (1<<4)

///Loops the timer repeatedly until qdeleted
///
///In most cases you want a subsystem instead, so don't use this unless you have a good reason
#define TIMER_LOOP (1<<5)

///Delete the timer on parent datum Destroy() and when deltimer'd
#define TIMER_DELETE_ME (1<<6)

///Empty ID define
#define TIMER_ID_NULL -1

/// Used to trigger object removal from a processing list
#define PROCESS_KILL 26

//! ## Initialization subsystem

///New should not call Initialize
#define INITIALIZATION_INSSATOMS 0
///New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_MAPLOAD 2
///New should call Initialize(FALSE)
#define INITIALIZATION_INNEW_REGULAR 1

#define INIT_ANNOUNCE(X) to_chat(world, "<span class='notice'>[X]</span>"); log_world(X)

///type and all subtypes should always immediately call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
    ..();\
    if(!(flags_atom & INITIALIZED)) {\
        args[1] = TRUE;\
        SSatoms.InitAtom(src, FALSE, args);\
    }\
}

// Subsystem defines.
// All in one file so it's easier to see what everything is relative to.


#define SS_INIT_TICKER_SPAWN		999
#define SS_INIT_TIMER				100
#define SS_INIT_INPUT				95
#define SS_INIT_FAIL_TO_TOPIC		90
#define SS_INIT_TOPIC				85
#define SS_INIT_RUST				80
#define SS_INIT_OVERLAY				75
#define SS_INIT_SUPPLY_SHUTTLE		70
#define SS_INIT_GARBAGE				65
#define SS_INIT_JOB					60
#define SS_INIT_DATABASE			55
#define SS_INIT_ENTITYMANAGER		50
#define SS_INIT_TICKER				45
#define SS_INIT_PLAYTIME			44
#define SS_INIT_EVENTS				43
#define SS_INIT_REDIS				42
#define SS_INIT_REAGENTS			41
#define SS_INIT_MAPPING				40
#define SS_INIT_PREF_LOGGING		39
#define SS_INIT_DONATORS			35
#define SS_INIT_NIGHTMARE			34
#define SS_INIT_PLANT				33
#define SS_INIT_TIMETRACK			32
#define SS_INIT_HUMANS				31
#define SS_INIT_MAP					30
#define SS_INIT_COMPONENT			25
#define SS_INIT_POWER				24
#define SS_INIT_OBJECT				23
#define SS_INIT_PIPENET				22
#define SS_INIT_XENOARCH			21
#define SS_INIT_MORE_INIT			20
#define SS_INIT_AIR					15
#define SS_INIT_TELEPORTER			10
#define SS_INIT_LIGHTING			9
#define SS_INIT_DEFCON				8
#define SS_INIT_LAW					7
#define SS_INIT_FZ_TRANSITIONS		6
#define SS_INIT_QUADTREE			5
#define SS_INIT_ATOMS				4
#define SS_INIT_DECORATOR			3
#define SS_INIT_SHUTTLE				2
#define SS_INIT_LANDMARK			1
#define SS_INIT_PROJECTILES			0
#define SS_INIT_MACHINES			-1
#define SS_INIT_RADIO				-2
#define SS_INIT_UNSPECIFIED			-3
#define SS_INIT_EMERGENCY_SHUTTLE	-20
#define SS_INIT_MAPVIEW				-21
#define SS_INIT_ASSETS				-22
#define SS_INIT_VOTE				-23
#define SS_INIT_FINISH				-24
#define SS_INIT_ADMIN				-26
#define SS_INIT_PREDSHIPS			-30
#define SS_INIT_OBJECTIVES			-31
#define SS_INIT_TASKS				-32
#define SS_INIT_LOBBYART			-33
#define SS_INIT_ICON_SMOOTHING		-34
#define SS_INIT_STATPANELS			-98
#define SS_INIT_QUEUE				-99
#define SS_INIT_CHAT				-100 //Should be last to ensure chat remains smooth during init.
#define SS_INIT_EARLYRUNTIMES		-500

#define SS_PRIORITY_INPUT			1000
#define SS_PRIORITY_SOUNDLOOPS		800
#define SS_PRIORITY_TIMER			700
#define SS_PRIORITY_OVERLAYS		500
#define SS_PRIORITY_SOUND			250
#define SS_PRIORITY_TICKER			200
#define SS_PRIORITY_NIGHTMARE		180
#define SS_PRIORITY_MAPVIEW			170
#define SS_PRIORITY_QUADTREE		160
#define SS_PRIORITY_CHAT			155
#define SS_PRIORITY_STATPANEL		154
#define SS_PRIORITY_PROJECTILES		152
#define SS_PRIORITY_CELLAUTO		151
#define SS_PRIORITY_MOB				150
#define SS_PRIORITY_XENO			149
#define SS_PRIORITY_HUMAN			148
#define SS_PRIORITY_STAMINA			126
#define SS_PRIORITY_COMPONENT		125
#define SS_PRIORITY_NANOUI			120
#define SS_PRIORITY_TGUI			120
#define SS_PRIORITY_HIVE_STATUS		112
#define SS_PRIORITY_SHIELD_PILLAR	111
#define SS_PRIORITY_VOTE			110
#define SS_PRIORITY_FAST_OBJECTS	105
#define SS_PRIORITY_OBJECTS			104
#define SS_PRIORITY_FACEHUGGERS		100
#define SS_PRIORITY_DECORATOR		99
#define SS_PRIORITY_POWER			95
#define SS_PRIORITY_EFFECTS			92
#define SS_PRIORITY_MACHINERY		90
#define SS_PRIORITY_FZ_TRANSITIONS	88
#define SS_PRIORITY_ROUND_RECORDING	83
#define SS_PRIORITY_PIPENET			85
#define SS_PRIORITY_SHUTTLE			80
#define SS_PRIORITY_TELEPORTER		75
#define SS_PRIORITY_EVENT			65
#define SS_PRIORITY_DATABASE		64
#define SS_PRIORITY_BALANCER		63
#define SS_PRIORITY_PARALLAX		62
#define SS_PRIORITY_DISEASE			60
#define SS_PRIORITY_FAST_MACHINERY	55
#define SS_PRIORITY_MIDI			40
#define SS_PRIORITY_ENTITY			37
#define SS_PRIORITY_DONATERS		36
#define SS_PRIORITY_DEFCON			35
#define SS_PRIORITY_ACID_PILLAR		34
#define SS_PRIORITY_UNSPECIFIED		30
#define SS_PRIORITY_PROCESS			25
#define SS_PRIORITY_SOUNDSCAPE		24
#define SS_PRIORITY_PAGER_STATUS	22
#define SS_PRIORITY_LIGHTING		20
#define SS_PRIORITY_TRACKING		19
#define SS_PRIORITY_PING			10
#define SS_PRIORITY_SMOOTHING		9
#define SS_PRIORITY_SUNLIGHTING		8
#define SS_PRIORITY_EVAC			7
#define SS_PRIORITY_PLAYTIME		6
#define SS_PRIORITY_PERFLOGGING		5
#define SS_PRIORITY_QUEUE			4
#define SS_PRIORITY_CORPSESPAWNER	3
#define SS_PRIORITY_GARBAGE			2
#define SS_PRIORITY_INACTIVITY		1
#define SS_PRIORITY_ADMIN			0


#define INITIALIZE_HINT_NORMAL		0  //Nothing happens
#define INITIALIZE_HINT_LATELOAD	1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL		2  //Call qdel on the atom
#define INITIALIZE_HINT_ROUNDSTART	3  //Call LateInitialize on roundstart

//! ### SS initialization hints
/**
 * Negative values incidate a failure or warning of some kind, positive are good.
 * 0 and 1 are unused so that TRUE and FALSE are guarenteed to be invalid values.
 */

/// Subsystem failed to initialize entirely. Print a warning, log, and disable firing.
#define SS_INIT_FAILURE -2

/// The default return value which must be overriden. Will succeed with a warning.
#define SS_INIT_NONE -1

/// Subsystem initialized sucessfully.
#define SS_INIT_SUCCESS 2

/// Successful, but don't print anything. Useful if subsystem was disabled.
#define SS_INIT_NO_NEED 3

// SS runlevels

#define RUNLEVEL_INIT 0
#define RUNLEVEL_LOBBY 1
#define RUNLEVEL_SETUP 2
#define RUNLEVEL_GAME 4
#define RUNLEVEL_POSTGAME 8

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)


#define COMPILE_OVERLAYS(A) \
	do {\
		var/list/ad = A.add_overlays;\
		var/list/rm = A.remove_overlays;\
		var/list/po = A.priority_overlays;\
		if(length(rm)){\
			A.overlays -= rm;\
			rm.Cut();\
		}\
		if(length(ad)){\
			A.overlays |= ad;\
			ad.Cut();\
		}\
		if(length(po)){\
			A.overlays |= po;\
		}\
		A.flags_atom &= ~OVERLAY_QUEUED;\
	} while (FALSE)

//SSticker.current_state values
/// Game is loading
#define GAME_STATE_STARTUP 0
/// Game is loaded and in pregame lobby
#define GAME_STATE_PREGAME 1
/// Game is attempting to start the round
#define GAME_STATE_SETTING_UP 2
/// Game has round in progress
#define GAME_STATE_PLAYING 3
/// Game has round finished
#define GAME_STATE_FINISHED 4

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
	* * timer_subsystem the subsystem to insert this timer into
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)

/// The timer key used to know how long subsystem initialization takes
#define SS_INIT_TIMER_KEY "ss_init"
