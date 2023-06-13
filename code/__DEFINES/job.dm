#define get_job_playtime(client, job) (client.player_data? LAZYACCESS(client.player_data.playtimes, job)? client.player_data.playtimes[job].total_minutes MINUTES_TO_DECISECOND : 0 : 0)
#define GET_MAPPED_ROLE(title) (SSticker.role_authority?.role_mappings?[title] ? SSticker.role_authority.role_mappings[title] : SSticker.role_authority?.roles_by_name?[title] ? SSticker.role_authority.roles_by_name[title] : GET_DEFAULT_ROLE(title))
#define GET_DEFAULT_ROLE(title) (SSticker.role_authority?.default_roles?[title] ? SSticker.role_authority.default_roles[title] : title)

///////////////////////////////////////////
//----------SQUAD NAMES DEFINES----------//
///////////////////////////////////////////

//------------Marine squad---------------//
#define SQUAD_MARINE_1 "Alpha"
#define SQUAD_MARINE_2 "Bravo"
#define SQUAD_MARINE_3 "Charlie"
#define SQUAD_MARINE_4 "Delta"
#define SQUAD_MARINE_5 "Echo"
#define SQUAD_MARINE_6 "Foxtrot"
#define SQUAD_MARINE_SOF "SOF"

//------------UPP squad------------------//
#define SQUAD_UPP_1 "Red Dragon"
#define SQUAD_UPP_2 "Sun Rise"
#define SQUAD_UPP_3 "Veiled Threat"
#define SQUAD_UPP_4 "Death Seekers"
#define SQUAD_UPP_5 "Echo"
#define SQUAD_UPP_SOZ "SOZ"

//------------CLF squad------------------//
#define SQUAD_CLF_1 "Python"
#define SQUAD_CLF_2 "Viper"
#define SQUAD_CLF_3 "Cobra"
#define SQUAD_CLF_4 "Boa"
#define SQUAD_CLF_5 "Engagers"

//------------WY squad-------------------//
#define SQUAD_WY_6 "PMC"
#define SQUAD_WY_7 "W-Y DS"

#define SQUADS_SETUP list("First" = list(SQUAD_MARINE_1, SQUAD_UPP_1, SQUAD_CLF_1), "Second" = list(SQUAD_MARINE_2, SQUAD_UPP_2, SQUAD_CLF_2), "Third" = list(SQUAD_MARINE_3, SQUAD_UPP_3, SQUAD_CLF_3), "Fourth" = list(SQUAD_MARINE_4, SQUAD_UPP_4, SQUAD_CLF_4))

///////////////////////////////////////////
//-----------JOB NAMES DEFINES-----------//
///////////////////////////////////////////

//------------Squad roles----------------//
#define JOB_SQUAD_MARINE "Squad Rifleman"
#define JOB_SQUAD_LEADER "Squad Leader"
#define JOB_SQUAD_ENGI "Squad Combat Technician"
#define JOB_SQUAD_MEDIC "Squad Hospital Corpsman"
#define JOB_SQUAD_SPECIALIST "Squad Weapons Specialist"
#define JOB_SQUAD_TEAM_LEADER "Squad Fireteam Leader"
#define JOB_SQUAD_SMARTGUN "Squad Smartgunner"

//------------Colonist roles-------------//
#define JOB_COLONIST "Colonist"
#define JOB_PASSENGER "Passenger"
#define JOB_SURVIVOR "Survivor"
#define JOB_SYNTH_SURVIVOR "Synth Survivor"
#define JOB_CO_SURVIVOR "CO Survivor"

#define ANY_SURVIVOR "Any Survivor"
#define CIVILIAN_SURVIVOR "Civilian Survivor"
#define SECURITY_SURVIVOR "Security Survivor"
#define SCIENTIST_SURVIVOR "Scientist Survivor"
#define MEDICAL_SURVIVOR "Medical Survivor"
#define ENGINEERING_SURVIVOR "Engineering Survivor"
#define CORPORATE_SURVIVOR "Corporate Survivor"
#define HOSTILE_SURVIVOR "Hostile Survivor" //AKA Marine Killers assuming they survive. Will do cultist survivor at some point.
#define SURVIVOR_VARIANT_LIST list(ANY_SURVIVOR = "Any", CIVILIAN_SURVIVOR = "Civ", SECURITY_SURVIVOR = "Sec", SCIENTIST_SURVIVOR = "Sci", MEDICAL_SURVIVOR = "Med", ENGINEERING_SURVIVOR = "Eng", CORPORATE_SURVIVOR = "W-Y", HOSTILE_SURVIVOR = "CLF")

//-1 is infinite amount, these are soft caps and can be bypassed by randomization
#define MAX_SURVIVOR_PER_TYPE list(ANY_SURVIVOR = -1, CIVILIAN_SURVIVOR = -1, SECURITY_SURVIVOR = 2, SCIENTIST_SURVIVOR = 2, MEDICAL_SURVIVOR = 3, ENGINEERING_SURVIVOR = 4, CORPORATE_SURVIVOR = 2, HOSTILE_SURVIVOR = 1)

#define SPAWN_PRIORITY_VERY_HIGH 1
#define SPAWN_PRIORITY_HIGH 2
#define SPAWN_PRIORITY_MEDIUM 3
#define SPAWN_PRIORITY_LOW 4
#define SPAWN_PRIORITY_VERY_LOW 5
#define LOWEST_SPAWN_PRIORITY 5

//------------Medic roles----------------//
#define JOB_CMO "Chief Medical Officer"
#define JOB_DOCTOR "Doctor"
#define JOB_SURGEON "Surgeon"

#define JOB_NURSE "Nurse"
#define JOB_RESEARCHER "Researcher"

//------------Assist roles---------------//
#define JOB_CORPORATE_LIAISON "Corporate Liaison"
#define JOB_COMBAT_REPORTER "Combat Correspondent"
#define JOB_MESS_SERGEANT "Mess Technician"
#define JOB_SYNTH "Synthetic"
#define JOB_WORKING_JOE "Working Joe"
#define JOB_COMBAT_REPORTER_CORPORATE_LIAISON "Combat Reporter"

//------------Command roles--------------//
#define JOB_CO "Commanding Officer"
#define JOB_XO "Executive Officer"
#define JOB_SO "Staff Officer"

//------------Auxiliaru roles------------//
#define JOB_PILOT "Pilot Officer"
#define JOB_DROPSHIP_CREW_CHIEF "Dropship Crew Chief"
#define JOB_CREWMAN "Vehicle Crewman"
#define JOB_INTEL "Intelligence Officer"

//------------Police roles---------------//
#define JOB_POLICE "Military Police"
#define JOB_WARDEN "Military Warden"
#define JOB_CHIEF_POLICE "Chief MP"


//------------SEA role-------------------//
#define JOB_SEA "Senior Enlisted Advisor"

//------------Engi roles-----------------//
#define JOB_CHIEF_ENGINEER "Chief Engineer"
#define JOB_MAINT_TECH "Maintenance Technician"
#define JOB_ORDNANCE_TECH "Ordnance Technician"

//------------Cargo roles----------------//
#define JOB_CHIEF_REQUISITION "Requisitions Officer"
#define JOB_CARGO_TECH "Cargo Technician"

//------------Raiders roles--------------//
#define JOB_MARINE_RAIDER "Marine Raider"
#define JOB_MARINE_RAIDER_SL "Marine Raider Team Lead"
#define JOB_MARINE_RAIDER_CMD "Marine Raider Platoon Lead"
#define JOB_MARINE_RAIDER_ROLES_LIST list(JOB_MARINE_RAIDER, JOB_MARINE_RAIDER_SL, JOB_MARINE_RAIDER_CMD)

//------------Generit mar roles----------//
#define JOB_STOWAWAY "Stowaway"

#define JOB_MARINE "USCM Marine"
#define JOB_COLONEL "USCM Colonel"
#define JOB_GENERAL "USCM General"
#define JOB_ACMC "Assistant Commandant of the Marine Corps"
#define JOB_CMC "Commandant of the Marine Corps"

//------------Crash roles----------------//
#define JOB_CRASH_CO "Special Commander"
#define JOB_CRASH_CHIEF_ENGINEER "Emergency Ship Crew Master"
#define JOB_CRASH_CMO "Head Surgeon"
#define JOB_CRASH_SYNTH "Ship Support Synthetic"
#define JOB_CRASH_SQUAD_MARINE "Ash Squad Marine"
#define JOB_CRASH_SQUAD_LEADER "Ash Squad Leader"
#define JOB_CRASH_SQUAD_ENGINEER "Ash Squad Engineer"
#define JOB_CRASH_SQUAD_MEDIC "Ash Squad Medic"
#define JOB_CRASH_SQUAD_SPECIALIST "Ash Squad Specialist"
#define JOB_CRASH_SQUAD_SMARTGUNNER "Ash Squad Smartgunner"

//-------------WO roles------------------//
#define JOB_WO_CO "Ground Commander"
#define JOB_WO_XO "Lieutenant Commander"
#define JOB_WO_CHIEF_POLICE "Honor Guard Squad Leader"
#define JOB_WO_SO "Veteran Honor Guard"
#define JOB_WO_CREWMAN "Honor Guard Weapons Specialist"
#define JOB_WO_POLICE "Honor Guard"

#define JOB_WO_PILOT "Mortar Crew"

#define JOB_WO_CHIEF_ENGINEER "Bunker Crew Master"
#define JOB_WO_ORDNANCE_TECH "Bunker Crew"

#define JOB_WO_CHIEF_REQUISITION "Quartermaster"
#define JOB_WO_REQUISITION "Bunker Crew Logistics"

#define JOB_WO_CMO "Head Surgeon"
#define JOB_WO_DOCTOR "Field Doctor"
#define JOB_WO_RESEARCHER "Chemist"

#define JOB_WO_SYNTH "Support Synthetic"

#define JOB_WO_SQUAD_MARINE "Dust Raider Squad Rifleman"
#define JOB_WO_SQUAD_MEDIC "Dust Raider Squad Hospital Corpsman"
#define JOB_WO_SQUAD_ENGINEER "Dust Raider Squad Combat Technician"
#define JOB_WO_SQUAD_SMARTGUNNER "Dust Raider Squad Smartgunner"
#define JOB_WO_SQUAD_SPECIALIST "Dust Raider Squad Weapons Specialist"
#define JOB_WO_SQUAD_LEADER "Dust Raider Squad Leader"

//---------------------------------------//

//-------- PMC --------//
#define JOB_PMC "PMC Standard"
#define JOB_PMC_ENGINEER "PMC Corporate Technician"
#define JOB_PMC_MEDIC "PMC Corporate Medic"
#define JOB_PMC_DOCTOR "PMC Trauma Surgeon"
#define JOB_PMC_INVESTIGATOR "PMC Medical Investigator"
#define JOB_PMC_ELITE "PMC Elite"
#define JOB_PMC_GUNNER "PMC Support Weapons Specialist" //Renamed from Specialist to Support Specialist as it only has SG skills.
#define JOB_PMC_SNIPER "PMC Weapons Specialist" //Renamed from Sharpshooter to specialist as it uses specialist skills.
#define JOB_PMC_CREWMAN "PMC Crewman"
#define JOB_PMC_NINJA "PMC Ninja"
#define JOB_PMC_XENO_HANDLER "PMC Xeno Handler"
#define JOB_PMC_COMMANDO "PMC Commando"
#define JOB_PMC_LEADER "PMC Leader"
#define JOB_PMC_LEAD_INVEST "PMC Lead Investigator"
#define JOB_PMC_DIRECTOR "PMC Site Director"
#define JOB_PMC_SYNTH    "PMC Support Synthetic"

#define JOB_PMC_GRUNT_LIST list(JOB_PMC, JOB_PMC_ENGINEER, JOB_PMC_MEDIC, JOB_PMC_INVESTIGATOR, JOB_PMC_ELITE, JOB_PMC_GUNNER, JOB_PMC_SNIPER, JOB_PMC_CREWMAN, JOB_PMC_NINJA, JOB_PMC_XENO_HANDLER, JOB_PMC_COMMANDO, JOB_PMC_LEADER, JOB_PMC_LEAD_INVEST)

//-------- WY --------//

#define JOB_TRAINEE "Corporate Trainee"
#define JOB_JUNIOR_EXECUTIVE "Corporate Junior Executive"
#define JOB_EXECUTIVE "Corporate Executive"
#define JOB_SENIOR_EXECUTIVE "Corporate Senior Executive"
#define JOB_EXECUTIVE_SPECIALIST "Corporate Executive Specialist"
#define JOB_EXECUTIVE_SUPERVISOR "Corporate Executive Supervisor"
#define JOB_ASSISTANT_MANAGER "Corporate Assistant Manager"
#define JOB_DIVISION_MANAGER "Corporate Division Manager"
#define JOB_CHIEF_EXECUTIVE "Corporate Chief Executive"
#define JOB_DIRECTOR "W-Y Director"

//-------- WY Goons --------//
#define JOB_WY_GOON "WY Corporate Security"
#define JOB_WY_GOON_LEAD "WY Corporate Security Lead"
#define JOB_WY_GOON_RESEARCHER "WY Research Consultant"

#define JOB_WY_GOON_LIST list(JOB_WY_GOON, JOB_WY_GOON_LEAD)

//---- Contractors ----//
#define JOB_CONTRACTOR "VAIPO Mercenary"
#define JOB_CONTRACTOR_ST "VAIPO Mercenary"
#define JOB_CONTRACTOR_MEDIC "VAIMS Medical Specialist"
#define JOB_CONTRACTOR_ENGI "VAIPO Engineering Specialist"
#define JOB_CONTRACTOR_MG "VAIPO Automatic Rifleman"
#define JOB_CONTRACTOR_TL "VAIPO Team Leader"
#define JOB_CONTRACTOR_SYN "VAIPO Support Synthetic"
#define JOB_CONTRACTOR_COV "VAISO Mercenary"
#define JOB_CONTRACTOR_COVST "VAISO Mercenary"
#define JOB_CONTRACTOR_COVMED "VAIMS Medical Specialist"
#define JOB_CONTRACTOR_COVENG "VAISO Engineering Specialist"
#define JOB_CONTRACTOR_COVMG "VAISO Automatic Rifleman"
#define JOB_CONTRACTOR_COVTL "VAISO Team Leader"
#define JOB_CONTRACTOR_COVSYN "VAISO Support Synthetic"

#define CONTRACTOR_JOB_LIST list(JOB_CONTRACTOR, JOB_CONTRACTOR_ST, JOB_CONTRACTOR_MEDIC, JOB_CONTRACTOR_ENGI, JOB_CONTRACTOR_MG, JOB_CONTRACTOR_TL, JOB_CONTRACTOR_COV, JOB_CONTRACTOR_COVST, JOB_CONTRACTOR_COVMED, JOB_CONTRACTOR_COVENG, JOB_CONTRACTOR_COVTL)

//-------- CMB --------//
#define JOB_CMB "CMB Deputy"
#define JOB_CMB_TL "CMB Marshal"
#define JOB_CMB_SYN "CMB Investigative Synthetic"
#define JOB_CMB_ICC "Interstellar Commerce Commission Corporate Liaison"
#define JOB_CMB_OBS "Interstellar Human Rights Observer"

#define CMB_GRUNT_LIST list(JOB_CMB, JOB_CMB_TL)

//-------- UPP --------//
#define JOB_UPP "UPP Private"
#define JOB_UPP_CONSCRIPT "UPP Conscript"
#define JOB_UPP_ENGI "UPP Korporal Sapper"
#define JOB_UPP_MEDIC "UPP Korporal Medic"
#define JOB_UPP_SPECIALIST "UPP Serzhant"
#define JOB_UPP_LEADER "UPP Master Serzhant"
#define JOB_UPP_POLICE "UPP Politsiya"
#define JOB_UPP_INTEL "UPP Reconnaissance Officer"
#define JOB_UPP_LT_OFFICER "UPP Leytenant"
#define JOB_UPP_LT_DOKTOR "UPP Leytenant Doktor"
#define JOB_UPP_SRLT_OFFICER "UPP Senior Leytenant"
#define JOB_UPP_MAY_OFFICER "UPP Mayjor"
#define JOB_UPP_KOL_OFFICER "UPP Kolonel"

#define JOB_UPP_CREWMAN "UPP Tank Crewman"
#define JOB_UPP_CORPORATE_LIAISON "UPP Corporate Liason"
#define JOB_UPP_COMBAT_SYNTH "UPP Combat Synthetic"

#define JOB_UPP_COMMANDO "UPP Junior Kommando"
#define JOB_UPP_COMMANDO_MEDIC "UPP 2nd Kommando"
#define JOB_UPP_COMMANDO_LEADER "UPP 1st Kommando"

#define UPP_COMMANDO_JOB_LIST list(JOB_UPP_COMMANDO, JOB_UPP_COMMANDO_MEDIC, JOB_UPP_COMMANDO_LEADER)

#define JOB_UPP_REPRESENTATIVE "UPP Representative"

#define UPP_JOB_LIST list(JOB_UPP_KOL_OFFICER, JOB_UPP_MAY_OFFICER, JOB_UPP_SRLT_OFFICER, JOB_UPP_LT_OFFICER, JOB_UPP_INTEL, JOB_UPP_CREWMAN, JOB_UPP_LT_DOKTOR, JOB_UPP_COMBAT_SYNTH, JOB_UPP_CORPORATE_LIAISON, JOB_UPP_POLICE, JOB_UPP_LEADER, JOB_UPP_SPECIALIST, JOB_UPP_MEDIC, JOB_UPP_ENGI, JOB_UPP)

//-------- CLF --------//
#define JOB_CLF "CLF Guerilla"
#define JOB_CLF_ENGI "CLF Field Technician"
#define JOB_CLF_MEDIC "CLF Field Medic"
#define JOB_CLF_SPECIALIST "CLF Field Specialist"
#define JOB_CLF_LEADER "CLF Cell Leader"
#define JOB_CLF_COMMANDER "CLF Cell Commander"
#define JOB_CLF_SYNTH "CLF Multipurpose Synthetic"

#define CLF_JOB_LIST list(JOB_CLF, JOB_CLF_ENGI, JOB_CLF_MEDIC, JOB_CLF_SPECIALIST, JOB_CLF_LEADER, JOB_CLF_COMMANDER, JOB_CLF_SYNTH)

//-------- TWE --------//
#define JOB_TWE_REPRESENTATIVE "TWE Representative"

#define JOB_TWE_YONTO "RMC Yonto"
#define JOB_TWE_SANTO "RMC Santo"
#define JOB_TWE_NITO "RMC Nito"
#define JOB_TWE_ITTO "RMC Itto"

#define TWE_COMMANDO_JOB_LIST list(JOB_TWE_YONTO, JOB_TWE_SANTO, JOB_TWE_NITO, JOB_TWE_ITTO)

#define JOB_TWE_SEAMAN "TWE Seaman"
#define JOB_TWE_LSEAMAN "TWE Leading Seaman"
#define JOB_TWE_SO "TWE Standing Officer"
#define JOB_TWE_WO "TWE Warrant Officer"
#define JOB_TWE_CPT "TWE Captain"
#define JOB_TWE_ADM "TWE Admiral"
#define JOB_TWE_GADM "TWE Grand Admiral"
#define JOB_TWE_ER "TWE Emperor"

#define TWE_OFFICER_JOB_LIST list(JOB_TWE_SEAMAN, JOB_TWE_LSEAMAN, JOB_TWE_SO, JOB_TWE_WO, JOB_TWE_CPT, JOB_TWE_ADM, JOB_TWE_GADM, JOB_TWE_ER)

//-------- PROVOST --------//
#define JOB_PROVOST_ENFORCER "Provost Enforcer"
#define JOB_PROVOST_TML "Provost Team Leader"
#define JOB_PROVOST_ADVISOR "Provost Advisor"
#define JOB_PROVOST_INSPECTOR "Provost Inspector"
#define JOB_PROVOST_MARSHAL "Provost Marshal"
#define JOB_PROVOST_SMARSHAL "Provost Sector Marshal"
#define JOB_PROVOST_CMARSHAL "Provost Chief Marshal"

#define PROVOST_JOB_LIST list(JOB_PROVOST_ENFORCER, JOB_PROVOST_TML, JOB_PROVOST_ADVISOR, JOB_PROVOST_INSPECTOR, JOB_PROVOST_MARSHAL, JOB_PROVOST_SMARSHAL, JOB_PROVOST_CMARSHAL)

#define JOB_RIOT "Riot Control"
#define JOB_RIOT_CHIEF "Chief Riot Control"

#define RIOT_JOB_LIST list(JOB_RIOT, JOB_RIOT_CHIEF)
//-------- UAAC --------//
#define JOB_TIS_IO "UAAC-TIS Intelligence Officer"
#define JOB_TIS_SA "UAAC-TIS Special Agent"

#define TIS_JOB_LIST list(JOB_TIS_SA, JOB_TIS_IO)

//-------- DUTCH'S DOZEN --------//
#define JOB_DUTCH_ARNOLD "Dutch's Dozen - Dutch"
#define JOB_DUTCH_RIFLEMAN "Dutch's Dozen - Rifleman"
#define JOB_DUTCH_MINIGUNNER "Dutch's Dozen - Minigunner"
#define JOB_DUTCH_FLAMETHROWER "Dutch's Dozen - Flamethrower"
#define JOB_DUTCH_MEDIC "Dutch's Dozen - Medic"

#define DUTCH_JOB_LIST list(JOB_DUTCH_ARNOLD, JOB_DUTCH_RIFLEMAN, JOB_DUTCH_MINIGUNNER, JOB_DUTCH_FLAMETHROWER, JOB_DUTCH_MEDIC)

#define JOB_PREDATOR			"Predator"
#define JOB_XENOMORPH			"Xenomorph"
#define JOB_XENOMORPH_QUEEN		"Queen"

// For colouring the ranks in the statistics menu
#define JOB_PLAYTIME_TIER_1		(25 HOURS)
#define JOB_PLAYTIME_TIER_2		(75 HOURS)
#define JOB_PLAYTIME_TIER_3		(150 HOURS)
#define JOB_PLAYTIME_TIER_4		(300 HOURS)

#define XENO_NO_AGE  -1
#define XENO_NORMAL 0
#define XENO_MATURE 1
#define XENO_ELDER 2
#define XENO_ANCIENT 3
#define XENO_PRIME 4

//For displaying groups of jobs. Used by new player's latejoin menu and by crew manifest.
#define FLAG_SHOW_CIC 1
#define FLAG_SHOW_AUXIL_SUPPORT 2
#define FLAG_SHOW_MISC 4
#define FLAG_SHOW_POLICE 8
#define FLAG_SHOW_ENGINEERING 16
#define FLAG_SHOW_REQUISITION 32
#define FLAG_SHOW_MEDICAL 64
#define FLAG_SHOW_MARINES 128
#define FLAG_SHOW_ALL_JOBS FLAG_SHOW_CIC|FLAG_SHOW_AUXIL_SUPPORT|FLAG_SHOW_MISC|FLAG_SHOW_POLICE|FLAG_SHOW_ENGINEERING|FLAG_SHOW_REQUISITION|FLAG_SHOW_MEDICAL|FLAG_SHOW_MARINES

///For denying certain traits being applied to people. ie. bad leg
///'Grunt' lists are for people who wouldn't logically get the bad leg trait, ie. UPP marine counterparts.
#define JOB_ERT_GRUNT_LIST list(DUTCH_JOB_LIST, RIOT_JOB_LIST, PROVOST_JOB_LIST, CMB_GRUNT_LIST, CLF_JOB_LIST, UPP_COMMANDO_JOB_LIST, CONTRACTOR_JOB_LIST, JOB_WY_GOON_LIST, JOB_PMC_GRUNT_LIST)

//Timelock things

//SQUAD
#define JOB_SQUAD_ROLES /datum/timelock/squad
#define JOB_SQUAD_ROLES_LIST list(JOB_SQUAD_MARINE, JOB_SQUAD_LEADER, JOB_SQUAD_ENGI, JOB_SQUAD_MEDIC, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_TEAM_LEADER, JOB_UPP, JOB_UPP_CONSCRIPT, JOB_UPP_LEADER, JOB_UPP_ENGI, JOB_UPP_MEDIC, JOB_UPP_SPECIALIST)

//MEDIC
#define JOB_MEDIC_ROLES /datum/timelock/medic
#define JOB_MEDIC_ROLES_LIST list(JOB_SQUAD_MEDIC, JOB_CMO, JOB_DOCTOR, JOB_NURSE, JOB_RESEARCHER, JOB_UPP_LT_DOKTOR)

//COMMAND
#define JOB_COMMAND_ROLES /datum/timelock/command
#define JOB_COMMAND_ROLES_LIST list(JOB_CO, JOB_XO, JOB_SO, JOB_UPP_LT_OFFICER, JOB_UPP_SRLT_OFFICER, JOB_UPP_KOL_OFFICER)

//POLICE
#define JOB_POLICE_ROLES /datum/timelock/mp
#define JOB_POLICE_ROLES_LIST list(JOB_POLICE, JOB_WARDEN, JOB_CHIEF_POLICE, JOB_UPP_POLICE)

//ENGINEER
#define JOB_ENGINEER_ROLES /datum/timelock/engineer
#define JOB_ENGINEER_ROLES_LIST list(JOB_SQUAD_ENGI, JOB_MAINT_TECH, JOB_ORDNANCE_TECH, JOB_CHIEF_ENGINEER)

//REQUISTION
#define JOB_REQUISITION_ROLES /datum/timelock/requisition
#define JOB_REQUISITION_ROLES_LIST list(JOB_CHIEF_REQUISITION, JOB_CARGO_TECH)

/// For monthly time tracking
#define JOB_OBSERVER "Observer"

//HUMAN
#define JOB_HUMAN_ROLES /datum/timelock/human

//XENO
#define JOB_XENO_ROLES /datum/timelock/xeno
#define JOB_DRONE_ROLES /datum/timelock/drone
#define JOB_T3_ROLES /datum/timelock/tier3

// Used to add a timelock to a job. Will be passed onto derivatives
#define AddTimelock(Path, timelockList) \
##Path/setup_requirements(list/L){\
	L += timelockList;\
	. = ..(L);\
}

// Used to add a timelock to a job. Will be passed onto derivates. Will not include the parent's timelocks.
#define OverrideTimelock(Path, timelockList) \
##Path/setup_requirements(list/L){\
	L = timelockList;\
	. = ..(L);\
}

#define TIMELOCK_JOB(role_id, hours) new/datum/timelock(role_id, hours, role_id)

//SQUAD THINGS
#define JOB_SQUAD_NORMAL_LIST list(JOB_SQUAD_MARINE, JOB_WO_SQUAD_MARINE, JOB_MARINE_RAIDER, JOB_UPP)
#define JOB_SQUAD_MEDIC_LIST list(JOB_SQUAD_MEDIC, JOB_WO_SQUAD_MEDIC, JOB_UPP_MEDIC)
#define JOB_SQUAD_ENGI_LIST list(JOB_SQUAD_ENGI, JOB_WO_SQUAD_ENGINEER, JOB_UPP_ENGI)
#define JOB_SQUAD_SUP_LIST list(JOB_SQUAD_TEAM_LEADER, JOB_UPP_CONSCRIPT)
#define JOB_SQUAD_SPEC_LIST list(JOB_SQUAD_SPECIALIST, JOB_WO_SQUAD_SPECIALIST, JOB_UPP_SPECIALIST)
#define JOB_SQUAD_MAIN_SUP_LIST list(JOB_SQUAD_SMARTGUN, JOB_WO_SQUAD_SMARTGUNNER)
#define JOB_SQUAD_LEADER_LIST list(JOB_SQUAD_LEADER, JOB_WO_SQUAD_LEADER, JOB_MARINE_RAIDER_SL, JOB_UPP_LEADER)

#define SQUAD_SELECTOR list("First" = 1, "Second" = 2, "Third" = 3, "Fourth" = 4)

#define SQUAD_BY_FACTION list(\
	FACTION_MARINE = list(/datum/squad/marine/alpha, /datum/squad/marine/bravo, /datum/squad/marine/charlie, /datum/squad/marine/delta, /datum/squad/marine/echo, /datum/squad/marine/cryo),\
	FACTION_UPP = list(/datum/squad/upp/red_daragon, /datum/squad/upp/sun_rise, /datum/squad/upp/veiled_threat, /datum/squad/upp/death_seekers, /datum/squad/upp/echo),\
	FACTION_CLF = list(/datum/squad/clf/python, /datum/squad/clf/viper, /datum/squad/clf/cobra, /datum/squad/clf/boa, /datum/squad/clf/engagers),\
)
