/datum/preference/choiced/vulpkanin_body_markings
	savefile_key = "feature_vulpkanin_body_markings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Body markings"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = "vulpkanin_body_markings"

/datum/preference/choiced/vulpkanin_body_markings/init_possible_values()
	return assoc_to_keys_features(GLOB.vulpkanin_body_markings_list)

/datum/preference/choiced/vulpkanin_body_markings/create_default_value()
	var/datum/sprite_accessory/vulpkanin_body_markings/markings = /datum/sprite_accessory/vulpkanin_body_markings
	return initial(markings.name)

/datum/preference/choiced/vulpkanin_body_markings/icon_for(value)
	var/static/icon/body
	if (isnull(body))
		body = icon('icons/blanks/32x32.dmi', "nothing")
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_chest_m"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_l_leg"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_r_leg"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_l_arm"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_r_arm"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_l_hand"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_r_hand"), ICON_OVERLAY)
		body.Blend(COLOR_ORANGE, ICON_MULTIPLY)

	var/datum/sprite_accessory/markings = GLOB.vulpkanin_body_markings_list[value]
	var/icon/icon_with_markings = new(body)

	if (value != "None")
		var/icon/body_part_icon = icon(markings.icon, "m_vulpkanin_body_markings_[markings.icon_state]_ADJ")
		body_part_icon.Crop(1, 1, 32, 32)
		body_part_icon.Blend(COLOR_VERY_LIGHT_GRAY, ICON_MULTIPLY)
		icon_with_markings.Blend(body_part_icon, ICON_OVERLAY)

	icon_with_markings.Scale(64, 64)
	icon_with_markings.Crop(15, 38, 15 + 31, 7)

	return icon_with_markings

/datum/preference/choiced/vulpkanin_body_markings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["vulpkanin_body_markings"] = value

/datum/preference/choiced/tail_vulpkanin
	savefile_key = "feature_vulpkanin_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/tail/vulpkanin

/datum/preference/choiced/tail_vulpkanin/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list_vulpkanin)

/datum/preference/choiced/tail_vulpkanin/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_vulpkanin"] = value

/datum/preference/choiced/tail_vulpkanin/create_default_value()
	var/datum/sprite_accessory/tails/vulpkanin/fluffy/tail = /datum/sprite_accessory/tails/vulpkanin/fluffy
	return initial(tail.name)

/datum/preference/choiced/vulpkanin_body_markings/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "vulpkanin_body_markings_color"

	return data

/datum/preference/color/vulpkanin_body_markings_color
	priority = PREFERENCE_PRIORITY_BODYPARTS
	savefile_key = "vulpkanin_body_markings_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_mutant_bodypart = "vulpkanin_body_markings"

/datum/preference/color/vulpkanin_body_markings_color/apply_to_human(mob/living/carbon/human/target, value)
	target.set_vulpkanin_body_markings_color(value, update = FALSE)

/mob/living/carbon/human
	var/vulpkanin_body_markings_color = "#FFFFFF"
	var/vulpkanin_head_markings_color = "#FFFFFF"
	var/vulpkanin_head_accessory_color = "#FFFFFF"
	var/vulpkanin_tail_markings_color = "#FFFFFF"

/mob/living/proc/set_vulpkanin_body_markings_color(hex_string, override, update = TRUE)
	return

/mob/living/carbon/human/set_vulpkanin_body_markings_color(hex_string, override, update = TRUE)

	vulpkanin_body_markings_color = hex_string

	if(update)
		update_body_parts()

// Раскраска тела:
// Раскраска хвоста:
// Раскраска головы:
// Кастомизация головы:

// HEAD MARKINGS

/datum/preference/choiced/vulpkanin_head_markings
	savefile_key = "feature_vulpkanin_head_markings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Head markings"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = "vulpkanin_head_markings"

/datum/preference/choiced/vulpkanin_head_markings/init_possible_values()
	return assoc_to_keys_features(GLOB.vulpkanin_head_markings_list)

/datum/preference/choiced/vulpkanin_head_markings/icon_for(value)
	var/static/icon/body
	if (isnull(body))
		body = icon('icons/blanks/32x32.dmi', "nothing")
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_head_m"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_chest_m"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_l_leg"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_r_leg"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_l_arm"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_r_arm"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_l_hand"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_r_hand"), ICON_OVERLAY)
		body.Blend(COLOR_ORANGE, ICON_MULTIPLY)

	var/datum/sprite_accessory/markings = GLOB.vulpkanin_head_markings_list[value]
	var/icon/icon_with_markings = new(body)

	if (value != "None")
		var/icon/body_part_icon = icon(markings.icon, "m_vulpkanin_head_markings_[markings.icon_state]_ADJ")
		body_part_icon.Crop(1, 1, 32, 32)
		body_part_icon.Blend(COLOR_VERY_LIGHT_GRAY, ICON_MULTIPLY)
		icon_with_markings.Blend(body_part_icon, ICON_OVERLAY)

	icon_with_markings.Scale(64, 64)
	icon_with_markings.Crop(15, 64, 15 + 31, 64 - 31)

	return icon_with_markings

/datum/preference/choiced/vulpkanin_head_markings/create_default_value()
	var/datum/sprite_accessory/vulpkanin_head_markings/markings = /datum/sprite_accessory/vulpkanin_head_markings
	return initial(markings.name)

/datum/preference/choiced/vulpkanin_head_markings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["vulpkanin_head_markings"] = value

/datum/preference/choiced/vulpkanin_head_markings/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "vulpkanin_head_markings_color"

	return data

/datum/preference/color/vulpkanin_head_markings_color
	priority = PREFERENCE_PRIORITY_BODYPARTS
	savefile_key = "vulpkanin_head_markings_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_mutant_bodypart = "vulpkanin_head_markings"

/datum/preference/color/vulpkanin_head_markings_color/apply_to_human(mob/living/carbon/human/target, value)
	target.set_vulpkanin_head_markings_color(value, update = FALSE)

/mob/living/proc/set_vulpkanin_head_markings_color(hex_string, override, update = TRUE)
	return

/mob/living/carbon/human/set_vulpkanin_head_markings_color(hex_string, override, update = TRUE)
	vulpkanin_head_markings_color = hex_string

	if(update)
		update_body_parts()

// HEAD ACCESSORIES

/datum/preference/choiced/vulpkanin_head_accessories
	savefile_key = "feature_vulpkanin_head_accessories"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Head accessories"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = "vulpkanin_head_accessories"

/datum/preference/choiced/vulpkanin_head_accessories/init_possible_values()
	return assoc_to_keys_features(GLOB.vulpkanin_head_accessories_list)

/datum/preference/choiced/vulpkanin_head_accessories/icon_for(value)
	var/static/icon/body
	if (isnull(body))
		body = icon('icons/blanks/32x32.dmi', "nothing")
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_head_m"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_chest_m"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_l_arm"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_r_arm"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_l_hand"), ICON_OVERLAY)
		body.Blend(icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_r_hand"), ICON_OVERLAY)
		body.Blend(COLOR_ORANGE, ICON_MULTIPLY)

	var/datum/sprite_accessory/markings = GLOB.vulpkanin_head_accessories_list[value]
	var/icon/icon_with_markings = new(body)

	if (value != "None")
		var/icon/body_part_icon = icon(markings.icon, "m_vulpkanin_head_accessories_[markings.icon_state]_ADJ")
		body_part_icon.Crop(1, 1, 32, 32)
		body_part_icon.Blend(COLOR_VERY_LIGHT_GRAY, ICON_MULTIPLY)
		icon_with_markings.Blend(body_part_icon, ICON_OVERLAY)

	icon_with_markings.Scale(64, 64)
	icon_with_markings.Crop(15, 64, 15 + 31, 64 - 31)

	return icon_with_markings

/datum/preference/choiced/vulpkanin_head_accessories/create_default_value()
	var/datum/sprite_accessory/vulpkanin_head_accessories/markings = /datum/sprite_accessory/vulpkanin_head_accessories
	return initial(markings.name)

/datum/preference/choiced/vulpkanin_head_accessories/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["vulpkanin_head_accessories"] = value

/datum/preference/choiced/vulpkanin_head_accessories/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "vulpkanin_head_accessories_color"

	return data

/datum/preference/color/vulpkanin_head_accessories_color
	priority = PREFERENCE_PRIORITY_BODYPARTS
	savefile_key = "vulpkanin_head_accessories_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_mutant_bodypart = "vulpkanin_head_accessories"

/datum/preference/color/vulpkanin_head_accessories_color/apply_to_human(mob/living/carbon/human/target, value)
	target.set_vulpkanin_head_accessories_color(value, update = FALSE)

/mob/living/proc/set_vulpkanin_head_accessories_color(hex_string, override, update = TRUE)
	return

/mob/living/carbon/human/set_vulpkanin_head_accessories_color(hex_string, override, update = TRUE)
	vulpkanin_head_accessory_color = hex_string

	if(update)
		update_body_parts()

// FACIAL HAIR

/datum/preference/choiced/vulpkanin_facial_hair
	savefile_key = "feature_vulpkanin_facial_hair"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Vulpkanin facial"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = "vulpkanin_facial_hair"

/datum/preference/choiced/vulpkanin_facial_hair/init_possible_values()
	return assoc_to_keys_features(GLOB.vulpkanin_facial_hair_list)

/datum/preference/choiced/vulpkanin_facial_hair/icon_for(value)
	var/datum/sprite_accessory/markings = GLOB.vulpkanin_facial_hair_list[value]
	var/static/icon/head_icon
	if (isnull(head_icon))
		head_icon = icon('modular_bandastation/species/icons/vulpkanin/body.dmi', "vulpkanin_head_m")
		head_icon.Blend(COLOR_ORANGE, ICON_MULTIPLY)

	var/icon/final_icon = new(head_icon)
	if (!isnull(markings))
		ASSERT(istype(markings))

		var/icon/head_accessory_icon = icon(markings.icon, "m_vulpkanin_facial_hair_[markings.icon_state]_ADJ")
		head_accessory_icon.Blend(COLOR_VERY_LIGHT_GRAY, ICON_MULTIPLY)
		final_icon.Blend(head_accessory_icon, ICON_OVERLAY)

	final_icon.Crop(10, 19, 22, 31)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/choiced/vulpkanin_facial_hair/create_default_value()
	var/datum/sprite_accessory/vulpkanin_facial_hair/markings = /datum/sprite_accessory/vulpkanin_facial_hair
	return initial(markings.name)

/datum/preference/choiced/vulpkanin_facial_hair/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["vulpkanin_facial_hair"] = value

/datum/preference/choiced/vulpkanin_facial_hair/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "vulpkanin_facial_hair_color"

	return data

/datum/preference/color/vulpkanin_facial_hair_color
	priority = PREFERENCE_PRIORITY_BODYPARTS
	savefile_key = "vulpkanin_facial_hair_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_mutant_bodypart = "vulpkanin_facial_hair"

/datum/preference/color/vulpkanin_facial_hair_color/apply_to_human(mob/living/carbon/human/target, value)
	target.set_vulpkanin_facial_hair_color(value, update = FALSE)

/mob/living/proc/set_vulpkanin_facial_hair_color(hex_string, override, update = TRUE)
	return

/mob/living/carbon/human/set_vulpkanin_facial_hair_color(hex_string, override, update = TRUE)
	facial_hair_color = hex_string

	if(update)
		update_body_parts()
//

/datum/preference/choiced/vulpkanin_tail_markings
	savefile_key = "feature_vulpkanin_tail_markings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_mutant_bodypart = "vulpkanin_tail_markings"

/datum/preference/choiced/vulpkanin_tail_markings/init_possible_values()
	return assoc_to_keys_features(GLOB.vulpkanin_tail_markings_list)

/datum/preference/choiced/vulpkanin_tail_markings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_markings"] = value

/datum/preference/choiced/vulpkanin_tail_markings/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "vulpkanin_tail_markings_color"

	return data

/datum/preference/color/vulpkanin_tail_markings_color
	savefile_key = "vulpkanin_tail_markings_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_mutant_bodypart = "vulpkanin_tail_markings"

/datum/preference/color/vulpkanin_tail_markings_color/apply_to_human(mob/living/carbon/human/target, value)
	target.set_vulpkanin_tail_markings_color(value, update = FALSE)

/mob/living/proc/set_vulpkanin_tail_markings_color(hex_string, override, update = TRUE)
	return

/mob/living/carbon/human/set_vulpkanin_tail_markings_color(hex_string, override, update = TRUE)
	vulpkanin_tail_markings_color = hex_string

	if(update)
		update_body_parts()

/datum/preference/color/vulpkanin_tail_markings_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return preferences.read_preference(/datum/preference/choiced/vulpkanin_tail_markings)
