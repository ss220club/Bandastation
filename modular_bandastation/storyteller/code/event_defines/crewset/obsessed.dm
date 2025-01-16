/datum/round_event_control/antagonist/solo/obsessed
	antag_flag = ROLE_OBSESSED
	tags = list(TAG_COMBAT)
	antag_datum // потому-что антаг выдается через событие
	typepath = /datum/round_event/obsessed
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		ROLE_POSITRONIC_BRAIN,
	)
	weight = 4
	max_occurrences = 3

/datum/round_event_control/antagonist/solo/obsessed/midround
	name = "Compulsive Obsession"
	prompted_picking = FALSE
	maximum_antags = 4

