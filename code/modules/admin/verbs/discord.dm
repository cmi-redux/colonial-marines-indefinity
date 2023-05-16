/client/proc/discord_panel()
	set category = "Admin.Panels"
	set name = "Discord Player Info"
	set waitfor = FALSE

	if(!check_rights(R_MOD) || !player_data.discord_loaded)
		return

	player_data.discord.show_discord_admin(usr)
