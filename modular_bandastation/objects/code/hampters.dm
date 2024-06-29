// Спавнер рандомного хамптера для карты
/obj/effect/spawner/random/hampter
	name = "Random Hampter"
	desc = "This is a random hampter spawner."
	icon = 'modular_bandastation/objects/icons/hampter.dmi'
	icon_state = "hampter"
	loot = list(
		/obj/item/toy/plush/hampter/assistant = 1,
		/obj/item/toy/plush/hampter/captain = 1,
		/obj/item/toy/plush/hampter/deadsquad = 1,
		/obj/item/toy/plush/hampter/ert = 1,
		/obj/item/toy/plush/hampter/janitor = 1,
		/obj/item/toy/plush/hampter/medical = 1,
		/obj/item/toy/plush/hampter/old_captain = 1,
		/obj/item/toy/plush/hampter/security = 1,
		/obj/item/toy/plush/hampter/syndicate = 1,
	)

// Хамптер
/obj/item/toy/plush/hampter
	name = "хамптер"
	desc = "Просто плюшевый хамптер. Самый обычный."
	icon = 'modular_bandastation/objects/icons/hampter.dmi'
	icon_state = "hampter"
	lefthand_file = 'modular_bandastation/objects/icons/inhands/hampter_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/hampter_righthand.dmi'
	slot_flags = ITEM_SLOT_HEAD
	w_class = WEIGHT_CLASS_TINY

// Действия при взаимодействии с включенным комбат модом
/obj/item/toy/plush/hampter/attack_self(mob/living/carbon/human/user)
	. = ..()
	if(user.combat_mode == TRUE)
		new /obj/effect/decal/cleanable/blood(get_turf(user))
		user.visible_message(span_warning("[user] раздавливает хамптера в своей руке!"), span_warning("Вы раздавливаете хамптера в своей руке, и от него остаётся лужа крови!"))
		qdel(src)

// Подвиды
/obj/item/toy/plush/hampter/assistant
	name = "хамптер ассистент"
	desc = "Плюшевый хамптер ассистент. Зачем ему изольки?"
	icon_state = "hampter_ass"

/obj/item/toy/plush/hampter/security
	name = "хамптер офицер"
	desc = "Плюшевый хамптер офицер службы безопасности. У него станбатон!"
	icon_state = "hampter_sec"

/obj/item/toy/plush/hampter/medical
	name = "хамптер врач"
	desc = "Плюшевый хамптер врач. Тащите дефибриллятор!"
	icon_state = "hampter_med"

/obj/item/toy/plush/hampter/janitor
	name = "хамптер уборщик"
	desc = "Плюшевый хамптер уборщик. Переключись на шаг."
	icon_state = "hampter_jan"

/obj/item/toy/plush/hampter/old_captain
	name = "хамптер старый капитан"
	desc = "ПЛюшевый хамптер капитан в старой униформе. Это какой год?"
	icon_state = "hampter_old-cap"

/obj/item/toy/plush/hampter/captain
	name = "хамптер капитан"
	desc = "Плюшевый хамптер капитан. Где его запасная карта?"
	icon_state = "hampter_cap"

/obj/item/toy/plush/hampter/syndicate
	name = "хамптер Синдиката"
	desc = "Плюшевый хамптер агент Синдиката. Ваши активы пострадают."
	icon_state = "hampter_sdy"

/obj/item/toy/plush/hampter/deadsquad
	name = "хамптер Дедсквада"
	desc = "Плюшевый хамптер Отряда Смерти. Все контракты расторгнуты."
	icon_state = "hampter_ded"

/obj/item/toy/plush/hampter/ert
	name = "хамптер ОБР"
	desc = "Плюшевый хамптер ОБР. Доложите о ситуации на станции."
	icon_state = "hampter_ert"
