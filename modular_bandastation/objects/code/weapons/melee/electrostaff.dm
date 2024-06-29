// Electrostaff
/obj/item/melee/baton/security/electrostaff
	name = "электропосох"
	desc = "Шоковая палка, только более мощная, двуручная и доступная наиболее авторитетным членам силовых структур Nanotrasen. А еще у неё нет тупого конца."
	lefthand_file = 'modular_bandastation/objects/icons/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/inhands/melee_righthand.dmi'
	icon = 'modular_bandastation/objects/icons/melee.dmi'
	icon_state = "electrostaff_orange"
	inhand_icon_state = "electrostaff_orange"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 7
	cooldown = 3.5 SECONDS
	preload_cell_type = /obj/item/stock_parts/cell/high
	block_chance = 30

/obj/item/melee/baton/security/electrostaff/purple
	icon_state = "electrostaff_purple"
	inhand_icon_state = "electrostaff_purple"

/obj/item/melee/baton/security/electrostaff/red
	icon_state = "electrostaff_red"
	inhand_icon_state = "electrostaff_red"

/obj/item/melee/baton/security/electrostaff/blue
	icon_state = "electrostaff_blue"
	inhand_icon_state = "electrostaff_blue"

/obj/item/melee/baton/security/electrostaff/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		wieldsound = 'modular_bandastation/objects/sounds/weapons/melee/electrostaff/on.ogg', \
		require_twohands = TRUE, \
	)

/obj/item/melee/baton/security/electrostaff/examine(mob/user)
	. = ..()
	. -= span_notice("This item can be recharged in a recharger. Using a screwdriver on this item will allow you to access its power cell, which can be replaced.")
	. += span_notice("Данный предмет не имеет внешних разъемов для зарядки. Используйте <b>отвертку</b> для доступа к внутренней батарее, чтобы заменить или зарядить её.")

/obj/item/weaponcrafting/gunkit/electrostaff
	name = "\improper electrostaff parts kit"
	desc = "Возьмите 2 оглушающие дубинки. Соедините их вместе, поместив внутрь батарею. Используйте остальные инструменты (лишних винтиков быть не должно)."

/datum/design/electrostaff
	name = "Electrostaff Parts Kit"
	desc = "Оперативный ответ."
	id = "electrostaff_kit"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.5,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.5,
	)
	build_path = /obj/item/weaponcrafting/gunkit/electrostaff
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_KITS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/crafting_recipe/electrostaff
	name = "Electrostaff"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/melee/baton/security/electrostaff
	reqs = list(/obj/item/melee/baton/security = 2,
				/obj/item/stock_parts/cell/high = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/assembly/signaler/anomaly/flux = 1,
				/obj/item/weaponcrafting/gunkit/electrostaff = 1)
	time = 10 SECONDS
	category = CAT_WEAPON_MELEE

/datum/techweb_node/electrostaff
	id = "electrostaff"
	display_name = "Advanced Security Baton Technology"
	description = "Настоящая двуручная дубинка службы безопасности."
	prereq_ids = list("riot_supression")
	design_ids = list(
		"electrostaff_kit",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
