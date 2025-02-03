#define DINNER_FOR_ALL "Всех"
#define DINNER_FOR_ENGI "Инженерного Отдела"
#define DINNER_FOR_SEC "Правохранительного Отдела"
#define DINNER_FOR_MED "Медицинского Отдела"
#define DINNER_FOR_CARGO "Отдела Доставок"
#define DINNER_FOR_RND "Научного Отдела"
#define DINNER_FOR_SERVICE "Отдела Обслуживания"

GLOBAL_LIST_EMPTY(department_dinner_types)

/datum/controller/subsystem/ticker/PostSetup()
	. = ..()
	GLOB.department_dinner_types = prepare_dinner()

/datum/controller/subsystem/ticker/proc/prepare_dinner()
	var/list/dinner_list = list()
	for(var/dinner_path in typesof(/datum/dinner))
		var/datum/dinner/new_dinner = new dinner_path
		dinner_list += new_dinner
	return dinner_list

/obj/machinery/computer/communications/proc/run_dinner(what_department)
	for(var/datum/dinner/dinner_in_list in GLOB.department_dinner_types)
		if(dinner_in_list.who_dinner != what_department)
			continue
		dinner_in_list.time_to_dinner()

/datum/dinner
	/// Название обеда(Используется в уишке чтобы показать для какого отдела предназначен обед).
	var/who_dinner = DINNER_FOR_ALL
	/// Переменная проверяющая что обед перезарядился.
	var/dinner_ready = FALSE
	/// Сколько времени уходит на перезарядку обеда.
	var/cooldown_time = 45 MINUTES
	/// Просто таймер.
	var/timer
	/// Какие отделы попадают под влияние этого обеда.
	var/list/jobs_to_give_dinner = list(
		/datum/job_department/security,
		/datum/job_department/cargo,
		/datum/job_department/engineering,
		/datum/job_department/medical,
		/datum/job_department/science,
		/datum/job_department/service,
	)
	/// Места которые будут засчитаны при проведении обеда у всех видов обеда.
	var/list/dinner_places_default = list(
		/area/station/commons/lounge,
		/area/station/service/cafeteria,
		/area/station/service/kitchen,
		/area/station/service/bar
	)
	/// Дополнительные зоны предназначенные для разных видов обеда. Например если обед для инженеров то в обеденные зоны также включается зона отдыха инжнеров.
	var/list/dinner_places = list()

/datum/dinner/New()
	. = ..()
	set_dinner_to_cooldown()

/datum/dinner/proc/set_dinner_to_cooldown()
	if(dinner_ready)
		dinner_ready = FALSE
	if(timer)
		deltimer(timer)
	timer = addtimer(VARSET_CALLBACK(src, dinner_ready, TRUE), cooldown_time, TIMER_STOPPABLE)

/datum/dinner/proc/time_to_dinner()
	priority_announce(
		text = "Командование объявило перерыв на обед для [who_dinner]! \
		Покиньте своё рабочее помещение и отправляйтесь в ближайший кафетерий или комнату отдыха своего отдела на обед. \
		У вас есть 5 минут, чтобы пообедать, после чего вы немедленно должны вернуться к работе!",
		title = "Обеденный Перерыв!",
		sound = 'sound/announcer/announcement/announce_dig.ogg',
		sender_override = "Ежедневное объявление",
		color_override = "green",
	)
	var/list/players_by_job = list()
	for(var/mob/living/carbon/human/one_from_all in GLOB.player_list)
		for(var/datum/job_department/dep_in_list as anything in jobs_to_give_dinner)
			if(!one_from_all.mind?.assigned_role?.departments_list?.Find(dep_in_list))
				continue
			players_by_job += one_from_all
	for(var/mob/living/carbon/human/hungry_human in players_by_job)
		if(!is_station_level(hungry_human.z)) // Только космос спасает от желания пообедать.
			continue
		if(hungry_human.stat == DEAD) // Ну или смерть
			continue
		if(hungry_human.mind.antag_datums)
			continue
		hungry_human.apply_status_effect(/datum/status_effect/dinner_influence, dinner_places + dinner_places_default)
	if(who_dinner == DINNER_FOR_ALL) // Если мы объявляем обед для всех то остальные кнопки обеда тоже идут в кд.
		var/list/other_departments_go_to_cooldown = GLOB.department_dinner_types - src
		for(var/datum/dinner/go_to_cooldown in other_departments_go_to_cooldown)
			if(!go_to_cooldown.dinner_ready)
				continue
			go_to_cooldown.set_dinner_to_cooldown()
	set_dinner_to_cooldown()

/datum/dinner/security
	who_dinner = DINNER_FOR_SEC
	jobs_to_give_dinner = list(
		/datum/job_department/security
	)

/datum/dinner/cargo
	who_dinner = DINNER_FOR_CARGO
	jobs_to_give_dinner = list(
		/datum/job_department/cargo
	)
	dinner_places = list(
		/area/station/cargo/breakroom,
		/area/station/cargo/mining_breakroom
	)

/datum/dinner/engineering
	who_dinner = DINNER_FOR_ENGI
	jobs_to_give_dinner = list(
		/datum/job_department/engineering
	)
	dinner_places = list(
		/area/station/engineering/break_room
	)

/datum/dinner/medical
	who_dinner = DINNER_FOR_MED
	jobs_to_give_dinner = list(
		/datum/job_department/medical
	)
	dinner_places = list(
		/area/station/medical/break_room
	)

/datum/dinner/science
	who_dinner = DINNER_FOR_RND
	jobs_to_give_dinner = list(
		/datum/job_department/science
	)
	dinner_places = list(
		/area/station/science/breakroom
	)

/datum/dinner/service
	who_dinner = DINNER_FOR_SERVICE
	jobs_to_give_dinner = list(
		/datum/job_department/service
	)

#undef DINNER_FOR_ALL
#undef DINNER_FOR_ENGI
#undef DINNER_FOR_SEC
#undef DINNER_FOR_MED
#undef DINNER_FOR_CARGO
#undef DINNER_FOR_RND
#undef DINNER_FOR_SERVICE
