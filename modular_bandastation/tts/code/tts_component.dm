/datum/component/tts_component
	/// TTS seed that will be used
	var/datum/tts_seed/tts_seed
	/// List of tts effects that will applied to resulting speech
	var/list/effects = list()

/datum/component/tts_component/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_TTS_SEED_CHANGE, PROC_REF(tts_seed_change))
	RegisterSignal(parent, COMSIG_ATOM_TTS_CAST, PROC_REF(cast_tts))
	RegisterSignal(parent, COMSIG_ATOM_TTS_EFFECT_ADD, PROC_REF(tts_effect_add))
	RegisterSignal(parent, COMSIG_ATOM_TTS_EFFECT_REMOVE, PROC_REF(tts_effect_remove))

/datum/component/tts_component/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_TTS_SEED_CHANGE)
	UnregisterSignal(parent, COMSIG_ATOM_TTS_CAST)
	UnregisterSignal(parent, COMSIG_ATOM_TTS_EFFECT_ADD)
	UnregisterSignal(parent, COMSIG_ATOM_TTS_EFFECT_REMOVE)

/datum/component/tts_component/Initialize(datum/tts_seed/new_tts_seed, list/effects)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	if(ispath(new_tts_seed) && SStts220.tts_seeds[initial(new_tts_seed.name)])
		new_tts_seed = SStts220.tts_seeds[initial(new_tts_seed.name)]

	if(istype(new_tts_seed))
		tts_seed = new_tts_seed

	if(!tts_seed)
		tts_seed = get_random_tts_seed_by_gender()

	if(!tts_seed) // Something went terribly wrong
		return COMPONENT_INCOMPATIBLE

	if(!effects)
		return

	if(!islist(effects))
		effects = list(effects)

	src.effects = effects

/datum/component/tts_component/proc/return_tts_seed()
	SIGNAL_HANDLER
	return tts_seed

/datum/component/tts_component/proc/select_tts_seed(mob/chooser, silent_target = FALSE, override = FALSE, list/new_effects)
	if(!chooser)
		if(ismob(parent))
			chooser = parent
		else
			return null

	var/atom/being_changed = parent
	var/static/tts_test_str = "Так звучит мой голос."
	var/datum/tts_seed/new_tts_seed

	if(chooser == being_changed)
		var/datum/preferences/prefs = chooser.client.prefs
		var/prefs_tts_seed = prefs?.read_preference(/datum/preference/text/tts_seed)
		if(being_changed.gender == prefs?.read_preference(/datum/preference/choiced/gender))
			var/tgui_alert_result = tgui_alert(
				chooser,
				"Оставляем голос вашего персонажа [prefs?.read_preference(/datum/preference/name/real_name)] - [prefs_tts_seed]?",
				"Выбор голоса",
				"Нет",
				"Да"
			)

			if(tgui_alert_result == "Да")
				if(!SStts220.tts_seeds[prefs_tts_seed])
					to_chat(chooser, span_warning("Отсутствует tts_seed для значения \"[prefs_tts_seed]\". Текущий голос - [tts_seed]"))
					return null
				new_tts_seed = SStts220.tts_seeds[prefs_tts_seed]

				if(new_effects)
					effects = new_effects

				INVOKE_ASYNC(
					SStts220, \
					TYPE_PROC_REF(/datum/controller/subsystem/tts220, get_tts), \
					null, \
					chooser, \
					tts_test_str, \
					new_tts_seed, \
					FALSE, \
					get_all_effects() \
				)
				return new_tts_seed

	var/tts_seeds
	var/list/tts_seeds_by_gender = SStts220.get_tts_by_gender(being_changed.gender)
	tts_seeds_by_gender |= SStts220.get_tts_by_gender(NEUTER)
	if(!length(tts_seeds_by_gender))
		to_chat(chooser, span_warning("Не удалось найти голоса для пола! Текущий голос - [tts_seed.name]"))
		return null
	if(check_rights(R_ADMIN, FALSE, chooser) || override || !ismob(being_changed))
		tts_seeds = tts_seeds_by_gender
	else
		tts_seeds = tts_seeds_by_gender && SStts220.get_available_seeds(being_changed) // && for lists means intersection

	var/new_tts_seed_key
	new_tts_seed_key = tgui_input_list(chooser, "Выберите голос персонажа", "Преобразуем голос", tts_seeds, tts_seed.name)
	if(!new_tts_seed_key || !SStts220.tts_seeds[new_tts_seed_key])
		to_chat(chooser, span_warning("Что-то пошло не так с выбором голоса. Текущий голос - [tts_seed.name]"))
		return null

	new_tts_seed = SStts220.tts_seeds[new_tts_seed_key]
	if(new_effects)
		effects = new_effects

	if(!silent_target && being_changed != chooser && ismob(being_changed))
		INVOKE_ASYNC( \
			SStts220, \
			TYPE_PROC_REF(/datum/controller/subsystem/tts220, get_tts), \
			null, \
			being_changed, \
			tts_test_str, \
			new_tts_seed, \
			FALSE, \
			get_all_effects() \
		)

	if(chooser)
		INVOKE_ASYNC( \
			SStts220, \
			TYPE_PROC_REF(/datum/controller/subsystem/tts220, get_tts), \
			null, \
			chooser, \
			tts_test_str, \
			new_tts_seed, \
			FALSE, \
			get_all_effects() \
		)

	return new_tts_seed

/datum/component/tts_component/proc/tts_seed_change(atom/being_changed, mob/chooser, override = FALSE, list/new_effects)
	set waitfor = FALSE
	var/datum/tts_seed/new_tts_seed = select_tts_seed(chooser = chooser, override = override, new_effects = new_effects)
	if(!new_tts_seed)
		return null
	tts_seed = new_tts_seed
	if(iscarbon(being_changed))
		var/mob/living/carbon/carbon = being_changed
		carbon.dna?.tts_seed_dna = tts_seed

/datum/component/tts_component/proc/get_random_tts_seed_by_gender()
	var/atom/being_changed = parent
	var/tts_choice = SStts220.pick_tts_seed_by_gender(being_changed.gender)
	var/datum/tts_seed/seed = SStts220.tts_seeds[tts_choice]
	if(!seed)
		return null
	return seed

/datum/component/tts_component/proc/cast_tts(
	atom/speaker,
	mob/listener,
	message,
	atom/location,
	is_local = TRUE,
	is_radio = FALSE,
	traits = TTS_TRAIT_RATE_FASTER,
	preSFX,
	postSFX
)

	SIGNAL_HANDLER

	if(!message)
		return

	if(mob_tts_disabled(listener))
		return

	if(HAS_TRAIT(listener, TRAIT_DEAF))
		return

	if(!speaker)
		speaker = parent

	if(!location)
		location = parent

	var/list/additional_effects = list()
	if(is_radio)
		if(listener == speaker) // don't hear both radio and whisper from yourself
			return

		additional_effects += TTS_SOUND_EFFECT_RADIO
		is_local = FALSE

	INVOKE_ASYNC(
		SStts220, \
		TYPE_PROC_REF(/datum/controller/subsystem/tts220, get_tts), \
		location, \
		listener, \
		message, \
		tts_seed, \
		is_local, \
		get_all_effects(additional_effects), \
		traits, \
		preSFX, \
		postSFX \
	)

/datum/component/tts_component/proc/mob_tts_disabled(mob/mob_to_check)
	var/datum/preferences/prefs = mob_to_check?.client?.prefs
	if(isnull(prefs))
		return TRUE

	return prefs.read_preference(/datum/preference/choiced/sound_tts) != TTS_SOUND_ENABLED \
	 || prefs.read_preference(/datum/preference/numeric/sound_tts_volume) == 0

/datum/component/tts_component/proc/tts_effect_add(atom/user, effect)
	SIGNAL_HANDLER

	if(isnull(effect))
		return

	effects |= effect

/datum/component/tts_component/proc/tts_effect_remove(atom/user, effect)
	SIGNAL_HANDLER

	if(isnull(effect))
		return

	effects -= effect

/datum/component/tts_component/proc/get_all_effects(list/additional_effects)
	var/list/resulting_effects = list()
	resulting_effects += effects
	if(!isnull(additional_effects))
		resulting_effects |= additional_effects

	return resulting_effects

// Component usage

/mob/living/silicon/verb/synth_change_voice()
	set name = "Смена голоса"
	set desc = "Express yourself!"
	set category = "Silicon Commands"
	change_tts_seed(src, new_effects = list(TTS_SOUND_EFFECT_ROBOT))
