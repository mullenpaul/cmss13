#define ARMOR_LIGHT "armor_light"
#define ARMOR_LIGHT_ON "armor_light_on"
#define ARMOR_SQUAD "armor_squad_overlay"

/obj/item/armor_module
	name = "armor module"
	desc = "A dis-figured armor module, in its prime this would've been a key item in your modular armor... now its just trash."

	var/soft_armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0) // This is here to overwrite code over at objs.dm line 41. Marines don't get funny 200+ bio buff anymore.

	slowdown = 0
	appearance_flags = KEEP_APART|TILE_BOUND

	///Reference to parent modular armor suit.
	var/obj/item/clothing/parent

	///Slot the attachment is able to occupy.
	var/slot
	///Icon sheet of the attachment overlays
	var/attach_icon = null
	///Proc typepath that is called when this is attached to something.
	var/on_attach = PROC_REF(on_attach)
	///Proc typepath that is called when this is detached from something.
	var/on_detach = PROC_REF(on_detach)
	///Proc typepath that is called when this is item is being attached to something. Returns TRUE if it can attach.
	var/can_attach = PROC_REF(can_attach)
	///Pixel shift for the item overlay on the X axis.
	var/pixel_shift_x = 0
	///Pixel shift for the item overlay on the Y axis.
	var/pixel_shift_y = 0
	///Bitfield flags of various features.
	var/attach_features_flags = ATTACH_REMOVABLE|ATTACH_APPLY_ON_MOB
	///Time it takes to attach.
	var/attach_delay = 1.5 SECONDS
	///Time it takes to detach.
	var/detach_delay = 1.5 SECONDS
	///Used for when the mob attach overlay icon is different than icon.
	var/mob_overlay_icon
	///Pixel shift for the mob overlay on the X axis.
	var/mob_pixel_shift_x = 0
	///Pixel shift for the mob overlay on the Y axis.
	var/mob_pixel_shift_y = 0

	///Light modifier for attachment to an armor piece
	var/light_mod = 0

	///Replacement for initial icon that allows for the code to work with multiple variants
	var/base_icon

	///Assoc list that uses the parents type as a key. type = "new_icon_state". This will change the icon state depending on what type the parent is. If the list is empty, or the parent type is not within, it will have no effect.
	var/list/variants_by_parent_type = list()

	///Layer for the attachment to be applied to.
	var/attachment_layer
	///Slot that is required for the action to appear to the equipper. If null the action will appear whenever the item is equiped to a slot.
	var/prefered_slot = SLOT_SUIT_STORE // SLOT_WEAR_SUIT

	///List of slots this attachment has.
	var/list/attachments_by_slot = list()
	///Starting attachments that are spawned with this.
	var/list/starting_attachments = list()

	///Allowed attachment types
	var/list/attachments_allowed = list()

	///The signal for this module if it can toggled
	var/toggle_signal

/obj/item/armor_module/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/attachment, slot, attach_icon, on_attach, on_detach, null, can_attach, pixel_shift_x, pixel_shift_y, attach_features_flags, attach_delay, detach_delay, mob_overlay_icon = mob_overlay_icon, mob_pixel_shift_x = mob_pixel_shift_x, mob_pixel_shift_y = mob_pixel_shift_y, attachment_layer = attachment_layer)
	AddComponent(/datum/component/attachment_handler, attachments_by_slot, attachments_allowed, starting_attachments = starting_attachments)
	update_icon()

/// Called before a module is attached.
/obj/item/armor_module/proc/can_attach(obj/item/attaching_to, mob/user)
	return TRUE

/// Called when the module is added to the armor.
/obj/item/armor_module/proc/on_attach(obj/item/attaching_to, mob/user)
	SEND_SIGNAL(attaching_to, COMSIG_ARMOR_MODULE_ATTACHING, user, src)
	parent = attaching_to
	// parent.set_light_range(parent.light_range + light_mod)
	// parent.hard_armor = parent.hard_armor.attachArmor(hard_armor)
	// parent.soft_armor = parent.soft_armor.attachArmor(soft_armor)
	parent.slowdown += slowdown

	if(CHECK_BITFIELD(attach_features_flags, ATTACH_ACTIVATION))
		RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(handle_actions))
	/*
	base_icon = icon_state
	if(length(variants_by_parent_type))
		for(var/selection in variants_by_parent_type)
			if(istype(parent, selection))
				icon_state = variants_by_parent_type[selection]
				base_icon = variants_by_parent_type[selection]
	*/
	update_icon()

/// Called when the module is removed from the armor.
/obj/item/armor_module/proc/on_detach(obj/item/detaching_from, mob/user)
	SEND_SIGNAL(detaching_from, COMSIG_ARMOR_MODULE_DETACHED, user, src)
	// parent.set_light_range(parent.light_range - light_mod)
	// parent.hard_armor = parent.hard_armor.detachArmor(hard_armor)
	// parent.soft_armor = parent.soft_armor.detachArmor(soft_armor)
	parent.slowdown -= slowdown
	UnregisterSignal(parent, COMSIG_ITEM_EQUIPPED)
	parent = null
	icon_state = initial(icon_state)
	update_icon()

///Adds or removes actions based on whether the parent is in the correct slot.
/obj/item/armor_module/proc/handle_actions(datum/source, mob/user, slot)

/obj/item/armor_module/ui_action_click(mob/user, datum/action/item_action/toggle/action)
	// action.set_toggle(activate(user))

///Called on ui_action_click. Used for activating the module.
/obj/item/armor_module/proc/activate(mob/living/user)
	return

/obj/item/armor_module/armor
	name = "modular armor - armor module"
	icon_state = "sheet-plastic"
	item_state = "sheet-plastic"

	/// The additional armor provided by equipping this piece.
	soft_armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	attachments_allowed = list(
		/obj/item/armor_module
	)

/obj/item/clothing/suit/modular
	name = "Party harness"
	desc = "big modular armour suit"

	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "1"
	item_state = "marine_armor" //Make unique states for Officer & Intel armors.
	starting_attachments = list(
		/obj/item/armor_module/armor
	)


/obj/item/armor_plate
	var/armor_melee = CLOTHING_ARMOR_MEDIUM
	var/armor_bullet = CLOTHING_ARMOR_MEDIUM
	var/armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	var/armor_energy = CLOTHING_ARMOR_NONE
	var/armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	var/armor_bio = CLOTHING_ARMOR_MEDIUM
	var/armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	var/armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	var/movement_compensation = SLOWDOWN_ARMOR_LIGHT

/obj/item/armor_plate/light
	name = "Light Armor Plate"
	icon_state = "sheet-plastic"
	item_state = "sheet-plastic"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/armor_plate/medium
	name = "Medium Armor Plate"
	icon_state = "sheet-metal"
	item_state = "sheet-metal"

/obj/item/armor_plate/heavy
	name = "Heavy Armor Plate"
	icon_state = "sheet-plasteel"
	item_state = "sheet-plasteel"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/harness
	name = "Modular Armor Harness"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "1"
	item_state = "marine_armor" //Make unique states for Officer & Intel armors.
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	blood_overlay_type = "armor"
	storage_slots = 2
	// this needs to be refactored
	light_power = 3
	light_range = 4
	light_system = MOVABLE_LIGHT

	var/atom/movable/marine_light/light_holder

/obj/item/clothing/suit/storage/harness/Initialize(mapload)
	. = ..()
	install_armor_plate(null)
	light_holder = new(src)
	update_icon()

/obj/item/clothing/suit/storage/harness/Destroy()
	QDEL_NULL(light_holder)
	return ..()

/obj/item/clothing/suit/storage/harness/attack_self(mob/user)
	. = ..()
	tgui_interact(user)

/obj/item/clothing/suit/storage/harness/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/armor_plate))
		var/obj/item/armor_plate/plate = W
		install_armor_plate(plate, user)
	else
		. = ..()

/obj/item/clothing/suit/storage/harness/proc/get_armor_plate()
	for(var/obj/content in contents)
		if(istype(content, /obj/item/armor_plate))
			return content
	return

/obj/item/clothing/suit/storage/harness/proc/remove_existing_plate(mob/user)
	armor_melee = 0
	armor_bullet = 0
	armor_laser = 0
	armor_energy = 0
	armor_bomb = 0
	armor_bio = 0
	armor_rad = 0
	armor_internaldamage = 0
	movement_compensation = 0
	var/obj/item/armor_plate/plate = get_armor_plate()
	if(plate)
		plate.forceMove(user.loc)


/obj/item/clothing/suit/storage/harness/proc/install_armor_plate(obj/item/armor_plate/plate, mob/user)
	remove_existing_plate()
	if(!plate)
		return
	armor_melee = plate.armor_melee
	armor_bullet = plate.armor_bullet
	armor_laser = plate.armor_laser
	armor_energy = plate.armor_energy
	armor_bomb = plate.armor_bomb
	armor_bio = plate.armor_bio
	armor_rad = plate.armor_rad
	armor_internaldamage = plate.armor_internaldamage
	movement_compensation = plate.movement_compensation
	user.drop_held_item(plate)
	plate.forceMove(src)
	update_icon()
	return


/obj/item/clothing/suit/storage/harness/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ArmourCustomisation")
		ui.open()

/obj/item/clothing/suit/storage/harness/update_icon(mob/user)
	var/image/I
	overlays.Cut()
	if(HAS_TRAIT(src, ARMOR_LIGHT))
		if(HAS_TRAIT(src, ARMOR_LIGHT_ON))
			I = image('icons/obj/items/clothing/cm_suits.dmi', src, "lamp-on")
		else
			I = image('icons/obj/items/clothing/cm_suits.dmi', src, "lamp-off")
		overlays += I

	if(user)
		user.update_inv_wear_suit()

/obj/item/clothing/suit/storage/harness/turn_light(mob/user, toggle_on)
	. = ..()
	if(. != CHECKS_PASSED)
		return

	set_light_range(initial(light_range))
	set_light_power(floor(initial(light_power) * 0.5))
	set_light_on(toggle_on)

	if(HAS_TRAIT(src, ARMOR_LIGHT))
		if(!HAS_TRAIT(src, ARMOR_LIGHT_ON))
			ADD_TRAIT(src, ARMOR_LIGHT_ON, usr)
		else
			REMOVE_TRAIT(src, ARMOR_LIGHT_ON, usr)
	else
		REMOVE_TRAIT(src, ARMOR_LIGHT_ON, usr)

	light_holder.set_light_flags(LIGHT_ATTACHED)
	light_holder.set_light_range(initial(light_range))
	light_holder.set_light_power(initial(light_power))
	light_holder.set_light_on(toggle_on)

	if(!toggle_on)
		playsound(src, 'sound/handling/click_2.ogg', 50, 1)

	playsound(src, 'sound/handling/suitlight_on.ogg', 50, 1)
	update_icon(user)

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()


/obj/item/clothing/suit/storage/harness/ui_data(mob/user)
	. = list()
	.["traits"] = list()
	.["traits"][ARMOR_LIGHT] = HAS_TRAIT(src, ARMOR_LIGHT)

/obj/item/clothing/suit/storage/harness/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr
	switch(action)
		if ("add_light")
			ADD_TRAIT(src, ARMOR_LIGHT, user)
			update_icon(user)
		if ("remove_light")
			REMOVE_TRAIT(src, ARMOR_LIGHT, user)
			update_icon(user)
		if ("big_storage")
			pockets.storage_slots = 5
			pockets.max_storage_space = 5
		if ("small_storage")
			pockets.storage_slots = 2
			pockets.max_storage_space = 2
		if ("toggle_light")
			turn_light(user, !HAS_TRAIT(src, ARMOR_LIGHT_ON))
		if("remove_armor_plate")
			install_armor_plate(null)
