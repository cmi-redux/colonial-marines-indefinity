/datum/job/uscm/squad
	supervisors = "the acting squad leader"
	selection_class = "job_marine"
	total_positions = 8
	spawn_positions = 8
	allow_additional = TRUE
	balance_formulas = list("misc", BALANCE_FORMULA_FIELD)

/datum/job/uscm/squad/generate_entry_message(mob/living/carbon/human/current_human)
	if(current_human.assigned_squad)
		entry_message_intro = "You are a [title]!<br>You have been assigned to: <b><font size=3 color=[current_human.assigned_squad.equipment_color]>[lowertext(current_human.assigned_squad.name)] squad</font></b>."
	return ..()

/datum/job/uscm/squad/generate_entry_conditions(mob/living/carbon/human/current_human)
	..()
	if(!Check_WO() || !Check_Crash())
		current_human.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW) //Start hungry for the default marine.

/datum/timelock/squad
	name = "Squad Roles"

/datum/timelock/squad/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_SQUAD_ROLES_LIST
