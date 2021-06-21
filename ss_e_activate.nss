/*
Filename:           ss_e_activate
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnActivateItem event hook-in script. Place this script on the OnActivateItem
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
    if (SS_ENABLE_TAGBASED_SCRIPTING)
    {
        object oObject = GetItemActivated();
        if (ss_RunTagBasedScript(oObject, X2_ITEM_EVENT_ACTIVATE) == 0)
            ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_ACTIVATE_ITEM);
    }
    else
        ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_ACTIVATE_ITEM);
}
