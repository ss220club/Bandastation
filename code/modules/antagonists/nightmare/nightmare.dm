/datum/antagonist/nightmare
	name = "\improper Nightmare"
	antagpanel_category = ANTAG_GROUP_ABOMINATIONS
	job_rank = ROLE_NIGHTMARE
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	ui_name = "AntagInfoNightmare"
	suicide_cry = "FOR THE DARKNESS!!"
	preview_outfit = /datum/outfit/nightmare

/datum/antagonist/nightmare/greet()
	. = ..()
	owner.announce_objectives()

/datum/antagonist/nightmare/on_gain()
	forge_objectives()
	. = ..()

/datum/outfit/nightmare
	name = "Nightmare (Preview only)"

/datum/outfit/nightmare/post_equip(mob/living/carbon/human/human, visuals_only)
	human.set_species(/datum/species/shadow/nightmare)

/datum/objective/nightmare_fluff

/datum/objective/nightmare_fluff/New()
	var/list/explanation_texts = list(
		"Поглотите последний проблеск света с космической станции.",
		"Несите суд на дневных ходоков.",
		"Погасите пламя этого адского пейзажа.",
		"Раскройте истинную природу теней.",
		"Из теней все погибнут.",
		"Создайте ночь с помощью клинка или пламени.",
		"Принесите тьму к свету."
	)
	explanation_text = pick(explanation_texts)
	..()

/datum/objective/nightmare_fluff/check_completion()
	return owner.current.stat != DEAD

/datum/antagonist/nightmare/forge_objectives()
	var/datum/objective/nightmare_fluff/objective = new
	objective.owner = owner
	objectives += objective
