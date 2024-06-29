// Supply Crate
/datum/supply_pack/misc/id_skins
	name = "Наклейки на карточку"
	crate_type = /obj/structure/closet/crate/wooden
	contains = list()
	cost = CARGO_CRATE_VALUE * 10
	crate_name = "ящик с наклейками"

/datum/supply_pack/misc/id_skins/New()
	for(var/i in 1 to 10)
		contains += pick(subtypesof(/obj/item/id_skin))
	. = ..()

/obj/item/storage/box/id_skins
	name = "наклейки на карту"
	desc = "Коробка с кучкой наклеек на ID карту."
	icon = 'modular_bandastation/objects/icons/id_skins.dmi'
	icon_state = "id_skins_box"
	illustration = "id_skins_box_label"

/obj/item/storage/box/id_skins/PopulateContents()
	for(var/I in 1 to 3)
		var/skin = pick(subtypesof(/obj/item/id_skin))
		new skin(src)
