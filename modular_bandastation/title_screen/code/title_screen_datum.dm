/datum/title_screen
	/// All title screen styles.
	var/title_css = DEFAULT_TITLE_SCREEN_HTML_CSS
	/// The current notice text, or null.
	var/notice
	/// The current title screen being displayed, as `/datum/asset_cache_item`
	var/datum/asset_cache_item/screen_image

/datum/title_screen/New(styles, notice, screen_image_file)
	if(styles)
		src.title_css = styles
	src.notice = notice
	set_screen_image(screen_image_file)

/datum/title_screen/proc/set_screen_image(screen_image_file)
	if(!screen_image_file)
		return

	if(!isfile(screen_image_file))
		screen_image_file = fcopy_rsc(screen_image_file)

	screen_image = SSassets.transport.register_asset("[screen_image_file]", screen_image_file)

/datum/title_screen/proc/show_to(client/viewer)
	if(!viewer)
		return

	winset(viewer, "title_browser", "is-disabled=false;is-visible=true")
	winset(viewer, "status_bar", "is-visible=false")

	var/datum/asset/lobby_asset = get_asset_datum(/datum/asset/simple/html_title_screen)
	var/datum/asset/fontawesome = get_asset_datum(/datum/asset/simple/namespaced/fontawesome)
	lobby_asset.send(viewer)
	fontawesome.send(viewer)

	SSassets.transport.send_assets(viewer, screen_image.name)
	viewer << browse(get_title_html(viewer, viewer.mob), "window=title_browser")

/datum/title_screen/proc/hide_from(client/viewer)
	if(viewer?.mob)
		winset(viewer, "title_browser", "is-disabled=true;is-visible=false")
		winset(viewer, "status_bar", "is-visible=true;focus=true")

/datum/title_screen/proc/create_main_button(user, href, text, advanced_classes)
	return {"
		<a class="lobby_element lobby-[href] [advanced_classes]" href='byond://?src=[REF(user)];[href]=1'>
			<span class="lobby-text">[text]</span>
			<img class="pixelated" src="[SSassets.transport.get_asset_url(asset_name = "lobby_[href].png")]">
		</a>
	"}

/datum/title_screen/proc/create_icon_button(user, href, tooltip, tooltip_position = "bottom", enabled = TRUE)
	return {"
		<a class="lobby_button lobby_element lobby-[href] [!enabled ? "disabled" : ""]" href='byond://?src=[REF(user)];[enabled ? href : ""]=1'>
			<div class="toggle">
				<img class="pixelated indicator [!enabled ? "disabled" : ""]" src="[SSassets.transport.get_asset_url(asset_name = "lobby_[enabled ? "highlight" : "disabled"].png")]">
			</div>
			<img class="pixelated" src="[SSassets.transport.get_asset_url(asset_name = "lobby_[href].png")]">
			[tooltip ? {"
			<div class="lobby-tooltip" data-position="[tooltip_position]">
				<span class="lobby-tooltip-content">[tooltip]</span>
			</div> "} : ""]
		</a>
	"}

/**
 * Get the HTML of title screen.
 */
/datum/title_screen/proc/get_title_html(client/viewer, mob/user)
	var/screen_image_url = SSassets.transport.get_asset_url(asset_cache_item = screen_image)
	var/mob/dead/new_player/player = user
	var/list/html = list()
	html += {"
		<!DOCTYPE html>
		<html>
		<head>
			<title>Title Screen</title>
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<style type='text/css'>
				[file2text(title_css)]
			</style>
		</head>
		<body>
	"}

	if(screen_image_url)
		html += {"<img id="screen_image" class="bg" src="[screen_image_url]">"}

	html += {"<div id="container_notice" class="hidden">[notice]</div>"}
	html += {"<input type="checkbox" id="hide_menu">"}
	html += {"<div class="lobby_wrapper">"}
	html += {"
		<div class="lobby_container">
			<img class="lobby_background pixelated" src="[SSassets.transport.get_asset_url(asset_name = "lobby_background.png")]">
			<img class="lobby_shutter pixelated" src="[SSassets.transport.get_asset_url(asset_name = "lobby_shutter.png")]">
	"}

	html += {"<div class="lobby_buttons-center">"}
	if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME)
		html += create_main_button(player, "toggle_ready", "ГОТОВ", player.ready == PLAYER_READY_TO_PLAY ? "good" : "bad")
	else
		html += create_main_button(player, "late_join", "ИГРАТЬ")

	html += create_main_button(player, "observe", "СЛЕДИТЬ")
	html += create_main_button(player, "character_setup", "НАСТРОЙКА ПЕРСОНАЖА")
	html += {"<div class="lobby_element lobby-name"><span id="character_name">[player.client.prefs.read_preference(/datum/preference/name/real_name)]</span></div>"}
	html += {"</div>"}

	html += {"<div class="lobby_buttons-bottom">"}
	html += create_icon_button(player, "changelog", "Открыть чейнджлог")
	html += create_icon_button(player, "settings", "Настройки игры")
	html += create_icon_button(player, "manifest", "Манифест персонала")
	html += create_icon_button(player, "wiki", "Перейти на вики")
	html += {"</div>"}

	if(check_rights_for(viewer, R_FUN|R_DEBUG))
		html += {"<div class="lobby_buttons-right">"}
		html += create_icon_button(player, "picture", "Сменить изображение", "right")
		html += create_icon_button(player, "notice", "Оставить уведомление", "right")

		if(check_rights_for(viewer, R_DEBUG))
			html += create_icon_button(player, "css", "Заменить CSS лобби", "right")

		html += {"</div>"}

	if(length(GLOB.lobby_station_traits))
		html += {"<div class="lobby_buttons-left">"}

		var/number = 0
		for(var/datum/station_trait/job/trait as anything in GLOB.lobby_station_traits)
			if(!trait.can_display_lobby_button(player.client))
				continue

			if(number > MAX_STATION_TRAIT_BUTTONS_VERTICAL) // 3 is a maximum
				break

			number++
			var/traitID = replacetext(replacetext("[trait.type]", "/datum/station_trait/job/", ""), "/", "-")
			var/assigned = LAZYFIND(trait.lobby_candidates, player)
			html += {"
				<a id="lobby-trait-[number]" class="lobby_button lobby_element" href='byond://?src=[REF(user)];trait_signup=[trait.name];id=[number]'>
					<div class="toggle">
						<img class="pixelated indicator trait_active [assigned ? "" : "hidden"]" src="[SSassets.transport.get_asset_url(asset_name = "lobby_active.png")]">
						<img class="pixelated indicator trait_disabled [!assigned ? "" : "hidden"]" src="[SSassets.transport.get_asset_url(asset_name = "lobby_disabled.png")]">
						<img class="pixelated indicator" src="[SSassets.transport.get_asset_url(asset_name = "lobby_highlight.png")]">
					</div>
					<img class="pixelated" src="[SSassets.transport.get_asset_url(asset_name = "lobby_[traitID].png")]">
					<div class="lobby-tooltip" data-position="left">
						<span class="lobby-tooltip-title">[trait.name]</span>
						<span class="lobby-tooltip-content">[trait.button_desc]</span>
					</div>
				</a>
			"}

		html += {"</div>"}

	html += {"
		<label class="lobby_element lobby-collapse" for="hide_menu">
			<span id="collapse" class="lobby-text toggle good">˄</span>
			<img class="pixelated" src="[SSassets.transport.get_asset_url(asset_name = "lobby_collapse.png")]">
		</label>
	"}

	html += {"</div></div></body>"}
	html += {"
		<script language="JavaScript">
			let ready_int = 0;
			const readyID = document.querySelector(".lobby-toggle_ready");
			const ready_class = \[ "bad", "good" \];
			function toggle_ready(setReady) {
				if(setReady) {
					ready_int = setReady;
					readyID.classList.add(ready_class\[ready_int\]);
					readyID.classList.remove(ready_class\[1 - ready_int\]);
				} else {
					ready_int++;
					if(ready_int === ready_class.length)
						ready_int = 0;
					readyID.classList.add("good");
					readyID.classList.remove("bad");
				}
			}

			function job_sign(assign, id) {
				/* I FUCKING HATE IE */
				let traitID;
				let trait_active;
				let trait_disabled;

				if(!id) {
					return
				}

				if (id === "1") {
					traitID = "lobby-trait-1";
				} else if (id === "2") {
					traitID = "lobby-trait-2";
				} else if (id === "3"){
					traitID = "lobby-trait-3";
				} else {
					return
				}

				trait_active = document.getElementById(traitID).querySelector(".trait_active");
				trait_disabled = document.getElementById(traitID).querySelector(".trait_disabled");

				if(assign === "true") {
					trait_active.classList.remove("hidden");
					trait_disabled.classList.add("hidden");
				} else {
					trait_active.classList.add("hidden");
					trait_disabled.classList.remove("hidden");
				}
			}

			const character_name_slot = document.getElementById("character_name");
			function update_character_name(name) {
				character_name_slot.textContent = name;
			}

			const notice_container = document.getElementById("container_notice");
			function update_notice(notice) {
				if(notice === undefined) {
					notice_container.classList.add("hidden");
					notice_container.textContent = "";
				} else {
					notice_container.classList.remove("hidden");
					notice_container.textContent = notice;
				}
			}

			let collapsed = false;
			const collapse = document.getElementById("collapse");
			function update_collapse() {
				const requestSound = new XMLHttpRequest();
				requestSound.open("GET", "?src=[REF(player)];collapse=1");
				requestSound.send();

				collapsed = !collapsed;
				if(collapsed) {
					collapse.textContent = "˅";
				} else {
					collapse.textContent = "˄";
				}
			}

			const image_container = document.getElementById("screen_image");
			function update_image(image) {
				image_container.src = image;
			}

			/* Return focus to Byond after click */
			function reFocus() {
				const focus = new XMLHttpRequest();
				focus.open("GET", "?src=[REF(player)];focus=1");
				focus.send();
			}

			document.addEventListener('keyup', reFocus);
			document.addEventListener('mouseup', reFocus);
			collapse.addEventListener('mouseup', update_collapse);
		</script>
	"}

	html += "</html>"

	return html.Join()

#undef MAX_STATION_TRAIT_BUTTONS_VERTICAL
