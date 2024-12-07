/obj/item/storage/bag/garment/blueshield
	name = "blueshield's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the blueshield."

/obj/item/storage/bag/garment/blueshield/PopulateContents()
	new /obj/item/clothing/suit/hooded/wintercoat/blueshield(src)
	new /obj/item/clothing/suit/armor/vest/blueshield(src)
	new /obj/item/clothing/suit/armor/vest/blueshield_jacket(src)
	new /obj/item/clothing/head/beret/blueshield(src)
	new /obj/item/clothing/head/beret/blueshield/navy(src)
	new /obj/item/clothing/mask/gas/sechailer(src)
	new /obj/item/clothing/under/rank/blueshield(src)
	new /obj/item/clothing/under/rank/blueshield/skirt(src)
	new /obj/item/clothing/under/rank/blueshield/casual(src)
	new /obj/item/clothing/under/rank/blueshield/casual/skirt(src)
	new /obj/item/clothing/under/rank/blueshield/turtleneck(src)
	new /obj/item/clothing/under/rank/blueshield/turtleneck/skirt(src)
	new /obj/item/clothing/under/rank/blueshield/formal(src)
	new /obj/item/clothing/neck/cloak/blueshield(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/clothing/glasses/hud/health/sunglasses(src)
	new /obj/item/clothing/shoes/jackboots/sec(src)
	new /obj/item/clothing/shoes/laceup(src)

/obj/structure/closet/secure_closet/blueshield
	name = "blueshield's locker"
	icon_state = "bs"
	icon = 'modular_bandastation/jobs/icons/blueshield/obj/closet.dmi'
	req_access = list(ACCESS_BLUESHIELD)

/obj/structure/closet/secure_closet/blueshield/New()
	..()
	new /obj/item/storage/briefcase/secure(src)
	new /obj/item/storage/medkit/advanced(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/storage/bag/garment/blueshield(src)
	new /obj/item/radio/headset/blueshield(src)
	new /obj/item/radio/headset/blueshield/alt(src)
	new /obj/item/sensor_device(src)
	new /obj/item/pinpointer/crew(src)
