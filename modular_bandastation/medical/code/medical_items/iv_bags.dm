#define ALERT_IV_CONNECTED "iv_connected"
///Minimum possible IV drip transfer rate in units per second
#define MIN_IV_TRANSFER_RATE 0
///Maximum possible IV drip transfer rate in units per second
#define MAX_IV_TRANSFER_RATE 5
///What the transfer rate value is rounded to
#define IV_TRANSFER_RATE_STEP 0.01
///Default IV drip transfer rate in units per second
#define DEFAULT_IV_TRANSFER_RATE 5

/obj/item/reagent_containers/chem_pack/click_alt(mob/living/user)
	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50)))
		to_chat(user, span_warning("Uh... whoops! You accidentally spill the content of the bag onto yourself."))
		SplashReagents(user)
		return CLICK_ACTION_BLOCKING

	if(sealed)
		reagents.flags = NONE
		reagent_flags = REFILLABLE | DRAINABLE | TRANSPARENT //To allow for sabotage or ghetto use.
		reagents.flags = reagent_flags
		spillable = TRUE
		sealed = FALSE
		balloon_alert(user, "unsealed")
		return CLICK_ACTION_SUCCESS
	else
		reagents.flags = NONE
		reagent_flags = DRAWABLE | INJECTABLE //To allow for sabotage or ghetto use.
		reagents.flags = reagent_flags
		spillable = FALSE
		sealed = TRUE
		balloon_alert(user, "sealed")
		return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/chem_pack/examine()
	. = ..()
	if(sealed)
		. += span_notice("The bag is sealed shut. Alt-click to unseal it.")
	else
		. += span_notice("The bag is open. Alt-click to seal it.")

/obj/item/reagent_containers/blood
	name = "blood pack"
	desc = "Contains blood used for transfusion. Can be attached to an IV drip."
	icon = 'icons/obj/medical/bloodpack.dmi'
	icon_state = "bloodpack"
	volume = 200
	var/sealed = TRUE
	var/injecting = TRUE
	var/injection_target
	var/transfer_rate = DEFAULT_IV_TRANSFER_RATE
	fill_icon_thresholds = list(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)

/obj/item/reagent_containers/blood/click_alt(mob/living/user)
	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50)) && !sealed)
		to_chat(user, span_warning("Uh... whoops! You accidentally spill the content of the bag onto yourself."))
		SplashReagents(user)
		return CLICK_ACTION_BLOCKING

	if(sealed)
		reagents.flags = NONE
		reagent_flags = REFILLABLE | DRAINABLE | TRANSPARENT //To allow for sabotage or ghetto use.
		reagents.flags = reagent_flags
		spillable = TRUE
		sealed = FALSE
		balloon_alert(user, "unsealed")
		return CLICK_ACTION_SUCCESS
	else
		reagents.flags = NONE
		reagent_flags = DRAWABLE | INJECTABLE //To allow for sabotage or ghetto use.
		reagents.flags = reagent_flags
		spillable = FALSE
		sealed = TRUE
		balloon_alert(user, "sealed")
		return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/blood/click_alt_secondary(mob/user)
	. = ..()
	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50)) && !sealed)
		to_chat(user, span_warning("Uh... whoops! You accidentally spill the content of the bag onto yourself."))
		SplashReagents(user)
		return CLICK_ACTION_BLOCKING

	if(injecting)
		injecting = FALSE
		balloon_alert(user, "Draw")
		return CLICK_ACTION_SUCCESS
	else
		injecting = TRUE
		balloon_alert(user, "Inject")
		return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/blood/examine()
	. = ..()
	if(sealed)
		. += span_notice("The bag is sealed shut. Alt-click to unseal it.")
	else
		. += span_notice("The bag is open. Alt-click to seal it.")
	if(injecting)
		. += span_notice("The bag is in inject mode and will transfer to patient.")
	else
		. += span_notice("The bag is in draw mode and will transfer from patient.")

/obj/item/reagent_containers/blood/interact_with_atom(atom/target, mob/user, proximity)

	if(!proximity)
		return
	if(!target.reagents)
		return

	if(isliving(target))
		var/mob/living/L = target
		if(injection_target) // Removing the needle
			detach_iv(user)
		else // Inserting the needle
			attach_iv(L,user)

	else if(target.is_refillable() && is_drainable()) // Transferring from IV bag to other containers
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>[src] is empty.</span>")
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, "<span class='warning'>[target] is full.</span>")
			return

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to [target].</span>")

/obj/item/reagent_containers/blood/proc/get_reagents()
	return src?.reagents

/obj/item/reagent_containers/blood/proc/attach_iv(atom/target, mob/user)
	if(isliving(target))
		user.visible_message(span_warning("[usr] begins attaching [src] to [target]..."), span_warning("You begin attaching [src] to [target]."))
		if(!do_after(usr, 3 SECONDS, target))
			return
	else
		injecting = TRUE
	if (target == user)
		injecting = FALSE
	else
		injecting = TRUE
	usr.visible_message(span_warning("[usr] attaches [src] to [target]."), span_notice("You attach [src] to [target]."))
	var/datum/reagents/container = get_reagents()
	log_combat(usr, target, "attached", src, "containing: ([container.get_reagent_log_string()])")
	add_fingerprint(usr)
	if(isliving(target))
		var/mob/living/target_mob = target
		target_mob.throw_alert(ALERT_IV_CONNECTED, /atom/movable/screen/alert/iv_connected)
	injection_target = target
	START_PROCESSING(SSmachines, src)
	update_appearance(UPDATE_ICON)

	SEND_SIGNAL(src, COMSIG_IV_ATTACH, target)

/obj/item/reagent_containers/blood/proc/detach_iv(mob/user)
	if(isliving(injection_target))
		user.visible_message(span_warning("[usr] begins detaching [src] to [injection_target]..."), span_warning("You begin detaching [src] to [injection_target]."))
		if(!do_after(usr, 3 SECONDS, injection_target))
			return
	if(injection_target)
		visible_message(span_notice("[injection_target] is detached from [src]."))
		if(isliving(injection_target))
			var/mob/living/attached_mob = injection_target
			attached_mob.clear_alert(ALERT_IV_CONNECTED, /atom/movable/screen/alert/iv_connected)
	SEND_SIGNAL(src, COMSIG_IV_DETACH, injection_target)
	injection_target = null
	update_appearance(UPDATE_ICON)

/obj/item/reagent_containers/blood/proc/set_transfer_rate(new_rate)
	transfer_rate = round(clamp(new_rate, MIN_IV_TRANSFER_RATE, MAX_IV_TRANSFER_RATE), IV_TRANSFER_RATE_STEP)
	update_appearance(UPDATE_ICON)

/obj/item/reagent_containers/blood/process(seconds_per_tick)
	if(!injection_target)
		return PROCESS_KILL

	var/mob/check_mob = recursive_loc_check(src, injection_target)
	if (check_mob.loc == injection_target)
		injecting = FALSE

	if(amount_per_transfer_from_this > 10) // Prevents people from switching to illegal transfer values while the IV is already in someone, i.e. anything over 10
		visible_message("<span class='danger'>The IV bag's needle pops out of [injection_target]'s arm. The transfer amount is too high!</span>")
		return PROCESS_KILL

	if (istype(injection_target, /mob/living))
		var/mob/living/carbon/attached_mob = injection_target
		if(!(get_dist(src, attached_mob) <= 1 && isturf(attached_mob.loc)))
			if(isliving(attached_mob))
				to_chat(attached_mob, span_userdanger("The IV drip needle is ripped out of you, leaving an open bleeding wound!"))
				var/list/arm_zones = shuffle(list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM))
				var/obj/item/bodypart/chosen_limb = attached_mob.get_bodypart(arm_zones[1]) || attached_mob.get_bodypart(arm_zones[2]) || attached_mob.get_bodypart(BODY_ZONE_CHEST)
				chosen_limb.receive_damage(3)
				attached_mob.cause_wound_of_type_and_severity(WOUND_PIERCE, chosen_limb, WOUND_SEVERITY_MODERATE, wound_source = "IV needle")
			else
				visible_message(span_warning("[injection_target] is detached from [src]."))
			detach_iv()
			return PROCESS_KILL

	var/datum/reagents/drip_reagents = get_reagents()
	if(!drip_reagents)
		return PROCESS_KILL

	if(!transfer_rate)
		return

	// Give reagents
	if(injecting)
		if(drip_reagents.total_volume)
			drip_reagents.trans_to(injection_target, transfer_rate * seconds_per_tick, methods = INJECT, show_message = FALSE) //make reagents reacts, but don't spam messages
			update_appearance(UPDATE_ICON)

	// Take blood
	else if (isliving(injection_target))
		var/mob/living/attached_mob = injection_target
		var/amount = min(transfer_rate * seconds_per_tick, drip_reagents.maximum_volume - drip_reagents.total_volume)
		// If the beaker is full, ping
		if(!amount)
			set_transfer_rate(MIN_IV_TRANSFER_RATE)
			audible_message(span_hear("[src] pings."))
			return
		var/atom/movable/target = src?.reagents
		attached_mob.transfer_blood_to(target, amount)
		update_appearance(UPDATE_ICON)

