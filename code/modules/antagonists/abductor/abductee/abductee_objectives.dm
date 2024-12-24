/datum/objective/abductee
	completed = 1

/datum/objective/abductee/random

/datum/objective/abductee/random/New()
	explanation_text = pick(world.file2list("strings/abductee_objectives.txt"))

/datum/objective/abductee/steal
	explanation_text = "Украдите"

/datum/objective/abductee/steal/New()
	var/target = pick(list("всех животных","все лампочки","всех мартышек","все фрукты","все ботинки","все куски мыла", "всё оружие", "все компьютеры", "все органы"))
	explanation_text+=" [target]."

/datum/objective/abductee/paint
	explanation_text = "Эта станция прогнила... Вы должны добавить в неё"

/datum/objective/abductee/paint/New()
	var/color = pick(list("красных", "голубых", "зелёных", "желтых", "оранжевых", "розовых", "черных", "радужных", "кровавых"))
	explanation_text+= " [color] красок!"

/datum/objective/abductee/speech
	explanation_text = "Ваш мозг сломлен... вы можете коммуницировать только с помощью"

/datum/objective/abductee/speech/New()
	var/style = pick(list("пантомимы", "рифмы", "хайку", "расширенных метафор", "загадок", "крайне буквальных терминов", "звуковых эффектов", "военного жаргона", "трехсловных предложений"))
	explanation_text+= " [style]."

/datum/objective/abductee/capture
	explanation_text = "Похитьте"

/datum/objective/abductee/capture/New()
	var/list/jobs = SSjob.joinable_occupations.Copy()
	for(var/datum/job/job as anything in jobs)
		if(job.current_positions < 1)
			jobs -= job
	if(length(jobs) > 0)
		var/datum/job/target = pick(jobs)
		explanation_text += " [target.title]."
	else
		explanation_text += " кого-либо."

/datum/objective/abductee/calling/New()
	var/mob/dead/D = pick(GLOB.dead_mob_list)
	if(D)
		explanation_text = "Вы знаете, что [D] погиб[genderize_ru(D.gender, "", "ла", "ло", "ли")]. Проведите ритуал, чтобы вызвать [D.ru_p_them()] из мира духов."

/datum/objective/abductee/forbiddennumber

/datum/objective/abductee/forbiddennumber/New()
	var/number = rand(2,10)
	explanation_text = "Игнорируйте всё, что связано с цифрой [number], этого не существует."
