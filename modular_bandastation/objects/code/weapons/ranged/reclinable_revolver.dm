#define CALIBER_44 ".44"
#define CALIBER_127 "12.7"

// Reclinable revolver
/obj/item/gun/ballistic/revolver/reclinable
	var/snapback_sound = 'modular_bandastation/objects/sounds/weapons/cylinder/snapback_rsh12.ogg'
	var/reclined_sound = 'modular_bandastation/objects/sounds/weapons/cylinder/reclined_rsh12.ogg'
	var/reclined = FALSE

/obj/item/gun/ballistic/revolver/reclinable/attack_self(mob/living/user)
	reclined = !reclined
	playsound(user, reclined ? reclined_sound : snapback_sound, 50, 1)
	update_icon()

	if(reclined)
		return ..()

/obj/item/gun/ballistic/revolver/reclinable/update_icon_state()
	. = ..()
	icon_state = (initial(icon_state)) + (reclined ? "_reclined" : "")

/obj/item/gun/ballistic/revolver/reclinable/attackby(obj/item/A, mob/user, params)
	if(!reclined)
		return
	return ..()

/obj/item/gun/ballistic/revolver/reclinable/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(!reclined)
		return ..()

	user.balloon_alert(user, "*click*")
	playsound(user, dry_fire_sound, 100, 1)

// Colt Anaconda .44
/obj/item/gun/ballistic/revolver/reclinable/anaconda
	name = "Анаконда"
	desc = "Крупнокалиберный револьвер двадцатого века. Несмотря на то, что оружие хранилось в хороших условиях, старина даёт о себе знать."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/d44
	lefthand_file = 'modular_bandastation/objects/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/guns_righthand.dmi'
	icon = 'modular_bandastation/objects/icons/guns.dmi'
	icon_state = "anaconda"
	fire_sound = 'modular_bandastation/objects/sounds/weapons/gunshots/gunshot_anaconda.ogg'
	inhand_icon_state = "anaconda"

/obj/item/gun/ballistic/revolver/reclinable/anaconda/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_box/box_d44))
		return
	return ..()

/obj/item/ammo_box/magazine/internal/cylinder/d44
	name = ".44 revolver cylinder"
	ammo_type = /obj/item/ammo_casing/d44
	caliber = CALIBER_44
	max_ammo = 6

/obj/item/ammo_casing/d44
	desc = "A .44 bullet casing."
	caliber = CALIBER_44
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "casing44"
	projectile_type = /obj/projectile/bullet/d44

/obj/projectile/bullet/d44
	name = ".44 bullet"
	icon_state = "bullet"
	damage = 50
	damage_type = BRUTE
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	spread = 20

/obj/item/ammo_box/speed_loader_d44
	name = "speed loader (.44)"
	desc = "Designed to quickly reload revolvers."
	ammo_type = /obj/item/ammo_casing/d44
	max_ammo = 6
	multiple_sprites = AMMO_BOX_PER_BULLET
	caliber = CALIBER_44
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "44"

/obj/item/ammo_box/box_d44
	name = "ammo box (.44)"
	desc = "Contains up to 24 .44 cartridges, intended to either be inserted into a speed loader or into the gun manually."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/d44
	max_ammo = 24
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "44_box"

// RSH-12 12.7
/obj/item/gun/ballistic/revolver/reclinable/rsh12
	name = "РШ-12"
	desc = "Тяжёлый револьвер винтовочного калибра с откидным стволом. По слухам, всё ещё находится на вооружении у СССП."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rsh12
	lefthand_file = 'modular_bandastation/objects/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/guns_righthand.dmi'
	icon = 'modular_bandastation/objects/icons/guns.dmi'
	icon_state = "rsh12"
	inhand_icon_state = "rsh12"
	fire_sound = 'modular_bandastation/objects/sounds/weapons/gunshots/gunshot_rsh12.ogg'
	fire_sound_volume = 30

/obj/item/gun/ballistic/revolver/reclinable/rsh12/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_box/box_mm127))
		return
	return ..()

/obj/item/ammo_box/magazine/internal/cylinder/rsh12
	name = "12.7mm revolver cylinder"
	ammo_type = /obj/item/ammo_casing/mm127
	caliber = CALIBER_127
	max_ammo = 5

/obj/item/ammo_casing/mm127
	desc = "A 12.7mm bullet casing."
	caliber = CALIBER_127
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "casing127mm"
	projectile_type = /obj/projectile/bullet/mm127

/obj/projectile/bullet/mm127
	name = "127mm bullet"
	icon_state = "bullet"
	damage = 75
	hitsound_wall = "ricochet"

/obj/item/ammo_box/speed_loader_mm127
	name = "speed loader (12.7mm)"
	desc = "Designed to quickly reload... is it a revolver speedloader with rifle cartidges in it?"
	ammo_type = /obj/item/ammo_casing/mm127
	max_ammo = 5
	multiple_sprites = AMMO_BOX_PER_BULLET
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "mm127"

/obj/item/ammo_box/box_mm127
	name = "ammo box (12.7)"
	desc = "Contains up to 100 12.7mm cartridges."
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = /obj/item/ammo_casing/mm127
	max_ammo = 100
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "mm127_box"

/obj/projectile/bullet/mm127/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/carbon/M = target
	if(M.move_resist == INFINITY)
		return
	var/atom/target_throw = get_edge_target_turf(M, get_dir(src, get_step_away(M, starting)))
	M.throw_at(target_throw, 2, 2)

#undef CALIBER_127
#undef CALIBER_44
