/obj/structure/blocker/fog/upwash
	opacity = FALSE
	density = FALSE

/obj/docking_port/stationary/dropship_hover
	name = "Dropship hover"
	width = 30
	height = 40
	dwidth = 15
	dheight = 20

	var/target_x = 100
	var/target_y = 50
	// we want to dynamically assign the z level
	// eventually this will have multiple options, right now we just
	// populate the ground map
	var/target_z = null

/obj/docking_port/stationary/dropship_hover/proc/set_hover_target(var/x, var/y)
	target_x = x
	target_y = y

/obj/docking_port/stationary/dropship_hover/proc/set_z(var/z=null)
	var/list/levels = SSmapping.levels_by_trait(ZTRAIT_GROUND)

	if(z == null)
		if(length(levels) == 0)
			return
		var/target_level = levels[1]
		z = target_level

	var/found = FALSE
	for(var/level in levels)
		if(z==level)
			found = TRUE
			target_z = level
			break
	if(!found)
		log_debug("Invalid z level")

/obj/docking_port/stationary/dropship_hover/proc/get_z()
	if(target_z == null)
		set_z()
	return target_z

/obj/docking_port/stationary/dropship_hover/proc/valid_coordinates()
	return get_z() != null

/obj/docking_port/stationary/dropship_hover/proc/can_see_turf(var/turf/T, var/nearby=FALSE)
	var/area/targ_area = get_area(T)
	var/is_visible = FALSE
	switch(targ_area.ceiling)
		if(CEILING_NONE)
			is_visible = TRUE
		if(CEILING_GLASS)
			is_visible = TRUE
	if(is_visible)
		return TRUE
	if(!nearby)
		return FALSE
	var/target_y = T.y - 1
	var/target_x = T.x - 1
	var/target_z = T.z
	// y -1
	var/turf/target = locate(target_x, target_y, target_z)
	if(can_see_turf(target))
		return TRUE
	target_x += 1
	target = locate(target_x, target_y, target_z)
	if(can_see_turf(target))
		return TRUE
	target_x += 1
	target = locate(target_x, target_y, target_z)
	if(can_see_turf(target))
		return TRUE

	// y 0
	target_x = T.x - 1
	target_y = T.y

	target = locate(target_x, target_y, target_z)
	if(can_see_turf(target))
		return TRUE
	target_x += 2
	target = locate(target_x, target_y, target_z)
	if(can_see_turf(target))
		return TRUE
	// y 1
	target_x = T.x - 1
	target_y = T.y + 1
	target = locate(target_x, target_y, target_z)
	if(can_see_turf(target))
		return TRUE
	target_x += 1
	target = locate(target_x, target_y, target_z)
	if(can_see_turf(target))
		return TRUE
	target_x += 1
	target = locate(target_x, target_y, target_z)
	if(can_see_turf(target))
		return TRUE
	return FALSE

/obj/docking_port/stationary/dropship_hover/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()

	if(!valid_coordinates())
		return

	var/target_level = get_z()

	log_debug("starting viscontents")
	var/list/turfs = get_area_turfs(/area/shuttle/dropship/hover)
	log_debug("found [length(turfs)] turfs")

	var/atom/movable/screen/background/roof = new
	roof.icon = 'icons/turf/floors/roof.dmi'
	roof.icon_state = "rooftop1"

	var/datum/weather_event/sand/weather = new

	var/obj/effect/weather_vfx_holder/curr_master_turf_overlay = new /obj/effect/weather_vfx_holder

	curr_master_turf_overlay.icon_state = weather.turf_overlay_icon_state
	curr_master_turf_overlay.alpha = weather.turf_overlay_alpha

	for(var/turf/T as anything in turfs)
		log_debug("turf [T]")
		var/offset_x = T.x - src.x
		var/offset_y = T.y - src.y
		var/turf/target_tile = locate(target_x + offset_x, target_y + offset_y, target_level)
		var/is_visible = can_see_turf(target_tile, nearby=TRUE)

		T.vis_contents.Cut()
		if(is_visible)
			T.vis_contents.Add(target_tile)
		else
			T.vis_contents.Add(roof)

		T.overlays += curr_master_turf_overlay

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
