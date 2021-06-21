/*
Filename:           ss_e_userdefined
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnUserDefined event hook-in script. Place this script on the OnUserDefined event
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
    ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_USER_DEFINED);
}
