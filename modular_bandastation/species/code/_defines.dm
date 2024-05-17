#define SPECIES_VULPKANIN "vulpkanin"
#define BUTT_SPRITE_VULPKANIN "vulpkanin"

GLOBAL_LIST_EMPTY(vulpkanin_body_markings_list)
GLOBAL_LIST_EMPTY(vulpkanin_head_markings_list)
GLOBAL_LIST_EMPTY(vulpkanin_head_accessories_list)
GLOBAL_LIST_EMPTY(tails_list_vulpkanin)
GLOBAL_LIST_EMPTY(vulpkanin_tail_markings_list)
GLOBAL_LIST_EMPTY(vulpkanin_facial_hair_list)

#define HEAD_HAIR_VULPKANIN (1<<7)
#define HEAD_FACIAL_HAIR_VULPKANIN (1<<101)

/world/proc/make_modular_datum_reference_lists()
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_body_markings, GLOB.vulpkanin_body_markings_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_head_markings, GLOB.vulpkanin_head_markings_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_head_accessories, GLOB.vulpkanin_head_accessories_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/vulpkanin, GLOB.tails_list_vulpkanin, add_blank = FALSE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_facial_hair, GLOB.vulpkanin_facial_hair_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_tail_markings, GLOB.vulpkanin_tail_markings_list, add_blank = TRUE)

/world/New()
	. = ..()

	make_modular_datum_reference_lists()

#define DNA_VULPKANIN_BODY_MARKINGS DNA_FEATURE_BLOCKS + 1
#define DNA_VULPKANIN_HEAD_MARKINGS DNA_FEATURE_BLOCKS + 2
#define DNA_VULPKANIN_HEAD_ACCESSORIES DNA_FEATURE_BLOCKS + 3
#define DNA_VULPKANIN_TAIL DNA_FEATURE_BLOCKS + 4
#define DNA_VULPKANIN_TAIL_MARKINGS DNA_FEATURE_BLOCKS + 5
#define DNA_VULPKANIN_FACIAL_HAIR DNA_FEATURE_BLOCKS + 6

#define DNA_MODULAR_BLOCKS_COUNT 6
