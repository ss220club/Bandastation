/mob/living/proc/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE, required_biotype = ALL, required_respiration_type = ALL)
	if(!can_adjust_oxy_loss(amount, forced, required_biotype, required_respiration_type))
		return 0
	. = oxyloss
	oxyloss = clamp((oxyloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	. -= oxyloss

	adjustOrganLoss(ORGAN_SLOT_BRAIN, oxyloss * 0.15)

	if(!.) // no change, no need to update
		return FALSE
	if(updating_health)
		updatehealth()
