/obj/machinery/papershredder
	name = "paper shredder"
	desc = "For those documents you don't want seen."
	icon = 'modular_bandastation/objects/icons/papershredder.dmi'
	icon_state = "papershredder0"
	density = TRUE
	anchored = TRUE
	var/max_paper = 15
	var/paperamount = 0
	var/list/shred_amounts = list(
		/obj/item/photo = 1,
		/obj/item/shredded_paper = 1,
		/obj/item/paper = 1,
		/obj/item/newspaper = 3,
		/obj/item/card/id = 3,
		/obj/item/folder = 4,
		/obj/item/book = 5
		)

/obj/machinery/papershredder/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	empty_contents(user)

/obj/machinery/papershredder/attackby(obj/item/item, mob/user, params)
	. = ..()
	var/paper_result
	if(item.type in shred_amounts)
		paper_result = shred_amounts[item.type]
	if(!paper_result)
		return
	if(paperamount == max_paper)
		to_chat(user, span_warning("[src] is full. Please empty it before you continue."))
		return
	paperamount += paper_result
	qdel(item)
	playsound(loc, 'modular_bandastation/objects/sounds/pshred.ogg', 75, 1)
	update_icon_state()
	add_fingerprint(user)

/obj/machinery/papershredder/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/papershredder/examine(mob/user)
	. = ..()
	. += span_notice("<b>Right-Click</b> to empty [src].")

/obj/machinery/papershredder/proc/empty_contents(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_RESTRAINED))
		to_chat(user, span_notice("You need your hands free for this."))
		return

	if(!paperamount)
		to_chat(user, span_notice("[src] is empty."))
		return

	get_shredded_paper()
	update_icon_state()



/obj/machinery/papershredder/proc/get_shredded_paper()
	if(!paperamount)
		return
	paperamount--
	return new /obj/item/shredded_paper(get_turf(src))

/obj/machinery/papershredder/update_icon_state()
	icon_state = "papershredder[clamp(round(paperamount/3), 0, 5)]"
	return ..()

/obj/item/shredded_paper
	name = "shredded paper"
	icon = 'modular_bandastation/objects/icons/papershredder.dmi'
	icon_state = "shredp"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	layer = BELOW_MOB_LAYER
	max_integrity = 25
	throw_range = 3
	throw_speed = 2

/obj/item/shredded_paper/Initialize()
	. = ..()
	if(prob(65))
		color = pick("#8b8b8b","#e7e4e4", "#c9c9c9")
