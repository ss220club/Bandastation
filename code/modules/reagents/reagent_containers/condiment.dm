
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
// leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
// to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_containers/condiment
	name = "бутылка специй"
	desc = "Просто обычная бутылка со специями."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "bottle"
	inhand_icon_state = "beer" //Generic held-item sprite until unique ones are made.
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	reagent_flags = OPENCONTAINER
	obj_flags = UNIQUE_RENAME
	possible_transfer_amounts = list(1, 5, 10, 15, 20, 25, 30, 50)
	volume = 50
	fill_icon_thresholds = list(0, 10, 25, 50, 75, 100)
	/// Icon (icon_state) to be used when container becomes empty (no change if falsy)
	var/icon_empty
	/// Holder for original icon_state value if it was overwritten by icon_emty to change back to
	var/icon_preempty

/obj/item/reagent_containers/condiment/update_icon_state()
	. = ..()
	if(reagents.reagent_list.len)
		if(icon_preempty)
			icon_state = icon_preempty
			icon_preempty = null
		return ..()

	if(icon_empty && !icon_preempty)
		icon_preempty = icon_state
		icon_state = icon_empty
	return ..()

/obj/item/reagent_containers/condiment/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] пытается проглоить содержимое [src.name]! Еда работает не так!"))
	return OXYLOSS

/obj/item/reagent_containers/condiment/attack(mob/M, mob/user, def_zone)

	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[src.name] оказывается без наполнения, о нет!"))
		return FALSE

	if(!canconsume(M, user))
		return FALSE

	if(M == user)
		user.visible_message(span_notice("[user] проглатывает немного содержимого [src.name]."), \
			span_notice("Вы проглотили немного содержимого [src]."))
	else
		M.visible_message(span_warning("[user] пытается накормить [M]. Похоже это [src.name]."), \
			span_warning("[user] пытается накормить вас. Похоже это [src]."))
		if(!do_after(user, 3 SECONDS, M))
			return
		if(!reagents || !reagents.total_volume)
			return // The condiment might be empty after the delay.
		M.visible_message(span_warning("[user] кормит [M]. Похоже это [src.name]."), \
			span_warning("[user] кормит вас. Похоже это[src.name]."))
		log_combat(user, M, "fed", reagents.get_reagent_log_string())
	reagents.trans_to(M, 10, transferred_by = user, methods = INGEST)
	playsound(M.loc,'sound/items/drink.ogg', rand(10,50), TRUE)
	return TRUE

/obj/item/reagent_containers/condiment/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target.name] без ничего!"))
			return ITEM_INTERACT_BLOCKING

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, span_warning("[src.name] уже не вмещает больше!"))
			return ITEM_INTERACT_BLOCKING

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transferred_by = user)
		to_chat(user, span_notice("[src.name] наполняется [trans] юнитами. Используется [target.name]."))
		return ITEM_INTERACT_SUCCESS

	//Something like a glass or a food item. Player probably wants to transfer TO it.
	else if(target.is_drainable() || IS_EDIBLE(target))
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src] без ничего!"))
			return ITEM_INTERACT_BLOCKING
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, span_warning("[target] не может вместить себя больше ингридиентов!"))
			return ITEM_INTERACT_BLOCKING
		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this, transferred_by = user)
		to_chat(user, span_notice("[trans] заполняет содержимое [target.name]."))
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/reagent_containers/condiment/enzyme
	name = "universal enzyme"
	desc = "Используется в приготовлении различных блюд."
	icon_state = "enzyme"
	list_reagents = list(/datum/reagent/consumable/enzyme = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/enzyme/examine(mob/user)
	. = ..()
	var/datum/chemical_reaction/recipe = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/cheesewheel]
	var/milk_required = recipe.required_reagents[/datum/reagent/consumable/milk]
	var/enzyme_required = recipe.required_catalysts[/datum/reagent/consumable/enzyme]
	. += span_notice("[milk_required] молока, [enzyme_required] энзима и вы получите сыр.")
	. += span_warning("Помните, что энзим лишь катализатор, не забудьте вернуть его в бутылку!")

/obj/item/reagent_containers/condiment/sugar
	name = "мешок сахара"
	desc = "Сладкий космический сахар!"
	icon_state = "sugar"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/sugar = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/sugar/examine(mob/user)
	. = ..()
	var/datum/chemical_reaction/recipe = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/cakebatter]
	var/flour_required = recipe.required_reagents[/datum/reagent/consumable/flour]
	var/eggyolk_required = recipe.required_reagents[/datum/reagent/consumable/eggyolk]
	var/sugar_required = recipe.required_reagents[/datum/reagent/consumable/sugar]
	. += span_notice("[flour_required] муки, [eggyolk_required] яий или соевого молока, [sugar_required] сахара, чтобы сделать слоенное тесто. Вы даже можете сделать пирог из него!")

/obj/item/reagent_containers/condiment/saltshaker //Separate from above since it's a small shaker rather then
	name = "солонка" // a large one.
	desc = "Соль. Скорее всего из космического океана."
	icon_state = "saltshakersmall"
	icon_empty = "emptyshaker"
	inhand_icon_state = ""
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	list_reagents = list(/datum/reagent/consumable/salt = 20)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/saltshaker/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] начинает поглощать содержимое солонки! Это похоже на какой-то акт самоубийства!"))
	var/newname = "[name]"
	name = "[user.name]"
	user.name = newname
	user.real_name = newname
	desc = "Соль. Скорее всего из мертвого члена экипажа."
	return TOXLOSS

/obj/item/reagent_containers/condiment/saltshaker/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(isturf(target))
		if(!reagents.has_reagent(/datum/reagent/consumable/salt, 2))
			to_chat(user, span_warning("У вас недостаточно соли, чтобы сделать горсть!"))
			return
		user.visible_message(span_notice("[target.name] наполняется солью благодаря [user]."), span_notice("[target.name] наполняется солью."))
		reagents.remove_reagent(/datum/reagent/consumable/salt, 2)
		new/obj/effect/decal/cleanable/food/salt(target)
		return ITEM_INTERACT_SUCCESS
	return .

/obj/item/reagent_containers/condiment/peppermill
	name = "перечница"
	desc = "Часто используется для придания особого вкуса. Или чтобы заставить людей чихать."
	icon_state = "peppermillsmall"
	icon_empty = "emptyshaker"
	inhand_icon_state = ""
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	list_reagents = list(/datum/reagent/consumable/blackpepper = 20)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/milk
	name = "космическое молоко"
	desc = "Это молоко. Белое и питательное божество!"
	icon_state = "milk"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/milk = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/milk/examine(mob/user)
	. = ..()
	var/datum/chemical_reaction/recipe = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/cheesewheel]
	var/milk_required = recipe.required_reagents[/datum/reagent/consumable/milk]
	var/enzyme_required = recipe.required_catalysts[/datum/reagent/consumable/enzyme]
	. += span_notice("[milk_required] молока, [enzyme_required] энзима, и вы получите сыр.")
	. += span_warning("Помните, что энзим лишь катализатор, поэтому верните его потом на место!")

/obj/item/reagent_containers/condiment/flour
	name = "упаковка муки"
	desc = "Крупная упаковка с мукой. Прекрасный выбор для выпечки!"
	icon_state = "flour"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/flour = 30)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/flour/examine(mob/user)
	. = ..()
	var/datum/chemical_reaction/recipe_dough = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/dough]
	var/datum/chemical_reaction/recipe_cakebatter = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/cakebatter]
	var/dough_flour_required = recipe_dough.required_reagents[/datum/reagent/consumable/flour]
	var/dough_water_required = recipe_dough.required_reagents[/datum/reagent/water]
	var/cakebatter_flour_required = recipe_cakebatter.required_reagents[/datum/reagent/consumable/flour]
	var/cakebatter_eggyolk_required = recipe_cakebatter.required_reagents[/datum/reagent/consumable/eggyolk]
	var/cakebatter_sugar_required = recipe_cakebatter.required_reagents[/datum/reagent/consumable/sugar]
	. += "<b><i>Вы копаетесь в своих мыслях и вспоминаете рецепт... теста...</i></b>"
	. += span_notice("[dough_flour_required] муки, [dough_water_required] воды подойдет для обычного кусочка теста. Его можно потом раскатать в плоскую лепешку.")
	. += span_notice("[cakebatter_flour_required] муки, [cakebatter_eggyolk_required] яичного желтка (или соевого молока), [cakebatter_sugar_required] сахара, чтобы сделать слоенное тесто. Из него выйдет отличный пирог!")

/obj/item/reagent_containers/condiment/soymilk
	name = "соевое молоко"
	desc = "соя, божество прозрачное, но все еще питательное!"
	icon_state = "soymilk"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/soymilk = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/rice
	name = "пачка риса"
	desc = "Крупная упаковка с рисом. Идеальна для приготовления блюд!"
	icon_state = "rice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/rice = 30)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/cornmeal
	name = "коробка кукурузной муки"
	desc = "Крупная коробка с кукрзной мукой. Отличный выбор для приготовления южных блюд."
	icon_state = "cornmeal"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/cornmeal = 30)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/bbqsauce
	name = "соус барбекью"
	desc = "Салфетки не включены."
	icon_state = "bbqsauce"
	list_reagents = list(/datum/reagent/consumable/bbqsauce = 50)

/obj/item/reagent_containers/condiment/soysauce
	name = "соевый соус"
	desc = "Соленоватый соус на основе сои."
	icon_state = "soysauce"
	list_reagents = list(/datum/reagent/consumable/soysauce = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/mayonnaise
	name = "майонез"
	desc = "Маслянистая приправа из яичного желтка."
	icon_state = "mayonnaise"
	list_reagents = list(/datum/reagent/consumable/mayonnaise = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/vinegar
	name = "уксус"
	desc = "Превосходно подходит для чипсов. Если у вас специфичный вкус."
	icon_state = "vinegar"
	list_reagents = list(/datum/reagent/consumable/vinegar = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/vegetable_oil
	name = "растительное масло"
	desc = "Для особо глубокого фритюра."
	icon_state = "cooking_oil"
	list_reagents = list(/datum/reagent/consumable/nutriment/fat/oil = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/olive_oil
	name = "качественное масло"
	desc = "Для утонченных шеф-поваров, что скрываются в каждом из нас."
	icon_state = "oliveoil"
	list_reagents = list(/datum/reagent/consumable/nutriment/fat/oil/olive = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/yoghurt
	name = "упаковка йогурта"
	desc = "Кремовый и мягкий."
	icon_state = "yoghurt"
	list_reagents = list(/datum/reagent/consumable/yoghurt = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/peanut_butter
	name = "ореховое масло"
	desc = "Вкусное, тянущееся масло в банке."
	icon_state = "peanutbutter"
	list_reagents = list(/datum/reagent/consumable/peanut_butter = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/cherryjelly
	name = "вишневое желе"
	desc = "Баночка с супер-сладким вишневым желе."
	icon_state = "cherryjelly"
	list_reagents = list(/datum/reagent/consumable/cherryjelly = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/honey
	name = "мед"
	desc = "Баночка приятного и тягучего меда."
	icon_state = "honey"
	list_reagents = list(/datum/reagent/consumable/honey = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/ketchup
	name = "кетчуп"
	// At time of writing, "ketchup" mechanically, is just ground tomatoes,
	// rather than // tomatoes plus vinegar plus sugar.
	desc = "Выжатые томаты, что скрываются в пластиковой бутылке."
	icon_state = "ketchup"
	list_reagents = list(/datum/reagent/consumable/ketchup = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/worcestershire
	name = "вустерширский соус"
	desc = "Фермнтированный легендарный соус с Земли."
	icon_state = "worcestershire"
	list_reagents = list(/datum/reagent/consumable/worcestershire = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/red_bay
	name = "\improper Приправа Рэд Бей"
	desc = "Прямо с Марса!"
	icon_state = "red_bay"
	list_reagents = list(/datum/reagent/consumable/red_bay = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/curry_powder
	name = "порошо карри"
	desc = "В нем заключена особая магия, что придает карри вкус карри."
	icon_state = "curry_powder"
	list_reagents = list(/datum/reagent/consumable/curry_powder = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/dashi_concentrate
	name = "конценрат даси"
	desc = "Бутылка концентрата даси марки Amagi. Варите на медленном огне воду в соотношении 1:8, чтобы получить идеальный бульон даси."
	icon_state = "dashi_concentrate"
	list_reagents = list(/datum/reagent/consumable/dashi_concentrate = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/coconut_milk
	name = "кокосовое молочко"
	desc = "Это кокосовое молоко. Потрясно!"
	icon_state = "coconut_milk"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/coconut_milk = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/grounding_solution
	name = "раствор заземления"
	desc = "Безопасный для пищевых продуктов ионный раствор, предназначенный для нейтрализации загадочного «жидкого электричества», свойственного продуктам Sprout, образуя при контакте безвредную соль."
	icon_state = "grounding_solution"
	list_reagents = list(/datum/reagent/consumable/grounding_solution = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/protein
	name = "protein powder"
	desc = "Fuel for your inner Hulk - because you can't spell 'swole' without 'whey'!"
	icon_state = "protein"
	list_reagents = list(/datum/reagent/consumable/nutriment/protein = 40)
	fill_icon_thresholds = null

//technically condiment packs but they are non transparent

/obj/item/reagent_containers/condiment/creamer
	name = "пакетик сливок для кофе"
	desc = "Лучше не думать о том, из чего это сделано."
	icon_state = "condi_creamer"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/creamer = 5)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/chocolate
	name = "пакетик шоколадной посыпки"
	desc= "Вам недостаточно сахара, который уже там есть?"
	icon_state = "condi_chocolate"
	list_reagents = list(/datum/reagent/consumable/choccyshake = 10)

/obj/item/reagent_containers/condiment/hotsauce
	name = "бутылка острого соуса"
	desc= "Вы можете чувствовать язву!"
	icon_state = "hotsauce"
	list_reagents = list(/datum/reagent/consumable/capsaicin = 50)

/obj/item/reagent_containers/condiment/coldsauce
	name = "бутылка холодного соуса"
	desc= "Оставляет язык онемевшим после пробы."
	icon_state = "coldsauce"
	list_reagents = list(/datum/reagent/consumable/frostoil = 50)

//Food packs. To easily apply deadly toxi... delicious sauces to your food!

/obj/item/reagent_containers/condiment/pack
	name = "набор приправ"
	desc = "Небольшой пластиковый пакет с приправами для вашей еды."
	icon_state = "condi_empty"
	volume = 10
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10)
	/**
	  * List of possible styles (list(<icon_state>, <name>, <desc>)) for condiment packs.
	  * Since all of them differs only in color should probably be replaced with usual reagentfillings instead
	  */
	var/list/possible_states = list(
		/datum/reagent/consumable/ketchup = list("condi_ketchup", "Кетчуп", "Вы уже чувствуете себя более космическим."),
		/datum/reagent/consumable/capsaicin = list("condi_hotsauce", "Острый соус", "Теперь вы почти можете ПОПРОБОВАТЬ язвы желудка!"),
		/datum/reagent/consumable/soysauce = list("condi_soysauce", "Соевый соус", "Соленая приправа на основе сои."),
		/datum/reagent/consumable/frostoil = list("condi_frostoil", "Холодный соус", "Оставляет язык онемевшим при еде."),
		/datum/reagent/consumable/salt = list("condi_salt", "Солонка", "Соль. Вероятно, из космических океанов."),
		/datum/reagent/consumable/blackpepper = list("condi_pepper", "Перечница", "Часто используется для придания вкуса пище или чтобы заставить людей чихать."),
		/datum/reagent/consumable/nutriment/fat/oil = list("condi_cornoil", "Растительное масло", "Вкусное масло, используемое в кулинарии."),
		/datum/reagent/consumable/sugar = list("condi_sugar", "Сахар", "Вкусный космический сахар!"),
		/datum/reagent/consumable/astrotame = list("condi_astrotame", "Астротейм", "Сладость тысячи сахаров, но без калорий."),
		/datum/reagent/consumable/bbqsauce = list("condi_bbq", "BBQ соус", "Салфетки не включены."),
		/datum/reagent/consumable/peanut_butter = list("condi_peanutbutter", "Арахисовое масло", "Кремовая паста из молотого арахиса."),
		/datum/reagent/consumable/cherryjelly = list("condi_cherryjelly", "Вишневое желе", "Банка сверхсладкого вишневого желе."),
		/datum/reagent/consumable/mayonnaise = list("condi_mayo", "Майонез", "Не является инструментом."),
	)
	/// Can't use initial(name) for this. This stores the name set by condimasters.
	var/originalname = "condiment"

/obj/item/reagent_containers/condiment/pack/create_reagents(max_vol, flags)
	. = ..()
	RegisterSignals(reagents, list(COMSIG_REAGENTS_NEW_REAGENT, COMSIG_REAGENTS_ADD_REAGENT, COMSIG_REAGENTS_REM_REAGENT), PROC_REF(on_reagent_add), TRUE)
	RegisterSignal(reagents, COMSIG_REAGENTS_DEL_REAGENT, PROC_REF(on_reagent_del), TRUE)

/obj/item/reagent_containers/condiment/pack/update_icon()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/item/reagent_containers/condiment/pack/attack(mob/M, mob/user, def_zone) //Can't feed these to people directly.
	return

/obj/item/reagent_containers/condiment/pack/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	//Пакет можно разорвать над едой, чтобы добавить приправы.
	if(IS_EDIBLE(target))
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src.name] открыли, но внутри пусто."))
			qdel(src)
			return ITEM_INTERACT_BLOCKING
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, span_warning("[src.name] вскрыли, но [target.name] уже не вмещает больше, и все просто стекает!"))
			qdel(src)
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice("[src.name] открыли, и [target.name] наполняется."))
		src.reagents.trans_to(target, amount_per_transfer_from_this, transferred_by = user)
		qdel(src)
		return ITEM_INTERACT_SUCCESS
	return ..()

/// Handles reagents getting added to the condiment pack.
/obj/item/reagent_containers/condiment/pack/proc/on_reagent_add(datum/reagents/reagents)
	SIGNAL_HANDLER

	var/datum/reagent/main_reagent = reagents.get_master_reagent()

	var/main_reagent_type = main_reagent?.type
	if(main_reagent_type in possible_states)
		var/list/temp_list = possible_states[main_reagent_type]
		icon_state = temp_list[1]
		desc = temp_list[3]
	else
		icon_state = "condi_mixed"
		desc = "Небольшой пакетик с приправами. На этикетке написано, что внутри [originalname]"

/// Handles reagents getting removed from the condiment pack.
/obj/item/reagent_containers/condiment/pack/proc/on_reagent_del(datum/reagents/reagents)
	SIGNAL_HANDLER
	icon_state = "condi_empty"
	desc = "Небольшой пакетик с приправами и он пуст."

//Ketchup
/obj/item/reagent_containers/condiment/pack/ketchup
	name = "упаковка кетчупа"
	originalname = "ketchup"
	list_reagents = list(/datum/reagent/consumable/ketchup = 10)

//Hot sauce
/obj/item/reagent_containers/condiment/pack/hotsauce
	name = "упаковска острого соуса"
	originalname = "hotsauce"
	list_reagents = list(/datum/reagent/consumable/capsaicin = 10)

/obj/item/reagent_containers/condiment/pack/astrotame
	name = "пакетик астротейма"
	originalname = "astrotame"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/astrotame = 5)

/obj/item/reagent_containers/condiment/pack/bbqsauce
	name = "пакетик BBQ соуса"
	originalname = "bbq sauce"
	list_reagents = list(/datum/reagent/consumable/bbqsauce = 10)

/obj/item/reagent_containers/condiment/pack/creamer
	name = "пакетик сливок"
	originalname = "creamer"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/cream = 5)

/obj/item/reagent_containers/condiment/pack/sugar
	name = "пакетик сахара"
	originalname = "sugar"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/sugar = 5)

/obj/item/reagent_containers/condiment/pack/soysauce
	name = "пакетик соевого соуса"
	originalname = "soy sauce"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/soysauce = 5)

/obj/item/reagent_containers/condiment/pack/mayonnaise
	name = "пакетик майонеза"
	originalname = "mayonnaise"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/mayonnaise = 5)
