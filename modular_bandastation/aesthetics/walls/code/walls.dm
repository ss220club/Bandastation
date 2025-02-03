// MARK: Walls
/turf/closed/wall
	icon = 'icons/bandastation/walls/wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	canSmoothWith = SMOOTH_GROUP_GIRDER + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/wall/rust
	icon = 'icons/bandastation/walls/wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"

/turf/closed/wall/r_wall
	icon = 'icons/bandastation/walls/reinforced_wall.dmi'
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"

/turf/closed/wall/r_wall/rust
	icon = 'icons/bandastation/walls/reinforced_wall.dmi'
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"

/turf/closed/wall/mineral/titanium
	smoothing_groups = SMOOTH_GROUP_TITANIUM_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_TITANIUM_WALLS

/turf/closed/wall/mineral/cult
	icon = 'icons/bandastation/walls/cult_wall.dmi'
	icon_state = "cult_wall-0"
	base_icon_state = "cult_wall"
	canSmoothWith = SMOOTH_GROUP_GIRDER + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/wall/material
	icon = 'icons/bandastation/walls/material_wall.dmi'
	icon_state = "material_wall-0"
	base_icon_state = "material_wall"
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_GIRDER + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

// MARK: Indestructible walls
/turf/closed/indestructible/riveted
	icon = 'icons/bandastation/walls/reinforced_wall.dmi'
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_GIRDER + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/indestructible/reinforced
	icon = 'icons/bandastation/walls/reinforced_wall.dmi'
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	canSmoothWith = SMOOTH_GROUP_GIRDER + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/indestructible/cult
	icon = 'icons/bandastation/walls/cult_wall.dmi'
	icon_state = "cult_wall-0"
	base_icon_state = "cult_wall"
	canSmoothWith = SMOOTH_GROUP_GIRDER + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

// MARK: Falsewalls
/obj/structure/falsewall
	icon = 'modular_bandastation/aesthetics/walls/icons/false_walls.dmi'
	base_icon_state = "wall"
	icon_state = "wall-open"
	fake_icon = 'icons/bandastation/walls/wall.dmi'
	canSmoothWith = SMOOTH_GROUP_GIRDER + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/obj/structure/falsewall/reinforced
	icon_state = "reinforced_wall-open"
	base_icon_state = "reinforced_wall"
	icon = 'modular_bandastation/aesthetics/walls/icons/false_walls.dmi'
	fake_icon = 'icons/bandastation/walls/reinforced_wall.dmi'

/obj/structure/falsewall/uranium
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/gold
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/silver
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/diamond
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/plasma
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/bananium
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/sandstone
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/wood
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/bamboo
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/iron
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/abductor
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/titanium
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/plastitanium
	icon = 'icons/turf/walls/false_walls.dmi'

/obj/structure/falsewall/material
	icon = 'icons/turf/walls/false_walls.dmi'

// MARK: Girder
/obj/structure/girder
	canSmoothWith = SMOOTH_GROUP_GIRDER + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS
