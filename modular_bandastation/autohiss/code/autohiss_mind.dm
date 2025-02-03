/datum/mind
	/// Assoc list of types which the mind will prevent from using speechmod. list(type = "name")
	var/list/disabled_speechmode_parent_types = list()

/datum/mind/proc/toggle_speechmode(datum/component/speechmod/speechmod)
	var/speechmod_name = speechmod.get_parent_name()
	if(disabled_speechmode_parent_types[speechmod.parent.type])
		disabled_speechmode_parent_types -= speechmod.parent.type
		to_chat(src, span_notice("Автошипение включено для: [speechmod_name]."))
		return
	disabled_speechmode_parent_types += list(speechmod.parent.type = speechmod_name)
	to_chat(src, span_notice("Автошипение отключено для: [speechmod_name]."))
