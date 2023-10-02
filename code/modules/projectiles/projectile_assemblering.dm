#define BULLET_STATS list("damage" = 0, "scatter" = 0, "accuracy" = 0, "damage_falloff" = 0, "damage_buildup" = 0, "penetration" = 0, "shrapnel_chance" = 0, "shrapnel_type" = 0, "debilitate" = list(0,0,0,0,0,0,0,0), "accurate_range" = 0, "max_range" = 0, "shell_speed" = 0)

/obj/structure/machinery/bullets_processor
	name = "\improper ammo mini factory"
	desc = "This is small miniature factory can produce bullets by model inserted in it."
	icon_state = "autolathe"
	var/base_state = "autolathe"
	unacidable = TRUE
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 500

	var/list/stored_material =  list("metal" = 50000, "glass" = 25000, "plastic" = 25000)
	var/list/projected_stored_material // will be <= stored_material values
	var/list/storage_capacity = list("metal" = 50000, "glass" = 25000, "plastic" = 25000)
	var/list/printable = list() // data list of each printable item (for NanoUI)
	var/list/recipes
	var/list/components = list(
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen
	)
	var/obj/item/ammo_parts/casing/example

	var/busy = FALSE
	var/turf/make_loc

	var/list/queue = list()
	var/queue_max = BULLETPROCESSOR_MAX_QUEUE

/obj/structure/machinery/bullets_processor/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/ammo_parts/casing))
		var/obj/item/ammo_parts/casing/ammo = O
		var/checked_len = 0
		for(var/obj/item/ammo_parts/part/part as anything in ammo.parts)
			checked_len++
			if(part.locked < 2)
				to_chat(user, SPAN_WARNING("[part] недостаточно закреплено."))
				return FALSE
		if(checked_len != 2)
			to_chat(user, SPAN_WARNING("Не все модули установлены."))
			return FALSE
		example = ammo
		ammo.forceMove(src)

	if(stat)
		return

	//Resources are being loaded.
	var/obj/item/eating = O
	if(!eating.matter)
		to_chat(user, "\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in eating.matter)

		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = eating.matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		projected_stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(!filltype)
		to_chat(user, SPAN_DANGER("\The [src] is full. Please remove material from the [name] in order to insert more."))
		return
	else if(filltype == 1)
		to_chat(user, "You fill \the [src] to capacity with \the [eating].")
	else
		to_chat(user, "You fill \the [src] with \the [eating].")

	flick("[base_state]_o",src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1,round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.

/obj/structure/machinery/bullets_processor/proc/initiare_generation()
	var/multiplier = queue_max - queue.len
	if(!multiplier || !example)
		return
	for(var/i in 1 to multiplier)
		var/result = try_queue(usr, example, make_loc)
		switch(result)
			if(BULLETPROCESSOR_FAILED)
				return
			if(BULLETPROCESSOR_START_PRINTING)
				start_printing()

/obj/structure/machinery/bullets_processor/proc/try_queue(mob/living/carbon/human/user, obj/item/ammo_parts/casing/making, turf/make_loc, multiplier = 1)
	if(queue.len >= queue_max)
		to_chat(usr, SPAN_DANGER("The [name] has queued the maximum number of operations. Please wait for completion of current operation."))
		return BULLETPROCESSOR_FAILED

	//This needs some work.
	use_power(max(2000, (making.space_taken*50*multiplier)))

	//Check if we still have the materials.
	for(var/material in making.matter)
		if(projected_stored_material[material] && projected_stored_material[material] >= (making.matter[material]*multiplier))
			continue
		to_chat(user, SPAN_DANGER("The [name] does not have the materials to create \the [making.name]."))
		return BULLETPROCESSOR_FAILED

	for(var/material in making.matter)
		projected_stored_material[material] = max(0, projected_stored_material[material]-(making.matter[material]*multiplier))

	var/list/print_params = list(making, multiplier, make_loc)
	queue += list(print_params) // This notation is necessary because of how adding to lists works

	if(busy)
		to_chat(usr, SPAN_NOTICE("Added the item \"[making.name]\" to the queue."))
		return BULLETPROCESSOR_QUEUED

	return BULLETPROCESSOR_START_PRINTING

/obj/structure/machinery/bullets_processor/proc/start_printing()
	set waitfor = FALSE

	var/list/print_params

	busy = TRUE

	while (queue.len)
		print_params = queue[1]
		queue -= list(print_params)
		print_item(arglist(print_params))

	busy = FALSE

/obj/structure/machinery/bullets_processor/proc/print_item(obj/item/ammo_parts/casing/making, multiplier, turf/make_loc)
	for(var/material in making.matter)
		if(isnull(stored_material[material]) || stored_material[material] < (making.matter[material]*multiplier))
			visible_message("The [name] beeps rapidly, unable to print the current item \"[making.name]\".")
			return

	//Consume materials.
	for(var/material in making.matter)
		if(stored_material[material])
			stored_material[material] = max(0,stored_material[material]-(making.matter[material]*multiplier))

	//Fancy autolathe animation.
	icon_state = "[base_state]_n"

	playsound(src, 'sound/machines/print.ogg', 25)
	sleep(5 SECONDS)
	playsound(src, 'sound/machines/print_off.ogg', 25)
	icon_state = "[base_state]"

	//Sanity check.
	if(!making || !src)
		return

	//Create the desired item.
	var/obj/item/I = making.generate_datums()
	if(multiplier > 1 && istype(I,/obj/item/stack))
		var/obj/item/stack/S = I
		S.amount = multiplier

/obj/item/ammo_parts
	name = "part"
	desc = "Ammo part."
	icon = 'icons/obj/items/casings.dmi'
	icon_state = null
	throwforce = 1
	w_class = SIZE_TINY
	flags_atom = FPRINT|CONDUCT
	matter = list()

	var/metal_cost = null
	var/glass_cost = null
	var/plastic_cost = null
	var/metal_base_cost = 200
	var/glass_base_cost = null
	var/plastic_base_cost = null
	var/caliber = null

/obj/item/ammo_parts/Initialize(new_caliber = list("1" = 1), garbage_new = FALSE)
	. = ..()
	caliber = new_caliber
	garbage = garbage_new
	pixel_x = rand(-10.0, 10)
	pixel_y = rand(-10.0, 10)
	update_material_cost()

/obj/item/ammo_parts/proc/update_material_cost()
	if(!caliber)
		return FALSE
	var/modificator_cost = 1
	var/caliber_value
	for(var/caliber_def in caliber)
		caliber_value = caliber_def
		modificator_cost = caliber[caliber_value]
	if(metal_base_cost)
		metal_cost = metal_base_cost*modificator_cost
		matter["metal"] = metal_cost
	if(glass_base_cost)
		glass_cost = glass_base_cost*modificator_cost
		matter["glass"] = glass_cost
	if(plastic_base_cost)
		plastic_cost = plastic_base_cost*modificator_cost
		matter["plastic"] = plastic_cost

/obj/item/ammo_parts/casing
	name = "case"
	desc = "Ammo case."
	icon_state = "casing"
	var/space_taken = 0
	var/space_to_parts = 15
	var/bullet_stats = BULLET_STATS
	var/projectile_flags = 0
	var/list/parts = list("shell" = null, "capsule" = null)
	var/ammo_datum = /datum/ammo/bullet/custom
	var/ammo_projectile = /obj/item/projectile
	var/datum/ammo/bullet/custom/generated_ammo
	var/locked = FALSE

/obj/item/ammo_parts/casing/update_icon()
	update_material_cost()
	overlays.Cut()
	for(var/obj/item/ammo_parts/part as anything in parts)
		metal_cost += metal_cost
		part.pixel_x = pixel_x
		part.pixel_y = pixel_y
		overlays += part.icon

/obj/item/ammo_parts/casing/attackby(obj/item/I, mob/living/user, bypass_hold_check = 0)
	if(locked)
		to_chat(user, SPAN_WARNING("[src] уже полностью собран, разбирать его нету смысла."))
		return
	else if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		if(user.action_busy)
			return
		var/list/choices = list()
		for(var/obj/item/ammo_parts/part/P as anything in parts)
			if(P.locked == 2)
				continue
			choices += list("[P.name]" = P)
		var/obj/item/ammo_parts/part/choiced = tgui_input_list(usr, "Выберети часть, которую хотите вынуть:","[src]", choices)
		if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
			to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
			return
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
		user.put_in_hands(choiced)
		space_taken -= choiced.part_size
		parts[choiced.parts_name] = null
		for(var/matterial in choiced.matter)
			matter[matterial] -= choiced.matter[matterial]
		update_icon()

	else if(HAS_TRAIT(I, TRAIT_TOOL_WRENCH))
		if(user.action_busy)
			return
		var/list/choices = list()
		for(var/obj/item/ammo_parts/part/P as anything in parts)
			choices += list("[P.name], [P.locked < 2 ? "" : "не "]закреплено" = P)
		var/obj/item/ammo_parts/part/choiced = tgui_input_list(usr, "Выберети часть, которую хотите закрепить или открепить:","[src]", choices)
		if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
			to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
			return
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		if(choiced.locked == 2)
			choiced.locked = 1
		else
			choiced.locked = 2
		update_icon()

	else if(istype(I, /obj/item/ammo_parts/part))
		add_part(user, I)

/obj/item/ammo_parts/casing/attack_self(mob/user as mob)
	..()
	complite(user)

/obj/item/ammo_parts/casing/proc/add_part(mob/user, obj/item/ammo_parts/part/new_part)
	if(parts[!new_part.parts_name] || new_part.locked == 2)
		to_chat(user, SPAN_WARNING("Данная часть пули уже добавлена!"))
		return
	else if((space_taken+ new_part.part_size) > space_to_parts)
		to_chat(user, SPAN_WARNING("Требование к месту от детали намного больше чем есть!"))
		return
	else
		to_chat(user, SPAN_WARNING("Вы начали устанавливать [new_part] в [src]."))
		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			to_chat(user, SPAN_WARNING("Вы перервали установку [new_part] в [src]."))
			return
		to_chat(user, SPAN_WARNING("Вы установили [new_part] в [src]."))
		new_part.locked = 2
		space_taken += new_part.part_size
		new_part.forceMove(src)
		parts[new_part.parts_name] = new_part
		for(var/matterial in new_part.matter)
			matter[matterial] += new_part.matter[matterial]

/obj/item/ammo_parts/casing/proc/complite(mob/user)
	var/checked_len = 0
	for(var/obj/item/ammo_parts/part/part as anything in parts)
		checked_len++
		if(part.locked < 2)
			to_chat(user, SPAN_WARNING("[part] недостаточно закреплено."))
			return FALSE
	if(checked_len != 2)
		to_chat(user, SPAN_WARNING("Не все модули установлены."))
		return FALSE
	to_chat(user, SPAN_WARNING("Вы начали собирать [src]."))
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		to_chat(user, SPAN_WARNING("Вы перервали сбор [src]."))
		return FALSE
	generate_datums()
	qdel(src)
	return TRUE

/obj/item/ammo_parts/casing/proc/generate_datums()
	locked = TRUE
	if(!generated_ammo)
		generated_ammo = new ammo_datum(loc)
		generated_ammo.name = "[prob(50) ? "" : "[rand(0,9)]"][prob(50) ? "" : "[rand(0,9)]"][prob(50) ? "" : "[rand(0,9)]"][prob(50) ? "" : "[pick(alphabet_uppercase)]"][prob(50) ? "" : "[pick(alphabet_uppercase)]"][prob(50) ? "" : "[pick(alphabet_uppercase)]"] EXP AMMO"
		for(var/obj/item/ammo_parts/part/part as anything in parts)
			for(var/i in part.modificators)
				bullet_stats[i] += part.modificators[i]
			projectile_flags |= part.part_flags
		generated_ammo.calculate_new_ammo_stats(bullet_stats, projectile_flags, caliber)
		GLOB.custom_ammo += generated_ammo
	var/obj/item/projectile/proj = new ammo_projectile(loc, generated_ammo, caliber)
	var/obj/item/ammo_parts/part/shell/part = parts["shell"]
	proj.container = part.inernal_container
	return proj

//Making child objects so that locate() and istype() doesn't screw up.

/obj/item/ammo_parts/casing/cartridge
	name = "spent cartridge"
	icon_state = "cartridge"
	space_to_parts = 20
	metal_base_cost = 300

/obj/item/ammo_parts/casing/shell
	name = "spent shell"
	icon_state = "shell"
	space_to_parts = 25
	metal_base_cost = 250

/obj/item/ammo_parts/part
	name = "case"
	desc = "Ammo case."
	icon_state = "part"

	var/locked = FALSE
	var/list/modificators = list()
	var/part_flags = null
	var/part_size = 1
	var/parts_name

/obj/item/ammo_parts/part/shell
	name = "shell"
	desc = "Shell, can hold conainer or can maked additionaly long and have container + cast tip."
	icon_state = "part"
	part_size = 6
	metal_base_cost = 150
	parts_name = "shell"

	var/obj/item/ammo_parts/part/cast/cast
	var/obj/item/ammo_parts/part/container/inernal_container

/obj/item/ammo_parts/part/shell/attackby(obj/item/W as obj, mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You do not know how to tinker with [name]."))
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(!cast && !inernal_container)
			to_chat(user, SPAN_NOTICE("[name] must contain a all parts to do that!"))
			return
		if(locked)
			to_chat(user, SPAN_NOTICE("You unlock [name]."))
		else
			to_chat(user, SPAN_NOTICE("You lock [name]."))
		locked = !locked
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 0, 6)
		return

	else if(istype(W, /obj/item/ammo_parts/part/cast) && !locked)
		var/obj/item/ammo_parts/part/cast/cast = W
		if(cast)
			to_chat(user, SPAN_DANGER("The [name] already has a cast!"))
			return
		user.temp_drop_inv_item(cast)
		cast.forceMove(src)
		inernal_container = cast
		part_size += cast.part_size
		for(var/i in cast.modificators)
			modificators[i] += cast.modificators[i]
		to_chat(user, SPAN_DANGER("You add [cast] to [name]."))
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)

	else if(istype(W, /obj/item/ammo_parts/part/container) && !locked)
		var/obj/item/ammo_parts/part/container = W
		if(inernal_container)
			to_chat(user, SPAN_DANGER("The [name] already has a cast!"))
			return
		user.temp_drop_inv_item(container)
		container.forceMove(src)
		inernal_container = container
		part_size += container.part_size
		to_chat(user, SPAN_DANGER("You add [container] to [name]."))
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)

/obj/item/ammo_parts/part/container
	name = "container"
	desc = "Special container for not standart bullets."
	icon_state = "container"
	part_size = 4
	metal_base_cost = 250
	glass_base_cost = 50
	plastic_base_cost = 150
	parts_name = "container"

	var/obj/item/ammo_parts/part/cast/inernal_cast
	var/obj/item/explosive/ammo_charge/inernal_charge
	var/obj/item/ammo_parts/part/detonator/inernal_detonator

/obj/item/ammo_parts/part/container/attackby(obj/item/W as obj, mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You do not know how to tinker with [name]."))
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(!inernal_detonator || (!inernal_charge && !inernal_cast))
			to_chat(user, SPAN_NOTICE("[name] must contain a all parts to do that!"))
			return
		if(locked)
			to_chat(user, SPAN_NOTICE("You unlock [name]."))
		else
			to_chat(user, SPAN_NOTICE("You lock [name]."))
		locked = !locked
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 0, 6)
		return

	else if(istype(W, /obj/item/ammo_parts/part/cast) && !locked)
		var/obj/item/ammo_parts/part/cast/cast = W
		if(inernal_cast)
			to_chat(user, SPAN_DANGER("The [name] already has a cast!"))
			return
		else if(cast.internal_allowed)
			user.temp_drop_inv_item(cast)
			cast.forceMove(src)
			inernal_cast = cast
			part_size += cast.part_size
			part_flags |= cast.part_flags
			for(var/i in cast.modificators)
				modificators[i] += cast.modificators[i]
			to_chat(user, SPAN_DANGER("You add [cast] to [name]."))
			playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)
		else
			to_chat(user, SPAN_DANGER("This is cast not allowed to internal use!"))
			return

	else if(istype(W, /obj/item/explosive/ammo_charge) && !locked)
		var/obj/item/explosive/ammo_charge/charge = W
		if(inernal_charge)
			to_chat(user, SPAN_DANGER("The [name] already has a cast!"))
			return
		user.temp_drop_inv_item(charge)
		charge.forceMove(src)
		inernal_charge = charge
		part_size += charge.part_size
		part_flags |= charge.part_flags
		to_chat(user, SPAN_DANGER("You add [charge] to [name]."))
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)

	else if(istype(W, /obj/item/ammo_parts/part/detonator) && !locked)
		var/obj/item/ammo_parts/part/detonator/detonator = W
		if(inernal_detonator)
			to_chat(user, SPAN_DANGER("The [name] already has a cast!"))
			return
		user.temp_drop_inv_item(detonator)
		detonator.forceMove(src)
		inernal_detonator = detonator
		part_size += detonator.part_size
		part_flags |= detonator.part_flags
		to_chat(user, SPAN_DANGER("You add [detonator] to [name]."))
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)

/obj/item/ammo_parts/part/cast
	name = "cast"
	desc = "Cast, can make shrapnel or additional piercing or some else."
	icon_state = "cast"
	part_size = 2
	parts_name = "cast"

	var/internal_allowed = TRUE

/obj/item/ammo_parts/part/cast/small
	part_size = 4
	metal_base_cost = 150
	plastic_base_cost = 75
	modificators = list("damage" =  35, "damage_falloff" = 4, "scatter" = 15, "accuracy" = 25, "penetration" = 5, "shrapnel_chance" = 10, "shell_speed" = 2, "max_range" = 8, "shrapnel_type" = /datum/ammo/bullet/shrapnel)

/obj/item/ammo_parts/part/cast/medium
	part_size = 6
	metal_base_cost = 250
	plastic_base_cost = 125
	modificators = list("damage" =  25, "damage_falloff" = 3, "scatter" = 2, "accuracy" = 25, "penetration" = 15, "shrapnel_chance" = 15, "shell_speed" = 1, "max_range" = 6, "shrapnel_type" = /datum/ammo/bullet/shrapnel)

/obj/item/ammo_parts/part/cast/big
	part_size = 8
	metal_base_cost = 150
	plastic_base_cost = 75
	modificators = list("damage" =  35, "damage_falloff" = 1, "scatter" = 4, "accuracy" = 30, "penetration" = 20, "shrapnel_chance" = 20, "shell_speed" = 1.5, "max_range" = 4, "debilitate" = list(0,2,0,0,0,1,0,0), "shrapnel_type" = /datum/ammo/bullet/shrapnel)
	part_flags = CUSTOM_AMMO_ON_HIT

/obj/item/ammo_parts/part/cast/armor_piercing
	part_size = 12
	metal_base_cost = 200
	glass_base_cost = 50
	plastic_base_cost = 500
	modificators = list("damage" =  40, "damage_falloff" = 1, "scatter" = 2, "accuracy" = 30, "penetration" = 40, "shrapnel_chance" = 5, "shell_speed" = -0.5, "max_range" = -2, "shrapnel_type" = /datum/ammo/bullet/shrapnel)
	part_flags = CUSTOM_AMMO_PENETRATION

/obj/item/ammo_parts/part/cast/expanent
	part_size = 3
	glass_base_cost = 400
	plastic_base_cost = 100
	modificators = list("damage" =  25, "damage_falloff" = 3, "scatter" = 6, "accuracy" = 20, "penetration" = 20, "shrapnel_chance" = 100, "shell_speed" = 1, "max_range" = 2, "shrapnel_type" = /datum/ammo/bullet/shrapnel)

/obj/item/ammo_parts/part/cast/shrapnel
	part_size = 4
	glass_base_cost = 800
	plastic_base_cost = 200
	modificators = list("damage" =  25, "damage_falloff" = 3, "scatter" = 8, "accuracy" = 25, "penetration" = 15, "shrapnel_chance" = 50, "shell_speed" = 0.5, "max_range" = -1, "shrapnel_type" = /datum/ammo/bullet/shrapnel/medium)
	internal_allowed = FALSE

/obj/item/ammo_parts/part/cast/shrapnel/big
	part_size = 8
	glass_base_cost = 1600
	plastic_base_cost = 200
	modificators = list("damage" =  30, "damage_falloff" = 2, "scatter" = 10, "accuracy" = 40, "penetration" = 20, "shrapnel_chance" = 100, "shell_speed" = -0.5, "max_range" = -2, "debilitate" = list(0,2,0,0,0,1,0,0), "shrapnel_type" = /datum/ammo/bullet/shrapnel/medium)
	part_flags = CUSTOM_AMMO_ON_HIT

/obj/item/ammo_parts/part/detonator
	name = "detonator"
	desc = "Detonate contained in bullets objects, take more place, rather than electric"
	icon_state = "detonator"
	part_size = 3
	metal_base_cost = 500

/obj/item/ammo_parts/part/detonator/electric
	name = "electric detonator"
	desc = "Detonate contained in bullets objects (this is electric detonator, any emp can disable ammo!)"
	part_size = 1
	metal_base_cost = 100
	glass_base_cost = 50
	plastic_base_cost = 200

/obj/item/ammo_parts/part/detonator/electric/iff
	part_flags = CUSTOM_AMMO_IFF

/obj/item/explosive/ammo_charge
	name = "bullet charge core"
	desc = "A custom bullet charge core meant for bullets containers."
	icon = 'icons/obj/items/casings.dmi'
	icon_state = "warhead_rocket"
	customizable = TRUE
	allowed_sensors = list(/obj/item/device/assembly/prox_sensor)
	max_container_volume = 40
	throwforce = 1
	w_class = SIZE_TINY
	flags_atom = FPRINT|CONDUCT
	reaction_limits = list(	"max_ex_power" = 200,	"base_ex_falloff" = 200,"max_ex_shards" = 64,
							"max_fire_rad" = 3,		"max_fire_int" = 30,	"max_fire_dur" = 36,
							"min_fire_rad" = 1,		"min_fire_int" = 4,		"min_fire_dur" = 5
	)
	has_blast_wave_dampener = TRUE
	matter = list("metal" = 0, "glass" = 0, "plastic" = 0)

	var/part_flags = CUSTOM_AMMO_EXPLOSION
	var/metal_cost = null
	var/glass_cost = null
	var/plastic_cost = null
	var/metal_base_cost = 300
	var/glass_base_cost = 50
	var/plastic_base_cost = 500
	var/caliber = null
	var/part_size = 4

/obj/item/explosive/ammo_charge/Initialize(new_caliber = list("1" = 1))
	. = ..()
	caliber = new_caliber
	update_material_cost()

/obj/item/explosive/ammo_charge/proc/update_material_cost()
	var/modificator_cost = 1
	for(var/i in caliber)
		modificator_cost = caliber[i] / 2
	metal_cost = metal_base_cost*modificator_cost // For the metal.
	matter["metal"] = metal_cost
	glass_cost = glass_base_cost*modificator_cost // For the metal.
	matter["glass"] = glass_cost
	plastic_cost = plastic_base_cost*modificator_cost // For the metal.
	matter["plastic"] = plastic_cost
	max_container_volume = max_container_volume*modificator_cost

/obj/item/explosive/ammo_charge/add_detonator(obj/item/device/assembly_holder/det)
	. = ..()
	if(istype(det, /obj/item/device/assembly/prox_sensor))
		part_flags |= CUSTOM_AMMO_PROXIMITY

/obj/item/reagent_container/glass/capsule_internal
	name = "small powdr storage"
	desc = "A special conainer for capsule, used to contain fuel and detonate it."
	volume = 20
	matter = list("metal" = 50, "glass" = 100)

/obj/item/ammo_parts/part/capsule
	name = "case"
	desc = "Ammo case."
	icon_state = "part"
	part_size = 2
	metal_base_cost = 100
	plastic_base_cost = 100
	modificators = list("shell_speed" = 0)
	parts_name = "capsule"

	var/obj/item/reagent_container/glass/capsule_internal/fuel
	var/fuel_requirement = 20
	var/fuel_type = "napalm"


/obj/item/ammo_parts/part/capsule/get_examine_text(mob/user)
	. = ..()
	if(fuel)
		. += "Contains fuel.<br>"

/obj/item/ammo_parts/part/capsule/attack_self(mob/user)
	..()

	if(locked)
		return

	if(fuel)
		user.put_in_hands(fuel)
		fuel = null

/obj/item/ammo_parts/part/capsule/attackby(obj/item/W as obj, mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You do not know how to tinker with [name]."))
		return
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(!fuel)
			to_chat(user, SPAN_NOTICE("[name] must contain a fuel to do that!"))
			return
		if(locked)
			to_chat(user, SPAN_NOTICE("You unlock [name]."))
		else
			to_chat(user, SPAN_NOTICE("You lock [name]."))
			if(fuel && fuel.reagents.get_reagent_amount(fuel_type) >= fuel_requirement)
				modificators["shell_speed"] = 3
			else
				modificators["shell_speed"] = 0
		locked = !locked
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 0, 6)
		return
	else if(istype(W,/obj/item/reagent_container/glass/capsule_internal) && !locked)
		if(fuel)
			to_chat(user, SPAN_DANGER("The [name] already has a fuel container!"))
			return
		else
			user.temp_drop_inv_item(W)
			W.forceMove(src)
			modificators["shell_speed"] = 3
			fuel = W
			to_chat(user, SPAN_DANGER("You add [W] to [name]."))
			playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)
