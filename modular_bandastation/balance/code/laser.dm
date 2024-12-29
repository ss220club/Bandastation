// MARK: carbine changes
/obj/item/ammo_casing/energy/lasergun/carbine
	e_cost = LASER_SHOTS(20, STANDARD_CELL_CHARGE) // Original: LASER_SHOTS(40, STANDARD_CELL_CHARGE)

/obj/projectile/beam/laser/carbine
	speed = 0.8 // Original: 1.25

/obj/item/gun/energy/laser/carbine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS, allow_akimbo = FALSE) // Original: automatic_fire, 0.15 SECONDS
