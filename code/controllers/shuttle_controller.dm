/datum/controller/shuttle_controller
	var/list/shuttles //maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles //simple list of shuttles, for processing
	var/list/locs_crash

/datum/controller/shuttle_controller/New()
	shuttles = list()
	process_shuttles = list()
	locs_crash = list()
