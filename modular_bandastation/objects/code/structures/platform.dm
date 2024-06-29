// Platform
/obj/structure/platform
	name = "platform"
	icon = 'modular_bandastation/objects/icons/platform.dmi'
	icon_state = "metal"
	desc = "A metal platform."
	flags_1 = ON_BORDER_1
	density = TRUE
	anchored = FALSE
	var/climbable = TRUE
	max_integrity = 200
	armor_type = /datum/armor/structure_platform
	var/corner = FALSE
	var/material_type = /obj/item/stack/sheet/iron
	var/material_amount = 4
	var/decon_speed

/datum/armor/structure_platform
	melee = 10
	bullet = 10
	laser = 10
	energy = 50
	bomb = 20
	fire = 30
	acid = 30

/obj/structure/platform/Initialize()
	. = ..()
	if(climbable)
		AddElement(/datum/element/climbable)
	CheckLayer()
	if(density && flags_1 & ON_BORDER_1) // blocks normal movement from and to the direction it's facing.
		var/static/list/loc_connections = list(
			COMSIG_ATOM_EXIT = PROC_REF(on_exit),
		)
		AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/platform/proc/CheckLayer()
	if(dir == SOUTH)
		layer = ABOVE_MOB_LAYER
	else if(corner || dir == NORTH)
		layer = BELOW_MOB_LAYER

/obj/structure/platform/proc/can_be_reached(mob/user)
	var/checking_dir = get_dir(user, src)
	if(!(checking_dir & dir))
		return TRUE
	checking_dir = REVERSE_DIR(checking_dir)
	for(var/obj/blocker in loc)
		if(!blocker.CanPass(user, checking_dir))
			return FALSE
	return TRUE

/obj/structure/platform/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(border_dir & dir)
		return . || mover.throwing || (mover.movement_type & MOVETYPES_NOT_TOUCHING_GROUND)
	return TRUE

/obj/structure/platform/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!(to_dir & dir))
		return TRUE
	return ..()

/obj/structure/platform/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return // Let's not block ourselves.

	if(!(direction & dir))
		return

	if (!density)
		return

	if (leaving.throwing)
		return

	if (leaving.movement_type & (PHASING|MOVETYPES_NOT_TOUCHING_GROUND))
		return

	if (leaving.move_force >= MOVE_FORCE_EXTREMELY_STRONG)
		return

	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/platform/setDir(newdir)
	. = ..()
	CheckLayer()

/obj/structure/platform/New()
	..()
	if(corner)
		decon_speed = 20
		density = FALSE
		climbable = FALSE
	else
		decon_speed = 30
	CheckLayer()

/obj/structure/platform/examine(mob/user)
	. = ..()
	. += span_notice("[src] is [anchored == TRUE ? "screwed" : "unscrewed"] [anchored == TRUE ? "to" : "from"] the floor.")
	. += span_notice("<b>Alt-Click</b> to rotate.")

/obj/structure/platform/proc/rotate(mob/user)
	if(user.incapacitated())
		return

	if(anchored)
		to_chat(user, span_warning("[src] cannot be rotated while it is screwed to the floor!"))
		return FALSE

	var/target_dir = turn(dir, 90)

	setDir(target_dir)
	air_update_turf(1)
	add_fingerprint(user)
	return TRUE

/obj/structure/platform/click_alt(mob/user)
	. = ..()
	rotate(user)

// Construction
/obj/structure/platform/screwdriver_act(mob/user, obj/item/I)
	. = ..()
	user.balloon_alert(user, "[anchored ? "unsecuring..." : "securing..."]")
	if(I.use_tool(src, user, decon_speed, volume = 50))
		user.balloon_alert(user, "[anchored ? "unsecured" : "secured"]")
		anchored = !anchored
		return ITEM_INTERACT_SUCCESS

/obj/structure/platform/wrench_act(mob/living/user, obj/item/tool)
	if(anchored)
		to_chat(user, "Unscrew it first.")
		return ITEM_INTERACT_FAILURE
	if(!anchored)
		user.balloon_alert(user, "deconstructed")
		if(tool.use_tool(src, user, volume = 50))
			playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
			new material_type(user.loc, material_amount)
			qdel(src)
			return ITEM_INTERACT_SUCCESS

// Platform types
/obj/structure/platform/reinforced
	name = "reinforced platform"
	desc = "A robust platform made of plasteel, more resistance for hazard sites."
	icon_state = "plasteel"
	material_type = /obj/item/stack/sheet/plasteel
	max_integrity = 300
	armor_type = /datum/armor/structure_rplatform

/datum/armor/structure_rplatform
	melee = 20
	bullet = 30
	laser = 30
	energy = 100
	bomb = 50
	fire = 100
	acid = 100

// Platform corners
/obj/structure/platform/corner
	name = "platform corner"
	desc = "A metal platform corner."
	icon_state = "metalcorner"
	corner = TRUE
	material_amount = 2

/obj/structure/platform/reinforced/corner
	name = "reinforced platform corner"
	desc = "A robust platform corner made of plasteel, more resistance for hazard sites."
	icon_state = "plasteelcorner"
	corner = TRUE
	material_amount = 2
