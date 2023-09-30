//Gun delay effect
#define WEAPON_DELAY_NO_EFFECT 0
#define WEAPON_DELAY_NO_FIRE 1
#define WEAPON_DELAY_SCATTER 2
#define WEAPON_DELAY_ACCURACY 4
#define WEAPON_DELAY_SCATTER_AND_ACCURACY 6

//Gun delay
#define WEAPON_GUARANTEED_DELAY 0.1

//Gun modificato -health
#define WEAPON_DAMAGE_SMALL 1
#define WEAPON_DAMAGE_MEDIUM 2
#define WEAPON_DAMAGE_BIG 4
#define WEAPON_DAMAGE_VERY_BIG 6
#define WEAPON_DAMAGE_ALOT 10

//Gun health
#define WEAPON_DURABILITY_SMALL 1000
#define WEAPON_DURABILITY_MEDIUM 2000
#define WEAPON_DURABILITY_BIG 4000
#define WEAPON_DURABILITY_HEAVY 8000

#define WEAPON_FAILURE_SMALL 0.1
#define WEAPON_FAILURE_MEDIUM 0.2
#define WEAPON_FAILURE_BIG 0.3
#define WEAPON_FAILURE_HEAVY 0.5

//Gun defines for gun related thing. More in the projectile folder.
#define GUN_CAN_POINTBLANK			(1<<0)
#define GUN_TRIGGER_SAFETY			(1<<1)
#define GUN_UNUSUAL_DESIGN			(1<<2)
#define GUN_SILENCED				(1<<3)
#define GUN_AUTOMATIC				(1<<4)
#define GUN_INTERNAL_MAG			(1<<5)
#define GUN_AUTO_EJECTOR			(1<<6)
#define GUN_AMMO_COUNTER			(1<<7)
#define GUN_BURST_FIRING			(1<<8)
#define GUN_FLASHLIGHT_ON			(1<<9)
#define GUN_WY_RESTRICTED			(1<<10)
#define GUN_CO_RESTRICTED			(1<<11)
#define GUN_SPECIALIST				(1<<12)
#define GUN_WIELDED_FIRING_ONLY		(1<<13)
#define GUN_HAS_FULL_AUTO			(1<<14)
#define GUN_FULL_AUTO_ON			(1<<15)
#define GUN_ONE_HAND_WIELDED		(1<<16)
#define GUN_ANTIQUE 				(1<<17)
#define GUN_RECOIL_BUILDUP			(1<<18)
#define GUN_SUPPORT_PLATFORM		(1<<19)
#define GUN_FULL_AUTO_ONLY			(1<<20)
#define GUN_NO_DESCRIPTION			(1<<21)

//Gun mounted flags
#define GUN_MOUNTING				(1<<0)
#define GUN_MOUNTED					(1<<1) //only mounted using
#define GUN_CAN_OVERRIDE_MOUNTED	(1<<2) //only mounted using

//Gun attachable related flags
#define ATTACH_REMOVABLE		(1<<0)
#define ATTACH_ACTIVATION		(1<<1)
#define ATTACH_PROJECTILE		(1<<2) // for attachments that fire bullets
#define ATTACH_RELOADABLE		(1<<3)
#define ATTACH_WEAPON			(1<<4) // is a weapon that fires stuff
#define ATTACH_IGNORE_EMPTY		(1<<5) // This attachment should override ignore if it is empty
#define ATTACH_MELEE			(1<<6) // This attachment should activate if you attack() with it attached.
#define ATTACH_WIELD_OVERRIDE	(1<<7) // Override for attachies so you can fire them with a single hand . ONLY FOR PROJECTILES!!

//Slowdowns for guns
#define SLOWDOWN_ADS_NONE				0
#define SLOWDOWN_ADS_QUICK_MINUS		0.15
#define SLOWDOWN_ADS_QUICK				0.35
#define SLOWDOWN_ADS_VERSATILE			0.5
#define SLOWDOWN_ADS_SHOTGUN			0.75
#define SLOWDOWN_ADS_RIFLE				1
#define SLOWDOWN_ADS_SCOPE				1.2
#define SLOWDOWN_AMT_GREENFIRE			1.5
#define SLOWDOWN_ADS_LMG				1.7
#define SLOWDOWN_ADS_INCINERATOR		1.75
#define SLOWDOWN_ADS_SPECIALIST			1.8
#define SLOWDOWN_ADS_MINISCOPE_DYNAMIC	2
#define SLOWDOWN_ADS_SUPERWEAPON		2.75

//Wield delays, in milliseconds. 10 is 1 second
#define WIELD_DELAY_NONE			0
#define WIELD_DELAY_MIN				1
#define WIELD_DELAY_VERY_FAST		2
#define WIELD_DELAY_FAST			4
#define WIELD_DELAY_NORMAL			6
#define WIELD_DELAY_SLOW			8
#define WIELD_DELAY_VERY_SLOW		10
#define WIELD_DELAY_HORRIBLE		12

#define GUN_LOW_AMMO_PERCENTAGE 0.25 // A gun filled with this percentage of it's total ammo or lower is considered to have low ammo

//Gun categories, currently used for firing while dualwielding.
#define GUN_CATEGORY_HANDGUN 1
#define GUN_CATEGORY_SMG 2
#define GUN_CATEGORY_RIFLE 3
#define GUN_CATEGORY_SHOTGUN 4
#define GUN_CATEGORY_HEAVY 5
#define GUN_CATEGORY_MOUNTED 6

#define FIRE_DELAY_GROUP_SHOTGUN "fdg_shtgn"
#define AMMO_MAX_ROUNDS 1000

#define TASER_MODE_P "precision"
#define TASER_MODE_F "free"

#define USES_STREAKS (1<<0)
#define DANGEROUS_TO_ONEHAND_LEVER (1<<1)
#define MOVES_WHEN_LEVERING (1<<2)

// Common
#define AMMO_BAND_COLOR_AP "#1F951F"
#define AMMO_BAND_COLOR_HIGH_VELOCITY "#8998A3"
#define AMMO_BAND_COLOR_TRAINING "#FFFFFF"
// Uncommon
#define AMMO_BAND_COLOR_HOLOTARGETING "#276A74"
#define AMMO_BAND_COLOR_RUBBER "#556696"
#define AMMO_BAND_COLOR_HOLLOWPOINT "#BA5D00"
#define AMMO_BAND_COLOR_INCENDIARY "#9C2219"
#define AMMO_BAND_COLOR_IMPACT "#7866FF"
// Defcons
#define AMMO_BAND_COLOR_PENETRATING "#67819C"
#define AMMO_BAND_COLOR_TOXIN "#98104d"
#define AMMO_BAND_COLOR_CLUSTER "#432ee5"
#define AMMO_BAND_COLOR_MIXED "#0faf7c"
// CO
#define AMMO_BAND_COLOR_SUPER "#C1811C"
#define AMMO_BAND_COLOR_HIGH_IMPACT "#00CDEA"
// Rare
#define AMMO_BAND_COLOR_HEAP "#9C9A19"
#define AMMO_BAND_COLOR_EXPLOSIVE "#19499C"
#define AMMO_BAND_COLOR_LIGHT_EXPLOSIVE "#7D199C"

// Ammo bands, but for revolvers. Or handfuls?

// M44
#define REVOLVER_TIP_COLOR_MARKSMAN "#FF744F"
#define REVOLVER_TIP_COLOR_HEAVY AMMO_BAND_COLOR_IMPACT
// Mateba
#define REVOLVER_TIP_COLOR_HIGH_IMPACT AMMO_BAND_COLOR_HIGH_IMPACT
#define REVOLVER_TIP_COLOR_AP AMMO_BAND_COLOR_AP
#define REVOLVER_TIP_COLOR_EXPLOSIVE AMMO_BAND_COLOR_EXPLOSIVE
// Upgrades
#define REVOLVER_TIP_COLOR_INCENDIARY AMMO_BAND_COLOR_INCENDIARY
#define REVOLVER_TIP_COLOR_PENETRATING AMMO_BAND_COLOR_PENETRATING
#define REVOLVER_TIP_COLOR_TOXIN AMMO_BAND_COLOR_TOXIN

#define GUN_FIREMODE_SEMIAUTO "semi-auto fire mode"
#define GUN_FIREMODE_BURSTFIRE "burst-fire mode"
#define GUN_FIREMODE_AUTOMATIC "automatic fire mode"

//autofire component fire callback return flags
#define AUTOFIRE_CONTINUE (1<<0)
#define AUTOFIRE_SUCCESS (1<<1)

///Base CO special weapons options
#define CO_GUNS list(CO_GUN_MATEBA, CO_GUN_MATEBA_SPECIAL, CO_GUN_DEAGLE)

///Council CO special weapons options
#define COUNCIL_CO_GUNS list(CO_GUN_MATEBA_COUNCIL, CO_GUN_DEAGLE_COUNCIL)

#define CO_GUN_MATEBA "Mateba"
#define CO_GUN_MATEBA_SPECIAL "Mateba Special"
#define CO_GUN_DEAGLE "Desert Eagle"
#define CO_GUN_MATEBA_COUNCIL "Colonel's Mateba"
#define CO_GUN_DEAGLE_COUNCIL "Golden Desert Eagle"

//							AMMO CALIBERS ALL
#define CALIBER_380			list(".380" = 9.02)
#define CALIBER_38			list(".38" = 9.02)
#define CALIBER_22			list(".22" = 5.66)
#define CALIBER_32ACP		list("32ACP" = 7.94)
#define CALIBER_7_62X38MM	list("7.62x38mm" = 7.91)
#define CALIBER_7_62X39MM	list("7.62x39mm" = 7.9)
#define CALIBER_5_56X45MM	list("5.56x45mm" = 5.7)
#define CALIBER_5_45X39MM	list("5.45x39mm" = 5.62)
#define CALIBER_6_5MM		list("6.5mm" = 6.72)
#define CALIBER_7_62MM		list("7.62mm" = 7.85)
#define CALIBER_8MM			list("8mm" = 8.1)
#define CALIBER_7_62X25MM	list("7.62x25mm" = 7.84)
#define CALIBER_5_7X28MM	list("5.7x28mm" = 5.7)
#define CALIBER_10X99MM		list("10x99mm" = 12.9)
#define CALIBER_7_62X54MM	list("7.62x54mm" = 7.94)
#define CALIBER_8G			list("8g" = 8.8)
#define CALIBER_20G			list("20g" = 20)
#define CALIBER_24G			list("24g" = 24)
//							MARINES USING
#define CALIBER_45_70		list("45-70" = 11.6)
#define CALIBER_7_62X51MM	list("7.62x51mm" = 7.92)
#define CALIBER_9MM			list("9mm" = 9.2)
#define CALIBER_45			list(".45" = 11.5)
#define CALIBER_50			list(".50" = 13)
#define CALIBER_44			list(".44" = 10.9)
#define CALIBER_357			list(".357" = 9.07)
#define CALIBER_454			list(".454" = 11.54)
#define CALIBER_455			list(".455" = 11.55)
#define CALIBER_10X24MM		list("10x24mm" = 10.6)
#define CALIBER_10X20MM		list("10x20mm" = 19.2)
#define CALIBER_12G			list("12g" = 12)
#define CALIBER_4_6X30MM	list("4.6x30mm" = 4.65)
#define CALIBER_7X45MM		list("7x45mm" = 7.7)

#define MARINES_AMMO_LIST_TO_GEN list(CALIBER_10X24MM, CALIBER_10X20MM, CALIBER_12G, CALIBER_7_62X51MM, CALIBER_7X45MM, CALIBER_4_6X30MM, CALIBER_9MM, CALIBER_45, CALIBER_50, CALIBER_44, CALIBER_357, CALIBER_454, CALIBER_455, CALIBER_45_70)
