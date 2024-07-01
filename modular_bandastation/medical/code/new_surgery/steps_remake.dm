/datum/surgery/debride
	name = "Debride burnt flesh"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = list(/datum/wound/burn/flesh,/datum/wound/necrosis/basic_necro)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/debride,
		/datum/surgery_step/dress,
	)

/datum/surgery/debride/can_start(mob/living/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return .

/datum/surgery/debride/can_start(mob/living/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return .

	var/datum/wound/burn/flesh/burn_wound = target.get_bodypart(user.zone_selected).get_wound_type(/datum/wound/burn/flesh)
	var/datum/wound/necrosis/basic_necro/necro_wound = target.get_bodypart(user.zone_selected).get_wound_type(/datum/wound/necrosis/basic_necro)
	// Should be guaranteed to have the wound by this point
	ASSERT(burn_wound, "[type] on [target] has no burn or infected wound when it should have been guaranteed to have one by can_start")
	if (!isnull(burn_wound))
		return burn_wound.infestation > 0
	if (!isnull(necro_wound))
		return necro_wound.necrosing_progress > 0

/datum/surgery_step/debride
	name = "excise infection (hemostat)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCALPEL = 85,
		TOOL_SAW = 60,
		TOOL_WIRECUTTER = 40)
	time = 30
	repeatable = TRUE
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'
	surgery_effects_mood = TRUE

	var/necrosis_removed = 4

/datum/surgery_step/debride/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/necrosis/basic_necro/necro_wound
	var/list_data = target.get_wounded_bodyparts()
	for(var/obj/item/bodypart/limb in (list_data))
		for(var/limb_wound in limb.wounds)
			var/datum/wound/current_wound = limb_wound
			if(istype(current_wound, /datum/wound/necrosis/basic_necro/))
				necro_wound = current_wound
	var/datum/wound/burn/flesh/burn_wound = surgery.operated_wound
	if(burn_wound)
		var/progress_text = get_progress(user, target, burn_wound)
		display_results(
			user,
			target,
			span_notice("You successfully excise some of the infected flesh from [target]'s [target.parse_zone_with_bodypart(target_zone)][progress_text]."),
			span_notice("[user] successfully excises some of the infected flesh from [target]'s [target.parse_zone_with_bodypart(target_zone)] with [tool]!"),
			span_notice("[user] successfully excises some of the infected flesh from  [target]'s [target.parse_zone_with_bodypart(target_zone)]!"),
		)
		log_combat(user, target, "excised infected flesh in", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
		surgery.operated_bodypart.receive_damage(brute=3, wound_bonus=CANT_WOUND)
		burn_wound.infestation -= infestation_removed
		burn_wound.sanitization += sanitization_added
		necro_wound.necrosing_progress -= necrosis_removed
		if(burn_wound.infestation <= 0)
			repeatable = FALSE
	else
		to_chat(user, span_warning("[target] has no infected flesh there!"))
	return ..()

/datum/surgery_step/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	var/screwedmessage = ""
	switch(fail_prob)
		if(0 to 24)
			screwedmessage = " You almost had it, though."
		if(50 to 74)//25 to 49 = no extra text
			screwedmessage = " This is hard to get right in these conditions..."
		if(75 to 99)
			screwedmessage = " This is practically impossible in these conditions..."

	display_results(
		user,
		target,
		span_warning("You screw up![screwedmessage]"),
		span_warning("[user] screws up!"),
		span_notice("[user] finishes."), TRUE) //By default the patient will notice if the wrong thing has been cut

	if (rand(1,100) > 20)
		var/wound_type = /datum/wound/necrosis/basic_necro/moderate
		var/datum/wound/necrosis/basic_necro/moderate_wound = new wound_type()
		moderate_wound.apply_wound(surgery.operated_bodypart,silent = TRUE)

	return FALSE
