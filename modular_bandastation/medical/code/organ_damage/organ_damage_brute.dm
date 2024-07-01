/mob/living/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype = ALL)
	if (!can_adjust_brute_loss(amount, forced, required_bodytype))
		return 0
	. = bruteloss
	bruteloss = clamp((bruteloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	. -= bruteloss

	switch(required_bodytype)
		if(BODY_ZONE_HEAD)
			if(!HAS_TRAIT(src, TRAIT_HEAD_INJURY_BLOCKED))
				if(prob(amount))
					adjustOrganLoss(ORGAN_SLOT_BRAIN, bruteloss * 0.5)
					if(stat == CONSCIOUS)
						visible_message(
							span_danger("[src] is knocked senseless!"),
							span_userdanger("You're knocked senseless!"),
						)
						set_confusion_if_lower(20 SECONDS)
						adjust_eye_blur(20 SECONDS)
					if(prob(10))
						gain_trauma(/datum/brain_trauma/mild/concussion)
				else
					adjustOrganLoss(ORGAN_SLOT_BRAIN, bruteloss * 0.2)
		if(BODY_ZONE_CHEST)
			if(prob(amount))
				adjustOrganLoss(ORGAN_SLOT_STOMACH, bruteloss * 0.3)
				if(BODY_ZONE_CHEST)
			if(prob(amount))
				adjustOrganLoss(ORGAN_SLOT_LUNGS, bruteloss * 0.2)
		if(BODY_ZONE_PRECISE_GROIN)
			if(prob(amount))
				adjustOrganLoss(ORGAN_SLOT_LIVER, bruteloss * 0.4)

	if(!.) // no change, no need to update
		return 0
	if(updating_health)
		updatehealth()
