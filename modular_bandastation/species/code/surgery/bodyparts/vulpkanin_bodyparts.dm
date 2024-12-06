/obj/item/bodypart/head/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN
	is_dimorphic = TRUE
	head_flags = HEAD_LIPS|HEAD_EYESPRITES|HEAD_EYECOLOR|HEAD_EYEHOLES|HEAD_DEBRAIN|HEAD_HAIR|HEAD_VULPKANIN
	species_bodytype = SPECIES_VULPKANIN

/obj/item/bodypart/chest/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN
	is_dimorphic = TRUE
	wing_types = list(/obj/item/organ/wings/functional/dragon)
	species_bodytype = SPECIES_VULPKANIN

/obj/item/bodypart/chest/vulpkanin/get_butt_sprite()
	return BUTT_SPRITE_VULPKANIN

/obj/item/bodypart/arm/left/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN
	unarmed_attack_verbs = list("slash")
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/items/weapons/slice.ogg'
	unarmed_miss_sound = 'sound/items/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/left/vulpkanin/get_limb_icon(dropped)
	. = ..()
	var/image/limb = image(layer = -23, dir = NONE)

	limb.icon = icon_greyscale
	if(!should_draw_greyscale || !icon_greyscale)
		limb.icon = icon_static

	if(is_dimorphic) //Does this type of limb have sexual dimorphism?
		limb.icon_state = "[limb_id]_[body_zone]_[limb_gender]"
	else
		limb.icon_state = "[limb_id]_[body_zone]"

	var/image/aux
	if(aux_zone)
		aux = image(limb.icon, "pointsfade_hand_l_arm", -23, NONE)
		. += aux

	return .

/obj/item/bodypart/arm/right/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN
	unarmed_attack_verbs = list("slash")
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/items/weapons/slice.ogg'
	unarmed_miss_sound = 'sound/items/weapons/slashmiss.ogg'

/obj/item/bodypart/leg/left/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN

/obj/item/bodypart/leg/right/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN

/obj/item/bodypart/leg/left/vulpkanin/digitigrade
	limb_id = "vulpkanin_digi"
	bodyshape = BODYSHAPE_HUMANOID | BODYSHAPE_DIGITIGRADE
	footprint_sprite = FOOTPRINT_SPRITE_CLAWS
	footstep_type = FOOTSTEP_MOB_CLAW

/obj/item/bodypart/leg/left/vulpkanin/digitigrade/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	. = ..()
	limb_id = owner?.is_digitigrade_squished() ? SPECIES_VULPKANIN : "vulpkanin_digi"

/obj/item/bodypart/leg/right/vulpkanin/digitigrade
	limb_id = "vulpkanin_digi"
	bodyshape = BODYSHAPE_HUMANOID | BODYSHAPE_DIGITIGRADE
	footprint_sprite = FOOTPRINT_SPRITE_CLAWS
	footstep_type = FOOTSTEP_MOB_CLAW

/obj/item/bodypart/leg/right/vulpkanin/digitigrade/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	. = ..()
	limb_id = owner?.is_digitigrade_squished() ? SPECIES_VULPKANIN : "vulpkanin_digi"
