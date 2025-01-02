/obj/item/storage/box/smoke_grenade
	name = "box of smoke grenade"
	desc = "Do not shake."
	icon_state = "secbox"
	illustration = "grenade"

/obj/item/storage/box/flashes/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/grenade/smokebomb(src)

/obj/item/storage/box/pepper_spray
	name = "box of pepper sprays"
	desc = "Everyone put masks on your face."
	icon_state = "secbox"
	illustration = "grenade"

/obj/item/storage/box/pepper_spray/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/spray/pepper(src)
