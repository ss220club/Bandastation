// Тактическая бита Флота Nanotrasen
/obj/item/melee/baseball_bat/homerun/central_command
	name = "тактическая бита Флота Nanotrasen"
	desc = "Выдвижная тактическая бита Центрального Командования Nanotrasen. \
	В официальных документах эта бита проходит под элегантным названием \"Высокоскоростная система доставки СРП\". \
	Выдаваясь только самым верным и эффективным офицерам Nanotrasen, это оружие является одновременно символом статуса \
	и инструментом высшего правосудия."
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	var/active = FALSE
	force = 5
	lefthand_file = 'modular_bandastation/objects/icons/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/melee_righthand.dmi'
	icon = 'modular_bandastation/objects/icons/melee.dmi'
	icon_state = "centcom_bat"
	inhand_icon_state = "centcom_bat"
	worn_icon = 'icons/mob/clothing/belt.dmi'
	worn_icon_state = "nothing"
	attack_verb_simple = list("бьёт")

/obj/item/melee/baseball_bat/homerun/central_command/attack_self(mob/user)
	active = !active

	if(active)
		set_active(user)
	else
		set_inactive(user)

	to_chat(user, active ? span_userdanger("Вы активировали [src.name] - время для правосудия!") : span_notice("Вы деактивировали [src.name]."))
	playsound(src, 'sound/weapons/batonextend.ogg', 50, TRUE)
	homerun_able = active

/obj/item/melee/baseball_bat/homerun/central_command/proc/set_active(mob/user)
	force = 20
	w_class = WEIGHT_CLASS_HUGE
	inhand_icon_state = "[inhand_icon_state]_on"
	icon_state = "[icon_state]_on"
	user.update_held_items()

/obj/item/melee/baseball_bat/homerun/central_command/proc/set_inactive(mob/user)
	force = initial(force)
	w_class = initial(w_class)
	inhand_icon_state = initial(inhand_icon_state)
	icon_state = initial(icon_state)
	user.update_held_items()

/obj/item/melee/baseball_bat/homerun/central_command/pickup(mob/living/carbon/human/user)
	. = ..()
	if(!istype(user.get_item_by_slot(ITEM_SLOT_ID), /obj/item/card/id/advanced/centcom) || subtypesof(/obj/item/card/id/advanced/centcom))
		user.AdjustParalyzed(10 SECONDS)
		user.drop_all_held_items(src, force)
		to_chat(user, span_userdanger("Это - оружие истинного правосудия. Тебе не дано обуздать его мощь."))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2, force))

/obj/item/melee/baseball_bat/homerun/central_command/attack(mob/living/target, mob/living/user)
	if(homerun_able)
		homerun_ready = TRUE
	. = ..()
