/obj/item/ammo_magazine/hardpoint/tank_glauncher
	name = "M92T Grenade Launcher Magazine"
	desc = "A secondary armament grenade magazine."
	caliber = "grenade"
	icon_state = "glauncher_2"
	w_class = SIZE_LARGE
	ammo_preset = list(/datum/ammo/grenade_container)
	max_rounds = 10
	gun_type = /obj/item/hardpoint/secondary/grenade_launcher

/obj/item/ammo_magazine/hardpoint/tank_glauncher/update_icon()
	if(ammo_position >= max_rounds)
		icon_state = "glauncher_2"
	else if(ammo_position <= 0)
		icon_state = "glauncher_0"
	else
		icon_state = "glauncher_1"
