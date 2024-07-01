
/*
	Piercing wounds
*/
/datum/wound/internal_bleed

/datum/wound/internal_bleed/bleed
	name = "Internal Bleeding"
	sound_effect = 'sound/weapons/slice.ogg'
	processes = TRUE
	treatable_tools = list(TOOL_HEMOSTAT)
	base_treat_time = 5 SECONDS
	wound_flags = MANGLES_INTERIOR

	/// How much blood we start losing when this wound is first applied
	var/initial_flow
	/// When hit on this bodypart, we have this chance of losing some blood + the incoming damage
	var/internal_bleeding_chance
	/// If we let off blood when hit, the max blood lost is this * the incoming damage
	var/internal_bleeding_coefficient
	/// Chance of heart attack due damage calculated by each tick
	var/heart_attack_chance
	/// Chance of lungs damage dealt by each tick
	var/lungs_damage

/datum/wound/internal_bleed/bleed/wound_injury(datum/wound/old_wound = null, attack_direction = null)
	set_blood_flow(initial_flow)
	if(limb.can_bleed() && attack_direction && victim.blood_volume > BLOOD_VOLUME_OKAY)
		victim.spray_blood(attack_direction, severity)

	return ..()

/datum/wound/internal_bleed/bleed/receive_damage(wounding_type, wounding_dmg, wound_bonus)
	if(victim.stat == DEAD || (wounding_dmg < 5) || !limb.can_bleed() || !victim.blood_volume || !prob(internal_bleeding_chance + wounding_dmg))
		return
	var/blood_bled = rand(1, wounding_dmg * internal_bleeding_coefficient) // 12 brute toolbox can cause up to 15/18/21 bloodloss on mod/sev/crit
	switch(blood_bled)
		if(1 to 6)
			victim.bleed(blood_bled, TRUE)
		if(7 to 13)
			victim.visible_message("<span class='smalldanger'>Blood droplets fly from [victim]'s mouth.</span>", span_danger("You cough up a bit of blood from the blow."), vision_distance=COMBAT_MESSAGE_RANGE)
			victim.bleed(blood_bled, TRUE)
		if(14 to 19)
			victim.visible_message("<span class='smalldanger'>A small stream of blood spurts from [victim]'s mouth!</span>", span_danger("You spit out a string of blood from the blow!"), vision_distance=COMBAT_MESSAGE_RANGE)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
			victim.bleed(blood_bled)
		if(20 to INFINITY)
			victim.visible_message(span_danger("A spray of blood streams from [victim]'s mouth!"), span_danger("<b>You choke up on a spray of blood from the blow!</b>"), vision_distance=COMBAT_MESSAGE_RANGE)
			victim.bleed(blood_bled)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
			victim.add_splatter_floor(get_step(victim.loc, victim.dir))

/datum/wound/internal_bleed/bleed/get_bleed_rate_of_change()
	//basically if a species doesn't bleed, the wound is stagnant and will not heal on it's own (nor get worse)
	if(!limb.can_bleed())
		return BLOOD_FLOW_STEADY
	if(HAS_TRAIT(victim, TRAIT_BLOODY_MESS))
		return BLOOD_FLOW_INCREASING
	return BLOOD_FLOW_STEADY

/datum/wound/internal_bleed/bleed/handle_process(seconds_per_tick, times_fired)
	if (!victim || HAS_TRAIT(victim, TRAIT_STASIS))
		return

	set_blood_flow(min(blood_flow, WOUND_SLASH_MAX_BLOODFLOW))

	if(limb.can_bleed())
		if(victim.bodytemperature < (BODYTEMP_NORMAL - 10))
			adjust_blood_flow(-0.1 * seconds_per_tick)
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(victim, span_notice("You feel the [LOWER_TEXT(name)] in your [limb.plaintext_zone] firming some sort of buldge!"))

		if(HAS_TRAIT(victim, TRAIT_BLOODY_MESS))
			adjust_blood_flow(0.25 * seconds_per_tick) // old heparin used to just add +2 bleed stacks per tick, this adds 0.5 bleed flow to all open cuts which is probably even stronger as long as you can cut them first

	var/obj/item/bodypart/chest/chest = victim.get_bodypart(BODY_ZONE_CHEST)
	if (heart_attack_chance > 0 && limb == chest && rand(0,100) < heart_attack_chance)
		var/datum/disease/heart_failure/heart_attack = new(src)
		heart_attack.stage_prob = 5 //Advances twice as fast
		victim.ForceContractDisease(heart_attack)

	var/obj/item/organ/internal/lungs/lungs = victim.get_organ_by_type(/obj/item/organ/internal/lungs)
	if (lungs_damage > 0 && !isnull(lungs) && limb == chest)
		lungs.apply_organ_damage(lungs_damage)


	if(blood_flow <= 0)
		qdel(src)

/datum/wound/internal_bleed/bleed/on_stasis(seconds_per_tick, times_fired)
	. = ..()
	if(blood_flow <= 0)
		qdel(src)

/datum/wound/internal_bleed/bleed/treat(obj/item/I, mob/user)
	if(I.tool_behaviour == TOOL_HEMOSTAT || I.get_temperature())
		return tool_clamping(I, user)

/datum/wound/internal_bleed/bleed/on_xadone(power)
	. = ..()

	if (limb) // parent can cause us to be removed, so its reasonable to check if we're still applied
		adjust_blood_flow(-0.03 * power) // i think it's like a minimum of 3 power, so .09 blood_flow reduction per tick is pretty good for 0 effort

/// Полевое лечение
/datum/wound/internal_bleed/bleed/proc/tool_clamping(obj/item/I, mob/user)

	var/improv_penalty_mult = (I.tool_behaviour == TOOL_HEMOSTAT ? 1 : 1.25) // 25% longer and less effective if you don't use a real hemostat
	var/self_penalty_mult = (user == victim ? 1.5 : 1) // 50% longer and less effective if you do it to yourself
	var/pierce_founded = FALSE
	var/treatment_delay = base_treat_time * self_penalty_mult * improv_penalty_mult

	if(HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		treatment_delay *= 0.5
		user.visible_message(span_danger("[user] begins expertly restore internals in [victim]'s [limb.plaintext_zone] with [I]..."), span_warning("You begin restoring internals in [user == victim ? "your" : "[victim]'s"] [limb.plaintext_zone] with [I], keeping the holo-image indications in mind..."))
	else
		user.visible_message(span_danger("[user] begins restoring internals in [victim]'s [limb.plaintext_zone] with [I]..."), span_warning("You begin restoring internals in [user == victim ? "your" : "[victim]'s"] [limb.plaintext_zone] with [I]..."))

	for(var/limb_wound in limb.wounds)
		var/datum/wound/current_wound = limb_wound
		if(istype(current_wound, /datum/wound/pierce/bleed))
			pierce_founded = TRUE

	if (!(pierce_founded))
		return TRUE

	if(!do_after(user, treatment_delay, target = victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return TRUE

	var/bleeding_wording = (!limb.can_bleed() ? "holes" : "bleeding")
	user.visible_message(span_green("[user] restore internals in [victim]."), span_green("You restore internals with reducing some of the [bleeding_wording] on [victim]."))
	if(prob(30))
		victim.emote("scream")
	var/blood_cauterized = (0.6 / (self_penalty_mult * improv_penalty_mult))
	adjust_blood_flow(-blood_cauterized)

	if(blood_flow > 0)
		return try_treating(I, user)
	return TRUE

/datum/wound_pregen_data/flesh_internal_bleed
	abstract = TRUE

	required_limb_biostate = (BIO_FLESH)
	required_wounding_types = list(WOUND_BLUNT)

	wound_series = WOUND_SERIES_INTERNAL_BLEED

/datum/wound/internal_bleed/get_limb_examine_description()
	return span_warning("The flesh on this limb appears heavy buldged")

/datum/wound/internal_bleed/bleed/moderate
	name = "Minor internal bleeding"
	desc = "Patient's skin has been formed some kind of bulge. Look a like there is a little intrnal bleed."
	treat_text = "Treat affected site with cautarizing inside after piecring patient's skin." // space is cold in ss13, so it's like an ice pack!
	examine_desc = "has a small bulge"
	occur_text = "spurts out a thin stream of blood"
	severity = WOUND_SEVERITY_MODERATE
	initial_flow = 6.0
	internal_bleeding_chance = 50
	internal_bleeding_coefficient = 3.75
	threshold_penalty = 5
	heart_attack_chance = 0
	lungs_damage = 0
	status_effect_type = /datum/status_effect/wound/internal_bleed/moderate

	simple_treat_text = "<b>Internal bleeding operation</b> the wound will remove blood loss, help the wound close by itself quicker, and speed up the blood recovery period."
	homemade_treat_text = "<b>Cauterizing</b> can help to close wounds inside, but you need some small hole to get there."

/datum/wound_pregen_data/flesh_internal_bleed/light_ib
	abstract = FALSE

	wound_path_to_generate = /datum/wound/internal_bleed/bleed/moderate

	threshold_minimum = 40

/datum/wound/internal_bleed/bleed/moderate/update_descriptions()
	if(!limb.can_bleed())
		examine_desc = "has a small, circular hole"
		occur_text = "splits a small hole open"

/datum/wound/internal_bleed/bleed/severe
	name = "Noticable internal bleeding"
	desc = "Patient's internal tissue is penetrated, causing sizeable internal bleeding and reduced limb stability."
	treat_text = "Repair internals under skin by cautery throught some kind of hole."
	examine_desc = "is a noticable buldge under skin on their limb"
	occur_text = "looses a violent spray of blood"
	severity = WOUND_SEVERITY_SEVERE
	initial_flow = 8
	internal_bleeding_chance = 100
	internal_bleeding_coefficient = 4.25
	threshold_penalty = 15
	heart_attack_chance = 100
	lungs_damage = 1
	status_effect_type = /datum/status_effect/wound/internal_bleed/severe

	simple_treat_text = "<b>Internal bleeding operation</b> the wound will remove blood loss, help the wound close by itself quicker, and speed up the blood recovery period."
	homemade_treat_text = "<b>Cauterizing</b> can help to close wounds inside, but you need some small hole to get there."

/datum/wound_pregen_data/flesh_internal_bleed/medium_ib
	abstract = FALSE

	wound_path_to_generate = /datum/wound/internal_bleed/bleed/severe

	threshold_minimum = 55

/datum/wound/internal_bleed/bleed/severe/update_descriptions()
	if(!limb.can_bleed())
		occur_text = "tears a hole open"

/datum/wound/internal_bleed/bleed/critical
	name = "Ruptured internals"
	desc = "Patient's internal tissue and circulatory system is shredded, causing significant internal bleeding and damage to internal organs."
	treat_text = "Surgical repair of internal bleeding throught puncture wound, followed by supervised resanguination."
	examine_desc = "is forming big buldge under their skin and you hear some sorts of hoarseness"
	occur_text = "blasts apart, sending chunks of viscera flying in all directions"
	severity = WOUND_SEVERITY_CRITICAL
	initial_flow = 10
	internal_bleeding_chance = 150
	internal_bleeding_coefficient = 4.75
	threshold_penalty = 25
	heart_attack_chance = 2
	lungs_damage = 5
	status_effect_type = /datum/status_effect/wound/internal_bleed/critical

	simple_treat_text = "<b>Internal bleeding operation</b> the wound will remove blood loss, help the wound close by itself quicker, and speed up the blood recovery period."
	homemade_treat_text = "<b>Cauterizing</b> can help to close wounds inside, but you need some small hole to get there."

/datum/wound_pregen_data/flesh_internal_bleed/heavy_ib
	abstract = FALSE

	wound_path_to_generate = /datum/wound/internal_bleed/bleed/critical

	threshold_minimum = 70
