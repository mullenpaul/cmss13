#define ARMOR_LIGHT "armor_light"
#define ARMOR_LIGHT_ON "armor_light_on"
#define ARMOR_SQUAD "armor_squad_overlay"


/obj/item/armor_plate
	icon_state = "sheet-metal"
	item_state = "sheet-metal"

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
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/armor_plate/medium
	name = "Medium Armor Plate"

/obj/item/armor_plate/heavy
	name = "Heavy Armor Plate"
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
		install_armor_plate(plate)
	else
		. = ..()

/obj/item/clothing/suit/storage/harness/proc/install_armor_plate(obj/item/armor_plate/plate)
	if(!plate)
		armor_melee = 0
		armor_bullet = 0
		armor_laser = 0
		armor_energy = 0
		armor_bomb = 0
		armor_bio = 0
		armor_rad = 0
		armor_internaldamage = 0
		movement_compensation = 0
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
	plate.forceMove(src)


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
