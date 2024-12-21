/obj/item/clothing/head/helmet/bike_helmet
	name = "байкерский шлем"
	desc = "Крутой шлем."
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'
	icon_state = "bike_helmet"
	base_icon_state = "bike_helmet"
	inhand_icon_state = "bike_helmet"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	actions_types = list(/datum/action/item_action/toggle_helmet)
	flags_cover = HEADCOVERSEYES|EARS_COVERED
	dog_fashion = null
	var/on = TRUE

/obj/item/clothing/head/helmet/bike_helmet/replica
	desc = "Крутой шлем. На вид хлипкий..."

/obj/item/clothing/head/helmet/bike_helmet/ui_action_click(mob/user, toggle_helmet)
	helm_toggle(user)

/obj/item/clothing/head/helmet/bike_helmet/proc/helm_toggle(mob/user)
	on = !on
	icon_state = "[base_icon_state][on ? null : "_up" ]"
	if (on)
		flags_cover &= ~HEADCOVERSEYES
	else
		flags_cover |= HEADCOVERSEYES
	update_appearance()

/obj/item/clothing/head/helmet/space/hardsuit/security
	icon = 'modular_bandastation/clothing/icons/object/helmet.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/helmet.dmi'
	icon_state = "hardsuit0-sec"
