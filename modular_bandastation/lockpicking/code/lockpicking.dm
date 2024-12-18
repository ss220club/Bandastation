#define PANEL_BROKEN 0
#define WIRES_DISCONNECTED 1
#define LOCK_OFF 2

/obj/structure/closet
	var/lockpicking_stage

/obj/structure/closet/examine(mob/user)
	. = ..()
	switch(lockpicking_stage)
		if(PANEL_BROKEN)
			. += span_notice("Панель доступа выломана.")
		if(WIRES_DISCONNECTED)
			. += span_notice("Панель доступа выломана.")
			. += span_notice("Провода отключены и торчат наружу.")
		if(LOCK_OFF)
			. += span_notice("Панель доступа выломана.")
			. += span_notice("Провода отключены и торчат наружу.")
			. += span_notice("Замок отключён.")

// MARK: Closets
/obj/structure/closet/secure_closet/crowbar_act(mob/living/user, obj/item/I)
	if(locked && lockpicking_stage == null) // Stage one
		to_chat(user, span_notice("Вы начинаете выламывать панель доступа [declent_ru(GENITIVE)]..."))
		if(I.use_tool(src, user, 16 SECONDS, volume = 50))
			if(prob(95)) // EZ
				broken = TRUE
				lockpicking_stage = PANEL_BROKEN
				to_chat(user, span_notice("Вы успешно выломали панель с [declent_ru(GENITIVE)]!"))
			else // Bad day
				var/mob/living/carbon/human/H = user
				var/obj/item/bodypart/affecting = H.get_active_hand()
				user.apply_damage(I.force, BRUTE, affecting)
				user.emote("scream")
				to_chat(user, span_warning("Проклятье! [capitalize(I.declent_ru(NOMINATIVE))] срывается и повреждает [affecting.declent_ru(ACCUSATIVE)]!"))
		return TRUE

/obj/structure/closet/secure_closet/wirecutter_act(mob/living/user, obj/item/I)
	if(locked && lockpicking_stage == PANEL_BROKEN) // Stage two
		to_chat(user, span_notice("Вы начинаете подготавливать провода панели [declent_ru(GENITIVE)]..."))
		if(I.use_tool(src, user, 16 SECONDS, volume = 50))
			if(prob(80)) // Good hacker!
				to_chat(user, span_notice("Вы успешно подготовили провода панели [declent_ru(GENITIVE)]!"))
				lockpicking_stage = WIRES_DISCONNECTED
			else // Bad day
				to_chat(user, span_warning("Черт! Не тот провод!"))
				do_sparks(5, TRUE, src)
				electrocute_mob(user, get_area(src), src, 1, TRUE)
		return TRUE

/obj/structure/closet/secure_closet/multitool_act(mob/living/user, obj/item/I)
	if(locked && lockpicking_stage == WIRES_DISCONNECTED) // Stage three
		to_chat(user, span_notice("Вы начинаете подключать провода панели [declent_ru(GENITIVE)] к [I.declent_ru(DATIVE)]..."))
		if(I.use_tool(src, user, 16 SECONDS, volume = 50))
			if(prob(80)) // Good hacker!
				broken = FALSE // Can be emagged
				lockpicking_stage = LOCK_OFF
				emag_act(user)
			else // Bad day
				to_chat(user, span_warning("Черт! Не тот провод!"))
				do_sparks(5, TRUE, src)
				electrocute_mob(user, get_area(src), src, 1, TRUE)
		return TRUE

// MARK: Crates
/obj/structure/closet/crate/secure/crowbar_act(mob/living/user, obj/item/I)
	if(locked && lockpicking_stage == null) // Stage one
		to_chat(user, span_notice("Вы начинаете выламывать панель доступа [declent_ru(GENITIVE)]..."))
		if(I.use_tool(src, user, 16 SECONDS, volume = 50))
			if(prob(95)) // EZ
				broken = TRUE
				lockpicking_stage = PANEL_BROKEN
				to_chat(user, span_notice("Вы успешно выломали панель с [declent_ru(GENITIVE)]!"))
			else // Bad day
				var/mob/living/carbon/human/H = user
				var/obj/item/bodypart/affecting = H.get_active_hand()
				user.apply_damage(I.force, BRUTE, affecting)
				user.emote("scream")
				to_chat(user, span_warning("Проклятье! [capitalize(I.declent_ru(NOMINATIVE))] срывается и повреждает [affecting.declent_ru(ACCUSATIVE)]!"))
		return TRUE

/obj/structure/closet/crate/secure/wirecutter_act(mob/living/user, obj/item/I)
	if(locked && lockpicking_stage == PANEL_BROKEN) // Stage two
		to_chat(user, span_notice("Вы начинаете подготавливать провода панели [declent_ru(GENITIVE)]..."))
		if(I.use_tool(src, user, 16 SECONDS, volume = 50))
			if(prob(80)) // Good hacker!
				to_chat(user, span_notice("Вы успешно подготовили провода панели [declent_ru(GENITIVE)]!"))
				lockpicking_stage = WIRES_DISCONNECTED
			else // Bad day
				to_chat(user, span_warning("Черт! Не тот провод!"))
				do_sparks(5, TRUE, src)
				electrocute_mob(user, get_area(src), src, 1, TRUE)
		return TRUE

/obj/structure/closet/crate/secure/multitool_act(mob/living/user, obj/item/I)
	if(locked && lockpicking_stage == WIRES_DISCONNECTED) // Stage three
		to_chat(user, span_notice("Вы начинаете подключать провода панели [declent_ru(GENITIVE)] к [I.declent_ru(DATIVE)]..."))
		if(I.use_tool(src, user, 16 SECONDS, volume = 50))
			if(prob(80)) // Good hacker!
				broken = FALSE // Can be emagged
				lockpicking_stage = LOCK_OFF
				emag_act(user)
			else // Bad day
				to_chat(user, span_warning("Черт! Не тот провод!"))
				do_sparks(5, TRUE, src)
				electrocute_mob(user, get_area(src), src, 1, TRUE)
		return TRUE

#undef PANEL_BROKEN
#undef WIRES_DISCONNECTED
#undef LOCK_OFF
