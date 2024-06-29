/obj/item/card/id
	var/skinable = TRUE
	var/obj/item/id_skin/skin_applied = null

/obj/item/card/id/guest
	skinable = FALSE

/obj/item/card/id/data
	skinable = FALSE

/obj/item/card/id/away
	skinable = FALSE

/obj/item/card/id/thunderdome
	skinable = FALSE

/obj/item/card/id/attackby(obj/item/item, mob/user, params)
	. = ..()
	if(!istype(item, /obj/item/id_skin))
		return .

	return apply_skin(item, user)

/obj/item/card/id/examine(mob/user)
	. = ..()
	. += span_notice("Вы можете попытаться снять наклейку, используя <b>Ctrl-Shift-Click</b>.")

/obj/item/card/id/item_ctrl_click(mob/living/carbon/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_RESTRAINED))
		to_chat(user, span_warning("Ваши руки должны быть свободны, чтобы сделать это!"))
		return
	if(!skin_applied)
		to_chat(user, span_warning("На карте нет наклейки!"))
		return
	if(user.combat_mode == TRUE)
		to_chat(user, span_notice("Вы начинаете пытаться отодрать наклейку..."))
		if(!do_after(user, 5 SECONDS, src, timed_action_flags = IGNORE_USER_LOC_CHANGE, progress = TRUE))
			return FALSE
		to_chat(user, span_notice("Вам не удаётся отодрать наклейку от карты."))
		return

	to_chat(user, span_notice("Вы начинаете пытаться снять наклейку с ID карты..."))
	if(!do_after(user, 20 SECONDS, src, timed_action_flags = IGNORE_USER_LOC_CHANGE, progress = TRUE))
		return FALSE
	to_chat(user, span_notice("Вам не удаётся снять наклейку с карты."))

/obj/item/card/id/proc/apply_skin(obj/item/id_skin/skin, mob/user)
	if(skin_applied)
		to_chat(usr, span_warning("На карте уже есть наклейка, сначала соскребите её!"))
		return FALSE

	if(!skinable)
		to_chat(usr, span_warning("Наклейка не подходит для [src.name]!"))
		return FALSE

	to_chat(user, span_notice("Вы начинаете наносить наклейку на карту."))
	if(!do_after(user, 2 SECONDS, src, progress = TRUE))
		return FALSE

	var/mutable_appearance/card_skin = mutable_appearance(skin.icon, skin.icon_state)
	card_skin.color = skin.color
	to_chat(user, span_notice("Вы наклеили [skin.pronoun_name] на [src.name]."))
	desc += "<br>[skin.info]"
	user.dropItemToGround()
	skin.forceMove(src)
	skin_applied = skin
	add_overlay(card_skin)
	return TRUE

/obj/item/id_skin/examine(mob/user)
	. = ..()
	desc += "<b>На наклейке можно заметить суперклей, который не позволит её снять после применения.</b>"

/obj/item/id_skin
	name = "\improper наклейка на карту"
	desc = "Этим можно изменить внешний вид своей карты! Покажи службе безопасности какой ты стильный."
	icon = 'modular_bandastation/objects/icons/id_skins.dmi'
	icon_state = ""
	var/pronoun_name = "наклейку"
	var/info = "На ней наклейка."

/obj/item/id_skin/colored
	name = "\improper голо-наклейка на карту"
	desc = "Голографическая наклейка на карту. Вы можете выбрать цвет который она примет."
	icon_state = "colored"
	pronoun_name = "голо-наклейку"
	info = "На ней голо-наклейка."
	var/static/list/color_list = list(
		"Красный" = LIGHT_COLOR_INTENSE_RED,
		"Зелёный" = LIGHT_COLOR_GREEN,
		"Синий" = LIGHT_COLOR_CYAN,
		"Жёлтый" = LIGHT_COLOR_HOLY_MAGIC,
		"Оранжевый" = LIGHT_COLOR_ORANGE,
		"Фиолетовый" = LIGHT_COLOR_LAVENDER,
		"Голубой" = LIGHT_COLOR_LIGHT_CYAN,
		"Циановый" = LIGHT_COLOR_CYAN,
		"Аквамариновый" = LIGHT_COLOR_BLUEGREEN,
		"Розовый" = LIGHT_COLOR_PINK)

/obj/item/id_skin/colored/Initialize(mapload)
	. = ..()
	if(color)
		return .

	color = color_list[pick(color_list)]

/obj/item/id_skin/colored/attack_self(mob/living)
	var/choice = tgui_input_list(usr, "Какой цвет предпочитаете?", "Выбор цвета", list("Выбрать предустановленный", "Выбрать вручную"))
	if(!choice)
		return
	switch(choice)
		if("Выбрать предустановленный")
			choice = tgui_input_list(usr, "Выберите цвет", "Выбор цвета", color_list)
			var/color_to_set = color_list[choice]
			if(!color_to_set)
				return

			color = color_to_set

		if("Выбрать вручную")
			color = input(usr,"Выберите цвет") as color
