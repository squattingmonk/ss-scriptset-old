/*
Filename:           ss_e_plaused
System:             Core (event script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 16, 2009
Summary:
Placeable OnUsed event script. Place this script on the OnUsed event under
Placeable Properties.

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
    ss_RunEventScripts(SS_PLACEABLE_EVENT_ON_USED);
}
