/datum/station_trait/proc/on_lobby_button_click(mob/dead/new_player/user, button_id)
	return // No SCUB and Pet Day

// STANDARD JOB TRAIT HANDLING
/datum/station_trait/job/on_lobby_button_click(mob/dead/new_player/user, button_id)
	if(SSticker.HasRoundStarted())
		to_chat(user, span_redtext("Раунд уже начался!"))
		return

	if(LAZYFIND(lobby_candidates, user))
		LAZYREMOVE(lobby_candidates, user)
		to_chat(user, span_redtext("Вы были убраны из списка кандидатов на роль [name]."))
		user.client << output(list2params(list("false", button_id)), "title_browser:job_sign")
	else
		LAZYADD(lobby_candidates, user)
		to_chat(user, span_greentext("Вы были добавлены в список кандидатов на роль [name]."))
		user.client << output(list2params(list("true", button_id)), "title_browser:job_sign")

// SKUB TRAIT HANDLING
#define PRO_SKUB "pro-skub"
#define ANTI_SKUB "anti-skub"
#define SKUB_IDFC "i don't frikkin' care"
