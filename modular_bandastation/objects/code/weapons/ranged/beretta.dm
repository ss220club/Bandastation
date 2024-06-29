#define CALIBER_9X19RMM "9x19rmm"
#define CALIBER_9X19BMM "9x19bmm"
#define CALIBER_9X19MM "9x19mm"
#define CALIBER_9X19AMM "9x19amm"

// Beretta M9
/obj/item/gun/ballistic/automatic/pistol/beretta
	name = "беретта M9"
	desc = "Один из самых распространенных и узнаваемых пистолетов во вселенной. К сожалению, из-за особенности ствола, на пистолет нельзя приделать глушитель. Старая добрая классика."
	icon = 'modular_bandastation/objects/icons/guns.dmi'
	lefthand_file = 'modular_bandastation/objects/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/guns_righthand.dmi'
	icon_state = "beretta"
	inhand_icon_state = "beretta"
	w_class = WEIGHT_CLASS_NORMAL
	can_suppress = FALSE
	accepted_magazine_type = /obj/item/ammo_box/magazine/beretta
	fire_sound = 'modular_bandastation/objects/sounds/weapons/gunshots/beretta_shot.ogg'
	fire_sound_volume = 30

/obj/item/gun/ballistic/automatic/pistol/beretta/desert
	icon_state = "beretta_desert"

/obj/item/gun/ballistic/automatic/pistol/beretta/black
	icon_state = "beretta_black"

/obj/item/gun/ballistic/automatic/pistol/beretta/add_seclight_point()
	. = ..()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_y = 12, \
		overlay_x = 17, \
	)

/obj/item/ammo_box/magazine/beretta
	name = "beretta rubber 9x19mm magazine"
	desc = "Магазин резиновых патронов калибра 9x19mm."
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "berettar-10"
	base_icon_state = "berettar"
	ammo_type = /obj/item/ammo_casing/beretta/mmrub919
	max_ammo = 10
	multiload = 0
	caliber = CALIBER_9X19RMM
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/magazine/beretta/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 2)]"

/obj/item/ammo_box/magazine/beretta/mm919
	name = "beretta lethal 9x19mm magazine"
	desc = "Магазин летальных патронов калибра 9x19mm."
	icon_state = "berettal-10"
	base_icon_state = "berettal"
	ammo_type = /obj/item/ammo_casing/beretta/mm919
	multiple_sprites = AMMO_BOX_PER_BULLET
	caliber = CALIBER_9X19MM

/obj/item/ammo_box/magazine/beretta/mm919/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 2)]"

/obj/item/ammo_box/magazine/beretta/mmbsp919
	name = "beretta bluespace 9x19mm magazine"
	desc = "Магазин экспериментальных блюспейс патронов калибра 9x19mm. Из-за особенности корпуса вмещает только блюспейс патроны."
	icon_state = "berettab-10"
	base_icon_state = "berettab"
	ammo_type = /obj/item/ammo_casing/beretta/mmbsp919
	multiple_sprites = AMMO_BOX_PER_BULLET
	caliber = CALIBER_9X19BMM

/obj/item/ammo_box/magazine/beretta/mmbsp919/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 2)]"

/obj/item/ammo_box/magazine/beretta/mmap919
	name = "beretta armor-piercing 9x19mm magazine"
	desc = "Магазин бронебойных патронов калибра 9x19mm."
	icon_state = "berettaap-10"
	base_icon_state = "berettaap"
	caliber = CALIBER_9X19AMM
	ammo_type = /obj/item/ammo_casing/beretta/mmap919
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/magazine/beretta/mmap919/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 2)]"

/obj/item/ammo_casing/beretta/mmbsp919
	caliber = CALIBER_9X19BMM
	name = "9x19mm bluespace bullet casing"
	desc = "A 9x19mm bluespace bullet casing."
	projectile_type = /obj/projectile/bullet/mmbsp919

/obj/projectile/bullet/mmbsp919
	name = "9x19 bluespace bullet"
	damage = 18
	speed = 0.2

/obj/item/ammo_casing/beretta/mmap919
	caliber = CALIBER_9X19AMM
	name = "9x19mm armor-piercing bullet casing"
	desc = "A 9x19 armor-piercing bullet casing."
	projectile_type = /obj/projectile/bullet/mmap919

/obj/projectile/bullet/mmap919
	name = "9x19mm armor-piercing bullet"
	damage = 18
	armour_penetration = 15

/obj/item/ammo_casing/beretta/mmrub919
	name = "9x19mm rubber bullet casing"
	caliber = CALIBER_9X19RMM
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "casingmm919"
	desc = "A 9x19 rubber bullet casing."
	projectile_type = /obj/projectile/bullet/mmrub919

/obj/projectile/bullet/mmrub919
	name = "beretta rubber bullet"
	damage = 5
	stamina = 30

/obj/item/ammo_casing/beretta/mm919
	name = "9x19mm lethal bullet casing"
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "casingmm919"
	desc = "A 9x19 lethal bullet casing."
	projectile_type = /obj/projectile/bullet/mm919
	caliber = CALIBER_9X19MM

/obj/projectile/bullet/mm919
	name = "beretta lethal bullet"
	damage = 20

/obj/item/ammo_box/beretta
	name = "box of rubber 9x19mm cartridges"
	desc = "Содержит до 30 резиновых патронов калибра 9x19mm."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/beretta/mmrub919
	max_ammo = 30
	icon = 'modular_bandastation/objects/icons/ammo.dmi'
	icon_state = "9mmr_box"

/obj/item/ammo_box/beretta/mm919
	name = "box of lethal 9x19mm cartridges"
	desc = "Содержит до 20 летальных патронов калибра 9x19mm."
	ammo_type = /obj/item/ammo_casing/beretta/mm919
	max_ammo = 20
	icon_state = "9mm_box"

/obj/item/ammo_box/beretta/mmbsp919
	name = "box of bluespace 9x19mm cartridges"
	desc = "Содержит до 20 блюспейс патронов калибра 9x19mm."
	ammo_type = /obj/item/ammo_casing/beretta/mmbsp919
	max_ammo = 20
	icon_state = "9mmb_box"

/obj/item/ammo_box/beretta/mmap919
	name = "box of armor-penetration 9x19mm cartridges"
	desc = "Содержит до 20 бронебойных патронов калибра 9x19mm."
	ammo_type = /obj/item/ammo_casing/beretta/mmap919
	max_ammo = 20
	icon_state = "9mmap_box"

/datum/supply_pack/security/armory/beretta
	name = "Beretta M9 Crate"
	contains = list(/obj/item/gun/ballistic/automatic/pistol/beretta = 2,)
	cost = CARGO_CRATE_VALUE * 3.25
	crate_name = "beretta m9 pack"

/datum/supply_pack/security/armory/berettarubberammo
	name = "Beretta M9 Rubber Ammunition Crate"
	contains = list(
		/obj/item/ammo_box/beretta = 2,
		/obj/item/ammo_box/magazine/beretta = 2,
	)
	cost = CARGO_CRATE_VALUE * 1.75
	crate_name = "beretta rubber ammunition pack"

/datum/supply_pack/security/armory/berettalethalammo
	name = "Beretta M9 Lethal Ammunition Crate"
	contains = list(
		/obj/item/ammo_box/beretta/mm919 = 2,
		/obj/item/ammo_box/magazine/beretta/mm919 = 2,
	)
	cost = CARGO_CRATE_VALUE * 2
	crate_name = "beretta lethal ammunition pack"

/datum/supply_pack/security/armory/berettaexperimentalammo
	name = "Beretta M9 Bluespace Ammunition Crate"
	contains = list(
		/obj/item/ammo_box/beretta/mmbsp919 = 2,
		/obj/item/ammo_box/magazine/beretta/mmbsp919 = 2,
	)
	cost = CARGO_CRATE_VALUE * 3.25
	crate_name = "beretta bluespace ammunition pack"

/datum/supply_pack/security/armory/berettaarmorpiercingammo
	name = "Beretta M9 Armor-piercing Ammunition Crate"
	contains = list(
		/obj/item/ammo_box/beretta/mmap919 = 2,
		/obj/item/ammo_box/magazine/beretta/mmap919 = 2,
	)
	cost = CARGO_CRATE_VALUE * 2.5
	crate_name = "beretta AP ammunition pack"

/datum/design/box_beretta/lethal
	name = "Beretta M9 Lethal Ammo Box (9mm)"
	desc = "A box of 20 lethal rounds for Beretta M9"
	id = "box_beretta"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.3)
	build_path = /obj/item/ammo_box/beretta/mm919
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/box_beretta/ap
	name = "Beretta M9 AP Ammo Box (9mm)"
	desc = "A box of 20 armor-piercing rounds for Beretta M9"
	id = "box_beretta_ap"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.3,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.5,
	)
	build_path = /obj/item/ammo_box/beretta/mmap919
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/box_beretta/bluespace
	name = "Beretta M9 Bluespace Ammo Box (9mm)"
	desc = "A box of 20 high velocity bluespace rounds for Beretta M9"
	id = "box_beretta_bsp"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.3,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT * 0.5,
	)
	build_path = /obj/item/ammo_box/beretta/mmbsp919
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/techweb_node/beretta_ammo
	id = "beretta_ammo"
	display_name = "Beretta Ammo Research"
	description = "Наши учёные смогли разработать боеприпасы к пистолету беретта и даже несколько... специфичных."
	prereq_ids = list("exotic_ammo")
	design_ids = list(
		"box_beretta_bsp",
		"box_beretta_ap",
		"box_beretta",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)

#undef CALIBER_9X19MM
#undef CALIBER_9X19BMM
#undef CALIBER_9X19AMM
#undef CALIBER_9X19RMM
