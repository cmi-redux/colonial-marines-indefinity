#define M2C_SETUP_TIME 4
#define M2C_OVERHEAT_CRITICAL 18
#define M2C_OVERHEAT_BAD 10
#define M2C_OVERHEAT_OK 2
#define M2C_OVERHEAT_DAMAGE 30
#define M2C_LOW_COOLDOWN_ROLL 0.3
#define M2C_HIGH_COOLDOWN_ROLL 0.45
#define M2C_PASSIVE_COOLDOWN_AMOUNT 3
#define M2C_OVERHEAT_OVERLAY 14
#define M2C_CRUSHER_STUN 3
#define SGL2_SETUP_TIME 100


//////////////////////////////////////////////////////////////
//MOUNTED DEFENCE
//////////////////////////////////////////////////////////////

/obj/structure/machinery/mounted_defence
	name = "Стационарное Укрепление"
	var/base_name = "Стационарное Укрепление"
	desc = "Сюда нужно положить стационарное разобранное оружие, после чего его можно будет использовать."
	icon = 'icons/obj/structures/barricades.dmi'
	icon_state = "small_place"
	anchored = 1
	unslashable = TRUE
	unacidable = TRUE
	density = 1
	layer = ABOVE_MOB_LAYER //no hiding the hmg beind corpse
	use_power = 0

	//at spawn create in weapon
	var/prebuild = 0
	var/parrent_type_gun
	var/undestructible = 0

	var/list/cadeblockers = list()
	var/cadeblockers_range = 0

	var/md_class = 0

	var/obj/item/weapon/gun/mounted/MD = null

	projectile_coverage = PROJECTILE_COVERAGE_LOW

	var/damage_state = null

	health = 600
	var/health_max = 600 //Why not just give it sentry-tier health for now.

	var/user_old_x = 0
	var/user_old_y = 0

	var/zoom = 0 // 0 is it doesn't zoom, 1 is that it zooms.
	var/tileoffset = 5
	var/viewsize = 12

/obj/structure/machinery/mounted_defence/Initialize()
	. = ..()
	for(var/turf/T in range(cadeblockers_range, src))
		var/obj/structure/blocker/anti_cade/CB = new(T)
		CB.to_block = src

		cadeblockers.Add(CB)

/obj/structure/machinery/mounted_defence/Destroy()
	QDEL_NULL_LIST(cadeblockers)
	return ..()

/obj/structure/machinery/mounted_defence/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if(PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

//Making so rockets don't hit
/obj/structure/machinery/mounted_defence/calculate_cover_hit_boolean(obj/item/projectile/P, distance = 0, cade_direction_correct = FALSE)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & AMMO_ROCKET)
		return 0
	..()

/obj/structure/machinery/mounted_defence/BlockedPassDirs(atom/movable/mover, target_turf)
	if(istype(mover, /obj/item) && mover.throwing)
		return FALSE
	else
		return ..()

/obj/structure/machinery/mounted_defence/proc/CrusherImpact()
	update_health(300)

/obj/structure/machinery/mounted_defence/proc/check_class(m_class)
	if(m_class > md_class)
		return FALSE
	return TRUE

/obj/structure/machinery/mounted_defence/attackby(obj/item/O as obj, mob/user, mob/living/E)
	if(!ishuman(user))
		return

	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		if(undestructible)
			return
		if(!anchored)
			var/turf/T = get_turf(src)
			if(T.density)
				to_chat(user, SPAN_WARNING("Невозможно установить [src] тут, что-то мешает на пути."))
				return
		else if(anchored)
			to_chat(user, "Вы начинаете откреплять [src]...")
		else
			to_chat(user, "Вы начинаете закреплять [src] на месте...")

		var/old_anchored = anchored
		if(do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && anchored == old_anchored)
			anchored = !anchored
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
			if(anchored)
				user.visible_message(SPAN_NOTICE("[user] закрепляет [src] на месте."),SPAN_NOTICE("Вы закрепили [src] на месте."))
			else
				user.visible_message(SPAN_NOTICE("[user] открепляет [src]."),SPAN_NOTICE("Вы открепили [src]."))
		return
	else if(istype(O, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/M = O
		if(!check_class(M.class))
			to_chat(user, SPAN_WARNING("[MD] слишком большой для [src]."))
			return
		if(!md_class)
			to_chat(user, SPAN_WARNING("[MD] слишком большой для [src]."))
			return
		if(!anchored && !prebuild)
			to_chat(user, SPAN_WARNING("[MD] нельзя закрепить на [src]."))
			return
		else if(!MD)
			user.visible_message(SPAN_NOTICE("[user] начал вставлять [MD] в [src]."),
			SPAN_NOTICE("Вы начали вставлять [O] в [src]."))
			if(do_after(user, 100 * M.class * md_class * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(user.drop_inv_item_to_loc(O, src))
					MD = O
					user.visible_message(SPAN_NOTICE("[user] вставил [MD] в [src]."),
					SPAN_NOTICE("Вы вставляете [O] в [src]."))
					MD.flags_mounted_gun_features |= GUN_MOUNTED
					name = "[MD] на [base_name]"
					zoom = MD.zooms
					update_icon()
			return
		else
			to_chat(user, SPAN_WARNING("В [src] место занято, для замены надо в начале снять [MD]."))

	else if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		if(health < 150)
			to_chat(user, SPAN_WARNING("В начале надо починить [src], прежде чем снимать с него [MD]."))
			return
		if(MD && !prebuild)
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] начал снимать [MD] с [src]."),
			SPAN_NOTICE("Вы начинаете снимать [MD] с [src]."))
			if(do_after(user, 200 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(SPAN_NOTICE("[user] снял [MD] с [src]."),
				SPAN_NOTICE("Вы сняли [MD] с [src]."))
				MD.flags_mounted_gun_features &= ~GUN_BURST_FIRING
				MD.update_icon()
				name = base_name
				user.put_in_hands(MD)
				MD = null
				update_icon()
			return
		else
			to_chat(user, SPAN_WARNING("Нечего снимать с [src]."))
			return

	else if(istype(O, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = O
		if(do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(WT.remove_fuel(3, user))
				to_chat(user, SPAN_NOTICE("Вы починили повреждения [src]."))
				update_health(-100)
			return
		return

	else if(istype(O, /obj/item/ammo_magazine))
		MD.reload(user, O)
		update_icon()
		return
	else if(istype(O, /obj/item/explosive/grenade))
		MD.on_pocket_attackby(O, user)
		update_icon()
		return

	else if(istype(O, /obj/item/prop/helmetgarb/gunoil))
		var/obj/item/prop/helmetgarb/gunoil/GO = O
		var/oil_verb = pick("lubes", "oils", "cleans", "tends to", "gently strokes")
		if(do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
			if(GO.remove_oil(2, user))
				user.visible_message("[user] [oil_verb] [MD]. It shines like new.", "You oil up and immaculately clean [MD]. It shines like new.")
				MD.clean_blood()
				MD.oil(MD.oil_max/2,1)
			return
		else
			return

	return ..()

/obj/structure/machinery/mounted_defence/bullet_act(obj/item/projectile/P) //Nope.
	bullet_ping(P)
	visible_message(SPAN_WARNING("В [src] попал [P.name]!"))
	update_health(round(P.damage / 10)) //Universal low damage to what amounts to a post with a gun.
	return 1

/obj/structure/machinery/mounted_defence/update_health(damage)
	health -= damage
	if(health <= 0)
		playsound(src, 'sound/effects/metal_crash.ogg', 25, 1)
		qdel(src)

/obj/structure/machinery/mounted_defence/MouseDrop(over_object, src_location, over_location) //Drag the tripod onto you to fold it.
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr //this is us

	if(!Adjacent(user))
		return

	src.add_fingerprint(usr)
	if(anchored && (over_object == user && (in_range(src, user) || locate(src) in user))) //Make sure its on ourselves
		if(user.interactee == src)
			user.unset_interaction()
			visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("[user] решил дать кому-то другому попробывать.")]")
			to_chat(usr, SPAN_NOTICE("Вы решили дать кому-то другому пострелять."))
			return
		if(operator) //If there is already a operator then they're manning it.
			if(operator.interactee == null)
				operator = null //this shouldn't happen, but just in case
			else
				to_chat(user, "Кто-то уже за пушкой.")
				return
		else
			if(user.interactee) //Make sure we're not manning two guns at once, tentacle arms.
				to_chat(user, "Вы уже делаете что-то другое!")
				return
			if(user.get_active_hand() != null)
				to_chat(user, SPAN_WARNING("Вы должны быть с пустыми руками, чтобы управлять [src]."))
			else
				visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("[user] mans the [MD]!")]")
				to_chat(user, SPAN_NOTICE("Вы за орудием!"))
				user.set_interaction(src)

	else if(over_object == user && in_range(src, user) && !prebuild)
		if(anchored)
			to_chat(user, SPAN_WARNING("[src] не может быть снят, пока прекручен."))
			return
		if(MD)
			to_chat(user, SPAN_WARNING("[src] не может быть снят, пока на нем закреплено орудие."))
			return
		to_chat(user, SPAN_NOTICE("Вы сняли [src]."))
		var/obj/item/device/mounted_defence/tripod/M = new(loc)
		user.put_in_hands(M)
		qdel(src)

/obj/structure/machinery/mounted_defence/on_set_interaction(mob/living/user)
	user.frozen = TRUE
	flags_atom |= RELAY_CLICK
	user.status_flags |= IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] mans \the [src]."),SPAN_NOTICE("You man \the [src], locked and loaded!"))
	user.update_canmove()
	user.forceMove(get_step(loc, GLOB.reverse_dir[dir]))
	user.setDir(dir)
	user_old_x = user.pixel_x
	user_old_y = user.pixel_y

	if(zoom)
		if(user.client)
			user.client.change_view(viewsize, src)
			var/viewoffset = tileoffset * 32
			var/zoom_offset_time = 4*((viewoffset/32)/7)
			switch(user.dir)
				if(NORTH)
					animate(user.client, pixel_x = 0, pixel_y = viewoffset, time = zoom_offset_time)
				if(SOUTH)
					animate(user.client, pixel_x = 0, pixel_y = -viewoffset, time = zoom_offset_time)
				if(EAST)
					animate(user.client, pixel_x = viewoffset, pixel_y = 0, time = zoom_offset_time)
				if(WEST)
					animate(user.client, pixel_x = -viewoffset, pixel_y = 0, time = zoom_offset_time)

//		user.add_fov_trait(src, "no_fov")

	operator = user
	user.unfreeze()
	if(MD.flags_gun_features & GUN_AMMO_COUNTER)
		user.hud_used.add_ammo_hud(MD, MD.get_ammo_list(), MD.get_display_ammo_count())

/obj/structure/machinery/mounted_defence/on_unset_interaction(mob/living/user)
	flags_atom &= ~RELAY_CLICK
	user.status_flags &= ~IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] lets go of \the [src]."),SPAN_NOTICE("You let go of \the [src], letting the gun rest."))
	user.update_canmove()
	user.reset_view(null)
	var/grip_dir = reverse_direction(dir)
	var/old_dir = dir
	step(user, grip_dir)
	user_old_x = 0
	user_old_y = 0
	user.setDir(old_dir)
	if(zoom)
//		user.remove_fov_trait(src, "no_fov")
		if(user.client)
			user.client.change_view(world_view_size, src)
			animate(user.client, 8, pixel_x = 0, pixel_y = 0)
	if(operator == user)
		user.hud_used.remove_ammo_hud(MD)
		operator = null

/obj/structure/machinery/mounted_defence/check_eye(mob/user)
	if(user.lying || get_dist(user,src) > 1 || user.is_mob_incapacitated() || !user.client || user.dir != dir)
		user.unset_interaction()

/obj/structure/machinery/mounted_defence/attack_alien(mob/living/carbon/xenomorph/M)
	if(islarva(M))
		return

	M.visible_message(SPAN_DANGER("[M] ударил [src]!"),
	SPAN_DANGER("Вы бьете [src]!"))
	M.animation_attack_on(src)
	M.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	update_health(rand(M.melee_damage_lower,M.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/machinery/mounted_defence/update_icon()
	if(overlays)
		overlays.Cut()
	else
		overlays = list()
	if(MD)
		overlays += MD.mounted_state

/obj/structure/machinery/mounted_defence/get_examine_text(mob/user)
	. = ..()
	if(MD)
		. += "Установлено [MD], [MD.desc].<br>"
	else if(!anchored)
		. += "Оно должно быть <B>прикручено</b>.<br>"
	else
		. += "Ничего не установлено.<br>"

/obj/structure/machinery/mounted_defence/handle_click(mob/living/user, atom/target, list/mods)
	if(!operator)
		return HANDLE_CLICK_UNHANDLED
	if(operator != user)
		return HANDLE_CLICK_UNHANDLED
	if(istype(target,/atom/movable/screen))
		return HANDLE_CLICK_UNHANDLED
	if(user.lying || get_dist(user,src) > 1 || user.is_mob_incapacitated() || !user.client || user.dir != dir)
		user.unset_interaction()
		return HANDLE_CLICK_UNHANDLED
	if(user.get_active_hand())
		to_chat(usr, SPAN_WARNING("Вам нужна свободная рука, чтобы стрелять с [src]."))
		return HANDLE_CLICK_UNHANDLED

	if(!istype(target))
		return HANDLE_CLICK_UNHANDLED

	if(target.z != src.z || target.z == 0 || src.z == 0 || isnull(operator.loc) || isnull(src.loc))
		return HANDLE_CLICK_UNHANDLED

	if(get_dist(target,src.loc) > 15)
		return HANDLE_CLICK_UNHANDLED

	if(mods["middle"] || mods["shift"] || mods["alt"] || mods["ctrl"])
		return HANDLE_CLICK_PASS_THRU

	var/angle = get_dir(src, target)
	//we can only fire in a 90 degree cone
	if(target.loc != src.loc && target.loc != operator.loc)
		if(dir & angle)
			MD.afterattack(target,user,0,mods,operator)
			MD.display_ammo(user)
			if(!MD.ammo)
				update_icon()
			return HANDLE_CLICK_HANDLED
		else if(handle_outside_cone(user))
			return HANDLE_CLICK_HANDLED
	return HANDLE_CLICK_UNHANDLED

/obj/structure/machinery/mounted_defence/proc/handle_outside_cone(mob/living/carbon/human/user)
	return FALSE

/obj/structure/machinery/mounted_defence/clicked(mob/user, list/mods)
	if(isobserver(user)) return

	if(mods["ctrl"])
		if(operator != user)
			return
		toggle_burst()
		return 1
	return ..()

/obj/structure/machinery/mounted_defence/proc/toggle_burst()
	if(!MD) return

	if(MD.burst_amount < 2 && !(MD.flags_gun_features & GUN_HAS_FULL_AUTO))
		to_chat(usr, SPAN_WARNING("Это оружие не имеет режима стрельбы очередями!"))
		return

	if(MD.flags_gun_features & GUN_BURST_FIRING)//can't toggle mid burst
		return

	playsound(usr, 'sound/weapons/handling/gun_burst_toggle.ogg', 15, 1)

	MD.flags_gun_features ^= GUN_BURST_ON
	to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] Вы [MD.flags_gun_features & GUN_BURST_ON ? "<B>включили</b>" : "<B>выключили</b>"] [src] режим стрельбы очередями."))


/obj/structure/machinery/mounted_defence/tripod
	name = "Триног"
	base_name = "Триног"
	desc = "Триног на который можно установить стационарное легкое вооружение."
	icon_state = "tripod"
	md_class = 1
	anchored = 0
	density = 1
	health = 300
	health_max = 300
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	zoom = 1

/obj/item/device/mounted_defence
	icon = 'icons/obj/structures/barricades.dmi'
	unacidable = TRUE
	w_class = SIZE_MEDIUM

/obj/item/device/mounted_defence/tripod_frame
	name = "Заготовка Тринога"
	desc = "Почти готовый триног, который надо <B>сварить</b>."
	icon_state = "folded_tripod_frame"

/obj/item/device/mounted_defence/tripod_frame/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			var/obj/item/device/mounted_defence/tripod/P = new(user.loc)
			to_chat(user, SPAN_NOTICE("Вы сварили [src] в [P]."))
			qdel(src)
			user.put_in_hands(P)
		return
	return ..()

/obj/item/device/mounted_defence/tripod
	name = "Триног"
	desc = "Триног на который можно установить стационарное легкое вооружение."
	icon_state = "folded_tripod"

/// Causes the tripod to unfold
/obj/item/device/mounted_defence/tripod/attack_self(mob/user)
	..()

	if(!ishuman(usr))
		return
	to_chat(user, SPAN_NOTICE("Вы устанавливаете [src]."))
	var/obj/structure/machinery/mounted_defence/tripod/M = new /obj/structure/machinery/mounted_defence/tripod(user.loc)
	M.name = src.name
	M.setDir(user.dir) // Make sure we face the right direction
	qdel(src)

/obj/structure/machinery/mounted_defence/tripod/prebuild
	prebuild = 1
	parrent_type_gun
	undestructible = 1
	density = 1
	anchored = 1

/obj/structure/machinery/mounted_defence/tripod/prebuild/Initialize()
	. = ..()
	if(parrent_type_gun)
		MD = new parrent_type_gun()
		MD.flags_mounted_gun_features |= GUN_MOUNTED
		name = "[MD] на [base_name]"
		zoom = MD.zooms
		MD.forceMove(src)
		update_icon()

/obj/structure/machinery/mounted_defence/tripod/prebuild/mg_turret
	name = "Нест"
	desc = "Нест на который можно установить стационарное легкое вооружение"
	icon_state = "small_place_sand"
	projectile_coverage = PROJECTILE_COVERAGE_HIGH
	parrent_type_gun = /obj/item/weapon/gun/mounted/m56d_gun

/obj/structure/machinery/mounted_defence/tripod/prebuild/mg_turret/dropship
	icon_state = "small_place_barricade_folding"
	var/obj/structure/dropship_equipment/mg_holder/deployment_system

/obj/structure/machinery/mounted_defence/tripod/prebuild/mg_turret/dropship/Destroy()
	if(deployment_system)
		deployment_system.deployed_mg = null
		deployment_system = null
	return ..()


/obj/structure/machinery/mounted_defence/t2
	name = "Среднее Укрепление"
	desc = "Используется для размещения среднего стационарного вооружения."
	icon_state = "medium_place"
	md_class = 2
	projectile_coverage = PROJECTILE_COVERAGE_MEDIUM


/obj/structure/machinery/mounted_defence/t3
	name = "Дот"
	desc = "Специальная огневая позиция для тяжелого стационарного вооружения."
	icon_state = "high_place"
	md_class = 3
	projectile_coverage = PROJECTILE_COVERAGE_HIGH


/obj/structure/blocker/anti_cade
	health = INFINITY
	anchored = 1
	density = 0
	unacidable = TRUE
	indestructible = TRUE
	invisibility = 101 // no looking at it with alt click

	var/atom/to_block

	alpha = 0

/obj/structure/blocker/anti_cade/BlockedPassDirs(atom/movable/AM, target_dir)
	if(istype(AM, /obj/structure/barricade))
		return BLOCKED_MOVEMENT

	return ..()

/obj/structure/blocker/anti_cade/Destroy()
	to_block = null

	return ..()


//////////////////////////////////////////////////////////////
//M56D
//////////////////////////////////////////////////////////////

//First thing we need is the ammo drum for this thing.
/obj/item/ammo_magazine/m56d
	name = "M56D drum magazine (10x28mm Caseless)"
	desc = "A box of 700, 10x28mm caseless tungsten rounds for the M56D heavy machine gun system. Just click the M56D with this to reload it."
	w_class = SIZE_MEDIUM
	icon_state = "m56d_drum"
	flags_magazine = NO_FLAGS //can't be refilled or emptied by hand
	caliber = "10x28mm"
	max_rounds = 700
	ammo_preset = list(/datum/ammo/bullet/smartgun)
	gun_type = /obj/item/weapon/gun/mounted/m56d_gun

//Now we need a box for this.
/obj/item/storage/box/m56d_hmg
	name = "\improper M56D crate"
	desc = "A large metal case with Japanese writing on the top. However it also comes with English text to the side. This is a M56D heavy machine gun, it clearly has various labeled warnings. The most major one is that this does not have IFF features due to specialized ammo."
	icon = 'icons/obj/structures/barricades.dmi'
	icon_state = "M56D_case" // I guess a placeholder? Not actually going to show up ingame for now.
	w_class = SIZE_HUGE
	storage_slots = 5

/obj/item/storage/box/m56d_hmg/Initialize()
	. = ..()
	new /obj/item/weapon/gun/mounted/m56d_gun(src) //gun itself
	new /obj/item/device/mounted_defence/tripod_frame(src) //tripod
	new /obj/item/ammo_magazine/m56d(src) //ammo for the gun
	new /obj/item/ammo_magazine/m56d(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/screwdriver(src)


//////////////////////////////////////////////////////////////
//SGL2
//////////////////////////////////////////////////////////////

/obj/item/storage/box/sgl2
	name = "\improper SGL2 Assembly-Supply Crate"
	desc = "A large case labelled 'SGL2, heavy grenade launcher', seems to be fairly heavy to hold. Contains a deadly SGL2 Heavy Grenade Launching System and its ammunition."
	icon = 'icons/obj/structures/barricades.dmi'
	icon_state = "SGL2_case"
	w_class = SIZE_HUGE
	storage_slots = 5

/obj/item/storage/box/sgl2/Initialize()
	..()

	new /obj/item/weapon/gun/launcher/grenade/mounted/sgl2_gun(src) //gun itself
	new /obj/item/device/mounted_defence/tripod_frame(src) //tripod
	new /obj/item/explosive/grenade/incendiary/airburst(src) //ammo for the gun
	new /obj/item/explosive/grenade/incendiary/airburst(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/screwdriver(src)


//////////////////////////////////////////////////////////////
//RCT
//////////////////////////////////////////////////////////////

//Now we need a box for this.
/obj/item/storage/box/rct
	name = "\improper RCT Assembly-Supply Crate"
	desc = "A large case labelled 'RCT, heavy grenade launcher', seems to be fairly heavy to hold. Contains stationary rocket launcher, can be used with all types rockets. likely to destroy enemy heavy machines."
	icon = 'icons/obj/structures/barricades.dmi'
	icon_state = "RCT_case" // I guess a placeholder? Not actually going to show up ingame for now.
	w_class = SIZE_HUGE
	storage_slots = 5

/obj/item/storage/box/rct/Initialize()
	. = ..()
	new /obj/item/weapon/gun/launcher/rocket/mounted/rct_gun(src) //gun itself
	new /obj/item/device/mounted_defence/tripod_frame(src) //tripod
	new /obj/item/ammo_magazine/rocket/ap(src) //ammo for the gun
	new /obj/item/ammo_magazine/rocket/ap(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/screwdriver(src)
