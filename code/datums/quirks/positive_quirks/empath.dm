/datum/quirk/empath
	name = "Empath"
	desc = "Будь то шестое чувство или тщательное изучение языка тела, вам достаточно одного взгляда на человека, чтобы понять, что он чувствует."
	icon = FA_ICON_SMILE_BEAM
	value = 8
	mob_trait = TRAIT_EMPATH
	gain_text = span_notice("Вы чувствуете единение с окружающими вас людьми.")
	lose_text = span_danger("Вы чувствуете себя отстраненным от окружающих вас людей")
	medical_record_text = "Пациент очень восприимчив и чувствителен к социальным сигналам, возможно, у него есть ESP. Необходимо дальнейшее тестирование."
	mail_goodies = list(/obj/item/toy/foamfinger)
