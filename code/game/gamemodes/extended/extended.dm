/datum/game_mode/extended
	name = "Extended"
	config_tag = "Extended"
	required_players = 0
	latejoin_larva_drop = 0
	votable = FALSE
	var/research_allocation_interval = 10 MINUTES
	var/next_research_allocation = 0
	taskbar_icon = 'icons/taskbar/gml_colonyrp.png'

/datum/game_mode/announce()
	to_world("<B>The current game mode is - Extended!</B>")

/datum/game_mode/extended/post_setup()
	initialize_post_marine_gear_list()
	for(var/mob/new_player/np in GLOB.new_player_list)
		np.new_player_panel_proc()
	round_time_lobby = world.time
	return ..()

/datum/game_mode/extended/process()
	. = ..()
	if(next_research_allocation < world.time)
		chemical_data.update_credits(chemical_data.research_allocation_amount)
		next_research_allocation = world.time + research_allocation_interval

///////////////////////////
//Checks to see who won///
//////////////////////////
/datum/game_mode/extended/check_win()
	return

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/extended/check_finished()
	if(round_finished)
		return TRUE
	return FALSE

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/extended/declare_completion()
	announce_ending()
	var/musical_track = pick('sound/music/round_end/neutral_hopeful1.ogg','sound/music/round_end/neutral_hopeful2.ogg')
	world << musical_track

	if(SSticker.mode.round_statistics)
		SSticker.mode.round_statistics.game_mode = name
		SSticker.mode.round_statistics.round_length = world.time
		SSticker.mode.round_statistics.end_round_player_population = GLOB.clients.len
		SSticker.mode.round_statistics.log_round_statistics()

	calculate_end_statistics()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()


	return TRUE
