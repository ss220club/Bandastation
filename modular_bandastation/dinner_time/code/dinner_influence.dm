/datum/status_effect/dinner_influence
	id = "dinner_influence"
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/dinner_influence
	show_duration = TRUE
	/// Места где мы можем пообедать с другими.
	var/list/areas_to_dinner
	/// 2-минутный таймер, после чего будет засчитываться опоздание на обед.
	var/two_minutes_left = FALSE
	/// Если мы поели по истечению 2-минутного таймера.
	var/wa_late_on_dinner = FALSE
	/// Проверка на то, что мы всё ещё находимся в зоне обеда.
	/// В случае, если обед закончится и в это время мы не находимся в обеденной зоне, игра засчитает, что ты ушёл с обеда пораньше..
	var/we_on_dinner_place = FALSE
	/// Если мы хоть что-то поели с наложенным статусом, то можно считать это за обед.
	var/we_ate_on_dinner = FALSE
	/// Запоминает муд, который мы заработали во время обеда, и выдает его по окончании обеда.
	var/datum/mood_event/what_mood_event_we_got

/atom/movable/screen/alert/status_effect/dinner_influence
	name = "Обеденный перерыв!"
	desc = "Самое время отправиться в кафетерий и насладиться обедом!"
	icon = 'modular_bandastation/dinner_time/icons/hud/screen_alert.dmi'
	icon_state = "dinner_influence"

/datum/status_effect/dinner_influence/on_creation(mob/living/new_owner, list/areas_to_dinner)
	. = ..()
	if(new_owner.nutrition >= NUTRITION_LEVEL_FED)
		new_owner.adjust_nutrition(-100)
	addtimer(VARSET_CALLBACK(src, two_minutes_left, TRUE), 2 MINUTES)
	src.areas_to_dinner = areas_to_dinner

/datum/status_effect/dinner_influence/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_FINISH_EAT, PROC_REF(eating_on_dinner_time))
	RegisterSignal(owner, COMSIG_ENTER_AREA, PROC_REF(enter_area_on_dinner_time))

/// У нас также есть 3 типа настроения, которые переопределяют mood_event_we_got:
//-// если мы ничего не поели.
//-// если у нас полноценный обед (мы не опоздали на обед, что-то поели и находились в обеденной зоне, когда обед закончился).
//-// если у нас нет событий настроения в mood_event_we_got.
/datum/status_effect/dinner_influence/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_LIVING_FINISH_EAT)
	UnregisterSignal(owner, COMSIG_ENTER_AREA)

	if(!we_ate_on_dinner)
		owner.add_mood_event(id, /datum/mood_event/dont_eat_on_dinner)
		return
	if(!wa_late_on_dinner && we_on_dinner_place)
		if(HAS_TRAIT(owner, TRAIT_INTROVERT))
			owner.add_mood_event(id, /datum/mood_event/introvert_on_dinner)
			return
		owner.add_mood_event(id, /datum/mood_event/full_dinner)
		return
	if(!what_mood_event_we_got)
		owner.add_mood_event(id, /datum/mood_event/dinner_left_early)
		return
	owner.add_mood_event(id, what_mood_event_we_got)

/// Proc проверяет, когда мы что-то поели. Проверяет, где мы поели, опоздали ли мы и запоминает новое настроение.
/datum/status_effect/dinner_influence/proc/eating_on_dinner_time(mob/living/carbon/human/hungry_human, datum/what_we_ate)
	SIGNAL_HANDLER
	if(we_ate_on_dinner)
		UnregisterSignal(owner, COMSIG_LIVING_FINISH_EAT)
		return
	if(!we_on_dinner_place)
		if(HAS_TRAIT(hungry_human, TRAIT_INTROVERT))
			new_mood_event(hungry_human, /datum/mood_event/out_dinner_room_eating_introvert)
			we_ate_on_dinner = TRUE
			return
		new_mood_event(hungry_human, /datum/mood_event/out_dinner_room_eating)
		we_ate_on_dinner = TRUE
		return
	if(two_minutes_left)
		new_mood_event(hungry_human, /datum/mood_event/came_late_dinner)
		we_ate_on_dinner = wa_late_on_dinner = TRUE
		return
	we_ate_on_dinner = TRUE

/// Proc проверяет, когда мы входим в зону. Проверяет, пришли ли мы в обеденную зону и обновляет переменную we_on_dinner_place.
/datum/status_effect/dinner_influence/proc/enter_area_on_dinner_time(mob/living/carbon/human/hungry_human, area/new_area)
	SIGNAL_HANDLER
	if(we_on_dinner_place && is_type_in_list(new_area, areas_to_dinner))
		return
	if(we_on_dinner_place && !is_type_in_list(new_area, areas_to_dinner))
		we_on_dinner_place = FALSE
		return
	if(!we_on_dinner_place && is_type_in_list(new_area, areas_to_dinner))
		we_on_dinner_place = TRUE
		return

/// Рассчитывает новое настроение, которое у нас есть, и записывает его, если его влияние выше.
/datum/status_effect/dinner_influence/proc/new_mood_event(mob/living/give_my_mood_event, datum/mood_event/event_type)
	if(!what_mood_event_we_got)
		what_mood_event_we_got = event_type
		return
	if(what_mood_event_we_got.mood_change > event_type.mood_change)
		return
	what_mood_event_we_got = event_type
