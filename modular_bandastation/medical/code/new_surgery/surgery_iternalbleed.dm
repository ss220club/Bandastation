/datum/surgery/iternal_bleed
	name = "Internal bleeding treatment"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/internal_bleed/bleed
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_ib,
		/datum/surgery_step/close
	)

/datum/surgery/fix_ib/can_start(mob/living/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return .

	var/datum/wound/internal_bleed/bleed/ib_wound = target.get_bodypart(user.zone_selected).get_wound_type(targetable_wound)
	// Should be guaranteed to have the wound by this point
	ASSERT(ib_wound, "[type] on [target] has no internal bleeding and operation can not be started")
	return ib_wound.blood_flow > 0

//SURGERY STEPS

///// Debride
/datum/surgery_step/fix_ib
	name = "fix internal bleeding (hemostat)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCALPEL = 85,
		TOOL_WIRECUTTER = 60,
		TOOL_SAW = 40)
	time = 30
	repeatable = TRUE
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'
	surgery_effects_mood = TRUE
	/// How much infestation is removed per step (positive number)
	var/blood_flow_removed = 4

/// To give the surgeon a heads up how much work they have ahead of them
/datum/surgery_step/fix_ib/proc/get_progress(mob/user, mob/living/carbon/target, datum/wound/internal_bleed/bleed/ib_wound)
	if(!ib_wound?.blood_flow || !blood_flow_removed)
		return
	var/estimated_remaining_steps = ib_wound.blood_flow / blood_flow_removed
	var/progress_text

	switch(estimated_remaining_steps)
		if(-INFINITY to 1)
			return
		if(1 to 2)
			progress_text = ", preparing to remove the last remaining bits of infection"
		if(2 to 4)
			progress_text = ", steadily narrowing the remaining bits of infection"
		if(5 to INFINITY)
			progress_text = ", though there's still quite a lot to excise"

	return progress_text

/datum/surgery_step/fix_ib/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		var/datum/wound/internal_bleed/bleed/IB_wound = surgery.operated_wound
		if(IB_wound.blood_flow <= 0)
			to_chat(user, span_notice("[target]'s [target.parse_zone_with_bodypart(user.zone_selected)] has no internal traumas to remove!"))
			surgery.status++
			repeatable = FALSE
			return
		display_results(
			user,
			target,
			span_notice("You begin to fix internal traumas from [target]'s [target.parse_zone_with_bodypart(user.zone_selected)]..."),
			span_notice("[user] begins to fix internal traumas from [target]'s [target.parse_zone_with_bodypart(user.zone_selected)] with [tool]."),
			span_notice("[user] begins to fix internal traumas from [target]'s [target.parse_zone_with_bodypart(user.zone_selected)]."),
		)
		display_pain(target, "The internal bleeding in your [target.parse_zone_with_bodypart(user.zone_selected)] stings like hell! It feels like you're being teared apart!")
	else
		user.visible_message(span_notice("[user] looks for [target]'s [target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("You look for [target]'s [target.parse_zone_with_bodypart(user.zone_selected)]..."))

/datum/surgery_step/fix_ib/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/internal_bleed/bleed/IB_wound = surgery.operated_wound
	if(IB_wound)
		var/progress_text = get_progress(user, target, IB_wound)
		display_results(
			user,
			target,
			span_notice("You successfully fix internal traumasfrom [target]'s [target.parse_zone_with_bodypart(target_zone)][progress_text]."),
			span_notice("[user] successfully fix internal traumas from [target]'s [target.parse_zone_with_bodypart(target_zone)] with [tool]!"),
			span_notice("[user] successfully fix internal traumas from  [target]'s [target.parse_zone_with_bodypart(target_zone)]!"),
		)
		log_combat(user, target, "fixed internal traumas in", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
		surgery.operated_bodypart.receive_damage(brute=2, wound_bonus=CANT_WOUND)
		IB_wound.blood_flow -= blood_flow_removed
		if(IB_wound.blood_flow <= 0)
			repeatable = FALSE
	else
		to_chat(user, span_warning("[target] has no internal traumas there!"))
	return ..()

/datum/surgery_step/fix_ib/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	var/datum/wound/internal_bleed/bleed/IB_wound = surgery.operated_wound
	display_results(
		user,
		target,
		span_notice("You fingers slip and you accidently damaged some insides in [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] fingers slip and you accidently damaged some insides in [target]'s [target.parse_zone_with_bodypart(target_zone)] with [tool]!"),
		span_notice("[user] fingers slip and you accidently damaged some insides in [target]'s [target.parse_zone_with_bodypart(target_zone)]!"),
	)
	surgery.operated_bodypart.receive_damage(brute=rand(3,5), sharpness=TRUE)
	IB_wound.blood_flow += blood_flow_removed

/datum/surgery_step/fix_ib/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	var/datum/wound/internal_bleed/bleed/IB_wound = surgery.operated_wound
	while(IB_wound && IB_wound.blood_flow > 0.25)
		if(!..())
			break
