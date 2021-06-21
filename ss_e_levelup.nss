/*
Filename:           ss_e_levelup
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnPlayerLevelUp event hook-in script. Place this script on the OnPlayerLevelUp
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
    object oPC = GetPCLevellingUp();
    if (SS_EXPORT_CHARACTERS_INTERVAL > 0.0)
        ExportSingleCharacter(oPC);
    ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_PLAYER_LEVEL_UP);
}
