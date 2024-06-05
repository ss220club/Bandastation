/datum/species/vulpkanin
	name = "\improper Вульпканин"
	plural_form = "Вульпкане"
	id = SPECIES_VULPKANIN
	inherent_traits = list(
		TRAIT_MUTANT_COLORS
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT

	species_language_holder = /datum/language_holder/vulpkanin

	mutantbrain = /obj/item/organ/internal/brain/vulpkanin
	mutantheart = /obj/item/organ/internal/heart/vulpkanin
	mutantlungs = /obj/item/organ/internal/lungs/vulpkanin
	mutanteyes = /obj/item/organ/internal/eyes/vulpkanin
	mutantears = /obj/item/organ/internal/ears/vulpkanin
	mutanttongue = /obj/item/organ/internal/tongue/vulpkanin
	mutantliver = /obj/item/organ/internal/liver/vulpkanin
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
	)

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/vulpkanin,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/vulpkanin,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/vulpkanin,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/vulpkanin,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/vulpkanin,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/vulpkanin,
	)

	payday_modifier = 0.8
	bodytemp_heat_damage_limit = BODYTEMP_HEAT_DAMAGE_LIMIT + 30
	bodytemp_cold_damage_limit = BODYTEMP_COLD_DAMAGE_LIMIT - 60

/datum/species/vulpkanin/prepare_human_for_preview(mob/living/carbon/human/vulpkanin)
	vulpkanin.set_haircolor("#A26324", update = FALSE) // brown
	vulpkanin.set_hairstyle("Jagged", update = TRUE)
	vulpkanin.dna.features["mcolor"] = "#D69E67"
	vulpkanin.dna.features["vulpkanin_head_accessories"] = "Vulpkanin Earfluff"
	vulpkanin.set_vulpkanin_head_accessories_color("#FFCBDB", update = FALSE)
	vulpkanin.update_body(is_creating = TRUE)

/datum/species/vulpkanin/randomize_features()
	var/list/features = ..()
	features["vulpkanin_body_markings"] = pick(SSaccessories.vulpkanin_body_markings_list)
	features["vulpkanin_head_markings"] = pick(SSaccessories.vulpkanin_head_markings_list)
	features["vulpkanin_head_accessories"] = pick(SSaccessories.vulpkanin_head_accessories_list)
	features["tail_markings"] = pick(SSaccessories.vulpkanin_tail_markings_list)
	features["vulpkanin_facial_hair"] = pick(SSaccessories.vulpkanin_facial_hair_list)
	return features

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

/datum/species/vulpkanin/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "wind",
			SPECIES_PERK_NAME = "Чувствительный нюх",
			SPECIES_PERK_DESC = "[plural_form] могут различать больше запахов и запоминать их.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "assistive-listening-systems",
			SPECIES_PERK_NAME = "Чувствительный слух",
			SPECIES_PERK_DESC = "[plural_form] лучше слышат, но более чувствительны к громким звукам, например, светошумовым гранатам.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "fire-alt",
			SPECIES_PERK_NAME = "Быстрый метаболизм",
			SPECIES_PERK_DESC = "[plural_form] быстрее тратят полезные вещества, потому чаще хотят есть.",
		),
	)

	return to_add

/datum/species/vulpkanin/create_pref_temperature_perks()
	return list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "temperature-low",
			SPECIES_PERK_NAME = "Термоустойчивость",
			SPECIES_PERK_DESC = "[plural_form] лучше переносят перепады температур.",))

/datum/species/vulpkanin/create_pref_liver_perks()
	return list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "wine-glass",
			SPECIES_PERK_NAME = "Чувствительность к алкоголю",
			SPECIES_PERK_DESC = "Вульпканская печень более восприимчива к алкоголю, чем печень человека, примерно на 150%."
		))

/datum/species/vulpkanin/create_pref_language_perk()
	return list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "comment",
			SPECIES_PERK_NAME = "Носитель языка",
			SPECIES_PERK_DESC = "[plural_form] получают возможность говорить на Канилунце.",
		))

/datum/species/vulpkanin/get_scream_sound(mob/living/carbon/human/human)
	if(human.physique == MALE)
		if(prob(1))
			return 'sound/voice/human/wilhelm_scream.ogg'
		return pick(
			'sound/voice/human/malescream_1.ogg',
			'sound/voice/human/malescream_2.ogg',
			'sound/voice/human/malescream_3.ogg',
			'sound/voice/human/malescream_4.ogg',
			'sound/voice/human/malescream_5.ogg',
			'sound/voice/human/malescream_6.ogg',
		)

	return pick(
		'sound/voice/human/femalescream_1.ogg',
		'sound/voice/human/femalescream_2.ogg',
		'sound/voice/human/femalescream_3.ogg',
		'sound/voice/human/femalescream_4.ogg',
		'sound/voice/human/femalescream_5.ogg',
	)

/datum/species/vulpkanin/get_cough_sound(mob/living/carbon/human/human)
	if(human.physique == FEMALE)
		return pick(
			'sound/voice/human/female_cough1.ogg',
			'sound/voice/human/female_cough2.ogg',
			'sound/voice/human/female_cough3.ogg',
			'sound/voice/human/female_cough4.ogg',
			'sound/voice/human/female_cough5.ogg',
			'sound/voice/human/female_cough6.ogg',
		)
	return pick(
		'sound/voice/human/male_cough1.ogg',
		'sound/voice/human/male_cough2.ogg',
		'sound/voice/human/male_cough3.ogg',
		'sound/voice/human/male_cough4.ogg',
		'sound/voice/human/male_cough5.ogg',
		'sound/voice/human/male_cough6.ogg',
	)

/datum/species/vulpkanin/get_cry_sound(mob/living/carbon/human/human)
	if(human.physique == FEMALE)
		return pick(
			'sound/voice/human/female_cry1.ogg',
			'sound/voice/human/female_cry2.ogg',
		)
	return pick(
		'sound/voice/human/male_cry1.ogg',
		'sound/voice/human/male_cry2.ogg',
		'sound/voice/human/male_cry3.ogg',
	)


/datum/species/vulpkanin/get_sneeze_sound(mob/living/carbon/human/human)
	if(human.physique == FEMALE)
		return 'sound/voice/human/female_sneeze1.ogg'
	return 'sound/voice/human/male_sneeze1.ogg'

/datum/species/vulpkanin/get_laugh_sound(mob/living/carbon/human/human)
	if(!ishuman(human))
		return
	if(human.physique == FEMALE)
		return 'sound/voice/human/womanlaugh.ogg'
	return pick(
		'sound/voice/human/manlaugh1.ogg',
		'sound/voice/human/manlaugh2.ogg',
	)

/datum/species/vulpkanin/handle_mutant_bodyparts(mob/living/carbon/human/source, forced_colour)
	var/list/bodyparts_to_add = mutant_bodyparts.Copy()
	var/list/relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	var/list/standing = list()

	source.remove_overlay(BODY_BEHIND_LAYER)
	source.remove_overlay(BODY_ADJ_LAYER)
	source.remove_overlay(BODY_FRONT_LAYER)

	if(!mutant_bodyparts || HAS_TRAIT(source, TRAIT_INVISIBLE_MAN))
		return

	var/obj/item/bodypart/head/noggin = source.get_bodypart(BODY_ZONE_HEAD)


	if(mutant_bodyparts["ears"])
		if(!source.dna.features["ears"] || source.dna.features["ears"] == "None" || source.head && (source.head.flags_inv & HIDEHAIR) || (source.wear_mask && (source.wear_mask.flags_inv & HIDEHAIR)) || !noggin || IS_ROBOTIC_LIMB(noggin))
			bodyparts_to_add -= "ears"

	if(!bodyparts_to_add)
		return

	var/g = (source.physique == FEMALE) ? "f" : "m"

	for(var/layer in relevent_layers)
		var/layertext = mutant_bodyparts_layertext(layer)

		for(var/bodypart in bodyparts_to_add)
			var/datum/sprite_accessory/accessory
			switch(bodypart)
				if("ears")
					accessory = SSaccessories.ears_list[source.dna.features["ears"]]
				if("vulpkanin_body_markings")
					accessory = SSaccessories.vulpkanin_body_markings_list[source.dna.features["vulpkanin_body_markings"]]
				if("vulpkanin_head_markings")
					accessory = SSaccessories.vulpkanin_head_markings_list[source.dna.features["vulpkanin_head_markings"]]
				if("vulpkanin_head_accessories")
					accessory = SSaccessories.vulpkanin_head_accessories_list[source.dna.features["vulpkanin_head_accessories"]]
				if("vulpkanin_facial_hair")
					accessory = SSaccessories.vulpkanin_facial_hair_list[source.dna.features["vulpkanin_facial_hair"]]

			if(!accessory || accessory.icon_state == "none")
				continue

			var/mutable_appearance/accessory_overlay = mutable_appearance(accessory.icon, layer = -layer)

			if(accessory.gender_specific)
				accessory_overlay.icon_state = "[g]_[bodypart]_[accessory.icon_state]_[layertext]"
			else
				accessory_overlay.icon_state = "m_[bodypart]_[accessory.icon_state]_[layertext]"

			if(accessory.em_block)
				accessory_overlay.overlays += emissive_blocker(accessory_overlay.icon, accessory_overlay.icon_state, source, accessory_overlay.alpha)

			if(accessory.center)
				accessory_overlay = center_image(accessory_overlay, accessory.dimension_x, accessory.dimension_y)

			if(!(HAS_TRAIT(source, TRAIT_HUSK)))
				if(!forced_colour)
					switch(accessory.color_src)
						if(MUTANT_COLOR)
							accessory_overlay.color = fixed_mut_color || source.dna.features["mcolor"]
						if(HAIR_COLOR)
							accessory_overlay.color = get_fixed_hair_color(source) || source.hair_color
						if(EYE_COLOR)
							accessory_overlay.color = source.eye_color_left
						if("vulpkanin_body_markings_color")
							accessory_overlay.color = source.vulpcolors["vulpkanin_body_markings"]
						if("vulpkanin_head_markings_color")
							accessory_overlay.color = source.vulpcolors["vulpkanin_head_markings"]
						if("vulpkanin_head_accessories_color")
							accessory_overlay.color = source.vulpcolors["vulpkanin_head_accessory"]
						if("vulpkanin_facial_hair_color")
							accessory_overlay.color = source.vulpcolors["vulpkanin_facial_hair"]
				else
					accessory_overlay.color = forced_colour
			standing += accessory_overlay

			if(accessory.hasinner)
				var/mutable_appearance/inner_accessory_overlay = mutable_appearance(accessory.icon, layer = -layer)
				if(accessory.gender_specific)
					inner_accessory_overlay.icon_state = "[g]_[bodypart]inner_[accessory.icon_state]_[layertext]"
				else
					inner_accessory_overlay.icon_state = "m_[bodypart]inner_[accessory.icon_state]_[layertext]"

				if(accessory.center)
					inner_accessory_overlay = center_image(inner_accessory_overlay, accessory.dimension_x, accessory.dimension_y)

				standing += inner_accessory_overlay

		source.overlays_standing[layer] = standing.Copy()
		standing = list()

	source.apply_overlay(BODY_BEHIND_LAYER)
	source.apply_overlay(BODY_ADJ_LAYER)
	source.apply_overlay(BODY_FRONT_LAYER)
