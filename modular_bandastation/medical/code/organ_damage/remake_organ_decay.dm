/mob/living/carbon/handle_organs(seconds_per_tick, times_fired)
	if(stat == DEAD)
		if(reagents && (reagents.has_reagent(/datum/reagent/toxin/formaldehyde, 1) || reagents.has_reagent(/datum/reagent/cryostylane)) || has_status_effect(/datum/status_effect/cpred)) // No organ decay if the body contains formaldehyde.
			return
		for(var/obj/item/organ/internal/organ in organs)
			// On-death is where organ decay is handled
			if(organ?.owner) // organ + owner can be null due to reagent metabolization causing organ shuffling
				organ.on_death(seconds_per_tick, times_fired)
			// We need to re-check the stat every organ, as one of our others may have revived us
			if(stat != DEAD)
				break
		return

	// NOTE: organs_slot is sorted by GLOB.organ_process_order on insertion
	for(var/slot in organs_slot)
		// We don't use get_organ_slot here because we know we have the organ we want, since we're iterating the list containing em already
		// This code is hot enough that it's just not worth the time
		var/obj/item/organ/internal/organ = organs_slot[slot]
		if(organ?.owner) // This exist mostly because reagent metabolization can cause organ reshuffling
			organ.on_life(seconds_per_tick, times_fired)
