/obj/effect/landmark
	name = "landmark"
	icon = 'icons/landmarks.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE
	layer = TURF_LAYER
	plane = GAME_PLANE
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/New()
	tag = "landmark*[name]"
	return ..()

/obj/effect/landmark/Initialize(mapload, ...)
	. = ..()
	GLOB.landmarks_list += src

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/newplayer_start
	name = "New Player Start"

/obj/effect/landmark/newplayer_start/New() // this must be New()
	. = ..()
	GLOB.newplayer_start += src

/obj/effect/landmark/newplayer_start/Destroy()
	GLOB.newplayer_start -= src
	return ..()

/obj/effect/landmark/sim_target
	name = "simulator_target"

/obj/effect/landmark/sim_target/Initialize(mapload, ...)
	. = ..()
	GLOB.simulator_targets += src

/obj/effect/landmark/sim_target/Destroy()
	GLOB.simulator_targets -= src
	return ..()

/obj/effect/landmark/sim_camera
	name = "simulator_camera"
	color = "#FFFF00"

/obj/effect/landmark/sim_camera/Initialize(mapload, ...)
	. = ..()
	GLOB.simulator_cameras += src

/obj/effect/landmark/sim_camera/Destroy()
	GLOB.simulator_cameras -= src
	return ..()

/obj/effect/landmark/observer_start
	name = "Observer Landmark"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost1"

/obj/effect/landmark/observer_start/Initialize()
	. = ..()
	GLOB.observer_starts += src

/obj/effect/landmark/observer_start/Destroy()
	GLOB.observer_starts -= src
	return ..()

/obj/effect/landmark/ert_spawns/Initialize(mapload, ...)
	. = ..()
	LAZYADD(GLOB.ert_spawns[type], src)

/obj/effect/landmark/ert_spawns/Destroy()
	LAZYREMOVE(GLOB.ert_spawns[type], src)
	return ..()

// Nightmare insert locations
/obj/effect/landmark/nightmare
	name = "Nightmare Insert"
	icon_state = "nightmare_insert"
	var/insert_tag // Identifier for global mapping
	var/replace = FALSE    // Replace another existing landmark mapping of same name
	var/autoremove = TRUE  // Delete mapped turf when landmark is deleted, such as by an insert in replace mode
/obj/effect/landmark/nightmare/Initialize(mapload, ...)
	. = ..()
	if(!insert_tag) return
	if(!replace && GLOB.nightmare_landmarks[insert_tag])
		return
	GLOB.nightmare_landmarks[insert_tag] = get_turf(src)
/obj/effect/landmark/nightmare/Destroy()
	if(insert_tag && autoremove \
	   && GLOB.nightmare_landmarks[insert_tag] == get_turf(src))
		GLOB.nightmare_landmarks.Remove(insert_tag)
	return ..()

/obj/effect/landmark/ert_spawns/distress
	name = "Distress"

/obj/effect/landmark/ert_spawns/distress/item
	name = "DistressItem"

/obj/effect/landmark/ert_spawns/distress_wo
	name = "distress_wo"

/obj/effect/landmark/ert_spawns/groundside_xeno
	name = "distress_groundside_xeno"

/obj/effect/landmark/monkey_spawn
	name = "monkey_spawn"
	icon_state = "monkey_spawn"

/obj/effect/landmark/monkey_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.monkey_spawns += src

/obj/effect/landmark/monkey_spawn/Destroy()
	GLOB.monkey_spawns -= src
	return ..()

/obj/effect/landmark/thunderdome/one
	name = "Thunderdome Team 1"
	icon_state = "thunderdome_t1"

/obj/effect/landmark/thunderdome/one/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_one += src

/obj/effect/landmark/thunderdome/one/Destroy()
	GLOB.thunderdome_one -= src
	return ..()

/obj/effect/landmark/thunderdome/two
	name = "Thunderdome Team 2"
	icon_state = "thunderdome_t2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_two += src

/obj/effect/landmark/thunderdome/two/Destroy()
	GLOB.thunderdome_two-= src
	return ..()

/obj/effect/landmark/thunderdome/admin
	name = "Thunderdome Admin"
	icon_state = "thunderdome_admin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_admin += src

/obj/effect/landmark/thunderdome/admin/Destroy()
	GLOB.thunderdome_admin -= src
	return ..()

/obj/effect/landmark/thunderdome/observer
	name = "Thunderdome Observer"
	icon_state = "thunderdome_observer"

/obj/effect/landmark/thunderdome/observer/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_observer += src

/obj/effect/landmark/thunderdome/observer/Destroy()
	GLOB.thunderdome_observer -= src
	return ..()

/obj/effect/landmark/queen_spawn
	name = "queen spawn"
	icon_state = "queen_spawn"

/obj/effect/landmark/queen_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.queen_spawns += src

/obj/effect/landmark/queen_spawn/Destroy()
	GLOB.queen_spawns -= src
	return ..()

/obj/effect/landmark/xeno_spawn
	name = "xeno spawn"
	icon_state = "xeno_spawn"

/obj/effect/landmark/xeno_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_spawns += src

/obj/effect/landmark/xeno_spawn/Destroy()
	GLOB.xeno_spawns -= src
	return ..()

/obj/effect/landmark/xeno_hive_spawn
	name = "xeno hive spawn"
	icon_state = "hive_spawn"

/obj/effect/landmark/xeno_hive_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_hive_spawns += src

/obj/effect/landmark/xeno_hive_spawn/Destroy()
	GLOB.xeno_hive_spawns -= src
	return ..()

/obj/effect/landmark/yautja_teleport
	name = "yautja_teleport"
	/// The index we registered as in mainship_yautja_desc or yautja_teleport_descs
	var/desc_index

/obj/effect/landmark/yautja_teleport/Initialize(mapload, ...)
	. = ..()
	var/turf/turf = get_turf(src)
	desc_index = turf.loc.name + turf.loc_to_string()
	if(is_mainship_level(z))
		GLOB.mainship_yautja_teleports += src
		GLOB.mainship_yautja_desc[desc_index] = src
	else
		GLOB.yautja_teleports += src
		GLOB.yautja_teleport_descs[desc_index] = src

/obj/effect/landmark/yautja_teleport/Destroy()
	GLOB.mainship_yautja_teleports -= src
	GLOB.yautja_teleports -= src
	GLOB.mainship_yautja_desc -= desc_index
	GLOB.yautja_teleport_descs -= desc_index
	return ..()



/obj/effect/landmark/start
	name = "start"
	icon_state = "x"
	anchored = TRUE
	var/job
	var/squad

/obj/effect/landmark/start/Initialize(mapload, ...)
	. = ..()
	if(job)
		if(squad)
			LAZYINITLIST(GLOB.spawns_by_squad_and_job[squad])
			LAZYADD(GLOB.spawns_by_squad_and_job[squad][job], src)
		else
			LAZYADD(GLOB.spawns_by_job[job], src)

/obj/effect/landmark/start/Destroy()
	if(job)
		if(squad)
			LAZYREMOVE(GLOB.spawns_by_squad_and_job[squad][job], src)
		else
			LAZYREMOVE(GLOB.spawns_by_job[job], src)
	return ..()

/obj/effect/landmark/start/AISloc
	name = "AI"


//****************************************** MARINE ROLES ************************************************//
/obj/effect/landmark/start/whiskey //category moment, indeed

/obj/effect/landmark/start/whiskey/marine
	icon_state = "marine_spawn"
	job = /datum/job/uscm/squad/standard/whiskey

/obj/effect/landmark/start/whiskey/leader
	icon_state = "leader_spawn"
	job = /datum/job/uscm/squad/leader/whiskey

/obj/effect/landmark/start/whiskey/tl
	icon_state = "tl_spawn"
	job = /datum/job/uscm/squad/tl //Need to create a WO variant in the future

/obj/effect/landmark/start/whiskey/spec
	icon_state = "spec_spawn"
	job = /datum/job/uscm/squad/specialist/whiskey

/obj/effect/landmark/start/whiskey/smartgunner
	icon_state = "smartgunner_spawn"
	job = /datum/job/uscm/squad/smartgunner/whiskey

/obj/effect/landmark/start/whiskey/medic
	icon_state = "medic_spawn"
	job = /datum/job/uscm/squad/medic/whiskey

/obj/effect/landmark/start/whiskey/engineer
	icon_state = "engi_spawn"
	job = /datum/job/uscm/squad/engineer/whiskey

//****************************************** LOGISTICAL ROLES ************************************************//
/obj/effect/landmark/start/whiskey/requisition
	job = /datum/job/logistics/requisition/whiskey

/obj/effect/landmark/start/whiskey/cargo
	job = /datum/job/logistics/cargo/whiskey

/obj/effect/landmark/start/whiskey/engineering
	job = /datum/job/logistics/engineering/whiskey

/obj/effect/landmark/start/whiskey/maint
	job = /datum/job/logistics/otech/maint/whiskey

/obj/effect/landmark/start/whiskey/tech
	job = /datum/job/logistics/otech //Need to create a WO variant in the future

//****************************************** MILITARY POLICE- HONOR-GUARD ************************************************//
/obj/effect/landmark/start/whiskey/warrant
	job = /datum/job/command/warrant/whiskey

/obj/effect/landmark/start/whiskey/police
	job = /datum/job/command/police/whiskey

/obj/effect/landmark/start/whiskey/warden
	job = /datum/job/command/warden //Need to create a WO variant in the future

//****************************************** CIC - COMMAND ************************************************//
/obj/effect/landmark/start/whiskey/commander
	job = /datum/job/command/commander/whiskey

/obj/effect/landmark/start/whiskey/executive
	job = /datum/job/command/executive/whiskey

/obj/effect/landmark/start/whiskey/bridge
	job = /datum/job/command/bridge/whiskey

//****************************************** AUXILIARY - SUPPORT ************************************************//
/obj/effect/landmark/start/whiskey/synthetic
	job = /datum/job/civilian/synthetic/whiskey

/obj/effect/landmark/start/whiskey/senior
	job = /datum/job/command/senior  //Need to create a WO variant in the future

/obj/effect/landmark/start/whiskey/pilot
	job = /datum/job/command/pilot/whiskey

/obj/effect/landmark/start/whiskey/tank_crew
	job = /datum/job/command/tank_crew/whiskey

/obj/effect/landmark/start/whiskey/intel
	job = /datum/job/command/warden //Need to create a WO variant in the future,  IO's dont exist in code anymore?

/obj/effect/landmark/start/whiskey/chef
	job = /datum/job/civilian/chef //Need to create a WO variant in the future

//****************************************** CIVILLIANS & MEDBAY ************************************************//
/obj/effect/landmark/start/whiskey/liaison
	job = /datum/job/civilian/liaison/combat_reporter

/obj/effect/landmark/start/whiskey/cmo
	job = /datum/job/civilian/professor/whiskey

/obj/effect/landmark/start/whiskey/researcher
	job = /datum/job/civilian/researcher/whiskey

/obj/effect/landmark/start/whiskey/doctor
	job = /datum/job/civilian/doctor/whiskey

/obj/effect/landmark/start/whiskey/nurse
	job = /datum/job/civilian/nurse //Need to create a WO variant in the future

//****************************************** LATE JOIN ************************************************//
/obj/effect/landmark/late_join
	name = "late join"
	icon_state = "x2"
	var/squad = "other"

//MARINE
/obj/effect/landmark/late_join/marine
	name = "marine late join"
	faction_to_get = FACTION_MARINE

/obj/effect/landmark/late_join/marine/alpha
	name = "marine alpha late join"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/late_join/marine/bravo
	name = "marine bravo late join"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/late_join/marine/charlie
	name = "marine charlie late join"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/late_join/marine/delta
	name = "marine delta late join"
	squad = SQUAD_MARINE_4

//UPP
/obj/effect/landmark/late_join/upp
	name = "upp late join"
	faction_to_get = FACTION_UPP

/obj/effect/landmark/late_join/upp/red_daragon
	name = "upp red dragon late join"
	squad = SQUAD_UPP_1

/obj/effect/landmark/late_join/upp/sun_rise
	name = "upp sun rise late join"
	squad = SQUAD_UPP_2

/obj/effect/landmark/late_join/upp/veiled_threat
	name = "upp veiled threat late join"
	squad = SQUAD_UPP_3

/obj/effect/landmark/late_join/upp/death_seekers
	name = "upp death seekers late join"
	squad = SQUAD_UPP_4

//CLF
/obj/effect/landmark/late_join/clf
	name = "clf late join"
	faction_to_get = FACTION_CLF

/obj/effect/landmark/late_join/clf/python
	name = "clf python late join"
	squad = SQUAD_CLF_1

/obj/effect/landmark/late_join/clf/viper
	name = "clf viper late join"
	squad = SQUAD_CLF_2

/obj/effect/landmark/late_join/clf/cobra
	name = "clf cobra late join"
	squad = SQUAD_CLF_3

/obj/effect/landmark/late_join/clf/boa
	name = "clf boa late join"
	squad = SQUAD_CLF_4

/obj/effect/landmark/late_join/working_joe
	name = "working joe late join"
	squad = JOB_WORKING_JOE
	faction_to_get = FACTION_MARINE

/obj/effect/landmark/late_join/Initialize()
	. = ..()
	if(!faction.late_join_landmarks[squad])
		faction.late_join_landmarks[squad] = list()
	faction.late_join_landmarks[squad] += src

/obj/effect/landmark/late_join/Destroy()
	faction.late_join_landmarks[squad] -= src
	return ..()

/proc/get_latejoin_spawn(mob/living/carbon/human/human, datum/faction/faction_assigned_spawn, assigned_squad = "other")
	var/turf/selected_turf
	if(human && faction_assigned_spawn && assigned_squad)
		if(length(faction_assigned_spawn.late_join_landmarks[assigned_squad]))
			selected_turf = get_turf(pick(faction_assigned_spawn.late_join_landmarks[assigned_squad]))
		if(!selected_turf)
			for(var/squad in faction_assigned_spawn.late_join_landmarks)
				if(!length(faction_assigned_spawn.late_join_landmarks[squad]))
					continue
				selected_turf = get_turf(pick(faction_assigned_spawn.late_join_landmarks[squad]))
	return selected_turf

//****************************************** DEFCON ASSETS ************************************************//
/obj/effect/landmark/asset_drop_point
	name = "asset drop point"
	icon_state = "x2"

/obj/effect/landmark/asset_drop_point/Initialize()
	. = ..()
	if(!GLOB.defcon_drop_point[faction_to_get])
		GLOB.defcon_drop_point[faction_to_get] = list()
	GLOB.defcon_drop_point[faction_to_get] += src

/obj/effect/landmark/asset_drop_point/Destroy()
	GLOB.defcon_drop_point[faction_to_get] -= src
	return ..()

/obj/effect/landmark/asset_drop_point/marine
	name = "marine asset drop point"
	icon_state = "x2"
	faction_to_get = FACTION_MARINE

/obj/effect/landmark/asset_drop_point/upp
	name = "upp asset drop point"
	icon_state = "x2"
	faction_to_get = FACTION_UPP

//****************************************** STATIC COMMS ************************************************//
/obj/effect/landmark/static_comms
	name = "static comms"
	icon = 'icons/obj/structures/machinery/comm_tower3.dmi'
	icon_state = "comms_landmark"
	var/broken_on_spawn = FALSE

/obj/effect/landmark/static_comms/proc/spawn_tower()
	var/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/commstower = new /obj/structure/machinery/telecomms/relay/preset/tower/mapcomms(loc)
	if(broken_on_spawn)
		commstower.update_health(damage = health) //fuck it up
	qdel(src)

/obj/effect/landmark/static_comms/net_one
	icon_state = "comms_landmark_1"

/obj/effect/landmark/static_comms/net_one/Initialize(mapload, ...)
	. = ..()
	GLOB.comm_tower_landmarks_net_one += src

/obj/effect/landmark/static_comms/net_one/Destroy()
	GLOB.comm_tower_landmarks_net_one -= src
	return ..()

/obj/effect/landmark/static_comms/net_two
	icon_state = "comms_landmark_2"

/obj/effect/landmark/static_comms/net_two/Initialize(mapload, ...)
	. = ..()
	GLOB.comm_tower_landmarks_net_two += src

/obj/effect/landmark/static_comms/net_two/Destroy()
	GLOB.comm_tower_landmarks_net_two -= src
	return ..()


// zombie spawn
/obj/effect/landmark/zombie
	name = "zombie spawnpoint"
	desc = "The spot a zombie spawns in. Players in-game can't see this."
	icon_state = "corpse_spawner"
	invisibility = INVISIBILITY_OBSERVER
	var/spawns_left = 1
	var/infinite_spawns = FALSE

/obj/effect/landmark/zombie/Initialize(mapload, ...)
	. = ..()
	GLOB.faction_datum[FACTION_ZOMBIE].force_spawning = TRUE
	GLOB.zombie_landmarks += src

/obj/effect/landmark/zombie/Destroy()
	GLOB.zombie_landmarks -= src
	return ..()

/obj/effect/landmark/zombie/proc/spawn_zombie(mob/dead/observer/observer)
	if(!infinite_spawns)
		spawns_left--

	anim(loc, loc, 'icons/mob/mob.dmi', null, "zombie_rise", 12, SOUTH)
	observer.see_invisible = SEE_INVISIBLE_LIVING
	observer.client.eye = src // gives the player a second to orient themselves to the spawn zone
	addtimer(CALLBACK(src, PROC_REF(handle_zombie_spawn), observer), 1 SECONDS)

/obj/effect/landmark/zombie/proc/handle_zombie_spawn(mob/dead/observer/observer)
	var/mob/living/carbon/human/zombie = new /mob/living/carbon/human(loc)
	if(!zombie.hud_used)
		zombie.create_hud()
	arm_equipment(zombie, /datum/equipment_preset/other/zombie, randomise = TRUE, count_participant = TRUE, mob_client = observer.client, show_job_gear = TRUE)
	observer.client.eye = zombie
	observer.mind.transfer_to(zombie)
	SSautobalancer.balance_action(zombie, "add")
	if(spawns_left <= 0)
		GLOB.zombie_landmarks -= src
		qdel(src)

/obj/effect/landmark/zombie/three
	spawns_left = 3

/obj/effect/landmark/zombie/infinite
	infinite_spawns = TRUE

/// Marks the bottom left of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_bottom_left
	name = "unit test zone bottom left"

/// Marks the top right of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_top_right
	name = "unit test zone top right"
