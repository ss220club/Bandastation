/mob/living
	var/lastclienttime = 0
	var/is_ssd = FALSE

/mob/living/proc/set_ssd_state(state)
	if(state == is_ssd)
		return
	is_ssd = state

/mob/living/Login()
	. = ..()
	set_ssd_state(FALSE)

/mob/living/Logout()
	lastclienttime = world.time
	set_ssd_state(TRUE)
	. = ..()

//Temporary, look below for the reason
/mob/living/ghostize(can_reenter_corpse = TRUE)
	. = ..()
	set_ssd_state(FALSE)

/*
//EDIT - TRANSFER CKEY IS NOT A THING ON THE TG CODEBASE, if things break too bad because of it, consider implementing it
//This proc should stop mobs from having the overlay when someone keeps jumping control of mobs, unfortunately it causes Aghosts to have their character without the SSD overlay, I wasn't able to find a better proc unfortunately
/mob/living/transfer_ckey(mob/new_mob, send_signal = TRUE)
	..()
	set_ssd_state(FALSE)
*/
