/datum/loadout_category/suits
	category_name = "Âåðõíÿÿ îäåæäà"
	category_ui_icon = FA_ICON_VEST
	type_to_generate = /datum/loadout_item/suits
	tab_order = /datum/loadout_category/head::tab_order + 1

/datum/loadout_item/suits
	abstract_type = /datum/loadout_item/suits

/datum/loadout_item/suits/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.suit)
		LAZYADD(outfit.backpack_contents, outfit.suit)
	outfit.suit = item_path

/datum/loadout_item/suits/wintercoat
	name = "Winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat

/datum/loadout_item/suits/apron
	name = "Apron"
	item_path = /obj/item/clothing/suit/apron

/datum/loadout_item/suits/apron/red
	name = "Red apron"
	item_path = /obj/item/clothing/suit/apron/chef/red

/datum/loadout_item/suits/jacket/miljacket
	name = "Military jacket"
	item_path = /obj/item/clothing/suit/jacket/miljacket

/datum/loadout_item/suits/jacket/det_jacket/disco
	name = "Disco jacket"
	item_path = /obj/item/clothing/suit/jacket/det_suit/disco

/datum/loadout_item/suits/jacket/biker
	name = "Biker's jacket"
	item_path = /obj/item/clothing/suit/jacket/leather/biker

/datum/loadout_item/suits/jacket/puffer
	name = "Puffer"
	item_path = /obj/item/clothing/suit/jacket/puffer

/datum/loadout_item/suits/jacket/letterman_nt
	name = "Nt's letterman jacket"
	item_path = /obj/item/clothing/suit/jacket/letterman_nanotrasen