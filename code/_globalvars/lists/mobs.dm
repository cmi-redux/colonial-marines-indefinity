GLOBAL_LIST_EMPTY(clients)							//all clients
GLOBAL_LIST_EMPTY(que_clients)						//all qued clients

#define REAL_CLIENTS length(GLOB.clients) - length(GLOB.que_clients)

GLOBAL_LIST_EMPTY(admins)							//all clients whom are admins
GLOBAL_LIST_EMPTY(que_admins)						//all clients whom are admins qued
GLOBAL_PROTECT(admins)
GLOBAL_PROTECT(que_admins)

GLOBAL_LIST_EMPTY(donaters)
GLOBAL_LIST_EMPTY(que_donaters)
GLOBAL_PROTECT(donaters)
GLOBAL_PROTECT(que_donaters)

GLOBAL_LIST_EMPTY(directory) //all ckeys with associated client

GLOBAL_LIST_EMPTY(player_list) //all mobs **with clients attached**.

GLOBAL_LIST_EMPTY(observer_list) //all /mob/dead/observer

GLOBAL_LIST_EMPTY(new_player_list) //all /mob/dead/new_player, in theory all should have clients and those that don't are in the process of spawning and get deleted when done.

GLOBAL_LIST_EMPTY_TYPED(mob_list, /mob)

GLOBAL_LIST_EMPTY_TYPED(living_mob_list, /mob/living)
GLOBAL_LIST_EMPTY_TYPED(alive_mob_list, /mob)

GLOBAL_LIST_EMPTY_TYPED(dead_mob_list, /mob) // excludes /mob/new_player

GLOBAL_LIST_EMPTY_TYPED(ert_mobs, /mob)

GLOBAL_LIST_EMPTY_TYPED(human_mob_list, /mob/living/carbon/human)
GLOBAL_LIST_EMPTY_TYPED(alive_human_list, /mob/living/carbon/human) // list of alive marines

GLOBAL_LIST_EMPTY_TYPED(xeno_mob_list, /mob/living/carbon/xenomorph)
GLOBAL_LIST_EMPTY_TYPED(living_xeno_list, /mob/living/carbon/xenomorph)
GLOBAL_LIST_EMPTY_TYPED(xeno_cultists, /mob/living/carbon/human)
GLOBAL_LIST_EMPTY_TYPED(player_embryo_list, /obj/item/alien_embryo)

GLOBAL_LIST_EMPTY_TYPED(hellhound_list, /mob/living/carbon/xenomorph/hellhound)
GLOBAL_LIST_EMPTY_TYPED(zombie_list, /mob/living/carbon/human)
GLOBAL_LIST_EMPTY_TYPED(yautja_mob_list, /mob/living/carbon/human)
