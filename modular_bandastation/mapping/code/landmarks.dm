/obj/effect/mapping_helpers/airlock/access/all/syndicate/command/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SYNDICATE_COMMAND
	return access_list
