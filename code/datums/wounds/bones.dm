
/*
	Blunt/Bone wounds
*/
// TODO: well, a lot really, but i'd kill to get overlays and a bonebreaking effect like Blitz: The League, similar to electric shock skeletons

/datum/wound_pregen_data/bone
	abstract = TRUE
	required_limb_biostate = BIO_BONE

	required_wounding_types = list(WOUND_BLUNT)

	wound_series = WOUND_SERIES_BONE_BLUNT_BASIC

/datum/wound/blunt/bone
	name = "Blunt (Bone) Wound"
	wound_flags = (ACCEPTS_GAUZE)

	default_scar_file = BONE_SCAR_FILE

	/// Have we been bone gel'd?
	var/gelled
	/// Have we been taped?
	var/taped
	/// If we did the gel + surgical tape healing method for fractures, how many ticks does it take to heal by default
	var/regen_ticks_needed
	/// Our current counter for gel + surgical tape regeneration
	var/regen_ticks_current
	/// If we suffer severe head booboos, we can get brain traumas tied to them
	var/datum/brain_trauma/active_trauma
	/// What brain trauma group, if any, we can draw from for head wounds
	var/brain_trauma_group
	/// If we deal brain traumas, when is the next one due?
	var/next_trauma_cycle
	/// How long do we wait +/- 20% for the next trauma?
	var/trauma_cycle_cooldown
	/// If this is a chest wound and this is set, we have this chance to cough up blood when hit in the chest
	var/internal_bleeding_chance = 0

/*
	Overwriting of base procs
*/
/datum/wound/blunt/bone/wound_injury(datum/wound/old_wound = null, attack_direction = null)
	// hook into gaining/losing gauze so crit bone wounds can re-enable/disable depending if they're slung or not
	if(limb.body_zone == BODY_ZONE_HEAD && brain_trauma_group)
		processes = TRUE
		active_trauma = victim.gain_trauma_type(brain_trauma_group, TRAUMA_RESILIENCE_WOUND)
		next_trauma_cycle = world.time + (rand(100-WOUND_BONE_HEAD_TIME_VARIANCE, 100+WOUND_BONE_HEAD_TIME_VARIANCE) * 0.01 * trauma_cycle_cooldown)

	if(limb.held_index && victim.get_item_for_held_index(limb.held_index) && (disabling || prob(30 * severity)))
		var/obj/item/I = victim.get_item_for_held_index(limb.held_index)
		if(istype(I, /obj/item/offhand))
			I = victim.get_inactive_held_item()

		if(I && victim.dropItemToGround(I))
			victim.visible_message(span_danger("[victim] бросает [I] от шока!"), span_warning("<b>Потеря хватки [limb.plaintext_zone] заставляет вас выронить [I]!</b>"), vision_distance=COMBAT_MESSAGE_RANGE)

	update_inefficiencies()
	return ..()

/datum/wound/blunt/bone/set_victim(new_victim)

	if (victim)
		UnregisterSignal(victim, COMSIG_LIVING_UNARMED_ATTACK)
	if (new_victim)
		RegisterSignal(new_victim, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(attack_with_hurt_hand))

	return ..()

/datum/wound/blunt/bone/remove_wound(ignore_limb, replaced)
	limp_slowdown = 0
	limp_chance = 0
	QDEL_NULL(active_trauma)
	return ..()

/datum/wound/blunt/bone/handle_process(seconds_per_tick, times_fired)
	. = ..()

	if (!victim || HAS_TRAIT(victim, TRAIT_STASIS))
		return

	if(limb.body_zone == BODY_ZONE_HEAD && brain_trauma_group && world.time > next_trauma_cycle)
		if(active_trauma)
			QDEL_NULL(active_trauma)
		else
			active_trauma = victim.gain_trauma_type(brain_trauma_group, TRAUMA_RESILIENCE_WOUND)
		next_trauma_cycle = world.time + (rand(100-WOUND_BONE_HEAD_TIME_VARIANCE, 100+WOUND_BONE_HEAD_TIME_VARIANCE) * 0.01 * trauma_cycle_cooldown)

	var/is_bone_limb = ((limb.biological_state & BIO_BONE) && !(limb.biological_state & BIO_FLESH))
	if(!gelled || (!taped && !is_bone_limb))
		return

	regen_ticks_current++
	if(victim.body_position == LYING_DOWN)
		if(SPT_PROB(30, seconds_per_tick))
			regen_ticks_current += 1
		if(victim.IsSleeping() && SPT_PROB(30, seconds_per_tick))
			regen_ticks_current += 1

	if(!is_bone_limb && SPT_PROB(severity * 1.5, seconds_per_tick))
		victim.take_bodypart_damage(rand(1, severity * 2), wound_bonus=CANT_WOUND)
		victim.adjustStaminaLoss(rand(2, severity * 2.5))
		if(prob(33))
			to_chat(victim, span_danger("Вы чувствуете острую боль в ваших костях!"))

	if(regen_ticks_current > regen_ticks_needed)
		if(!victim || !limb)
			qdel(src)
			return
		to_chat(victim, span_green("[limb.plaintext_zone] восстановилась от [name]!"))
		remove_wound()

/// If we're a human who's punching something with a broken arm, we might hurt ourselves doing so
/datum/wound/blunt/bone/proc/attack_with_hurt_hand(mob/M, atom/target, proximity)
	SIGNAL_HANDLER

	if(victim.get_active_hand() != limb || !proximity || !victim.combat_mode || !ismob(target) || severity <= WOUND_SEVERITY_MODERATE)
		return NONE

	// With a severe or critical wound, you have a 15% or 30% chance to proc pain on hit
	if(prob((severity - 1) * 15))
		// And you have a 70% or 50% chance to actually land the blow, respectively
		if(prob(70 - 20 * (severity - 1)))
			to_chat(victim, span_userdanger("Перелом в [limb.plaintext_zone] отдает болью, когда вы ударяете [target]!"))
			limb.receive_damage(brute=rand(1,5))
		else
			victim.visible_message(span_danger("[victim] слабо бьет [target] сломанной [victim.p_their()] [limb.plaintext_zone], пошатываясь от боли!"), \
			span_userdanger("ВЫ не смогли ударить [target] из-за перелома в вашей руке [limb.plaintext_zone] из-за вызванной боли!"), vision_distance=COMBAT_MESSAGE_RANGE)
			INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), "scream")
			victim.Stun(0.5 SECONDS)
			limb.receive_damage(brute=rand(3,7))
			return COMPONENT_CANCEL_ATTACK_CHAIN

	return NONE

/datum/wound/blunt/bone/receive_damage(wounding_type, wounding_dmg, wound_bonus)
	if(!victim || wounding_dmg < WOUND_MINIMUM_DAMAGE)
		return
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(HAS_TRAIT(human_victim, TRAIT_NOBLOOD))
			return

	if(limb.body_zone == BODY_ZONE_CHEST && victim.blood_volume && prob(internal_bleeding_chance + wounding_dmg))
		var/blood_bled = rand(1, wounding_dmg * (severity == WOUND_SEVERITY_CRITICAL ? 2 : 1.5)) // 12 brute toolbox can cause up to 18/24 bleeding with a severe/critical chest wound
		switch(blood_bled)
			if(1 to 6)
				victim.bleed(blood_bled, TRUE)
			if(7 to 13)
				victim.visible_message(
					span_smalldanger("Тонкая струйка крови капает из рта [victim] после удара по [victim.p_their()] груди."),
					span_danger("Вы откашливаете немного крови после удара в грудь."),
					vision_distance = COMBAT_MESSAGE_RANGE,
				)
				victim.bleed(blood_bled, TRUE)
			if(14 to 19)
				victim.visible_message(
					span_smalldanger("Кровь брызгает из рта [victim] после удара по [victim.p_their()] груди!"),
					span_danger("Вы плевок струей крови после удара в грудь!"),
					vision_distance = COMBAT_MESSAGE_RANGE,
				)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.bleed(blood_bled)
			if(20 to INFINITY)
				victim.visible_message(
					span_danger("Кровь фонтанирует из рта [victim] после удара по [victim.p_their()] груди!"),
					span_bolddanger("Вы задыхаетесь от струи крови после удара в грудь!"),
					vision_distance = COMBAT_MESSAGE_RANGE,
				)
				victim.bleed(blood_bled)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.add_splatter_floor(get_step(victim.loc, victim.dir))


/datum/wound/blunt/bone/modify_desc_before_span(desc)
	. = ..()

	if (!limb.current_gauze)
		if(taped)
			. += ", [span_notice("и, похоже, начинает восстанавливаться под хирургической лентой!")]"
		else if(gelled)
			. += ", [span_notice("с шипящими кусочками синего костного геля, искрящимися от кости!")]"

/datum/wound/blunt/get_limb_examine_description()
	return span_warning("Кости выглядят сильно поврежденными.")

/*
	New common procs for /datum/wound/blunt/bone/
*/

/datum/wound/blunt/bone/get_scar_file(obj/item/bodypart/scarred_limb, add_to_scars)
	if (scarred_limb.biological_state & BIO_BONE && (!(scarred_limb.biological_state & BIO_FLESH))) // only bone
		return BONE_SCAR_FILE
	else if (scarred_limb.biological_state & BIO_FLESH && (!(scarred_limb.biological_state & BIO_BONE)))
		return FLESH_SCAR_FILE

	return ..()

/// Joint Dislocation (Moderate Blunt)
/datum/wound/blunt/bone/moderate
	name = "Вывих сустава"
	desc = "Конечность пациента выпала из пазухи, вызывая моторную дисфункцию."
	treat_text = "Используйте костоправ на поврежденной конечности. \
		Можно вправить руками если крепко схватить конечность и твердым объятием вставить на место."
	treat_text_short = "Используйте костоправ или вручную вправьте сустав."
	examine_desc = "выглядит не на своем месте"
	occur_text = "отталкивающе выглядит и безвольно шатается"
	severity = WOUND_SEVERITY_MODERATE
	interaction_efficiency_penalty = 1.3
	limp_slowdown = 3
	limp_chance = 50
	threshold_penalty = 15
	treatable_tools = list(TOOL_BONESET)
	status_effect_type = /datum/status_effect/wound/blunt/bone/moderate
	scar_keyword = "dislocate"

	simple_desc = "Сустав пациента вывихнут, вызывая хромату и снижая общую ловкость."
	simple_treat_text = "<b>Перевязывание</b> раны уменьшит ее влияние, пока не будет вправлена костопроавом. Чаще их вправляют сильным хватом и последующим крепким объятием, хотя этим не стоит злоупотреблять."
	homemade_treat_text = "Помимо бинтования и использования гаечного ключа, <b>костоправ</b> можно изготовить на станке и использовать на себе, но это будет сопровождаться сильной болью. В крайнем случае, <b>раздавливание</b>  пациента с помощью <b>шлюза</b> иногда может помочь вправить конечность."

/datum/wound_pregen_data/bone/dislocate
	abstract = FALSE

	wound_path_to_generate = /datum/wound/blunt/bone/moderate

	required_limb_biostate = BIO_JOINTED

	threshold_minimum = 35

/datum/wound/blunt/bone/moderate/Destroy()
	if(victim)
		UnregisterSignal(victim, COMSIG_LIVING_DOORCRUSHED)
	return ..()

/datum/wound/blunt/bone/moderate/set_victim(new_victim)

	if (victim)
		UnregisterSignal(victim, COMSIG_LIVING_DOORCRUSHED)
	if (new_victim)
		RegisterSignal(new_victim, COMSIG_LIVING_DOORCRUSHED, PROC_REF(door_crush))

	return ..()

/// Getting smushed in an airlock/firelock is a last-ditch attempt to try relocating your limb
/datum/wound/blunt/bone/moderate/proc/door_crush()
	SIGNAL_HANDLER
	if(prob(40))
		victim.visible_message(span_danger("[limb.plaintext_zone] [victim] встала обратно на место!"), span_userdanger("Сустав в районе [limb.plaintext_zone] встал обратно на место! Ой!"))
		remove_wound()

/datum/wound/blunt/bone/moderate/try_handling(mob/living/user)
	if(user.usable_hands <= 0 || user.pulling != victim)
		return FALSE
	if(!isnull(user.hud_used?.zone_select) && user.zone_selected != limb.body_zone)
		return FALSE

	if(user.grab_state == GRAB_PASSIVE)
		to_chat(user, span_warning("Вы должны держать [victim] в агрессивном захвате, чтобы заниматься [victim.p_their()] [LOWER_TEXT(name)]!"))
		return TRUE

	if(user.grab_state >= GRAB_AGGRESSIVE)
		user.visible_message(span_danger("[user] начинает вкручивать сустав [limb.plaintext_zone] [victim]!"), span_notice("Вы начинаете вкручивать сустав [limb.plaintext_zone] [victim]..."), ignored_mobs=victim)
		to_chat(victim, span_userdanger("[user] начинает править ваш вывих [limb.plaintext_zone]!"))
		if(!user.combat_mode)
			chiropractice(user)
		else
			malpractice(user)
		return TRUE

/// If someone is snapping our dislocated joint back into place by hand with an aggro grab and help intent
/datum/wound/blunt/bone/moderate/proc/chiropractice(mob/living/carbon/human/user)
	var/time = base_treat_time

	if(!do_after(user, time, target=victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return

	if(prob(65))
		user.visible_message(span_danger("[user] вправляет вывих в [limb.plaintext_zone] [victim]!"), span_notice("Вы вправляете вывих [limb.plaintext_zone] [victim]!"), ignored_mobs=victim)
		to_chat(victim, span_userdanger("[user] вправляет ваш вывих в [limb.plaintext_zone]!"))
		victim.emote("scream")
		limb.receive_damage(brute=20, wound_bonus=CANT_WOUND)
		qdel(src)
	else
		user.visible_message(span_danger("[user] болезнено вправляет вывих [limb.plaintext_zone] [victim]!"), span_danger("Вы болезненно вправляете вывих [limb.plaintext_zone] [victim]!"), ignored_mobs=victim)
		to_chat(victim, span_userdanger("[user] болезнено вправляет ваш вывих в [limb.plaintext_zone]!"))
		limb.receive_damage(brute=10, wound_bonus=CANT_WOUND)
		chiropractice(user)

/// If someone is snapping our dislocated joint into a fracture by hand with an aggro grab and harm or disarm intent
/datum/wound/blunt/bone/moderate/proc/malpractice(mob/living/carbon/human/user)
	var/time = base_treat_time

	if(!do_after(user, time, target=victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return

	if(prob(65))
		user.visible_message(span_danger("[user] вправляет вывих в [limb.plaintext_zone] [victim] с хрустом!"), span_danger("Вы вправляете вывих [limb.plaintext_zone] [victim] с хрустом!"), ignored_mobs=victim)
		to_chat(victim, span_userdanger("[user] вправляет ваш вывих в [limb.plaintext_zone] с хрустом!"))
		victim.emote("scream")
		limb.receive_damage(brute=25, wound_bonus=30)
	else
		user.visible_message(span_danger("[user] болезнено вправляет вывих [limb.plaintext_zone] [victim]!"), span_danger("Вы болезненно вправляете вывих [limb.plaintext_zone] [victim]!"), ignored_mobs=victim)
		to_chat(victim, span_userdanger("[user] болезнено вправляет ваш вывих в [limb.plaintext_zone]!"))
		limb.receive_damage(brute=10, wound_bonus=CANT_WOUND)
		malpractice(user)


/datum/wound/blunt/bone/moderate/treat(obj/item/I, mob/user)
	var/scanned = HAS_TRAIT(src, TRAIT_WOUND_SCANNED)
	var/self_penalty_mult = user == victim ? 1.5 : 1
	var/scanned_mult = scanned ? 0.5 : 1
	var/treatment_delay = base_treat_time * self_penalty_mult * scanned_mult

	if(victim == user)
		victim.visible_message(span_danger("[user] начинет [scanned ? "опытно" : ""] вправлять [victim.p_their()] [limb.plaintext_zone] при помощи [I]."), span_warning("Вы вправляете себе [limb.plaintext_zone] при помощи [I][scanned ? ", держа в голове показатели сканера" : ""]..."))
	else
		user.visible_message(span_danger("[user] начинет [scanned ? "опытно" : ""] вправлять [victim]'s [limb.plaintext_zone] при помощи [I]."), span_notice("Вы вправляете [victim] [limb.plaintext_zone] при помощи [I][scanned ? ", держа в голове показатели сканера" : ""]..."))

	if(!do_after(user, treatment_delay, target = victim, extra_checks=CALLBACK(src, PROC_REF(still_exists))))
		return

	if(victim == user)
		limb.receive_damage(brute=15, wound_bonus=CANT_WOUND)
		victim.visible_message(span_danger("[user] заканчивает лечение вывиха [limb.plaintext_zone] [victim.p_their()]!"), span_userdanger("Вы вправили вывих себе в [limb.plaintext_zone]!"))
	else
		limb.receive_damage(brute=10, wound_bonus=CANT_WOUND)
		user.visible_message(span_danger("[user] заканчивает лечение вывиха [limb.plaintext_zone] [victim.p_their()]!!"), span_nicegreen("YВы вправили вывих [limb.plaintext_zone] [victim]!"), ignored_mobs=victim)
		to_chat(victim, span_userdanger("[user] заканивает лечение вывиха [limb.plaintext_zone]!"))

	victim.emote("scream")
	qdel(src)

/*
	Severe (Hairline Fracture)
*/

/datum/wound/blunt/bone/severe
	name = "Трещина в кости"
	desc = "Кость пациента имеет трещину, вызывая сильную боль и снижение функциональности конечности."
	treat_text = "Вылечить хирургически. В случае крайней необходимости нанесение костного геля на пораженную область позволит зажить со временем. \
		Также можно использовать шину или повязку из медицинской марли, чтобы предотвратить ухудшение трещины."
	treat_text_short = "Хирургическое лечение или нанесение костного геля. Можно также использовать шину или повязку из марли."
	examine_desc = "выглядит ужасно опухшей, с зазубренными буграми, указывающими на трещины в кости"
	occur_text = "сыпется костная крошка, и виден ужасный синяк"


	severity = WOUND_SEVERITY_SEVERE
	interaction_efficiency_penalty = 2
	limp_slowdown = 6
	limp_chance = 60
	threshold_penalty = 30
	treatable_by = list(/obj/item/stack/sticky_tape/surgical, /obj/item/stack/medical/bone_gel)
	status_effect_type = /datum/status_effect/wound/blunt/bone/severe
	scar_keyword = "bluntsevere"
	brain_trauma_group = BRAIN_TRAUMA_MILD
	trauma_cycle_cooldown = 1.5 MINUTES
	internal_bleeding_chance = 40
	wound_flags = (ACCEPTS_GAUZE | MANGLES_INTERIOR)
	regen_ticks_needed = 120 // ticks every 2 seconds, 240 seconds, so roughly 4 minutes default

	simple_desc = "Кость пациента треснула посередине, значительно снижая функциональность конечности."
	simple_treat_text = "<b>Перевязка</b> раны уменьшит её влияние до тех пор, пока не будет проведено <b>хирургическое лечение</b> с использованием костного геля и хирургической ленты."
	homemade_treat_text = "<b>Костный гель и хирургическая лента</b> могут быть нанесены непосредственно на рану, хотя это довольно сложно для большинства людей сделать самостоятельно, если только они не приняли одну или несколько <b>обезболивающих</b> (известно, что морфин и мазь шахтёра помогают)."


/datum/wound_pregen_data/bone/hairline
	abstract = FALSE

	wound_path_to_generate = /datum/wound/blunt/bone/severe

	threshold_minimum = 60

/// Compound Fracture (Critical Blunt)
/datum/wound/blunt/bone/critical
	name = "Открытый перелом"
	desc = "Кости пациента получили множественные переломы, \
		сопровождающиеся разрывом кожи, вызывая значительную боль и практически полную бесполезность конечности."
	treat_text = "Немедленно перевяжите поврежденную конечность марлей или наложите шину. Проведите хирургическое лечение. \
		В случае чрезвычайной ситуации можно нанести костный гель и хирургическую ленту на пораженную область для восстановления в течение длительного времени."
	treat_text_short = "Проведите хирургическое лечение или нанесите костный гель и хирургическую ленту. Также следует использовать шину или повязку из марли."
	examine_desc = "полностью раздроблена и треснута, обнажая осколки кости на воздух"
	occur_text = "раскалывается, обнажая сломанные кости на воздух"


	severity = WOUND_SEVERITY_CRITICAL
	interaction_efficiency_penalty = 2.5
	limp_slowdown = 7
	limp_chance = 70
	sound_effect = 'sound/effects/wounds/crack2.ogg'
	threshold_penalty = 50
	disabling = TRUE
	treatable_by = list(/obj/item/stack/sticky_tape/surgical, /obj/item/stack/medical/bone_gel)
	status_effect_type = /datum/status_effect/wound/blunt/bone/critical
	scar_keyword = "bluntcritical"
	brain_trauma_group = BRAIN_TRAUMA_SEVERE
	trauma_cycle_cooldown = 2.5 MINUTES
	internal_bleeding_chance = 60
	wound_flags = (ACCEPTS_GAUZE | MANGLES_INTERIOR)
	regen_ticks_needed = 240 // ticks every 2 seconds, 480 seconds, so roughly 8 minutes default

	simple_desc = "Кости пациента фактически полностью раздроблены, вызывая полную неподвижность конечности."
	simple_treat_text = "<b>Перевязка</b> раны немного уменьшит её влияние до тех пор, пока не будет проведено <b>хирургическое лечение</b> с использованием костного геля и хирургической ленты."
	homemade_treat_text = "Хотя это крайне сложно и медленно в исполнении, <b>Костный гель и хирургическая лента</b> могут быть нанесены непосредственно на рану, однако для большинства людей это практически невозможно выполнить самостоятельно, если только они не приняли одну или несколько <b>обезболивающих</b> (Известно, что морфин и мазь шахтёра могут помочь)"

/datum/wound_pregen_data/bone/compound
	abstract = FALSE

	wound_path_to_generate = /datum/wound/blunt/bone/critical

	threshold_minimum = 115

// doesn't make much sense for "a" bone to stick out of your head
/datum/wound/blunt/bone/critical/apply_wound(obj/item/bodypart/L, silent = FALSE, datum/wound/old_wound = null, smited = FALSE, attack_direction = null, wound_source = "Unknown", replacing = FALSE)
	if(L.body_zone == BODY_ZONE_HEAD)
		occur_text = "раскрывается, обнажая голую, треснувшую черепную кость сквозь плоть и кровь"
		examine_desc = "имеет тревожную вмятину, из которой торчат кусочки черепа"
	. = ..()

/// if someone is using bone gel on our wound
/datum/wound/blunt/bone/proc/gel(obj/item/stack/medical/bone_gel/I, mob/user)
	// skellies get treated nicer with bone gel since their "reattach dismembered limbs by hand" ability sucks when it's still critically wounded
	if((limb.biological_state & BIO_BONE) && !(limb.biological_state & BIO_FLESH))
		return skelly_gel(I, user)

	if(gelled)
		to_chat(user, span_warning("[user == victim ? "Ваш" : "[victim]"] [limb.plaintext_zone] уже покрыта костным гелем!"))
		return TRUE

	user.visible_message(span_danger("[user] начинает в спешке наносить [I] на [limb.plaintext_zone] [victim]..."), span_warning("Вы начинаете в спешке наносить [I] на [user == victim ? "вашу" : "[victim]"] [limb.plaintext_zone], игнорируя предупреждающую наклейку..."))

	if(!do_after(user, base_treat_time * 1.5 * (user == victim ? 1.5 : 1), target = victim, extra_checks=CALLBACK(src, PROC_REF(still_exists))))
		return TRUE

	I.use(1)
	victim.emote("scream")
	if(user != victim)
		user.visible_message(span_notice("[user] заканчивает нанесение [I] на [limb.plaintext_zone] [victim]а, раздаётся шипящий звук!"), span_notice("Вы заканчиваете нанесение [I] на [limb.plaintext_zone] [victim]а!"), ignored_mobs=victim)
		to_chat(victim, span_userdanger("[user] завершает нанесение [I] на вашу [limb.plaintext_zone], и вы чувствуете, как кости взрываются болью, когда начинают плавиться и реформироваться!"))
	else
		if(!HAS_TRAIT(victim, TRAIT_ANALGESIA))
			if(prob(25 + (20 * (severity - 2)) - min(victim.get_drunk_amount(), 10))) // 25%/45% chance to fail self-applying with severe and critical wounds, modded by drunkenness
				victim.visible_message(span_danger("[victim] не успевает завершить нанесение [I] на [victim.p_their()] [limb.plaintext_zone], теряя сознание от боли!"), span_notice("Вы теряете сознание от боли при нанесении [I] на вашу [limb.plaintext_zone], не успев завершить!"))
				victim.AdjustUnconscious(5 SECONDS)
				return TRUE
		victim.visible_message(span_notice("[victim] finishes applying [I] to [victim.p_their()] [limb.plaintext_zone], grimacing from the pain!"), span_notice("You finish applying [I] to your [limb.plaintext_zone], and your bones explode in pain!"))

	limb.receive_damage(25, wound_bonus=CANT_WOUND)
	victim.adjustStaminaLoss(100)
	gelled = TRUE
	return TRUE

/// skellies are less averse to bone gel, since they're literally all bone
/datum/wound/blunt/bone/proc/skelly_gel(obj/item/stack/medical/bone_gel/I, mob/user)
	if(gelled)
		to_chat(user, span_warning("[user == victim ? "Ваша" : "[victim]'s"] [limb.plaintext_zone] уже покрыта костным гелем!"))
		return

	user.visible_message(span_danger("[user] начинает наносить [I] на [limb.plaintext_zone] [victim]..."), span_warning("Вы начинаете наносить [I] на [user == victim ? "свою" : "[victim]'s"] [limb.plaintext_zone]..."))

	if(!do_after(user, base_treat_time * (user == victim ? 1.5 : 1), target = victim, extra_checks=CALLBACK(src, PROC_REF(still_exists))))
		return

	I.use(1)
	if(user != victim)
		user.visible_message(span_notice("[user] завершает нанесение [I] на [limb.plaintext_zone] [victim], издавая шипящий звук!"), span_notice("Вы завершаете нанесение [I] на [limb.plaintext_zone] [victim]!"), ignored_mobs=victim)
		to_chat(victim, span_userdanger("[user] завершает нанесение [I] на вашу [limb.plaintext_zone], и вы чувствуете странное щекочущее покалывание, пока кости начинают восстанавливаться!"))
	else
		victim.visible_message(span_notice("[victim] завершает нанесение [I] на [victim.p_their()] [limb.plaintext_zone], издавая забавный шипящий звук!"), span_notice("Вы завершаете нанесение [I] на вашу [limb.plaintext_zone] и чувствуете странное щекочущее покалывание, пока кость начинает восстанавливаться!"))

	gelled = TRUE
	processes = TRUE
	return TRUE

/// if someone is using surgical tape on our wound
/datum/wound/blunt/bone/proc/tape(obj/item/stack/sticky_tape/surgical/I, mob/user)
	if(!gelled)
		to_chat(user, span_warning("[user == victim ? "Ваша" : "[victim]'s"] [limb.plaintext_zone] должна быть покрыта костным гелем, чтобы выполнить эту экстренную операцию!"))
		return TRUE
	if(taped)
		to_chat(user, span_warning("[user == victim ? "Ваша" : "[victim]'s"] [limb.plaintext_zone] уже обернута в [I.name] и восстанавливается!"))
		return TRUE

	user.visible_message(span_danger("[user] начинает наносить [I] на [victim]'s [limb.plaintext_zone]..."), span_warning("Вы начинаете наносить [I] на [user == victim ? "вашу" : "[victim]'s"] [limb.plaintext_zone]..."))

	if(!do_after(user, base_treat_time * (user == victim ? 1.5 : 1), target = victim, extra_checks=CALLBACK(src, PROC_REF(still_exists))))
		return TRUE

	if(victim == user)
		regen_ticks_needed *= 1.5

	I.use(1)
	if(user != victim)
		user.visible_message(span_notice("[user] завершает нанесение [I] на [victim]'s [limb.plaintext_zone], издавая шипящий звук!"), span_notice("Вы завершаете нанесение [I] на [victim]'s [limb.plaintext_zone]!"), ignored_mobs=victim)
		to_chat(victim, span_green("[user] завершает нанесение [I] на вашу [limb.plaintext_zone], и вы сразу начинаете чувствовать, как ваши кости начинают восстанавливаться!"))
	else
		victim.visible_message(span_notice("[victim] завершает нанесение [I] на [victim.p_their()] [limb.plaintext_zone], !"), span_green("Вы завершаете нанесение [I] на вашу [limb.plaintext_zone], и вы сразу начинаете чувствовать, как ваши кости начинают восстанавливаться!"))

	taped = TRUE
	processes = TRUE
	return TRUE

/datum/wound/blunt/bone/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/medical/bone_gel))
		return gel(I, user)
	else if(istype(I, /obj/item/stack/sticky_tape/surgical))
		return tape(I, user)

/datum/wound/blunt/bone/get_scanner_description(mob/user)
	. = ..()

	. += "<div class='ml-3'>"

	if(severity > WOUND_SEVERITY_MODERATE)
		if((limb.biological_state & BIO_BONE) && !(limb.biological_state & BIO_FLESH))
			if(!gelled)
				. += "Рекомендуемое лечение: Нанесите костный гель непосредственно на поврежденную конечность. Существо из костей, похоже, не так сильно реагирует на нанесение костного геля, как особь с плотью. Хирургический скотч также будет ненужен.\n"
			else
				. += "[span_notice("Примечание: Регенерация костей в процессе. Кости восстановлены на [round(regen_ticks_current*100/regen_ticks_needed)]%.")]\n"
		else
			if(!gelled)
				. += "Альтернативное лечение: Нанесите костный гель непосредственно на поврежденную конечность, затем нанесите хирургический скотч, чтобы начать регенерацию костей. Это крайне болезненно и медленно, рекомендуется только в крайних случаях.\n"
			else if(!taped)
				. += "[span_notice("Продолжайте альтернативное лечение: Нанесите хирургический скотч непосредственно на поврежденную конечность, чтобы начать регенерацию костей. Обратите внимание, что это крайне болезненно и медленно, хотя сон или лежание ускорят восстановление.")]\n"
			else
				. += "[span_notice("Примечание: Регенерация костей в процессе. Кости восстановлены на [round(regen_ticks_current*100/regen_ticks_needed)]%.")]\n"

	if(limb.body_zone == BODY_ZONE_HEAD)
		. += "Обнаружена черепная травма: Пациент будет страдать от случайных приступов [severity == WOUND_SEVERITY_SEVERE ? "незначительных" : "серьезных"] травм головного мозга до восстановления кости."
	else if(limb.body_zone == BODY_ZONE_CHEST && victim.blood_volume)
		. += "Обнаружена травма грудной клетки: Дальнейшая травма груди, вероятно, усугубит внутреннее кровотечение до восстановления кости."
	. += "</div>"
