/obj/docking_port/mobile/supply_elevator
	name="Supply Elevator"
	id = MOBILE_ALMAYER_SUPPLY_SHUTTLE
	height=5
	width=5
	preferred_direction = NORTH
	port_direction = SOUTH

	area_type = /area/shuttle/supply_shuttle

	// Shuttle timings
	callTime = 30 SECONDS
	rechargeTime = 30 SECONDS
	ignitionTime = 4 SECONDS
	ambience_flight = 'sound/vehicles/tank_driving.ogg'
	ignition_sound = 'sound/mecha/powerup.ogg'

	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)

/obj/docking_port/mobile/supply_elevator/proc/forbidden_atoms_check()
	if (mode != SHUTTLE_IDLE)
		return FALSE

	return GLOB.supply_controller.forbidden_atoms_check(area_type)

/obj/docking_port/mobile/supply_elevator/proc/lower()
	set_mode(SHUTTLE_IGNITING)
	on_ignition()
	setTimer(ignitionTime)
/obj/docking_port/mobile/supply_elevator/proc/raise()

/obj/docking_port/stationary/almayer_supply
	name="Requisitions"
	id = ALMAYER_SUPPLY_LZ
	dir=NORTH
	width=5
	height=5
	roundstart_template = /datum/map_template/shuttle/supply_elevator
