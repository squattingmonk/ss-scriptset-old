/*
Filename:           ss_e_equip
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnPlayerEquipItem event hook-in script. Place this script on the
OnPlayerEquipItem event under Module Properties.

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
    if (SS_ENABLE_TAGBASED_SCRIPTING)
    {
        object oObject = GetPCItemLastEquipped();
        if (ss_RunTagBasedScript(oObject, X2_ITEM_EVENT_EQUIP) == 0)
            ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_PLAYER_EQUIP_ITEM);
    }
    else
        ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_PLAYER_EQUIP_ITEM);
}
