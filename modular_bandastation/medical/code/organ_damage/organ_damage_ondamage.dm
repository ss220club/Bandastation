/mob/living/carbon/human/attack_effects(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	. = ..()
	switch(hit_zone)
		if(BODY_ZONE_HEAD)
			if(.)
				if(wear_mask)
					wear_mask.add_mob_blood(src)
					update_worn_mask()
				if(head)
					head.add_mob_blood(src)
					update_worn_head()
				if(glasses && prob(33))
					glasses.add_mob_blood(src)
					update_worn_glasses()

				// rev deconversion through blunt trauma.
				// this can be signalized to the rev datum
				if(mind && stat == CONSCIOUS && src != attacker && prob(damage_done + ((100 - health) * 0.5)))
					var/datum/antagonist/rev/rev = mind.has_antag_datum(/datum/antagonist/rev)
					rev?.remove_revolutionary(attacker)

		if(BODY_ZONE_CHEST)
			if(.)
				if(wear_suit)
					wear_suit.add_mob_blood(src)
					update_worn_oversuit()
				if(w_uniform)
					w_uniform.add_mob_blood(src)
					update_worn_undersuit()

			if(stat == CONSCIOUS && !attacking_item.get_sharpness() && !HAS_TRAIT(src, TRAIT_BRAWLING_KNOCKDOWN_BLOCKED) && attacking_item.damtype == BRUTE)
				if(prob(damage_done))
					visible_message(
						span_danger("[src] is knocked down!"),
						span_userdanger("You're knocked down!"),
					)
					apply_effect(6 SECONDS, EFFECT_KNOCKDOWN, armor_block)

	// Triggers force say events
	if(damage_done > 10 || (damage_done >= 5 && prob(33)))
		force_say()


/datum/species/handle_environment_pressure(mob/living/carbon/human/H, datum/gas_mixture/environment, seconds_per_tick, times_fired)
	var/pressure = environment.return_pressure()
	var/adjusted_pressure = H.calculate_affecting_pressure(pressure)

	// Set alerts and apply damage based on the amount of pressure
	switch(adjusted_pressure)
		// Very high pressure, show an alert and take damage
		if(HAZARD_HIGH_PRESSURE to INFINITY)
			if(HAS_TRAIT(H, TRAIT_RESISTHIGHPRESSURE))
				H.clear_alert(ALERT_PRESSURE)
			else
				var/pressure_damage = min(((adjusted_pressure / HAZARD_HIGH_PRESSURE) - 1) * PRESSURE_DAMAGE_COEFFICIENT, MAX_HIGH_PRESSURE_DAMAGE) * H.physiology.pressure_mod * H.physiology.brute_mod * seconds_per_tick
				H.adjustBruteLoss(pressure_damage, required_bodytype = BODYTYPE_ORGANIC)
				H.adjustOrganLoss(ORGAN_SLOT_LUNGS, pressure_damage, required_organ_flag = ORGAN_ORGANIC)
				H.throw_alert(ALERT_PRESSURE, /atom/movable/screen/alert/highpressure, 2)

		// High pressure, show an alert
		if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
			H.throw_alert(ALERT_PRESSURE, /atom/movable/screen/alert/highpressure, 1)

		// No pressure issues here clear pressure alerts
		if(WARNING_LOW_PRESSURE to WARNING_HIGH_PRESSURE)
			H.clear_alert(ALERT_PRESSURE)

		// Low pressure here, show an alert
		if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
			// We have low pressure resit trait, clear alerts
			if(HAS_TRAIT(H, TRAIT_RESISTLOWPRESSURE))
				H.clear_alert(ALERT_PRESSURE)
			else
				H.throw_alert(ALERT_PRESSURE, /atom/movable/screen/alert/lowpressure, 1)

		// Very low pressure, show an alert and take damage
		else
			// We have low pressure resit trait, clear alerts
			if(HAS_TRAIT(H, TRAIT_RESISTLOWPRESSURE))
				H.clear_alert(ALERT_PRESSURE)
			else
				var/pressure_damage = LOW_PRESSURE_DAMAGE * H.physiology.pressure_mod * H.physiology.brute_mod * seconds_per_tick
				H.adjustBruteLoss(pressure_damage, required_bodytype = BODYTYPE_ORGANIC)
				H.adjustOrganLoss(ORGAN_SLOT_LUNGS, pressure_damage, required_organ_flag = ORGAN_ORGANIC)
				H.throw_alert(ALERT_PRESSURE, /atom/movable/screen/alert/lowpressure, 2)
