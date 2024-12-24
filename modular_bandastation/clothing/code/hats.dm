/obj/item/clothing/head/caphat/beret_black
	name = "чёрный капитанский берет"
	desc = "Хорошо быть королём."
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'
	icon_state = "cap_beret_black"

/obj/item/clothing/head/ratge
	name = "ratge head"
	desc = "Ну ты и крыса!"
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'
	icon_state = "ratgehead"
	inhand_icon_state = "ratgehead"
	lefthand_file = 'modular_bandastation/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_bandastation/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEMASK | HIDEEARS | HIDEEYES | HIDEFACE | HIDEHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/chefhat/red
	name = "chef's red hat"
	desc = "Красный поварской колпак, для тех, кто хочет показать что он тут настоящий босс кухни."
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'
	icon_state = "chef_red"

/obj/item/clothing/head/towel
	name = "шапка из полотенца"
	desc = "Полотенце замотанное в импровизированную шапку. Можно надеть на голову."
	icon = 'modular_bandastation/clothing/icons/object/hats.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/hats.dmi'
	icon_state = "towel_head"

/obj/item/clothing/head/towel/attackby(obj/item/S, mob/user, params)
	. = ..()
	if(istype(S, /obj/item/toy/crayon/spraycan))
		var/obj/item/toy/crayon/spraycan/spcan = S
		var/list/hsl = rgb2hsl(hex2num(copytext(spcan.paint_color, 2, 4)), hex2num(copytext(spcan.paint_color, 4, 6)), hex2num(copytext(spcan.paint_color, 6, 8)))
		hsl[3] = max(hsl[3], 0.4)
		var/list/rgb = hsl2rgb(arglist(hsl))
		var/new_color = "#[num2hex(rgb[1], 2)][num2hex(rgb[2], 2)][num2hex(rgb[3], 2)]"
		color = new_color
		to_chat(user, "<span class='notice'>Вы перекрашиваете [src.name].</span>")
		return

/obj/item/clothing/head/towel/red
	name = "красная шапочка из полотенца"
	color = "#EE204D"

/obj/item/clothing/head/towel/green
	name = "зелёная шапочка из полотенца"
	color = "#32CD32"

/obj/item/clothing/head/towel/blue
	name = "синяя шапочка из полотенца"
	color = "#1E90FF"

/obj/item/clothing/head/towel/orange
	name = "оранжевая шапочка из полотенца"
	color = "#FFA500"

/obj/item/clothing/head/towel/purple
	name = "фиолетовая шапочка из полотенца"
	color = "#DA70D6"

/obj/item/clothing/head/towel/cyan
	name = "голубая шапочка из полотенца"
	color = "#40E0D0"

/obj/item/clothing/head/towel/brown
	name = "коричневая шапочка из полотенца"
	color = "#DEB887"
