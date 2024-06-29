/datum/modpack/objects
	name = "Объекты"
	desc = "В основном включает в себя портированные объекты и всякие мелочи, которым не нужен отдельный модпак."
	author = "dj-34, Chorden"

// Maybe it would be better, if i didn't make it modular, because i can't change order in the recipe list :catDespair:
/datum/modpack/objects/initialize()
	GLOB.metal_recipes += list(
		new /datum/stack_recipe("metal platform", /obj/structure/platform, 4, time = 3 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF),
		new /datum/stack_recipe("metal platform corner", /obj/structure/platform/corner, 2, time = 20, crafting_flags = CRAFT_ONE_PER_TURF)
	)

	GLOB.plasteel_recipes += list(
		new /datum/stack_recipe("reinforced plasteel platform", /obj/structure/platform/reinforced, 4, time = 4 SECONDS,crafting_flags = CRAFT_ONE_PER_TURF),
		new /datum/stack_recipe("reinforced plasteel platform corner", /obj/structure/platform/reinforced/corner, 2, time = 30,crafting_flags = CRAFT_ONE_PER_TURF)
	)

	GLOB.wood_recipes += list(
		new /datum/stack_recipe("tribune", /obj/structure/tribune, 5, time = 5 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF)
	)

	GLOB.plastic_recipes += list(
		new /datum/stack_recipe("пластиковый стул", /obj/structure/chair/plastic, time = 2 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF),
	)

	GLOB.arcade_prize_pool += list(
		/obj/item/storage/box/id_skins = 1,
		/obj/item/storage/wallet/wallet_USSP_1 = 1,
	)
