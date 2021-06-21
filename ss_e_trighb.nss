/*
Filename:           ss_e_trighb
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 16, 2009
Summary:
OnHeartbeat trigger event hook-in script. Place this script on the OnHeartbeat
event under trigger Properties.

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
    ss_RunEventScripts(SS_TRIGGER_EVENT_ON_HEARTBEAT);
}
