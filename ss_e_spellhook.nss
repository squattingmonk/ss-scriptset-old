/*
Filename:           ss_e_spellhook
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7, 2009
Summary:
OnSpellHook pseudo-event hook-in script. This script should be set as the
spellhook script in the OnModuleLoad event script for the module.

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
    ss_RunGlobalEventScripts(SS_PSEUDO_EVENT_ON_SPELLHOOK);
}
