/*
Filename:           ss_e_respawn
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnPlayerRespawn event hook-in script. Place this script on the OnPlayerRespawn
event under Module Properties.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Core system include script.
#include "ss_i_core"

void main()
{
    object oPC = GetLastRespawnButtonPresser();
    ss_SetPlayerInt(oPC, SS_PLAYER_STATE, SS_PLAYER_STATE_ALIVE);
    ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_PLAYER_RESPAWN);
}
