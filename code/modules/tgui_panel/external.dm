/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/client/var/datum/tgui_panel/tgui_panel

/**
 * tgui panel / chat troubleshooting verb
 */
/client/verb/fix_tgui_panel()
	set name = "Fix chat"
	set category = "OOC.Fix"
	log_tgui(src, "Started fixing.", context = "verb/fix_tgui_panel")

	nuke_chat()

	// Failed to fix
	if(alert(src, "Did that work?", "", auto_lang(LANGUAGE_YES), auto_lang(LANGUAGE_NO)) != auto_lang(LANGUAGE_YES))
		winset(src, "output", "on-show=&is-disabled=0&is-visible=1")
		winset(src, "browseroutput", "is-disabled=1;is-visible=0")
		log_tgui(src, "Failed to fix.", context = "verb/fix_tgui_panel")

/client/proc/nuke_chat()
	// Catch all solution (kick the whole thing in the pants)
	winset(src, "output", "on-show=&is-disabled=0&is-visible=1")
	winset(src, "browseroutput", "is-disabled=1;is-visible=0")
	if(!tgui_panel || !istype(tgui_panel))
		log_tgui(src, "tgui_panel datum is missing",
			context = "verb/fix_tgui_panel")
		tgui_panel = new(src)
	tgui_panel.initialize(force = TRUE)
	// Force show the panel to see if there are any errors
	winset(src, "output", "is-disabled=1&is-visible=0")
	winset(src, "browseroutput", "is-disabled=0;is-visible=1")

/client/verb/refresh_tgui()
	set name = "Refresh TGUI"
	set category = "OOC.Fix"

	for(var/window_id in tgui_windows)
		var/datum/tgui_window/window = tgui_windows[window_id]
		window.reinitialize()
