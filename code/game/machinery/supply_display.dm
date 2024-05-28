/obj/structure/machinery/status_display/supply_display
	ignore_friendc = 1

/obj/structure/machinery/status_display/supply_display/update()
	if(!..() && mode == STATUS_DISPLAY_CUSTOM)
		message1 = "SUPPLY"
		message2 = ""
		var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(MOBILE_ALMAYER_SUPPLY_SHUTTLE)
		if (!shuttle)
			message2 = "Error"
			return 0
		if(shuttle.mode == SHUTTLE_IDLE)
			message2 = "Docked"
			update_display(message1, message2)
			return 1
		message2 = get_supply_shuttle_timer()
		update_display(message1, message2)
		return 1
	return 0

/obj/structure/machinery/status_display/supply_display/receive_signal/(datum/signal/signal)
	if(signal.data["command"] == "supply")
		mode = STATUS_DISPLAY_CUSTOM
	else
		..(signal)
