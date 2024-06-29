#define CALIBER_PEA "pea"

// Горохострел
/obj/item/gun/ballistic/revolver/pea_shooter
	name = "горохострел"
	desc = "Живой горох! Может стрелять горошинами, которые наносят слабый урон самооценке."
	icon = 'modular_bandastation/objects/icons/guns.dmi'
	icon_state = "pea_shooter"
	lefthand_file = 'modular_bandastation/objects/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/guns_righthand.dmi'
	fire_sound = 'modular_bandastation/objects/sounds/weapons/gunshots/peas_shooter_gunshot.ogg'
	drop_sound = 'modular_bandastation/objects/sounds/weapons/drop/peas_shooter_drop.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/pea_shooter
	inhand_icon_state = "pea_shooter"

/obj/item/ammo_box/magazine/internal/pea_shooter
	name = "peacock shooter magazine"
	desc = "Хранилище горошин для горохострела, вмещает до 6 горошин за раз."
	ammo_type = /obj/item/ammo_casing/pea_shooter
	max_ammo = 6
	caliber = CALIBER_PEA

/obj/item/ammo_casing/pea_shooter
	name = "pea bullet"
	desc = "Пуля из гороха, не может нанести какого-либо ощутимого урона."
	projectile_type = /obj/projectile/bullet/pea_shooter
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "pea_bullet"
	caliber = CALIBER_PEA

// Пуля горохострела
/obj/projectile/bullet/pea_shooter
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "pea_bullet"
	damage = 5
	damage_type = STAMINA
	wound_bonus = -100

/obj/projectile/bullet/pea_shooter/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(istype(target, /mob/living/carbon) | isliving(target))
		var/mob/living/carbon/M = target
		if(prob(15))
			M.emote("moan")
	return

#undef CALIBER_PEA
