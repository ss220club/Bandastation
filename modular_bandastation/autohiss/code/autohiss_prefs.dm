/datum/preference/toggle/autohiss_enabled
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "autohiss_enabled"
	savefile_identifier = PREFERENCE_CHARACTER
	default_value = TRUE

/datum/preference/toggle/autohiss_enabled/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/datum/species/specie = preferences.read_preference(/datum/preference/choiced/species)
	return specie.mutanttongue?.modifies_speech

/datum/preference/toggle/autohiss_enabled/apply_to_human(mob/living/carbon/human/target, value)
	if(value)
		return
	RegisterSignal(target, COMSIG_MOB_MIND_TRANSFERRED_INTO, PROC_REF(on_mind_transfer), override = TRUE)

/datum/preference/toggle/autohiss_enabled/proc/on_mind_transfer(mob/living/carbon/human/current_mob, mob/previous_mob)
	SIGNAL_HANDLER

	var/list/datum/component/speechmod/speechmod_components = list()
	SEND_SIGNAL(current_mob, COMSIG_MOB_GET_AFFECTING_SPEECHMODS, speechmod_components)
	for(var/datum/component/speechmod/speechmod as anything in speechmod_components)
		current_mob.mind.toggle_speechmode(speechmod)
	UnregisterSignal(current_mob, COMSIG_MOB_MIND_TRANSFERRED_INTO)
