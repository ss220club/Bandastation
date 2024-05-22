/obj/item/organ/internal/tongue/vulpkanin
	name = "long tongue"
	desc = "длинный и более чувствительный язык, может различить больше вкусов"
	icon_state = "tongue"
	taste_sensitivity = 10
	modifies_speech = FALSE
	languages_native = list(/datum/language/canilunzt)
	liked_foodtypes = RAW | MEAT | SEAFOOD
	disliked_foodtypes = VEGETABLES | GRAIN | FRUIT | JUNKFOOD | GORE

/obj/item/organ/internal/tongue/vulpkanin/get_possible_languages()
	return ..() + /datum/language/canilunzt

/obj/item/organ/internal/stomach/vulpkanin
	hunger_modifier = 1.5
