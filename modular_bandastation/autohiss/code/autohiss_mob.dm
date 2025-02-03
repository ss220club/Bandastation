/mob/proc/get_effecting_speechmods()
	var/list/datum/component/speechmod/speechmod_components = list()
	SEND_SIGNAL(src, COMSIG_MOB_GET_AFFECTING_SPEECHMODS, speechmod_components)
	return speechmod_components

/mob/proc/toggle_speechmods()
	set category = "IC"
	set name = "Переключить модификатор речи"
	set desc = "Даёт возможность переключить модификатор речи"

	var/list/datum/component/speechmod/speechmod_components = get_effecting_speechmods()
	// Assoc list - ["parent name" = /datum/speechmod]
	var/list/toggleable_speechmods = list()
	for(var/datum/component/speechmod/speechmod as anything in speechmod_components)
		if(speechmod.toggleable)
			toggleable_speechmods["[capitalize(speechmod.get_parent_name())]"] = speechmod
	if(!length(toggleable_speechmods))
		to_chat(src, span_warning("Нет модификаторов речи доступных для переключения!"))
		return
	// So we don't make player choose, when only 1 option is available
	if(length(toggleable_speechmods) == 1)
		mind.toggle_speechmode(toggleable_speechmods["[toggleable_speechmods[1]]"])
		return
	var/speechmod_parent = tgui_input_list(src, "Выберите, где нужно переключить модификатор речи.", "Переключить модификтор речи.", toggleable_speechmods)
	if(isnull(speechmod_parent))
		return
	mind.toggle_speechmode(toggleable_speechmods[speechmod_parent])
