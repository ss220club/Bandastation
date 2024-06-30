/obj/item/organ/internal/tongue/vulpkanin
	name = "long tongue"
	desc = "Длинный и более чувствительный язык, может различить больше вкусов"
	icon_state = "tongue"
	taste_sensitivity = 10
	modifies_speech = FALSE
	languages_native = list(/datum/language/canilunzt)
	liked_foodtypes = RAW | MEAT | SEAFOOD | DAIRY
	disliked_foodtypes =  FRUIT | NUTS | GROSS | GRAIN

/obj/item/organ/internal/tongue/vulpkanin/get_possible_languages()
	return ..() + /datum/language/canilunzt

/obj/item/organ/internal/tongue/vulpkanin/on_mob_insert(mob/living/carbon/owner)
	. = ..()
	add_verb(owner, /mob/living/carbon/human/species/vulpkanin/proc/emote_howl)
	add_verb(owner, /mob/living/carbon/human/species/vulpkanin/proc/emote_growl)

/obj/item/organ/internal/tongue/vulpkanin/on_mob_remove(mob/living/carbon/owner)
	. = ..()
	remove_verb(owner, /mob/living/carbon/human/species/vulpkanin/proc/emote_howl)
	remove_verb(owner, /mob/living/carbon/human/species/vulpkanin/proc/emote_growl)

/obj/item/organ/internal/stomach/vulpkanin
	hunger_modifier = 1.3

/obj/item/organ/internal/liver/vulpkanin
	name = "vulpkanin liver"
	icon = 'modular_bandastation/species/icons/mob/species/vulpkanin/organs.dmi'
	alcohol_tolerance = ALCOHOL_RATE * 2.5

/obj/item/organ/internal/eyes/vulpkanin
	name = "vulpkanin eyeballs"
	icon = 'modular_bandastation/species/icons/mob/species/vulpkanin/organs.dmi'

/obj/item/organ/internal/ears/vulpkanin
	desc = "Большие ушки позволяют легче слышать шепот."
	damage_multiplier = 2

/obj/item/organ/internal/ears/vulpkanin/on_mob_insert(mob/living/carbon/ear_owner)
	. = ..()
	ADD_TRAIT(ear_owner, TRAIT_GOOD_HEARING, ORGAN_TRAIT)

/obj/item/organ/internal/ears/vulpkanin/on_mob_remove(mob/living/carbon/ear_owner)
	. = ..()
	REMOVE_TRAIT(ear_owner, TRAIT_GOOD_HEARING, ORGAN_TRAIT)

/obj/item/organ/internal/heart/vulpkanin
	name = "vulpkanin heart"
	icon = 'modular_bandastation/species/icons/mob/species/vulpkanin/organs.dmi'

/obj/item/organ/internal/brain/vulpkanin
	icon = 'modular_bandastation/species/icons/mob/species/vulpkanin/organs.dmi'
	actions_types = list(/datum/action/cooldown/sniff)

/obj/item/organ/internal/lungs/vulpkanin
	name = "vulpkanin lungs"
	icon = 'modular_bandastation/species/icons/mob/species/vulpkanin/organs.dmi'

/obj/item/organ/internal/kidneys/vulpkanin
	name = "vulpkanin kidneys"
	icon = 'modular_bandastation/species/icons/mob/species/vulpkanin/organs.dmi'
