//the idea is to put all the bulk items scanner secure crate with lot's of flares MRE in it and at the end OB and non buyable.

//non buyable

/datum/supply_packs/ob_incendiary
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/incendiary,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/incendiary,
	)

	name = "OB Incendiary Crate"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "OB Ammo Crate (Incendiary x2)"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/ob_explosive
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/explosive,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/explosive,
	)

	name = "OB HE Crate"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "OB Ammo Crate (HE x2)"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/ob_cluster
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/cluster,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/cluster,
	)

	name = "OB Cluster Crate"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "OB Ammo Crate (Cluster x2)"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/telecommsparts
	name = "Replacement Telecommunications Parts"
	contains = list(
		/obj/item/circuitboard/machine/telecomms/relay/tower,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/subspace/filter,
		/obj/item/stock_parts/subspace/filter,
		/obj/item/cell,
		/obj/item/cell,
		/obj/item/stack/cable_coil,
		/obj/item/stack/cable_coil,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/supply
	buyable = 0
	containername = "replacement telecommunications crate"
	group = "Operations"

/datum/supply_packs/technuclearbomb
	name = "Encrypted Operational Nuke"
	cost = 0
	containertype = /obj/structure/machinery/nuclearbomb/tech
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/obnuclearbomb
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/nuke,
	)

	name = "OB Nuclear Crate"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ammo
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/spec_kits
	name = "Specialist Kits"
	contains = list(
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "specialist kits crate"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/spec_kits
	name = "Weapons Specialist Kits"
	contains = list(
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs,
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "weapons specialist kits crate"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/special_ammo
	name = "Special Ammo"
	contains = list(
		/obj/item/ammo_kit/incendiary,
		/obj/item/ammo_kit/incendiary,
		/obj/item/ammo_kit/cluster,
		/obj/item/ammo_kit/cluster,
		/obj/item/ammo_kit/toxin,
		/obj/item/ammo_kit/toxin,
		/obj/item/ammo_kit/penetrating,
		/obj/item/ammo_kit/penetrating
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "special ammo supply crate"
	buyable = 0
	group = "Operations"

/datum/supply_packs/special_guns_kit
	name = "Experemental Guns Kits"
	contains = list(
		/obj/item/advanced_weapon_kit/heavyshotgun,
		/obj/item/advanced_weapon_kit/heavyshotgun,
		/obj/item/advanced_weapon_kit/heavyshotgun,
		/obj/item/advanced_weapon_kit/heavyshotgun,
		/obj/item/advanced_weapon_kit/railgun,
		/obj/item/advanced_weapon_kit/railgun,
		/obj/item/advanced_weapon_kit/railgun,
		/obj/item/advanced_weapon_kit/railgun
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "experemental guns supply crate"
	buyable = 0
	group = "Operations"

/datum/supply_packs/upgrade_turrets_kits
	name = "upgrade turret kits crate (x4)"
	contains = list(
					/obj/item/engi_upgrade_kit,
					/obj/item/engi_upgrade_kit,
					/obj/item/engi_upgrade_kit,
					/obj/item/engi_upgrade_kit
					)
	cost = 0
	buyable = FALSE
	containertype = /obj/structure/closet/crate/medical
	containername = "upgrade turret kits crate"
	group = "Operations"

/datum/supply_packs/upgraded_medical_kits
	name = "upgraded medical equipment crate (x4)"
	contains = list(
					/obj/item/storage/box/czsp/medic_upgraded_kits,
					/obj/item/storage/box/czsp/medic_upgraded_kits,
					/obj/item/storage/box/czsp/medic_upgraded_kits,
					/obj/item/storage/box/czsp/medic_upgraded_kits
					)
	cost = 0
	buyable = FALSE
	containertype = /obj/structure/closet/crate/medical
	containername = "upgraded medical equipment crate"
	group = "Operations"

/datum/supply_packs/faction_tags
	name = "Faction IFF Tag Case (x7 tags)"
	contains = list(
		/obj/item/storage/tag_case/uscm/marine/full
	)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weyland
	containername = "IFF tag crate"
	group = "Operations"
