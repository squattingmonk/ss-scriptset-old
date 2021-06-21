/*
Filename:           ss_e_credisturb
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       June 19, 2009
Summary:
OnDisturbed creature event hook-in script. Place this script on the OnDisturbed
event under creature Properties.

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
    ss_RunEventScripts(SS_CREATURE_EVENT_ON_DISTURBED);
}
