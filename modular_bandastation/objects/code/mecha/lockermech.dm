// Makeshift (Lockermech)
/obj/vehicle/sealed/mecha/ripley/lockermech
	name = "Шкафомех"
	desc = "Шкафчик с украденными проводами, стойками, электроникой и шлюзовыми сервоприводами, грубо собранными в нечто, напоминающее мех."
	icon = 'modular_bandastation/objects/icons/mecha.dmi'
	icon_state = "lockermech"
	base_icon_state = "lockermech"
	max_integrity = 100
	lights_power = 5
	armor_type = /datum/armor/ripley/lockermech
	internal_damage_threshold = 30
	wreckage = /obj/structure/mecha_wreckage/lockermech
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 3,
		MECHA_POWER = 1,
		MECHA_ARMOR = 0,
	)
	equip_by_category = list(
		MECHA_L_ARM = null,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/ejector/lockermech),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)


/obj/item/mecha_parts/mecha_equipment/ejector/lockermech
	cargo_capacity = 4

/datum/armor/ripley/lockermech
	melee = 20
	bullet = 10
	laser = 10
	energy = 0
	bomb = 10
	fire = 70
	acid = 60

/obj/vehicle/sealed/mecha/ripley/lockermech/on_move()
	. = ..()
	update_pressure()

/obj/vehicle/sealed/mecha/ripley/lockermech/update_pressure()
	if(active_thrusters)
		return // Don't calculate this if they have thrusters on, this is calculated right after domove because of course it is
	else
		. = ..()

// Crafting
/datum/crafting_recipe/lockermech
	name = "Locker Mech"
	result = list(/obj/vehicle/sealed/mecha/ripley/lockermech)
	reqs = list(
		/obj/item/stack/cable_coil = 20,
		/obj/item/stack/sheet/iron = 10,
		/obj/item/storage/toolbox = 2, // For feet
		/obj/item/tank/internals/oxygen = 1, // For air
		/obj/item/electronics/airlock = 1, // You are stealing the motors from airlocks
		/obj/item/extinguisher = 1, // For bastard pnumatics
		/obj/item/c_tube = 1, // To make it airtight
		/obj/item/flashlight = 1, // For the mech light
		/obj/item/stack/sticky_tape = 25, // ¯\_(ツ)_/¯
		/obj/item/stock_parts/cell/high = 1,
		/obj/item/stack/rods = 4 // To mount the equipment
	)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 200
	category = CAT_ROBOT

/datum/crafting_recipe/lockermech_drill
	name = "Locker Mech Exosuit Drill"
	result = list(/obj/item/mecha_parts/mecha_equipment/drill/lockermech)
	reqs = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/iron = 2,
		/obj/item/surgicaldrill = 1
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 50
	category = CAT_ROBOT

/datum/crafting_recipe/lockermech_clamp
	name = "Locker Mech Exosuit Clamp"
	result = list(/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/lockermech)
	reqs = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/iron = 2,
		/obj/item/wirecutters = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 50
	category = CAT_ROBOT

// Wreckage
/obj/structure/mecha_wreckage/lockermech
	name = "\improper Обломки Шкафомеха"
	desc = "Владелец данного изделия, на что он надеялся?..."
	icon = 'modular_bandastation/objects/icons/mecha.dmi'
	icon_state = "lockermech-broken"

// Equipment
/obj/item/mecha_parts/mecha_equipment/drill/lockermech
	name = "locker mech exosuit drill"
	desc = "Собранная из, скорее всего, краденых деталей, эта дрель не сравнится по эффективности с настоящей."
	equip_cooldown = 60
	force = 10
	drill_delay = 15

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/lockermech
	name = "locker mech clamp"
	desc = "Беспорядочное расположение собранных вместе деталей, напоминающее зажим."
	equip_cooldown = 25
	clamp_damage = 10
