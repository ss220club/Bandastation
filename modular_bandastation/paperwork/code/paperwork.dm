GLOBAL_LIST_INIT_TYPED(paper_replacements, /datum/paper_replacement, init_paper_replacements())

/proc/init_paper_replacements()
	var/list/paper_replacements = list()
	for(var/paper_replacement_type in subtypesof(/datum/paper_replacement))
		var/datum/paper_replacement/paper_replacement = new paper_replacement_type()
		paper_replacements[paper_replacement.key] = paper_replacement
	return paper_replacements

/datum/paper_replacement
	var/key = null
	var/name = "Undentified"

/datum/paper_replacement/proc/get_replacement(mob/user)
	CRASH("Paper replacement get_replacement not implemented.")

/datum/paper_replacement/sign
	key = "sign"
	name = "Подпись"

/datum/paper_replacement/sign/get_replacement(mob/user)
	return "<span style='font: [SIGNATURE_FONT]'>[user.real_name]</span>"

/datum/paper_replacement/time
	key = "time"
	name = "Текущее время"

/datum/paper_replacement/time/get_replacement(mob/user)
	return station_time_timestamp()

/datum/paper_replacement/date
	key = "date"
	name = "Текущая дата"

/datum/paper_replacement/date/get_replacement(mob/user)
	return "[time2text(world.timeofday, "DD/MM")]/[CURRENT_STATION_YEAR]"

/datum/paper_replacement/station_name
	key = "station_name"
	name = "Название станции"

/datum/paper_replacement/station_name/get_replacement(mob/user)
	return station_name()

/datum/paper_replacement/account_number
	key = "account_number"
	name = "Номер счета"

/datum/paper_replacement/account_number/get_replacement(mob/user)
	if(!iscarbon(user))
		return "unknown"

	var/mob/living/carbon/human/account_owner = user
	return account_owner.account_id
