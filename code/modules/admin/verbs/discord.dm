/client/proc/discord_panel()
	set category = "Admin.Panels"
	set name = "Discord Player Info"
	set waitfor = FALSE

	if(!check_rights(R_MOD))
		return

	discord.show_discord_admin(usr)