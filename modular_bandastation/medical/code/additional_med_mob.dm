/mob/proc/add_additional_med_component()
	return

/mob/living/carbon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/additional_med)
