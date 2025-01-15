
///The storyteller datum. He operates with the SSgamemode data to run events
/datum/storyteller
	/// Name of our storyteller.
	var/name = "Badly coded storyteller"
	/// Description of our storyteller.
	var/desc = "Report this to the coders."
	/// Text that the players will be greeted with when this storyteller is chosen.
	var/welcome_text = "Set your eyes on the horizon."
	/// This is the multiplier for repetition penalty in event weight. The lower the harsher it is
	var/event_repetition_multiplier = 0.6
	/// Multipliers for starting points.
	var/list/starting_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_MAJOR = 1,
		EVENT_TRACK_ROLESET = 1,
		EVENT_TRACK_OBJECTIVES = 1
		)
	/// Multipliers for point gains.
	var/list/point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_MAJOR = 1,
		EVENT_TRACK_ROLESET = 1,
		EVENT_TRACK_OBJECTIVES = 1
		)
	/// Configurable multipliers for roundstart points.
	var/list/roundstart_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_MAJOR = 1,
		EVENT_TRACK_ROLESET = 1,
		EVENT_TRACK_OBJECTIVES = 1
		)
	/// Multipliers of weight to apply for each tag of an event.
	var/list/tag_multipliers

	/// Variance in cost of the purchased events. Effectively affects frequency of events
	var/cost_variance = 15

	/// Variance in the budget of roundstart points.
	var/roundstart_points_variance = 15

	/// Whether the storyteller guaranteed a roleset roll (antag) on roundstart. (Still needs to pass pop check)
	var/guarantees_roundstart_roleset = TRUE

	/// Whether the storyteller has the distributions disabled. Important for ghost storytellers
	var/disable_distribution = FALSE

	/// Whether a storyteller is pickable/can be voted for
	var/restricted = FALSE
	/// If defined, will need a minimum of population to be votable
	var/population_min
	/// If defined, it will not be votable if exceeding the population
	var/population_max
	/// has the round gotten to the point where jobs are pre-created?
	var/round_started = FALSE
	///have we done roundstart checks?
	var/roundstart_checks = FALSE
	///prob of roundstart antag
	var/roundstart_prob = 25
	///do we ignore ran_roundstart
	var/ignores_roundstart = FALSE
	///is a storyteller always able to be voted for(also does not count for the amount of storytellers to pick from)
	var/always_votable = FALSE
	///weight this has of being picked for random storyteller/showing up in the vote if not always_votable
	var/weight = 0
	///Количество игроков на сервере, чтобы сторителлер начинал расчеты максимального количества антагов
	var/min_antag_popcount = STORYTELLER_MIN_ANTAG_POPCOUNT
	///Количество игроков на сервере, которое требуется чтобы появился хотя бы один антаг (по умолчанию 30)
	var/antag_denominator = ANTAG_CAP_DENOMINATOR
	///Количество антагов, которое СТ может добавить сверх расчетов
	var/antag_flat_cap = ANTAG_CAP_FLAT
	///Общий множитель всех треков сторителлера (для коректировок)
	var/point_gain_base_mult = STORYTELLER_BASIC_MULT
	///Множитель силы СБ
	var/sec_antag_modifier = STORYTELLER_SEC_ANTAG_MODIFIER
	///Множитель цен антагов
	var/storyteller_basic_modifier = STORYTELLER_BASIC_MODIFIER

/datum/storyteller/process(seconds_per_tick)
	if(!round_started || disable_distribution) // we are differing roundstarted ones until base roundstart so we can get cooler stuff
		return

	if(!guarantees_roundstart_roleset && prob(roundstart_prob) && !roundstart_checks)
		roundstart_checks = TRUE

	add_points(seconds_per_tick)
	handle_tracks()

/// Add points to all tracks while respecting the multipliers.
/datum/storyteller/proc/add_points(seconds_per_tick)
	var/datum/controller/subsystem/gamemode/mode = SSgamemode
	var/base_point = EVENT_POINT_GAINED_PER_SECOND * seconds_per_tick * mode.event_frequency_multiplier //w = 0.08*y*1 = 0.4 => y = 5
	for(var/track in mode.event_track_points)
		var/point_gain = base_point * point_gains_multipliers[track] * mode.point_gain_multipliers[track] * point_gain_base_mult // p = w*1*1*10=4 => w = 0.4
		if(mode.allow_pop_scaling)
			point_gain *= mode.current_pop_scale_multipliers[track] //p*1 = 4
		mode.event_track_points[track] += point_gain
		mode.last_point_gains[track] = point_gain

/// Goes through every track of the gamemode and checks if it passes a threshold to buy an event, if does, buys one.
/datum/storyteller/proc/handle_tracks()
	. = FALSE //Has return value for the roundstart loop
	var/datum/controller/subsystem/gamemode/mode = SSgamemode
	for(var/track in mode.event_track_points)
		var/points = mode.event_track_points[track]
		if(SSgamemode.can_run_roundstart && track == EVENT_TRACK_ROLESET)
			SSgamemode.round_start_handle()
			SSgamemode.can_run_roundstart = FALSE
			SSgamemode.roundstart_event_view = FALSE

		if(points >= mode.point_thresholds[track])
			if(prob(SSgamemode.empty_event_chance) && track == EVENT_TRACK_ROLESET)
				calculate_empty_event(TRUE)
				mode.event_track_points[track] = 0
			else if(find_and_buy_event_from_track(track))
				calculate_empty_event(FALSE)
			. = TRUE

/datum/storyteller/proc/calculate_empty_event(reset = FALSE)
	if(reset)
		SSgamemode.empty_event_chance = 5
	else
		SSgamemode.empty_event_chance += SSgamemode.get_antag_count()

/// Find and buy a valid event from a track.
/datum/storyteller/proc/find_and_buy_event_from_track(track)
	. = FALSE
	var/are_forced = FALSE
	var/datum/controller/subsystem/gamemode/mode = SSgamemode
	var/datum/round_event_control/picked_event

	mode.update_crew_infos()
	var/pop_required = mode.min_pop_thresholds[track]
	if(mode.active_players < pop_required)
		message_admins("Storyteller failed to pick an event for track of [track] due to insufficient population. (required: [pop_required] active pop for [track]. Current: [mode.active_players])")
		mode.event_track_points[track] *= TRACK_FAIL_POINT_PENALTY_MULTIPLIER
		return
	calculate_weights(track)
	var/list/valid_events = list()
	// Determine which events are valid to pick
	for(var/datum/round_event_control/event as anything in mode.event_pools[track])
		var/players_amt = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
		if(event.can_spawn_event(players_amt))
			if(QDELETED(event))
				message_admins("[event.name] was deleted!")
				continue
			valid_events[event] = round(event.calculated_weight * 10) //multiply weight by 10 to get first decimal value
	///If we didn't get any events, remove the points inform admins and dont do anything
	if(!length(valid_events))
		message_admins("Storyteller failed to pick an event for track of [track].")
		mode.event_track_points[track] *= TRACK_FAIL_POINT_PENALTY_MULTIPLIER
		return
	picked_event = pick_weight(valid_events)
	if(!picked_event)
		if(length(valid_events))
			var/added_string = ""
			for(var/datum/round_event_control/item as anything in valid_events)
				added_string += "[item.name]:[valid_events[item]]; "
			stack_trace("WARNING: Storyteller picked a null from event pool, defaulting to option 1, look at weights:[added_string]")
			shuffle_inplace(valid_events)
			picked_event = valid_events[1]
		else
			message_admins("WARNING: Storyteller picked a null from event pool. Aborting event roll.")
			stack_trace("WARNING: Storyteller picked a null from event pool.")
			SSgamemode.event_track_points[track] = 0
			return

	if(picked_event?.can_spawn_event(get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)) && track)
		buy_event(picked_event, track, are_forced)
	. = TRUE

///Attempt to buy a specific event if we can afford it, otherwise returns FALSE, note this does NOT take cost variance into account
/datum/storyteller/proc/try_buy_event(datum/round_event_control/bought_event)
	if(ispath(bought_event))
		bought_event = locate(bought_event) in SSevents.control //might be able to make this slightly cheaper by searching in the track sorted list
	var/track = bought_event.track
	if(!track || (bought_event in SSgamemode.uncategorized))
		return FALSE //trackless events cant be bought

	var/datum/controller/subsystem/gamemode/mode = SSgamemode
	if(mode.event_track_points[track] - (bought_event.cost * mode.point_thresholds[track]) < 0)
		return FALSE

	buy_event(bought_event, track)
	return TRUE

/// Find and buy a valid event from a track.
/datum/storyteller/proc/buy_event(datum/round_event_control/bought_event, track, forced = FALSE)
	if(!track)
		track = bought_event.track

	var/datum/controller/subsystem/gamemode/mode = SSgamemode
	// Perhaps use some bell curve instead of a flat variance?
	var/total_cost = bought_event.cost * mode.point_thresholds[track]
	if(!bought_event.roundstart)
		total_cost *= (1 + (rand(-cost_variance, cost_variance)/100)) //Apply cost variance if not roundstart event
	mode.event_track_points[track] = max(mode.event_track_points[track] - total_cost, 0)
	message_admins("Storyteller purchased and triggered [bought_event] event, on [track] track, for [total_cost] cost.")
	if(bought_event.roundstart)
		mode.TriggerEvent(bought_event, forced)
	else
		mode.schedule_event(bought_event, 3 MINUTES, total_cost, _forced = forced)

/// Calculates the weights of the events from a passed track.
/datum/storyteller/proc/calculate_weights(track)
	var/datum/controller/subsystem/gamemode/mode = SSgamemode
	for(var/datum/round_event_control/event as anything in mode.event_pools[track])
		var/weight_total = event.weight
		/// Apply tag multipliers if able
		if(tag_multipliers)
			for(var/tag in tag_multipliers)
				if(tag in event.tags)
					weight_total *= tag_multipliers[tag]
		/// Apply occurence multipliers if able
		var/occurences = event.get_occurences()
		if(occurences)
			///If the event has occured already, apply a penalty multiplier based on amount of occurences
			weight_total -= event.reoccurence_penalty_multiplier * weight_total * (1 - (event_repetition_multiplier ** occurences))
		/// Write it
		event.calculated_weight = weight_total
