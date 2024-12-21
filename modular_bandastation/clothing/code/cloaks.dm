/obj/item/clothing/suit/mantle/armor/captain/black
	name = "чёрная капитанская мантия"
	desc = "Носится верховным лидером станции NSS Cyberiad."
	icon = 'modular_bandastation/clothing/icons/object/cloaks.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/cloaks.dmi'
	icon_state = "capcloak_black"
	worn_icon_state = "capcloak_black"

/obj/item/clothing/suit/mantle/armor/captain/black/Initialize(mapload)
	. = ..()
	desc = "Носится верховным лидером станции [station_name()]."

/obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt
	name = "армированная мантия офицера флота Нанотрейзен"
	desc = "Один из вариантов торжественного одеяния сотрудников Верховного Командования Нанотрейзен, подойдет для официальной встречи или важного вылета. Сшита из лёгкой и сверхпрочной ткани."
	icon = 'modular_bandastation/clothing/icons/object/cloaks.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/cloaks.dmi'
	icon_state = "ntsc_cloak"

/obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt/coat_nt
	name = "полевой плащ офицера флота Нанотрейзен"
	desc = "Парадный плащ нового образца, внедряемый на объектах компании в последнее время. Отличительной чертой является стоячий воротник и резаный подол. Невысокие показатели защиты нивелируются пафосом, источаемым этим плащом."
	icon_state = "ntsc_coat"
	icon = 'modular_bandastation/clothing/icons/object/cloaks.dmi'
	worn_icon = 'modular_bandastation/clothing/icons/mob/cloaks.dmi'
