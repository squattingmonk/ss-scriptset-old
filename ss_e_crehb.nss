/*
Filename:           ss_e_crehb
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       May 4, 2009
Summary:
OnHeartbeat creature event hook-in script. Place this script on the OnHeartbeat
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
    // If not runnning normal or better AI, then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW)
        return;

    ss_RunEventScripts(SS_CREATURE_EVENT_ON_HEARTBEAT);
}
