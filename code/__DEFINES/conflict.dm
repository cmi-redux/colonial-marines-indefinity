//Grab levels
#define GRAB_PASSIVE 0
#define GRAB_AGGRESSIVE 1
#define GRAB_CARRY   2
#define GRAB_CHOKE   3

//Slowdown from various armors.
#define SHOES_SLOWDOWN				-1.0
#define SLOWDOWN_ARMOR_NONE         0
#define SLOWDOWN_ARMOR_VERY_LIGHT	0.20
#define SLOWDOWN_ARMOR_LIGHT		0.35
#define SLOWDOWN_ARMOR_MEDIUM		0.55
#define SLOWDOWN_ARMOR_LOWHEAVY		0.75
#define SLOWDOWN_ARMOR_HEAVY		1
#define SLOWDOWN_ARMOR_VERY_HEAVY	1.15

///This is how long you must wait after throwing something to throw again
#define THROW_DELAY (0.4 SECONDS)

//Explosion level thresholds. Upper bounds
#define EXPLOSION_THRESHOLD_VLOW 50
#define EXPLOSION_THRESHOLD_LOW 100
#define EXPLOSION_THRESHOLD_MLOW 150
#define EXPLOSION_THRESHOLD_MEDIUM 200
#define EXPLOSION_THRESHOLD_HIGH 300

/// how much it takes to gib a mob
#define EXPLOSION_THRESHOLD_GIB 200
/// prone mobs receive less damage from explosions
#define EXPLOSION_PRONE_MULTIPLIER 0.5

//Explosion damage multipliers for different objects
#define EXPLOSION_DAMAGE_MULTIPLIER_DOOR 15
#define EXPLOSION_DAMAGE_MULTIPLIER_WALL 15
#define EXPLOSION_DAMAGE_MULTIPLIER_WINDOW 10

//Additional explosion damage modifier for open doors
#define EXPLOSION_DAMAGE_MODIFIER_DOOR_OPEN 0.5

//Melee weapons and xenos do more damage to resin structures
#define RESIN_MELEE_DAMAGE_MULTIPLIER 8.2
#define RESIN_XENO_DAMAGE_MULTIPLIER 4

#define RESIN_EXPLOSIVE_MULTIPLIER 0.85

//Projectile block probabilities for different types of cover
#define PROJECTILE_COVERAGE_NONE 0
#define PROJECTILE_COVERAGE_MINIMAL 10
#define PROJECTILE_COVERAGE_LOW 35
#define PROJECTILE_COVERAGE_MEDIUM 60
#define PROJECTILE_COVERAGE_HIGH 85
#define PROJECTILE_COVERAGE_MAX 100
//=================================================

#define ARMOR_MELEE 1
#define ARMOR_BULLET 2
#define ARMOR_LASER 4
#define ARMOR_ENERGY 8
#define ARMOR_BOMB 16
#define ARMOR_BIO 32
#define ARMOR_RAD 64
#define ARMOR_INTERNALDAMAGE 128

#define ARMOR_SHARP_INTERNAL_PENETRATION 10

// Related to damage that ANTISTRUCT ammo types deal to structures
#define ANTISTRUCT_DMG_MULT_BARRICADES 1.45
#define ANTISTRUCT_DMG_MULT_WALL 2.5
#define ANTISTRUCT_DMG_MULT_TANK 1.5

// human armor
#define CLOTHING_ARMOR_NONE 0
#define CLOTHING_ARMOR_VERYLOW 5
#define CLOTHING_ARMOR_LOW 10
#define CLOTHING_ARMOR_MEDIUMLOW 15
#define CLOTHING_ARMOR_MEDIUM 20
#define CLOTHING_ARMOR_MEDIUMHIGH 25
#define CLOTHING_ARMOR_HIGH 30
#define CLOTHING_ARMOR_HIGHPLUS 35
#define CLOTHING_ARMOR_VERYHIGH 40
#define CLOTHING_ARMOR_VERYHIGHPLUS 45
#define CLOTHING_ARMOR_ULTRAHIGH 50
#define CLOTHING_ARMOR_ULTRAHIGHPLUS 55
#define CLOTHING_ARMOR_GIGAHIGH 70
#define CLOTHING_ARMOR_GIGAHIGHPLUS 75
#define CLOTHING_ARMOR_GIGAHIGHDOUBLEPLUSGOOD 80
#define CLOTHING_ARMOR_HARDCORE 100

#define UNIFORM_NO_SENSORS 0
#define UNIFORM_HAS_SENSORS 1
#define UNIFORM_FORCED_SENSORS 2

#define EYE_PROTECTION_NEGATIVE -1
#define EYE_PROTECTION_NONE 0
#define EYE_PROTECTION_FLAVOR 1
#define EYE_PROTECTION_FLASH 2
#define EYE_PROTECTION_WELDING 3

#define SENSOR_MODE_OFF 0
#define SENSOR_MODE_BINARY 1
#define SENSOR_MODE_DAMAGE 2
#define SENSOR_MODE_LOCATION 3

//OB timings
#define OB_TRAVEL_TIMING 9 SECONDS
#define OB_CRASHING_DOWN 1 SECONDS
#define OB_CLUSTER_DURATION 45 SECONDS
//=================================================

//Health of various items
#define HEALTH_WALL 3000
#define HEALTH_WALL_REINFORCED 9000
#define HEALTH_WALL_XENO 900
#define HEALTH_WALL_XENO_WEAK 100
#define HEALTH_WALL_XENO_THICK 1350
#define HEALTH_WALL_XENO_MEMBRANE 300
#define HEALTH_WALL_XENO_REFLECTIVE 300
#define HEALTH_WALL_XENO_MEMBRANE_THICK 600

#define HEALTH_DOOR 1200
#define HEALTH_DOOR_XENO 600
#define HEALTH_DOOR_XENO_THICK 900

#define HEALTH_RESIN_PILLAR 2200
#define HEALTH_RESIN_XENO_ACID_PILLAR 300
#define HEALTH_RESIN_XENO_SHIELD_PILLAR 300
#define HEALTH_RESIN_XENO_SPIKE 45
#define HEALTH_RESIN_XENO_STICKY 45
#define HEALTH_RESIN_XENO_FAST 30

/// Coefficient of throwforce when calculating damage from an atom colliding with a mob
#define THROWFORCE_COEFF 0.02
/// Coefficient of mobsize when calculating damage from a mob colliding with a dense atom
#define MOB_SIZE_COEFF 20
/// Coefficient of throwspeed when calculating damage from a mob colliding with a dense atom
#define THROW_SPEED_DENSE_COEFF 0.2
/// Coefficient of throwspeed when calculating damage from an atom colliding with a mob
#define THROW_SPEED_IMPACT_COEFF 0.05

#define THROW_MODE_OFF   0
#define THROW_MODE_NORMAL   1
#define THROW_MODE_HIGH  2

#define XENO_ACID_BARRICADE_DAMAGE 8
#define XENO_ACID_STATIONAR_DAMAGE 10

#define MOLOTOV_POTENCY_MAX 20
#define MOLOTOV_TIME_MAX 20

// Fire
#define MAX_FIRE_STACKS 45
#define MIN_FIRE_STACKS -20
#define XENO_FIRE_RESIST_AMOUNT -10
#define HUMAN_FIRE_RESIST_AMOUNT -10
#define HUNTER_FIRE_RESIST_AMOUNT -25

// Organ damage chance

/// The multiplier to damage when calculating organ damage probability
#define DMG_ORGAN_DAM_PROB_MULT (2/9)
/// The multiplier to existing brute damage when calculating organ damage probability
#define BRUTE_ORGAN_DAM_PROB_MULT (0.05)
