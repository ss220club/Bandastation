#define SPECIES_VULPKANIN "vulpkanin"
#define BUTT_SPRITE_VULPKANIN "vulpkanin"

#define DEFAULT_SPRITE_LIST "default_sprites"

#define DNA_VULPKANIN_BODY_MARKINGS DNA_FEATURE_BLOCKS + 1
#define DNA_VULPKANIN_HEAD_MARKINGS DNA_FEATURE_BLOCKS + 2
#define DNA_VULPKANIN_HEAD_ACCESSORIES DNA_FEATURE_BLOCKS + 3
#define DNA_VULPKANIN_TAIL DNA_FEATURE_BLOCKS + 4
#define DNA_VULPKANIN_TAIL_MARKINGS DNA_FEATURE_BLOCKS + 5
#define DNA_VULPKANIN_FACIAL_HAIR DNA_FEATURE_BLOCKS + 6

#define DNA_MODULAR_BLOCKS_COUNT 6

/datum/controller/subsystem/accessories
	var/list/vulpkanin_body_markings_list
	var/list/vulpkanin_head_markings_list
	var/list/vulpkanin_head_accessories_list
	var/list/tails_list_vulpkanin
	var/list/vulpkanin_tail_markings_list
	var/list/vulpkanin_facial_hair_list

/datum/controller/subsystem/accessories/proc/init_modular_lists()
	vulpkanin_body_markings_list = init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_body_markings, add_blank = TRUE)[DEFAULT_SPRITE_LIST]
	vulpkanin_head_markings_list = init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_head_markings, add_blank = TRUE)[DEFAULT_SPRITE_LIST]
	vulpkanin_head_accessories_list = init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_head_accessories, add_blank = TRUE)[DEFAULT_SPRITE_LIST]
	tails_list_vulpkanin = init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/vulpkanin, add_blank = FALSE)[DEFAULT_SPRITE_LIST]
	vulpkanin_tail_markings_list = init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_tail_markings, add_blank = TRUE)[DEFAULT_SPRITE_LIST]
	vulpkanin_facial_hair_list = init_sprite_accessory_subtypes(/datum/sprite_accessory/vulpkanin_facial_hair, add_blank = TRUE)[DEFAULT_SPRITE_LIST]

/datum/controller/subsystem/accessories/PreInit()
	..()
	init_modular_lists()
