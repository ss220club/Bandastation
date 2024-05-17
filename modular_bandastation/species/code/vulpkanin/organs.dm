/obj/item/organ/internal/tongue/vulpkanin
	name = "long tongue"
	desc = "длинный и более чувствительный язык, может различить больше вкусов"
	icon_state = "tongue"
	taste_sensitivity = 10
	modifies_speech = FALSE
	languages_native = list(/datum/language/canilunzt)
	liked_foodtypes = RAW | MEAT | SEAFOOD
	disliked_foodtypes = VEGETABLES | GRAIN | FRUIT | JUNKFOOD | GORE

/obj/item/organ/internal/tongue/vulpkanin/get_possible_languages()
	RETURN_TYPE(/list)
	return list(
		/datum/language/common,
		/datum/language/uncommon,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/nekomimetic,
		/datum/language/canilunzt
	)

/obj/item/organ/external/tail/vulpkanin
	name = "vulpkanin tail"
	preference = "feature_vulpkanin_tail"

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/vulpkanin

	wag_flags = WAG_ABLE
	dna_block = 18
	var/datum/bodypart_overlay/mutant/vulpkanin_tail_markings/tail_markings_overlay

/datum/bodypart_overlay/mutant/tail/vulpkanin
	feature_key = "tail_vulpkanin"

/datum/bodypart_overlay/mutant/tail/vulpkanin/get_global_feature_list()
	return GLOB.tails_list_vulpkanin

/obj/item/organ/internal/stomach/vulpkanin
	hunger_modifier = 1.5

//

/datum/bodypart_overlay/mutant/vulpkanin_tail_markings
	layers = EXTERNAL_FRONT|EXTERNAL_BEHIND
	feature_key = "tailmarkings"
	var/wagging = FALSE
	var/tail_markings_key = NONE
	var/tail_markings_color = "#FFFFFF"

/datum/bodypart_overlay/mutant/vulpkanin_tail_markings/get_global_feature_list()
	return GLOB.vulpkanin_tail_markings_list

/datum/bodypart_overlay/mutant/vulpkanin_tail_markings/get_base_icon_state()
	return (!isnull(tail_markings_key) ? "[tail_markings_key]_" : "") + (wagging ? "wagging_" : "") + sprite_datum.icon_state

/datum/bodypart_overlay/mutant/vulpkanin_tail_markings/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = ..()
	if(human.wear_suit && (human.wear_suit.flags_inv & HIDEJUMPSUIT))
		return FALSE

/datum/bodypart_overlay/mutant/vulpkanin_tail_markings/override_color(rgb_value)
	return tail_markings_color
//

/obj/item/organ/external/tail/vulpkanin/on_bodypart_insert(obj/item/bodypart/bodypart)
	var/data = ..()
	insert_tail_markings(bodypart)
	return data

/obj/item/organ/external/tail/vulpkanin/on_bodypart_remove(obj/item/bodypart/bodypart)
	remove_tail_markings(bodypart)
	return ..()

/obj/item/organ/external/tail/vulpkanin/proc/insert_tail_markings(obj/item/bodypart/bodypart)
	if(tail_markings_overlay)
		return

	var/datum/sprite_accessory/tails/vulpkanin/tail_sprite_datum = bodypart_overlay.sprite_datum

	if(!istype(tail_sprite_datum))
		return

	var/tail_markings_key = tail_sprite_datum.icon_state
	if(!tail_markings_key)
		return

	var/mob/living/carbon/human/owner = bodypart.owner
	var/feature_name = bodypart.owner.dna.features["tail_markings"]
	if (feature_name && istype(owner, /mob/living/carbon/human))
		tail_markings_overlay = new
		tail_markings_overlay.tail_markings_key = tail_markings_key
		tail_markings_overlay.color_source = ORGAN_COLOR_OVERRIDE
		tail_markings_overlay.tail_markings_color = owner.vulpkanin_tail_markings_color
		tail_markings_overlay.set_appearance_from_name(feature_name)
		bodypart.add_bodypart_overlay(tail_markings_overlay)

/obj/item/organ/external/tail/vulpkanin/proc/remove_tail_markings(obj/item/bodypart/bodypart)
	if(!tail_markings_overlay)
		return
	bodypart.remove_bodypart_overlay(tail_markings_overlay)
	QDEL_NULL(tail_markings_overlay)

/obj/item/organ/external/tail/vulpkanin/start_wag(mob/living/carbon/organ_owner, stop_after = INFINITY)
	if(tail_markings_overlay)
		tail_markings_overlay.wagging = TRUE
	return ..()

/obj/item/organ/external/tail/vulpkanin/stop_wag(mob/living/carbon/organ_owner)
	if(tail_markings_overlay)
		tail_markings_overlay.wagging = FALSE
	return ..()
