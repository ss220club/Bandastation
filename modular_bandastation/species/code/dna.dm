/datum/dna/generate_unique_features()
	var/list/L = new /list(DNA_MODULAR_BLOCKS_COUNT)
	if(features["vulpkanin_body_markings"])
		L[DNA_VULPKANIN_BODY_MARKINGS - DNA_FEATURE_BLOCKS] = construct_block(GLOB.vulpkanin_body_markings_list.Find(features["vulpkanin_body_markings"]), GLOB.vulpkanin_body_markings_list.len)
	if(features["vulpkanin_head_markings"])
		L[DNA_VULPKANIN_HEAD_MARKINGS - DNA_FEATURE_BLOCKS] = construct_block(GLOB.vulpkanin_head_markings_list.Find(features["vulpkanin_head_markings"]), GLOB.vulpkanin_head_markings_list.len)
	if(features["vulpkanin_head_accessories"])
		L[DNA_VULPKANIN_HEAD_ACCESSORIES - DNA_FEATURE_BLOCKS] = construct_block(GLOB.vulpkanin_head_accessories_list.Find(features["vulpkanin_head_accessories"]), GLOB.vulpkanin_head_accessories_list.len)
	if(features["tail_vulpkanin"])
		L[DNA_VULPKANIN_TAIL - DNA_FEATURE_BLOCKS] = construct_block(GLOB.tails_list_vulpkanin.Find(features["tail_vulpkanin"]), GLOB.tails_list_vulpkanin.len)
	if(features["tail_markings"])
		L[DNA_VULPKANIN_TAIL_MARKINGS - DNA_FEATURE_BLOCKS] = construct_block(GLOB.vulpkanin_tail_markings_list.Find(features["tail_markings"]), GLOB.vulpkanin_tail_markings_list.len)
	if(features["vulpkanin_facial_hair"])
		L[DNA_VULPKANIN_FACIAL_HAIR - DNA_FEATURE_BLOCKS] = construct_block(GLOB.vulpkanin_facial_hair_list.Find(features["vulpkanin_facial_hair"]), GLOB.vulpkanin_facial_hair_list.len)

	for(var/blocknum in 1 to DNA_MODULAR_BLOCKS_COUNT)
		. += L[blocknum] || random_string(GET_UI_BLOCK_LEN(blocknum), GLOB.hex_characters)
	. = ..()

/datum/dna/update_uf_block(blocknumber)
	. = ..()
	if(DNA_VULPKANIN_BODY_MARKINGS)
		set_uni_feature_block(blocknumber, construct_block(GLOB.vulpkanin_body_markings_list.Find(features["vulpkanin_body_markings"]), GLOB.vulpkanin_body_markings_list.len))
	if(DNA_VULPKANIN_HEAD_MARKINGS)
		set_uni_feature_block(blocknumber, construct_block(GLOB.vulpkanin_head_markings_list.Find(features["vulpkanin_head_markings"]), GLOB.vulpkanin_head_markings_list.len))
	if(DNA_VULPKANIN_HEAD_ACCESSORIES)
		set_uni_feature_block(blocknumber, construct_block(GLOB.vulpkanin_head_accessories_list.Find(features["vulpkanin_head_accessories"]), GLOB.vulpkanin_head_accessories_list.len))
	if(DNA_VULPKANIN_TAIL)
		set_uni_feature_block(blocknumber, construct_block(GLOB.tails_list_vulpkanin.Find(features["tail_vulpkanin"]), GLOB.tails_list_vulpkanin.len))
	if(DNA_VULPKANIN_TAIL_MARKINGS)
		set_uni_feature_block(blocknumber, construct_block(GLOB.vulpkanin_tail_markings_list.Find(features["tail_markings"]), GLOB.vulpkanin_tail_markings_list.len))
	if(DNA_VULPKANIN_FACIAL_HAIR)
		set_uni_feature_block(blocknumber, construct_block(GLOB.vulpkanin_facial_hair_list.Find(features["vulpkanin_facial_hair"]), GLOB.vulpkanin_facial_hair_list.len))

/mob/living/carbon/human/updateappearance(icon_update = TRUE, mutcolor_update = FALSE, mutations_overlay_update = FALSE)
	. = ..()
	if(dna.features["vulpkanin_body_markings"])
		dna.features["vulpkanin_body_markings"] = GLOB.vulpkanin_body_markings_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_BODY_MARKINGS), GLOB.vulpkanin_body_markings_list.len)]
	if(dna.features["vulpkanin_head_markings"])
		dna.features["vulpkanin_head_markings"] = GLOB.vulpkanin_head_markings_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_HEAD_MARKINGS), GLOB.vulpkanin_head_markings_list.len)]
	if(dna.features["vulpkanin_head_accessories"])
		dna.features["vulpkanin_head_accessories"] = GLOB.vulpkanin_head_accessories_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_HEAD_ACCESSORIES), GLOB.vulpkanin_head_accessories_list.len)]
	if(dna.features["tail_vulpkanin"])
		dna.features["tail_vulpkanin"] = GLOB.tails_list_vulpkanin[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_TAIL), GLOB.tails_list_vulpkanin.len)]
	if(dna.features["tail_markings"])
		dna.features["tail_markings"] = GLOB.vulpkanin_tail_markings_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_TAIL_MARKINGS), GLOB.vulpkanin_tail_markings_list.len)]
	if(dna.features["vulpkanin_facial_hair"])
		dna.features["vulpkanin_facial_hair"] = GLOB.vulpkanin_facial_hair_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_FACIAL_HAIR), GLOB.vulpkanin_facial_hair_list.len)]

/vulpkanin/populate_total_uf_len_by_block()
	. = list()
	var/total_block_len = 1
	for(var/blocknumber in 1 to DNA_FEATURE_BLOCKS)
		. += total_block_len
		total_block_len += GET_UF_BLOCK_LEN(blocknumber)
