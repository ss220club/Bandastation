/datum/design/laserscalpel
	name = "Autocompressor"
	desc = "A chest mounted device for automatic CPR in oxygen enviroment."
	id = "autocompressor"
	build_path = /obj/item/clothing/suit/autocompressor
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1, /datum/material/silver =SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 0.5, /datum/material/diamond =SMALL_MATERIAL_AMOUNT * 1, /datum/material/titanium = SHEET_MATERIAL_AMOUNT*1)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
