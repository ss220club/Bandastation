#define RESOLVE_ICON_STATE(worn_item) (worn_item.worn_icon_state || worn_item.icon_state)

/obj/item/bodypart
	var/species_bodytype

/mob/living/carbon/human/update_worn_mask(update_obscured = TRUE)
	remove_overlay(FACEMASK_LAYER)

	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)
	if(isnull(my_head)) //Decapitated
		return

	if(client && hud_used && hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_MASK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_MASK) + 1]
		inv.update_icon()

	if(wear_mask)
		var/obj/item/worn_item = wear_mask
		update_hud_wear_mask(worn_item)

		if(update_obscured)
			update_obscured_slots(worn_item.flags_inv)

		if(check_obscured_slots(transparent_protection = TRUE) & ITEM_SLOT_MASK)
			return

		var/icon_file = 'icons/mob/clothing/mask.dmi'
		var/list/icon_files_species = list(
			SPECIES_VULPKANIN = 'modular_bandastation/species/icons/mob/species/clothing/mask.dmi',
		)

		var/mutant_override = FALSE

		var/obj/item/bodypart/head/bodypart_head = src.get_bodypart(BODY_ZONE_HEAD)
		if(worn_item.worn_icon_species && worn_item.worn_icon_species[src.dna.species.id])
			icon_file = worn_item.worn_icon_species[bodypart_head.species_bodytype]
			mutant_override = TRUE
		else if(bodypart_head.species_bodytype in icon_files_species)
			icon_file = icon_files_species[bodypart_head.species_bodytype]
			mutant_override = FALSE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			icon_file = 'icons/mob/clothing/mask.dmi'
			mutant_override = FALSE

		var/mutable_appearance/mask_overlay = wear_mask.build_worn_icon(default_layer = FACEMASK_LAYER, default_icon_file = icon_file, override_file = mutant_override ? icon_file : null)
		my_head.worn_mask_offset?.apply_offset(mask_overlay)
		overlays_standing[FACEMASK_LAYER] = mask_overlay

	apply_overlay(FACEMASK_LAYER)
	update_mutant_bodyparts()

/mob/living/carbon/human/update_worn_head(update_obscured = TRUE)
	remove_overlay(HEAD_LAYER)
	if(client && hud_used && hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_HEAD) + 1]
		inv.update_icon()

	if(head)
		var/obj/item/worn_item = head
		update_hud_head(worn_item)

		if(update_obscured)
			update_obscured_slots(worn_item.flags_inv)

		if(check_obscured_slots(transparent_protection = TRUE) & ITEM_SLOT_HEAD)
			return

		var/icon_file = 'icons/mob/clothing/head/default.dmi'
		var/list/icon_files_species = list(
			SPECIES_VULPKANIN = 'modular_bandastation/species/icons/mob/species/clothing/head.dmi',
		)

		var/mutant_override = FALSE

		var/obj/item/bodypart/head/bodypart_head = src.get_bodypart(BODY_ZONE_HEAD)
		if(worn_item.worn_icon_species && worn_item.worn_icon_species[src.dna.species.id])
			icon_file = worn_item.worn_icon_species[src.dna.species.id]
			mutant_override = TRUE
		else if(bodypart_head.species_bodytype in icon_files_species)
			icon_file = icon_files_species[bodypart_head.species_bodytype]
			mutant_override = FALSE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			icon_file = 'icons/mob/clothing/head/default.dmi'
			mutant_override = FALSE

		var/mutable_appearance/head_overlay = head.build_worn_icon(default_layer = HEAD_LAYER, default_icon_file = icon_file, override_file = mutant_override ? icon_file : null)
		var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)
		my_head?.worn_head_offset?.apply_offset(head_overlay)
		overlays_standing[HEAD_LAYER] = head_overlay

	apply_overlay(HEAD_LAYER)

/mob/living/carbon/human/update_worn_oversuit(update_obscured = TRUE)
	remove_overlay(SUIT_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_OCLOTHING) + 1]
		inv.update_icon()

	if(wear_suit)
		var/obj/item/worn_item = wear_suit
		update_hud_wear_suit(worn_item)

		if(update_obscured)
			update_obscured_slots(worn_item.flags_inv)

		var/icon_file = DEFAULT_SUIT_FILE
		var/list/icon_files_species = list(
			/datum/species/vulpkanin = 'modular_bandastation/species/icons/mob/species/clothing/suit.dmi',
		)

		var/mutant_override = FALSE

		if(worn_item.worn_icon_species && worn_item.worn_icon_species[src.dna.species.id])
			icon_file = worn_item.worn_icon_species[src.dna.species.id]
			mutant_override = TRUE
		else if(src.dna.species.type in icon_files_species)
			icon_file = icon_files_species[src.dna.species.type]
			mutant_override = FALSE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			icon_file = DEFAULT_SUIT_FILE
			mutant_override = FALSE

		var/mutable_appearance/suit_overlay = wear_suit.build_worn_icon(default_layer = SUIT_LAYER, default_icon_file = icon_file, override_file = mutant_override ? icon_file : null)
		var/obj/item/bodypart/chest/my_chest = get_bodypart(BODY_ZONE_CHEST)
		my_chest?.worn_suit_offset?.apply_offset(suit_overlay)
		overlays_standing[SUIT_LAYER] = suit_overlay
	update_body_parts()
	update_mutant_bodyparts()

	apply_overlay(SUIT_LAYER)
