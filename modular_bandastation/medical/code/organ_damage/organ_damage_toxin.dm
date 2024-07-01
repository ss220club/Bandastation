/mob/living/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE, required_biotype = ALL)
	if(!can_adjust_tox_loss(amount, forced, required_biotype))
		return 0

	if(!forced && HAS_TRAIT(src, TRAIT_TOXINLOVER)) //damage becomes healing and healing becomes damage
		amount = -amount
		if(HAS_TRAIT(src, TRAIT_TOXIMMUNE)) //Prevents toxin damage, but not healing
			amount = min(amount, 0)
		if(blood_volume)
			if(amount > 0)
				blood_volume = max(blood_volume - (5 * amount), 0)
			else
				blood_volume = max(blood_volume - amount, 0)

	else if(!forced && HAS_TRAIT(src, TRAIT_TOXIMMUNE)) //Prevents toxin damage, but not healing
		amount = min(amount, 0)

	. = toxloss
	toxloss = clamp((toxloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	if(prob(amount))
		adjustOrganLoss(ORGAN_SLOT_LIVER, toxloss * 0.2,required_organ_flag = ORGAN_ORGANIC)
		toxloss -= toxloss * 0.2
	. -= toxloss

	if(!.) // no change, no need to update
		return FALSE

	if(updating_health)
		updatehealth()
