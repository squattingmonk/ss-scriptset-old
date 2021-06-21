/*
Filename:           ss_e_creattack
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       June 19, 2009
Summary:
OnPhysicalAttacked creature event hook-in script. Place this script on the
OnPhysicalAttacked event under creature Properties.

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
    ss_RunEventScripts(SS_CREATURE_EVENT_ON_PHYSICAL_ATTACKED);
}
