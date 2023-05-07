/*
 * Tunnels
 */

/obj/structure/tunnel
	name = "tunnel"
	desc = "A tunnel entrance. Looks like it was dug by some kind of clawed beast."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "hole"

	density = FALSE
	opacity = FALSE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = RESIN_STRUCTURE_LAYER
	plane = FLOOR_PLANE

	var/tunnel_desc = "" //description added by the hivelord.

	faction_to_get = FACTION_XENOMORPH_NORMAL

	health = 140
	var/id = null //For mapping

/obj/structure/tunnel/Initialize(mapload, datum/faction/faction_to_set)
	. = ..()

	var/turf/L = get_turf(src)
	tunnel_desc = L.loc.name + " ([loc.x], [loc.y]) [pick(greek_letters)]"//Default tunnel desc is the <area name> (x, y) <Greek letter>

	if(faction_to_set)
		faction = faction_to_set

	set_hive_data(src, faction)
	faction.tunnels += src

	var/obj/effect/alien/resin/trap/resin_trap = locate() in L
	if(resin_trap)
		qdel(resin_trap)

	SSmapview.add_marker(src, "xenotunnel")

/obj/structure/tunnel/Destroy()
	if(faction)
		faction.tunnels -= src

	for(var/mob/living/carbon/xenomorph/X in contents)
		X.forceMove(loc)
		to_chat(X, SPAN_DANGER("[src] suddenly collapses, forcing you out!"))
	. = ..()

/obj/structure/tunnel/proc/isfriendly(mob/target)
	var/mob/living/carbon/C = target
	if(istype(C) && C.ally(faction))
		return TRUE
	return FALSE

/obj/structure/tunnel/get_examine_text(mob/user)
	. = ..()
	if(tunnel_desc && (isfriendly(user) || isobserver(user)))
		. += SPAN_INFO("The pheromone scent reads: \'[tunnel_desc]\'")

/obj/structure/tunnel/proc/healthcheck()
	if(health <= 0)
		visible_message(SPAN_DANGER("[src] suddenly collapses!"))
		qdel(src)

/obj/structure/tunnel/bullet_act(obj/item/projectile/Proj)
	return FALSE

/obj/structure/tunnel/ex_act(severity)
	health -= severity/2
	healthcheck()

/obj/structure/tunnel/attackby(obj/item/W as obj, mob/user as mob)
	if(!isxeno(user))
		return ..()
	return attack_alien(user)

/obj/structure/tunnel/verb/use_tunnel()
	set name = "Use Tunnel"
	set category = "Object"
	set src in view(1)

	if(isxeno(usr) && isfriendly(usr) && (usr.loc == src))
		pick_tunnel(usr)
	else
		to_chat(usr, "You stare into the dark abyss" + "[contents.len ? ", making out what appears to be two little lights... almost like something is watching." : "."]")

/obj/structure/tunnel/verb/exit_tunnel_verb()
	set name = "Exit Tunnel"
	set category = "Object"
	set src in view(0)

	if(isxeno(usr) && (usr.loc == src))
		exit_tunnel(usr)

/obj/structure/tunnel/proc/pick_tunnel(mob/living/carbon/xenomorph/xeno)
	. = FALSE	//For peace of mind when it comes to dealing with unintended proc failures
	if(!istype(xeno) || xeno.stat || xeno.lying || !isfriendly(xeno) || !faction)
		return FALSE
	if(xeno in contents)
		var/list/tunnels = list()
		for(var/obj/structure/tunnel/T in faction.tunnels)
			if(T == src)
				continue
			if(!is_ground_level(T.z))
				continue

			tunnels += list(T.tunnel_desc = T)
		var/pick = tgui_input_list(usr, "Which tunnel would you like to move to?", "Tunnel", tunnels, theme="hive_status")
		if(!pick)
			return FALSE

		if(!(xeno in contents))
			//Xeno moved out of the tunnel before they picked a destination
			//No teleporting!
			return FALSE

		to_chat(xeno, SPAN_XENONOTICE("You begin moving to your destination."))

		var/tunnel_time = TUNNEL_MOVEMENT_XENO_DELAY

		if(xeno.mob_size >= MOB_SIZE_BIG) //Big xenos take WAY longer
			tunnel_time = TUNNEL_MOVEMENT_BIG_XENO_DELAY
		else if(islarva(xeno)) //larva can zip through near-instantly, they are wormlike after all
			tunnel_time = TUNNEL_MOVEMENT_LARVA_DELAY

		if(!do_after(xeno, tunnel_time, INTERRUPT_NO_NEEDHAND, 0))
			return FALSE

		var/obj/structure/tunnel/T = tunnels[pick]

		if(T.contents.len > 2)// max 3 xenos in a tunnel
			to_chat(xeno, SPAN_WARNING("The tunnel is too crowded, wait for others to exit!"))
			return FALSE
		if(!T.loc)
			to_chat(xeno, SPAN_WARNING("The tunnel has collapsed before you reached its exit!"))
			return FALSE

		xeno.forceMove(T)
		to_chat(xeno, SPAN_XENONOTICE("You have reached your destination."))
		return TRUE

/obj/structure/tunnel/proc/exit_tunnel(mob/living/carbon/xenomorph/xeno)
	. = FALSE //For peace of mind when it comes to dealing with unintended proc failures
	if(xeno in contents)
		xeno.forceMove(loc)
		visible_message(SPAN_XENONOTICE("\The [xeno] pops out of the tunnel!"), \
		SPAN_XENONOTICE("You pop out through the other side!"))
		return TRUE

//Used for controling tunnel exiting and returning
/obj/structure/tunnel/clicked(mob/user, list/mods)
	if(!isxeno(user) || !isfriendly(user))
		return ..()
	var/mob/living/carbon/xenomorph/X = user
	if(mods["ctrl"] && pick_tunnel(X))//Returning to original tunnel
		return TRUE
	else if(mods["alt"] && exit_tunnel(X))//Exiting the tunnel
		return TRUE
	. = ..()

/obj/structure/tunnel/attack_larva(mob/living/carbon/xenomorph/xeno)
	. = attack_alien(xeno)

/obj/structure/tunnel/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(!istype(xeno) || xeno.stat || xeno.lying)
		return XENO_NO_DELAY_ACTION

	if(!isfriendly(xeno))
		if(xeno.mob_size < MOB_SIZE_BIG)
			to_chat(xeno, SPAN_XENOWARNING("You aren't large enough to collapse this tunnel!"))
			return XENO_NO_DELAY_ACTION

		xeno.visible_message(SPAN_XENODANGER("[xeno] begins to fill [src] with dirt."),\
		SPAN_XENONOTICE("You begin to fill [src] with dirt using your massive claws."), max_distance = 3)
		xeno_attack_delay(xeno)

		if(!do_after(xeno, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL_OUT_OF_RANGE, max_dist = 1))
			to_chat(xeno, SPAN_XENOWARNING("You decide not to cave the tunnel in."))
			return XENO_NO_DELAY_ACTION

		src.visible_message(SPAN_XENODANGER("[src] caves in!"), max_distance = 3)
		qdel(src)

		return XENO_NO_DELAY_ACTION

	if(xeno.anchored)
		to_chat(xeno, SPAN_XENOWARNING("You can't climb through a tunnel while immobile."))
		return XENO_NO_DELAY_ACTION

	if(!faction.tunnels.len)
		to_chat(xeno, SPAN_WARNING("\The [src] doesn't seem to lead anywhere."))
		return XENO_NO_DELAY_ACTION

	if(contents.len > 2)
		to_chat(xeno, SPAN_WARNING("The tunnel is too crowded, wait for others to exit!"))
		return XENO_NO_DELAY_ACTION

	var/tunnel_time = TUNNEL_ENTER_XENO_DELAY

	if(xeno.mob_size >= MOB_SIZE_BIG) //Big xenos take WAY longer
		tunnel_time = TUNNEL_ENTER_BIG_XENO_DELAY
	else if(islarva(xeno)) //larva can zip through near-instantly, they are wormlike after all
		tunnel_time = TUNNEL_ENTER_LARVA_DELAY

	if(xeno.mob_size >= MOB_SIZE_BIG)
		xeno.visible_message(SPAN_XENONOTICE("[xeno] begins heaving their huge bulk down into \the [src]."), \
		SPAN_XENONOTICE("You begin heaving your monstrous bulk into \the [src]</b>."))
	else
		xeno.visible_message(SPAN_XENONOTICE("\The [xeno] begins crawling down into \the [src]."), \
		SPAN_XENONOTICE("You begin crawling down into \the [src]</b>."))

	xeno_attack_delay(xeno)
	if(!do_after(xeno, tunnel_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(xeno, SPAN_WARNING("Your crawling was interrupted!"))
		return XENO_NO_DELAY_ACTION

	if(faction.tunnels.len) //Make sure other tunnels exist
		xeno.forceMove(src) //become one with the tunnel
		to_chat(xeno, SPAN_HIGHDANGER("Alt + Click the tunnel to exit, Ctrl + Click to choose a destination."))
		pick_tunnel(xeno)
	else
		to_chat(xeno, SPAN_WARNING("\The [src] ended unexpectedly, so you return back up."))
	return XENO_NO_DELAY_ACTION
