/*
Filename:           ss_e_areaexit
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 16, 2009
Summary:
OnExit area event hook-in script. Place this script on the OnExit event under
Area Properties.

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

    if (GetIsPC(oPC) || GetIsDM(oPC))
    {
        int nPlayers = GetLocalInt(OBJECT_SELF, SS_PLAYERS_IN_AREA) - 1;
        SetLocalInt(OBJECT_SELF, SS_PLAYERS_IN_AREA, nPlayers);
    }

    ss_RunEventScripts(SS_AREA_EVENT_ON_EXIT);
}
