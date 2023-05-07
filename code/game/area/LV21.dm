/area/lv21
	name = "\improper Whiskey Outpost"
	icon = 'icons/turf/area_whiskey.dmi'
	icon_state = "outside"
	ceiling = CEILING_METAL
	powernet_name = "ground"

/*
|***INSIDE AREAS***|
*/

/area/lv21/bunker
	name = "Interior Bunker"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/lv21/bunker/hospital
	name = "\improper Hospital"
	icon_state = "medical"

/area/lv21/bunker/hospital/operation_room_1
	name = "\improper Surgery One"

/area/lv21/bunker/hospital/operation_room_2
	name = "\improper Surgery Two"

/area/lv21/bunker/hospital/operation_room_3
	name = "\improper Surgery Three"

/area/lv21/bunker/hospital/triage
	name = "\improper Triage Center"

/area/lv21/bunker/cic
	name = "\improper Command Information Center"
	icon_state = "CIC"

/area/lv21/bunker/controller
	name = "\improper Controller"
	icon_state = "CIC"

/area/lv21/bunker/turbine_1
	name = "\improper Turbine One"
	icon_state = "engineering"

/area/lv21/bunker/turbine_2
	name = "\improper Turbine Two"
	icon_state = "engineering"

/area/lv21/bunker/engineering
	name = "\improper Engineering"
	icon_state = "engineering"

/area/lv21/bunker/reactor
	name = "\improper Reactor"
	icon_state = "engineering"

/area/lv21/bunker/living
	name = "\improper Living Quarters"
	icon_state = "livingspace"

/area/lv21/bunker/living/preps
	name = "\improper Marine Preparations"
	icon_state = "livingspace"

/area/lv21/bunker/supply
	name = "\improper Supply Depo"
	icon_state = "req"

/area/lv21/bunker/hangar
	name = "\improper Hangar"
	icon_state = "engineering"

/area/lv21/bunker/water_intake
	name = "\improper Water Intake"
	icon_state = "engineering"


/area/lv21/building
	name = "Building"

/*
|***OUTSIDE AREAS***|
*/

/area/lv21/ground
	name = "\improper Unused"
	icon_state = "outside"
	ceiling = CEILING_NONE
	//ambience = list('sound/ambience/jungle_amb1.ogg')
	requires_power = 1
	always_unpowered = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE

/area/lv21/ground/north
	name = "\improper Northern Beach"
	icon_state = "north"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv21/ground/north/northwest
	name = "\improper North-Western Beach"
	icon_state = "northwest"

/area/lv21/ground/north/northeast
	name = "\improper North-Eastern Beach"
	icon_state = "northeast"

/area/lv21/ground/north/beach
	name = "\improper Bunker Beach"
	icon_state = "farnorth"

/area/lv21/ground/north/platform
	name = "\improper Bunker Platform"
	icon_state = "platform"

/area/lv21/ground/lane

/area/lv21/ground/lane/one_north
	name = "\improper Western Jungle North"
	icon_state = "lane1n"

/area/lv21/ground/lane/one_south
	name = "\improper Western Jungle South"
	icon_state = "lane1s"

/area/lv21/ground/lane/two_north
	name = "\improper Western Path North"
	icon_state = "lane2n"

/area/lv21/ground/lane/two_south
	name = "\improper Western Path South"
	icon_state = "lane2s"

/area/lv21/ground/lane/three_north
	name = "\improper Eastern Path North"
	icon_state = "lane3n"

/area/lv21/ground/lane/three_south
	name = "\improper Eastern Path South"
	icon_state = "lane3s"

/area/lv21/ground/lane/four_north
	name = "\improper Eastern Crash Site North"
	icon_state = "lane4n"

/area/lv21/ground/lane/four_south
	name = "\improper Eastern Crash Site South"
	icon_state = "lane4s"

//lane4south
/area/lv21/ground/south
	name = "\improper Perimeter Entrance"
	icon_state = "south"

/area/lv21/ground/south/far
	name = "Southern Jungle"
	icon_state = "farsouth"

/area/lv21/ground/south/very_far
	name = "\improper Far-Southern Jungle"
	icon_state = "veryfarsouth"

/area/lv21/ground/mortar_pit
	name = "\improper Mortar Pit"
	icon_state = "mortarpit"

/area/lv21/ground/river
	name = "\improper River Central"
	icon_state = "river"

/area/lv21/ground/river/east
	name = "\improper River East"
	icon_state = "rivere"

/area/lv21/ground/river/west
	name = "\improper River West"
	icon_state = "riverw"

/*
|***CAVE AREAS***|
*/

/area/lv21/caves
	name = "\improper Rock"
	icon_state = "rock"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambisin4.ogg')
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	requires_power = 1
	always_unpowered = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE

/area/lv21/caves/tunnel
	name = "\improper Tunnel"
	icon_state = "tunnel"
	flags_area = AREA_NOTUNNEL

/area/lv21/caves/caverns
	name = "\improper Northern Caverns"
	icon_state = "caves"
/area/lv21/caves/caverns/west
	name = "\improper Western Caverns"
	icon_state = "caveswest"

/area/lv21/caves/caverns/east
	name = "\improper Eastern Caverns"
	icon_state = "caveseast"