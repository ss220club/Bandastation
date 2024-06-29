// Fountain
/obj/structure/statue/fountain
	name = "фонтан"
	desc = "Фонтан, собранный из настоящего, тёсанного камня."
	icon = 'modular_bandastation/objects/icons/fountain.dmi'
	icon_state = "fountain_g"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	pixel_x = -16

/obj/structure/statue/fountain/aged
	name = "старый фонтан"
	desc = "Фонтан, собранный из настоящего, тёсанного камня. Его помотало временем."
	icon = 'modular_bandastation/objects/icons/fountain.dmi'
	icon_state = "fountain"

// Archive structure
/obj/structure/archives
	name = "Desk"
	icon = 'icons/obj/antags/cult/structures.dmi'
	desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Looking at the text makes your skin crawl."
	icon_state = "tomealtar"
	light_range = 1.5
	light_color = LIGHT_COLOR_FIRE
	density = TRUE
	anchored = TRUE

/obj/structure/archives/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool, 10 SECONDS)
	return ITEM_INTERACT_SUCCESS

// Display Cases
/obj/structure/displaycase/hos
	alert = TRUE
	start_showpiece_type = /obj/item/food/donut/choco
	req_access = list(ACCESS_HOS)

// Mattress
/obj/structure/bed/mattress
	name = "матрас"
	icon = 'modular_bandastation/objects/icons/mattress.dmi'
	icon_state = "mattress"
	desc = "Голый матрас. Выглядит не очень удобным, но может быть лучше чем лежать на полу."
	anchored = FALSE

/obj/structure/bed/mattress/dirty
	name = "грязный матрас"
	icon_state = "dirty_mattress"
	desc = "Грязный, вонючий матрас, заляпанный различными жидкостями. Здесь не то что прилечь нельзя, к этому вовсе прикасаться не хочется..."
