//Серия ниже восстанавливает органы в холодной среде. Работают при -50 по цельсию (173K), и "мощность" растет до 103К (-120 по цельсию), после чего падает  снова до 33
/datum/reagent/medicine/cryodrit_base
	name = "cryodrit base"
	description = "you not suposed to see this"
	color = "#00c8be"
	taste_description = "blue"
	ph = 11
	burning_temperature = 20 //cold burning
	burning_volume = 0.1
	var/organ

/datum/reagent/medicine/cryodrit_base/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	metabolization_rate = REAGENTS_METABOLISM * (0.00001 * (affected_mob.bodytemperature ** 2) + 0.1)
	if(affected_mob.bodytemperature >= 173.15 || affected_mob.bodytemperature <= 33 || !HAS_TRAIT(affected_mob, TRAIT_KNOCKEDOUT))
		return
	var/power = -0.25 * ((-(affected_mob.bodytemperature - 103)^2 / 2450) + 2)
	var/need_mob_update
	need_mob_update = affected_mob.adjustOrganLoss(organ, power * REM * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

//Кардиокcадонорит - сердце

/datum/reagent/medicine/cryodrit_base/cardioxadonorit
	name = "Cardioxadonorit"
	description = "Used to heal heart in cold enviroment. Optimal temperature for best result is 103K"
	organ = ORGAN_SLOT_HEART

/datum/chemical_reaction/medicine/cardioxadonorit
	results = list(/datum/reagent/medicine/cryodrit_base/ = 5)
	required_reagents = list(/datum/reagent/medicine/omnidrite = 3, /datum/reagent/medicine/cryoxadone = 2, /datum/reagent/acetone = 1, /datum/reagent/water = 1, /datum/reagent/medicine/ephedrine = 1)
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_PLANT | REACTION_TAG_BRUTE |REACTION_TAG_BURN | REACTION_TAG_TOXIN | REACTION_TAG_OXY

//Пульмеокcадонорит - легкие

/datum/reagent/medicine/cryodrit_base/pulmeoxadonorit
	name = "Pulmeoxadonorit"
	description = "Used to heal lungs in cold enviroment. Optimal temperature for best result is 103K"
	organ = ORGAN_SLOT_LUNGS

/datum/chemical_reaction/medicine/pulmeoxadonorit
	results = list(/datum/reagent/medicine/cryodrit_base/ = 5)
	required_reagents = list(/datum/reagent/medicine/omnidrite = 3, /datum/reagent/medicine/cryoxadone = 2, /datum/reagent/acetone = 1, /datum/reagent/water = 1, /datum/reagent/medicine/salbutamol = 1)
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_PLANT | REACTION_TAG_BRUTE |REACTION_TAG_BURN | REACTION_TAG_TOXIN | REACTION_TAG_OXY

//Гигакcадонорит - печень

/datum/reagent/medicine/cryodrit_base/pulmeoxadonorit
	name = "Pulmeoxadonorit"
	description = "Used to heal liver in cold enviroment. Optimal temperature for best result is 103K"
	organ = ORGAN_SLOT_LIVER

/datum/chemical_reaction/medicine/higaxadonorit
	results = list(/datum/reagent/medicine/cryodrit_base/ = 5)
	required_reagents = list(/datum/reagent/medicine/omnidrite = 3, /datum/reagent/medicine/cryoxadone = 2, /datum/reagent/acetone = 1, /datum/reagent/water = 1, /datum/reagent/medicine/higadrite = 1)
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_PLANT | REACTION_TAG_BRUTE |REACTION_TAG_BURN | REACTION_TAG_TOXIN | REACTION_TAG_OXY

//Гастрокcадонорит - желудок

/datum/reagent/medicine/cryodrit_base/gastroxadonorit
	name = "Gastroxadonorit"
	description = "Used to heal stomach in cold enviroment. Optimal temperature for best result is 103K"
	organ = ORGAN_SLOT_STOMACH

/datum/chemical_reaction/medicine/gastroxadonorit
	results = list(/datum/reagent/medicine/cryodrit_base/ = 5)
	required_reagents = list(/datum/reagent/medicine/omnidrite = 3, /datum/reagent/medicine/cryoxadone = 2, /datum/reagent/acetone = 1, /datum/reagent/water = 1, /datum/reagent/medicine/calomel = 1)
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_PLANT | REACTION_TAG_BRUTE |REACTION_TAG_BURN | REACTION_TAG_TOXIN | REACTION_TAG_OXY
