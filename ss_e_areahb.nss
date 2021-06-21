/*
Filename:           ss_e_areahb
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 16, 2009
Summary:
OnHeartbeat area event hook-in script. Place this script on the OnHeartbeat
event under Area Properties.

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
    ss_RunEventScripts(SS_AREA_EVENT_ON_HEARTBEAT);
}
