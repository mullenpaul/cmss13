#define HAS_FLAG(variable, flag) ((variable) & (flag))

// better bitfield macros
#define ENABLE_BITFIELD(variable, flag) ((variable) |= (flag))
#define DISABLE_BITFIELD(variable, flag) ((variable) &= ~(flag))
#define CHECK_BITFIELD(variable, flag) ((variable) & (flag))
#define TOGGLE_BITFIELD(variable, flag) ((variable) ^= (flag))

//check if all bitflags specified are present
#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags) (((flagvar) & (flags)) == (flags))

/*
	These defines are specific to the atom/flags_1 bitmask
*/
#define ALL (~0) //For convenience.
#define NONE 0

/* Directions */
///All the cardinal direction bitflags.
#define ALL_CARDINALS (NORTH|SOUTH|EAST|WEST)

// for /datum/var/datum_flags
#define DF_USE_TAG (1<<0)
#define DF_VAR_EDITED (1<<1)
#define DF_ISPROCESSING (1<<2)

// Bitflags for emotes, used in var/emote_type of the emote datum
/// Is the emote audible
#define EMOTE_AUDIBLE (1<<0)
/// Is the emote visible
#define EMOTE_VISIBLE (1<<1)
/// Is it an emote that should be shown regardless of blindness/deafness
#define EMOTE_IMPORTANT (1<<2)
/// Does the emote not have a message?
#define EMOTE_NO_MESSAGE (1<<3)

// Update flags for [/atom/proc/update_appearance]
/// Update the atom's name
#define UPDATE_NAME (1<<0)
/// Update the atom's desc
#define UPDATE_DESC (1<<1)
/// Update the atom's icon state
#define UPDATE_ICON_STATE (1<<2)
/// Update the atom's overlays
#define UPDATE_OVERLAYS (1<<3)
/// Update the atom's greyscaling
#define UPDATE_GREYSCALE (1<<4)
/// Update the atom's smoothing. (More accurately, queue it for an update)
#define UPDATE_SMOOTHING (1<<5)
/// Update the atom's icon
#define UPDATE_ICON (UPDATE_ICON_STATE|UPDATE_OVERLAYS)

/// Should we use the initial icon for display? Mostly used by overlay only objects
#define HTML_USE_INITAL_ICON_1 (1<<16)
