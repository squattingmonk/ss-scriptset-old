/*
Filename:           ss_e_dying
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnPlayerDying event hook-in script. Place this script on the OnPlayerDying event
under Module Properties.

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
    object oPC = GetLastPlayerDying();
    if (ss_GetDatabaseInt(SS_PLAYER_STATE, oPC) != SS_PLAYER_STATE_DEAD)
        ss_SetDatabaseInt(SS_PLAYER_STATE, SS_PLAYER_STATE_DYING, oPC);

    ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_PLAYER_DYING);
}
