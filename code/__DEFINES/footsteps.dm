#define FOOTSTEP_WOOD "wood"
#define FOOTSTEP_FLOOR "floor"
#define FOOTSTEP_PLATING "plating"
#define FOOTSTEP_CARPET "carpet"
#define FOOTSTEP_SAND "sand"
#define FOOTSTEP_GRASS "grass"
#define FOOTSTEP_WATER "water"
#define FOOTSTEP_RESIN "resin"
#define FOOTSTEP_CATWALK "catwalk"
#define FOOTSTEP_SNOW "snow"
#define FOOTSTEP_ICE "ice"
#define FOOTSTEP_CONCRETE "concrete"
//barefoot and claw sounds
#define FOOTSTEP_HARD "hard"
//misc footstep sounds
#define FOOTSTEP_GENERIC_HEAVY "heavy"

//footstep mob defines
#define FOOTSTEP_MOB_BAREFOOT 1
#define FOOTSTEP_XENO_HEAVY 2
#define FOOTSTEP_MOB_SHOE 3
#define FOOTSTEP_MOB_HUMAN 4 //Warning: Only works on /mob/living/carbon/human
#define FOOTSTEP_XENO_MEDIUM 5

GLOBAL_LIST_INIT(shoefootstep, list(
	FOOTSTEP_WOOD = list(list(
		'sound/effects/footstep/wood/wood_step1.ogg',
		'sound/effects/footstep/wood/wood_step2.ogg',
		'sound/effects/footstep/wood/wood_step3.ogg',
		'sound/effects/footstep/wood/wood_step4.ogg',
		'sound/effects/footstep/wood/wood_step5.ogg',
		'sound/effects/footstep/wood/wood_step6.ogg'), 100, 0),
	FOOTSTEP_CARPET = list(list(
		'sound/effects/footstep/carpet/carpet_step1.ogg',
		'sound/effects/footstep/carpet/carpet_step2.ogg',
		'sound/effects/footstep/carpet/carpet_step3.ogg',
		'sound/effects/footstep/carpet/carpet_step4.ogg',
		'sound/effects/footstep/carpet/carpet_step5.ogg',
		'sound/effects/footstep/carpet/carpet_step6.ogg',
		'sound/effects/footstep/carpet/carpet_step7.ogg',
		'sound/effects/footstep/carpet/carpet_step8.ogg'), 75, -1),
	FOOTSTEP_FLOOR = list(list(
		'sound/effects/footstep/tile1.wav',
		'sound/effects/footstep/tile2.wav',
		'sound/effects/footstep/tile3.wav',
		'sound/effects/footstep/tile4.wav'), 75, -1),
	FOOTSTEP_PLATING = list(list(
		'sound/effects/footstep/plating/plating1.ogg',
		'sound/effects/footstep/plating/plating2.ogg',
		'sound/effects/footstep/plating/plating3.ogg',
		'sound/effects/footstep/plating/plating4.ogg',
		'sound/effects/footstep/plating/plating5.ogg'), 100, 1),
	FOOTSTEP_CATWALK = list(list(
		'sound/effects/footstep/plating/catwalk1.ogg',
		'sound/effects/footstep/plating/catwalk2.ogg',
		'sound/effects/footstep/plating/catwalk3.ogg',
		'sound/effects/footstep/plating/catwalk4.ogg',
		'sound/effects/footstep/plating/catwalk5.ogg'), 100, 1),
	FOOTSTEP_CONCRETE = list(list(
		'sound/effects/footstep/concrete/concrete1.ogg',
		'sound/effects/footstep/concrete/concrete2.ogg',
		'sound/effects/footstep/concrete/concrete3.ogg',
		'sound/effects/footstep/concrete/concrete4.ogg',
		'sound/effects/footstep/concrete/concrete5.ogg'), 100, 1),
//nature
	FOOTSTEP_SNOW = list(list(
		'sound/effects/footstep/snow/snow1.ogg',
		'sound/effects/footstep/snow/snow2.ogg',
		'sound/effects/footstep/snow/snow3.ogg',
		'sound/effects/footstep/snow/snow4.ogg',
		'sound/effects/footstep/snow/snow5.ogg'), 100, 1),
	FOOTSTEP_ICE = list(list(
		'sound/effects/footstep/snow/ice1.ogg',
		'sound/effects/footstep/snow/ice2.ogg',
		'sound/effects/footstep/snow/ice3.ogg',
		'sound/effects/footstep/snow/ice4.ogg',
		'sound/effects/footstep/snow/ice5.ogg'), 60, 1),
	FOOTSTEP_SAND = list(list(
		'sound/effects/footstep/sand/sand_step1.ogg',
		'sound/effects/footstep/sand/sand_step2.ogg',
		'sound/effects/footstep/sand/sand_step3.ogg',
		'sound/effects/footstep/sand/sand_step4.ogg',
		'sound/effects/footstep/sand/sand_step5.ogg',
		'sound/effects/footstep/sand/sand_step6.ogg',
		'sound/effects/footstep/sand/sand_step7.ogg',
		'sound/effects/footstep/sand/sand_step8.ogg'), 75, 0),
	FOOTSTEP_GRASS = list(list(
		'sound/effects/footstep/grass/grass1.wav',
		'sound/effects/footstep/grass/grass2.wav',
		'sound/effects/footstep/grass/grass3.wav',
		'sound/effects/footstep/grass/grass4.wav'), 75, 0),
//generic
	FOOTSTEP_HARD = list(list(
		'sound/effects/footstep/hard/hard_barefoot1.ogg',
		'sound/effects/footstep/hard/hard_barefoot2.ogg',
		'sound/effects/footstep/hard/hard_barefoot3.ogg',
		'sound/effects/footstep/hard/hard_barefoot4.ogg',
		'sound/effects/footstep/hard/hard_barefoot5.ogg'), 80, -1),
	FOOTSTEP_RESIN = list(list(
		'sound/effects/footstep/alien_resin_move1.ogg',
		'sound/effects/footstep/alien_resin_move2.ogg',), 70, 2),
	FOOTSTEP_WATER = list(list(
		'sound/effects/footstep/water/slosh1.wav',
		'sound/effects/footstep/water/slosh2.wav',
		'sound/effects/footstep/water/slosh3.wav',
		'sound/effects/footstep/water/slosh4.wav'), 100, 1),
))
//bare footsteps lists
GLOBAL_LIST_INIT(barefootstep, list(
	FOOTSTEP_WOOD = list(list(
		'sound/effects/footstep/wood/wood_barefoot1.ogg',
		'sound/effects/footstep/wood/wood_barefoot2.ogg',
		'sound/effects/footstep/wood/wood_barefoot3.ogg',
		'sound/effects/footstep/wood/wood_barefoot4.ogg',
		'sound/effects/footstep/wood/wood_barefoot5.ogg'), 80, -1),
	FOOTSTEP_CARPET = list(list(
		'sound/effects/footstep/carpet/carpet_barefoot1.ogg',
		'sound/effects/footstep/carpet/carpet_barefoot2.ogg',
		'sound/effects/footstep/carpet/carpet_barefoot3.ogg',
		'sound/effects/footstep/carpet/carpet_barefoot4.ogg',
		'sound/effects/footstep/carpet/carpet_barefoot5.ogg'), 75, -2),
	FOOTSTEP_FLOOR = list(list(
		'sound/effects/footstep/tile1.wav',
		'sound/effects/footstep/tile2.wav',
		'sound/effects/footstep/tile3.wav',
		'sound/effects/footstep/tile4.wav'), 75, -1),
	FOOTSTEP_PLATING = list(list(
		'sound/effects/footstep/plating/plating1.ogg',
		'sound/effects/footstep/plating/plating2.ogg',
		'sound/effects/footstep/plating/plating3.ogg',
		'sound/effects/footstep/plating/plating4.ogg',
		'sound/effects/footstep/plating/plating5.ogg'), 100, 1),
	FOOTSTEP_CATWALK = list(list(
		'sound/effects/footstep/plating/catwalk1.ogg',
		'sound/effects/footstep/plating/catwalk2.ogg',
		'sound/effects/footstep/plating/catwalk3.ogg',
		'sound/effects/footstep/plating/catwalk4.ogg',
		'sound/effects/footstep/plating/catwalk5.ogg'), 100, 1),
	FOOTSTEP_CONCRETE = list(list(
		'sound/effects/footstep/hard/hard_barefoot1.ogg',
		'sound/effects/footstep/hard/hard_barefoot2.ogg',
		'sound/effects/footstep/hard/hard_barefoot3.ogg',
		'sound/effects/footstep/hard/hard_barefoot4.ogg',
		'sound/effects/footstep/hard/hard_barefoot5.ogg'), 80, -1),
//nature
	FOOTSTEP_SNOW = list(list(
		'sound/effects/footstep/snow/snow1.ogg',
		'sound/effects/footstep/snow/snow2.ogg',
		'sound/effects/footstep/snow/snow3.ogg',
		'sound/effects/footstep/snow/snow4.ogg',
		'sound/effects/footstep/snow/snow5.ogg'), 100, 1),
	FOOTSTEP_ICE = list(list(
		'sound/effects/footstep/snow/ice1.ogg',
		'sound/effects/footstep/snow/ice2.ogg',
		'sound/effects/footstep/snow/ice3.ogg',
		'sound/effects/footstep/snow/ice4.ogg',
		'sound/effects/footstep/snow/ice5.ogg'), 60, 1),
	FOOTSTEP_SAND = list(list(
		'sound/effects/footstep/sand/sand_step1.ogg',
		'sound/effects/footstep/sand/sand_step2.ogg',
		'sound/effects/footstep/sand/sand_step3.ogg',
		'sound/effects/footstep/sand/sand_step4.ogg',
		'sound/effects/footstep/sand/sand_step5.ogg',
		'sound/effects/footstep/sand/sand_step6.ogg',
		'sound/effects/footstep/sand/sand_step7.ogg',
		'sound/effects/footstep/sand/sand_step8.ogg'), 75, 0),
	FOOTSTEP_GRASS = list(list(
		'sound/effects/footstep/grass/grass1.wav',
		'sound/effects/footstep/grass/grass2.wav',
		'sound/effects/footstep/grass/grass3.wav',
		'sound/effects/footstep/grass/grass4.wav'), 75, 0),
//generic
	FOOTSTEP_HARD = list(list(
		'sound/effects/footstep/hard/hard_barefoot1.ogg',
		'sound/effects/footstep/hard/hard_barefoot2.ogg',
		'sound/effects/footstep/hard/hard_barefoot3.ogg',
		'sound/effects/footstep/hard/hard_barefoot4.ogg',
		'sound/effects/footstep/hard/hard_barefoot5.ogg'), 80, -1),
	FOOTSTEP_RESIN = list(list(
		'sound/effects/footstep/alien_resin_move1.ogg',
		'sound/effects/footstep/alien_resin_move2.ogg',), 70, 2),
	FOOTSTEP_WATER = list(list(
		'sound/effects/footstep/water/slosh1.wav',
		'sound/effects/footstep/water/slosh2.wav',
		'sound/effects/footstep/water/slosh3.wav',
		'sound/effects/footstep/water/slosh4.wav'), 100, 1),
))
//claw footsteps lists
GLOBAL_LIST_INIT(xenomediumstep, list(
	FOOTSTEP_WOOD = list(list(
		'sound/effects/footstep/wood/wood_claw1.ogg',
		'sound/effects/footstep/wood/wood_claw2.ogg',
		'sound/effects/footstep/wood/wood_claw3.ogg'), 90, 1),
	FOOTSTEP_CARPET = list(list(
		'sound/effects/footstep/carpet/carpet_barefoot1.ogg',
		'sound/effects/footstep/carpet/carpet_barefoot2.ogg',
		'sound/effects/footstep/carpet/carpet_barefoot3.ogg',
		'sound/effects/footstep/carpet/carpet_barefoot4.ogg',
		'sound/effects/footstep/carpet/carpet_barefoot5.ogg'), 75, -1),
	FOOTSTEP_FLOOR = list(list(
		'sound/effects/footstep/tile1.wav',
		'sound/effects/footstep/tile2.wav',
		'sound/effects/footstep/tile3.wav',
		'sound/effects/footstep/tile4.wav'), 75, -1),
	FOOTSTEP_PLATING = list(list(
		'sound/effects/footstep/plating/plating1.ogg',
		'sound/effects/footstep/plating/plating2.ogg',
		'sound/effects/footstep/plating/plating3.ogg',
		'sound/effects/footstep/plating/plating4.ogg',
		'sound/effects/footstep/plating/plating5.ogg'), 100, 1),
	FOOTSTEP_CATWALK = list(list(
		'sound/effects/footstep/plating/catwalk1.ogg',
		'sound/effects/footstep/plating/catwalk2.ogg',
		'sound/effects/footstep/plating/catwalk3.ogg',
		'sound/effects/footstep/plating/catwalk4.ogg',
		'sound/effects/footstep/plating/catwalk5.ogg'), 100, 1),
	FOOTSTEP_CONCRETE = list(list(
		'sound/effects/footstep/concrete/concrete1.ogg',
		'sound/effects/footstep/concrete/concrete2.ogg',
		'sound/effects/footstep/concrete/concrete3.ogg',
		'sound/effects/footstep/concrete/concrete4.ogg',
		'sound/effects/footstep/concrete/concrete5.ogg'), 90, 1),
//nature
	FOOTSTEP_SNOW = list(list(
		'sound/effects/footstep/snow/snow1.ogg',
		'sound/effects/footstep/snow/snow2.ogg',
		'sound/effects/footstep/snow/snow3.ogg',
		'sound/effects/footstep/snow/snow4.ogg',
		'sound/effects/footstep/snow/snow5.ogg'), 100, 1),
	FOOTSTEP_ICE = list(list(
		'sound/effects/footstep/snow/ice1.ogg',
		'sound/effects/footstep/snow/ice2.ogg',
		'sound/effects/footstep/snow/ice3.ogg',
		'sound/effects/footstep/snow/ice4.ogg',
		'sound/effects/footstep/snow/ice5.ogg'), 60, 1),
	FOOTSTEP_SAND = list(list(
		'sound/effects/footstep/sand/sand_step1.ogg',
		'sound/effects/footstep/sand/sand_step2.ogg',
		'sound/effects/footstep/sand/sand_step3.ogg',
		'sound/effects/footstep/sand/sand_step4.ogg',
		'sound/effects/footstep/sand/sand_step5.ogg',
		'sound/effects/footstep/sand/sand_step6.ogg',
		'sound/effects/footstep/sand/sand_step7.ogg',
		'sound/effects/footstep/sand/sand_step8.ogg'), 75, 0),
	FOOTSTEP_GRASS = list(list(
		'sound/effects/footstep/grass/grass1.wav',
		'sound/effects/footstep/grass/grass2.wav',
		'sound/effects/footstep/grass/grass3.wav',
		'sound/effects/footstep/grass/grass4.wav'), 75, 0),
//generic
	FOOTSTEP_HARD = list(list(
		'sound/effects/footstep/hard/hard_claw1.ogg',
		'sound/effects/footstep/hard/hard_claw2.ogg',
		'sound/effects/footstep/hard/hard_claw3.ogg',
		'sound/effects/footstep/hard/hard_claw4.ogg'), 80, -1),
	FOOTSTEP_RESIN = list(list(
		'sound/effects/footstep/alien_resin_move1.ogg',
		'sound/effects/footstep/alien_resin_move2.ogg',), 70, 2),
	FOOTSTEP_WATER = list(list(
		'sound/effects/footstep/water/slosh1.wav',
		'sound/effects/footstep/water/slosh2.wav',
		'sound/effects/footstep/water/slosh3.wav',
		'sound/effects/footstep/water/slosh4.wav'), 100, 1),
))
//heavy footsteps list
GLOBAL_LIST_INIT(xenoheavystep, list(
	FOOTSTEP_GENERIC_HEAVY = list(list(
		'sound/effects/footstep/hard/heavy1.ogg',
		'sound/effects/footstep/hard/heavy1.ogg',
		'sound/effects/footstep/hard/heavy2.ogg',
		'sound/effects/footstep/hard/heavy2.ogg'), 100, 2),
	FOOTSTEP_SNOW = list(list(
		'sound/effects/footstep/snow/snow1.ogg',
		'sound/effects/footstep/snow/snow2.ogg',
		'sound/effects/footstep/snow/snow3.ogg',
		'sound/effects/footstep/snow/snow4.ogg',
		'sound/effects/footstep/snow/snow5.ogg'), 100, 1),
	FOOTSTEP_RESIN = list(list(
		'sound/effects/footstep/alien_resin_move1.ogg',
		'sound/effects/footstep/alien_resin_move2.ogg',), 70, 2),
	FOOTSTEP_WATER = list(list(
		'sound/effects/footstep/water/slosh1.wav',
		'sound/effects/footstep/water/slosh2.wav',
		'sound/effects/footstep/water/slosh3.wav',
		'sound/effects/footstep/water/slosh4.wav'), 100, 2),
))
