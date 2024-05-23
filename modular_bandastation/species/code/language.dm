// Язык вульпкан

/datum/language/canilunzt
	name = "Канилунц"
	desc = "Основной разговорный язык вульпканинов."
	key = "7"
	flags = TONGUELESS_SPEECH
	space_chance = 60
	syllables = list("rur","ya","cen","rawr","bar","kuk","tek","qat","uk","wu","vuh","tah","tch","schz","auch", \
	"ist","ein","entch","zwichs","tut","mir","wo","bis","es","vor","nic","gro","lll","enem","zandt","tzch","noch", \
	"hel","ischt","far","wa","baram","iereng","tech","lach","sam","mak","lich","gen","or","ag","eck","gec","stag","onn", \
	"bin","ket","jarl","vulf","einech","cresthz","azunein","ghzth")
	icon = 'modular_bandastation/species/icons/mob/species/vulpkanin/lang.dmi'
	icon_state = "vulptail"
	default_priority = 90

/datum/language/canilunzt/get_random_name(
	gender = NEUTER,
	name_count = default_name_count,
	syllable_min = default_name_syllable_min,
	syllable_max = default_name_syllable_max,
	force_use_syllables = FALSE,
)
	if(force_use_syllables)
		return ..()
	if(gender != MALE)
		gender = pick(MALE, FEMALE)

	if(gender == MALE)
		return "[pick(GLOB.first_names_male_vulp)][random_name_spacer][pick(GLOB.last_names_vulp)]"
	return "[pick(GLOB.first_names_female_vulp)][random_name_spacer][pick(GLOB.last_names_vulp)]"

/datum/language_holder/vulpkanin
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/canilunzt = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/canilunzt = list(LANGUAGE_ATOM),
	)
