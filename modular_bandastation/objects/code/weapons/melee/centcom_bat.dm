// Тактическая бита Флота Nanotrasen
/obj/item/melee/baseball_bat/homerun/central_command
	name = "тактическая бита Флота Nanotrasen"
	desc = "Выдвижная тактическая бита Центрального Командования Nanotrasen. \
	В официальных документах эта бита проходит под элегантным названием \"Высокоскоростная система доставки СРП\". \
	Выдаваясь только самым верным и эффективным офицерам Nanotrasen, это оружие является одновременно символом статуса \
	и инструментом высшего правосудия."
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	var/on = FALSE
	/// Force when concealed
	force = 5
	/// Force when extended
	var/force_on = 20
	lefthand_file = 'modular_bandastation/objects/icons/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/melee_righthand.dmi'
	icon = 'modular_bandastation/objects/icons/melee.dmi'
	/// Icon state when concealed
	icon_state = "centcom_bat_0"
	inhand_icon_state = "centcom_bat_0"
	worn_icon = 'icons/mob/clothing/belt.dmi'
	worn_icon_state = "nothing"
	/// Icon state when extended
	var/icon_state_on = "centcom_bat_1"
	var/inhand_icon_state_on = "centcom_bat_1"
	/// Sound to play when concealing or extending
	var/extend_sound = 'sound/weapons/batonextend.ogg'
	/// Attack verbs when concealed (created on Initialize)
	attack_verb_simple = list("hit", "poked")
	/// Attack verbs when extended (created on Initialize)
	var/list/attack_verb_simple_on = list("smacked", "struck", "cracked", "beaten")

/obj/item/melee/baseball_bat/homerun/central_command/pickup(mob/living/user)
	. = ..()
	if(!HAS_TRAIT(user, R_ADMIN))
		user.AdjustParalyzed(10 SECONDS)
		user.drop_all_held_items(src, force)
		to_chat(user, span_userdanger("Это - оружие истинного правосудия. Тебе не дано обуздать его мощь."))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2, force))

/obj/item/melee/baseball_bat/homerun/central_command/attack_self(mob/user)
	on = !on

	if(on)
		to_chat(user, span_userdanger("Вы разложили [src.name] - время для правосудия!"))
		icon_state = icon_state_on
		inhand_icon_state = inhand_icon_state_on
		w_class = WEIGHT_CLASS_HUGE
		force = force_on
		attack_verb_simple = attack_verb_simple_on
	else
		to_chat(user, span_userdanger("Вы сложили [src.name]."))
		icon_state = initial(icon_state)
		inhand_icon_state = initial(inhand_icon_state)
		w_class = initial(w_class)
		force = initial(force)
		attack_verb_simple = initial(attack_verb_simple)

	homerun_able = on
	// Update mob hand visuals
	if(ishuman(user))
		user.update_held_items()
	playsound(loc, extend_sound, 50, TRUE)
	add_fingerprint(user)

/obj/item/melee/baseball_bat/homerun/central_command/attack(mob/living/target, mob/living/user)
	if(on)
		homerun_ready = TRUE
	. = ..()
