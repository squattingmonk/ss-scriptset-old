/*
Filename:           ss_e_trigexit
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 16, 2009
Summary:
OnExit trigger event hook-in script. Place this script on the OnExit event under
trigger Properties.

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
        int nPlayers = GetLocalInt(OBJECT_SELF, SS_PLAYERS_IN_TRIGGER) - 1;
        SetLocalInt(OBJECT_SELF, SS_PLAYERS_IN_TRIGGER, nPlayers);
    }

    ss_RunEventScripts(SS_TRIGGER_EVENT_ON_EXIT);
}
