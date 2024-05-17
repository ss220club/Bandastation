/datum/species/vulpkanin
	name = "\improper Vulpkanin"
	plural_form = "Vulpkans"
	id = SPECIES_VULPKANIN
	inherent_traits = list(
		TRAIT_MUTANT_COLORS
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT

	species_language_holder = /datum/language_holder/vulpkanin
	mutanttongue = /obj/item/organ/internal/tongue/vulpkanin
	mutantstomach = /obj/item/organ/internal/stomach/vulpkanin
	external_organs = list(
		/obj/item/organ/external/tail/vulpkanin = "Default",
	)

	mutant_bodyparts = list(
		"wings" = "None",
		"vulpkanin_body_markings" = "None",
		"vulpkanin_head_markings" = "None",
		"vulpkanin_head_accessories" = "None",
		"vulpkanin_facial_hair" = "None",
		"vulpkanin_tail_markings" = "None",
		"hair" = "Bald",
	)

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/vulpkanin,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/vulpkanin,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/vulpkanin,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/vulpkanin,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/vulpkanin,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/vulpkanin,
	)

	coldmod = 0.8
	heatmod = 1.2
	stunmod = 0.9
	bodytemp_heat_damage_limit = BODYTEMP_HEAT_DAMAGE_LIMIT - 15
	bodytemp_cold_damage_limit = BODYTEMP_COLD_DAMAGE_LIMIT - 15

/datum/species/vulpkanin/prepare_human_for_preview(mob/living/carbon/human/vulpkanin)
	vulpkanin.set_haircolor("#bb9966", update = FALSE) // brown
	vulpkanin.set_hairstyle("Bald", update = TRUE)
	vulpkanin.dna.features["mcolor"] = "#FFFFD5"
	vulpkanin.update_body(is_creating = TRUE)

/datum/species/vulpkanin/check_roundstart_eligible()
	return TRUE

/datum/species/vulpkanin/get_physical_attributes()
	return "Вульпканины - двуногие гуманоиды собакоподобные покрытые шерстью, ростом от 140 до 180 см и весом до 60 кг. \
	Их скелет легкий и прочный, а череп особенно прочно соединен с позвоночником. \
	У них глубоко расположенный речевой аппарат, длинный язык, паутинообразная грудная клетка, длинные пальцы с острыми \
	когтями, длинные задние конечности для ходьбы и бега, хвост для равновесия и невербального общения. \
	Их шерсть мягкая, хорошо сохраняет тепло, но уязвима к высоким температурам и химическим веществам."

/datum/species/vulpkanin/get_species_description()
	return "Вульпканины происходят с планеты Альтам, которая долгое время находится в стадии кровопролитной войны трёх доминирующих кланов, \
	которые пытаются установить на планете единый режим и привести расу вульпканинов к процветанию."

/datum/species/vulpkanin/get_species_lore()
	return list(
		"Альтам, родина вульпканинов, представляет собой мир, где горы, покрытые снегом, устремляются к небесам, а ниже расстилаются холодные пустыни. \
		Температура здесь редко поднимается выше одного градуса, создавая пейзаж вечного прохладного уединения. \
		В мире Альтама растения хитроумно сохраняют влагу под восковыми листьями, расцветая в короткую весну и оживляя холодные пустыни яркими красками. \
		Вульпканины гармонично вписываются в этот мир. Их мягкая шерсть и стальные мышцы помогают противостоять холоду.",

		"В силу того, что вульпкане окончательно не оформились в единственное государство, они представляют из себя децентрализованное скопление кланов, находящихся на своей родной планете Альтам. \
		Интересы расы во внешней политике не представляют из себя ничего. Вульпканины погружены в распри и кровопролитные войны на своей планете. \
		Сотни тысяч беженцев-вульпканинов заполонили всю галактику; те, кто хочет мира своей нации, бегут от войны, им чужды идеи их соплеменников, из-за чего оставшиеся на Альтаме вульпканины буквально ненавидят кочующих собратьев.",

		"Культура вульпканинов - это небогатое, но многообразное наследие, которое развивается в условиях войны и поиске единства на Альтаме. \
		На протяжении всей войны вульпканинская культура потеряла многие кланы, племена и народности. \
		Вульпканины продолжают бороться между собой за единство и мирную жизнь на планете Альтам, стремясь достичь процветания и равновесия для своей расы.",

		"Представители расы вульпканинов являются отличными разнорабочими, которые без особых проблем выполняют свои обязанности - от уборщика до наёмника. \
		В частности, представители кланов - это относительно дешёвая рабочая сила, неприхотливая в быту и пище, готовая работать за скромную плату. \
		Практически все члены кланов отправляют часть заработанных средств своему родному клану. \
		Что касается беженцев, то они не особо проявляют активность, например, на политическом поприще.",
	)

/datum/species/vulpkanin/randomize_features()
	var/list/features = ..()
	//features["body_mvulpkanin_body_markingsarkings"] = pick(GLOB.vulpkanin_body_markings_list)
	features["tail_vulpkanin"] = pick(GLOB.tails_list_vulpkanin)
	return features

/mob/living/carbon/human/species/vulpkanin
	race = /datum/species/vulpkanin
