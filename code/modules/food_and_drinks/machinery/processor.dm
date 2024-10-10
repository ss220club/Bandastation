#define PROCESSOR_SELECT_RECIPE(movable_input) LAZYACCESS(processor_inputs[type], movable_input.type)

/obj/machinery/processor
	name = "food processor"
	RU_NAMES_LIST_INIT("food processor", "комбайн", "комбайна", "комбайну", "комбайн", "комбайном", "комбайне")
	desc = "Промышленный комбайн, используемый для обработки мяса и других продуктов. Во время работы держите руки подальше от зоны приема."
	icon = 'icons/obj/machines/kitchen.dmi'
	base_icon_state = "processor"
	icon_state = "processor"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	pass_flags = PASSTABLE
	circuit = /obj/item/circuitboard/machine/processor
	anchored_tabletop_offset = 8
	///Is the processor blending items at the moment
	var/processing = FALSE
	///The speed at which the processor processes items
	var/rating_speed = 1
	///The amount of items the processor produces, without any food specific multipliers
	var/rating_amount = 1
	///Lazylist of items to be blended
	var/list/processor_contents
	/*
	 * Static, nested list. The first layer contains all food processor types.
	 * The second layer contains input typepaths (key) and the associated food_processor_process datums (assoc) the processor can access.
	 * This allows for different types of processor to produce different outputs from same input as long as the recipes require different processors.
	 */
	var/static/list/processor_inputs

/obj/machinery/processor/Initialize(mapload)
	. = ..()
	if(processor_inputs)
		return
	processor_inputs = list()
	for(var/datum/food_processor_process/recipe as anything in subtypesof(/datum/food_processor_process))
		if(!initial(recipe.input))
			continue
		recipe = new recipe
		var/list/typecache = list()
		var/list/bad_types
		for(var/bad_type in recipe.blacklist)
			LAZYADD(bad_types, typesof(bad_type))
		for(var/input_type in typesof(recipe.input) - bad_types)
			typecache[input_type] = recipe
		for(var/machine_type in typesof(recipe.required_machine))
			LAZYADD(processor_inputs[machine_type], typecache)

/obj/machinery/processor/RefreshParts()
	. = ..()
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		rating_amount = matter_bin.tier
	for(var/datum/stock_part/servo/servo in component_parts)
		rating_speed = servo.tier

/obj/machinery/processor/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("На дисплее состояния отображается: Вывод <b>[rating_amount]</b> предметов с скоростью - <b>[rating_speed*100]%</b>.")

/obj/machinery/processor/Exited(atom/movable/gone, direction)
	..()
	LAZYREMOVE(processor_contents, gone)

/*
*	Spawns the items based on the passed processor recipes, and transfers materials and reagents
*	If the input was a mob, gibs them, otherwise, deletes the item
*/
/obj/machinery/processor/proc/process_food(datum/food_processor_process/recipe, atom/movable/what)
	if(recipe.output && loc && !QDELETED(src))
		var/list/cached_mats = recipe.preserve_materials && what.custom_materials
		var/cached_multiplier = (recipe.food_multiplier * rating_amount)
		for(var/i in 1 to cached_multiplier)
			var/atom/processed_food = new recipe.output(drop_location())
			if(processed_food.reagents && what.reagents)
				processed_food.reagents.clear_reagents()
				what.reagents.copy_to(processed_food, what.reagents.total_volume, multiplier = 1 / cached_multiplier)
			if(cached_mats)
				processed_food.set_custom_materials(cached_mats, 1 / cached_multiplier)

	if(isliving(what))
		var/mob/living/themob = what
		themob.gib()
	else
		qdel(what)
	LAZYREMOVE(processor_contents, what)

/obj/machinery/processor/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/processor/attackby(obj/item/attacking_item, mob/living/user, params)
	if(processing)
		to_chat(user, span_warning("[capitalize(declent_ru(NOMINATIVE))] находится в работе!"))
		return TRUE
	if(default_deconstruction_screwdriver(user, base_icon_state + "_open", base_icon_state, attacking_item) || default_pry_open(attacking_item, close_after_pry = TRUE) || default_deconstruction_crowbar(attacking_item))
		return

	if(istype(attacking_item, /obj/item/storage/bag/tray))
		var/obj/item/storage/attacking_storage = attacking_item
		var/loaded = 0
		for(var/obj/content_item in attacking_storage.contents)
			if(!IS_EDIBLE(content_item))
				continue
			var/datum/food_processor_process/recipe = PROCESSOR_SELECT_RECIPE(content_item)
			if(recipe)
				if(attacking_storage.atom_storage.attempt_remove(content_item, src))
					LAZYADD(processor_contents, content_item)
					loaded++

		if(loaded)
			to_chat(user, span_notice("[capitalize(loaded)] вставлен в [declent_ru(ACCUSATIVE)].."))
		return

	var/datum/food_processor_process/recipe = PROCESSOR_SELECT_RECIPE(attacking_item)
	if(recipe)
		user.visible_message(
			span_notice("[capitalize(user.declent_ru(NOMINATIVE))] засунул [attacking_item.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]."),
			span_notice("Вы засунули [attacking_item.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]."),
		)
		user.transferItemToLoc(attacking_item, src, TRUE)
		LAZYADD(processor_contents, attacking_item)
		return TRUE
	else if(!user.combat_mode)
		to_chat(user, span_warning("Это, вероятно, не будет смешиваться!"))
		return TRUE
	else
		return ..()

/obj/machinery/processor/interact(mob/user)
	if(processing)
		to_chat(user, span_warning("[capitalize(declent_ru(NOMINATIVE))] находится в работе!"))
		return TRUE
	if(ismob(user.pulling) && PROCESSOR_SELECT_RECIPE(user.pulling))
		if(user.grab_state < GRAB_AGGRESSIVE)
			to_chat(user, span_warning("Для этого вам нужен хват получше!"))
			return
		var/mob/living/pushed_mob = user.pulling
		visible_message(span_warning("[capitalize(user.declent_ru(NOMINATIVE))] пихает [pushed_mob.name] в [declent_ru(ACCUSATIVE)]!"))
		pushed_mob.forceMove(src)
		LAZYADD(processor_contents, pushed_mob)
		user.stop_pulling()
		return
	if(!LAZYLEN(processor_contents))
		to_chat(user, span_warning("[capitalize(declent_ru(NOMINATIVE))] пустой!"))
		return TRUE
	processing = TRUE
	user.visible_message(span_notice("[capitalize(user.declent_ru(NOMINATIVE))] включил [declent_ru(ACCUSATIVE)]."), \
		span_notice("Вы включили [declent_ru(NOMINATIVE)]."), \
		span_hear("Вы слышите кухонный комбайн."))
	playsound(loc, 'sound/machines/blender.ogg', 50, TRUE)
	use_energy(active_power_usage)
	var/total_time = 0
	for(var/atom/movable/movable_input as anything in processor_contents)
		var/datum/food_processor_process/recipe = PROCESSOR_SELECT_RECIPE(movable_input)
		if (!recipe)
			log_admin("DEBUG: [movable_input] in processor doesn't have a suitable recipe. How did it get in there? Please report it immediately!!!")
			continue
		total_time += recipe.time

	var/duration = (total_time / rating_speed)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, Shake), 1, 0, duration)
	addtimer(CALLBACK(src, PROC_REF(complete_processing)), duration)

/obj/machinery/processor/proc/complete_processing()
	for(var/atom/movable/content_item in processor_contents)
		var/datum/food_processor_process/recipe = PROCESSOR_SELECT_RECIPE(content_item)
		if (!recipe)
			log_admin("DEBUG: [content_item] in processor doesn't have a suitable recipe. How do you put it in?")
			continue
		process_food(recipe, content_item)
	processing = FALSE
	visible_message(span_notice(" [declent_ru(NOMINATIVE)] заканчивает обработку."))

/obj/machinery/processor/verb/eject()
	set category = "Object"
	set name = "Извлечь содержимое"
	set src in oview(1)
	if(usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return
	if(!usr.can_perform_action(src))
		return
	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_UI))
			return
	dump_inventory_contents()
	add_fingerprint(usr)

/obj/machinery/processor/container_resist_act(mob/living/user)
	user.forceMove(drop_location())
	user.visible_message(span_notice("[capitalize(user.declent_ru(NOMINATIVE))] выбирается из кухонного комбайна!"))

/obj/machinery/processor/slime
	name = "slime processor"
	RU_NAMES_LIST_INIT("slime processor", "переработчик слаймов", "переработчика слаймов", "переработчику слаймов", "переработчик слаймов", "переработчиком слаймов", "переработчике слаймов")
	base_icon_state = "processor_slime"
	icon_state = "processor_slime"
	desc = "Промышленный комбайн с наклейкой о том, что он предназначен для научного отдела. Во время работы держите руки подальше от зоны приема."
	circuit = /obj/item/circuitboard/machine/processor/slime

/obj/machinery/processor/slime/adjust_item_drop_location(atom/movable/atom_to_drop)
	var/static/list/slimecores = subtypesof(/obj/item/slime_extract)
	var/i = 0
	if(!(i = slimecores.Find(atom_to_drop.type))) // If the item is not found
		return
	if (i <= 16) // If in the first 12 slots
		atom_to_drop.pixel_x = atom_to_drop.base_pixel_x - 12 + ((i%4)*8)
		atom_to_drop.pixel_y = atom_to_drop.base_pixel_y - 12 + (round(i/4)*8)
		return i
	var/ii = i - 16
	atom_to_drop.pixel_x = atom_to_drop.base_pixel_x - 8 + ((ii%3)*8)
	atom_to_drop.pixel_y = atom_to_drop.base_pixel_y - 8 + (round(ii/3)*8)
	return i

/obj/machinery/processor/slime/process()
	if(processing)
		return
	var/mob/living/basic/slime/picked_slime
	for(var/mob/living/basic/slime/slime in range(1,src))
		if(!CanReach(slime)) //don't take slimes behind glass panes or somesuch; also makes it ignore slimes inside the processor
			continue
		if(slime.stat)
			picked_slime = slime
			break
	if(!picked_slime)
		return
	var/datum/food_processor_process/recipe = PROCESSOR_SELECT_RECIPE(picked_slime)
	if (!recipe)
		return

	visible_message(span_notice("[capitalize(picked_slime.declent_ru(NOMINATIVE))] засасывается в [declent_ru(ACCUSATIVE)]]."))
	LAZYADD(processor_contents, picked_slime)
	picked_slime.forceMove(src)

/obj/machinery/processor/slime/process_food(datum/food_processor_process/recipe, atom/movable/what)
	var/mob/living/basic/slime/processed_slime = what
	if (!istype(processed_slime))
		return

	if(processed_slime.stat != DEAD)
		processed_slime.forceMove(drop_location())
		processed_slime.balloon_alert_to_viewers("ползет")
		return

	var/core_count = processed_slime.cores
	var/extra_cores = rating_amount - 1 // 0-3 bonus cores above what slime already has with upgraded parts
	for(var/i in 1 to (core_count + extra_cores))
		var/atom/movable/item = new processed_slime.slime_type.core_type(drop_location())
		adjust_item_drop_location(item)
		SSblackbox.record_feedback("tally", "slime_core_harvested", 1, processed_slime.slime_type.colour)
	return ..()

#undef PROCESSOR_SELECT_RECIPE
