//no dynamic lighting, powered.
/area/event
	name = "Open grounds (event P)"
	icon = 'icons/turf/areas_event.dmi'
	icon_state = "event"

	//no bioscan and no tunnels allowed
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL

	//events are not part of regular gameplay, therefore, no statistics
	statistic_exempt = TRUE

	//always powered
	requires_power = FALSE
	unlimited_power = TRUE

//no dynamic lighting, unpowered.
/area/event/unpowered
	name = "Open grounds (event)"
	icon_state = "event_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/dynamic
	name = "Open grounds (event PD)"
	icon_state = "event_dyn"
	requires_power = TRUE
	unlimited_power = TRUE

//no dynamic lighting, unpowered.
/area/event/dynamic/unpowered
	name = "Open grounds (event D)"
	icon_state = "event_dyn_nopower"

	unlimited_power = FALSE
	base_lighting_alpha = 255

//dynamic lighting, lit, powered.
/area/event/dynamic/lit
	name = "Open grounds (event PDL)"
	icon_state = "event_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/dynamic/lit/unpowered
	name = "Open grounds (event DL)"
	icon_state = "event_dyn_lit_nopower"

	unlimited_power = FALSE
	base_lighting_alpha = 255

//no dynamic lighting, powered.
/area/event/metal
	name = "Building interior (event P)"
	name = "Event interior area"
	icon_state = "metal"

//no dynamic lighting, unpowered.
/area/event/metal/unpowered
	name = "Building interior (event)"
	icon_state = "metal_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/metal/dynamic
	name = "Building interior (event PD)"
	icon_state = "metal_dyn"
	requires_power = TRUE
	unlimited_power = TRUE

//no dynamic lighting, unpowered.
/area/event/metal/dynamic/unpowered
	name = "Building interior (event D)"
	icon_state = "metal_dyn_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, lit, powered.
/area/event/metal/dynamic/lit
	name = "Building interior (event PDL)"
	icon_state = "metal_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/metal/dynamic/lit/unpowered
	name = "Building interior (event DL)"
	icon_state = "metal_dyn_lit_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//no dynamic lighting, powered.
/area/event/underground
	name = "Small caves (event P)"
	icon_state = "under"

	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25

//no dynamic lighting, unpowered.
/area/event/underground/unpowered
	name = "Small caves (event)"
	icon_state = "under_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/underground/dynamic
	name = "Small caves (event PD)"
	icon_state = "under_dyn"
	requires_power = TRUE
	unlimited_power = TRUE

//no dynamic lighting, unpowered.
/area/event/underground/dynamic/unpowered
	name = "Small caves (event D)"
	icon_state = "under_dyn_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, lit, powered.
/area/event/underground/dynamic/lit
	name = "Small caves (event PDL)"
	icon_state = "under_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/underground/dynamic/lit/unpowered
	name = "Small caves (event DL)"
	icon_state = "under_dyn_lit_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//no dynamic lighting, powered.
/area/event/underground_no_CAS
	name = "Caves (event P)"
	name = "Event underground area"
	icon_state = "undercas"

	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25

//no dynamic lighting, unpowered.
/area/event/underground_no_CAS/unpowered
	name = "Caves (event)"
	icon_state = "undercas_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/underground_no_CAS/dynamic
	name = "Caves (event PD)"
	icon_state = "undercas_dyn"
	requires_power = TRUE
	unlimited_power = TRUE

//no dynamic lighting, unpowered.
/area/event/underground_no_CAS/dynamic/unpowered
	name = "Caves (event D)"
	icon_state = "undercas_dyn_nopower"

	unlimited_power = FALSE

//dynamic lighting, lit, powered.
/area/event/underground_no_CAS/dynamic/lit
	name = "Caves (event PDL)"
	icon_state = "undercas_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/underground_no_CAS/dynamic/lit/unpowered
	name = "Caves (event DL)"
	icon_state = "undercas_dyn_lit_nopower"

	unlimited_power = FALSE

//no dynamic lighting, powered.
/area/event/deep_underground
	name = "Deep underground (event P)"
	icon_state = "deep"

	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25

//no dynamic lighting, unpowered.
/area/event/deep_underground/unpowered
	name = "Deep underground (event)"
	icon_state = "deep_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/deep_underground/dynamic
	name = "Deep underground (event PD)"
	icon_state = "deep_dyn"
	requires_power = TRUE
	unlimited_power = TRUE

//no dynamic lighting, unpowered.
/area/event/deep_underground/dynamic/unpowered
	name = "Deep underground (event D)"
	icon_state = "deep_dyn_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, lit, powered.
/area/event/deep_underground/dynamic/lit
	name = "Deep underground (event PDL)"
	icon_state = "deep_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/deep_underground/dynamic/lit/unpowered
	name = "Deep underground (event DL)"
	icon_state = "deep_dyn_lit_nopower"

	requires_power = TRUE
	unlimited_power = FALSE
