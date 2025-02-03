/obj/item/melee/garrote
	name = "fiber wire"
	desc = "A length of razor-thin wire with an elegant wooden handle on either end.<br>You suspect you'd have to be behind the target to use this weapon effectively."
	w_class = WEIGHT_CLASS_TINY
	icon = 'modular_bandastation/objects/icons/obj/weapons/misc.dmi'
	icon_state = "garrot_wrap"
	var/mob/living/carbon/human/strangling
	var/improvised = FALSE
	COOLDOWN_DECLARE(garrote_cooldown)

/obj/item/melee/garrote/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed)

/obj/item/melee/garrote/Destroy()
	strangling = null
	return ..()

/obj/item/melee/garrote/update_icon_state()
	if(strangling) // If we're strangling someone we want our icon to stay wielded
		icon_state = "garrot_[improvised ? "I_" : ""]unwrap"
	else
		icon_state = "garrot_[improvised ? "I_" : ""][HAS_TRAIT(src, TRAIT_WIELDED) ? "un" : ""]wrap"
	. = ..()

	/// Made via tablecrafting
/obj/item/melee/garrote/improvised
	name = "garrote"
	desc = "A length of cable with a shoddily-carved wooden handle tied to either end.<br>You suspect you'd have to be behind the target to use this weapon effectively."
	icon_state = "garrot_I_wrap"
	improvised = TRUE

/obj/item/melee/garrote/improvised/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, wield_callback = CALLBACK(src, PROC_REF(wield)))


/obj/item/melee/garrote/proc/wield(obj/item/source, mob/living/carbon/user)
	if(!strangling)
		return
	user.visible_message(
		span_notice("[user] removes [src] from [strangling]'s neck."),
		span_warning("You remove [src] from [strangling]'s neck.")
	)

	strangling = null
	update_icon(UPDATE_ICON_STATE)
	STOP_PROCESSING(SSobj, src)



/obj/item/melee/garrote/attack(mob/living/carbon/human/target, mob/living/carbon/user)
	if(!COOLDOWN_FINISHED(src, garrote_cooldown)) // Cooldown
		return
	if(!ishuman(user)) // spap_hand is a proc of /mob/living, user is simply /mob
		return
	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		to_chat(user, span_warning("You must use both hands to garrote [target]!"))
		return
	if(!ishuman(target))
		to_chat(user, span_warning("You don't think that garroting [target] would be very effective..."))
		return
	if(!check_behind(user, target) && !HAS_TRAIT(target, TRAIT_INCAPACITATED))
		to_chat(user, span_warning("You cannot use [src] on [target] from that angle!"))
		return
	if(improvised && ((target.head && (target.head.flags_cover & HEADCOVERSMOUTH)) || (target.wear_mask && (target.wear_mask.flags_cover & MASKCOVERSMOUTH)))) // Improvised garrotes are blocked by mouth-covering items.
		to_chat(user, span_warning("[target]'s neck is blocked by something [target.p_theyre()] wearing!"))
	if(strangling && strangling != target)
		to_chat(user, span_warning("You cannot use [src] on two people at once!"))
		return
	if(user.grab_state == GRAB_KILL)
		return

	if(user.grab_state < 1)
		target.grabbedby(user, TRUE)
		if(improvised)
			user.setGrabState(GRAB_AGGRESSIVE)
		else
			user.setGrabState(GRAB_NECK)
	else
		if(user.grab_state != GRAB_KILL)
			user.setGrabState(user.grab_state + 1)
	if(!strangling)
		playsound(loc, 'sound/items/weapons/cablecuff.ogg', 15, TRUE, -10, ignore_walls = FALSE)

	if(improvised) // Improvised garrotes start you off with a passive grab, but will lock you in place. A quick stun to drop items but not to make it unescapable
		target.Stun(1 SECONDS)
		//target.Immobilize(2 SECONDS)
	else
		target.adjust_silence(2 SECONDS)
	target.dir = user.dir
	COOLDOWN_START(src, garrote_cooldown, 6 SECONDS)
	START_PROCESSING(SSobj, src)
	strangling = target
	update_icon(UPDATE_ICON_STATE)

	target.visible_message(
		span_danger("[user] comes from behind and begins garroting [target] with [src]!"), \
		span_userdanger("[user] begins garroting you with [src]![improvised ? "" : " You are unable to speak!"]"), \
		"You hear struggling and wire strain against flesh!"
	)
	return

/obj/item/melee/garrote/process()
	if(!strangling)
		// Our mark got gibbed or similar
		update_icon(UPDATE_ICON_STATE)
		STOP_PROCESSING(SSobj, src)
		return


	if(!ishuman(loc))
		strangling = null
		update_icon(UPDATE_ICON_STATE)
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/living/carbon/human/user = loc
	strangling.dir = user.dir

	if(user.grab_state < 1 || !HAS_TRAIT(src, TRAIT_WIELDED))
		user.visible_message(
			span_warning("[user] loses [user.p_their()] grip on [strangling]'s neck."), \
			span_warning("You lose your grip on [strangling]'s neck.")
		)

		strangling = null
		update_icon(UPDATE_ICON_STATE)
		STOP_PROCESSING(SSobj, src)

		return

	if(user.grab_state < GRAB_NECK) // Only possible with improvised garrotes, essentially this will stun people as if they were aggressively grabbed. Allows for resisting out if you're quick, but not running away.
		strangling.Immobilize(3 SECONDS)

	if(improvised)
		strangling.adjust_stutter(6 SECONDS)
		strangling.apply_damage(2, OXY, "head")
		return


	strangling.adjust_silence(6 SECONDS) // Non-improvised effects
	if(user.grab_state == GRAB_KILL)
		//strangling.PreventOxyHeal(6 SECONDS)
		strangling.losebreath += 6
		strangling.apply_damage(4, OXY, "head")
		strangling.apply_damage(4, BRUTE, "head")
