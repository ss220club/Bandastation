#define CPR_PANIC_SPEED (2 SECONDS)

/// Убрана проверка на смерть, идет посыл сигнала проведение СЛР
/mob/living/carbon/human/do_cpr(mob/living/carbon/target)
	if(target == src)
		return

	var/panicking = FALSE

	do
		CHECK_DNA_AND_SPECIES(target)

		if (DOING_INTERACTION_WITH_TARGET(src,target))
			return FALSE

		if (is_mouth_covered())
			balloon_alert(src, "remove your mask first!")
			return FALSE

		if (target.is_mouth_covered())
			balloon_alert(src, "remove [target.p_their()] mask first!")
			return FALSE

		if(HAS_TRAIT_FROM(src, TRAIT_NOBREATH, DISEASE_TRAIT))
			to_chat(src, span_warning("you can't breathe!"))
			return FALSE

		var/obj/item/organ/internal/lungs/human_lungs = get_organ_slot(ORGAN_SLOT_LUNGS)
		if(isnull(human_lungs))
			balloon_alert(src, "you don't have lungs!")
			return FALSE
		if(human_lungs.organ_flags & ORGAN_FAILING)
			balloon_alert(src, "your lungs are too damaged!")
			return FALSE

		visible_message(span_notice("[src] is trying to perform CPR on [target.name]!"), \
						span_notice("You try to perform CPR on [target.name]... Hold still!"))

		if (!do_after(src, delay = panicking ? CPR_PANIC_SPEED : (3 SECONDS), target = target))
			balloon_alert(src, "you fail to perform CPR!")
			return FALSE

		if (target.health > target.crit_threshold)
			return FALSE

		visible_message(span_notice("[src] performs CPR on [target.name]!"), span_notice("You perform CPR on [target.name]."))
		if(HAS_MIND_TRAIT(src, TRAIT_MORBID))
			add_mood_event("morbid_saved_life", /datum/mood_event/morbid_saved_life)
		else
			add_mood_event("saved_life", /datum/mood_event/saved_life)
		log_combat(src, target, "CPRed")

		if (HAS_TRAIT(target, TRAIT_NOBREATH))
			to_chat(target, span_unconscious("You feel a breath of fresh air... which is a sensation you don't recognise..."))
		else if (!target.get_organ_slot(ORGAN_SLOT_LUNGS))
			to_chat(target, span_unconscious("You feel a breath of fresh air... but you don't feel any better..."))
		else
			target.apply_status_effect(/datum/status_effect/cpred)
			if (!(target.stat == DEAD || HAS_TRAIT(target, TRAIT_FAKEDEATH)))
				target.adjustOxyLoss(-min(target.getOxyLoss(), 7))
				to_chat(target, span_unconscious("You feel a breath of fresh air enter your lungs... It feels good..."))

		if (target.health <= target.crit_threshold)
			if (!panicking)
				to_chat(src, span_warning("[target] still isn't up! You try harder!"))
			panicking = TRUE
		else
			panicking = FALSE

	while (panicking)
#undef CPR_PANIC_SPEED
