/*
Filename:           ss_e_clientleave
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnClientLeave event hook-in script. Place this script on the OnClientLeave event
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
    object oPC = GetExitingObject();

    if (GetLocalInt(oPC, SS_LOGIN_BOOT))
        return;

    if (GetIsPC(oPC))
    {
        int nPlayerCount = ss_GetGlobalInt(SS_PLAYER_COUNT);
        ss_SetGlobalInt(SS_PLAYER_COUNT, nPlayerCount - 1);
        ss_SaveHitPoints(oPC);
        ss_SavePCLocation(oPC);
        ss_SetPCLoggedIn(oPC, FALSE);
    }

    ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_CLIENT_ENTER);
}
