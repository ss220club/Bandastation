/**
 * Enables an admin to upload a new titlescreen image.
 */
ADMIN_VERB(change_title_screen, R_FUN, "Title Screen: Change", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_EVENTS)
	if(!check_rights(R_FUN))
		return

	log_admin("[key_name(usr)] is changing the title screen.")
	message_admins("[key_name_admin(usr)] is changing the title screen.")

	switch(tgui_alert(usr, "Что делаем с изображением в лобби?", "Лобби", list("Меняем", "Сбрасываем", "Ничего")))
		if("Меняем")
			var/file = input(usr) as icon|null
			if(!file)
				return

			SStitle.set_title_image(file)
		if("Сбрасываем")
			SStitle.set_title_image()
		if("Ничего")
			return

/**
 * Sets a titlescreen notice, a big red text on the main screen.
 */
ADMIN_VERB(change_title_screen_notice, R_FUN, "Title Screen: Set Notice", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_EVENTS)
	if(!check_rights(R_FUN))
		return

	log_admin("Title Screen: [key_name(usr)] is setting the title screen notice.")
	message_admins("Title Screen: [key_name_admin(usr)] is setting the title screen notice.")

	var/new_notice = tgui_input_text(usr, "Введи то что должно отображаться в лобби:", "Уведомление в лобби", max_length = 2048)
	if(isnull(new_notice))
		message_admins("Title Screen: [key_name_admin(usr)] changed mind to change title screen notice.")
		return

	var/announce_text
	if(new_notice == "")
		announce_text = "УВЕДОМЛЕНИЕ В ЛОББИ УДАЛЕНО."
	else
		announce_text = "УВЕДОМЛЕНИЕ В ЛОББИ ОБНОВЛЕНО: [new_notice]"

	SStitle.set_notice(new_notice)
	for(var/mob/new_player in GLOB.player_list)
		to_chat(new_player, span_boldannounce(announce_text))
		SEND_SOUND(new_player,  sound('sound/items/bikehorn.ogg'))

/**
 * An admin debug command that enables you to change the CSS on the go.
 */
ADMIN_VERB(change_title_screen_html, R_DEBUG, "Title Screen: Set CSS", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_EVENTS)
	if(!check_rights(R_DEBUG))
		return

	log_admin("Title Screen: [key_name(usr)] is setting the title screen CSS.")
	message_admins("Title Screen: [key_name_admin(usr)] is setting the title screen CSS.")

	SStitle.set_title_css()

/**
 * Reloads the titlescreen if it is bugged for someone.
 */
/client/verb/fix_title_screen()
	set name = "Fix Lobby Screen"
	set desc = "Lobbyscreen broke? Press this."
	set category = "OOC"

	SStitle.show_title_screen_to(src)

