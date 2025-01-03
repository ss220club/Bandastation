/datum/controller/subsystem/gamemode/Initialize(time, zlevel)
	. = ..()
	selected_storyteller = /datum/storyteller/prime

/datum/storyteller/prime
	name = "Andy Prime"
	desc = "Andy Prime is the default Storyteller, and the comparison point for every other Storyteller. Best for an average, varied experience."
	always_votable = TRUE
	welcome_text = "I am not your Andy!"
	weight = 6
