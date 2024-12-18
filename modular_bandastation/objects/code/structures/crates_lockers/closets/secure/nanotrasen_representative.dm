/obj/structure/closet/secure_closet/nanotrasen_representative
	name = "nanotrasen representative's locker"
	// icon_state = "nanotrasen_representative"
	// icon = 'modular_bandastation/jobs/job_types/nanotrasen_representative/icons/obj/closet.dmi'
	req_access = list(ACCESS_NANOTRASEN_REPRESENTATIVE)

/obj/structure/closet/secure_closet/nanotrasen_representative/New()
	..()
	new /obj/item/storage/briefcase/secure(src)
	new /obj/item/radio/headset/headset_cent(src)
	new /obj/item/radio/headset/headset_cent/alt(src)
	new /obj/item/pai_card(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/taperecorder(src)
	new /obj/item/storage/box/tapes(src)
	new /obj/item/storage/bag/garment/nanotrasen_representative(src)
