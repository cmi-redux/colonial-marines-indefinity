/datum/job/upp/squad
	supervisors = "the acting squad leader"
	selection_class = "job_marine"
	total_positions = 8
	spawn_positions = 8
	allow_additional = TRUE
	balance_formulas = list("misc", BALANCE_FORMULA_FIELD)

/datum/job/upp/squad/generate_entry_message(mob/living/carbon/human/current_human)
	if(current_human.assigned_squad)
		entry_message_intro = "You are a [title]!<br>You have been assigned to: <b><font size=3 color=[current_human.assigned_squad.equipment_color]>[lowertext(current_human.assigned_squad.name)] squad</font></b>."
	return ..()
