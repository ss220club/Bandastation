
/*
	Burn wounds
*/

// TODO: well, a lot really, but specifically I want to add potential fusing of clothing/equipment on the affected area, and limb infections, though those may go in body part code
/datum/wound/burn
	name = "Burn Wound"
	a_or_from = "from"
	sound_effect = 'sound/effects/wounds/sizzle1.ogg'

/datum/wound/burn/flesh
	name = "Burn (Flesh) Wound"
	a_or_from = "from"
	processes = TRUE

	default_scar_file = FLESH_SCAR_FILE

	treatable_by = list(/obj/item/stack/medical/ointment, /obj/item/stack/medical/mesh) // sterilizer and alcohol will require reagent treatments, coming soon

	// Flesh damage vars
	/// How much damage to our flesh we currently have. Once both this and infestation reach 0, the wound is considered healed
	var/flesh_damage = 5
	/// Our current counter for how much flesh regeneration we have stacked from regenerative mesh/synthflesh/whatever, decrements each tick and lowers flesh_damage
	var/flesh_healing = 0

	// Infestation vars (only for severe and critical)
	/// How quickly infection breeds on this burn if we don't have disinfectant
	var/infestation_rate = 0
	/// Our current level of infection
	var/infestation = 0
	/// Our current level of sanitization/anti-infection, from disinfectants/alcohol/UV lights. While positive, totally pauses and slowly reverses infestation effects each tick
	var/sanitization = 0

	/// Once we reach infestation beyond WOUND_INFESTATION_SEPSIS, we get this many warnings before the limb is completely paralyzed (you'd have to ignore a really bad burn for a really long time for this to happen)
	var/strikes_to_lose_limb = 3

/datum/wound/burn/flesh/handle_process(seconds_per_tick, times_fired)

	if (!victim || HAS_TRAIT(victim, TRAIT_STASIS))
		return

	. = ..()
	if(strikes_to_lose_limb <= 0) // мы уже достигли сепсиса, больше ничего не сделать
		victim.adjustToxLoss(0.25 * seconds_per_tick)
		if(SPT_PROB(0.5, seconds_per_tick))
			victim.visible_message(span_danger("Инфекция на остатках [victim]'s [limb.plaintext_zone] шевелится и пузырится, вызывая тошноту!"), span_warning("Вы чувствуете, как инфекция на остатках вашего [limb.plaintext_zone] проникает в ваши вены!"), vision_distance = COMBAT_MESSAGE_RANGE)
		return

	for(var/datum/reagent/reagent as anything in victim.reagents.reagent_list)
		if(reagent.chemical_flags & REAGENT_AFFECTS_WOUNDS)
			reagent.on_burn_wound_processing(src)

	if(HAS_TRAIT(victim, TRAIT_VIRUS_RESISTANCE))
		sanitization += 0.9

	if(limb.current_gauze)
		limb.seep_gauze(WOUND_BURN_SANITIZATION_RATE * seconds_per_tick)

	if(flesh_healing > 0) // хорошие повязки удлиняют процесс заживления
		var/bandage_factor = limb.current_gauze?.burn_cleanliness_bonus || 1
		flesh_damage = max(flesh_damage - (0.5 * seconds_per_tick), 0)
		flesh_healing = max(flesh_healing - (0.5 * bandage_factor * seconds_per_tick), 0) // хорошие повязки удлиняют процесс заживления

	// если у нас мало/нет инфекции, у конечности немного повреждений от ожога, и питание хорошее, заживление происходит
	if(infestation <= WOUND_INFECTION_MODERATE && (limb.burn_dam < 5) && (victim.nutrition >= NUTRITION_LEVEL_FED))
		flesh_healing += 0.2

	// проверка на выздоровление
	if((flesh_damage <= 0) && (infestation <= WOUND_INFECTION_MODERATE))
		to_chat(victim, span_green("Ожоги на вашем [limb.plaintext_zone] зажили!"))
		qdel(src)
		return

	// санитация проверяется после проверки на выздоровление, но перед фактическими негативными последствиями, потому что мы замораживаем эффекты инфекции, пока есть санитация
	if(sanitization > 0)
		var/bandage_factor = limb.current_gauze?.burn_cleanliness_bonus || 1
		infestation = max(infestation - (WOUND_BURN_SANITIZATION_RATE * seconds_per_tick), 0)
		sanitization = max(sanitization - (WOUND_BURN_SANITIZATION_RATE * bandage_factor * seconds_per_tick), 0)
		return

	infestation += infestation_rate * seconds_per_tick
	switch(infestation)
		if(0 to WOUND_INFECTION_MODERATE)
			return

		if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
			if(SPT_PROB(15, seconds_per_tick))
				victim.adjustToxLoss(0.2)
				if(prob(6))
					to_chat(victim, span_warning("Мозоли на вашем [limb.plaintext_zone] выделяют странный гной..."))

		if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
			if(!disabling)
				if(SPT_PROB(1, seconds_per_tick))
					to_chat(victim, span_warning("<b>Ваш [limb.plaintext_zone] полностью блокируется, и вы боретесь за контроль над инфекцией!</b>"))
					set_disabling(TRUE)
					return
			else if(SPT_PROB(4, seconds_per_tick))
				to_chat(victim, span_notice("Вы вновь чувствуете свою [limb.plaintext_zone], но она по-прежнему в ужасном состоянии!"))
				set_disabling(FALSE)
				return

			if(SPT_PROB(10, seconds_per_tick))
				victim.adjustToxLoss(0.5)

		if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
			if(!disabling)
				if(SPT_PROB(1.5, seconds_per_tick))
					to_chat(victim, span_warning("<b>Вы внезапно теряете все ощущения от гнойной инфекции в вашем [limb.plaintext_zone]!</b>"))
					set_disabling(TRUE)
					return
			else if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(victim, span_notice("Вы едва чувствуете свою [limb.plaintext_zone] снова, и вам нужно напрягаться, чтобы сохранить контроль над моторикой!"))
				set_disabling(FALSE)
				return

			if(SPT_PROB(2.48, seconds_per_tick))
				if(prob(20))
					to_chat(victim, span_warning("Вы размышляете о жизни без своей [limb.plaintext_zone]..."))
					victim.adjustToxLoss(0.75)
				else
					victim.adjustToxLoss(1)

		if(WOUND_INFECTION_SEPTIC to INFINITY)
			if(SPT_PROB(0.5 * infestation, seconds_per_tick))
				strikes_to_lose_limb--
				switch(strikes_to_lose_limb)
					if(2 to INFINITY)
						to_chat(victim, span_deadsay("<b>Инфекция в вашем [limb.plaintext_zone] буквально стекает, вам ужасно!</b>"))
					if(1)
						to_chat(victim, span_deadsay("<b>Инфекция почти полностью захватила ваш [limb.plaintext_zone]!</b>"))
					if(0)
						to_chat(victim, span_deadsay("<b>Последние нервные окончания в вашем [limb.plaintext_zone] увядают, пока инфекция полностью парализует ваш сустав.</b>"))
						threshold_penalty = 120 // легко потерять
						set_disabling(TRUE)

/datum/wound/burn/flesh/set_disabling(new_value)
	. = ..()
	if(new_value && strikes_to_lose_limb <= 0)
		treat_text_short = "Ампутируйте или усовершенствуйте конечность немедленно, или поместите пациента в криогенерику."
	else
		treat_text_short = initial(treat_text_short)

/datum/wound/burn/flesh/get_wound_description(mob/user)
	if(strikes_to_lose_limb <= 0)
		return span_deadsay("<B>[victim.p_Their()] [limb.plaintext_zone] полностью заблокирован и не функционирует.</B>")

	var/list/condition = list("[victim.p_Their()] [limb.plaintext_zone] [examine_desc]")
	if(limb.current_gauze)
		var/bandage_condition
		switch(limb.current_gauze.absorption_capacity)
			if(0 to 1.25)
				bandage_condition = "почти разрушен"
			if(1.25 to 2.75)
				bandage_condition = "плохо изношен"
			if(2.75 to 4)
				bandage_condition = "слегка запачкан"
			if(4 to INFINITY)
				bandage_condition = "чистый"

		condition += " под повязкой из [bandage_condition] [limb.current_gauze.name]"
	else
		switch(infestation)
			if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
				condition += ", [span_deadsay("с ранними признаками инфекции.")]"
			if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
				condition += ", [span_deadsay("с растущими облаками инфекции.")]"
			if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
				condition += ", [span_deadsay("с полосами гнилой инфекции!")]"
			if(WOUND_INFECTION_SEPTIC to INFINITY)
				return span_deadsay("<B>[victim.p_Their()] [limb.plaintext_zone] представляет собой хаос из обожженной кожи и зараженного гниения!</B>")
			else
				condition += "!"

	return "<B>[condition.Join()]</B>"


/datum/wound/burn/flesh/severity_text(simple = FALSE)
	. = ..()
	. += " Ожог / "
	switch(infestation)
		if(-INFINITY to WOUND_INFECTION_MODERATE)
			. += "Нет"
		if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
			. += "Умеренный"
		if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
			. += "<b>Серьезный</b>"
		if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
			. += "<b>Критический</b>"
		if(WOUND_INFECTION_SEPTIC to INFINITY)
			. += "<b>Полный</b>"
	. += " Инфекция"

/datum/wound/burn/flesh/get_scanner_description(mob/user)
	if(strikes_to_lose_limb <= 0) // Непонятно, может ли это значение опуститься ниже 0, лучше не рисковать
		var/oopsie = "Тип: [name]<br>Тяжесть: [severity_text()]"
		oopsie += "<div class='ml-3'>Уровень инфекции: [span_deadsay("Часть тела пострадала от полной сепсиса и должна быть удалена. Ампутируйте или улучшите конечность немедленно, или поместите пациента в криотрубку.")]</div>"
		return oopsie

	. = ..()
	. += "<div class='ml-3'>"

	if(infestation <= sanitization && flesh_damage <= flesh_healing)
		. += "Дополнительное лечение не требуется: Ожоги заживут в ближайшее время."
	else
		switch(infestation)
			if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
				. += "Уровень инфекции: Умеренный\n"
			if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
				. += "Уровень инфекции: Серьезный\n"
			if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
				. += "Уровень инфекции: [span_deadsay("КРИТИЧЕСКИЙ")]\n"
			if(WOUND_INFECTION_SEPTIC to INFINITY)
				. += "Уровень инфекции: [span_deadsay("УТРАТА НЕМЕДЛЕННО")]\n"
		if(infestation > sanitization)
			. += "\tХирургическая обработка, антибиотики/стерилизаторы или регенеративная сетка избавят от инфекции. Ультрафиолетовые ручные фонарики парамедиков также эффективны.\n"

		if(flesh_damage > 0)
			. += "Обнаружено повреждение ткани: Применение мази, регенеративной сетки, Synthflesh или употребление \"Минералки\" помогут восстановить поврежденную ткань. Хорошее питание, отдых и поддержание чистоты раны также могут медленно восстановить ткань.\n"
	. += "</div>"

/*
	new burn common procs
*/

/// if someone is using ointment or mesh on our burns
/datum/wound/burn/flesh/proc/ointmentmesh(obj/item/stack/medical/I, mob/user)
	user.visible_message(span_notice("[user] начинает наносить [I] на [victim]'s [limb.plaintext_zone]..."), span_notice("Вы начинаете наносить [I] на [user == victim ? "ваш" : "[victim]'s"] [limb.plaintext_zone]..."))
	if (I.amount <= 0)
		return TRUE
	if(!do_after(user, (user == victim ? I.self_delay : I.other_delay), target = victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return TRUE

	limb.heal_damage(I.heal_brute, I.heal_burn)
	user.visible_message(span_green("[user] наносит [I] на [victim]."), span_green("Вы наносите [I] на [user == victim ? "ваш" : "[victim]'s"] [limb.plaintext_zone]."))
	I.use(1)
	sanitization += I.sanitization
	flesh_healing += I.flesh_regeneration

	if((infestation <= 0 || sanitization >= infestation) && (flesh_damage <= 0 || flesh_healing > flesh_damage))
		to_chat(user, span_notice("Вы сделали всё, что могли с [I], теперь вам нужно подождать, пока flesh на [victim]'s [limb.plaintext_zone] восстановится."))
		return TRUE
	else
		return try_treating(I, user)

/// Paramedic UV penlights
/datum/wound/burn/flesh/proc/uv(obj/item/flashlight/pen/paramedic/I, mob/user)
	if(!COOLDOWN_FINISHED(I, uv_cooldown))
		to_chat(user, span_notice("[I] еще перезаряжается!"))
		return TRUE
	if(infestation <= 0 || infestation < sanitization)
		to_chat(user, span_notice("Нет инфекция на [limb.plaintext_zone] [victim]!"))
		return TRUE

	user.visible_message(span_notice("[user] отчищает ожоги [limb] [victim] при помощи [I]."), span_notice("Вы очищаете ожоги [user == victim ? "вашей" : "[victim]"] [limb.plaintext_zone] при помощи [I]."), vision_distance=COMBAT_MESSAGE_RANGE)
	sanitization += I.uv_power
	COOLDOWN_START(I, uv_cooldown, I.uv_cooldown_length)
	return TRUE

/datum/wound/burn/flesh/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/medical/ointment))
		return ointmentmesh(I, user)
	else if(istype(I, /obj/item/stack/medical/mesh))
		var/obj/item/stack/medical/mesh/mesh_check = I
		if(!mesh_check.is_open)
			to_chat(user, span_warning("Ваш нужно открыть [mesh_check] для начала."))
			return
		return ointmentmesh(mesh_check, user)
	else if(istype(I, /obj/item/flashlight/pen/paramedic))
		return uv(I, user)

// people complained about burns not healing on stasis beds, so in addition to checking if it's cured, they also get the special ability to very slowly heal on stasis beds if they have the healing effects stored
/datum/wound/burn/flesh/on_stasis(seconds_per_tick, times_fired)
	. = ..()
	if(strikes_to_lose_limb <= 0) // we've already hit sepsis, nothing more to do
		if(SPT_PROB(0.5, seconds_per_tick))
			victim.visible_message(span_danger("Зараженные остатки [victim]'s [limb.plaintext_zone] пузыряться!"), span_warning("Вы можете чувствовать, как заражение на [limb.plaintext_zone] проникает в ваши вены!"), vision_distance = COMBAT_MESSAGE_RANGE)
		return
	if(flesh_healing > 0)
		flesh_damage = max(flesh_damage - (0.1 * seconds_per_tick), 0)
	if((flesh_damage <= 0) && (infestation <= 1))
		to_chat(victim, span_green("Ожоги на [limb.plaintext_zone] очистились!"))
		qdel(src)
		return
	if(sanitization > 0)
		infestation = max(infestation - (0.1 * WOUND_BURN_SANITIZATION_RATE * seconds_per_tick), 0)

/datum/wound/burn/flesh/on_synthflesh(reac_volume)
	flesh_healing += reac_volume * 0.5 // 20u patch will heal 10 flesh standard

/datum/wound_pregen_data/flesh_burn
	abstract = TRUE

	required_wounding_types = list(WOUND_BURN)
	required_limb_biostate = BIO_FLESH

	wound_series = WOUND_SERIES_FLESH_BURN_BASIC

/datum/wound/burn/get_limb_examine_description()
	return span_warning("Плоть на конечности ужасно обуглена.")

// we don't even care about first degree burns, straight to second
/datum/wound/burn/flesh/moderate
	name = "Ожоги второй степени"
	desc = "Пациент страдает от значительных ожогов с незначительным проникновением в кожу, что ослабляет целостность конечности и вызывает усиленные ощущения жжения."
	treat_text = "Нанесите местную мазь или регенеративную сетку на рану."
	treat_text_short = "Нанесите средство для лечения, например, регенеративную сетку."
	examine_desc = "сильно обожжён и покрывается волдырями"
	occur_text = "покрывается ярко-красными ожогами"
	severity = WOUND_SEVERITY_MODERATE
	damage_multiplier_penalty = 1.1
	threshold_penalty = 30 // burns cause significant decrease in limb integrity compared to other wounds
	status_effect_type = /datum/status_effect/wound/burn/flesh/moderate
	flesh_damage = 5
	scar_keyword = "burnmoderate"

	simple_desc = "Кожа пациента обожжена, что ослабляет конечность и увеличивает ощущаемый урон!"
	simple_treat_text = "Мазь ускорит восстановление, как и регенеративная сетка. Риск заражения незначителен."
	homemade_treat_text = "Полезный чай ускорит восстановление. Соль или, предпочтительно, солевой раствор, продезинфицируют рану, но использование соли может вызвать раздражение кожи и увеличить риск заражения."

/datum/wound_pregen_data/flesh_burn/second_degree
	abstract = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/moderate

	threshold_minimum = 40

/datum/wound/burn/flesh/severe
	name = "Ожоги третьей степени"
	desc = "Пациент страдает от сильнейших ожогов с полным проникновением в кожу, что создает серьезный риск инфекции и значительно снижает целостность конечности."
	treat_text = "Немедленно примените лечебные средства, такие как синтплоть или регенеративная сетка, к ране. \
			Продезинфицируйте рану и хирургически удалите инфицированную кожу, затем оберните чистой марлей или используйте мазь для предотвращения дальнейшего заражения. \
			Если конечность отмерла, ее необходимо ампутировать, заменить имплантатом или лечить криогеникой."
	treat_text_short = "Примените лечебные средства, такие как регенеративная сетка, синтплоть или криогеника, и продезинфицируйте / удалите инфицированные участки. \
			Чистая марля или мазь замедлят скорость распространения инфекции."
	examine_desc = "выглядит сильно обугленной, с агрессивными красными пятнами"
	occur_text = "обугливается, обнажая разрушенные ткани и распространяя ярко-красные ожоги"
	severity = WOUND_SEVERITY_SEVERE
	damage_multiplier_penalty = 1.2
	threshold_penalty = 40
	status_effect_type = /datum/status_effect/wound/burn/flesh/severe
	treatable_by = list(/obj/item/flashlight/pen/paramedic, /obj/item/stack/medical/ointment, /obj/item/stack/medical/mesh)
	infestation_rate = 0.07 // appx 9 minutes to reach sepsis without any treatment
	flesh_damage = 12.5
	scar_keyword = "burnsevere"

	simple_desc = "Кожа пациента сильно обожжена, что значительно ослабляет конечность и усугубляет дальнейшие повреждения!!"
	simple_treat_text = "<b>Бинты ускорят восстановление</b>, как и <b>мазь или регенеративная сетка</b>. <b>Спейсациллин, стерилизин и 'Шахтерская мазь'</b> помогут справиться с инфекцией."
	homemade_treat_text = "<b>Полезный чай</b> ускорит восстановление. <b>Соль</b> или, предпочтительно, <b>смесь соли и воды</b>, продезинфицируют рану, но особенно первая вызовет раздражение кожи и обезвоживание, что ускорит развитие инфекции. <b>Космоочиститель</b> можно использовать в качестве дезинфицирующего средства в крайнем случае."

/datum/wound_pregen_data/flesh_burn/third_degree
	abstract = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/severe

	threshold_minimum = 80

/datum/wound/burn/flesh/critical
	name = "Катастрофические ожоги"
	desc = "Пациент страдает от почти полного разрушения тканей, с серьезными обугленными мышцами и костями, что создает угрожающую жизни опасность инфекции и практически нулевую целостность конечности."
	treat_text = "Немедленно нанесите лечебные средства, такие как Синтплоть или регенеративную сетку, на рану. \
		Продезинфицируйте рану и хирургически удалите инфицированные участки кожи, затем оберните чистой марлей / используйте мазь для предотвращения дальнейшей инфекции. \
		Если конечность зафиксирована, её необходимо ампутировать, заменить на имплант или лечить с помощью криогенной терапии."
	treat_text_short = "Нанесите лечебное средство, такое как регенеративная сетка, Синтплоть или используйте криотерапию и продезинфицируйте / удалите инфицированные участки. \
		Чистая марля или мазь замедлит скорость инфицирования."
	examine_desc = "это разрушенный беспорядок из обесцвеченных костей, расплавленного жира и обугленной ткани"
	occur_text = "испаряется, когда плоть, кости и жир плавятся в ужасающую массу"
	severity = WOUND_SEVERITY_CRITICAL
	damage_multiplier_penalty = 1.3
	sound_effect = 'sound/effects/wounds/sizzle2.ogg'
	threshold_penalty = 80
	status_effect_type = /datum/status_effect/wound/burn/flesh/critical
	treatable_by = list(/obj/item/flashlight/pen/paramedic, /obj/item/stack/medical/ointment, /obj/item/stack/medical/mesh)
	infestation_rate = 0.075 // appx 4.33 minutes to reach sepsis without any treatment
	flesh_damage = 20
	scar_keyword = "burncritical"

	simple_desc = "Кожа пациента разрушена, ткани обуглены, конечность почти лишена <b>целостности</b> и подвержена крайне высокой вероятности <b>инфекции</b>!!!"
	simple_treat_text = "Немедленно <b>перевяжите</b> рану и обработайте её <b>мазью или регенеративной сеткой</b>. <b>Спейсациллин, стерилизин или 'Мазь шахтёра'</b> помогут предотвратить инфекцию. Обратитесь за профессиональной помощью <b>немедленно</b>, до того как начнётся сепсис и рана станет неизлечимой."
	homemade_treat_text = "<b>Целебный чай</b> поможет с восстановлением. <b>Раствор соли</b>, нанесенный местно, может временно предотвратить инфекцию, но чистая поваренная соль НЕ рекомендуется. <b>Космический очиститель</b> можно использовать в качестве дезинфицирующего средства в крайнем случае."

/datum/wound_pregen_data/flesh_burn/fourth_degree
	abstract = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/critical

	threshold_minimum = 140

///special severe wound caused by sparring interference or other god related punishments.
/datum/wound/burn/flesh/severe/brand
	name = "Священное Клеймо"
	desc = "Пациент страдает от сильных ожогов с загадочными клеймами, создающими серьезный риск инфекции и сильно сниженную целостность конечности."
	examine_desc = "похоже, что на его/ее коже были выжжены священные символы, оставившие сильные ожоги."
	occur_text = "быстро обугливается в странный узор из священных символов, выжженных на коже."

	simple_desc = "На коже пациента выжжены странные метки, что значительно ослабляет конечность и усугубляет дальнейший ущерб!!"

/datum/wound_pregen_data/flesh_burn/third_degree/holy
	abstract = FALSE
	can_be_randomly_generated = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/severe/brand
/// special severe wound caused by the cursed slot machine.
/datum/wound/burn/flesh/severe/cursed_brand
	name = "Древнее Клеймо"
	desc = "Пациент страдает от сильных ожогов с причудливым орнаментом, создающих серьезный риск инфекции и сильно сниженной целостностью конечности."
	examine_desc = "похоже, что на его/ее коже были выжжены причудливые символы, оставившие сильные ожоги."
	occur_text = "быстро обугливается в узор, который можно описать только как сочетание нескольких финансовых символов, выжженных на коже."

/datum/wound/burn/flesh/severe/cursed_brand/get_limb_examine_description()
	return span_warning("На коже этой конечности выжжены причудливые символы, с углублениями по всей поверхности.")

/datum/wound_pregen_data/flesh_burn/third_degree/cursed_brand
	abstract = FALSE
	can_be_randomly_generated = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/severe/cursed_brand
