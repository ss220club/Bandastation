/obj/item/clothing/suit/v_jacket
	name = "куртка V"
	desc = "Куртка так называемого V."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "v_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/takemura_jacket
	name = "куртка Такэмуры"
	desc = "Куртка так называемого Такэмуры."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "takemura_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/katarina_jacket
	name = "куртка Катарины"
	desc = "Куртка так называемой Катарины."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "katarina_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/katarina_cyberjacket
	name = "киберкуртка Катарины"
	desc = "Кибер-куртка так называемой Катарины."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "katarina_cyberjacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/hooded/shark_costume
	name = "костюм акулы"
	desc = "Костюм из 'синтетической' кожи акулы, пахнет."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "shark_casual"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	allowed = list(/obj/item/tank/internals/emergency_oxygen)
	hoodtype = /obj/item/clothing/head/hooded/shark_hood_par

/obj/item/clothing/head/hooded/shark_hood_par
	name = "акулий капюшон"
	desc = "Капюшон, прикрепленный к костюму акулы."
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'
	icon_state = "shark_casual"

	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEEARS | HIDEHAIR

/obj/item/clothing/suit/hooded/shark_costume/light
	name = "светло-голубой костюм акулы"
	icon_state = "shark_casual_light"
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'
	hoodtype = /obj/item/clothing/head/hooded/shark_hood/light_par

/obj/item/clothing/head/hooded/shark_hood/light_par
	name = "светло-голубой акулий капюшон"
	icon_state = "shark_casual_light"
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'

/obj/item/clothing/suit/space/deathsquad/officer/syndie
	name = "куртка офицера синдиката"
	desc = "Длинная куртка из высокопрочного волокна."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "jacket_syndie"

/obj/item/clothing/suit/space/deathsquad/officer/field
	name = "полевая форма офицера флота Нанотрейзен"
	desc = "Парадный плащ, разработанный в качестве массового варианта формы Верховного Главнокомандующего. У этой униформы нет тех же защитных свойств, что и у оригинала, но она все ещё является довольно удобным и стильным предметом гардероба."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "ntsc_uniform"

/obj/item/clothing/suit/hooded/vi_arcane
	name = "куртка Вай"
	desc = "Слегка потрёпанный жакет боевой девчушки Вай."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "vi_arcane"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT
	hoodtype = /obj/item/clothing/head/hooded/vi_arcane

/obj/item/clothing/head/hooded/vi_arcane
	name = "капюшон Вай"
	desc = "Капюшон, прикреплённый к жакету Вай."
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'
	icon_state = "vi_arcane"

	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEEARS | HIDEHAIR

/obj/item/clothing/suit/hooded/vi_arcane
	name = "жакет Вай"
	icon_state = "vi_arcane"
	hoodtype = /obj/item/clothing/head/hooded/vi_arcane

/obj/item/clothing/head/hooded/vi_arcane
	name = "капюшон Вай"
	icon_state = "vi_arcane"
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'

/obj/item/clothing/suit/storage/soundhand_white_jacket
	name = "серебристая куртка группы Саундхэнд"
	desc = "Редкая серебристая куртка Саундхэнд. Ограниченная серия."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "soundhand_white_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_white_jacket/tag
	name = "куртка Арии"
	desc = "Редкая серебристая куртка Арии Вильвен, основательницы Саундхэнд."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "soundhand_white_jacket_teg"
	worn_icon_state = "soundhand_white_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_black_jacket
	name = "фанатская черная куртка Саундхэнд"
	desc = "Черная куртка группы Саундхэнд, исполненая в духе оригинала, но без логотипа на спине. С любовью для фанатов."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "soundhand_black_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_black_jacket/tag
	name = "черная куртка Саундхэнд"
	desc = "Черная куртка с тэгом группы Саундхэнд, которую носят исполнители группы."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "soundhand_black_jacket_teg"
	worn_icon_state = "soundhand_black_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_olive_jacket
	name = "фанатская оливковая куртка Саундхэнд"
	desc = "Оливковая куртка гурппы Саундхэнд, исполненая в духе оригинала, но без логотипа на спине. С любовью для фанатов."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "soundhand_olive_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_olive_jacket/tag
	name = "оливковая куртка с тэгом группы Саундхэнд"
	desc = "Оливковая куртка с тэгом группы Саундхэнд, которую носят исполнители группы."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "soundhand_olive_jacket_teg"
	worn_icon_state = "soundhand_olive_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_brown_jacket
	name = "фанатская коричневая куртка Саундхэнд"
	desc = "Коричневая куртка Саундхэнд, исполненая в духе оригинала, но без логотипа на спине. С любовью для фанатов."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "soundhand_brown_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_brown_jacket/tag
	name = "коричневая куртка с тэгом Саундхэнд"
	desc = "Коричневая куртка с тэгом группы Саундхэнд, которую носят исполнители группы."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "soundhand_brown_jacket_teg"
	worn_icon_state = "soundhand_brown_jacket"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'

/datum/supply_pack/misc/soundhand_fan
	name = "Soundhand Fan Crate"
	desc = "Содержит фанатские куртки группы Саундхэнд"
	cost = CARGO_CRATE_VALUE * 30
	special = TRUE
	access_view = ACCESS_SERVICE
	contains = list(/obj/item/clothing/suit/storage/soundhand_black_jacket,
					/obj/item/clothing/suit/storage/soundhand_black_jacket,
					/obj/item/clothing/suit/storage/soundhand_olive_jacket,
					/obj/item/clothing/suit/storage/soundhand_olive_jacket,
					/obj/item/clothing/suit/storage/soundhand_brown_jacket,
					/obj/item/clothing/suit/storage/soundhand_brown_jacket,
					/obj/item/clothing/suit/storage/soundhand_white_jacket)
	crate_name = "soundhand Fan crate"

/obj/item/clothing/suit/chef/red
	name = "chef's red apron"
	desc = "Хорошо скроенный поварской китель."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "chef_red"

/* Space Battle */
/obj/item/clothing/suit/space/hardsuit/security
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	icon_state = "hardsuit-sec-old"
