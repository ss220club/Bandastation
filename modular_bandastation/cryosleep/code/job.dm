/datum/controller/subsystem/job/proc/FreeRoleCryo(rank)
	if(!rank)
		return
	job_debug("Freeing role: [rank]")
	var/datum/job/job = get_job(rank)
	if(!job)
		return FALSE
	job.current_positions = max(0, job.current_positions - 1)
