#define DEFINE_BITFIELD(_variable, _flags) /datum/bitfield/##_variable { \
	flags = ##_flags; \
	variable = #_variable; \
}

GLOBAL_LIST_EMPTY(bitflag_lists)

#define SET_BITFLAG_LIST(target) \
	do { \
		var/txt_signature = target.Join("-"); \
		if(!GLOB.bitflag_lists[txt_signature]) { \
			var/list/new_bitflag_list = list(); \
			for(var/value in target) { \
				new_bitflag_list["[round(value / 24)]"] |= (1 << (value % 24)); \
			}; \
			GLOB.bitflag_lists[txt_signature] = new_bitflag_list; \
		}; \
		target = GLOB.bitflag_lists[txt_signature]; \
	} while (FALSE)
