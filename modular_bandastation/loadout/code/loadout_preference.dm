/client
	var/loadout_points = 0

/datum/client_interface/
	var/loadout_points = 0

/datum/preferences/load_preferences()
	. = ..()
	var/donation_level = parent.get_donator_level()
	switch(donation_level)
		if(0)
			parent.loadout_points = 5
		if(1)
			parent.loadout_points = 8
		if(2)
			parent.loadout_points = 11
		if(3)
			parent.loadout_points = 14
		if(4)
			parent.loadout_points = 17
		if(5)
			parent.loadout_points = 20

/datum/preference_middleware/loadout/on_new_character(mob/user)
	var/list/loaded_loadout_list = preferences.read_preference(/datum/preference/loadout)
	for(var/datum/loadout_item/item as anything in loaded_loadout_list)
		if (preferences.parent.loadout_points < item.cost)
			LAZYREMOVE(loaded_loadout_list, item.item_path)
			preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], loaded_loadout_list)
		else
			preferences.parent.loadout_points -= item.cost
	.=..()

// Handles selecting from the preferences UI
/datum/preference_middleware/loadout/select_item(datum/loadout_item/selected_item)
	var/donator_level = preferences.parent.get_donator_level()
	if(preferences.parent.loadout_points >= selected_item.cost && donator_level >= selected_item.donator_level)
		return ..()
	else if(donator_level < selected_item.donator_level)
		to_chat(preferences.parent.mob, span_warning("У вас недостаточный уровень доната, чтобы взять [selected_item.name]!"))
	else
		to_chat(preferences.parent.mob, span_warning("У вас недостаточно свободных очков лодаута, чтобы взять [selected_item.name]!"))

// Removes donator_level items from the user if their donator_level is insufficient
/datum/preference/loadout/deserialize(input, datum/preferences/preferences)
	. = ..()
	// For loadout purposes, donator_level is updated in middleware on select
	var/donator_level = preferences.parent.donator_level
	var/removed_items = list()
	var/client/afflicted_client = preferences.parent
	for(var/path in .)
		var/datum/loadout_item/item = GLOB.all_loadout_datums[path]
		if(donator_level >= item.donator_level && afflicted_client.loadout_points >= item.cost)
			afflicted_client.loadout_points -= item.cost
			continue
		. -= path
		removed_items += item.name
	if(length(removed_items) && preferences.parent.mob)
		to_chat(preferences.parent.mob, span_warning("У вас недостаточный уровень доната или очков, чтобы взять: [english_list(removed_items, and_text = " и ")]!"))
