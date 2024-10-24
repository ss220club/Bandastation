/datum/tts_provider/silero
	name = "Silero"
	is_enabled = TRUE

/datum/tts_provider/silero/request(datum/tts_process_request/request)
	. = ..()
	if(!.)
		return FALSE

	if(throttle_check())
		return FALSE

	var/ssml_text = {"<speak>[request.text]</speak>"}

	var/list/req_body = list()
	req_body["api_token"] = CONFIG_GET(string/tts_token_silero)
	req_body["text"] = ssml_text
	req_body["sample_rate"] = 24000
	req_body["ssml"] = TRUE
	req_body["speaker"] = request.seed.value
	req_body["remote_id"] = "[world.port]"
	req_body["lang"] = "ru"
	req_body["put_accent"] = TRUE
	req_body["put_yo"] = FALSE
	req_body["symbol_durs"] = list()
	req_body["format"] = "ogg"
	req_body["word_ts"] = FALSE
	req_body["sfx"] = request.sfx

	SShttp.create_async_request(RUSTG_HTTP_METHOD_POST, CONFIG_GET(string/tts_api_url_silero), json_encode(req_body), list("Content-Type" = "application/json"), request.after_process_callback)

	return TRUE

/datum/tts_provider/silero/process_response(datum/http_response/response)
	var/data = json_decode(response.body)

	if(data["timings"]["003_tts_time"] > 3)
		is_throttled = TRUE
		throttled_until = world.time + 15 SECONDS

	return data["results"][1]["audio"]

/datum/tts_provider/silero/pitch_whisper(text)
	return {"<prosody pitch="x-low">[text]</prosody>"}

/datum/tts_provider/silero/rate_faster(text)
	return {"<prosody rate="fast">[text]</prosody>"}

/datum/tts_provider/silero/rate_medium(text)
	return {"<prosody rate="medium">[text]</prosody>"}
