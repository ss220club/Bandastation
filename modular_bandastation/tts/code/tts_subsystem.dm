#define TTS_REPLACEMENTS_FILE_PATH "config/bandastation/tts_replacements.json"
#define TTS_ACRONYM_REPLACEMENTS "tts_acronym_replacements"
#define TTS_JOB_REPLACEMENTS "tts_job_replacements"
#define TTS_CACHE_LOCATION "data/tts_cache"

#define FILE_CLEANUP_DELAY 30 SECONDS

SUBSYSTEM_DEF(tts220)
	name = "Text-to-Speech 220"
	wait = 1 SECONDS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	/// All time tts uses
	VAR_PRIVATE/tts_wanted = 0
	/// Amount of errored requests to providers
	VAR_PRIVATE/tts_requests_failed = 0
	/// Amount of successfull requests to providers
	VAR_PRIVATE/tts_requests_succeeded = 0
	/// Amount of cache hits
	VAR_PRIVATE/tts_reused = 0
	/// Assoc list of request error codes
	VAR_PRIVATE/list/tts_errors = list()
	/// Last errored requests' contents
	VAR_PRIVATE/tts_error_raw = ""

	// Simple Moving Average RPS
	VAR_PRIVATE/list/tts_rps_list = list()
	VAR_PRIVATE/tts_sma_rps = 0

	/// Requests per Second (RPS), only real API requests
	VAR_PRIVATE/tts_rps = 0
	VAR_PRIVATE/tts_rps_counter = 0

	/// Total Requests per Second (TRPS), all TTS request, even reused
	VAR_PRIVATE/tts_trps = 0
	VAR_PRIVATE/tts_trps_counter = 0

	/// Reused Requests per Second (RRPS), only reused requests
	VAR_PRIVATE/tts_rrps = 0
	VAR_PRIVATE/tts_rrps_counter = 0

	VAR_PRIVATE/is_enabled = TRUE
	/// List of all available TTS seeds
	var/list/datum/tts_seed/tts_seeds = list()
	/// List of all available TTS providers
	var/list/datum/tts_provider/tts_providers = list()

	VAR_PRIVATE/tts_requests_queue_limit = 100
	VAR_PRIVATE/tts_rps_limit = 11
	VAR_PRIVATE/last_network_fire = 0

	/// General request queue
	VAR_PRIVATE/list/messages_being_processed = list()
	/// List of tts requests that need to be performed to TTS provider API
	VAR_PRIVATE/list/tts_requests_queue = list()

	/// List of currently existing binding of atom and sound channel: `atom` => `sound_channel`.
	VAR_PRIVATE/list/tts_local_channels_by_owner = list()
	/// Is debug mode enabled or not. Information about `sanitized_messages_cache_hit` and `sanitized_messages_cache_miss` is printed to debug logs each SS fire
	VAR_PRIVATE/debug_mode_enabled = FALSE
	/// Whether or not caching of sanitized messages is performed
	VAR_PRIVATE/sanitized_messages_caching = TRUE
	/// Amount of message duplicates that were sanitized current SS fire. Debug purpose only
	VAR_PRIVATE/sanitized_messages_cache_hit = 0
	/// Amount of unique messages that were sanitized current SS fire. Debug purpose only
	VAR_PRIVATE/sanitized_messages_cache_miss = 0
	/// List of all messages that were sanitized as: `raw message md5 hash` => `message`
	VAR_PRIVATE/list/sanitized_messages_cache = list()

	/// List of all available TTS seed names
	VAR_PRIVATE/list/tts_seeds_names = list()
	/// List of all available TTS seed names, mapped by donator level for faster access
	VAR_PRIVATE/list/tts_seeds_names_by_donator_levels = list()

	/// List of all tts seeds mapped by TTS gender: `tts gender` => `list of seeds`
	VAR_PRIVATE/list/tts_seeds_by_gender
	/// Replacement map for jobs for proper TTS spelling
	VAR_PRIVATE/list/tts_job_replacements
	/// Replacement map for acronyms for proper TTS spelling. Not private because `replacetext` can use only global procs
	var/list/tts_acronym_replacements
	/// Mapping of BYOND gender to TTS gender
	VAR_PRIVATE/list/gender_table = list(
		NEUTER = TTS_GENDER_ANY,
		PLURAL = TTS_GENDER_ANY,
		MALE = TTS_GENDER_MALE,
		FEMALE = TTS_GENDER_FEMALE
	)

/datum/controller/subsystem/tts220/stat_entry(msg)
	msg += "tRPS:[tts_trps] "
	msg += "rRPS:[tts_rrps] "
	msg += "RPS:[tts_rps] "
	msg += "smaRPS:[tts_sma_rps] | "
	msg += "W:[tts_wanted] "
	msg += "F:[tts_requests_failed] "
	msg += "S:[tts_requests_succeeded] "
	msg += "R:[tts_reused] "
	return ..()

/datum/controller/subsystem/tts220/PreInit()
	. = ..()
	for(var/path in subtypesof(/datum/tts_provider))
		var/datum/tts_provider/provider = new path
		tts_providers[provider.name] += provider

	for(var/path in subtypesof(/datum/tts_seed))
		var/datum/tts_seed/seed = new path
		if(seed.value == "STUB")
			continue
		seed.provider = tts_providers[initial(seed.provider.name)]
		tts_seeds[seed.name] = seed
		tts_seeds_names += seed.name
		tts_seeds_names_by_donator_levels["[seed.required_donator_level]"] += list(seed.name)
		LAZYADDASSOCLIST(tts_seeds_by_gender, seed.gender, seed.name)
	tts_seeds_names = sortTim(tts_seeds_names, GLOBAL_PROC_REF(cmp_text_asc))

/datum/controller/subsystem/tts220/Initialize(start_timeofday)
	if(!CONFIG_GET(flag/tts_enabled))
		is_enabled = FALSE
		return SS_INIT_NO_NEED

	load_replacements()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/tts220/fire()
	update_rps_stats()

	var/free_rps = clamp(tts_rps_limit - tts_rps, 0, tts_rps_limit)
	var/copy_until = min(length(tts_requests_queue), free_rps) + 1
	for(var/datum/tts_process_request/request_to_process as anything in tts_requests_queue.Copy(1, copy_until))
		var/datum/tts_provider/provider = request_to_process.seed.provider
		provider.request(request_to_process)
		tts_rps_counter++

	tts_requests_queue.Cut(1, copy_until)

	log_cache_stats()

/datum/controller/subsystem/tts220/Recover()
	is_enabled = SStts220.is_enabled
	tts_wanted = SStts220.tts_wanted
	tts_requests_failed = SStts220.tts_requests_failed
	tts_requests_succeeded = SStts220.tts_requests_succeeded
	tts_reused = SStts220.tts_reused
	tts_acronym_replacements = SStts220.tts_acronym_replacements
	tts_job_replacements = SStts220.tts_job_replacements

/datum/controller/subsystem/tts220/proc/get_tts(
	atom/speaker,
	mob/listener,
	message,
	datum/tts_seed/tts_seed,
	is_local = TRUE,
	list/effects,
	traits = TTS_TRAIT_RATE_FASTER,
	preSFX = null,
	postSFX = null
)

	if(!is_enabled)
		return

	if(!message)
		return

	if(isnull(listener) || !listener.client)
		return

	if(ispath(tts_seed))
		tts_seed = SStts220.tts_seeds[lowertext(tts_seed::name)]

	if(!istype(tts_seed))
		return

	tts_wanted++
	tts_trps_counter++

	var/datum/tts_provider/provider = tts_seed.provider
	if(!provider.is_enabled)
		return

	if(provider.throttle_check())
		return

	var/sanitized_message = sanitize_tts_input(message)
	if(!sanitized_message)
		return

	sanitized_message = apply_traits(sanitized_message, traits, provider)
	process_message(sanitized_message, effects, tts_seed, speaker, listener, is_local, traits, preSFX, postSFX)

/datum/controller/subsystem/tts220/proc/process_http_response(
	atom/speaker,
	mob/listener,
	pure_message_key,
	effects_key,
	datum/tts_seed/seed,
	is_local,
	preSFX,
	postSFX,
	datum/http_response/response
)

	var/datum/tts_provider/provider = seed.provider
	if(check_response_for_errors(response, provider))
		return

	tts_requests_succeeded++

	var/list/base64_encoded_speech_files = provider.process_response(response)
	if(!length(base64_encoded_speech_files))
		return

	if(!save_tts_file(seed.name, pure_message_key, base64_encoded_speech_files["pure"]))
		stack_trace("pure tts file is missing from the response.")
	else
		invoke_message_callbacks(pure_message_key)

	if(!effects_key)
		return

	var/full_message_key = pure_message_key + effects_key
	if(!save_tts_file(seed.name, full_message_key, base64_encoded_speech_files[effects_key]))
		stack_trace("expected tts file with effects key `[effects_key]` is missing from the response.")
		return

	invoke_message_callbacks(full_message_key)

/datum/controller/subsystem/tts220/proc/update_rps_stats()
	PRIVATE_PROC(TRUE)

	tts_rps = tts_rps_counter
	tts_rps_counter = 0
	tts_trps = tts_trps_counter
	tts_trps_counter = 0
	tts_rrps = tts_rrps_counter
	tts_rrps_counter = 0

	tts_rps_list += tts_rps
	if(length(tts_rps_list) > 15)
		tts_rps_list.Cut(1,2)

	var/rps_sum = 0
	for(var/rps in tts_rps_list)
		rps_sum += rps
	tts_sma_rps = round(rps_sum / length(tts_rps_list), 0.1)

/datum/controller/subsystem/tts220/proc/log_cache_stats()
	PRIVATE_PROC(TRUE)

	if(!sanitized_messages_caching)
		return

	sanitized_messages_cache.Cut()
	if(debug_mode_enabled)
		logger.Log(LOG_CATEGORY_DEBUG, "sanitized_messages_cache: HIT=[sanitized_messages_cache_hit] / MISS=[sanitized_messages_cache_miss]")

	sanitized_messages_cache_hit = 0
	sanitized_messages_cache_miss = 0

/datum/controller/subsystem/tts220/proc/load_replacements()
	PRIVATE_PROC(TRUE)
	if(!fexists(TTS_REPLACEMENTS_FILE_PATH))
		logger.Log(LOG_CATEGORY_DEBUG, "No file for TTS replacements located at: [TTS_REPLACEMENTS_FILE_PATH]. No replacements will be applied for TTS.")
		return

	var/tts_replacements_json = file2text(TTS_REPLACEMENTS_FILE_PATH)
	if(!length(tts_replacements_json))
		logger.Log(LOG_CATEGORY_DEBUG, "TTS replacements file is empty at: [TTS_REPLACEMENTS_FILE_PATH].")
		return

	var/list/replacements = json_decode(tts_replacements_json)
	tts_acronym_replacements = replacements[TTS_ACRONYM_REPLACEMENTS]
	tts_job_replacements = replacements[TTS_JOB_REPLACEMENTS]

/datum/controller/subsystem/tts220/proc/process_message(
	sanitized_message,
	list/effects,
	datum/tts_seed/tts_seed,
	atom/speaker,
	mob/listener,
	is_local = TRUE,
	traits = TTS_TRAIT_RATE_FASTER,
	preSFX = null,
	postSFX = null
)

	PRIVATE_PROC(TRUE)

	if(!isnull(effects) && !islist(effects))
		effects = list(effects)

	if(length(effects))
		effects = sort_list(effects)

	var/pure_message_key = generate_pure_message_key(sanitized_message)
	var/effects_key = generate_effects_key(effects)
	var/full_message_key = pure_message_key + effects_key

	var/file_location = get_file_location(tts_seed.name, full_message_key)
	if(fexists(file_location))
		tts_reused++
		tts_rrps_counter++
		play_tts(speaker, listener, file_location, is_local, preSFX, postSFX)
		return

	if(islist(messages_being_processed[full_message_key]))
		tts_reused++
		tts_rrps_counter++
	else
		enqueue_request(
			sanitized_message,
			tts_seed,
			effects,
			CALLBACK(src, PROC_REF(process_http_response), speaker, listener, pure_message_key, effects_key, tts_seed, is_local, preSFX, postSFX)
		)

	if(length(effects))
		LAZYINITLIST(messages_being_processed[pure_message_key])

	LAZYADD(messages_being_processed[full_message_key], CALLBACK(src, PROC_REF(play_tts), speaker, listener, file_location, is_local, preSFX, postSFX))

/datum/controller/subsystem/tts220/proc/get_file_location(seed_name, full_message_key)
	PRIVATE_PROC(TRUE)

	return "[TTS_CACHE_LOCATION]/[seed_name]/[full_message_key].ogg"

/datum/controller/subsystem/tts220/proc/apply_traits(sanitized_message, traits, datum/tts_provider/provider)
	PRIVATE_PROC(TRUE)

	var/modified_message = sanitized_message
	if(traits & TTS_TRAIT_RATE_FASTER)
		modified_message = provider.rate_faster(sanitized_message)

	if(traits & TTS_TRAIT_RATE_MEDIUM)
		modified_message = provider.rate_medium(sanitized_message)

	if(traits & TTS_TRAIT_PITCH_WHISPER)
		modified_message = provider.pitch_whisper(sanitized_message)

	return modified_message

/datum/controller/subsystem/tts220/proc/generate_pure_message_key(sanitized_message)
	PRIVATE_PROC(TRUE)

	return md5(lowertext(sanitized_message))

/datum/controller/subsystem/tts220/proc/generate_effects_key(list/effects)
	PRIVATE_PROC(TRUE)

	if(!length(effects))
		return ""

	return effects.Join("_")

/datum/controller/subsystem/tts220/proc/enqueue_request(text, datum/tts_seed/seed, list/effects, datum/callback/postprocess_callback)
	PRIVATE_PROC(TRUE)

	if(length(tts_requests_queue) > tts_requests_queue_limit)
		is_enabled = FALSE
		to_chat(world, span_info("SERVER: очередь запросов превысила лимит, подсистема [src] принудительно отключена!"))
		return FALSE

	var/datum/tts_process_request/request = new(text, seed, postprocess_callback, effects)
	if(tts_rps_counter < tts_rps_limit)
		var/datum/tts_provider/provider = seed.provider
		provider.request(request)
		tts_rps_counter++
	else
		tts_requests_queue += request

	return TRUE

/**
 * Invokes all message callbacks associated with `message_key` and removes them from `messages_being_processed`
 */
/datum/controller/subsystem/tts220/proc/invoke_message_callbacks(message_key)
	PRIVATE_PROC(TRUE)

	var/list/callbacks = messages_being_processed[message_key]
	if(isnull(callbacks))
		return

	for(var/datum/callback/cb as anything in callbacks)
		cb.InvokeAsync()

	messages_being_processed -= message_key

/**
 * Save TTS file to cache and created timer for file deletion in `FILE_CLEANUP_DELAY` if `tts_cache_enabled` is set to FALSE
 *
 ** Returns TRUE on file successful save, FALSE otherwise
 */
/datum/controller/subsystem/tts220/proc/save_tts_file(seed_name, filename, file_base64)
	PRIVATE_PROC(TRUE)

	if(!seed_name || !filename || !file_base64)
		return FALSE

	var/file_location = get_file_location(seed_name, filename)
	rustgss220_file_write_b64decode(file_base64, file_location)
	if(!CONFIG_GET(flag/tts_cache_enabled))
		addtimer(CALLBACK(src, PROC_REF(cleanup_tts_file), file_location), FILE_CLEANUP_DELAY)

	return TRUE

/**
 * Check response for errors.
 *
 ** Returns TRUE if there was an error, FALSE otherwise
 */
/datum/controller/subsystem/tts220/proc/check_response_for_errors(datum/http_response/response, datum/tts_provider/provider)
	PRIVATE_PROC(TRUE)

	if(response.errored)
		provider.timed_out_requests++
		log_game(span_warning("Error connecting to [provider.name] TTS API. Please inform a maintainer or server host."))
		message_admins(span_warning("Error connecting to [provider.name] TTS API. Please inform a maintainer or server host."))
		return TRUE

	if(response.status_code != 200)
		provider.failed_requests++
		log_game(span_warning("Error performing [provider.name] TTS API request (Code: [response.status_code])"))
		message_admins(span_warning("Error performing [provider.name] TTS API request (Code: [response.status_code])"))
		tts_requests_failed++

		if(response.status_code)
			if(tts_errors["[response.status_code]"])
				tts_errors["[response.status_code]"]++
			else
				tts_errors += "[response.status_code]"
				tts_errors["[response.status_code]"] = 1
		tts_error_raw = response.error
		return TRUE

	return FALSE

/datum/controller/subsystem/tts220/proc/play_tts(atom/speaker, mob/listener, filename_to_play, is_local = TRUE, preSFX = null, postSFX = null)
	if(isnull(listener) || !listener.client)
		return

	var/is_radio = !is_local || isnull(speaker)
	var/volume = get_tts_volume(listener, is_radio)
	if(!volume)
		return

	var/sound/output = sound(filename_to_play)
	output.status = SOUND_STREAM
	output.volume = volume

	play_sfx_if_exists(listener, preSFX, output)

	if(is_radio)
		output_tts_radio(listener, output)
	else
		output_tts_local(speaker, listener, output)

	play_sfx_if_exists(listener, postSFX, output)

/datum/controller/subsystem/tts220/proc/output_tts_radio(mob/listener, sound/output)
	PRIVATE_PROC(TRUE)

	output.wait = TRUE
	output.environment = SOUND_ENVIRONMENT_NONE
	output.channel = CHANNEL_TTS_RADIO

	SEND_SOUND(listener, output)

/datum/controller/subsystem/tts220/proc/output_tts_local(atom/speaker, mob/listener, sound/output)
	PRIVATE_PROC(TRUE)

	// Reserve channel only for players
	if(ismob(speaker))
		var/mob/speaking_mob = speaker
		if(speaking_mob.client)
			output.channel = get_local_channel_by_owner(speaker)
			output.wait = TRUE

	var/turf/turf_source = get_turf(speaker)
	listener.playsound_local(
		turf_source,
		vol = output.volume,
		falloff_exponent = SOUND_FALLOFF_EXPONENT,
		channel = output.channel,
		pressure_affected = TRUE,
		sound_to_use = output,
		max_distance = SOUND_RANGE,
		falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE,
		distance_multiplier = 1,
		use_reverb = TRUE,
	)

/datum/controller/subsystem/tts220/proc/get_tts_volume(mob/listener, is_radio)
	var/datum/preferences/prefs = listener?.client?.prefs
	if(!prefs)
		return 100

	return prefs.read_preference(
		is_radio ? /datum/preference/numeric/sound_tts_volume_radio : /datum/preference/numeric/sound_tts_volume
	)

/datum/controller/subsystem/tts220/proc/play_sfx_if_exists(mob/listener, sfx, sound/output)
	if(!sfx)
		return

	play_sfx(listener, sfx, output.volume, output.environment)

/datum/controller/subsystem/tts220/proc/play_sfx(mob/listener, sfx, volume, environment)
	var/sound/output = sound(sfx)
	output.status = SOUND_STREAM
	output.wait = TRUE
	output.volume = volume
	output.environment = environment
	SEND_SOUND(listener, output)

/datum/controller/subsystem/tts220/proc/get_local_channel_by_owner(owner)
	var/channel = tts_local_channels_by_owner[owner]
	if(isnull(channel))
		channel = SSsounds.reserve_sound_channel(owner)
		tts_local_channels_by_owner[owner] = channel
		RegisterSignal(owner, COMSIG_QDELETING, PROC_REF(clear_channel))

	return channel

/datum/controller/subsystem/tts220/proc/clear_channel(owner)
	SIGNAL_HANDLER

	tts_local_channels_by_owner -= owner

/datum/controller/subsystem/tts220/proc/cleanup_tts_file(filename)
	fdel(filename)

/datum/controller/subsystem/tts220/proc/sanitize_tts_input(message)
	var/raw_message_hash
	if(sanitized_messages_caching)
		raw_message_hash = md5(lowertext(message))
		if(sanitized_messages_cache[raw_message_hash])
			sanitized_messages_cache_hit++
			return sanitized_messages_cache[raw_message_hash]

		sanitized_messages_cache_miss++

	var/sanitized_message = trim(message)

	var/static/regex/punctuation_check = new(@"[.,?!]\Z")
	if(!punctuation_check.Find(sanitized_message))
		sanitized_message += "."

	sanitized_message = strip_html_full(sanitized_message)

	var/static/regex/forbidden_symbols = new(@"[^a-zA-Z0-9а-яА-ЯёЁ,!?+./ \r\n\t:—()-]", "g")
	sanitized_message = forbidden_symbols.Replace(sanitized_message, "")

	var/static/regex/acronyms = new(@"(?<![a-zA-Zа-яёА-ЯЁ])[a-zA-Zа-яёА-ЯЁ]+?(?![a-zA-Zа-яёА-ЯЁ])", "gm")
	sanitized_message = replacetext_char(sanitized_message, acronyms, /proc/tts_acronym_replacer)

	for(var/job in tts_job_replacements)
		sanitized_message = replacetext_char(sanitized_message, job, tts_job_replacements[job])

	sanitized_message = rustgss220_latin_to_cyrillic(sanitized_message)

	var/static/regex/decimals = new(@"-?\d+\.\d+", "g")
	sanitized_message = replacetext_char(sanitized_message, decimals, GLOBAL_PROC_REF(dec_in_words))

	var/static/regex/numbers = new(@"-?\d+", "g")
	sanitized_message = replacetext_char(sanitized_message, numbers, GLOBAL_PROC_REF(num_in_words))

	sanitized_message = truncate(sanitized_message, MAX_MESSAGE_LEN)
	if(sanitized_messages_caching)
		sanitized_messages_cache[raw_message_hash] = sanitized_message

	return sanitized_message

/datum/controller/subsystem/tts220/proc/get_available_seeds(owner)
	var/list/_tts_seeds_names = list()
	_tts_seeds_names |= tts_seeds_names

	if(!ismob(owner))
		return _tts_seeds_names

	var/mob/M = owner

	if(!M.client)
		return _tts_seeds_names

	return _tts_seeds_names

/datum/controller/subsystem/tts220/proc/get_random_seed(owner)
	return pick(get_available_seeds(owner))

/datum/controller/subsystem/tts220/proc/get_tts_by_gender(gender)
	return LAZYACCESS(tts_seeds_by_gender, get_tts_gender(gender))

/datum/controller/subsystem/tts220/proc/get_tts_gender(gender)
	var/tts_gender = gender_table[gender]
	if(!tts_gender)
		log_runtime("No mapping found for gender `[gender]` in `SStts220.gender_table`")
		return TTS_GENDER_ANY

	return tts_gender


/datum/controller/subsystem/tts220/proc/pick_tts_seed_by_gender(gender)
	var/tts_gender = SStts220.get_tts_gender(gender)
	var/tts_by_gender = LAZYACCESS(SStts220.tts_seeds_by_gender, tts_gender)
	tts_by_gender |= LAZYACCESS(SStts220.tts_seeds_by_gender, TTS_GENDER_ANY)
	if(!length(tts_by_gender))
		logger.Log(LOG_CATEGORY_DEBUG, "No tts for gender `[gender]`, tts_gender: `[tts_gender]`")
		return null

	return pick(tts_by_gender)

/// Proc intended to use with `replacetext`. Is global because `replacetext` cant use non globabl procs.
/proc/tts_acronym_replacer(word)
	if(!word || !LAZYLEN(SStts220.tts_acronym_replacements))
		return word

	var/match = SStts220.tts_acronym_replacements[lowertext(word)]
	return match || word

/datum/tts_process_request
	/// Text to generate speech from
	var/text
	/// Seed that will be provided on request
	var/datum/tts_seed/seed
	/// Callback that will be called after request is processed
	var/datum/callback/after_process_callback
	/// List of special effects that should be applied to resulting speech
	var/list/sfx = list()

/datum/tts_process_request/New(text, datum/tts_seed/seed, datum/callback/after_process_callback, list/sfx = list())
	ASSERT(text, "No `text` provided")
	ASSERT(seed, "No `seed` provided")
	ASSERT(after_process_callback, "No `after_process_callback` provided")

	src.text = text
	src.seed = seed
	src.after_process_callback = after_process_callback

	if(!isnull(sfx) && !islist(sfx))
		sfx = list(sfx)

	src.sfx = sfx

#undef TTS_REPLACEMENTS_FILE_PATH
#undef TTS_ACRONYM_REPLACEMENTS
#undef TTS_JOB_REPLACEMENTS
#undef TTS_CACHE_LOCATION

#undef FILE_CLEANUP_DELAY
