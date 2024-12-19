/datum/id_trim/job/nanotrasen_representative
	assignment = JOB_NANOTRASEN_REPRESENTATIVE
	trim_icon = 'modular_bandastation/jobs/icons/obj/card.dmi'
	trim_state = "trim_nanotrasen_representative"
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_CENTCOM_BLUE
	sechud_icon_state = SECHUD_NANOTRASEN_REPRESENTATIVE
	extra_access = list(
		ACCESS_BRIG,
		ACCESS_CARGO,
		ACCESS_COURT,
		ACCESS_GATEWAY,
	)
	minimal_access = list(
		ACCESS_SECURITY,
		ACCESS_ALL_PERSONAL_LOCKERS,
		ACCESS_BRIG_ENTRANCE,
		ACCESS_BLUESHIELD,
		ACCESS_NANOTRASEN_REPRESENTATIVE,
		ACCESS_COMMAND,
		ACCESS_CONSTRUCTION,
		ACCESS_ENGINEERING,
		ACCESS_EVA,
		ACCESS_MAINT_TUNNELS,
		ACCESS_MEDICAL,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_SCIENCE,
		ACCESS_TELEPORTER,
		ACCESS_WEAPONS,
	)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS
	)
	job = /datum/job/nanotrasen_representative
	big_pointer = TRUE
	pointer_color = COLOR_CENTCOM_BLUE
