/datum/dna/generate_unique_features()
	. = ..()
	var/list/L = new /list(DNA_MODULAR_BLOCKS_COUNT)
	if(features["vulpkanin_body_markings"])
		L[DNA_VULPKANIN_BODY_MARKINGS - DNA_FEATURE_BLOCKS] = construct_block(SSaccessories.vulpkanin_body_markings_list.Find(features["vulpkanin_body_markings"]), SSaccessories.vulpkanin_body_markings_list.len)
	if(features["vulpkanin_head_markings"])
		L[DNA_VULPKANIN_HEAD_MARKINGS - DNA_FEATURE_BLOCKS] = construct_block(SSaccessories.vulpkanin_head_markings_list.Find(features["vulpkanin_head_markings"]), SSaccessories.vulpkanin_head_markings_list.len)
	if(features["vulpkanin_head_accessories"])
		L[DNA_VULPKANIN_HEAD_ACCESSORIES - DNA_FEATURE_BLOCKS] = construct_block(SSaccessories.vulpkanin_head_accessories_list.Find(features["vulpkanin_head_accessories"]), SSaccessories.vulpkanin_head_accessories_list.len)
	if(features["tail_vulpkanin"])
		L[DNA_VULPKANIN_TAIL - DNA_FEATURE_BLOCKS] = construct_block(SSaccessories.tails_list_vulpkanin.Find(features["tail_vulpkanin"]), SSaccessories.tails_list_vulpkanin.len)
	if(features["tail_markings"])
		L[DNA_VULPKANIN_TAIL_MARKINGS - DNA_FEATURE_BLOCKS] = construct_block(SSaccessories.vulpkanin_tail_markings_list.Find(features["tail_markings"]), SSaccessories.vulpkanin_tail_markings_list.len)
	if(features["vulpkanin_facial_hair"])
		L[DNA_VULPKANIN_FACIAL_HAIR - DNA_FEATURE_BLOCKS] = construct_block(SSaccessories.vulpkanin_facial_hair_list.Find(features["vulpkanin_facial_hair"]), SSaccessories.vulpkanin_facial_hair_list.len)

	for(var/blocknum in 1 to DNA_MODULAR_BLOCKS_COUNT)
		. += L[blocknum] || random_string(GET_UI_BLOCK_LEN(blocknum), GLOB.hex_characters)

/datum/dna/update_uf_block(blocknumber)
	. = ..()
	switch(blocknumber)
		if(DNA_VULPKANIN_BODY_MARKINGS)
			set_uni_feature_block(blocknumber, construct_block(SSaccessories.vulpkanin_body_markings_list.Find(features["vulpkanin_body_markings"]), SSaccessories.vulpkanin_body_markings_list.len))
		if(DNA_VULPKANIN_HEAD_MARKINGS)
			set_uni_feature_block(blocknumber, construct_block(SSaccessories.vulpkanin_head_markings_list.Find(features["vulpkanin_head_markings"]), SSaccessories.vulpkanin_head_markings_list.len))
		if(DNA_VULPKANIN_HEAD_ACCESSORIES)
			set_uni_feature_block(blocknumber, construct_block(SSaccessories.vulpkanin_head_accessories_list.Find(features["vulpkanin_head_accessories"]), SSaccessories.vulpkanin_head_accessories_list.len))
		if(DNA_VULPKANIN_TAIL)
			set_uni_feature_block(blocknumber, construct_block(SSaccessories.tails_list_vulpkanin.Find(features["tail_vulpkanin"]), SSaccessories.tails_list_vulpkanin.len))
		if(DNA_VULPKANIN_TAIL_MARKINGS)
			set_uni_feature_block(blocknumber, construct_block(SSaccessories.vulpkanin_tail_markings_list.Find(features["tail_markings"]), SSaccessories.vulpkanin_tail_markings_list.len))
		if(DNA_VULPKANIN_FACIAL_HAIR)
			set_uni_feature_block(blocknumber, construct_block(SSaccessories.vulpkanin_facial_hair_list.Find(features["vulpkanin_facial_hair"]), SSaccessories.vulpkanin_facial_hair_list.len))

/mob/living/carbon/human/updateappearance(icon_update = TRUE, mutcolor_update = FALSE, mutations_overlay_update = FALSE)
	. = ..()
	if(dna.features["vulpkanin_body_markings"])
		dna.features["vulpkanin_body_markings"] = SSaccessories.vulpkanin_body_markings_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_BODY_MARKINGS), SSaccessories.vulpkanin_body_markings_list.len)]
	if(dna.features["vulpkanin_head_markings"])
		dna.features["vulpkanin_head_markings"] = SSaccessories.vulpkanin_head_markings_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_HEAD_MARKINGS), SSaccessories.vulpkanin_head_markings_list.len)]
	if(dna.features["vulpkanin_head_accessories"])
		dna.features["vulpkanin_head_accessories"] = SSaccessories.vulpkanin_head_accessories_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_HEAD_ACCESSORIES), SSaccessories.vulpkanin_head_accessories_list.len)]
	if(dna.features["tail_vulpkanin"])
		dna.features["tail_vulpkanin"] = SSaccessories.tails_list_vulpkanin[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_TAIL), SSaccessories.tails_list_vulpkanin.len)]
	if(dna.features["tail_markings"])
		dna.features["tail_markings"] = SSaccessories.vulpkanin_tail_markings_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_TAIL_MARKINGS), SSaccessories.vulpkanin_tail_markings_list.len)]
	if(dna.features["vulpkanin_facial_hair"])
		dna.features["vulpkanin_facial_hair"] = SSaccessories.vulpkanin_facial_hair_list[deconstruct_block(get_uni_feature_block(dna.unique_features, DNA_VULPKANIN_FACIAL_HAIR), SSaccessories.vulpkanin_facial_hair_list.len)]

/proc/populate_total_uf_len_by_block_modular(last)
	. = list()
	var/total_block_len = last
	for(var/blocknumber in 1 to DNA_MODULAR_BLOCKS_COUNT)
		total_block_len += DNA_BLOCK_SIZE
		. += total_block_len

/mob/living/carbon/human/species/vulpkanin/random_mutate_unique_features()
	if(!has_dna())
		CRASH("[src] does not have DNA")
	var/num = rand(1, DNA_FEATURE_BLOCKS + DNA_MODULAR_BLOCKS_COUNT)
	dna.set_uni_feature_block(num, random_string(GET_UF_BLOCK_LEN(num), GLOB.hex_characters))
	updateappearance(mutcolor_update = TRUE, mutations_overlay_update = TRUE)

/datum/modpack/species/vulpkanin/post_initialize()
	GLOB.total_uf_len_by_block += populate_total_uf_len_by_block_modular(GLOB.total_uf_len_by_block[DNA_FEATURE_BLOCKS])
