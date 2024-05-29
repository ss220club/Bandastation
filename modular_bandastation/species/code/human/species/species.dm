#define GET_ATOM_SHIFF_FINGERPRINTS(atom) atom.forensics?.fingerprints
#define GET_ATOM_SHIFF_BLOOD_DNA(atom) atom.forensics?.blood_DNA

#define CM_COLOR_SAT_MIN 0.6
#define CM_COLOR_SAT_MAX 0.7
#define CM_COLOR_LUM_MIN 0.65
#define CM_COLOR_LUM_MAX 0.75

/datum/action/cooldown/vulpkanin
	name = "Vulp Power"
	check_flags = AB_CHECK_IMMOBILE | AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	melee_cooldown_time = 2 SECONDS

/datum/action/cooldown/vulpkanin/sniffer
	name = "Вынюхать"
	desc = "Вы обнюхиваете предмет и определяете кто с ним взаимодействовал. Вы можете запомнить запах определённого человека обнюхав его."
	click_to_activate = TRUE
	var/list/sniffed_species_ue = list()
	var/list/sniffed_species_ui = list()

/datum/action/cooldown/vulpkanin/sniffer/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return

	on_who.update_icons()

/datum/action/cooldown/vulpkanin/sniffer/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return

	on_who.update_icons()

/datum/action/cooldown/vulpkanin/sniffer/PreActivate(atom/target)
	if(get_dist(owner, target) > 1)
		return FALSE
	if(ishuman(target))
		owner.emote("sniff", message = target.name, intentional = TRUE)
	else
		owner.emote("sniff")
	if(HAS_TRAIT(owner, TRAIT_ANOSMIA))
		return TRUE
	if(!is_species(owner, /datum/species/vulpkanin))
		return FALSE

	return ..()

/datum/action/cooldown/vulpkanin/proc/colorize_string(name, sat_shift = 1, lum_shift = 1)
	var/static/rseed = rand(1,26)

	var/hash = copytext(md5(name + GLOB.round_id), rseed, rseed + 6)
	var/h = hex2num(copytext(hash, 1, 3)) * (360 / 255)
	var/s = (hex2num(copytext(hash, 3, 5)) >> 2) * ((CM_COLOR_SAT_MAX - CM_COLOR_SAT_MIN) / 63) + CM_COLOR_SAT_MIN
	var/l = (hex2num(copytext(hash, 5, 7)) >> 2) * ((CM_COLOR_LUM_MAX - CM_COLOR_LUM_MIN) / 63) + CM_COLOR_LUM_MIN

	s *= clamp(sat_shift, 0, 1)
	l *= clamp(lum_shift, 0, 1)

	var/h_int = round(h/60)
	var/c = (1 - abs(2 * l - 1)) * s
	var/x = c * (1 - abs((h / 60) % 2 - 1))
	var/m = l - c * 0.5
	x = (x + m) * 255
	c = (c + m) * 255
	m *= 255
	switch(h_int)
		if(0)
			return "#[num2hex(c, 2)][num2hex(x, 2)][num2hex(m, 2)]"
		if(1)
			return "#[num2hex(x, 2)][num2hex(c, 2)][num2hex(m, 2)]"
		if(2)
			return "#[num2hex(m, 2)][num2hex(c, 2)][num2hex(x, 2)]"
		if(3)
			return "#[num2hex(m, 2)][num2hex(x, 2)][num2hex(c, 2)]"
		if(4)
			return "#[num2hex(x, 2)][num2hex(m, 2)][num2hex(c, 2)]"
		if(5)
			return "#[num2hex(c, 2)][num2hex(m, 2)][num2hex(x, 2)]"


/datum/action/cooldown/vulpkanin/sniffer/Activate(atom/target)
	var/list/fingerprints = GET_ATOM_SHIFF_FINGERPRINTS(target)
	var/list/blood = GET_ATOM_SHIFF_BLOOD_DNA(target)

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		sniffed_species_ue[H.dna.unique_enzymes] = H.name
		sniffed_species_ui[md5(H.dna.unique_identity)] = H.name
		to_chat(owner, "Вы запомнили запах [H.name]")
		return TRUE

	if(!fingerprints && !blood)
		return TRUE

	var/list/fingerprint_output = list()
	var/list/blood_output = list()

	for(var/mob/living/carbon/human/A in GLOB.human_list)
		if(A.dna)
			if(A.dna.unique_enzymes in blood)
				blood_output[A.dna.unique_enzymes] = list()
				blood_output[A.dna.unique_enzymes]["Gender"] = A.gender
				blood_output[A.dna.unique_enzymes]["Species"] = A.dna.species.name
				blood_output[A.dna.unique_enzymes]["Color"] = colorize_string(A.dna.unique_enzymes + A.dna.unique_identity)
			var/h = md5(A.dna.unique_identity)
			if(h in fingerprints)
				fingerprint_output[h] = list()
				fingerprint_output[h]["Gender"] = A.gender
				fingerprint_output[h]["Species"] = A.dna.species.name
				fingerprint_output[h]["Color"] = colorize_string(A.dna.unique_enzymes + A.dna.unique_identity)

	if(fingerprints)
		for(var/i in fingerprints)
			if(sniffed_species_ui[i])
				fingerprint_output[i]["Name"] = sniffed_species_ui[i]
	if(blood)
		for(var/i in blood)
			if(sniffed_species_ue[i])
				blood_output[i]["Name"] = sniffed_species_ue[i]

	var/list/message = list()
	if(fingerprint_output.len > 0)
		message += "<B>Вы чувствуете запах:</B>"
		for(var/i in fingerprint_output)
			var/name = fingerprint_output[i]["Name"] ? fingerprint_output[i]["Name"] : "Неизвестный"
			message += "<font color='#[fingerprint_output[i]["Color"]]'>[name], [fingerprint_output[i]["Gender"]], [fingerprint_output[i]["Species"]]</font>"
		to_chat(owner, jointext(message, "\n&bull; "))
	message = list()
	if(blood_output.len > 0)
		message += "<B>Вы чувствуете запах <font color='red'>крови</font>:</B>"
		for(var/i in blood_output)
			var/name = blood_output[i]["Name"] ? blood_output[i]["Name"] : "Неизвестный"
			message += "<font color='#[blood_output[i]["Color"]]'>[name], [blood_output[i]["Gender"]], [blood_output[i]["Species"]]</font>"
		to_chat(owner, jointext(message, "\n&bull; "))

	return TRUE

#undef CM_COLOR_LUM_MAX
#undef CM_COLOR_LUM_MIN
#undef CM_COLOR_SAT_MAX
#undef CM_COLOR_SAT_MIN

#undef GET_ATOM_SHIFF_FINGERPRINTS
#undef GET_ATOM_SHIFF_BLOOD_DNA
