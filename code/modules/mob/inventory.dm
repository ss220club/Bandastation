//These procs handle putting stuff in your hands
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

///Returns the thing we're currently holding
/mob/proc/get_active_held_item()
	return get_item_for_held_index(active_hand_index)


//Finds the opposite limb for the active one (eg: upper left arm will find the item in upper right arm)
//So we're treating each "pair" of limbs as a team, so "both" refers to them
/mob/proc/get_inactive_held_item()
	return get_item_for_held_index(get_inactive_hand_index())


//Finds the opposite index for the active one (eg: upper left arm will find the item in upper right arm)
//So we're treating each "pair" of limbs as a team, so "both" refers to them
/mob/proc/get_inactive_hand_index()
	var/other_hand = 0
	if(!(active_hand_index % 2))
		other_hand = active_hand_index-1 //finding the matching "left" limb
	else
		other_hand = active_hand_index+1 //finding the matching "right" limb
	if(other_hand < 0 || other_hand > held_items.len)
		other_hand = 0
	return other_hand


/mob/proc/get_item_for_held_index(i)
	if(i > 0 && i <= held_items.len)
		return held_items[i]
	return null


//Odd = left. Even = right
/mob/proc/held_index_to_dir(i)
	if(!(i % 2))
		return "r"
	return "l"

//Check we have an organ for this hand slot (Dismemberment), Only relevant for humans
/mob/proc/has_hand_for_held_index(i)
	return TRUE


//Check we have an organ for our active hand slot (Dismemberment),Only relevant for humans
/mob/proc/has_active_hand()
	return has_hand_for_held_index(active_hand_index)


//Finds the first available (null) index OR all available (null) indexes in held_items based on a side.
//Lefts: 1, 3, 5, 7...
//Rights:2, 4, 6, 8...
/mob/proc/get_empty_held_index_for_side(side = LEFT_HANDS, all = FALSE)
	var/list/empty_indexes = all ? list() : null
	for(var/i in (side == LEFT_HANDS) ? 1 : 2 to held_items.len step 2)
		if(!held_items[i])
			if(!all)
				return i
			empty_indexes += i
	return empty_indexes


//Same as the above, but returns the first or ALL held *ITEMS* for the side
/mob/proc/get_held_items_for_side(side = LEFT_HANDS, all = FALSE)
	var/list/holding_items = all ? list() : null
	for(var/i in (side == LEFT_HANDS) ? 1 : 2 to held_items.len step 2)
		var/obj/item/I = held_items[i]
		if(I)
			if(!all)
				return I
			holding_items += I
	return holding_items


/mob/proc/get_empty_held_indexes()
	var/list/L
	for(var/i in 1 to held_items.len)
		if(!held_items[i])
			LAZYADD(L, i)
	return L

/mob/proc/get_held_index_of_item(obj/item/I)
	return held_items.Find(I)


///Find number of held items, multihand compatible
/mob/proc/get_num_held_items()
	. = 0
	for(var/i in 1 to held_items.len)
		if(held_items[i])
			.++

//Sad that this will cause some overhead, but the alias seems necessary
//*I* may be happy with a million and one references to "indexes" but others won't be
/mob/proc/is_holding(obj/item/I)
	return get_held_index_of_item(I)


//Checks if we're holding an item of type: typepath
/mob/proc/is_holding_item_of_type(typepath)
	for(var/obj/item/I in held_items)
		if(istype(I, typepath))
			return I
	return FALSE

//Checks if we're holding a tool that has given quality
//Returns the tool that has the best version of this quality
/mob/proc/is_holding_tool_quality(quality)
	var/obj/item/best_item
	var/best_quality = INFINITY

	for(var/obj/item/I in held_items)
		if(I.tool_behaviour == quality && I.toolspeed < best_quality)
			best_item = I
			best_quality = I.toolspeed

	return best_item


//To appropriately fluff things like "they are holding [I] in their [get_held_index_name(get_held_index_of_item(I))]"
//Can be overridden to pass off the fluff to something else (eg: science allowing people to add extra robotic limbs, and having this proc react to that
// with say "they are holding [I] in their Nanotrasen Brand Utility Arm - Right Edition" or w/e
/mob/proc/get_held_index_name(i)
	var/list/hand = list()
	if(i > 2)
		hand += "верхней "
	var/num = 0
	if(!(i % 2))
		num = i-2
		hand += "правой руке"
	else
		num = i-1
		hand += "левой руке"
	num -= (num*0.5)
	if(num > 1) //"upper left hand #1" seems weird, but "upper left hand #2" is A-ok
		hand += " #[num]"
	return hand.Join()



//Returns if a certain item can be equipped to a certain slot.
// Currently invalid for two-handed items - call obj/item/mob_can_equip() instead.
/mob/proc/can_equip(obj/item/I, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE, ignore_equipped = FALSE, indirect_action = FALSE)
	return FALSE

/mob/proc/can_put_in_hand(I, hand_index)
	if(hand_index > held_items.len)
		return FALSE
	if(!put_in_hand_check(I))
		return FALSE
	if(!has_hand_for_held_index(hand_index))
		return FALSE
	return !held_items[hand_index]

/mob/proc/put_in_hand(obj/item/I, hand_index, forced = FALSE, ignore_anim = TRUE)
	if(hand_index == null || !held_items.len || (!forced && !can_put_in_hand(I, hand_index)))
		return FALSE

	if(isturf(I.loc) && !ignore_anim)
		I.do_pickup_animation(src)
	if(get_item_for_held_index(hand_index))
		dropItemToGround(get_item_for_held_index(hand_index), force = TRUE)
	I.forceMove(src)
	held_items[hand_index] = I
	SET_PLANE_EXPLICIT(I, ABOVE_HUD_PLANE, src)
	if(I.pulledby)
		I.pulledby.stop_pulling()
	if(!I.on_equipped(src, ITEM_SLOT_HANDS))
		return FALSE
	update_held_items()
	I.pixel_x = I.base_pixel_x
	I.pixel_y = I.base_pixel_y
	if(QDELETED(I)) // this is here because some ABSTRACT items like slappers and circle hands could be moved from hand to hand then delete, which meant you'd have a null in your hand until you cleared it (say, by dropping it)
		held_items[hand_index] = null
		return FALSE
	return hand_index

//Puts the item into the first available left hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_l_hand(obj/item/I)
	return put_in_hand(I, get_empty_held_index_for_side(LEFT_HANDS))

//Puts the item into the first available right hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_r_hand(obj/item/I)
	return put_in_hand(I, get_empty_held_index_for_side(RIGHT_HANDS))

/mob/proc/put_in_hand_check(obj/item/I)
	return FALSE //nonliving mobs don't have hands

/mob/living/put_in_hand_check(obj/item/I)
	if(istype(I) && ((mobility_flags & MOBILITY_PICKUP) || (I.item_flags & ABSTRACT)) \
		&& !(SEND_SIGNAL(src, COMSIG_LIVING_TRY_PUT_IN_HAND, I) & COMPONENT_LIVING_CANT_PUT_IN_HAND))
		return TRUE
	return FALSE

//Puts the item into our active hand if possible. returns TRUE on success.
/mob/proc/put_in_active_hand(obj/item/I, forced = FALSE, ignore_animation = TRUE)
	return put_in_hand(I, active_hand_index, forced, ignore_animation)


//Puts the item into our inactive hand if possible, returns TRUE on success
/mob/proc/put_in_inactive_hand(obj/item/I, forced = FALSE)
	return put_in_hand(I, get_inactive_hand_index(), forced)


//Puts the item our active hand if possible. Failing that it tries other hands. Returns TRUE on success.
//If both fail it drops it on the floor (or nearby tables if germ sensitive) and returns FALSE.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(obj/item/I, del_on_fail = FALSE, merge_stacks = TRUE, forced = FALSE, ignore_animation = TRUE)
	if(QDELETED(I))
		return FALSE

	// If the item is a stack and we're already holding a stack then merge
	if (isstack(I))
		var/obj/item/stack/item_stack = I
		var/obj/item/stack/active_stack = get_active_held_item()

		if (item_stack.is_zero_amount(delete_if_zero = TRUE))
			return FALSE

		if (merge_stacks)
			if (istype(active_stack) && active_stack.can_merge(item_stack, inhand = TRUE))
				if (item_stack.merge(active_stack))
					to_chat(usr, span_notice("Your [active_stack.name] stack now contains [active_stack.get_amount()] [active_stack.singular_name]\s."))
					return TRUE
			else
				var/obj/item/stack/inactive_stack = get_inactive_held_item()
				if (istype(inactive_stack) && inactive_stack.can_merge(item_stack, inhand = TRUE))
					if (item_stack.merge(inactive_stack))
						to_chat(usr, span_notice("Your [inactive_stack.name] stack now contains [inactive_stack.get_amount()] [inactive_stack.singular_name]\s."))
						return TRUE

	if(put_in_active_hand(I, forced, ignore_animation))
		return TRUE

	var/hand = get_empty_held_index_for_side(LEFT_HANDS)
	if(!hand)
		hand = get_empty_held_index_for_side(RIGHT_HANDS)
	if(hand)
		if(put_in_hand(I, hand, forced, ignore_animation))
			return TRUE
	if(del_on_fail)
		qdel(I)
		return FALSE

	// Failed to put in hands - drop the item
	var/atom/location = drop_location()

	// Try dropping on nearby tables if germ sensitive (except table behind you)
	if(HAS_TRAIT(I, TRAIT_GERM_SENSITIVE))
		var/list/dirs = list( // All dirs in clockwise order
			NORTH,
			NORTHEAST,
			EAST,
			SOUTHEAST,
			SOUTH,
			SOUTHWEST,
			WEST,
			NORTHWEST,
		)
		var/dir_count = dirs.len
		var/facing_dir_index = dirs.Find(dir)
		var/cw_index = facing_dir_index
		var/ccw_index = facing_dir_index
		var/list/turfs_ordered = list(get_step(src, dir))

		// Build ordered list of turfs starting from the front facing
		for(var/i in 1 to ROUND_UP(dir_count/2) - 1)
			cw_index++
			if(cw_index > dir_count)
				cw_index = 1
			turfs_ordered += get_step(src, dirs[cw_index]) // Add next tile on your right
			ccw_index--
			if(ccw_index <= 0)
				ccw_index = dir_count
			turfs_ordered += get_step(src, dirs[ccw_index])	// Add next tile on your left

		// Check tables on these turfs
		for(var/turf in turfs_ordered)
			if(locate(/obj/structure/table) in turf || locate(/obj/structure/rack) in turf || locate(/obj/machinery/icecream_vat) in turf)
				location = turf
				break

	I.forceMove(location)
	I.layer = initial(I.layer)
	SET_PLANE_EXPLICIT(I, initial(I.plane), location)
	I.dropped(src)
	return FALSE

/// Returns true if a mob is holding something
/mob/proc/is_holding_items()
	return !!locate(/obj/item) in held_items

/**
 * Returns a list of all dropped held items.
 * If none were dropped, returns an empty list.
 */
/mob/proc/drop_all_held_items()
	. = list()
	for(var/obj/item/I in held_items)
		. |= dropItemToGround(I)

//Here lie drop_from_inventory and before_item_take, already forgotten and not missed.

/mob/proc/canUnEquip(obj/item/I, force)
	if(!I)
		return TRUE
	if(HAS_TRAIT(I, TRAIT_NODROP) && !force)
		return FALSE
	return TRUE

/mob/proc/putItemFromInventoryInHandIfPossible(obj/item/I, hand_index, force_removal = FALSE)
	if(!can_put_in_hand(I, hand_index))
		return FALSE
	if(!temporarilyRemoveItemFromInventory(I, force_removal))
		return FALSE
	I.remove_item_from_storage(src)
	if(!put_in_hand(I, hand_index))
		qdel(I)
		CRASH("Assertion failure: putItemFromInventoryInHandIfPossible") //should never be possible
	return TRUE

//The following functions are the same save for one small difference

/**
 * Used to drop an item (if it exists) to the ground.
 * * Will return null if the item wasn't dropped.
 * * If it was, returns the item.
 * If the item can be dropped, it will be forceMove()'d to the ground and the turf's Entered() will be called.
*/
/mob/proc/dropItemToGround(obj/item/I, force = FALSE, silent = FALSE, invdrop = TRUE)
	if (isnull(I))
		return

	SEND_SIGNAL(src, COMSIG_MOB_DROPPING_ITEM)
	var/try_uneqip = doUnEquip(I, force, drop_location(), FALSE, invdrop = invdrop, silent = silent)

	if(!try_uneqip || !I) //ensure the item exists and that it was dropped properly.
		return

	if(!(I.item_flags & NO_PIXEL_RANDOM_DROP))
		I.pixel_x = I.base_pixel_x + rand(-6, 6)
		I.pixel_y = I.base_pixel_y + rand(-6, 6)
	I.do_drop_animation(src)
	return I

//for when the item will be immediately placed in a loc other than the ground
/mob/proc/transferItemToLoc(obj/item/I, newloc = null, force = FALSE, silent = TRUE)
	. = doUnEquip(I, force, newloc, FALSE, silent = silent)
	I.do_drop_animation(src)

//visibly unequips I but it is NOT MOVED AND REMAINS IN SRC
//item MUST BE FORCEMOVE'D OR QDEL'D
/mob/proc/temporarilyRemoveItemFromInventory(obj/item/I, force = FALSE, idrop = TRUE)
	return doUnEquip(I, force, null, TRUE, idrop, silent = TRUE)

//DO NOT CALL THIS PROC
//use one of the above 3 helper procs
//you may override it, but do not modify the args
/mob/proc/doUnEquip(obj/item/I, force, atom/newloc, no_move, invdrop = TRUE, silent = FALSE) //Force overrides TRAIT_NODROP for things like wizarditis and admin undress.
													//Use no_move if the item is just gonna be immediately moved afterward
													//Invdrop is used to prevent stuff in pockets dropping. only set to false if it's going to immediately be replaced
	PROTECTED_PROC(TRUE)
	if(!I) //If there's nothing to drop, the drop is automatically succesfull. If(unEquip) should generally be used to check for TRAIT_NODROP.
		return TRUE

	if(HAS_TRAIT(I, TRAIT_NODROP) && !force)
		return FALSE

	if((SEND_SIGNAL(I, COMSIG_ITEM_PRE_UNEQUIP, force, newloc, no_move, invdrop, silent) & COMPONENT_ITEM_BLOCK_UNEQUIP) && !force)
		return FALSE

	var/hand_index = get_held_index_of_item(I)
	if(hand_index)
		held_items[hand_index] = null
		update_held_items()
	if(I)
		if(client)
			client.screen -= I
		I.layer = initial(I.layer)
		SET_PLANE_EXPLICIT(I, initial(I.plane), newloc)
		I.appearance_flags &= ~NO_CLIENT_COLOR
		if(!no_move && !(I.item_flags & DROPDEL)) //item may be moved/qdel'd immedietely, don't bother moving it
			if (isnull(newloc))
				I.moveToNullspace()
			else
				I.forceMove(newloc)
		I.dropped(src, silent)
	SEND_SIGNAL(I, COMSIG_ITEM_POST_UNEQUIP, force, newloc, no_move, invdrop, silent)
	SEND_SIGNAL(src, COMSIG_MOB_UNEQUIPPED_ITEM, I, force, newloc, no_move, invdrop, silent)
	return TRUE

/**
 * Used to return a list of equipped items on a mob; does not include held items (use get_all_gear)
 *
 * Argument(s):
 * * Optional - include_flags, (see obj.flags.dm) describes which optional things to include or not (pockets, accessories, held items)
 */

/mob/living/proc/get_equipped_items(include_flags = NONE)
	var/list/items = list()
	for(var/obj/item/item_contents in contents)
		if(item_contents.item_flags & IN_INVENTORY)
			items += item_contents
	if (!(include_flags & INCLUDE_HELD))
		items -= held_items
	return items

/**
 * Returns the items that were succesfully unequipped.
 */
/mob/living/proc/unequip_everything()
	var/list/items = list()
	items |= get_equipped_items(INCLUDE_POCKETS)
	// In case something isn't actually unequipped somehow
	var/list/dropped_items = list()
	for(var/I in items)
		var/return_val = dropItemToGround(I)
		if(!isitem(return_val))
			continue
		dropped_items |= return_val
	var/return_val = drop_all_held_items()
	if(islist(return_val))
		dropped_items |= return_val
	return dropped_items

/**
 * Try to equip an item to a slot on the mob
 *
 * This is a SAFE proc. Use this instead of equip_to_slot()!
 *
 * set qdel_on_fail to have it delete W if it fails to equip
 *
 * set disable_warning to disable the 'you are unable to equip that' warning.
 *
 * unset redraw_mob to prevent the mob icons from being redrawn at the end.
 *
 * Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
 *
 * set indirect_action to allow insertions into "soft" locked objects, things that are easily opened by the owning mob
 */
/mob/proc/equip_to_slot_if_possible(obj/item/W, slot, qdel_on_fail = FALSE, disable_warning = FALSE, redraw_mob = TRUE, bypass_equip_delay_self = FALSE, initial = FALSE, indirect_action = FALSE)
	if(!istype(W) || QDELETED(W)) //This qdeleted is to prevent stupid behavior with things that qdel during init, like say stacks
		return FALSE
	if(!W.mob_can_equip(src, slot, disable_warning, bypass_equip_delay_self, indirect_action = indirect_action))
		if(qdel_on_fail)
			qdel(W)
		else if(!disable_warning)
			to_chat(src, span_warning("You are unable to equip that!"))
		return FALSE
	equip_to_slot(W, slot, initial, redraw_mob, indirect_action = indirect_action) //This proc should not ever fail.
	return TRUE

/**
 * Actually equips an item to a slot (UNSAFE)
 *
 * This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on
 * whether you can or can't equip need to be done before! Use mob_can_equip() for that task.
 *
 *In most cases you will want to use equip_to_slot_if_possible()
 */
/mob/proc/equip_to_slot(obj/item/equipping, slot, initial = FALSE, redraw_mob = FALSE, indirect_action = FALSE)
	return

/**
 * Equip an item to the slot or delete
 *
 * This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to
 * equip people when the round starts and when events happen and such.
 *
 * Also bypasses equip delay checks, since the mob isn't actually putting it on.
 * Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
 * set indirect_action to allow insertions into "soft" locked objects, things that are easily opened by the owning mob
 */
/mob/proc/equip_to_slot_or_del(obj/item/W, slot, initial = FALSE, indirect_action = FALSE)
	return equip_to_slot_if_possible(W, slot, TRUE, TRUE, FALSE, TRUE, initial, indirect_action)

/**
 * Auto equip the passed in item the appropriate slot based on equipment priority
 *
 * puts the item "W" into an appropriate slot in a human's inventory
 *
 * returns 0 if it cannot, 1 if successful
 */
/mob/proc/equip_to_appropriate_slot(obj/item/W, qdel_on_fail = FALSE, indirect_action = FALSE)
	if(!istype(W))
		return FALSE
	var/slot_priority = W.slot_equipment_priority

	if(!slot_priority)
		slot_priority = list( \
			ITEM_SLOT_BACK, ITEM_SLOT_ID,\
			ITEM_SLOT_ICLOTHING, ITEM_SLOT_OCLOTHING,\
			ITEM_SLOT_MASK, ITEM_SLOT_HEAD, ITEM_SLOT_NECK,\
			ITEM_SLOT_FEET, ITEM_SLOT_GLOVES,\
			ITEM_SLOT_EARS, ITEM_SLOT_EYES,\
			ITEM_SLOT_BELT, ITEM_SLOT_SUITSTORE,\
			ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET,\
			ITEM_SLOT_DEX_STORAGE\
		)

	for(var/slot in slot_priority)
		if(equip_to_slot_if_possible(W, slot, disable_warning = TRUE, redraw_mob = TRUE, indirect_action = indirect_action))
			return TRUE

	if(qdel_on_fail)
		qdel(W)
	return FALSE

/// Tries to equip an item, store it in open storage, or in next best storage
/obj/item/proc/equip_to_best_slot(mob/user)
	if(user.equip_to_appropriate_slot(src))
		user.update_held_items()
		return TRUE
	else
		if(equip_delay_self)
			return

	if(user.active_storage?.attempt_insert(src, user, messages = FALSE))
		return TRUE

	var/list/obj/item/possible = list(
		user.get_inactive_held_item(),
		user.get_item_by_slot(ITEM_SLOT_BELT),
		user.get_item_by_slot(ITEM_SLOT_DEX_STORAGE),
		user.get_item_by_slot(ITEM_SLOT_BACK),
	)
	for(var/thing in possible)
		if(isnull(thing))
			continue
		var/obj/item/gear = thing
		if(gear.atom_storage?.attempt_insert(src, user, messages = FALSE))
			return TRUE

	to_chat(user, span_warning("You are unable to equip that!"))
	return FALSE


/mob/verb/quick_equip()
	set name = "quick-equip"
	set hidden = TRUE

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(execute_quick_equip)))

/// Safely drop everything, without deconstructing the mob
/mob/proc/drop_everything(del_on_drop, force, del_if_nodrop)
	. = list()
	for(var/obj/item/item in src)
		if(!dropItemToGround(item, force))
			if(del_if_nodrop && !(item.item_flags & ABSTRACT))
				qdel(item)
		if(del_on_drop)
			qdel(item)
		//Anything thats not deleted and isn't in the mob, so everything that is succesfully dropped to the ground, is returned
		if(!QDELETED(item) && !(item in src))
			. += item

///proc extender of [/mob/verb/quick_equip] used to make the verb queuable if the server is overloaded
/mob/proc/execute_quick_equip()
	var/obj/item/I = get_active_held_item()
	if(!I)
		to_chat(src, span_warning("You are not holding anything to equip!"))
		return
	if(!QDELETED(I))
		I.equip_to_best_slot(src)

//used in code for items usable by both carbon and drones, this gives the proper back slot for each mob.(defibrillator, backpack watertank, ...)
/mob/proc/getBackSlot()
	return ITEM_SLOT_BACK

/mob/proc/getBeltSlot()
	return ITEM_SLOT_BELT

//Inventory.dm is -kind of- an ok place for this I guess

//This is NOT for dismemberment, as the user still technically has 2 "hands"
//This is for multi-handed mobs, such as a human with a third limb installed
//This is a very rare proc to call (besides admin fuckery) so
//any cost it has isn't a worry
/mob/proc/change_number_of_hands(amt)
	if(amt < held_items.len)
		for(var/i in held_items.len to amt step -1)
			dropItemToGround(held_items[i])
	held_items.len = amt

	if(hud_used)
		hud_used.build_hand_slots()

//GetAllContents that is reasonable and not stupid
/mob/living/proc/get_all_gear(accessories = TRUE, recursive = TRUE)
	var/list/processing_list = get_equipped_items(INCLUDE_POCKETS | INCLUDE_HELD | (accessories ? INCLUDE_ACCESSORIES : NONE))
	list_clear_nulls(processing_list) // handles empty hands
	var/i = 0
	while(i < length(processing_list))
		var/atom/A = processing_list[++i]
		if(A.atom_storage && recursive)
			processing_list += A.atom_storage.return_inv()
	return processing_list

/// Returns a list of things that the provided mob has, including any storage-capable implants.
/mob/living/proc/gather_belongings(accessories = TRUE, recursive = TRUE)
	var/list/belongings = get_all_gear(accessories, recursive)
	for (var/obj/item/implant/storage/internal_bag in implants)
		belongings += internal_bag.contents
	return belongings
