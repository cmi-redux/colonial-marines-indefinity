/obj/item/hardpoint/primary/flamer
	name = "DRG-N Offensive Flamer Unit"
	desc = "A primary weapon for the tank that spews fire everywhere."

	icon_state = "drgn_flamer"
	disp_icon = "tank"
	disp_icon_state = "drgn_flamer"
	activation_sounds = list('sound/weapons/vehicles/flamethrower.ogg')

	health = 400
	cooldown = 20
	accuracy = 0.75
	firing_arc = 90

	origins = list(0, -3)

	ammo = new /obj/item/ammo_magazine/hardpoint/primary_flamer
	max_clips = 1

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 1),
		"8" = list(-32, 1)
	)

	use_muzzle_flash = FALSE

/obj/item/hardpoint/primary/flamer/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/primary/flamer/can_activate(mob/user, atom/A)
	if(!..())
		return FALSE

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)
	if(origin_turf == get_turf(A))
		return FALSE

	return TRUE

/obj/item/hardpoint/primary/flamer/fire_projectile(mob/user, atom/target_atom)
	set waitfor = FALSE

	if(!ammo || !ammo.ammo_position)
		return

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	var/range = get_dist(origin_turf, target_atom) + 1

	var/obj/item/projectile/proj = generate_bullet(user, origin_turf)
	SEND_SIGNAL(proj, COMSIG_BULLET_USER_EFFECTS, user)
	proj.fire_at(target_atom, user, src, range < proj.ammo.max_range ? range : proj.ammo.max_range, proj.ammo.shell_speed)

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(owner, target_atom))
