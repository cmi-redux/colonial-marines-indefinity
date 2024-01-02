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
	var/minimap_name = "Target Map"
	var/datum/ui_minimap/minimap

/obj/item/map/Initialize(mapload, ...)
	. = ..()
	link_minimap()

/obj/item/map/attack_self(mob/user) //Open the map
	..()
	user.visible_message(SPAN_NOTICE("[user] opens the [src.name]. "))
	minimap.tgui_interact(user)

/obj/item/map/proc/link_minimap()
	set waitfor = FALSE
	WAIT_MAPVIEW_READY
	minimap = SSmapview.get_minimap_ui(null, GROUND_MAP_Z, src, FALSE, minimap_name)

/obj/item/map/attack()
	return

//used by marine equipment machines to spawn the correct map.
/obj/item/map/current_map

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
