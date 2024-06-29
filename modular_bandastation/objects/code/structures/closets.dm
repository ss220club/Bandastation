/obj/structure/closet/secure_closet/expedition
	name = "expeditors locker"
	req_access = list(ACCESS_COMMAND)
	icon = 'modular_bandastation/objects/icons/closets.dmi'
	icon_state = "explorer"

/obj/structure/closet/secure_closet/expedition/PopulateContents()
	. = ..()
	new /obj/item/gun/energy/awaymission_aeg/rnd(src)
	new /obj/item/storage/medkit/regular(src)
	new /obj/item/paper/pamphlet/gateway(src)
