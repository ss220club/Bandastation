/datum/computer_file/program/dinner_manager
	filename = "dinner_manager_V220"
	filedesc = "Dinner Manager"
	downloader_category = PROGRAM_CATEGORY_SECURITY
	program_open_overlay = "generic"
	extended_desc = "Программа позволяет удалённо управлять обеденным менеджером."
	program_flags = PROGRAM_UNIQUE_COPY
	size = 4
	tgui_id = "NtosDinnerManager"
	program_icon = "utensils"
	var/obj/machinery/computer/communications/coms_ref

/datum/computer_file/program/dinner_manager/on_install()
	. = ..()
	coms_ref = new /obj/machinery/computer/communications

/datum/computer_file/program/dinner_manager/ui_data(mob/user)
	var/list/data = list()
	data["station_code_allowed"] = SSsecurity_level?.current_security_level?.number_level >= SEC_LEVEL_RED ? FALSE : TRUE
	data["dinner_types"] = list()
	if(GLOB.department_dinner_types)
		for(var/dinner_type in GLOB.department_dinner_types)
			var/datum/dinner/dinner_in_list = dinner_type
			data["dinner_types"] += list(list(
				"dinner_name" = dinner_in_list.who_dinner,
				"dinner_ready" = dinner_in_list.dinner_ready,
				"dinner_cooldown" = floor(timeleft(dinner_in_list.timer) / 600),
			))
	return data

/datum/computer_file/program/dinner_manager/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("toggleDinnerReady")
			var/is_ready = params["is_ready"]
			var/dep_name = params["dinner_name"]
			var/timer_cooldown = params["cooldown"]
			if(!is_ready)
				to_chat(ui.user, span_warning("Объявить обед можно будет только через: [floor(timeleft(timer_cooldown) / 600)] минут!"))
				return
			coms_ref.run_dinner(dep_name)
