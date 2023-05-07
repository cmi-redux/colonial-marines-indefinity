/*
 * Construction Node
 */

/obj/effect/alien/resin/construction
	name = "construction node"
	desc = "A strange wriggling lump. Looks like a marker for something."
	icon = 'icons/mob/xenos/weeds.dmi'
	icon_state = "constructionnode"
	density = FALSE
	anchored = TRUE
	health = 200
	block_range = 1

	var/datum/construction_template/xenomorph/template //What we're building

/obj/effect/alien/resin/construction/Initialize(mapload, datum/faction/faction_to_set)
	. = ..()

	if(faction_to_set)
		faction = faction_to_set

	set_hive_data(src, faction)

/obj/effect/alien/resin/construction/Destroy()
	if(template && faction && (template.crystals_stored < template.crystals_required))
		faction.crystal_stored += template.crystals_stored
		faction.remove_construction(src)

	template = null
	faction = null
	return ..()

/obj/effect/alien/resin/construction/update_icon()
	..()
	overlays.Cut()
	if(template)
		var/image/I = template.get_structure_image()
		I.alpha = 122
		I.pixel_x = template.pixel_x
		I.pixel_y = template.pixel_y
		overlays += I

/obj/effect/alien/resin/construction/get_examine_text(mob/user)
	. = ..()
	if((isxeno(user) || isobserver(user)) && faction)
		var/message = "A [template.name] construction is designated here. It requires [template.crystals_required - template.crystals_stored] more [MATERIAL_CRYSTAL]."
		. += message

/obj/effect/alien/resin/construction/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(!faction || (faction && (xeno.faction != faction)) || (xeno.a_intent == INTENT_HARM && xeno.can_destroy_special()))
		return ..()

	if(!template)
		to_chat(xeno, SPAN_XENOWARNING("There is no template!"))
	else
		template.add_crystal(xeno) //This proc handles attack delay itself.
	return XENO_NO_DELAY_ACTION

/obj/effect/alien/resin/construction/proc/set_template(datum/construction_template/xenomorph/new_template)
	if(!istype(new_template) || !faction)
		return

	template = new_template
	template.owner = src
	template.build_loc = get_turf(src)
	template.faction = faction
	update_icon()
