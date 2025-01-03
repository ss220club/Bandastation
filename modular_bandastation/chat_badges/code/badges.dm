#define CHAT_BADGES_DMI 'modular_bandastation/chat_badges/icons/chatbadges.dmi'

GLOBAL_LIST(badge_icons_cache)

/client/proc/get_ooc_badged_name()
	var/icon/donator_badge_icon = get_badge_icon(get_donator_badge())
	var/icon/worker_badge_icon = get_badge_icon(get_worker_badge())

	var/list/badge_parts = list()
	if(donator_badge_icon)
		badge_parts += icon2base64html(donator_badge_icon)

	if(worker_badge_icon)
		badge_parts += icon2base64html(worker_badge_icon)

	var/list/parts = list()
	if(length(badge_parts))
		parts += badge_parts
	parts += "<font color='[prefs.read_preference(/datum/preference/color/ooc_color) || GLOB.normal_ooc_colour]'>[key]</font>"
	return jointext(parts, "<div style='display: inline-block; width: 3px;'></div>")

/client/proc/get_donator_badge()
	if(prefs.unlock_content && (prefs.toggles & MEMBER_PUBLIC))
		return "ByondMember"

	if(donator_level && prefs.read_preference(/datum/preference/toggle/donor_public))
		return "Tier_[min(donator_level, 5)]"

/client/proc/get_worker_badge()
	var/static/list/rank_badge_map = list(
		"Maxon" = "Wycc",
		"Banda" = "Streamer",
		"Banda Friend" = "Streamer",
		"Host" = "Host",
		"Head Developer" = "HeadDeveloper",
		"Big Developer" = "Developer",
		"Developer" = "Developer",
		"Mini Developer" = "MiniDeveloper",
		"Head Mapper" = "HeadMapper",
		"Mapper" = "Mapper",
		"Spriter" = "Spriceter",
		"Wiki Maintainer" = "WikiLore",
		"Head Admin" = "HeadAdmin",
		"Game Admin" = "GameAdmin",
		"Trial Admin" = "TrialAdmin",
		"Mentor" = "Mentor"
	)
	return rank_badge_map["[holder?.ranks[1]]"]

/client/proc/get_badge_icon(badge)
	if(isnull(badge))
		return null

	var/icon/badge_icon = LAZYACCESS(GLOB.badge_icons_cache, badge)
	if(isnull(badge_icon))
		badge_icon = icon(CHAT_BADGES_DMI, badge)
		LAZYSET(GLOB.badge_icons_cache, badge, badge_icon)

	return badge_icon

#undef CHAT_BADGES_DMI

/datum/preference/toggle/donor_public
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE
	savefile_key = "donor_public"
	savefile_identifier = PREFERENCE_PLAYER
