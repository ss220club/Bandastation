/datum/objective/revenant

/datum/objective/revenant/New()
	target_amount = rand(350, 600)
	explanation_text = "Поглотите [target_amount] очков эссенции из живых существ."
	return ..()

/datum/objective/revenant/check_completion()
	if(!isrevenant(owner.current))
		return FALSE
	var/mob/living/basic/revenant/owner_mob = owner.current
	if(QDELETED(owner_mob) || owner_mob.stat == DEAD)
		return FALSE
	var/essence_stolen = owner_mob.essence_accumulated
	return essence_stolen >= target_amount

/datum/objective/revenant_fluff

/datum/objective/revenant_fluff/New()
	var/list/explanation_texts = list(
		"Усугубляйте существующие угрозы в критические моменты.",
		"Создавайте как можно больше хаоса и злости, не будучи убитыми.",
		"Наносите ущерб и делайте как можно больше частей станции ржавыми и непригодными для использования.",
		"Отключайте и вызывайте сбои в как можно большем количестве машин.",
		"Убедитесь, что любые священные оружия становятся непригодными для использования.",
		"Слушайте и подчиняйтесь просьбам мертвых, при условии, что их выполнение не будет слишком неудобным или саморазрушительным.",
		"Выдавайте себя за Бога или будьте почитаемы как Бог.",
		"Делайте капитана как можно более несчастным.",
		"Делайте клоуна как можно более несчастным.",
		"Делайте экипаж как можно более несчастным.",
		"Предотвращайте использование энергетического оружия, где это возможно.",
	)
	explanation_text = pick(explanation_texts)
	return ..()

/datum/objective/revenant_fluff/check_completion()
	return TRUE
