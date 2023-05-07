//Ammo defines for gun/projectile related things.

//Headshot overlay icoc states used for suicide and battlefield executions.
#define HEADSHOT_OVERLAY_LIGHT "light_headshot"
#define HEADSHOT_OVERLAY_MEDIUM "medium_headshot"
#define HEADSHOT_OVERLAY_HEAVY "heavy_headshot"

#define AMMO_EXPLOSIVE 			(1<<0)
#define AMMO_ACIDIC 			(1<<1)
#define AMMO_XENO				(1<<2)
#define AMMO_LASER				(1<<3)
#define AMMO_ENERGY 			(1<<4)
#define AMMO_ROCKET				(1<<5)
#define AMMO_SNIPER				(1<<6)
#define AMMO_ANTISTRUCT			(1<<7) // Primarily for railgun but can be implemented for other projectiles that are for antitank and antistructure (wall/machine)
#define AMMO_SKIPS_ALIENS 		(1<<8)
#define AMMO_IGNORE_ARMOR		(1<<9)
#define AMMO_IGNORE_RESIST		(1<<10)
#define AMMO_BALLISTIC			(1<<11)
#define AMMO_IGNORE_COVER		(1<<12)
#define AMMO_SCANS_NEARBY		(1<<13) //ammo that is scanning stuff nearby - VERY resource intensive
#define AMMO_STOPPED_BY_COVER	(1<<14)
#define AMMO_SPECIAL_EMBED		(1<<15)
#define AMMO_STRIKES_SURFACE	(1<<16) // If the projectile hits a dense turf it'll do on_hit_turf on the turf just in front of the turf instead of on the turf itself
#define AMMO_HITS_TARGET_TURF	(1<<17) // Whether or not the bullet hits the target that was clicked or if it keeps travelling
#define AMMO_ALWAYS_FF			(1<<18)
#define AMMO_HOMING				(1<<19) // If the bullet target is a mob, it will correct its trajectory toward the mob.
#define AMMO_NO_DEFLECT			(1<<20) // Can't be deflected
#define AMMO_MP					(1<<21) //Can only hit people with criminal status
#define AMMO_FLAME				(1<<22) // Handles sentry flamers glob

//Special flags for custom ammo
#define CUSTOM_AMMO_EXPLOSION	(1<<0)
#define CUSTOM_AMMO_PROXIMITY	(1<<1)
#define CUSTOM_AMMO_SMOKE		(1<<2)
#define CUSTOM_AMMO_EFFECT		(1<<3)
#define CUSTOM_AMMO_ON_HIT		(1<<4)
#define CUSTOM_AMMO_ON_SHOT		(1<<5)
#define CUSTOM_AMMO_CONTROL		(1<<6)
#define CUSTOM_AMMO_AUTO_TARGET	(1<<7)
#define CUSTOM_AMMO_PENETRATION	(1<<8)
#define CUSTOM_AMMO_IFF			(1<<9)
#define CUSTOM_AMMO_FLAK		(1<<10)

/// Projectile is shrpanel which allow it to skip some collisions
#define PROJECTILE_SHRAPNEL		(1<<0)
/// Apply additional effects upon hitting clicked target
#define PROJECTILE_BULLSEYE		(1<<1)

//Ammo magazine defines, for flags_magazine
#define AMMUNITION_REFILLABLE				(1<<0)
#define AMMUNITION_HANDFUL					(1<<1)
#define AMMUNITION_HANDFUL_BOX				(1<<2) //for dump_ammo_to(), boxes of handfuls like shotgun shell boxes
#define AMMUNITION_HIDE_AMMO				(1<<3)
#define AMMUNITION_CANNOT_REMOVE_BULLETS	(1<<4)

/// 1 % per 1 tile per 1 normalcy
#define FALLOFF_PER_TILE 0.01
#define FALLOFF_DISTANCE_POWER 1.4
