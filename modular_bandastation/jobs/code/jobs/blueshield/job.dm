/datum/job/blueshield
	title = "Офицер «Синий щит»"
	description = "Персональная охрана глав"
	department_head = list("Центральное командование")
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_STATION
	total_positions = 0
	spawn_positions = 0
	supervisors = "Представитель НаноТрейзен и центральное командование"
	minimal_player_age = 30
	exp_requirements = 1500
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "BLUESHIELD"

	outfit = /datum/outfit/job/blueshield
	plasmaman_outfit = /datum/outfit/plasmaman/blueshield

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_PRETENDER_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_BLUESHIELD
	bounty_types = CIV_JOB_SEC
	departments_list = list(
		/datum/job_department/nanotrasen_representation,
		/datum/job_department/security
	)

	family_heirlooms = list(/obj/item/bedsheet/captain, /obj/item/clothing/head/beret/blueshield)

	mail_goodies = list(
		/obj/item/storage/fancy/cigarettes/cigars/havana = 10,
		/obj/item/stack/spacecash/c500 = 3,
		/obj/item/disk/nuclear/fake/obvious = 2,
		/obj/item/clothing/head/collectable/captain = 4,
	)

	rpg_title = "Guard"
	job_flags = STATION_JOB_FLAGS | JOB_BOLD_SELECT_TEXT | JOB_CANNOT_OPEN_SLOTS

/datum/outfit/job/blueshield
	name = "Blueshield"

	jobtype = /datum/job/blueshield
	uniform = /obj/item/clothing/under/rank/blueshield
	suit = /obj/item/clothing/suit/armor/vest/blueshield_jacket
	gloves = /obj/item/clothing/gloves/tackler/combat
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/job/blueshield
	shoes = /obj/item/clothing/shoes/jackboots
	ears = /obj/item/radio/headset/blueshield/alt
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	implants = list(/obj/item/implant/mindshield)

	backpack = /obj/item/storage/backpack/blueshield
	satchel = /obj/item/storage/backpack/satchel/blueshield
	duffelbag = /obj/item/storage/backpack/duffelbag/blueshield

	head = /obj/item/clothing/head/beret/blueshield
	box = /obj/item/storage/box/survival/security
	l_pocket = /obj/item/modular_computer/pda/heads/blueshield

/datum/outfit/plasmaman/blueshield
	name = "Blueshield Plasmaman"
	head = /obj/item/clothing/head/helmet/space/plasmaman/blueshield
	uniform = /obj/item/clothing/under/plasmaman/blueshield

/obj/item/modular_computer/pda/heads/blueshield
	name = "blueshield PDA"
	greyscale_colors = "#0000cc#EA3232"
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/robocontrol,
	)
