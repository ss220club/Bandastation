// Removes donator_level items from the user if their donator_level is insufficient
/datum/preference/loadout/sanitize_loadout_list(list/passed_list, mob/optional_loadout_owner)
	. = ..()
	var/donator_level = optional_loadout_owner?.client?.get_donator_level() || 0
	var/removed_items = list()
	for(var/path in .)
		var/datum/loadout_item/item = GLOB.all_loadout_datums[path]
		if(donator_level >= item.donator_level)
			continue
		. -= path
		removed_items += item.name
	if(length(removed_items) && optional_loadout_owner)
		to_chat(optional_loadout_owner, span_warning("У вас недостаточный уровень доната, чтобы взять: [english_list(removed_items, and_text = " и ")]!"))
