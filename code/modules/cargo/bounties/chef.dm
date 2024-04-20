/datum/bounty/item/chef/birthday_cake
	name = "Праздничный торт"
	description = "День рождения Нанотрейзен уже наступает! Отправьте Центральному Командованию праздничный торт для празднования!"
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(
		/obj/item/food/cake/birthday = TRUE,
		/obj/item/food/cakeslice/birthday = TRUE
	)

/datum/bounty/reagent/chef/soup
	name = "Суп"
	description = "Для подавления роста бездомных, Нанотрейзен будет будет выдавать суп для всех низкооплачиваемых работников."

/datum/bounty/reagent/chef/soup/New()
	. = ..()
	required_volume = pick(10, 15, 20, 25)
	wanted_reagent = pick(subtypesof(/datum/reagent/consumable/nutriment/soup))
	reward = CARGO_CRATE_VALUE * round(required_volume / 3)
	// In the future there could be tiers of soup bounty corresponding to soup difficulty
	// (IE, stew is harder to make than tomato soup, so it should reward more)
	description += " Отправьте нам [required_volume] юнитов данного реагента: [initial(wanted_reagent.name)]."

/datum/bounty/item/chef/popcorn
	name = "Попкорн"
	description = "Высшее руководство хочет устроить вечер кино. Отправьте попкорн для такого повода."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/popcorn = TRUE)

/datum/bounty/item/chef/onionrings
	name = "Луковые кольца"
	description = "Нанторейзен вспоминает день Сатурна. Отправьте луковые кольца для поддержки станции."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/onionrings = TRUE)

/datum/bounty/item/chef/icecreamsandwich
	name = "Бутерброды с мороженым"
	description = "Высшее руководство орало не переставая о бутербродах с мороженым. Пожалуйста отправьте несколько."
	reward = CARGO_CRATE_VALUE * 8
	required_count = 3
	wanted_types = list(/obj/item/food/icecreamsandwich = TRUE)

/datum/bounty/item/chef/strawberryicecreamsandwich
	name = "Бутерброды с клубничным мороженым"
	description = "Высшее руководство орало не переставая о более вкусных бутербродах с мороженым. Пожалуйста отправьте несколько."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(/obj/item/food/strawberryicecreamsandwich = TRUE)

/datum/bounty/item/chef/bread
	name = "Хлеб"
	description = "Проблемы с центральным планированием привели к космическому росту цен на хлеб. Отправьте немного хлеба для снижения напряжения."
	reward = CARGO_CRATE_VALUE * 2
	wanted_types = list(
		/obj/item/food/bread = TRUE,
		/obj/item/food/breadslice = TRUE,
		/obj/item/food/bun = TRUE,
		/obj/item/food/pizzabread = TRUE,
		/obj/item/food/rawpastrybase = TRUE,
	)

/datum/bounty/item/chef/pie
	name = "ПИрог"
	description = "3.14159? Нет! Руководство ЦентКома хочет съедобный пирог! Отправьте целый один."
	reward = 3142 //Screw it I'll do this one by hand
	wanted_types = list(/obj/item/food/pie = TRUE)

/datum/bounty/item/chef/salad
	name = "Салат или миски риса"
	description = "Руководство ЦентКома переходит на здоровую пищу. Ваш заказ - это отправить салад или миски риса."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/salad = TRUE)

/datum/bounty/item/chef/carrotfries
	name = "Морковный картофель фри"
	description = "Ночное зрение может означать жизнь или смерть! Доставка морковного картофеля фри - заказ."
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/food/carrotfries = TRUE)

/datum/bounty/item/chef/superbite
	name = "Супер бургер"
	description = "Коммандор Табс думает, что он сможет установить мировой рекорд по поеданию. Всё что ему нужно, так это супер бургер, отправленный ему."
	reward = CARGO_CRATE_VALUE * 24
	wanted_types = list(/obj/item/food/burger/superbite = TRUE)

/datum/bounty/item/chef/poppypretzel
	name = "Poppy Pretzel"
	description = "Центральному Командованию нужна причина для увольнения главы отдела кадров. Отправьте маковый крендель чтобы завалить тест на наркотики."
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/food/poppypretzel = TRUE)

/datum/bounty/item/chef/cubancarp
	name = "Cuban Carp"
	description = "Чтобы отпраздновать рождение Кастро XXVII, отправьте кубинского карпа на ЦентКом."
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/food/cubancarp = TRUE)

/datum/bounty/item/chef/hotdog
	name = "Хот-дог"
	description = "Нанотрейзен проводит дегустацию чтобы определить лучший рецепт хот-дога. Отправьте версию своей станции для участия."
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/food/hotdog = TRUE)

/datum/bounty/item/chef/eggplantparm
	name = "Eggplant Parmigianas"
	description = "Популярный певец прибудет на ЦентКом и в его контракте прописано, что на стол должна подаваться только баклажановый пармезан. Отправьте немного, пожалуйста!"
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/food/eggplantparm = TRUE)

/datum/bounty/item/chef/muffin
	name = "Кексы"
	description = "Любитель кексов посещает ЦентКОм, но он забыл свои кексы! Ваша задача - исправить это."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/muffin = TRUE)

/datum/bounty/item/chef/chawanmushi
	name = "Chawanmushi"
	description = "Нанотрейзен хочет улучшить отношения с её дочерней компанией, Японотрейзен. Отправьте Тяван-муси немедленно."
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/food/chawanmushi = TRUE)

/datum/bounty/item/chef/kebab
	name = "Шашлык"
	description = "Убери весь шашлык со станции, и ты станешь едою. Отправьте на ЦентКом для удаления из помещения."
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/food/kebab = TRUE)

/datum/bounty/item/chef/soylentgreen
	name = "Soylent Green"
	description = "ЦентКом услышал замечательные вещи о 'Зелёном сойленте' и хочет попробовать его. Если вы оправдаете их ожидания, ожидайте приятный бонус."
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(/obj/item/food/soylentgreen = TRUE)

/datum/bounty/item/chef/pancakes
	name = "Pancakes"
	description = "Здесь, в Нанотрейзен, сотрудников считают семьёй. Вы знаете что семьи любят? Оладьи. Отправьте чёртову дюжину."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 13
	wanted_types = list(/obj/item/food/pancakes = TRUE)

/datum/bounty/item/chef/nuggies
	name = "Куриные котлеты"
	description = "Сын вице-президента не можете перестать говорить о куриных котлетках. Не могли бы вы отрпавить несколько?"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 6
	wanted_types = list(/obj/item/food/nugget = TRUE)

/datum/bounty/item/chef/corgifarming //Butchering is a chef's job.
	name = "Шкура корги"
	description = "Космическая яхта адмирала Вейнштейна нуждается в новой обивке. Дюжина меха корги должна с этим справиться."
	reward = CARGO_CRATE_VALUE * 60 //that's a lot of dead dogs
	required_count = 12
	wanted_types = list(/obj/item/stack/sheet/animalhide/corgi = TRUE)

/datum/bounty/item/chef/pickles
	name = "Огурцы"
	description = "В отделе контроля питания не хватает огурцов для правильной дегустации разных типов крепкого ликёра."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 7
	wanted_types = list(/obj/item/food/pickle = TRUE)
