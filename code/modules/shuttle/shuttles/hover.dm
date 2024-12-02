/obj/docking_port/stationary/dropship_hover
	name = "Dropship hover"
	width = 30
	height = 40
	dwidth = 15
	dheight = 20

/obj/docking_port/stationary/dropship_hover/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	var/list/levels = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	log_debug("found [levels] [length(levels)] maps")
	if(length(levels) == 0)
		log_debug("NO GROUND MAPS")
		return
	var/target_level = levels[1]
	if(!target_level)
		return
	var/target_x = 100
	var/target_y = 100

	log_debug("starting viscontents")
	var/list/turfs = get_area_turfs(/area/shuttle/dropship/hover)
	log_debug("found [length(turfs)] turfs")

	for(var/turf/T as anything in turfs)
		log_debug("turf [T]")
		var/offset_x = T.x - src.x
		var/offset_y = T.y - src.y
		var/target_tile = locate(target_x + offset_x, target_y + offset_y, target_level)
		T.vis_contents.Add(target_tile)

	log_debug("end viscontents")


/obj/docking_port/stationary/dropship_hover/on_departure(obj/docking_port/mobile/arriving_shuttle)
	. = ..()

	for(var/turf/T in /area/shuttle/dropship/hover)
		T.vis_contents.Cut()

/*
/datum/dropship_hover
	var/obj/docking_port/mobile/marine_dropship/ds

/datum/dropship_hover/New(/obj/docking_port/mobile/marine_dropship/target)
	ds = target

/datum/dropship_hover/Destroy(force=FALSE)
	. = ..()
	ds = null


/datum/dropship_hover/proc/begin_hover()
	log_world("Dropship [ds] is going into a hover.")
/datum/dropship_hover/proc/end_hover()
	log_world("Dropship [ds] is leaving the hover.")
*/

/datum/map_template/hover_template
	name = "Dropship hover template"
	mappath = "maps/shuttles/dropship_hover.dmm"
	width = 30
	height = 40
