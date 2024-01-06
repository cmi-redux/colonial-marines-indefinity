/obj/item/hardpoint/armor/snowplow
	name = "Snowplow"
	desc = "Clears road for friendlies."

	icon_state = "snowplow"
	disp_icon = "tank"
	disp_icon_state = "snowplow"

	health = 1600
	activatable = 1

	type_multipliers = list(
		"blunt" = 0.1,
		"all" = 0.8
	)

/obj/item/hardpoint/armor/snowplow/livingmob_interact(mob/living/M)
	var/turf/targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	M.throw_atom(targ, 4, SPEED_VERY_FAST, src, 1)
	M.apply_damage(40 + rand(0, 100), BRUTE)

/obj/item/hardpoint/armor/snowplow/on_move(turf/old, turf/new_turf, move_dir)
	if(health <= 0)
		return

	if(dir != move_dir)
		return

	var/turf/ahead = get_step(new_turf, move_dir)

	var/list/turfs_ahead = list(ahead, get_step(ahead, turn(move_dir, 90)), get_step(ahead, turn(move_dir, -90)))
	for(var/turf/T in turfs_ahead)
		if(istype(T.snow))
			var/obj/structure/snow/snow = T.snow
			if(!snow)
				continue
			new /obj/item/stack/snow(snow.loc, snow.bleed_layer)
			snow.changing_layer(0)
		else if(istype(T.weeds))
			T.weeds.Destroy()
		else if(istype(T, /turf/closed/wall))
			var/turf/closed/wall/next_wall = T
			next_wall.take_damage(250)
		else if(istype(T, /turf/open))
			for(var/atom/movable/atom in T.contents)
				atom.throw_atom(get_step(T, turn(move_dir, 90)), 4, SPEED_SLOW, src, TRUE, HIGH_LAUNCH)
		else
			continue
