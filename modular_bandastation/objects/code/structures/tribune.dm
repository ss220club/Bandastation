// Tribune
/obj/structure/tribune
	name = "tribune"
	icon = 'modular_bandastation/objects/icons/tribune.dmi'
	icon_state = "nt_tribune"
	desc = "A sturdy wooden tribune. When you look at it, you want to start making a speech."
	density = TRUE
	anchored = FALSE
	max_integrity = 100
	resistance_flags = FLAMMABLE
	can_buckle = TRUE
	flags_1 = ON_BORDER_1
	var/buildstacktype = /obj/item/stack/sheet/mineral/wood
	var/buildstackamount = 5

/obj/structure/tribune/Initialize(mapload)
	..()
	handle_layer()
	if(density && flags_1 & ON_BORDER_1)
		var/static/list/loc_connections = list(
			COMSIG_ATOM_EXIT = PROC_REF(on_exit),
		)
		AddElement(/datum/element/connect_loc, loc_connections)
	return INITIALIZE_HINT_NORMAL

/obj/structure/tribune/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(border_dir & dir)
		return . || mover.throwing || (mover.movement_type & MOVETYPES_NOT_TOUCHING_GROUND)
	return TRUE

/obj/structure/tribune/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!(to_dir & dir))
		return TRUE
	return ..()

/obj/structure/tribune/proc/on_exit(datum/source, atom/movable/leaving, direction)
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

/obj/structure/tribune/wrench_act(mob/user, obj/item/tool)
	. = TRUE
	default_unfasten_wrench(user, tool)

/obj/structure/tribune/screwdriver_act(mob/user, obj/item/tool)
	. = ..()
	if(obj_flags & INDESTRUCTIBLE)
		to_chat(user, span_warning("Try as you might, you can't figure out how to deconstruct [src]."))
		return ITEM_INTERACT_FAILURE
	to_chat(user, span_notice("You start disassembling [src]..."))
	if(tool.use_tool(src, user, 2 SECONDS, volume = 50))
		user.balloon_alert(user, "disassembled")
		deconstruct(TRUE)
		return ITEM_INTERACT_SUCCESS

/obj/structure/tribune/atom_deconstruct(disassembled = TRUE)
	. = ..()
	var/turf/target_turf = get_turf(src)
	if(buildstacktype)
		new buildstacktype(target_turf, buildstackamount)

/obj/structure/tribune/proc/after_rotation(mob/user)
	add_fingerprint(user)

/obj/structure/tribune/setDir(newdir)
	..()
	handle_layer()

/obj/structure/tribune/Move(newloc, direct, movetime)
	. = ..()
	handle_layer()

/obj/structure/tribune/proc/handle_layer()
	if(dir == NORTH)
		layer = LOW_OBJ_LAYER
		return
	layer = ABOVE_MOB_LAYER

/obj/structure/tribune/click_alt(mob/user)
	. = ..()
	if(!Adjacent(user))
		return
	if(anchored)
		to_chat(user, span_warning("It is fastened to the floor!"))
		return
	setDir(turn(dir, 90))
	after_rotation(user)

/obj/structure/tribune/centcom
	name = "CentCom tribune"
	icon_state = "nt_tribune_cc"
	desc = "A richly decorated tribune. Just looking at her makes your heart skip a beat."
	obj_flags = INDESTRUCTIBLE
