/datum/mood_event/full_dinner
	description = "Я хорошо пообедал и теперь полон сил, чтобы продолжить работу."
	mood_change = 6
	timeout = 60 MINUTES

/datum/mood_event/came_late_dinner
	description = "Я немного опоздал, но всё равно успел пообедать."
	mood_change = 4
	timeout = 30 MINUTES

/datum/mood_event/dinner_left_early
	description = "Я поел, и этого достаточно. Мне нужно как можно скорее вернуться к своей работе."
	mood_change = 0
	timeout = 10 MINUTES

/datum/mood_event/introvert_on_dinner
	description = "Я не люблю обедать в людных местах."
	mood_change = -2
	timeout = 30 MINUTES

/datum/mood_event/out_dinner_room_eating
	description = "Я не люблю есть вне кафетерия, но работа важнее."
	mood_change = -2
	timeout = 20 MINUTES

/datum/mood_event/out_dinner_room_eating_introvert
	description = "Мне нравится обедать в одиночестве."
	mood_change = 6
	timeout = 60 MINUTES

/datum/mood_event/dont_eat_on_dinner
	description = "Обед закончился, а я ничего не поел!"
	mood_change = -4
	timeout = 40 MINUTES
