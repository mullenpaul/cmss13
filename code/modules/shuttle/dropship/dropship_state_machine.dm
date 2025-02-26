#define DROPSHIP_LANDED "landed"
#define DROPSHIP_IN_TRANSIT "transit"
#define	DROPSHIP_ON_STATION "on_station"
#define DROPSHIP_HOVER "hover"
#define DROPSHIP_HIJACK "hijack"
#define DROPSHIP_CAS "cas"
#define DROPSHIP_CRASH "crash"

/datum/dropship_state_machine
	var/datum/dropship_state/state
	var/obj/docking_port/mobile/marine_dropship/dropship

/datum/dropship_state_machine/New(obj/docking_port/mobile/marine_dropship/d)
	dropship = d
	state = new /datum/dropship_state/landed()

/datum/dropship_state_machine/proc/command(datum/dropship_state_command/command)
	// Requests to the state machine externally
	CRASH("Unimplemented proc")

/datum/dropship_state_machine/proc/process()
	// Regular processing for timing events
	if(state.is_stable)
		return
	CRASH("Unimplemented proc")

/datum/dropship_state_machine/proc/is_valid_transition(new_state)
	CRASH("Unimplemented proc")

/datum/dropship_state_command

/datum/dropship_state_command/transit_to_destination


/datum/dropship_state
	var/name
	var/state
	// is the state unaffected by time
	var/is_stable

/datum/dropship_state/landed
	name = "landed"
	state = DROPSHIP_LANDED
	is_stable = TRUE
