/*
Filename:           ss_e_heartbeat
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnHeartbeat event hook-in script. Place this script on the OnHeartbeat event
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
    // Forced time update.
    if (SS_FORCE_CLOCK_UPDATE)
        SetTime(GetTimeHour(), GetTimeMinute(), GetTimeSecond(), GetTimeMillisecond());
    ss_SaveCurrentCalendar();
    ss_RunElapsedTimers();
    ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_HEARTBEAT);
}
