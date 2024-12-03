// Syndicate Central Command
/datum/outfit/syndicate/central_command
	name = "Syndicate Officer"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/jacket/trenchcoat
	gloves = /obj/item/clothing/gloves/combat
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id/advanced/black/syndicate_central_command
	mask = /obj/item/cigarette/cigar
	tc = 1000
	command_radio = TRUE
	backpack_contents = list(
		/obj/item/gun/ballistic/automatic/smartgun = 1,
		/obj/item/ammo_box/magazine/smartgun = 2,
	)

/datum/outfit/syndicate/central_command/agent
	name = "Syndicate Officer - Special Agent"
	uniform = /obj/item/clothing/under/suit/black_really
	suit = null
	shoes = /obj/item/clothing/shoes/laceup
	neck = /obj/item/clothing/neck/chameleon
	l_pocket = /obj/item/modular_computer/pda/assistant
	id = /obj/item/card/id/advanced/chameleon
	tc = 100
	command_radio = FALSE
	backpack_contents = list(
		/obj/item/storage/box/syndie_kit/chameleon = 1,
	)

// Outfit-related stuff
/datum/id_trim/syndiofficer
	assignment = "Syndicate Officer"
	trim_state = "trim_syndicate"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED
	sechud_icon_state = SECHUD_SYNDICATE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER, ACCESS_SYNDICATE_COMMAND)
	threat_modifier = 5
	big_pointer = TRUE
	pointer_color = COLOR_SYNDIE_RED

/obj/item/card/id/advanced/black/syndicate_central_command
	name = "syndicate command ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	registered_age = null
	trim = /datum/id_trim/syndiofficer
	wildcard_slots = WILDCARD_LIMIT_SYNDICATE
