/obj/structure/dps_tester
	name = "DPS xenomorph tester"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	icon = 'icons/obj/structures/machinery/bolt_target.dmi'
	icon_state = "opened"
	COOLDOWN_DECLARE(calculation_timer)
	var/dps = 0
	var/time_calculation = 30 SECONDS
	var/armor_simulation = 0
	var/explosive_armor_simulation = 0

/obj/structure/dps_tester/ex_act(severity)
	damaged(armor_damage_reduction(GLOB.xeno_explosive, severity, armor_simulation , 60, 0, 0.5, armor_simulation))

/obj/structure/dps_tester/bullet_act(obj/item/projectile/projectile)
	damaged(armor_damage_reduction(GLOB.xeno_ranged, projectile.calculate_damage(), armor_simulation, projectile.ammo.penetration, projectile.ammo.pen_armor_punch, projectile.ammo.damage_armor_punch, armor_simulation))

/obj/structure/dps_tester/attackby(obj/item/weapon/melee/weapon, mob/user)
	var/power = weapon.force
	if(user.skills)
		power = round(power * (1 + 0.25 * user.skills.get_skill_level(SKILL_MELEE_WEAPONS)))
	damaged(armor_damage_reduction(GLOB.xeno_melee, power, armor_simulation , 20, 0, 0, armor_simulation))

/obj/structure/dps_tester/proc/damaged(damage, type)
	if(COOLDOWN_FINISHED(src, calculation_timer))
		dps = 0
		COOLDOWN_START(src, calculation_timer, time_calculation)
	dps += damage

	visible_message("DPS: [dps/(time_calculation-COOLDOWN_TIMELEFT(src, calculation_timer))]")
