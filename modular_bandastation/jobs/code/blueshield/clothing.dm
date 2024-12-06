/obj/item/clothing/head/helmet/space/plasmaman/blueshield
	name = "blueshield envirosuit helmet"
	desc = "A plasmaman containment helmet designed for certified blueshields, who's job guarding heads should not include self-combustion... most of the time."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/plasmaman_hats.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/plasmaman_head.dmi'
	icon_state = "blueshield_envirohelm"
	armor_type = /datum/armor/suit_armor

/obj/item/clothing/under/plasmaman/blueshield
	name = "blueshield envirosuit"
	desc = "A plasmaman containment suit designed for certified blueshields, offering a limited amount of extra protection."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/plasmaman.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/plasmaman.dmi'
	icon_state = "blueshield_envirosuit"
	armor_type = /datum/armor/clothing_under/under_plasmaman_blueshield
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/datum/armor/clothing_under/under_plasmaman_blueshield
	melee = 10
	bio = 100
	fire = 95
	acid = 95

/obj/item/clothing/head/beret/blueshield
	name = "blueshield's beret"
	desc = "A blue beret made of durathread with a genuine golden badge, denoting its owner as a Blueshield Lieuteneant. It seems to be padded with nano-kevlar, making it tougher than standard reinforced berets."
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#3A4E7D#DEB63D"
	icon_state = "beret_badge"
	armor_type = /datum/armor/suit_armor

/obj/item/clothing/head/beret/blueshield/navy
	name = "navy blueshield's beret"
	desc = "A navy-blue beret made of durathread with a silver badge, denoting its owner as a Blueshield Lieuteneant. It seems to be padded with nano-kevlar, making it tougher than standard reinforced berets."
	greyscale_colors = "#3C485A#BBBBBB"

/obj/item/storage/backpack/blueshield
	name = "blueshield backpack"
	desc = "A robust backpack issued to Nanotrasen's finest."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/backpacks.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/back.dmi'
	lefthand_file = 'modular_bandastation/jobs/icons/blueshield/mob/backpack_lefthand.dmi'
	righthand_file = 'modular_bandastation/jobs/icons/blueshield/mob/backpack_righthand.dmi'
	icon_state = "backpack_blueshield"
	inhand_icon_state = "backpack_blueshield"

/obj/item/storage/backpack/satchel/blueshield
	name = "blueshield satchel"
	desc = "A robust satchel issued to Nanotrasen's finest."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/backpacks.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/back.dmi'
	lefthand_file = 'modular_bandastation/jobs/icons/blueshield/mob/backpack_lefthand.dmi'
	righthand_file = 'modular_bandastation/jobs/icons/blueshield/mob/backpack_righthand.dmi'
	icon_state = "satchel_blueshield"
	inhand_icon_state = "satchel_blueshield"

/obj/item/storage/backpack/duffelbag/blueshield
	name = "blueshield duffelbag"
	desc = "A robust duffelbag issued to Nanotrasen's finest."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/backpacks.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/back.dmi'
	lefthand_file = 'modular_bandastation/jobs/icons/blueshield/mob/backpack_lefthand.dmi'
	righthand_file = 'modular_bandastation/jobs/icons/blueshield/mob/backpack_righthand.dmi'
	icon_state = "duffel_blueshield"
	inhand_icon_state = "duffel_blueshield"

/obj/item/clothing/suit/armor/vest/blueshield
	name = "blueshield's armor"
	desc = "A tight-fitting kevlar-lined vest with a blue badge on the chest of it."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/armor.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/armor.dmi'
	icon_state = "blueshield_armor"
	body_parts_covered = CHEST
	unique_reskin = list(
		"Slim" = "blueshield_armor",
		"Marine" = "blueshield_marine",
		"Bulky" = "vest_black"
	)

/obj/item/clothing/suit/armor/vest/blueshield_jacket
	name = "blueshield's jacket"
	desc = "An expensive kevlar-lined jacket with a golden badge on the chest and \"NT\" emblazoned on the back. It weighs surprisingly little, despite how heavy it looks."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/armor.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/armor.dmi'
	icon_state = "blueshield"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/armor/vest/blueshield_jacket/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/hooded/wintercoat/blueshield
	name = "blueshield's winter coat"
	desc = "A comfy kevlar-lined coat with blue highlights, fit to keep the blueshield armored and warm."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/wintercoat.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/wintercoat.dmi'
	icon_state = "coat_blueshield"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/blueshield
	armor_type = /datum/armor/suit_armor

/obj/item/clothing/suit/hooded/wintercoat/blueshield/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_wintercoat_allowed

/obj/item/clothing/head/hooded/winterhood/blueshield
	desc = "A comfy kevlar-lined hood to go with the comfy kevlar-lined coat."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/winterhood.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/winterhood.dmi'
	icon_state = "hood_blueshield"
	armor_type = /datum/armor/suit_armor

/obj/item/clothing/under/rank/blueshield
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/command.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/command.dmi'
	name = "blueshield's suit"
	desc = "A classic bodyguard's suit, with custom-fitted Blueshield-Blue cuffs and a Nanotrasen insignia over one of the pockets."
	icon_state = "blueshield"
	strip_delay = 50
	armor_type = /datum/armor/clothing_under/rank_blueshield
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	alt_covers_chest = TRUE

/datum/armor/clothing_under/rank_blueshield
	melee = 10
	bullet = 5
	laser = 5
	energy = 10
	bomb = 10
	fire = 50
	acid = 50

/obj/item/clothing/under/rank/blueshield/skirt
	name = "blueshield's suitskirt"
	desc = "A classic bodyguard's suitskirt, with custom-fitted Blueshield-Blue cuffs and a Nanotrasen insignia over one of the pockets."
	icon_state = "blueshield_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/blueshield/turtleneck
	name = "blueshield's turtleneck"
	desc = "A tactical jumper fit for only the best of bodyguards, with plenty of tactical pockets for your tactical needs."
	icon_state = "blueshield_turtleneck"

/obj/item/clothing/under/rank/blueshield/turtleneck/skirt
	name = "blueshield's skirtleneck"
	desc = "A tactical jumper fit for only the best of bodyguards - instead of tactical pockets, this one has a tactical lack of leg protection."
	icon_state = "blueshield_skirtleneck"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/neck/cloak/blueshield
	name = "blueshield's cloak"
	desc = "A cloak fit for only the best of bodyguards."
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/neck.dmi'
	worn_icon = 'modular_bandastation/jobs/icons/blueshield/mob/neck.dmi'
	icon_state = "blueshield_cloak"

/obj/item/radio/headset/blueshield
	name = "blueshield's headset"
	desc = "The headset of the guy who keeps the administration alive."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/blueshield
	keyslot2 = /obj/item/encryptionkey/headset_cent

/obj/item/radio/headset/blueshield/alt
	name = "blueshield's bowman headset"
	desc = "The headset of the guy who keeps the administration alive. Protects your ears from flashbangs."
	icon_state = "com_headset_alt"
	worn_icon_state = "com_headset_alt"

/obj/item/radio/headset/blueshield/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
