/obj/item/map
	name = "map"
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "map"
	item_state = "map"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_TINY
	// color = ... (Colors can be names - "red, green, grey, cyan" or a HEX color code "#FF0000")
	var/dat // Page content
	var/html_link = ""
	var/window_size = "1280x720"
	var/minimap_name = "Target Map"
	var/datum/ui_minimap/minimap

/obj/item/map/attack_self(mob/user) //Open the map
	..()
	user.visible_message(SPAN_NOTICE("[user] opens the [src.name]. "))
	minimap.tgui_interact(user)

/obj/item/map/proc/link_minimap()
	set waitfor = FALSE
	WAIT_MAPVIEW_READY
	minimap = SSmapview.get_minimap_ui(null, GROUND_MAP_Z, minimap_name)

/obj/item/map/attack()
	return

//used by marine equipment machines to spawn the correct map.
/obj/item/map/current_map

/obj/item/map/current_map/Initialize(mapload, ...)
	. = ..()
	link_minimap()
	switch(SSmapping.configs[GROUND_MAP].map_name)
		if(MAP_LV_624)
			name = "\improper Lazarus Landing Map"
			desc = "A satellite printout of the Lazarus Landing colony on LV-624."
		if(MAP_ICE_COLONY)
			name = "\improper Ice Colony map"
			desc = "A satellite printout of the Ice Colony."
			color = "cyan"
		if(MAP_ICE_COLONY_V3)
			name = "\improper Shivas Snowball map"
			desc = "A labelled print out of the anterior scan of the UA colony Shivas Snowball."
			color = "cyan"
		if(MAP_BIG_RED)
			name = "\improper Solaris Ridge Map"
			desc = "A censored blueprint of the Solaris Ridge facility"
			color = "#e88a10"
		if(MAP_SKY_SCRAPER)
			name = "\improper Sky Scraper Map"
			desc = "A censored blueprint of the Sky Scraper in the Skyes"
			color = "white"
		if(MAP_PRISON_STATION)
			name = "\improper Fiorina Orbital Penitentiary Map"
			desc = "A labelled interior scan of Fiorina Orbital Penitentiary"
			color = "#e88a10"
		if(MAP_PRISON_STATION_V3)
			name = "\improper Fiorina Orbital Penitentiary Map"
			desc = "A scan produced by the the Almayer's sensor array of the Fiorina Orbital Penitentiary Civilian Annex. It appears to have broken off from the rest of the station and is now in free geo-sync orbit around the planet."
			color = "#e88a10"
		if(MAP_DESERT_DAM)
			name = "\improper Trijent Dam map"
			desc = "A map of Trijent Dam"
			color = "#cec13f"
			//did only the basics todo change later
		if(MAP_SOROKYNE_STRATA)
			name = "\improper Sorokyne Strata map"
			desc = "A map of the Weyland-Yutani colony Sorokyne Outpost, commonly known as Sorokyne Strata."
			color = "cyan"
		if(MAP_CORSAT)
			name = "\improper CORSAT map"
			desc = "A blueprint of CORSAT station"
			color = "red"
		if(MAP_KUTJEVO)
			name = "\improper Kutjevo Refinery map"
			desc = "An orbital scan of Kutjevo Refinery"
			color = "red"
		if(MAP_LV522_CHANCES_CLAIM)
			name = "\improper LV-522 Map"
			desc = "An overview of LV-522 schematics."
			html_link = "images/b/bb/C_claim.png"
			color = "cyan"
		if(MAP_NEW_VARADERO)
			name = "\improper New Varadero map"
			desc = "The blueprint and readout of the UA outpost New Varadero"
			html_link = "images/0/0d/Kutjevo_a1.jpg"//replace later
			color = "red"
		if(MAP_WHISKEY_OUTPOST)
			name = "\improper Whiskey Outpost map"
			desc = "A tactical printout of the Whiskey Outpost defensive positions and locations."
			color = "grey"
		if(MAP_RAVENUE_5)
			name = "\improper Ravenue 5 map"
			desc = "A tactical printout of the Ravenue 5 defensive positions and locations."
			color = "grey"
		else
			return INITIALIZE_HINT_QDEL



// Landmark - Used for mapping. Will spawn the appropriate map for each gamemode (LV map items will spawn when LV is the gamemode, etc)
/obj/effect/landmark/map_item
	name = "map item"
	icon_state = "ipool"

/obj/effect/landmark/map_item/Initialize(mapload, ...)
	. = ..()
	GLOB.map_items += src

/obj/effect/landmark/map_item/Destroy()
	GLOB.map_items -= src
	return ..()
