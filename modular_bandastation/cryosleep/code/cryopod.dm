GLOBAL_LIST_EMPTY(objectives)

#define CRYO_JOIN "CRYO_JOIN"
#define CRYO_LEAVE "CRYO_LEAVE"

/datum/objective/New()
	. = ..()
	GLOB.objectives += src

//Apparently objectives can be qdel'd. Learn a new thing every day
/datum/objective/Destroy()
	GLOB.objectives -= src
	return ..()

// Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "Камера предназначенная для киборгов и гуманоидов, является безопасным местом, где персонал, страдающий от расстройства космического сна, может немного отдохнуть."
	icon = 'modular_bandastation/cryosleep/icons/cryogenics.dmi'
	icon_state = "cryopod-open"
	base_icon_state = "cryopod"
	use_power = FALSE
	density = TRUE
	anchored = TRUE
	state_open = TRUE
	interaction_flags_mouse_drop = NEED_DEXTERITY

	var/open_icon_state = "cryopod-open"
	/// Whether the cryopod respects the minimum time someone has to be disconnected before they can be put into cryo by another player
	var/allow_timer_override = FALSE
	/// Minimum time for someone to be SSD before another player can cryo them.
	var/ssd_time = 30 MINUTES //Replace with "cryo_min_ssd_time" CONFIG

	/// Time until despawn when a mob enters a cryopod. You cannot other people in pods unless they're catatonic.
	var/time_till_despawn = 30 SECONDS
	/// Cooldown for when it's now safe to try an despawn the player.
	COOLDOWN_DECLARE(despawn_world_time)

	///Weakref to our controller
	var/datum/weakref/control_computer_weakref
	COOLDOWN_DECLARE(last_no_computer_message)
	/// if false, plays announcement on cryo
	var/quiet = FALSE
	/// Has the occupant been tucked in?
	var/tucked = FALSE

/obj/machinery/cryopod/quiet
	quiet = TRUE

/obj/machinery/cryopod/Initialize(mapload)
	..()
	if(!quiet)
		GLOB.valid_cryopods += src
	return INITIALIZE_HINT_LATELOAD //Gotta populate the cryopod computer GLOB first

/obj/machinery/cryopod/post_machine_initialize()
	. = ..()
	update_icon()
	find_control_computer()

// This is not a good situation
/obj/machinery/cryopod/Destroy()
	GLOB.valid_cryopods -= src
	control_computer_weakref = null
	return ..()

/obj/machinery/cryopod/proc/find_control_computer(urgent = FALSE)
	for(var/cryo_console as anything in GLOB.cryopod_computers)
		var/obj/machinery/computer/cryopod/console = cryo_console
		if(get_area(console) == get_area(src))
			control_computer_weakref = WEAKREF(console)
			break

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer_weakref && urgent && COOLDOWN_FINISHED(src, last_no_computer_message))
		COOLDOWN_START(src, last_no_computer_message, 5 MINUTES)
		log_admin("Cryopod in [get_area(src)] could not find control computer!")
		message_admins("Cryopod in [get_area(src)] could not find control computer!")
		last_no_computer_message = world.time

	return control_computer_weakref != null

/obj/machinery/cryopod/close_machine(atom/movable/target, density_to_set = TRUE)
	if(!control_computer_weakref)
		find_control_computer(TRUE)
	if((isnull(target) || isliving(target)) && state_open && !panel_open)
		. = ..(target)
		var/mob/living/mob_occupant = occupant
		if(mob_occupant?.stat != DEAD)
			to_chat(occupant, span_notice("<b>Вы чувствуете, как холодный воздух обволакивает вас. Чувства затухают и ваше тело немеет.</b>"))

		COOLDOWN_START(src, despawn_world_time, time_till_despawn)

/obj/machinery/cryopod/open_machine(drop = TRUE, density_to_set = FALSE)
	. = ..()
	set_density(TRUE)
	name = initial(name)
	tucked = FALSE

/obj/machinery/cryopod/container_resist_act(mob/living/user)
	visible_message(span_notice("[capitalize(occupant.declent_ru(NOMINATIVE))] вылезает из [declent_ru(GENITIVE)]!"),
		span_notice("Вы вылезаете из [declent_ru(GENITIVE)]!"))
	open_machine()

/obj/machinery/cryopod/relaymove(mob/user)
	container_resist_act(user)

/obj/machinery/cryopod/process()
	if(!isliving(occupant))
		return

	var/mob/living/mob_occupant = occupant
	if(mob_occupant.stat == DEAD)
		open_machine()

	if(!mob_occupant.client && COOLDOWN_FINISHED(src, despawn_world_time))
		if(!control_computer_weakref)
			find_control_computer(urgent = TRUE)

		despawn_occupant()

/obj/machinery/cryopod/proc/handle_objectives()
	if(!isliving(occupant))
		return

	var/mob/living/mob_occupant = occupant
	// Update any existing objectives involving this mob.
	for(var/datum/objective/objective in GLOB.objectives)
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(istype(objective,/datum/objective/mutiny) && objective.target == mob_occupant.mind)
			objective.team.objectives -= objective
			qdel(objective)
			for(var/datum/mind/mind in objective.team.members)
				to_chat(mind.current, "<BR>[span_userdanger("Ваша цель вне зоны досягаемости. Цель удалена!")]")
				mind.announce_objectives()
			return
		if(istype(objective.target) && objective.target == mob_occupant.mind)
			var/old_target = objective.target
			objective.target = null
			objective.find_target()
			if(!objective.target && objective.owner)
				to_chat(objective.owner.current, "<BR>[span_userdanger("Ваша цель вне зоны досягаемости. Цель удалена!")]")
				for(var/datum/antagonist/antag in objective.owner.antag_datums)
					antag.objectives -= objective
			if (!objective.team)
				objective.update_explanation_text()
				objective.owner.announce_objectives()
				to_chat(objective.owner.current, "<BR>[span_userdanger("Вы чувствуете, что ваша цель вне зоны досягаемости. Время плана [pick("Б","В","Г","Д","Ж","З")]. Цели обновлены!")]")
			else
				var/list/objectives_to_update
				for(var/datum/mind/objective_owner in objective.get_owners())
					to_chat(objective_owner.current, "<BR>[span_userdanger("Вы чувствуете, что ваша цель вне зоны досягаемости. Время плана [pick("Б","В","Г","Д","Ж","З")]. Цели обновлены!")]")
					for(var/datum/objective/update_target_objective in objective_owner.get_all_objectives())
						LAZYADD(objectives_to_update, update_target_objective)
				objectives_to_update += objective.team.objectives
				for(var/datum/objective/update_objective in objectives_to_update)
					if(update_objective.target != old_target || !istype(update_objective,objective.type))
						continue
					update_objective.target = objective.target
					update_objective.update_explanation_text()
					to_chat(objective.owner.current, "<BR>[span_userdanger("Вы чувствуете, что ваша цель вне зоны досягаемости. Время плана [pick("Б","В","Г","Д","Ж","З")]. Цели обновлены!")]")
					update_objective.owner.announce_objectives()
			qdel(objective)

/// This function can not be undone; do not call this unless you are sure.
/// Handles despawning the player.
/obj/machinery/cryopod/proc/despawn_occupant()
	if(!isliving(occupant))
		return

	var/mob/living/mob_occupant = occupant

	var/occupant_ckey = mob_occupant.ckey || mob_occupant.mind?.key
	var/occupant_name = mob_occupant.name
	var/occupant_rank = mob_occupant.mind?.assigned_role.title
	var/occupant_departments_bitflags = mob_occupant.mind?.assigned_role.departments_bitflags
	var/occupant_job_radio = mob_occupant.mind?.assigned_role.default_radio_channel
	var/occupant_gender = mob_occupant.gender // для аннонсов

	SSjob.FreeRoleCryo(occupant_rank)

	// Delete them from datacore and ghost records.
	var/announce_rank = null

	for(var/list/record in GLOB.ghost_records)
		if(record["name"] == occupant_name)
			announce_rank = record["rank"]
			GLOB.ghost_records.Remove(list(record))
			break

	if(!announce_rank) // No need to loop over all of those if we already found it beforehand.
		for(var/datum/record/crew/possible_target_record as anything in GLOB.manifest.general)
			if(possible_target_record.name == occupant_name && (occupant_rank == "N/A" || possible_target_record.trim == job_title_ru(occupant_rank)))
				announce_rank = possible_target_record.rank
				qdel(possible_target_record)
				break

	var/obj/machinery/computer/cryopod/control_computer = control_computer_weakref?.resolve()
	if(!control_computer)
		control_computer_weakref = null
	else
		control_computer.frozen_crew += list(list("name" = occupant_name, "job" = job_title_ru(occupant_rank)))

		// Make an announcement and log the person entering storage. If set to quiet, does not make an announcement.
		if(!quiet)
			control_computer.announce(CRYO_LEAVE, mob_occupant.real_name, announce_rank, occupant_departments_bitflags, occupant_job_radio, occupant_gender)

	visible_message(span_notice("[capitalize(declent_ru(NOMINATIVE))] гудит и шипит, перемещая [mob_occupant.declent_ru(ACCUSATIVE)] в хранилище."))

	for(var/obj/item/item_content as anything in mob_occupant)
		if(!istype(item_content) || HAS_TRAIT(item_content, TRAIT_NODROP))
			continue
		if(issilicon(mob_occupant) && istype(item_content, /obj/item/mmi))
			continue
		if(control_computer)
			if(istype(item_content, /obj/item/modular_computer))
				var/obj/item/modular_computer/computer = item_content
				for(var/datum/computer_file/program/messenger/message_app in computer.stored_files)
					message_app.invisible = TRUE
			mob_occupant.transferItemToLoc(item_content, control_computer, force = TRUE, silent = TRUE)
			item_content.dropped(mob_occupant)
			control_computer.frozen_item += item_content
		else
			mob_occupant.transferItemToLoc(item_content, drop_location(), force = TRUE, silent = TRUE)

	GLOB.joined_player_list -= occupant_ckey

	handle_objectives()
	mob_occupant.ghostize()
	QDEL_NULL(occupant)
	open_machine()
	name = initial(name)

/obj/machinery/cryopod/mouse_drop_receive(mob/living/target, mob/user, params)
	if(!istype(target) || isanimal(target) || !istype(user.loc, /turf) || target.buckled)
		return

	if(occupant)
		to_chat(user, span_notice("[capitalize(declent_ru(NOMINATIVE))] уже занята!"))
		return

	if(target.stat == DEAD)
		to_chat(user, span_notice("Мёртвых людей нельзя поместить в криохранилище."))
		return

// Allows admins to enable players to override SSD Time check.
	if(allow_timer_override)
		if(tgui_alert(user, "Хотите помесить [target.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]?", "Поместить в [declent_ru(ACCUSATIVE)]?", list("Да", "Нет")) == "Да")
			to_chat(user, span_danger("Вы помещаете [target.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]."))
			log_admin("[key_name(user)] has put [key_name(target)] into a overridden stasis pod.")
			message_admins("[key_name(user)] has put [key_name(target)] into a overridden stasis pod. [ADMIN_JMP(src)]")

			add_fingerprint(target)

			close_machine(target)
			ru_names_rename(ru_names_toml(src::name, suffix = " ([target.declent_ru(NOMINATIVE)])", override_base = "[name] ([target.name])"))
			name = "[name] ([target.name])"

// Allows players to cryo others. Checks if they have been AFK for 30 minutes.
	if(target.key && user != target)
		if(target.get_organ_by_type(/obj/item/organ/brain)) //Target the Brain
			if(!target.mind || target.is_ssd) // Is the character empty / AI Controlled
				if(target.lastclienttime + ssd_time >= world.time)
					to_chat(user, span_notice("Вы не можете поместить [target.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)] ещё [round(((ssd_time - (world.time - target.lastclienttime)) / (1 MINUTES)), 1)] минут."))
					log_admin("[key_name(user)] has attempted to put [key_name(target)] into a stasis pod, but they were only disconnected for [round(((world.time - target.lastclienttime) / (1 MINUTES)), 1)] minutes.")
					message_admins("[key_name(user)] has attempted to put [key_name(target)] into a stasis pod. [ADMIN_JMP(src)]")
					return
				else if(tgui_alert(user, "Хотите поместить [target.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]?", "Поместить в криокамеру?", list("Да", "Нет")) == "Да")
					if(target.mind.assigned_role.req_admin_notify)
						tgui_alert(user, "Они играют на важной роли! Уверены что хотите переместить их в криохранилище?")
					to_chat(user, span_danger("Вы помещаете [target.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]."))
					log_admin("[key_name(user)] has put [key_name(target)] into a stasis pod.")
					message_admins("[key_name(user)] has put [key_name(target)] into a stasis pod. [ADMIN_JMP(src)]")

					add_fingerprint(target)

					close_machine(target)

					ru_names_rename(ru_names_toml(src::name, suffix = " ([target.declent_ru(NOMINATIVE)])", override_base = "[name] ([target.name])"))
					name = "[name] ([target.name])"

		else if(iscyborg(target))
			to_chat(user, span_danger("Вы не можете поместить [target.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]. Юнит активен."))
		else
			to_chat(user, span_danger("Вы не можете поместить [target.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]. [target.ru_p_they(TRUE)] в сознании."))
		return

	if(target == user && (tgui_alert(target, "Войти в криохранилище?", "Войти в криокапсулу?", list("Да", "Нет")) == "Нет"))
		return

	if(target == user)
		if(target.mind.assigned_role.req_admin_notify)
			tgui_alert(target, "Вы играете на важной роли! Уверены что хотите покинуть раунд?")
		var/datum/antagonist/antag = target.mind.has_antag_datum(/datum/antagonist)
		if(antag)
			tgui_alert(target, "Вы [antag.name]! Уверены что хотите покинуть раунд?")

	if(LAZYLEN(target.buckled_mobs) > 0)
		if(target == user)
			to_chat(user, span_danger("Вы не сможете влезеть в [declent_ru(ACCUSATIVE)], пока к вам кто-то пристёгнут."))
		else
			to_chat(user, span_danger("[capitalize(target.declent_ru(NOMINATIVE))] не сможет влезть в [declent_ru(ACCUSATIVE)], пока [target.ru_p_they()] пристёгнут[genderize_ru(target.gender, "", "а", "о", "ы")]."))
		return

	if(!istype(target) || !can_interact(user) || !target.Adjacent(user) || !ismob(target) || isanimal(target) || !istype(user.loc, /turf) || target.buckled)
		return
		// rerun the checks in case of shenanigans

	if(occupant)
		to_chat(user, span_notice("[capitalize(declent_ru(NOMINATIVE))] занята!"))
		return

	if(target == user)
		visible_message(span_infoplain("[capitalize(user.declent_ru(NOMINATIVE))] залезает в [declent_ru(ACCUSATIVE)]."))
	else
		visible_message(span_infoplain("[capitalize(user.declent_ru(NOMINATIVE))] помещает [target.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]."))

	to_chat(target, span_warning("<b>Если вы станете призраком, выйдете из игры или закроете клиент, ваш персонаж вскоре будет навсегда удален из раунда.</b>"))

	log_admin("[key_name(target)] entered a stasis pod.")
	message_admins("[key_name_admin(target)] entered a stasis pod. [ADMIN_JMP(src)]")
	add_fingerprint(target)

	close_machine(target)
	ru_names_rename(ru_names_toml(src::name, suffix = " ([target.declent_ru(NOMINATIVE)])", override_base = "[name] ([target.name])"))
	name = "[name] ([target.name])"

// Attacks/effects.
/obj/machinery/cryopod/blob_act()
	return // Sorta gamey, but we don't really want these to be destroyed.

/obj/machinery/cryopod/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(istype(tool, /obj/item/bedsheet))
		if(!isliving(occupant))
			return ITEM_INTERACT_BLOCKING
		if(tucked)
			to_chat(user, span_warning("[capitalize(occupant.declent_ru(NOMINATIVE))] выглядит уже достаточно комфортабельно!"))
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice("Вы укладываете [occupant.declent_ru(ACCUSATIVE)] в [declent_ru(ACCUSATIVE)]!"))
		qdel(tool)
		user.add_mood_event("tucked", /datum/mood_event/tucked_in, occupant)
		tucked = TRUE
		return ITEM_INTERACT_SUCCESS

/obj/machinery/cryopod/update_icon_state()
	icon_state = state_open ? open_icon_state : base_icon_state
	return ..()

/// Special wall mounted cryopod for the prison, making it easier to autospawn.
/obj/machinery/cryopod/prison
	icon_state = "prisonpod"
	base_icon_state = "prisonpod"
	open_icon_state = "prisonpod"
	density = FALSE

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/cryopod/prison, 18)

/obj/machinery/cryopod/prison/close_machine(atom/movable/target, density_to_set = FALSE)
	. = ..()
	// Flick the pod for a second when user enters
	set_density(FALSE)
	flick("prisonpod-open", src)

/obj/machinery/cryopod/prison/open_machine(drop = TRUE, density_to_set = FALSE)
	. = ..()
	set_density(FALSE)
	flick("prisonpod-open", src)

#undef CRYO_JOIN
#undef CRYO_LEAVE
