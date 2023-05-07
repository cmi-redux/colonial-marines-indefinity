/datum/pass_flags_container
	var/flags_pass = NO_FLAGS

	var/flags_can_pass_all = NO_FLAGS // Use for objects that are not ON_BORDER or for general pass characteristics of an atom
	var/flags_can_pass_front = NO_FLAGS // Relevant mainly for ON_BORDER atoms with the BlockedPassDirs() proc
	var/flags_can_pass_behind = NO_FLAGS // Relevant mainly for ON_BORDER atoms with the BlockedExitDirs() proc
