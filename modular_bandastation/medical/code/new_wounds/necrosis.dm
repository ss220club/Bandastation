/*
	Necrosis wounds
*/
/datum/wound/necrosis/basic_necro
	name = "Cells necrosis"
	sound_effect = 'sound/weapons/slice.ogg'
	processes = TRUE
	treatable_tools = list(TOOL_HEMOSTAT)
	base_treat_time = 3 SECONDS
	wound_flags = MANGLES_EXTERIOR

	var/necrosing_progress = 0
	var/necrosing_max
	/// How fast progress necrosis to next stage
	var/necrosing_coefficient
	/// How many toxins damage dealt on each tock
	var/toxin_damage_basic
	/// How many organ damage dealt on each tock
	var/organ_damage_basic


/datum/wound/necrosis/basic_necro/handle_process(seconds_per_tick, times_fired)
	if (!victim || HAS_TRAIT(victim, TRAIT_STASIS))
		return
	var/datum/wound/necro_wound
	for(var/limb_wound in limb.wounds)
		var/datum/wound/current_wound = limb_wound
		if(istype(current_wound, /datum/wound/necrosis/basic_necro/))
			necro_wound = current_wound


	if(!(victim.has_status_effect(/datum/status_effect/necroinversite)))
	//Если некроз на груди, голове или пахе - не более 2 уровня
		if(victim.bodytemperature > (BODYTEMP_NORMAL - 10) && necrosing_progress <= (necrosing_max + 10))
			necrosing_progress += necrosing_coefficient * times_fired
	else
		if (!(istype(necro_wound, /datum/wound/necrosis/basic_necro/critical)))
			necrosing_progress -= 3

	if (necrosing_progress >= (necrosing_max) && (istype(necro_wound, /datum/wound/necrosis/basic_necro/moderate)))
		var/wound_type = /datum/wound/necrosis/basic_necro/severe
		var/datum/wound/necrosis/basic_necro/severe_wound = new wound_type()
		severe_wound.apply_wound(limb,silent = TRUE,old_wound = necro_wound,wound_source = "Progressing infection",replacing = TRUE)
		necro_wound.remove_wound()
	if (necrosing_progress >= (necrosing_max) && (istype(necro_wound, /datum/wound/necrosis/basic_necro/severe)))
		if(limb != victim.get_bodypart(BODY_ZONE_CHEST) && limb != victim.get_bodypart(BODY_ZONE_HEAD) && limb != victim.get_bodypart(BODY_ZONE_PRECISE_GROIN))
			var/wound_type = /datum/wound/necrosis/basic_necro/critical
			var/datum/wound/necrosis/basic_necro/critical/crit_wound = new wound_type()
			crit_wound.apply_wound(limb,silent = TRUE,old_wound = necro_wound,wound_source = "Progressing infection",replacing = TRUE)
			necro_wound.remove_wound()

	if (istype(necro_wound, /datum/wound/necrosis/basic_necro/critical))
		var/datum/gas_mixture/corpseGas = new
		corpseGas.assert_gas(/datum/gas/miasma)

	var/toxin_damage = toxin_damage_basic * (necrosing_progress / 100)
	var/organ_damage = organ_damage_basic * (necrosing_progress / 100)

	if (!(isnull(victim)))
		victim.adjustToxLoss(toxin_damage)
		if ((istype(necro_wound, /datum/wound/necrosis/basic_necro/severe) || (istype(necro_wound, /datum/wound/necrosis/basic_necro/critical))))
			for(var/obj/item/organ/internal/selected_organ as anything in victim.get_organs_for_zone(BODY_ZONE_CHEST,include_children = TRUE))
				if (organ_damage > 0 && !isnull(selected_organ))
					selected_organ.apply_organ_damage(organ_damage)
			for(var/obj/item/organ/internal/selected_organ as anything in victim.get_organs_for_zone(BODY_ZONE_HEAD,include_children = TRUE))
				if (organ_damage > 0 && !isnull(selected_organ))
					selected_organ.apply_organ_damage(organ_damage)
			for(var/obj/item/organ/internal/selected_organ as anything in victim.get_organs_for_zone(BODY_ZONE_PRECISE_GROIN,include_children = TRUE))
				if (organ_damage > 0 && !isnull(selected_organ))
					selected_organ.apply_organ_damage(organ_damage)

	if (necrosing_progress < 5 && rand(1, 100) >= 20)
		necrosing_progress = 0

	if(necrosing_progress <= 0)
		if (istype(necro_wound, /datum/wound/necrosis/basic_necro/severe))
			var/wound_type = /datum/wound/necrosis/basic_necro/moderate
			var/datum/wound/necrosis/basic_necro/moderate_wound = new wound_type()
			moderate_wound.apply_wound(limb,silent = TRUE,old_wound = necro_wound,wound_source = "Curing infection",replacing = TRUE)
			moderate_wound.necrosing_progress = 99
			necro_wound.remove_wound()
		if (istype(necro_wound, /datum/wound/necrosis/basic_necro/moderate))
			qdel(src)

/datum/wound/necrosis/basic_necro/on_stasis(seconds_per_tick, times_fired)
	. = ..()
	if(necrosing_progress <= 0)
		var/datum/wound/necro_wound
		for(var/limb_wound in limb.wounds)
			var/datum/wound/current_wound = limb_wound
			if(istype(current_wound, /datum/wound/necrosis/basic_necro/))
				necro_wound = current_wound

		if (istype(necro_wound, /datum/wound/necrosis/basic_necro/severe))
			var/wound_type = /datum/wound/necrosis/basic_necro/moderate
			var/datum/wound/necrosis/basic_necro/moderate_wound = new wound_type()
			moderate_wound.apply_wound(limb,silent = TRUE,old_wound = necro_wound,wound_source = "Curing infection",replacing = TRUE)
			moderate_wound.necrosing_progress = 99
			necro_wound.remove_wound()

		if (istype(necro_wound, /datum/wound/necrosis/basic_necro/moderate))
			qdel(src)

/datum/wound/necrosis/basic_necro/treat(obj/item/I, mob/user)
	if(I.tool_behaviour == TOOL_HEMOSTAT || I.get_temperature())
		return tool_clearing(I, user)

/// Полевое лечение
/datum/wound/necrosis/basic_necro/proc/tool_clearing(obj/item/I, mob/user)

	var/datum/wound/necro_wound
	for(var/limb_wound in limb.wounds)
		var/datum/wound/current_wound = limb_wound
		if(istype(current_wound, /datum/wound/necrosis/basic_necro/))
			necro_wound = current_wound

	if (istype(necro_wound, /datum/wound/necrosis/basic_necro/critical))
		return

	var/improv_penalty_mult = (I.tool_behaviour == TOOL_HEMOSTAT ? 1 : 1.25) // 25% longer and less effective if you don't use a real hemostat
	var/self_penalty_mult = (user == victim ? 1.5 : 1) // 50% longer and less effective if you do it to yourself
	var/treatment_delay = base_treat_time * self_penalty_mult * improv_penalty_mult

	if(HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		treatment_delay *= 0.5
		user.visible_message(span_danger("[user] begins expertly cleaning dead skin of [victim]'s [limb.plaintext_zone] with [I]..."), span_warning("You begin cleaning dead skin of [user == victim ? "your" : "[victim]'s"] [limb.plaintext_zone] with [I], keeping the holo-image indications in mind..."))
	else
		user.visible_message(span_danger("[user] begins cleaning dead skin of [victim]'s [limb.plaintext_zone] with [I]..."), span_warning("You begin cleaning dead skin of [user == victim ? "your" : "[victim]'s"] [limb.plaintext_zone] with [I]..."))

	if(!do_after(user, treatment_delay, target = victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return TRUE

	var/necro_wording = (!limb.can_bleed() ? "dead cells" : "patches of dead skin")
	user.visible_message(span_green("[user] restore internals in [victim]."), span_green("You restore skin with reducing some of the [necro_wording] on [victim]."))
	if(prob(30))
		victim.emote("scream")

	necrosing_progress = necrosing_progress - treatment_delay * 2

	if(necrosing_progress > 0)
		return try_treating(I, user)
	return TRUE

/datum/wound_pregen_data/flesh_necrosis
	abstract = TRUE

	required_limb_biostate = (BIO_FLESH)
	required_wounding_types = list(WOUND_PIERCE,WOUND_SLASH)

	wound_series = WOUND_SERIES_NECROSIS

/datum/wound/necrosis/get_limb_examine_description()
	return span_warning("The flesh on this limb appears heavy buldged")

/datum/wound/necrosis/basic_necro/moderate
	name = "Light infection"
	desc = "Patient's skin has a strange color of skin in places."
	treat_text = "This should be treated by spaceacelin, hemostate or necroinversit." // space is cold in ss13, so it's like an ice pack!
	examine_desc = "has strange color of skin"
	occur_text = "have a peeling skin"
	severity = WOUND_SEVERITY_MODERATE
	necrosing_coefficient = 0.1
	necrosing_max = 100
	toxin_damage_basic = 0
	organ_damage_basic = 0
	threshold_penalty = 5
	status_effect_type = /datum/status_effect/wound/necrosis/moderate

	simple_treat_text = "<b>Spaceacelin, Necroinversit</b> can remove the dying of cells process."
	homemade_treat_text = "<b>Hemostat</b> can help to remove some patches of dead skin."

/datum/wound_pregen_data/flesh_necrosis/light_necrosis
	abstract = FALSE

	wound_path_to_generate = /datum/wound/necrosis/basic_necro/moderate

	threshold_minimum = 1

/datum/wound/necrosis/basic_necro/moderate/update_descriptions()
	if(!limb.can_bleed())
		examine_desc = "has a small, circular hole"
		occur_text = "splits a small hole open"

/datum/wound/necrosis/basic_necro/severe
	name = "Noticable dead skin"
	desc = "Patient's have a weird gray color."
	treat_text = "This should be treated by spaceacelin, hemostate or necroinversit."
	examine_desc = "is a noticable flesh wound with falling skin"
	occur_text = "looses a patch of their skin"
	severity = WOUND_SEVERITY_SEVERE
	necrosing_coefficient = 0.15
	necrosing_max = 150
	toxin_damage_basic = 0.25
	organ_damage_basic = 0.1
	threshold_penalty = 15
	status_effect_type = /datum/status_effect/wound/necrosis/severe

	simple_treat_text = "<b>Necroinversit</b> still can be helpfull to reverse the process of dying cells."
	homemade_treat_text = "<b>Debride Infected Flesh</b> operation can help to remove some patches of dead skin cells to prevent futher processing of dying."

/datum/wound_pregen_data/flesh_necrosis/medium_necrosis
	abstract = FALSE

	wound_path_to_generate = /datum/wound/necrosis/basic_necro/severe

	threshold_minimum = 1000

/datum/wound/necrosis/basic_necro/severe/update_descriptions()
	if(!limb.can_bleed())
		occur_text = "tears a hole open"

/datum/wound/necrosis/basic_necro/critical
	name = "Gangren"
	desc = "Patient limb looks lifeless and rotten."
	treat_text = "Surgical amputation of limb is only way to safe patient."
	examine_desc = "is forming horrible wounds of open flesh that stinks"
	occur_text = "have horrible smell of rotten and decaying flesh"
	severity = WOUND_SEVERITY_CRITICAL
	necrosing_coefficient = 1
	necrosing_max = 10
	toxin_damage_basic = 0.5
	organ_damage_basic = 0.25
	threshold_penalty = 25
	status_effect_type = /datum/status_effect/wound/necrosis/critical

	simple_treat_text = "<b>Amputation</b> is the only way to stop cruel afflictions of wound."
	homemade_treat_text = "<b>Nothing helpfull.</b> The only way to stop wound to afflict pations is amputation."

/datum/wound_pregen_data/flesh_necrosis/heavy_necrosis
	abstract = FALSE

	wound_path_to_generate = /datum/wound/necrosis/basic_necro/critical

	threshold_minimum = 1000
