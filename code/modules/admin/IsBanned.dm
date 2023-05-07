#ifndef OVERRIDE_BAN_SYSTEM
//Blocks an attempt to connect before even creating our client datum thing.
/world/IsBanned(key, address, computer_id, type, real_bans_only=FALSE)
	var/ckey = ckey(key)

	// This is added siliently. Thanks to MSO for this fix. You will see it when/if we go OS
	if(type == "world")
		return ..() //shunt world topic banchecks to purely to byond's internal ban system

	var/client/C = GLOB.directory[ckey]
	if(C && ckey == C.ckey && computer_id == C.computer_id && address == C.address)
		return //don't recheck connected clients.

	//Guest Checking
	if(IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins("Failed Login: [key] - Guests not allowed")
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	//Population Cap Checking
	var/extreme_popcap = CONFIG_GET(number/extreme_popcap)
	if(!real_bans_only && !C && extreme_popcap && !admin_datums[ckey])
		var/popcap_value = GLOB.clients.len
		if(popcap_value >= extreme_popcap)
			if(!CONFIG_GET(flag/byond_member_bypass_popcap) || !world.IsSubscribed(ckey, "BYOND"))
				log_access("Failed Login: [key] - Population cap reached")
				message_admins("Failed Login: [src] - POPCAPPED")
				return list("reason"="POP CAPPED", "desc"="\nReason: Server is pop capped at the moment at [CONFIG_GET(number/extreme_popcap)] players. Attempt reconnection in 2-3 minutes, queuing system offline.")

	//Mode joining
	if(!real_bans_only && !C && locked_conect && !admin_datums[ckey])
		if(locked_conect > 0)
			log_access("Failed Login: [key] - Server locked for players")
			message_admins("Failed Login: [key] - Server locked for players")
			return list("reason"="Server not accept conection", "desc"= "\n Server not accept conection. Still wait start, if this is bug, ask head staff.")

	WAIT_DB_READY
	if(admin_datums[ckey] && (admin_datums[ckey].rights & R_MOD))
		return ..()

	var/datum/entity/player/P = get_player_from_key(ckey)

	//check if the IP address is a known TOR node
	if(CONFIG_GET(flag/ToRban) && ToRban_isbanned(address))
		log_access("Failed Login: [src] - Banned: ToR")
		message_admins("Failed Login: [src] - Banned: ToR")
		return list("reason"="Using ToR", "desc"="\nReason: The network you are using to connect has been banned.\nIf you believe this is a mistake, please request help at [CONFIG_GET(string/banappeals)]")

	// wait for database to be ready

	. = P.check_ban(computer_id, address)
	if(.)
		return .

	return ..() //default pager ban stuff


#endif
