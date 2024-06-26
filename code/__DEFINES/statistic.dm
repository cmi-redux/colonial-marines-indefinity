#define get_client_stat(client, stat) (client.player_data ? LAZYACCESS(client.player_data.stats, stat) ? client.player_data.stats[stat].stat_number : 0 : 0)

#define FACEHUG_TIER_1 5
#define FACEHUG_TIER_2 25
#define FACEHUG_TIER_3 100
#define FACEHUG_TIER_4 1000

GLOBAL_LIST_INIT_TYPED(balance_formulas, /datum/autobalance_formula_row, setup_formulas_list())

/proc/setup_formulas_list()
	var/list/balance_formulas_list = list()
	for(var/T in typesof(/datum/autobalance_formula_row))
		var/datum/autobalance_formula_row/F = new T
		balance_formulas_list[F.statistic_type] = F
	return balance_formulas_list

// Balance formulas
#define BALANCE_FORMULA_COMMANDING		"commanding"
#define BALANCE_FORMULA_MISC			"misc"
#define BALANCE_FORMULA_ENGINEER		"engineer"
#define BALANCE_FORMULA_SUPPORT			"support"
#define BALANCE_FORMULA_OPERATIONS		"operations"
#define BALANCE_FORMULA_MEDIC			"medic"
#define BALANCE_FORMULA_FIELD			"field"

#define BALANCE_FORMULA_XENO_HEALER		"xeno_healer"
#define BALANCE_FORMULA_XENO_FIGHTER	"xeno_fighter"
#define BALANCE_FORMULA_XENO_ABILITER	"xeno_abiliter"
#define BALANCE_FORMULA_XENO_BUILDER	"xeno_builder"

// Statistics defines
#define STATISTIC_TYPE_MISC				"Misc"
#define STATISTIC_TYPE_CASTE			"Caste"
#define STATISTIC_TYPE_CASTE_ABILITIES	"Caste Abilities"
#define STATISTIC_TYPE_JOB				"Role"
#define STATISTIC_TYPE_WEAPON			"Weapon"

#define STATISTICS_DEATH_LIST_LEN		20

#define STATISTICS_FF_SHOT_HIT			"FF Shot Hit"
#define STATISTICS_SHOT_HIT				"Shot Hit"
#define STATISTICS_SHOT					"Shot"
#define STATISTICS_DAMAGE				"Damage"
#define STATISTICS_FF_DAMAGE			"FF Damage"
#define STATISTICS_HEALED_DAMAGE		"Healed Damage"
#define STATISTICS_SCREAM				"Scream"
#define STATISTICS_HIT					"Hit"
#define STATISTICS_FF_HIT				"FF Hit"
#define STATISTICS_SLASH				"Slash"
#define STATISTICS_REVIVE				"Revive"
#define STATISTICS_REVIVED				"Revived"
#define STATISTICS_STEPS_WALKED			"Steps"
#define STATISTICS_KILL					"Kill"
#define STATISTICS_DEATH				"Death"
#define STATISTICS_KILL_FF				"Kill FF"
#define STATISTICS_DEATH_FF				"Death FF"
#define STATISTICS_ROUNDS_PLAYED		"Rounds Played"

#define STATISTICS_ABILITES				"Abilites"
#define STATISTICS_FACEHUGGE			"Facehugge"
#define STATISTIC_XENO_STRUCTURES_BUILD	"Builded"

#define STATISTICS_EXECUTION			"Executions Made"
#define STATISTICS_MEDALS				"Medals Received"
#define STATISTICS_MEDALS_GIVE			"Medals Given"
#define STATISTICS_SHOCK				"Times Shocked"
#define STATISTICS_GRENADES				"Grenades Thrown"
#define STATISTICS_FLIGHT				"Flights Piloted"
#define STATISTICS_HANDCUFF				"Handcuffs Applied"
#define STATISTICS_PILLS				"Pills Fed"
#define STATISTICS_DISCHARGE			"Accidental Discharges"
#define STATISTICS_FULTON				"Fultons Deployed"
#define STATISTICS_DISK					"Disks Decrypted"
#define STATISTICS_UPLOAD				"Data Uploaded"
#define STATISTICS_CHEMS				"Chemicals Discovered"
#define STATISTICS_CRATES				"Supplies Airdropped"
#define STATISTICS_OB					"Bombardments Fired"
#define STATISTICS_AMMO_CONVERTED		"Ammo Converted"
#define STATISTICS_IMPLANTS_IMPLANTED	"Implants Implanted"
#define STATISTICS_REVIVED_BY_IMPLANT	"Revive Implant Saved Lifes"
#define STATISTICS_SD_ACTIVATION		"SD Activated"
#define STATISTICS_SACRIFICE			"Sacrificed"
#define STATISTICS_ESCAPE				"Escaped"

#define STATISTICS_CADES				"Barricades Built"
#define STATISTICS_UPGRADE_CADES		"Barricades Upgraded"
#define STATISTICS_REPAIR_CADES			"Barricades Repaired"
#define STATISTICS_REPAIR_GENERATOR		"Generators Repaired"
#define STATISTICS_UPGRADE_TURRETS		"Defenses Upgraded"
#define STATISTICS_REPAIR_APC			"APCs Repaired"
#define STATISTICS_DEFENSES_BUILT		"Defenses Built"

#define STATISTICS_CORGI				"Corgis Murdered"
#define STATISTICS_CAT					"Cats Murdered"
#define STATISTICS_COW					"Cows Murdered"
#define STATISTICS_CHICKEN				"Chickens Murdered"

#define STATISTICS_SURGERY_BONES		"Bones Mended"
#define STATISTICS_SURGERY_IB			"Internal Bleedings Stopped"
#define STATISTICS_SURGERY_BRAIN		"Brains Mended"
#define STATISTICS_SURGERY_EYE			"Eyes Mended"
#define STATISTICS_SURGERY_LARVA		"Larvae Removed"
#define STATISTICS_SURGERY_NECRO		"Necro Limbs Fixed"
#define STATISTICS_SURGERY_SHRAPNEL		"Shrapnel Removed"
#define STATISTICS_SURGERY_AMPUTATE		"Limbs Amputated"
#define STATISTICS_SURGERY_ORGAN_REPAIR	"Organs Repaired"
#define STATISTICS_SURGERY_ORGAN_ATTACH	"Organs Implanted"
#define STATISTICS_SURGERY_ORGAN_REMOVE	"Organs Harvested"

#define STATISTICS_DESTRUCTION_WALLS	"Walls Destroyed"
#define STATISTICS_DESTRUCTION_DOORS	"Doors Destroyed"
#define STATISTICS_DESTRUCTION_WINDOWS	"Windows Destroyed"


#define STATISTIC_ALL					STATISTIC_XENO_ALL + STATISTIC_ASSIST_ALL + STATISTIC_MISC_ALL + STATISTIC_MEDICINE_ALL + STATISTIC_DAMAGE_ALL + STATISTIC_DAMAGE_FF_ALL + STATISTIC_KDA_ALL + STATISTIC_KDA_FF_ALL + STATISTIC_ESCAPE_ALL + STATISTIC_ENGINEERING_ALL + STATISTIC_SURGERY_ALL + STATISTIC_ATTACK_ALL

#define STATISTIC_XENO_ALL				list(STATISTICS_ABILITES, STATISTICS_FACEHUGGE, STATISTIC_XENO_STRUCTURES_BUILD)

#define STATISTIC_ASSIST_ALL			list(STATISTICS_OB, STATISTICS_CRATES, STATISTICS_UPLOAD, STATISTICS_DISK, STATISTICS_FULTON, STATISTICS_FLIGHT)

#define STATISTIC_MISC_ALL				list(STATISTICS_SHOCK, STATISTICS_AMMO_CONVERTED, STATISTICS_IMPLANTS_IMPLANTED, STATISTICS_SCREAM, STATISTICS_STEPS_WALKED, STATISTICS_ROUNDS_PLAYED, STATISTICS_MEDALS, STATISTICS_MEDALS_GIVE, STATISTICS_EXECUTION, STATISTICS_HANDCUFF, STATISTICS_DISCHARGE)

#define STATISTIC_MEDICINE_ALL			list(STATISTICS_REVIVED_BY_IMPLANT, STATISTICS_CHEMS, STATISTICS_REVIVE, STATISTICS_REVIVED, STATISTICS_HEALED_DAMAGE, STATISTICS_PILLS)

#define STATISTIC_DAMAGE_ALL			list(STATISTICS_SLASH, STATISTICS_GRENADES, STATISTICS_SHOT_HIT, STATISTICS_SHOT, STATISTICS_HIT, STATISTICS_DAMAGE)

#define STATISTIC_DAMAGE_FF_ALL			list(STATISTICS_FF_SHOT_HIT, STATISTICS_FF_HIT, STATISTICS_FF_DAMAGE)

#define STATISTIC_KDA_ALL				list(STATISTICS_KILL, STATISTICS_DEATH)

#define STATISTIC_KDA_FF_ALL			list(STATISTICS_KILL_FF, STATISTICS_DEATH_FF)

#define STATISTIC_ESCAPE_ALL			list(STATISTICS_SD_ACTIVATION, STATISTICS_SACRIFICE, STATISTICS_ESCAPE)

#define STATISTIC_ENGINEERING_ALL		list(STATISTICS_CADES, STATISTICS_UPGRADE_CADES, STATISTICS_REPAIR_CADES, STATISTICS_REPAIR_GENERATOR, STATISTICS_UPGRADE_TURRETS, STATISTICS_REPAIR_APC, STATISTICS_DEFENSES_BUILT)

#define STATISTIC_SURGERY_ALL			list(STATISTICS_SURGERY_BONES, STATISTICS_SURGERY_IB, STATISTICS_SURGERY_BRAIN, STATISTICS_SURGERY_EYE, STATISTICS_SURGERY_LARVA, STATISTICS_SURGERY_NECRO, STATISTICS_SURGERY_SHRAPNEL, STATISTICS_SURGERY_AMPUTATE, STATISTICS_SURGERY_ORGAN_REPAIR, STATISTICS_SURGERY_ORGAN_ATTACH, STATISTICS_SURGERY_ORGAN_REMOVE)

#define STATISTIC_ATTACK_ALL			list(STATISTICS_DESTRUCTION_WALLS, STATISTICS_DESTRUCTION_DOORS, STATISTICS_DESTRUCTION_WINDOWS, STATISTICS_CORGI, STATISTICS_CAT, STATISTICS_COW, STATISTICS_CHICKEN)
