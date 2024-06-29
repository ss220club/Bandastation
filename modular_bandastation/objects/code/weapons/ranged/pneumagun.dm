#define CALIBER_PNEUMA "pneuma"

// Pneumagun
/obj/item/gun/ballistic/automatic/pneumaticgun
	name = "Пневморужье"
	desc = "Стандартное пневморужье"
	lefthand_file = 'modular_bandastation/objects/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/guns_righthand.dmi'
	icon = 'modular_bandastation/objects/icons/guns.dmi'
	icon_state = "pneumagun"
	inhand_icon_state = "pneumagun"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/pneuma
	fire_sound = 'modular_bandastation/objects/sounds/weapons/gunshots/gunshot_pneumatic.ogg'
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 1
	special_mags = TRUE
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pneumaticgun/loaded
	spawnwithmagazine = TRUE
	spawn_magazine_type = /obj/item/ammo_box/magazine/pneuma

/obj/item/gun/ballistic/automatic/pneumaticgun/loaded/pepper
	spawn_magazine_type = /obj/item/ammo_box/magazine/pneuma/pepper

// Базовые боеприпасы для пневморужья
/obj/item/ammo_box/magazine/pneuma
	name = "магазин пневморужья"
	desc = "Наполняется шариками с реагентом."
	caliber = CALIBER_PNEUMA
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "pneumag"
	base_icon_state = "pneumag"
	ammo_type = /obj/item/ammo_casing/pneuma
	max_ammo = 12
	multiload = 0

/obj/item/ammo_casing/pneuma
	name = "пневматический шарик"
	desc = "Пустой пневматический шарик."
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "pneumaball_g"
	caliber = CALIBER_PNEUMA
	projectile_type = /obj/projectile/bullet/pneumaball
	harmful = FALSE

/obj/projectile/bullet/pneumaball
	name = "пневматический шарик"
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "pneumaball_g"
	wound_bonus = -100
	stamina = 7
	damage = 1

// Боеприпасы для перцового типа пневморужья
/obj/item/ammo_box/magazine/pneuma/pepper
	ammo_type = /obj/item/ammo_casing/pneuma/pepper
	icon_state = "pneumar"
	base_icon_state = "pneumar"

/obj/item/ammo_casing/pneuma/pepper
	desc = "Шарик с капсаицином. Эффективно подходит для задержания преступников, не носящих очки."
	projectile_type = /obj/projectile/bullet/pneumaball/pepper
	icon_state = "pneumaball_r"

/obj/projectile/bullet/pneumaball/pepper
	icon_state = "pneumaball_r"
	var/pneuma_reagent = /datum/reagent/consumable/condensedcapsaicin
	var/reagent_volume = 5

/obj/projectile/bullet/pneumaball/pepper/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(isliving(target))
		var/mob/living/carbon/M = target
		var/datum/reagent/R = new pneuma_reagent
		R.expose_mob(M, VAPOR, reagent_volume)

/datum/supply_pack/security/armory/pneumagun
	name = "Pneumatic Pepper Rifles Crate"
	contains = list(
		/obj/item/gun/ballistic/automatic/pneumaticgun = 2,
		/obj/item/ammo_box/magazine/pneuma/pepper = 2,
	)
	cost = CARGO_CRATE_VALUE * 2.5
	crate_name = "pneumatic pepper rifles pack"

/datum/supply_pack/security/armory/pneumapepperballs
	name = "Pneumatic Pepper Rifle Ammunition Crate"
	contains = list(
		/obj/item/ammo_box/magazine/pneuma/pepper = 3,
	)
	cost = CARGO_CRATE_VALUE * 1.25
	crate_name = "pneumatic pepper ammunition pack"

#undef CALIBER_PNEUMA
