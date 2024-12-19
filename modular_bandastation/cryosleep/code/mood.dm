/datum/mood_event/tucked_in
	description = "Я чувствую себя лучше, уложив кого-то отдохнуть на ночь!"
	mood_change = 3
	timeout = 2 MINUTES

/datum/mood_event/tucked_in/add_effects(mob/living/tuckee)
	if(!tuckee)
		return
	description = "Я чувствую себя лучше, уложив [tuckee.declent_ru(ACCUSATIVE)] отдохнуть на ночь!"
