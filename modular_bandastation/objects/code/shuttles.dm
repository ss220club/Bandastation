// Shuttle Dockers
/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/sit
	name = "syndicate infiltrator navigation computer"
	desc = "Used to pilot the syndicate infiltration team to board enemy stations and ships."
	shuttleId = "syndicate_sit"
	shuttlePortId = "syndicate_sit_custom"
	x_offset = 0
	y_offset = 3

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/sst
	name = "syndicate striker navigation computer"
	desc = "Used to pilot the syndicate strike team to board enemy stations and ships."
	shuttleId = "syndicate_sst"
	shuttlePortId = "syndicate_sst_custom"
	x_offset = 0
	y_offset = 3

/obj/machinery/computer/camera_advanced/shuttle_docker/argos
	name = "syndicate infiltrator navigation computer"
	desc = "Used to pilot Argos shuttle."
	shuttleId = "argos"
	shuttlePortId = "argos_custom"
	x_offset = 0
	y_offset = 8
	lock_override = CAMERA_LOCK_STATION
	jump_to_ports = list("syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)

// Shuttle Dockers Override
/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate
	x_offset = 0
	y_offset = 10

// Shuttle Control Terminals
/obj/machinery/computer/shuttle/syndicate/sit
	name = "syndicate shuttle recall terminal"
	desc = "Use this if your friends left you behind."
	shuttleId = "syndicate_sit"
	possible_destinations = "syndicate_sit;syndicate_z5;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s;syndicate_custom"

/obj/machinery/computer/shuttle/syndicate/sst
	name = "syndicate shuttle recall terminal"
	desc = "Use this if your friends left you behind."
	shuttleId = "syndicate_sst"
	possible_destinations = "syndicate_sst;syndicate_z5;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s;syndicate_custom"

/obj/machinery/computer/shuttle/argos
	name = "transport argos console"
	desc = "A console that controls the transport Argos."
	circuit = /obj/item/circuitboard/computer/argos
	shuttleId = "argos"
	possible_destinations = "argos_home;ferry_trurl;argos_custom"
	req_access = list(ACCESS_CENT_GENERAL)

/**
 * Not sure now if we need to declare war if we use these shuttles
 * Probably not. If we want it, so we'll have to modify "is_infiltrator_docked_at_syndiebase" proc
 */
/obj/machinery/computer/shuttle/syndicate/sit/launch_check(mob/user)
	return allowed(user)

/obj/machinery/computer/shuttle/syndicate/sst/launch_check(mob/user)
	return allowed(user)

// Shutte Docking Port
/obj/docking_port/mobile/syndicate_sit
	name = "syndicate sit shuttle"
	shuttle_id = "syndicate_sit"
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	hidden = TRUE
	dir = EAST
	port_direction = WEST
	preferred_direction = NORTH

/obj/docking_port/mobile/syndicate_sst
	name = "syndicate sst shuttle"
	shuttle_id = "syndicate_sst"
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	hidden = TRUE
	dir = WEST
	port_direction = EAST
	preferred_direction = NORTH

/obj/docking_port/mobile/argos
	name = "argos shuttle"
	shuttle_id = "argos"
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	hidden = TRUE
	dir = NORTH
	port_direction = NORTH
	preferred_direction = SOUTH

// Shuttle Areas
/area/shuttle/syndicate_sit
	name = "Syndicate SIT Shuttle"

/area/shuttle/syndicate_sst
	name = "Syndicate SST Shuttle"

/area/shuttle/argos
	name = "Argos Shuttle"

// Shuttle Circuitboard
/obj/item/circuitboard/computer/argos
	name = "Transport Argos"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/shuttle/argos
