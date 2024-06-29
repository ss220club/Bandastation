/datum/modpack/spawners
	name = "Спавнеры"
	desc = "Добавляет необходимые нам спавнеры."
	author = "Chorden"

/datum/modpack/spawners/initialize()
	. = ..()
	GLOB.uncommon_loot += list(
		/obj/item/knife/stylet = 1,
	)
