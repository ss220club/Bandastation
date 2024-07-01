/datum/component/additional_med
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/is_cpred = FALSE

/datum/component/additional_med/Initialize(...)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/additional_med/proc/set_e_cpr(value)
	is_cpred = value
