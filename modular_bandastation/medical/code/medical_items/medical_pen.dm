/obj/item/flashlight/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/turf/user_turf = user.loc
	if(!isturf(user_turf))
		return
	var/light_strength = light_power + user_turf.get_lumcount() - 0.5

	if(!ishuman(interacting_with))
		return NONE
	if(!light_on)
		return NONE
	add_fingerprint(user)
	if(user.combat_mode || (user.zone_selected != BODY_ZONE_PRECISE_EYES && user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		return NONE
	if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50)) //too dumb to use flashlight properly
		return ITEM_INTERACT_SKIP_TO_ATTACK //just hit them in the head

	. = ITEM_INTERACT_BLOCKING
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return
	var/mob/living/scanning = interacting_with
	if(!scanning.get_bodypart(BODY_ZONE_HEAD))
		to_chat(user, span_warning("[scanning] doesn't have a head!"))
		return
	if(light_strength < 1)
		to_chat(user, span_warning("[src] isn't bright enough to see anything!"))
		return

	var/list/render_list = list()
	switch(user.zone_selected)
		if(BODY_ZONE_PRECISE_EYES)
			render_list += eye_examine(scanning, user)
		if(BODY_ZONE_PRECISE_MOUTH)
			render_list += mouth_examine(scanning, user)

	if(length(render_list))
		//display our packaged information in an examine block for easy reading
		to_chat(user, examine_block(jointext(render_list, "")), type = MESSAGE_TYPE_INFO)
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/item/flashlight/eye_examine(mob/living/carbon/human/M, mob/living/user)
	. = list()
	if((M.head && M.head.flags_cover & HEADCOVERSEYES) || (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) || (M.glasses && M.glasses.flags_cover & GLASSESCOVERSEYES))
		to_chat(user, span_warning("You're going to need to remove that [(M.head && M.head.flags_cover & HEADCOVERSEYES) ? "helmet" : (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) ? "mask": "glasses"] first!"))
		return

	var/obj/item/organ/internal/eyes/E = M.get_organ_slot(ORGAN_SLOT_EYES)
	var/obj/item/organ/internal/brain = M.get_organ_slot(ORGAN_SLOT_BRAIN)
	var/obj/item/organ/internal/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if(!E)
		to_chat(user, span_warning("[M] doesn't have any eyes!"))
		return

	M.flash_act(visual = TRUE, length = (user.combat_mode) ? 2.5 SECONDS : 1 SECONDS) // Apply a 1 second flash effect to the target. The duration increases to 2.5 Seconds if you have combat mode on.

	if(M == user) //they're using it on themselves
		user.visible_message(span_warning("[user] shines [src] into [M.p_their()] eyes."), ignored_mobs = user)
		. += span_info("You direct [src] to into your eyes:\n")

		if(M.is_blind())
			. += "<span class='notice ml-1'>You're not entirely certain what you were expecting...</span>\n"
		else
			. += "<span class='notice ml-1'>Trippy!</span>\n"

	else
		user.visible_message(span_warning("[user] directs [src] to [M]'s eyes."), ignored_mobs = user)
		. += span_info("You direct [src] to [M]'s eyes:\n")

		if(M.stat == DEAD || M.is_blind() || M.get_eye_protection() > FLASH_PROTECTION_WELDER)
			. += "<span class='danger ml-1'>[M.p_Their()] pupils don't react to the light!</span>\n"//mob is dead
		else if(liver.damage < 20 && E.damage < 10 && liver.damage < 20)
			. += "<span class='notice ml-1'>[M.p_Their()] pupils narrow.</span>\n"//they're okay :D
		if(brain.damage > 20)
			. += "<span class='danger ml-1'>[M.p_Their()] pupils contract unevenly!</span>\n"//mob has sustained damage to their brain
		if(E.damage > 10)
			. += "<span class='danger ml-1'>[M.p_Their()] eyes have some damaged veins!</span>\n"//mob has sustained damage to their eyes
		if(liver.damage > 20)
			. += "<span class='danger ml-1'>[M.p_Their()] eyes have strange color around them!</span>\n"//mob has sustained damage to their liver

		if(M.dna && M.dna.check_mutation(/datum/mutation/human/xray))
			. += "<span class='danger ml-1'>[M.p_Their()] pupils give an eerie glow!</span>\n"//mob has X-ray vision

	return .
