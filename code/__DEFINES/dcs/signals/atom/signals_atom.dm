/// From /atom/proc/Decorate
#define COMSIG_ATOM_DECORATED "atom_decorated"

///from base of atom/setDir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"

/// generally called before temporary non-parallel animate()s on the atom (animation_duration)
#define COMSIG_ATOM_TEMPORARY_ANIMATION_START "atom_temp_animate_start"

#define COMSIG_ATOM_DBLCLICK_SHIFT_MIDDLE "atom_dblclick_shift_middle"
#define COMSIG_ATOM_DBLCLICK_CTRL_SHIFT "atom_dblclick_ctrl_shift"
#define COMSIG_ATOM_DBLCLICK_CTRL_MIDDLE "atom_dblclick_ctrl_middle"
#define COMSIG_ATOM_DBLCLICK_MIDDLE "atom_dblclick_middle"
#define COMSIG_ATOM_DBLCLICK_SHIFT "atom_dblclick_shift"
#define COMSIG_ATOM_DBLCLICK_ALT "atom_dblclick_alt"
#define COMSIG_ATOM_DBLCLICK_CTRL "atom_dblclick_ctrl"

///called when an atom starts orbiting another atom: (atom)
#define COMSIG_ATOM_ORBIT_BEGIN "atom_orbit_begin"
///called when an atom stops orbiting another atom: (atom)
#define COMSIG_ATOM_ORBIT_STOP "atom_orbit_stop"

///from /atom/hitby(): (atom/movable/AM)
#define COMSIG_ATOM_HITBY "atom_hitby"

///from /turf/ChangeTurf
#define COMSIG_ATOM_TURF_CHANGE "movable_turf_change"

//from atom/set_light(): (l_range, l_power, l_color)
#define COMSIG_ATOM_SET_LIGHT "atom_set_light"

///Called right before the atom changes the value of light_range to a different one, from base atom/set_light_range(): (new_range)
#define COMSIG_ATOM_SET_LIGHT_RANGE "atom_set_light_range"
///Called right before the atom changes the value of light_power to a different one, from base atom/set_light_power(): (new_power)
#define COMSIG_ATOM_SET_LIGHT_POWER "atom_set_light_power"
///Called right before the atom changes the value of light_color to a different one, from base atom/set_light_color(): (new_color)
#define COMSIG_ATOM_SET_LIGHT_COLOR "atom_set_light_color"
///Called right before the atom changes the value of light_on to a different one, from base atom/set_light_on(): (new_value)
#define COMSIG_ATOM_SET_LIGHT_ON "atom_set_light_on"
///Called right before the atom changes the value of light_flags to a different one, from base atom/set_light_flags(): (new_value)
#define COMSIG_ATOM_SET_LIGHT_FLAGS "atom_set_light_flags"

///Called right after the atom changes the value of light_flags to a different one, from base of [/atom/proc/set_light_flags]: (old_flags)
#define COMSIG_ATOM_OFF_LIGHT "atom_off_light"

///from base of atom/set_opacity(): (new_opacity)
#define COMSIG_ATOM_SET_OPACITY "atom_set_opacity"

///When the transform or an atom is varedited through vv topic.
#define COMSIG_ATOM_VV_MODIFY_TRANSFORM "atom_vv_modify_transform"

///from base of atom/Entered(): (atom/movable/arrived, atom/old_loc, list/atom/old_locs)
#define COMSIG_ATOM_ENTERED "atom_entered"
/// Sent from the atom that just Entered src. From base of atom/Entered(): (/atom/destination, atom/old_loc, list/atom/old_locs)
#define COMSIG_ATOM_ENTERING "atom_entering"
///from base of atom/Exit(): (/atom/movable/leaving, direction)
#define COMSIG_ATOM_EXIT "atom_exit"
	#define COMPONENT_ATOM_BLOCK_EXIT (1<<0)
///from base of atom/Exited(): (atom/movable/gone, direction)
#define COMSIG_ATOM_EXITED "atom_exited"
