/obj/item/encryptionkey/heads/blueshield
	name = "blueshield's encryption key"
	icon_state = "cypherkey_centcom"
	channels = list(RADIO_CHANNEL_COMMAND = 1, RADIO_CHANNEL_SECURITY = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_centcom
	greyscale_colors = "#1d2657#dca01b"

/obj/item/radio/headset/blueshield
	name = "blueshield's headset"
	desc = "The headset of the guy who keeps the administration alive."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/blueshield

/obj/item/radio/headset/blueshield/alt
	name = "blueshield's bowman headset"
	desc = "The headset of the guy who keeps the administration alive. Protects your ears from flashbangs."
	icon_state = "com_headset_alt"
	worn_icon_state = "com_headset_alt"

/obj/item/radio/headset/blueshield/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
