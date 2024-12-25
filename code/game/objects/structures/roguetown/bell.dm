/obj/structure/boatbell
	name = "bell"
	desc = "This is the doomspeller of Roguetown."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "bell"
	density = FALSE
	max_integrity = 0
	anchored = TRUE
	var/last_ring
	var/datum/looping_sound/boatloop/soundloop

/obj/structure/boatbell/Initialize()
	soundloop = new(src, FALSE)
	soundloop.start()
	. = ..()

/obj/structure/boatbell/attack_hand(mob/user)
	if(world.time < last_ring + 50)
		return
	user.visible_message(span_info("[user] rings the bell."))
	SSshuttle.moveShuttle("supply", "supply_away", TRUE)
	playsound(src, 'sound/misc/boatbell.ogg', 100, extrarange = 5)
	last_ring = world.time

/obj/structure/boatbell/fluff/attack_hand(mob/user)
	if(world.time < last_ring + 50)
		return
	user.visible_message(span_info("[user] rings the bell."))
	playsound(src, 'sound/misc/boatbell.ogg', 100, extrarange = 5)
	last_ring = world.time

/obj/structure/boatbell/escape
	desc = "This boat spells the doom of Roguetown. The bell being rung will naturally incite panic in everyone, as many fear the fate of many lordless border settlements should they stay."
	var/bribe = 0
	var/bribeprice = 500

/obj/structure/boatbell/escape/Initialize()
	bribeprice = rand(300,700)
	. = ..()


/obj/structure/boatbell/escape/attackby(obj/item/P, mob/user, params)
	if(!user.cmode)
		if(istype(P, /obj/item/roguecoin) || istype(P, /obj/item/roguegem))
			bribe += P.get_real_price()
			qdel(P)
			if(bribe >= bribeprice)
				to_chat(user, span_warning("That should be enough."))
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			return
	..()

/obj/structure/boatbell/escape/attack_hand(mob/user)
	if(world.time < last_ring + 50)
		return
	last_ring = world.time
	user.visible_message(span_info("[user] starts ringing the bell."))
	for(var/i in 1 to rand(1,5))
		playsound(src, 'sound/misc/boatbell.ogg', 100, extrarange = 5)
		if(!do_after(user, 30, target = src))
			return

