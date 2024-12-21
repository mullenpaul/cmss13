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

	var/atom/movable/screen/background/roof = new


/obj/docking_port/stationary/dropship_hover/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_HOVER_LOCATION, PROC_REF(set_hover_target))
	roof.icon = 'icons/turf/floors/roof.dmi'
	roof.icon_state = "rooftop1"

/obj/docking_port/stationary/dropship_hover/proc/set_hover_target(source, x, y)
	SIGNAL_HANDLER
	target_x = x
	target_y = y
	set_visual_on_target()

/obj/docking_port/stationary/dropship_hover/proc/set_z(z=null)
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

/obj/docking_port/stationary/dropship_hover/proc/can_see_turf(turf/T, nearby=FALSE)
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

/obj/docking_port/stationary/dropship_hover/proc/set_visual_on_target()

	if(!valid_coordinates())
		return

	var/target_level = get_z()

	var/list/turfs = get_area_turfs(/area/shuttle/dropship/hover)

	var/datum/weather_event/sand/weather = new

	var/obj/effect/weather_vfx_holder/curr_master_turf_overlay = new /obj/effect/weather_vfx_holder

	curr_master_turf_overlay.icon_state = weather.turf_overlay_icon_state
	curr_master_turf_overlay.alpha = weather.turf_overlay_alpha

	for(var/turf/T as anything in turfs)
		var/offset_x = T.x - src.x
		var/offset_y = T.y - src.y
		var/turf/target_tile = locate(target_x + offset_x, target_y + offset_y, target_level)


		T.vis_contents.Cut()
		T.vis_flags = VIS_UNDERLAY | VIS_INHERIT_LAYER
		for(var/obj/O in target_tile)
			O.vis_flags = VIS_UNDERLAY | VIS_INHERIT_LAYER

		var/is_visible = can_see_turf(target_tile, nearby=TRUE)
		if(is_visible)
			T.vis_contents.Add(target_tile)
		else
			T.vis_contents.Add(roof)

		//T.overlays += curr_master_turf_overlay
		T.underlays += curr_master_turf_overlay

	var/obj/docking_port/mobile/shuttle = get_mobile_docked()
	var/area/A = get_area(shuttle)
	for(var/turf/T as anything in A)
		var/offset_x = T.x - src.x
		var/offset_y = T.y - src.y
		var/turf/target_tile = locate(target_x + offset_x, target_y + offset_y, target_level)
		//target_tile.vis_flags = VIS_UNDERLAY | VIS_INHERIT_LAYER
		for(var/obj/O in target_tile)
			O.vis_flags = VIS_UNDERLAY | VIS_INHERIT_LAYER

		T.vis_contents.Cut()
		if(locate(/obj/structure/shuttle) in T)
			var/is_visible = can_see_turf(target_tile, nearby=TRUE)
			if(is_visible)
				T.vis_contents.Add(target_tile)
			else
				T.vis_contents.Add(roof)


		//T.vis_flags |= VIS_UNDERLAY

		//if(is_visible)
		//	T.vis_contents.Add(target_tile)


/obj/docking_port/stationary/dropship_hover/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	SEND_SIGNAL(arriving_shuttle, COMSIG_HOVER_REGISTER)
	set_visual_on_target()

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
