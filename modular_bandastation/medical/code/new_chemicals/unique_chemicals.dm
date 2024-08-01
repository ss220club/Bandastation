//Омнидрит - немного восстанавливает органы пока в организме, является основной для лекарств органов
/datum/reagent/medicine/omnidrite
	name = "Omnidrite"
	description = "Stimulates the slow healing of organs. Have extremly low threshold of overdose."
	reagent_state = LIQUID
	color = "#05af85"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 10
	ph = 10.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	inverse_chem_val = 0.3
	inverse_chem = /datum/reagent/medicine/higadrite
	var/static/list/possible_organs = list(
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_STOMACH,
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_EARS,
		ORGAN_SLOT_BRAIN,
		ORGAN_SLOT_APPENDIX,
		ORGAN_SLOT_TONGUE,
	)

/datum/reagent/medicine/omnidrite/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/selected = pick(possible_organs)
	var/obj/item/organ/internal/organ = affected_mob.get_organ_slot(selected)
	if(organ && IS_ORGANIC_ORGAN(organ) && !(organ.organ_flags & ORGAN_FAILING))
		affected_mob.adjustOrganLoss(selected, -0.5 * REM * seconds_per_tick * normalise_creation_purity())

/datum/reagent/medicine/omnidrite/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/selected = pick(possible_organs)
	var/obj/item/organ/internal/organ = affected_mob.get_organ_slot(selected)
	if(organ && IS_ORGANIC_ORGAN(organ))
		affected_mob.adjustOrganLoss(selected, 3 * REM * seconds_per_tick * normalise_creation_purity())
	affected_mob.reagents.remove_reagent(type, 1 * REM * seconds_per_tick)

/datum/chemical_reaction/medicine/omnidrite
	results = list(/datum/reagent/medicine/omnidrite = 3)
	required_reagents = list(/datum/reagent/medicine/omnizine = 1, /datum/reagent/phenol = 1, /datum/reagent/hydrogen = 2, /datum/reagent/oxygen = 1)
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_BURN


//Некроинверсит - позволяет начать реверс некрозиса на 1 и 2 стадиях
/datum/reagent/medicine/spaceacillin
	name = "Spaceacillin"
	description = "Spaceacillin will provide limited resistance against disease and parasites. Also reduces infection in serious burns."
	color = "#E1F2E6"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	ph = 8.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	added_traits = list(TRAIT_VIRUS_RESISTANCE)
	inverse_chem_val = 0.5
	inverse_chem = /datum/reagent/medicine/spaceacillin

/datum/reagent/medicine/necroinversite
	name = "Necroinversite"
	description = "Stimulates the cells for reverse necrosis process. Absolutely useless on last stage of necrosis. Can help with some toxin damage"
	reagent_state = LIQUID
	color = "#813d8f"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	ph = 4.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/medicine/necroinversite/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.apply_status_effect(/datum/status_effect/necroinversite)
	var/need_mob_update
	if(affected_mob.getToxLoss() <= 15)
		need_mob_update = affected_mob.adjustToxLoss(-0.3, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/necroinversite/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustBruteLoss(1.5, updating_health = FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH
