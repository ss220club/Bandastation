#define CRYO_JOIN "CRYO_JOIN"
#define CRYO_LEAVE "CRYO_LEAVE"

/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */
GLOBAL_LIST_EMPTY(cryopod_computers)

GLOBAL_LIST_EMPTY(ghost_records)

/// A list of all cryopods that aren't quiet, to be used by the "Send to Cryogenic Storage" VV action.
GLOBAL_LIST_EMPTY(valid_cryopods)

//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "Интерфейс для взаимодействия экипажа с системами контроля криогенного хранилища."
	icon = 'modular_bandastation/cryosleep/icons/cryogenics.dmi'
	icon_state = "cellconsole_1"
	icon_keyboard = null
	icon_screen = null
	use_power = FALSE
	density = FALSE
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE
	req_one_access = list(ACCESS_COMMAND, ACCESS_ARMORY) // Heads of staff or the warden can go here to claim recover items from their department that people went were cryodormed with.
	verb_say = "coldly states"
	verb_ask = "queries"
	verb_exclaim = "alarms"

	/// Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	/// The items currently stored in the cryopod control panel.
	var/list/frozen_item = list()

	/// This is what the announcement system uses to make announcements. Make sure to set a radio that has the channel you want to broadcast on.
	var/obj/item/radio/headset/radio = /obj/item/radio/headset/silicon/ai
	/// The channel to be broadcast on, valid values are the values of any of the "RADIO_CHANNEL_" defines.
	var/announcement_channel = null // RADIO_CHANNEL_COMMON doesn't work here.

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/computer/cryopod, 32)

/obj/machinery/computer/cryopod/Initialize(mapload)
	. = ..()
	GLOB.cryopod_computers += src
	radio = new radio(src)

/obj/machinery/computer/cryopod/Destroy()
	GLOB.cryopod_computers -= src
	QDEL_NULL(radio)
	return ..()

/obj/machinery/computer/cryopod/update_icon_state()
	if(machine_stat & (NOPOWER|BROKEN))
		icon_state = "cellconsole"
		return ..()
	icon_state = "cellconsole_1"
	return ..()

/obj/machinery/computer/cryopod/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	add_fingerprint(user)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CryopodConsole", name)
		ui.open()

/obj/machinery/computer/cryopod/ui_data(mob/user)
	var/list/data = list()
	data["frozen_crew"] = frozen_crew

	/// The list of references to the stored items.
	var/list/item_ref_list = list()
	/// The associative list of the reference to an item and its name.
	var/list/item_ref_name = list()

	for(var/obj/item/item in frozen_item)
		var/ref = REF(item)
		item_ref_list += ref
		item_ref_name[ref] = item.declent_ru(NOMINATIVE)

	data["item_ref_list"] = item_ref_list
	data["item_ref_name"] = item_ref_name

	// Check Access for item dropping.
	var/item_retrieval_allowed = allowed(user)
	data["item_retrieval_allowed"] = item_retrieval_allowed

	var/obj/item/card/id/id_card
	if(isliving(user))
		var/mob/living/person = user
		id_card = person.get_idcard()
	if(id_card?.registered_name)
		data["account_name"] = id_card.registered_name

	return data

/obj/machinery/computer/cryopod/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("item_get")
			// This is using references, kinda clever, not gonna lie. Good work Zephyr
			var/item_get = params["item_get"]
			var/obj/item/item = locate(item_get)
			if(item in frozen_item)
				item.forceMove(drop_location())
				frozen_item.Remove(item_get, item)
				visible_message("[capitalize(declent_ru(NOMINATIVE))] выдаёт [item.declent_ru(NOMINATIVE)].")
				message_admins("[item] was retrieved from cryostorage at [ADMIN_COORDJMP(src)]")
			else
				CRASH("Invalid REF# for ui_act. Not inside internal list!")
			return TRUE

		else
			CRASH("Illegal action for ui_act: '[action]'")

/obj/machinery/computer/cryopod/proc/announce(message_type, user, rank, occupant_departments_bitflags, occupant_job_radio, occupant_gender)
	switch(message_type)
		if(CRYO_JOIN)
			radio.talk_into(src, "[user][rank ? ", [rank]," : ""] пробудил[genderize_ru(occupant_gender, "ся", "ась", "ось", "ись")] из криогенного хранилища.", announcement_channel)
		if(CRYO_LEAVE)
			if(occupant_job_radio)
				if(occupant_departments_bitflags & DEPARTMENT_BITFLAG_COMMAND)
					if(occupant_job_radio != RADIO_CHANNEL_COMMAND)
						radio.talk_into(src, "[user][rank ? ", [rank]," : ""] был[genderize_ru(occupant_gender, "", "а", "о", "и")] перемещ[genderize_ru(occupant_gender, "ён", "ена", "ено", "ены")] в криогенное хранилище.", RADIO_CHANNEL_COMMAND)
					radio.use_command = TRUE
				radio.talk_into(src, "[user][rank ? ", [rank]," : ""] был[genderize_ru(occupant_gender, "", "а", "о", "и")] перемещ[genderize_ru(occupant_gender, "ён", "ена", "ено", "ены")] в криогенное хранилище.", occupant_job_radio)
				radio.use_command = FALSE
			radio.talk_into(src, "[user][rank ? ", [rank]," : ""] был[genderize_ru(occupant_gender, "", "а", "о", "и")] перемещ[genderize_ru(occupant_gender, "ён", "ена", "ено", "ены")] в криогенное хранилище.", announcement_channel)

#undef CRYO_JOIN
#undef CRYO_LEAVE
