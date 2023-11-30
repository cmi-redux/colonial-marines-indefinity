/proc/bad_reboot_auth(auth)
	var/msg = !auth ? "no" : "a bad"
	message_admins("world.Reboot() called with [msg] authorization key!")
	log_admin_private("world.Reboot() called with [msg] authorization key!")
	/// Here we rickrolling and nuking that big brain client
	if(istype(usr, /client))
		var/client/big_brain = usr
		big_brain << link("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
		qdel(big_brain)
	else if(istype(usr, /mob))
		var/mob/big_brain = usr
		big_brain.client << link("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
		qdel(big_brain.client)
