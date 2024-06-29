#define ERT_TYPE_AMBER		1
#define ERT_TYPE_RED		2
#define ERT_TYPE_GAMMA		3

// GYGAX

/// NT Special Gygax
/obj/vehicle/sealed/mecha/gygax/nt
	name = "Специальный Гигакс НТ"
	desc = "Козырь Nanotrasen при решении проблем, легкий мех окрашенный в победоносные цвета НТ. Если вы видите этот мех, вероятно все проблемы уже решены."
	icon = 'modular_bandastation/objects/icons/mecha.dmi'
	icon_state = "ntgygax"
	base_icon_state = "ntgygax"
	max_integrity = 300
	max_temperature = 35000
	armor_type = /datum/armor/mecha_gygax_nt
	accesses = list(ERT_TYPE_AMBER)
	wreckage = /obj/structure/mecha_wreckage/gygax/gygax_nt
	destruction_sleep_duration = 2 SECONDS
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 4,
		MECHA_POWER = 1,
		MECHA_ARMOR = 3,
	)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/radio, /obj/item/mecha_parts/mecha_equipment/air_tank/full, /obj/item/mecha_parts/mecha_equipment/thrusters/ion),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/anticcw_armor_booster, /obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster),
		)

/obj/vehicle/sealed/mecha/gygax/nt/red
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 4,
		MECHA_POWER = 1,
		MECHA_ARMOR = 3,
	)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/disabler,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/radio, /obj/item/mecha_parts/mecha_equipment/air_tank/full, /obj/item/mecha_parts/mecha_equipment/thrusters/ion),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/anticcw_armor_booster, /obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster),
		)

/obj/vehicle/sealed/mecha/gygax/nt/epsilon
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 4,
		MECHA_POWER = 1,
		MECHA_ARMOR = 3,
	)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/radio, /obj/item/mecha_parts/mecha_equipment/air_tank/full, /obj/item/mecha_parts/mecha_equipment/thrusters/ion),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/anticcw_armor_booster, /obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster),
		)

/datum/armor/mecha_gygax_nt
	melee = 40
	bullet = 40
	laser = 50
	energy = 35
	bomb = 20
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/gygax/nt/populate_parts()
	. = ..()
	cell = new /obj/item/stock_parts/cell/high/slime_hypercharged
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()

// NT Special Gygax wreckage
/obj/structure/mecha_wreckage/gygax/gygax_nt
	name = "\improper Обломки Специального Гигакса НТ"
	desc = "Видимо козырь был плохим..."
	icon = 'modular_bandastation/objects/icons/mecha.dmi'
	icon_state = "ntgygax-broken"

// DURAND

/// Rover
/obj/vehicle/sealed/mecha/durand/rover
	name = "Ровер"
	desc = "Боевой мех, разработанный Синдикатом на основе Durand Mk. II путем удаления ненужных вещей и добавления некоторых своих технологий. Гораздо лучше защищен от любых опасностей, связанных с Нанотрейзен."
	icon = 'modular_bandastation/objects/icons/mecha.dmi'
	icon_state = "darkdurand"
	base_icon_state = "darkdurand"
	armor_type = /datum/armor/mecha_durand_rover
	accesses = list(ACCESS_SYNDICATE)
	internal_damage_threshold = 35
	wreckage = /obj/structure/mecha_wreckage/durand/rover
	destruction_sleep_duration = 2 SECONDS
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 4,
		MECHA_POWER = 1,
		MECHA_ARMOR = 3,
	)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/radio, /obj/item/mecha_parts/mecha_equipment/air_tank/full, /obj/item/mecha_parts/mecha_equipment/thrusters/ion, /obj/item/mecha_parts/mecha_equipment/repair_droid),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/anticcw_armor_booster, /obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster),
		)

/datum/armor/mecha_durand_rover
	melee = 30
	bullet = 40
	laser = 50
	energy = 50
	bomb = 20
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/durand/rover/populate_parts()
	. = ..()
	cell = new /obj/item/stock_parts/cell/bluespace
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()

// Rover's wreckage
/obj/structure/mecha_wreckage/durand/rover
	name = "\improper Обломки Ровера"
	desc = "И как такой гигант пал?"
	icon = 'modular_bandastation/objects/icons/mecha.dmi'
	icon_state = "darkdurand-broken"

#undef ERT_TYPE_AMBER
#undef ERT_TYPE_RED
#undef ERT_TYPE_GAMMA
