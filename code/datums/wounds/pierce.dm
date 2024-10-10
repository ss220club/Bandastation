
/*
	Piercing wounds
*/
/datum/wound/pierce

/datum/wound/pierce/bleed
	name = "Piercing Wound"
	sound_effect = 'sound/items/weapons/slice.ogg'
	processes = TRUE
	treatable_by = list(/obj/item/stack/medical/suture)
	treatable_tools = list(TOOL_CAUTERY)
	base_treat_time = 3 SECONDS
	wound_flags = (ACCEPTS_GAUZE | CAN_BE_GRASPED)

	default_scar_file = FLESH_SCAR_FILE

	/// How much blood we start losing when this wound is first applied
	var/initial_flow
	/// If gauzed, what percent of the internal bleeding actually clots of the total absorption rate
	var/gauzed_clot_rate

	/// When hit on this bodypart, we have this chance of losing some blood + the incoming damage
	var/internal_bleeding_chance
	/// If we let off blood when hit, the max blood lost is this * the incoming damage
	var/internal_bleeding_coefficient

/datum/wound/pierce/bleed/wound_injury(datum/wound/old_wound = null, attack_direction = null)
	set_blood_flow(initial_flow)
	if(limb.can_bleed() && attack_direction && victim.blood_volume > BLOOD_VOLUME_OKAY)
		victim.spray_blood(attack_direction, severity)

	return ..()

/datum/wound/pierce/bleed/receive_damage(wounding_type, wounding_dmg, wound_bonus)
	if(victim.stat == DEAD || (wounding_dmg < 5) || !limb.can_bleed() || !victim.blood_volume || !prob(internal_bleeding_chance + wounding_dmg))
		return
	if(limb.current_gauze?.splint_factor)
		wounding_dmg *= (1 - limb.current_gauze.splint_factor)
	var/blood_bled = rand(1, wounding_dmg * internal_bleeding_coefficient) // 12 brute toolbox can cause up to 15/18/21 bloodloss on mod/sev/crit
	switch(blood_bled)
    if(1 to 6)
        victim.bleed(blood_bled, TRUE)
    if(7 to 13)
        victim.visible_message(
            span_smalldanger("Капли крови вылетают из дыры в [limb.plaintext_zone] [victim]!."),
            span_danger("Вы откашливаетесь, выплевывая немного крови из удара по вашей [limb.plaintext_zone]."),
            vision_distance = COMBAT_MESSAGE_RANGE,
        )
        victim.bleed(blood_bled, TRUE)
    if(14 to 19)
        victim.visible_message(
            span_smalldanger("Небольшая струя крови брызгает из дыры в [limb.plaintext_zone] [victim]!!"),
            span_danger("Вы выплевываете струю крови из удара по вашей [limb.plaintext_zone]!"),
            vision_distance = COMBAT_MESSAGE_RANGE,
        )
        new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
        victim.bleed(blood_bled)
    if(20 to INFINITY)
        victim.visible_message(
            span_danger("Брызги крови струятся из раны в [limb.plaintext_zone] [victim]!"),
            span_bolddanger("Вы задыхаетесь, выплевывая брызги крови из удара по вашей [limb.plaintext_zone]!"),
            vision_distance = COMBAT_MESSAGE_RANGE,
        )
        victim.bleed(blood_bled)
        new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
        victim.add_splatter_floor(get_step(victim.loc, victim.dir))

/datum/wound/pierce/bleed/get_bleed_rate_of_change()
	//basically if a species doesn't bleed, the wound is stagnant and will not heal on its own (nor get worse)
	if(!limb.can_bleed())
		return BLOOD_FLOW_STEADY
	if(HAS_TRAIT(victim, TRAIT_BLOODY_MESS))
		return BLOOD_FLOW_INCREASING
	if(limb.current_gauze)
		return BLOOD_FLOW_DECREASING
	return BLOOD_FLOW_STEADY

/datum/wound/pierce/bleed/handle_process(seconds_per_tick, times_fired)
	if (!victim || HAS_TRAIT(victim, TRAIT_STASIS))
		return

	set_blood_flow(min(blood_flow, WOUND_SLASH_MAX_BLOODFLOW))

	if(limb.can_bleed())
		if(victim.bodytemperature < (BODYTEMP_NORMAL - 10))
			adjust_blood_flow(-0.1 * seconds_per_tick)
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(victim, span_notice("Вы чувствуете, как [LOWER_TEXT(name)] в вашей [limb.plaintext_zone] становится твердым от холода!"))

		if(HAS_TRAIT(victim, TRAIT_BLOODY_MESS))
			adjust_blood_flow(0.25 * seconds_per_tick) // old heparin used to just add +2 bleed stacks per tick, this adds 0.5 bleed flow to all open cuts which is probably even stronger as long as you can cut them first

	if(limb.current_gauze)
		adjust_blood_flow(-limb.current_gauze.absorption_rate * gauzed_clot_rate * seconds_per_tick)
		limb.current_gauze.absorption_capacity -= limb.current_gauze.absorption_rate * seconds_per_tick

	if(blood_flow <= 0)
		qdel(src)

/datum/wound/pierce/bleed/on_stasis(seconds_per_tick, times_fired)
	. = ..()
	if(blood_flow <= 0)
		qdel(src)

/datum/wound/pierce/bleed/check_grab_treatments(obj/item/I, mob/user)
	if(I.get_temperature()) // if we're using something hot but not a cautery, we need to be aggro grabbing them first, so we don't try treating someone we're eswording
		return TRUE

/datum/wound/pierce/bleed/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/medical/suture))
		return suture(I, user)
	else if(I.tool_behaviour == TOOL_CAUTERY || I.get_temperature())
		return tool_cauterize(I, user)

/datum/wound/pierce/bleed/on_xadone(power)
	. = ..()

	if (limb) // parent can cause us to be removed, so its reasonable to check if we're still applied
		adjust_blood_flow(-0.03 * power) // i think it's like a minimum of 3 power, so .09 blood_flow reduction per tick is pretty good for 0 effort

/datum/wound/pierce/bleed/on_synthflesh(reac_volume)
	. = ..()
	adjust_blood_flow(-0.025 * reac_volume) // 20u * 0.05 = -1 blood flow, less than with slashes but still good considering smaller bleed rates

/// If someone is using a suture to close this puncture
/datum/wound/pierce/bleed/proc/suture(obj/item/stack/medical/suture/I, mob/user)
	var/self_penalty_mult = (user == victim ? 1.4 : 1)
	var/treatment_delay = base_treat_time * self_penalty_mult

	if(HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		treatment_delay *= 0.5
		user.visible_message(span_notice("[user] начинает искусно зашивать [limb.plaintext_zone] [victim] с помощью [I]..."), span_notice("Вы начинаете зашивать [user == victim ? "вашу" : "[victim]"] [limb.plaintext_zone] с помощью [I], имея в виду информацию с голограммы..."))
	else
		user.visible_message(span_notice("[user] начинает зашивать [limb.plaintext_zone] [victim] с помощью [I]..."), span_notice("Вы начинаете зашивать [user == victim ? "вашу" : "[victim]"] [limb.plaintext_zone] с помощью [I]..."))

	if(!do_after(user, treatment_delay, target = victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return TRUE
	var/bleeding_wording = (!limb.can_bleed() ? "дыры" : "кровотечение")
	user.visible_message(span_green("[user] зашивает некоторые из [bleeding_wording] на [victim]."), span_green("Вы зашиваете некоторые из [bleeding_wording] на [user == victim ? "себе" : "[victim]"]."))
	var/blood_sutured = I.stop_bleeding / self_penalty_mult
	adjust_blood_flow(-blood_sutured)
	limb.heal_damage(I.heal_brute, I.heal_burn)
	I.use(1)

	if(blood_flow > 0)
		return try_treating(I, user)
	else
		to_chat(user, span_green("Вы успешно закрываете дыру в [user == victim ? "вашей" : "[victim]'s"] [limb.plaintext_zone]."))
		return TRUE

/// Если кто-то использует инструмент для прижигания или что-то горячее для прижигания этой раны
/datum/wound/pierce/bleed/proc/tool_cauterize(obj/item/I, mob/user)

	var/improv_penalty_mult = (I.tool_behaviour == TOOL_CAUTERY ? 1 : 1.25) // На 25% дольше и менее эффективно, если вы не используете настоящий инструмент для прижигания
	var/self_penalty_mult = (user == victim ? 1.5 : 1) // На 50% дольше и менее эффективно, если вы делаете это себе

	var/treatment_delay = base_treat_time * self_penalty_mult * improv_penalty_mult

	if(HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		treatment_delay *= 0.5
		user.visible_message(span_danger("[user] начинает искусно прижигать [limb.plaintext_zone] [victim] с помощью [I]..."), span_warning("Вы начинаете прижигать [user == victim ? "вашу" : "[victim]"] [limb.plaintext_zone] с помощью [I], учитывая информацию с голограммы..."))
	else
		user.visible_message(span_danger("[user] начинает прижигать [limb.plaintext_zone] [victim] с помощью [I]..."), span_warning("Вы начинаете прижигать [user == victim ? "вашу" : "[victim]"] [limb.plaintext_zone] с помощью [I]..."))

	if(!do_after(user, treatment_delay, target = victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return TRUE

	var/bleeding_wording = (!limb.can_bleed() ? "дыры" : "кровотечение")
	user.visible_message(span_green("[user] прижигает некоторые из [bleeding_wording] на [victim]."), span_green("Вы прижигаете некоторые из [bleeding_wording] на [victim]."))
	limb.receive_damage(burn = 2 + severity, wound_bonus = CANT_WOUND)
	if(prob(30))
		victim.emote("кричит")
	var/blood_cauterized = (0.6 / (self_penalty_mult * improv_penalty_mult))
	adjust_blood_flow(-blood_cauterized)

	if(blood_flow > 0)
		return try_treating(I, user)
	return TRUE

/datum/wound_pregen_data/flesh_pierce
	abstract = TRUE

	required_limb_biostate = (BIO_FLESH)
	required_wounding_types = list(WOUND_PIERCE)

	wound_series = WOUND_SERIES_FLESH_PUNCTURE_BLEED

/datum/wound/pierce/get_limb_examine_description()
	return span_warning("Кожа на этой конечности кажется сильно перфорированной.")

/datum/wound/pierce/bleed/moderate
	name = "Незначительный прокол"
	desc = "Кожа пациента была повреждена, вызвав сильный синяк и незначительное внутреннее кровотечение в пораженной области."
	treat_text = "Наложите повязку или зашейте рану, используйте коагулянты, \
		прижигание или в крайних случаях - воздействие сильного холода или вакуума. \
		Следует обеспечить прием пищи и период отдыха."
	treat_text_short = "Наложите повязку или зашейте рану."
	examine_desc = "имеет небольшое круглое отверстие, слегка кровоточит"
	occur_text = "выбрызгивает тонкую струю крови"
	sound_effect = 'sound/effects/wounds/pierce1.ogg'
	severity = WOUND_SEVERITY_MODERATE
	initial_flow = 1.5
	gauzed_clot_rate = 0.8
	internal_bleeding_chance = 30
	internal_bleeding_coefficient = 1.25
	threshold_penalty = 20
	status_effect_type = /datum/status_effect/wound/pierce/moderate
	scar_keyword = "piercemoderate"

	simple_treat_text = "<b>Перевязка</b> раны уменьшит кровопотерю, поможет ране быстрее закрыться самостоятельно и ускорит период восстановления крови. Саму рану можно медленно <b>зашить</b>."
	homemade_treat_text = "<b>Чай</b> стимулирует естественныеHealing системы организма, слегка ускоряя свёртывание крови. Рану также можно промыть в раковине или под душем. Другие средства не нужны."

/datum/wound_pregen_data/flesh_pierce/breakage
	abstract = FALSE

	wound_path_to_generate = /datum/wound/pierce/bleed/moderate

	threshold_minimum = 30

/datum/wound/pierce/bleed/moderate/update_descriptions()
	if(!limb.can_bleed())
		examine_desc = "имеет небольшое круглое отверстие"
		occur_text = "разрывает небольшое отверстие"

/datum/wound/pierce/bleed/severe
	name = "Открытый прокол"
	desc = "Внутренние ткани пациента повреждены, что вызывает значительное внутреннее кровотечение и снижение стабильности конечности."
	treat_text = "Быстро примените повязку или швы к ране, используйте средства для свертывания крови или соляно-глюкозный раствор, \
		каутеризацию или, в крайних случаях, воздействие на рану экстремальным холодом или вакуумом. \
		Следует дополнить лечение добавками железа и периодом отдыха."
	treat_text_short = "Примените повязку, швы, средства для свертывания крови или кутеризацию."
	examine_desc = "проколотое насквозь, с кусочками ткани, закрывающими открытое отверстие"
	occur_text = "теряет сильный фонтан крови, обнажая проколотую рану"
	sound_effect = 'sound/effects/wounds/pierce2.ogg'
	severity = WOUND_SEVERITY_SEVERE
	initial_flow = 2.25
	gauzed_clot_rate = 0.6
	internal_bleeding_chance = 60
	internal_bleeding_coefficient = 1.5
	threshold_penalty = 35
	status_effect_type = /datum/status_effect/wound/pierce/severe
	scar_keyword = "piercesevere"

	simple_treat_text = "<b>Повязка</b> на рану необходима и поможет уменьшить кровотечение. После этого рану можно <b>зашить</b>, предпочтительно когда пациент отдыхает и/или держит свою рану."
	homemade_treat_text = "Простыни можно разорвать, чтобы сделать <b>самодельный бинт</b>. <b>Мука, поваренная соль или соль, смешанная с водой</b> могут быть нанесены непосредственно на рану, чтобы остановить кровотечение, хотя неразмешанная соль будет раздражать кожу и ухудшать естественное заживление. Отдых и удерживание раны также помогут уменьшить кровотечение."

/datum/wound_pregen_data/flesh_pierce/open_puncture
	abstract = FALSE

	wound_path_to_generate = /datum/wound/pierce/bleed/severe

	threshold_minimum = 50

/datum/wound/pierce/bleed/severe/update_descriptions()
	if(!limb.can_bleed())
		occur_text = "разрывает дыру"

/datum/wound/pierce/bleed/critical
	name = "Разорванная полость"
	desc = "Внутренние ткани и кровеносная система пациента разорваны, что вызывает значительное внутреннее кровотечение и повреждение внутренних органов."
	treat_text = "Сразу же наложите повязку или сделайте швы на ране, используйте средства для остановки кровотечения или соляно-глюкозный раствор, \
		краткосрочное сжигание, или в крайних случаях, воздействие экстремального холода или вакуума. \
		Затем следует провести контролируемую реинфузию."
	treat_text_short = "Наложите повязку, сделайте швы, используйте средства для остановки кровотечения или краткосрочное сжигание."
	examine_desc = "разорвано насквозь, едва удерживается на месте открытой костью"
	occur_text = "разлетается на куски, отправляя части внутренностей во все стороны"
	sound_effect = 'sound/effects/wounds/pierce3.ogg'
	severity = WOUND_SEVERITY_CRITICAL
	initial_flow = 3
	gauzed_clot_rate = 0.4
	internal_bleeding_chance = 80
	internal_bleeding_coefficient = 1.75
	threshold_penalty = 50
	status_effect_type = /datum/status_effect/wound/pierce/critical
	scar_keyword = "piercecritical"
	wound_flags = (ACCEPTS_GAUZE | MANGLES_EXTERIOR | CAN_BE_GRASPED)

	simple_treat_text = "<b>Наложение повязки</b> на рану имеет первостепенное значение, так же как и получение непосредственной медицинской помощи - <b>Смерть</b> наступит, если лечение будет задержано, так как недостаток <b>кислорода</b> убьет пациента, поэтому <b>Пища, Железо и солевой раствор</b> всегда рекомендуются после лечения. Эта рана не заживет самостоятельно."
	homemade_treat_text = "Простыни можно порвать, чтобы сделать <b>временные марлевые повязки</b>. <b>Мука, соль и соленая вода</b>, нанесенные на кожу, помогут. Падение на землю и удерживание раны снизит кровотечение."

/datum/wound_pregen_data/flesh_pierce/cavity
	abstract = FALSE

	wound_path_to_generate = /datum/wound/pierce/bleed/critical

	threshold_minimum = 100
