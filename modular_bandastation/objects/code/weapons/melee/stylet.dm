// Stylet
/obj/item/knife/stylet
	name = "выкидной нож"
	desc = "Маленький складной нож скрытого ношения. \
	Нож в итальянском стиле, который исторически стал предметом споров и даже запретов \
	Его лезвие практически мгновенно выбрасывается при нажатии кнопки-качельки."
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_TINY

	var/on = FALSE
	force = 2
	var/force_on = 8

	lefthand_file = 'modular_bandastation/objects/icons/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/melee_righthand.dmi'
	icon = 'modular_bandastation/objects/icons/melee.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	icon_state = "stylet_0"
	inhand_icon_state = "stylet_0"
	var/icon_state_on = "stylet_1"
	var/inhand_icon_state_on = "stylet_1"
	var/extend_sound = 'modular_bandastation/objects/sounds/weapons/styletext.ogg'
	attack_verb_simple = list("hit", "poked")
	var/list/attack_verb_simple_on = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/knife/stylet/update_icon()
	. = ..()
	if(on)
		icon_state = inhand_icon_state = "stylet_1"
	else
		icon_state = inhand_icon_state = "stylet_0"

/obj/item/knife/stylet/attack_self(mob/user)
	on = !on

	if(on)
		to_chat(user, span_notice("Вы разложили [src.name]."))
		update_icon()
		w_class = WEIGHT_CLASS_SMALL
		force = force_on
		attack_verb_simple = attack_verb_simple_on
	else
		to_chat(user, span_notice("Вы сложили [src.name]."))
		update_icon()
		w_class = initial(w_class)
		force = initial(force)
		attack_verb_simple = initial(attack_verb_simple)

	// Update mob hand visuals
	if(ishuman(user))
		user.update_held_items()
	playsound(loc, extend_sound, 50, TRUE)
	add_fingerprint(user)
