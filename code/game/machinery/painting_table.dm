/obj/structure/painting_table
	name = "\improper Painting Table"
	desc = "Can repaint equipment."
	icon = 'icons/obj/structures/workbenches.dmi'
	icon_state = "paint_bench"
	unacidable = TRUE
	density = TRUE
	anchored = TRUE
	bound_width = 64
	bound_height = 32

/obj/structure/painting_table/attackby(obj/item/item as obj, mob/user as mob)
	if(user && user.client)
		if(user.client.donator_info.skins["[item.type]"] && !user.client.donator_info.skins_used["[item.type]"])
			handle_skinning(item, user)
			return
	. = ..()

/proc/handle_skinning(obj/item, mob/user)
	var/datum/entity/skin/skin_selection = user.client.donator_info.skins["[item.type]"]
	if(!skin_selection)
		return
	var/list/skins_choice = list()
	for(var/i in skin_selection.skin)
		skins_choice += skin_selection.skin[i]
	var/skin = tgui_input_list(usr, "Выберите скин, можно получить всего один (нажмите отмена чтобы выбрать стандартное)", "Скин", skins_choice)
	if(!skin)
		to_chat(user, SPAN_WARNING("Vending base skin."))
		return
	user.client.donator_info.skins_used["[item.type]"] = skin_selection
	item.skin(skin)
