
/atom/movable/screen/blob
	icon = 'icons/hud/blob.dmi'
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/blob/MouseEntered(location,control,params)
	. = ..()
	openToolTip(usr,src,params,title = declent_ru(NOMINATIVE),content = desc, theme = "blob")

/atom/movable/screen/blob/MouseExited()
	closeToolTip(usr)

/atom/movable/screen/blob/jump_to_node
	icon_state = "ui_tonode"
	name = "Перейти к узлу"
	desc = "Перемещает камеру к выбранному узлу блоба."

/atom/movable/screen/blob/jump_to_node/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/eye/blob/blob = usr
	blob.jump_to_node()

/atom/movable/screen/blob/jump_to_core
	icon_state = "ui_tocore"
	name = "Перейти к ядру"
	desc = "Переместите камеру к ядру блоба."

/atom/movable/screen/blob/jump_to_core/MouseEntered(location,control,params)
	if(hud?.mymob && isovermind(hud.mymob))
		var/mob/eye/blob/B = hud.mymob
		if(!B.placed)
			name = "Разместить ядро блоба"
			desc = "Попытатся разместить ядро блоба в этом месте."
		else
			name = initial(name)
			desc = initial(desc)
	return ..()

/atom/movable/screen/blob/jump_to_core/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/eye/blob/blob = usr
	if(!blob.placed)
		blob.place_blob_core(BLOB_NORMAL_PLACEMENT)
	blob.transport_core()

/atom/movable/screen/blob/blobbernaut
	icon_state = "ui_blobbernaut"
	// Name and description get given their proper values on Initialize()
	name = "Произвести Блоббернаута (ОШИБКА)"
	desc = "Производит сильного, умного блоббернаута из фабричного блоб за (ОШИБКА) ресурсов.<br>Используемый фабричный блоб станет хрупким и не сможет производить споры."

/atom/movable/screen/blob/blobbernaut/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Произвести Блоббернаута ([BLOBMOB_BLOBBERNAUT_RESOURCE_COST])"
	desc = "Производит сильного, умного блоббернаута из фабричного блоб за [BLOBMOB_BLOBBERNAUT_RESOURCE_COST] ресурсов.<br>Используемый фабричный блоб станет хрупким и не сможет производить споры."

/atom/movable/screen/blob/blobbernaut/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/eye/blob/blob = usr
	blob.create_blobbernaut()

/atom/movable/screen/blob/resource_blob
	icon_state = "ui_resource"
	// Name and description get given their proper values on Initialize()
	name = "Произвести ресурсный блоб (ОШИБКА)"
	desc = "Производит ресурсный блоб за ОШИБКА ресурсов.<br>Ресурсный блоб будет давать вам ресурсы каждые несколько секунд."

/atom/movable/screen/blob/resource_blob/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Произвести ресурсный блоб ([BLOB_STRUCTURE_RESOURCE_COST])"
	desc = "Производит ресурсный блоб за [BLOB_STRUCTURE_RESOURCE_COST] ресурсов.<br>Ресурсный блоб будет давать вам ресурсы каждые несколько секунд."

/atom/movable/screen/blob/resource_blob/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/eye/blob/blob = usr
	blob.create_special(BLOB_STRUCTURE_RESOURCE_COST, /obj/structure/blob/special/resource, BLOB_RESOURCE_MIN_DISTANCE, TRUE)

/atom/movable/screen/blob/node_blob
	icon_state = "ui_node"
	// Name and description get given their proper values on Initialize()
	name = "Произвести узлового блоба (ОШИБКА)"
	desc = "Производит узлового блоба за ОШИБКА ресурсов.<br>Узловой блоб распространяется и активируют близлежащие ресурсные блобы и фабричные блобы."

/atom/movable/screen/blob/node_blob/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Произвести узлового блоба ([BLOB_STRUCTURE_NODE_COST])"
	desc = "Производит узлового блоба за [BLOB_STRUCTURE_NODE_COST] ресурсов.<br>Узловой блоб распространяется и активируют близлежащие ресурсные блобы и фабричные блобы."

/atom/movable/screen/blob/node_blob/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/eye/blob/blob = usr
	blob.create_special(BLOB_STRUCTURE_NODE_COST, /obj/structure/blob/special/node, BLOB_NODE_MIN_DISTANCE, FALSE)

/atom/movable/screen/blob/factory_blob
	icon_state = "ui_factory"
	// Name and description get given their proper values on Initialize()
	name = "Произвести фабричного блоба (ОШИБКА)"
	desc = "Производит фабричного блоба за ОШИБКА ресурсов.<br>Фабричный блоб будет производить споры каждые несколько секунд."

/atom/movable/screen/blob/factory_blob/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Произвести фабричного блоба ([BLOB_STRUCTURE_FACTORY_COST])"
	desc = "Производит фабричного блоба за [BLOB_STRUCTURE_FACTORY_COST] ресурсов.<br>Фабричный блоб будет производить споры каждые несколько секунд."

/atom/movable/screen/blob/factory_blob/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/eye/blob/blob = usr
	blob.create_special(BLOB_STRUCTURE_FACTORY_COST, /obj/structure/blob/special/factory, BLOB_FACTORY_MIN_DISTANCE, TRUE)

/atom/movable/screen/blob/readapt_strain
	icon_state = "ui_chemswap"
	// Description gets given its proper values on Initialize()
	name = "Реадаптировать реагент"
	desc = "Позволяет выбрать новый реагент из ОШИБКА случайных вариантов за ОШИБКА ресурсов."

/atom/movable/screen/blob/readapt_strain/MouseEntered(location,control,params)
	if(hud?.mymob && isovermind(hud.mymob))
		var/mob/eye/blob/B = hud.mymob
		if(B.free_strain_rerolls)
			name = "[initial(name)] (БЕСПЛАТНО)"
			desc = "Случайным образом бесплатно меняет ваш реагент."
		else
			name = "[initial(name)] ([BLOB_POWER_REROLL_COST])"
			desc = "Позволяет выбрать новый реагент из [BLOB_POWER_REROLL_CHOICES] случайных вариантов за [BLOB_POWER_REROLL_COST] ресурсов."
	return ..()

/atom/movable/screen/blob/readapt_strain/Click()
	if(isovermind(usr))
		var/mob/eye/blob/B = usr
		B.strain_reroll()

/atom/movable/screen/blob/relocate_core
	icon_state = "ui_swap"
	// Name and description get given their proper values on Initialize()
	name = "Переместить ядро (ОШИБКА)"
	desc = "Меняет местами узел и ядро за ОШИБКА ресурсов."

/atom/movable/screen/blob/relocate_core/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Переместить ядро ([BLOB_POWER_RELOCATE_COST])"
	desc = "Меняет местами узел и ядро за [BLOB_POWER_RELOCATE_COST] ресурсов."

/atom/movable/screen/blob/relocate_core/Click()
	if(isovermind(usr))
		var/mob/eye/blob/B = usr
		B.relocate_core()

/datum/hud/blob_overmind/New(mob/owner)
	..()
	var/atom/movable/screen/using

	blobpwrdisplay = new /atom/movable/screen(null, src)
	blobpwrdisplay.name = "blob power"
	blobpwrdisplay.icon_state = "block"
	blobpwrdisplay.screen_loc = ui_health
	blobpwrdisplay.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SET_PLANE_EXPLICIT(blobpwrdisplay, ABOVE_HUD_PLANE, owner)
	infodisplay += blobpwrdisplay

	healths = new /atom/movable/screen/healths/blob(null, src)
	infodisplay += healths

	using = new /atom/movable/screen/blob/jump_to_node(null, src)
	using.screen_loc = ui_inventory
	static_inventory += using

	using = new /atom/movable/screen/blob/jump_to_core(null, src)
	using.screen_loc = ui_zonesel
	static_inventory += using

	using = new /atom/movable/screen/blob/blobbernaut(null, src)
	using.screen_loc = ui_belt
	static_inventory += using

	using = new /atom/movable/screen/blob/resource_blob(null, src)
	using.screen_loc = ui_back
	static_inventory += using

	using = new /atom/movable/screen/blob/node_blob(null, src)
	using.screen_loc = ui_hand_position(RIGHT_HANDS)
	static_inventory += using

	using = new /atom/movable/screen/blob/factory_blob(null, src)
	using.screen_loc = ui_hand_position(LEFT_HANDS)
	static_inventory += using

	using = new /atom/movable/screen/blob/readapt_strain(null, src)
	using.screen_loc = ui_storage1
	static_inventory += using

	using = new /atom/movable/screen/blob/relocate_core(null, src)
	using.screen_loc = ui_storage2
	static_inventory += using
