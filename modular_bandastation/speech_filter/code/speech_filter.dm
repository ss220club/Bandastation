#define BRAINROT_FILTER_FILE "config/bandastation/brainrot_filter.json"

/datum/element/speech_filter
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY
	/// what is displayed to the speaker on replace
	var/static/list/brainrot_notifications = list(
		"Почему у меня такой скудный словарный запас? Стоит сходить в библиотеку и прочесть книгу...",
		"Что, черт побери, я несу?",
		"Я в своём уме? Надо следить за языком.",
		"Неужели я не могу подобрать нужных слов? Позор мне..."
	)

/datum/element/speech_filter/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	var/mob/mob_to_censor = target
	if(!mob_to_censor.client)
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(mob_to_censor, COMSIG_MOB_SAY, PROC_REF(filter_speech), TRUE)
	RegisterSignal(mob_to_censor, COMSIG_MOB_LOGOUT, PROC_REF(Detach), TRUE)

/datum/element/speech_filter/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_MOB_SAY)
	UnregisterSignal(source, COMSIG_MOB_LOGOUT)

/datum/element/speech_filter/proc/filter_speech(mob/speaker, list/speech_args)
	if(!CONFIG_GET(flag/enable_speech_filter) || can_bypass_filter(speaker))
		return

	var/message = speech_args[SPEECH_MESSAGE]
	if(!length(message))
		return

	if(message[1] == "*")
		return

	var/brainrot_regex = get_brainrot_filter_regex()
	if(!brainrot_regex)
		return

	var/original_message = copytext(message, 1)
	message = rustutils_regex_replace(message, brainrot_regex, "i", "цветочек")
	if(original_message == message)
		return

	speech_args[SPEECH_MESSAGE] = message
	addtimer(CALLBACK(speaker, TYPE_PROC_REF(/mob, emote), "drool"), 0.3 SECONDS)
	to_chat(speaker, span_priorityalert(pick(brainrot_notifications)))
	if(check_streamer_active_admin())
		message_admins("[ADMIN_LOOKUPFLW(speaker)] has attempted to say forbidden word. The message was: \
		<a href='byond://?src=[REF(src)];speaker=[key_name(speaker)];message=[original_message]'>SEE MESSAGE</a>")
	else
		message_admins("[ADMIN_LOOKUPFLW(speaker)] has attempted to say forbidden word. The message was: [original_message]")

	log_game("[key_name(speaker)] has attempted to say forbidden word. His message was: [original_message]")

/datum/element/speech_filter/proc/check_streamer_active_admin()
	var/static/list/streamer_rank = list("Максон","Банда")
	for(var/client/admin as anything in GLOB.admins)
		if(admin.holder.name in streamer_rank)
			return TRUE

/datum/element/speech_filter/Topic(href, list/href_list)
	if (..())
		return
	if(!check_rights(R_ADMIN))
		return
	if(href_list["speaker"] && href_list["message"])
		tgui_alert(usr, href_list["message"], href_list["speaker"], autofocus = FALSE)

/datum/element/speech_filter/proc/get_brainrot_filter_regex()
	if(!fexists(BRAINROT_FILTER_FILE))
		return

	var/static/list/filters

	if(!length(filters))
		var/raw_filter = file2text(BRAINROT_FILTER_FILE)
		if(raw_filter)
			var/list/parsed_filter = safe_json_decode(raw_filter)
			if(isnull(parsed_filter))
				log_config("JSON parsing failure for [BRAINROT_FILTER_FILE]")
			else
				filters = parsed_filter["brainrot_filter"]

	if(!length(filters))
		return list()

	var/static/brainrot_regex
	if(!brainrot_regex)
		var/list/unique_filters = unique_list(filters)

		brainrot_regex = unique_filters.Join("|")

	return brainrot_regex

/datum/element/speech_filter/proc/can_bypass_filter(mob/mob_to_check)
	return mob_to_check.client.ckey in ckey_list(CONFIG_GET(str_list/speech_filter_bypass))

/datum/element/speech_filter/proc/ckey_list(list/list_to_ckey)
	. = list()
	for(var/i in list_to_ckey)
		. |= LIST_VALUE_WRAP_LISTS(ckey(i))

#undef BRAINROT_FILTER_FILE
