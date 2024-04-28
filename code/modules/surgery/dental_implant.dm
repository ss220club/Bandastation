/datum/surgery/dental_implant
	name = "Зубное имплантирование"
	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)
	steps = list(
		/datum/surgery_step/drill,
		/datum/surgery_step/insert_pill,
	)

/datum/surgery_step/insert_pill
	name = "вставьте таблетку"
	implements = list(/obj/item/reagent_containers/pill = 100)
	time = 16

/datum/surgery_step/insert_pill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете вставлять [tool.name] в [parse_zone(target_zone)] у [target]..."),
		span_notice("[user] начинает вставлять [tool.name] в [parse_zone(target_zone)] у [target]."),
		span_notice("[user] начинает вставлять что-то в [parse_zone(target_zone)] у [target]."),
	)
	display_pain(target, "Что-то засовывают вам в [parse_zone(target_zone)]!")

/datum/surgery_step/insert_pill/success(mob/user, mob/living/carbon/target, target_zone, obj/item/reagent_containers/pill/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(!istype(tool))
		return FALSE

	user.transferItemToLoc(tool, target, TRUE)

	var/datum/action/item_action/hands_free/activate_pill/pill_action = new(tool)
	pill_action.name = "Активируйте [tool.name]"
	pill_action.build_all_button_icons()
	pill_action.target = tool
	pill_action.Grant(target) //The pill never actually goes in an inventory slot, so the owner doesn't inherit actions from it

	display_results(
		user,
		target,
		span_notice("Вы вставили [tool.name] в [parse_zone(target_zone)] у [target]."),
		span_notice("[user] вставил [tool.name] в [parse_zone(target_zone)] у [target]!"),
		span_notice("[user] вставил что-то в [parse_zone(target_zone)] у [target]!"),
	)
	return ..()

/datum/action/item_action/hands_free/activate_pill
	name = "Активировать таблетку"

/datum/action/item_action/hands_free/activate_pill/Trigger(trigger_flags)
	if(!..())
		return FALSE
	var/obj/item/item_target = target
	to_chat(owner, span_notice("Вы стискиваете зубы и ломаете вживленный [item_target.name]!"))
	owner.log_message("проглотил вживленную таблетку, [target]", LOG_ATTACK)
	if(item_target.reagents.total_volume)
		item_target.reagents.trans_to(owner, item_target.reagents.total_volume, transferred_by = owner, methods = INGEST)
	qdel(target)
	return TRUE
