/datum/wound/burn/flesh/handle_process(seconds_per_tick, times_fired)

	if (!victim || HAS_TRAIT(victim, TRAIT_STASIS))
		return

	. = ..()
	if(strikes_to_lose_limb == 0) // we've already hit sepsis, nothing more to do
		victim.adjustToxLoss(0.25 * seconds_per_tick)
		if(SPT_PROB(0.5, seconds_per_tick))
			victim.visible_message(span_danger("The infection on the remnants of [victim]'s [limb.plaintext_zone] shift and bubble nauseatingly!"), span_warning("You can feel the infection on the remnants of your [limb.plaintext_zone] coursing through your veins!"), vision_distance = COMBAT_MESSAGE_RANGE)
		return

	for(var/datum/reagent/reagent as anything in victim.reagents.reagent_list)
		if(reagent.chemical_flags & REAGENT_AFFECTS_WOUNDS)
			reagent.on_burn_wound_processing(src)

	if(HAS_TRAIT(victim, TRAIT_VIRUS_RESISTANCE))
		sanitization += 0.9

	if(limb.current_gauze)
		limb.seep_gauze(WOUND_BURN_SANITIZATION_RATE * seconds_per_tick)

	if(flesh_healing > 0) // good bandages multiply the length of flesh healing
		var/bandage_factor = limb.current_gauze?.burn_cleanliness_bonus || 1
		flesh_damage = max(flesh_damage - (0.5 * seconds_per_tick), 0)
		flesh_healing = max(flesh_healing - (0.5 * bandage_factor * seconds_per_tick), 0) // good bandages multiply the length of flesh healing

	// if we have little/no infection, the limb doesn't have much burn damage, and our nutrition is good, heal some flesh
	if(infestation <= WOUND_INFECTION_MODERATE && (limb.burn_dam < 5) && (victim.nutrition >= NUTRITION_LEVEL_FED))
		flesh_healing += 0.2

	// here's the check to see if we're cleared up
	if((flesh_damage <= 0) && (infestation <= WOUND_INFECTION_MODERATE))
		to_chat(victim, span_green("The burns on your [limb.plaintext_zone] have cleared up!"))
		qdel(src)
		return

	// sanitization is checked after the clearing check but before the actual ill-effects, because we freeze the effects of infection while we have sanitization
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
					to_chat(victim, span_warning("The blisters on your [limb.plaintext_zone] ooze a strange pus..."))

		if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
			if(!disabling)
				if(SPT_PROB(1, seconds_per_tick))
					to_chat(victim, span_warning("<b>Your [limb.plaintext_zone] completely locks up, as you struggle for control against the infection!</b>"))
					set_disabling(TRUE)
					if (rand(1, 100) >= 66.6)
						var/wound_type = /datum/wound/necrosis/basic_necro/moderate
						var/datum/wound/necrosis/basic_necro/moderate_wound = new wound_type()
						moderate_wound.apply_wound(limb,silent = TRUE,wound_source = "Burning infection progress")
						moderate_wound.necrosing_progress = 5
					return
			else if(SPT_PROB(4, seconds_per_tick))
				to_chat(victim, span_notice("You regain sensation in your [limb.plaintext_zone], but it's still in terrible shape!"))
				set_disabling(FALSE)
				return

			if(SPT_PROB(10, seconds_per_tick))
				victim.adjustToxLoss(0.5)

		if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
			if(!disabling)
				if(SPT_PROB(1.5, seconds_per_tick))
					to_chat(victim, span_warning("<b>You suddenly lose all sensation of the festering infection in your [limb.plaintext_zone]!</b>"))
					set_disabling(TRUE)
					if (rand(1, 100) >= 33.3)
						var/wound_type = /datum/wound/necrosis/basic_necro/moderate
						var/datum/wound/necrosis/basic_necro/moderate_wound = new wound_type()
						moderate_wound.apply_wound(limb,silent = TRUE,wound_source = "Burning infection progress")
						moderate_wound.necrosing_progress = 5
					return
			else if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(victim, span_notice("You can barely feel your [limb.plaintext_zone] again, and you have to strain to retain motor control!"))
				set_disabling(FALSE)
				return

			if(SPT_PROB(2.48, seconds_per_tick))
				if(prob(20))
					var/wound_type = /datum/wound/necrosis/basic_necro/moderate
					var/datum/wound/necrosis/basic_necro/moderate_wound = new wound_type()
					moderate_wound.apply_wound(limb,silent = TRUE,wound_source = "Burning infection progress")
					moderate_wound.necrosing_progress = 5
					to_chat(victim, span_warning("You contemplate life without your [limb.plaintext_zone]..."))
					victim.adjustToxLoss(0.75)
				else
					victim.adjustToxLoss(1)

		if(WOUND_INFECTION_SEPTIC to INFINITY)
			if(SPT_PROB(0.5 * infestation, seconds_per_tick))
				strikes_to_lose_limb--
				switch(strikes_to_lose_limb)
					if(2 to INFINITY)
						to_chat(victim, span_deadsay("<b>The infection in your [limb.plaintext_zone] is literally dripping off, you feel horrible!</b>"))
					if(1)
						to_chat(victim, span_deadsay("<b>Infection has just about completely claimed your [limb.plaintext_zone]!</b>"))
					if(0)
						to_chat(victim, span_deadsay("<b>The last of the nerve endings in your [limb.plaintext_zone] wither away, as the infection completely paralyzes your joint connector.</b>"))
						threshold_penalty = 120 // piss easy to destroy
						set_disabling(TRUE)
