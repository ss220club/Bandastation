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
	icon_state = "animal"
	default_priority = 90

/datum/language_holder/vulpkanin
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/canilunzt = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/canilunzt = list(LANGUAGE_ATOM),
	)
