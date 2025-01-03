/mob/living/silicon/ai/verb/ai_cryo()
	set name = "AI Cryogenic Stasis"
	set desc = "Перемещает текущий ИИ в криогенное хранилище, освобождая место для другого."
	set category = "AI Commands"

	if(incapacitated)
		return
	if(tgui_alert(usr, "Войти в криогенный стазис? Вы станете призраком.", "Войти в криогенный стазис", list("Да", "Нет")) == "Да")
		ghostize(FALSE)
		minor_announce("Станционный ИИ был отключён от внутренних систем и был перемещён на хранение. Производится подготовка для загрузки нового ИИ.", "Станционный ИИ")
		new /obj/structure/ai_core/latejoin_inactive(loc)
		if(mind)
			//Handle job slot/tater cleanup.
			if(mind.assigned_role.title == JOB_AI)
				SSjob.FreeRoleCryo(JOB_AI)
		mind.special_role = null
		qdel(src)
