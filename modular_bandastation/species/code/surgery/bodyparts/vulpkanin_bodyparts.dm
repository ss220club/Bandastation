/obj/item/bodypart/head/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN
	is_dimorphic = TRUE
	head_flags = HEAD_LIPS|HEAD_EYESPRITES|HEAD_EYECOLOR|HEAD_EYEHOLES|HEAD_DEBRAIN|HEAD_HAIR

/obj/item/bodypart/chest/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN
	is_dimorphic = TRUE
	wing_types = list(/obj/item/organ/external/wings/functional/dragon)

/obj/item/bodypart/chest/vulpkanin/get_butt_sprite()
	return BUTT_SPRITE_VULPKANIN

/obj/item/bodypart/arm/left/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN
	unarmed_attack_verbs = list("slash")
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/right/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN
	unarmed_attack_verbs = list("slash")
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/leg/left/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN

/obj/item/bodypart/leg/right/vulpkanin
	icon_greyscale = 'modular_bandastation/species/icons/mob/species/vulpkanin/body.dmi'
	limb_id = SPECIES_VULPKANIN
