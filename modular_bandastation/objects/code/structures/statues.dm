// MARK: On-station statues
/obj/structure/statue/themis
	name = "Фемида"
	desc = "Статуя древнегреческой богини правосудия."
	icon = 'modular_bandastation/objects/icons/obj/structures/statuelarge.dmi'
	icon_state = "themis"
	layer = ABOVE_MOB_LAYER
	pixel_y = 7
	anchored = TRUE
	max_integrity = 1000
	impressiveness = 50
	abstract_type = /obj/structure/statue/themis

// MARK: Off-station statues
/obj/structure/statue/mooniverse
	name = "Неизвестный агент"
	desc = "Информация на табличке под статуей исцарапана и нечитабельна... Поверх написано невнятное словосочетание из слов \"Moon\" и \"Universe\"."
	icon = 'modular_bandastation/objects/icons/obj/structures/statuelarge.dmi'
	icon_state = "mooniverse"
	pixel_y = 7
	anchored = TRUE
	max_integrity = 1000
	impressiveness = 100
	abstract_type = /obj/structure/statue/mooniverse

/obj/structure/statue/ell_good
	name = "Mr.Буум"
	desc = "Загадочный клоун с жёлтым оттенком кожи и выразительными зелёными глазами. Лучший двойной агент синдиката, получивший власть над множеством фасилити. \
			Его имя часто произносят неправильно из-за чего его заслуги по документам принадлежат сразу нескольким Буумам. \
			Так же знаменит тем, что убедил руководство НТ тратить время, силы и средства, на золотой унитаз."
	icon = 'modular_bandastation/objects/icons/obj/structures/statuelarge.dmi'
	icon_state = "ell_good"
	pixel_y = 7
	anchored = TRUE
	max_integrity = 1000
	impressiveness = 100
	abstract_type = /obj/structure/statue/ell_good

/obj/structure/statue/heinrich_treisen
	name = "Генрих Трейзен Третий"
	desc = "Золотая статуя текущего главы семьи Трейзен. Его успешная агрессивная политика в отношении конкурентов, \
			формирование окончательной монополии на рынке и мудрое распоряжение имеющимися активами привели к получению Корпорацией исключительных прав на разработку, \
			переработку и продажу плазмы во многих известных мирах. Именно благодаря Генриху Трейзену Третьему мы сегодня знаем Компанию Нанотрейзен такой, какая она есть."
	icon = 'modular_bandastation/objects/icons/obj/structures/statue.dmi'
	icon_state = "heinrich_treisen"
	anchored = TRUE
	abstract_type = /obj/structure/statue/heinrich_treisen

/obj/structure/statue/elwycco
	name = "Camper Hunter"
	desc = "Похоже это какой-то очень важный человек, или очень значимый для многих людей. Вы замечаете огроменный топор в его руках, с выгравированным числом 220. \
			Что это число значит? Каждый понимает по своему, однако по слухам оно означает количество его жертв. \n Надпись на табличке - Мы с тобой, Шустрила! Аве, Легион!"
	icon = 'modular_bandastation/objects/icons/obj/structures/statue.dmi'
	icon_state = "elwycco"
	anchored = TRUE
	abstract_type = /obj/structure/statue/elwycco

/obj/structure/statue/normandy_soo
	name = "Офицер специальных операций"
	desc = "Статуя одного из офицеров специальных операций. Подобной почести удостоены лишь самые верные..."
	icon = 'modular_bandastation/objects/icons/obj/structures/statue.dmi'
	icon_state = "mooniverse_soo"
	anchored = TRUE
	abstract_type = /obj/structure/statue/normandy_soo

/obj/structure/statue/sandstone/venus/pure
	name = "Венера"
	desc = "Эта мраморная реплика античной статуи восхлавляет женскую красоту и грацию, привлекая внимание своими изящными формами. \
			Скульптура создает величественный образ, который восхищает своим великолепием."
	icon = 'modular_bandastation/objects/icons/obj/structures/statuelarge.dmi'
	icon_state = "venus_pure"
	layer = ABOVE_MOB_LAYER
	pixel_y = 7
	anchored = TRUE
	max_integrity = 1000
	impressiveness = 50
	abstract_type = /obj/structure/statue/themis

/obj/structure/statue/statue_holoplanet
	name = "планетарная голограмма"
	desc = "Установка, позволяющая показывать подробные голографические карты известных миров."
	icon = 'modular_bandastation/objects/icons/obj/structures/statue.dmi'
	icon_state = "statue_holoplanet"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	abstract_type = /obj/structure/statue/statue_holoplanet


// Dummies
/**
 *	It is used as decorative element, or for shitspawn/events
 *	DO NOT use these icons for PvE NPCs! TGs NPCs made different.
 */
/obj/structure/statue/dummy
	name = "Unknown"
	desc = null
	icon = 'modular_bandastation/mobs/icons/dummies.dmi'
	icon_state = null
	pixel_y = 7
	anchored = TRUE
	max_integrity = 1000
	impressiveness = 0
	abstract_type = /obj/structure/statue/dummy
