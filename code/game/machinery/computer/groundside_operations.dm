/obj/structure/machinery/computer/groundside_operations
	name = "Консоль наблюдения за операцией"
	desc = "This can be used for various important functions."
	icon_state = "comm"
	req_access = list(ACCESS_MARINE_SENIOR)
	unslashable = TRUE
	unacidable = TRUE

	var/obj/structure/machinery/camera/cam = null
	var/datum/squad/current_squad = null

	var/is_announcement_active = TRUE
	var/announcement_title = COMMAND_ANNOUNCE
	var/lz_selection = TRUE
	var/has_squad_overwatch = TRUE

	faction_to_get = FACTION_MARINE

	var/minimap_name = "Marine Tactical Map"
	var/current_mapviewer
	var/list/datum/ui_minimap/minimap = list()

/obj/structure/machinery/computer/groundside_operations/Initialize()
	. = ..()
	link_minimap()

/obj/structure/machinery/computer/groundside_operations/proc/link_minimap()
	set waitfor = FALSE
	WAIT_MAPVIEW_READY
	for(var/i in ALL_MAPVIEW_MAPTYPES)
		var/datum/ui_minimap/new_minimap = SSmapview.get_minimap_ui(faction, i, minimap_name)
		minimap += list("[i]" = new_minimap)

/obj/structure/machinery/computer/groundside_operations/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/groundside_operations/attack_hand(mob/user as mob)
	if(..() || !allowed(user) || inoperable())
		return

	ui_interact(user)

/obj/structure/machinery/computer/groundside_operations/ui_interact(mob/user as mob)
	user.set_interaction(src)

	var/dat = "<head><title>Консоль Наблюдения За Операцией</title></head><body>"
	dat += "<BR><A HREF='?src=\ref[src];operation=announce'>[is_announcement_active ? "Сделать Оповещение" : "*Ожидайте*"]</A>"
	dat += "<BR><A HREF='?src=\ref[src];operation=mapview_ground'>Тактическая Карта Колонии</A>"
	dat += "<BR><A HREF='?src=\ref[src];operation=mapview_ship'>Тактическая Карта Корабля</A>"
	dat += "<BR><hr>"
	var/datum/squad/marine/echo/echo_squad = locate() in SSticker.role_authority.squads
	if(!echo_squad.active && faction == FACTION_MARINE)
		dat += "<BR><A href='?src=\ref[src];operation=activate_echo'>Designate Echo Squad</A>"
		dat += "<BR><hr>"

	if(SSevacuation.ship_operation_stage_status == OPERATION_BRIEFING && lz_selection && SSticker.mode && (isnull(SSticker.mode.active_lz) || isnull(SSticker.mode.active_lz.loc)))
		dat += "<BR>Основная ЗВ <BR><A HREF='?src=\ref[src];operation=selectlz'>Выбрать основную ЗВ</A>"
		dat += "<BR><hr>"

	if(has_squad_overwatch)
		dat += "Отряд: <A href='?src=\ref[src];operation=pick_squad'>[!isnull(current_squad) ? "[current_squad.name]" : "----------"]</A><BR>"
		if(current_squad)
			dat += get_overwatch_info()

	dat += "<BR><A HREF='?src=\ref[user];mach_close=groundside_operations'>Закрыть</A>"
	show_browser(user, dat, name, "groundside_operations", "size=600x700")
	onclose(user, "groundside_operations")

/obj/structure/machinery/computer/groundside_operations/proc/get_overwatch_info()
	var/dat = ""
	dat += {"
	<script type="text/javascript">
		function updateSearch() {
			var filter_text = document.getElementById("filter");
			var filter = filter_text.value.toLowerCase();

			var marine_list = document.getElementById("marine_list");
			var ltr = marine_list.getElementsByTagName("tr");

			for(var i = 0; i < ltr.length; ++i) {
				try {
					var tr = ltr\[i\];
					tr.style.display = '';
					var ltd = tr.getElementsByTagName("td")
					var name = ltd\[0\].innerText.toLowerCase();
					var role = ltd\[1\].innerText.toLowerCase()
					if(name.indexOf(filter) == -1 && role.indexOf(filter) == -1) {
						tr.style.display = 'none';
					}
				} catch(err) {}
			}
		}
	</script>
	"}

	if(!current_squad)
		dat += "No Squad selected!<BR>"
	else
		var/leader_text = ""
		var/spec_text = ""
		var/medic_text = ""
		var/engi_text = ""
		var/smart_text = ""
		var/marine_text = ""
		var/misc_text = ""
		var/living_count = 0
		var/almayer_count = 0
		var/SSD_count = 0
		var/helmetless_count = 0

		for(var/X in current_squad.marines_list)
			if(!X)
				continue //just to be safe
			var/mob_name = "unknown"
			var/mob_state = ""
			var/role = "unknown"
			var/act_sl = ""
			var/area_name = "<b>???</b>"
			var/mob/living/carbon/human/H
			if(ishuman(X))
				H = X
				mob_name = H.real_name
				var/area/A = get_area(H)
				var/turf/M_turf = get_turf(H)
				if(A)
					area_name = sanitize_area(A.name)

				if(H.job)
					role = H.job
				else if(istype(H.wear_id, /obj/item/card/id)) //decapitated marine is mindless,
					var/obj/item/card/id/ID = H.wear_id //we use their ID to get their role.
					if(ID.rank)
						role = ID.rank

				switch(H.stat)
					if(CONSCIOUS)
						mob_state = "Conscious"
						living_count++
					if(UNCONSCIOUS)
						mob_state = "<b>Unconscious</b>"
						living_count++
					else
						continue

				if(!is_ground_level(M_turf.z))
					almayer_count++
					continue

				if(!istype(H.head, /obj/item/clothing/head/helmet/marine))
					helmetless_count++
					continue

				if(!H.key || !H.client)
					SSD_count++
					continue

			var/marine_infos = "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td></tr>"
			var/real_job = GET_DEFAULT_ROLE(role)
			if(real_job in JOB_SQUAD_LEADER_LIST)
				leader_text += marine_infos
			else if(real_job in JOB_SQUAD_SPEC_LIST)
				spec_text += marine_infos
			else if(real_job in JOB_SQUAD_MEDIC_LIST)
				medic_text += marine_infos
			else if(real_job in JOB_SQUAD_ENGI_LIST)
				engi_text += marine_infos
			else if(real_job in JOB_SQUAD_MAIN_SUP_LIST)
				smart_text += marine_infos
			else if(real_job in JOB_SQUAD_NORMAL_LIST)
				marine_text += marine_infos
			else
				misc_text += marine_infos
		dat += "<b>Total: [current_squad.marines_list.len] Deployed</b><BR>"
		dat += "<b>Marines detected: [living_count] ([helmetless_count] no helmet, [SSD_count] SSD, [almayer_count] on Almayer)</b><BR>"
		dat += "<center><b>Search:</b> <input type='text' id='filter' value='' onkeyup='updateSearch();' style='width:300px;'></center>"
		dat += "<table id='marine_list' border='2px' style='width: 100%; border-collapse: collapse;' align='center'><tr>"
		dat += "<th>Name</th><th>Role</th><th>State</th><th>Location</th></tr>"
		dat += leader_text + spec_text + medic_text + engi_text + smart_text + marine_text + misc_text
		dat += "</table>"
	dat += "<br><hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a><br>"
	return dat

/obj/structure/machinery/computer/groundside_operations/proc/mapview(map_to_view)
	if(!Adjacent(current_mapviewer))
		return
	var/datum/ui_minimap/chosed = minimap["[map_to_view]"]
	chosed.tgui_interact(current_mapviewer)

/obj/structure/machinery/computer/groundside_operations/Topic(href, href_list)
	if(..())
		return FALSE

	if(!Adjacent(usr))
		return FALSE

	usr.set_interaction(src)
	switch(href_list["operation"])
		if("mapview_ground")
			current_mapviewer = usr
			mapview("[GROUND_MAP_Z]")
			return

		if("mapview_ship")
			current_mapviewer = usr
			mapview("[SHIP_MAP_Z]")

		if("announce")
			if(usr.client.prefs.muted & MUTE_IC)
				to_chat(usr, SPAN_DANGER("You cannot send Announcements (muted)."))
				return

			if(!is_announcement_active)
				to_chat(usr, SPAN_WARNING("Please allow at least [COOLDOWN_COMM_MESSAGE*0.1] second\s to pass between announcements."))
				return FALSE
			if(usr.faction != faction)
				to_chat(usr, SPAN_WARNING("Access denied."))
				return
			var/input = stripped_multiline_input(usr, "Please write a message to announce to the station crew.", "Priority Announcement", "")
			if(!input || !is_announcement_active || !(usr in view(1,src)))
				return FALSE

			is_announcement_active = FALSE

			var/signed = null
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/id = H.wear_id
				if(istype(id))
					var/paygrade = get_paygrades(id.paygrade, FALSE, H.gender)
					signed = "[paygrade] [id.registered_name]"

			faction_announcement(input, announcement_title, null, faction, signed)
			addtimer(CALLBACK(src, PROC_REF(reactivate_announcement), usr), COOLDOWN_COMM_MESSAGE)
			message_admins("[key_name(usr)] has made a command announcement.")
			log_announcement("[key_name(usr)] has announced the following: [input]")

		if("award")
			print_medal(usr, src)

		if("selectlz")
			if(SSticker.mode.active_lz)
				return
			var/lz_choices = list("lz1", "lz2")
			var/new_lz = tgui_input_list(usr, "Select primary LZ", "LZ Select", lz_choices)
			if(!new_lz)
				return
			if(new_lz == "lz1")
				SSticker.mode.select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1))
			else
				SSticker.mode.select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz2))

		if("pick_squad")
			var/list/squad_list = list()
			for(var/datum/squad/S in SSticker.role_authority.squads)
				if(S.name != "Root" && !S.locked && S.active && S.faction == faction.faction_name)
					squad_list += S.name

			var/name_sel = tgui_input_list(usr, "Which squad would you like to look at?", "Pick Squad", squad_list)
			if(!name_sel)
				return

			var/datum/squad/selected = get_squad_by_name(name_sel)
			if(selected)
				current_squad = selected
			else
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Invalid input. Aborting.")]")

		if("use_cam")
			if(isRemoteControlling(usr))
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Unable to override console camera viewer. Track with camera instead. ")]")
				return

			if(current_squad)
				var/mob/cam_target = locate(href_list["cam_target"])
				var/obj/structure/machinery/camera/new_cam = get_camera_from_target(cam_target)
				if(!new_cam || !new_cam.can_use())
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Searching for helmet cam. No helmet cam found for this marine! Tell your squad to put their helmets on!")]")
				else if(cam && cam == new_cam)//click the camera you're watching a second time to stop watching.
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Stopping helmet cam view of [cam_target].")]")
					usr.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = null
					usr.reset_view(null)
				else if(usr.client.view != world_view_size)
					to_chat(usr, SPAN_WARNING("You're too busy peering through binoculars."))
				else
					if(cam)
						usr.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = new_cam
					usr.reset_view(cam)
					usr.RegisterSignal(cam, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/mob, reset_observer_view_on_deletion))

		if("activate_echo")
			var/reason = strip_html(input(usr, "What is the purpose of Echo Squad?", "Activation Reason"))
			if(!reason)
				return
			if(alert(usr, "Confirm activation of Echo Squad for [reason]", "Confirm Activation", usr.client.auto_lang(LANGUAGE_YES), usr.client.auto_lang(LANGUAGE_NO)) != usr.client.auto_lang(LANGUAGE_YES))
				return
			var/datum/squad/marine/echo/echo_squad = locate() in SSticker.role_authority.squads
			if(!echo_squad)
				visible_message(SPAN_BOLDNOTICE("ERROR: Unable to locate Echo Squad database."))
				return
			echo_squad.engage_squad(TRUE)
			message_admins("[key_name(usr)] activated Echo Squad for '[reason]'.")

		if("refresh")
			attack_hand(usr)

	updateUsrDialog()

/obj/structure/machinery/computer/groundside_operations/proc/reactivate_announcement(mob/user)
	is_announcement_active = TRUE
	updateUsrDialog()

/obj/structure/machinery/computer/groundside_operations/on_unset_interaction(mob/user)
	..()

	if(!isRemoteControlling(user))
		if(cam)
			user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
		cam = null
		user.reset_view(null)

//returns the helmet camera the human is wearing
/obj/structure/machinery/computer/groundside_operations/proc/get_camera_from_target(mob/living/carbon/human/H)
	if(current_squad)
		if(H && istype(H) && istype(H.head, /obj/item/clothing/head/helmet/marine))
			var/obj/item/clothing/head/helmet/marine/helm = H.head
			return helm.camera

/obj/structure/machinery/computer/groundside_operations/upp
	announcement_title = UPP_COMMAND_ANNOUNCE
	lz_selection = FALSE
	has_squad_overwatch = FALSE

	faction_to_get = FACTION_UPP
	minimap_name = "UPP Tactical Map"

/obj/structure/machinery/computer/groundside_operations/clf
	announcement_title = CLF_COMMAND_ANNOUNCE
	lz_selection = FALSE
	has_squad_overwatch = FALSE

	faction_to_get = FACTION_CLF
	minimap_name = "CLF Tactical Map"

/obj/structure/machinery/computer/groundside_operations/pmc
	announcement_title = WY_COMMAND_ANNOUNCE
	lz_selection = FALSE
	has_squad_overwatch = FALSE

	faction_to_get = FACTION_WY
	minimap_name = "WY Tactical Map"
