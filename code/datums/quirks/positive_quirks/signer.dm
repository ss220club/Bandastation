/datum/quirk/item_quirk/signer
	name = "Signer"
	desc = "Вы обладаете отличными навыками общения на языке жестов."
	icon = FA_ICON_HANDS
	value = 4
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	medical_record_text = "Пациент может общаться на языке жестов."
	mail_goodies = list(/obj/item/clothing/gloves/radio)

/datum/quirk/item_quirk/signer/add_unique(client/client_source)
	quirk_holder.AddComponent(/datum/component/sign_language)
	var/obj/item/clothing/gloves/gloves_type = /obj/item/clothing/gloves/radio
	if(isplasmaman(quirk_holder))
		gloves_type = /obj/item/clothing/gloves/color/plasmaman/radio
	give_item_to_holder(gloves_type, list(LOCATION_GLOVES = ITEM_SLOT_GLOVES, LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/signer/remove()
	qdel(quirk_holder.GetComponent(/datum/component/sign_language))
