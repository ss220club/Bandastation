ADMIN_VERB(wl_ban, R_BAN, "WL Ban", "Ban a player from the whitelist.", ADMIN_CATEGORY_MAIN)
	var/banned_ckey = input(user, "Please specify the ckey of the player you want to ban from the whitelist.", "WL Ban", "") as string|null
	banned_ckey = ckey(ckey)
	if(!input)
		return
	var/duration_days = input(user, "Please specify the duration of the ban in days.", "Duration", "") as num|null
	if(!duration_days || duration_days < 0)
		return

	var/reason = input(user, "Please specify the reason for the ban.", "Reason", "") as text|null

	SScentral.whitelist_ban_player(banned_ckey, admin_ckey, duration_days, reason)

	log_admin("[key_name(user)] banned [banned_ckey] from whitelist for [duration_days] days for reason: [reason]")
	message_admins("[key_name_admin(user)] banned [banned_ckey] from whitelist  for [duration_days] days for reason: [reason]")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("WL Ban", "Ckey: [banned_ckey], Duration: [duration_days], Reason: [reason]"))
