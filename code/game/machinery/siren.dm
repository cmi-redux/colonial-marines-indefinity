/obj/structure/machinery/siren
	name = "Siren"
	desc = "A siren used to play warnings for the colony."
	icon = 'icons/obj/structures/machinery/loudspeaker.dmi'
	icon_state = "loudspeaker"
	density = 0
	anchored = 1
	unacidable = 1
	unslashable = 1
	use_power = 0
	health = 0
	var/message = "ТРЕВОГА, ЧЕРЕЗВУЧАЙНАЯ СИТУАЦИЯ, ВСЕМ ВЫПОЛНЯТЬ АВАРИЙНЫЙ ПРОТОКОЛ"
	var/sound = 'sound/effects/weather_warning.ogg'
	var/siren_lt = "sky_scraper"

/obj/structure/machinery/siren/Initialize()
	. = ..()
	if(siren_lt == "sky_scraper")
		siren_lt = "[siren_lt]_[z]"
	GLOB.siren_objects["[siren_lt]"] += list(src)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/siren/LateInitialize()
	. = ..()
	var/obj/structure/machinery/computer/security_blocker/SB = GLOB.skyscrapers_sec_comps["[z]"]
	SB.sirens += src

/obj/structure/machinery/siren/power_change()
	return

/obj/structure/machinery/siren/proc/siren_warning(msg = "ТРЕВОГА, критическая ситуация, всем выполнять базовые протоколы безопасности.", sound_ch = 'sound/effects/weather_warning.ogg')
	playsound(loc, sound_ch, 80, 0)
	visible_message(SPAN_DANGER("[src] издает сигнал. [msg]."))

/obj/structure/machinery/siren/start_processing()
	if(!machine_processing)
		machine_processing = TRUE
		addToListNoDupe(power_machines, src)

/obj/structure/machinery/siren/stop_processing()
	if(machine_processing)
		machine_processing = FALSE
		processing_machines -= src

/obj/structure/machinery/siren/proc/siren_warning_start(msg, sound_ch = 'sound/effects/weather_warning.ogg')
	if(!msg)
		return
	message = msg
	sound = sound_ch
	start_processing()

/obj/structure/machinery/siren/proc/siren_warning_stop()
	stop_processing()

/obj/structure/machinery/siren/process()
	if(prob(2))
		playsound(loc, sound, 80, 0)
		visible_message(SPAN_DANGER("[src] издает сигнал. [message]."))


/obj/structure/machinery/siren/weather
	name = "Weather Siren"
	desc = "A siren used to play weather warnings for the colony."
	siren_lt = "weather"
