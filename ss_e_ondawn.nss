/*
Filename:           ss_e_ondawn
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 6, 2009
Summary:
OnDawn pseudo-event hook-in script.

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
    ss_RunGlobalEventScripts(SS_PSEUDO_EVENT_ON_DAWN);
}
