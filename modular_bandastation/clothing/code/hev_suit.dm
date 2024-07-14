#define SOUND_BEEP(sound) add_queue(##sound, 20)
#define MORPHINE_INJECTION_DELAY (30 SECONDS)
//Suit
/obj/item/clothing/suit/space/hev
	name = "\improper hazardous environment suit"
	desc = "The Mark IV HEV suit protects the user from a number of hazardous environments and has in build ballistic protection."
	icon = 'modular_bandastation/clothing/icons/object/suits.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	icon_state = "hev"
	inhand_icon_state = "hev"
	resistance_flags = FIRE_PROOF | ACID_PROOF | FREEZE_PROOF
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|FEET
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor_type = /datum/armor/armor_heavy
	allowed = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/gun/energy,
		/obj/item/crowbar,
	)
	slowdown = 0.25

	var/static/list/funny_signals = list(
		COMSIG_MOB_SAY = PROC_REF(handle_speech),
		COMSIG_MOB_DEATH = PROC_REF(handle_death),
		COMSIG_LIVING_IGNITED = PROC_REF(handle_ignite),
		COMSIG_LIVING_ELECTROCUTE_ACT = PROC_REF(handle_shock),
	//	COMSIG_MOB_APPLY_DAMAGE= PROC_REF(handle_damage),
	)


	var/list/sound_queue = list()

	var/mob/living/carbon/owner

	var/obj/item/geiger_counter/GC

	COOLDOWN_DECLARE(next_damage_notify)
	COOLDOWN_DECLARE(next_morphine)

/obj/item/clothing/suit/space/hev/Initialize(mapload)
	. = ..()
	GC = new(src)
	GC.scanning = TRUE
	update_appearance(UPDATE_ICON)

/obj/item/clothing/suit/space/hev/Destroy()
	QDEL_NULL(GC)
	owner = null
	return ..()

/obj/item/clothing/suit/space/hev/proc/process_sound_queue()

	var/list/sound_data = sound_queue[1]
	var/sound_file = sound_data[1]
	var/sound_delay = sound_data[2]

	playsound(owner, sound_file, 20)

	sound_queue.Cut(1,2)

	if(!length(sound_queue))
		return

	addtimer(CALLBACK(src, PROC_REF(process_sound_queue)), sound_delay)

/obj/item/clothing/suit/space/hev/proc/add_queue(desired_file, desired_delay, purge_queue=FALSE)

	var/was_empty_sound_queue = !length(sound_queue)

	if(purge_queue)
		sound_queue.Cut()

	sound_queue += list(list(desired_file,desired_delay)) //BYOND is fucking weird so you have to do this bullshit if you want to add a list to a list.

	if(was_empty_sound_queue)
		addtimer(CALLBACK(src, PROC_REF(process_sound_queue)), 1 SECONDS)

	return TRUE

//Signal handling.
/obj/item/clothing/suit/space/hev/equipped(mob/M, slot)
	..()
	if(iscarbon(M))
		for(var/voice in funny_signals)
			RegisterSignal(M, voice, funny_signals[voice])
			owner = M
			add_queue('modular_bandastation/clothing/sound/hev/blip.ogg', 2 SECONDS, purge_queue=TRUE)
			add_queue('modular_bandastation/clothing/sound/hev/01_hev_logon.ogg', 11 SECONDS)
			add_queue('modular_bandastation/clothing/sound/hev/04_vitalsigns_on.ogg', 4 SECONDS)
			add_queue('modular_bandastation/clothing/sound/hev/09_safe_day.ogg', 8 SECONDS)
	else
		for(var/voice in funny_signals)
			UnregisterSignal(M, voice)

/obj/item/clothing/suit/space/hev/dropped(mob/M)
	..()
	for(var/voice in funny_signals)
		UnregisterSignal(M, voice)

//Death
/obj/item/clothing/suit/space/hev/proc/handle_death(gibbed)
	SIGNAL_HANDLER
	add_queue('modular_bandastation/clothing/sound/hev/death.ogg', 5 SECONDS, purge_queue=TRUE)

//Mute
/obj/item/clothing/suit/space/hev/proc/handle_speech(datum/source, mob/speech_args)
	SIGNAL_HANDLER
	var/static/list/cancel_messages = list(
		"Вам трудно говорить, когда костюм туго сдавливает ваше горло...",
		"Ваши связки ощущаются сдавленными, что пресекает любую попытку выдавить хоть какой-то звук...",
		"Вы пытаетесь что-то сказать, но костюм сдавливает вам гортань..."
	)

	speech_args[SPEECH_MESSAGE] = "..."
	to_chat(source, span_warning(pick(cancel_messages)))

//Fire
/obj/item/clothing/suit/space/hev/proc/handle_ignite(mob/living)
	SIGNAL_HANDLER
	SOUND_BEEP('modular_bandastation/clothing/sound/hev/beep_3.ogg')
	add_queue('modular_bandastation/clothing/sound/hev/heat.ogg', 3 SECONDS)

//Shock
/obj/item/clothing/suit/space/hev/proc/handle_shock(mob/living)
	SIGNAL_HANDLER
	SOUND_BEEP('modular_bandastation/clothing/sound/hev/beep_3.ogg')
	add_queue('modular_bandastation/clothing/sound/hev/shok.ogg', 3 SECONDS)

//Helmet
/obj/item/clothing/head/helmet/hev_helmet
	name = "hazardous environment suit helmet"
	desc = "The Mark IV HEV suit helmet."
	icon = 'modular_bandastation/clothing/icons/object/helmet.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/helmet.dmi'
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	icon_state = "hev_helmet0"
	inhand_icon_state = "hev_helmet"
	armor_type = /datum/armor/armor_heavy
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flash_protect = FLASH_PROTECTION_WELDER
	dog_fashion = null
	var/on = FALSE
	var/brightness_on = 4
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	var/hud_types = list(DATA_HUD_MEDICAL_ADVANCED)

/obj/item/clothing/head/helmet/hev_helmet/equipped(mob/living/carbon/human/user, slot)
	..()
	if(ishuman(user) && slot_flags & slot)
		for(var/new_hud in hud_types)
			var/datum/atom_hud/H = GLOB.huds[new_hud]
			if(H)
				H.show_to(user)

/obj/item/clothing/head/helmet/hev_helmet/dropped(mob/living/carbon/human/user)
	..()
	if(ishuman(user))
		for(var/new_hud in hud_types)
			var/datum/atom_hud/H = GLOB.huds[new_hud]
			if(H)
				H.hide_from(user)

/obj/item/clothing/head/helmet/hev_helmet/ui_action_click(mob/user, toggle_helmet_light)
	light_toggle(user)

/obj/item/clothing/head/helmet/hev_helmet/proc/light_toggle(mob/user)
	on = !on
	icon_state = "hev_helmet[on]"

	if(on)
		set_light(brightness_on)
	else
		set_light(0)

#undef MORPHINE_INJECTION_DELAY
#undef SOUND_BEEP
