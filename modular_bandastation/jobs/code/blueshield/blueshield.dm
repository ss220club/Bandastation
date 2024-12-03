/datum/job/blueshield
	title = "Офицер «Синий щит»"
	description = "Персональная охрана глав"
	department_head = list("Центральное Командование")
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "НаноТрейзен и Космозакон"
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "BLUESHIELD"

	outfit = /datum/outfit/job/blueshield
	plasmaman_outfit = /datum/outfit/plasmaman/blueshield

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	family_heirlooms = list()
	mail_goodies = list()

	job_flags = STATION_JOB_FLAGS | JOB_BOLD_SELECT_TEXT | JOB_CANNOT_OPEN_SLOTS
	rpg_title = "Star Marine"

/datum/outfit/job/blueshield
	name = "Blueshield"
	jobtype = /datum/job/blueshield

	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/job/blueshield
	uniform = /obj/item/clothing/under/rank/blueshield
	suit = /obj/item/clothing/suit/armor/vest/blueshield
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/radio/headset/heads/blueshield/alt
	glasses = /obj/item/clothing/glasses/hud/health/sunglasses
	id = /obj/item/card/id/blueshield
	pda = /obj/item/pda/heads/blueshield
	backpack_contents = list(
		/obj/item/storage/box/deathimp = 1,
		/obj/item/gun/energy/gun/blueshield = 1
	)
	bio_chips = list(/obj/item/bio_chip/mindshield)
	backpack = /obj/item/storage/backpack/blueshield
	satchel = /obj/item/storage/backpack/satchel_blueshield
	dufflebag = /obj/item/storage/backpack/duffel/blueshield
