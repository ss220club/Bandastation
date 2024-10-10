/obj/item/clothing/mask/rooster
	name = "маска петуха"
	desc = "Прямо из Острой дороги космо-Майами. Со встроенными фразами."
	icon = 'modular_bandastation/rooster_mask/icons/obj/clothing/mask/rooster_mask.dmi'
	worn_icon = 'modular_bandastation/rooster_mask/icons/mob/clothing/mask/rooster_mask.dmi'
	icon_state = "rooster"
	inhand_icon_state = null
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = MASKCOVERSMOUTH
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/rooster/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/speechmod, end_string = list(". Тебе нравится причинять боль людям?",". Вы вернулись, да?",". Что, бля, за неуважение?", ". Кто я?"), end_string_chance = 5, slots = ITEM_SLOT_MASK)
