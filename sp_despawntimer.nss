/*
Filename:           sp_despawntimer
System:             Spawn System (timer script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       March 11, 2009
Summary:

This is the despawn timer script. When executed, it will remove all spawns
from the area.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Spawn system core include script.
#include "sp_i_main"

void main()
{
    object oArea = OBJECT_SELF;

    // Timer scripts are executed once they start and after the interval.
    // This is to disable the first running as soon as the timer is started.
    if (!GetLocalInt(oArea, SP_EXECUTE_TIMER))
    {
        SetLocalInt(oArea, SP_EXECUTE_TIMER, TRUE);
        return;
    }

    sp_DoAreaDeSpawns(oArea);
    SetLocalInt(oArea, SP_EXECUTE_TIMER, FALSE);
    ss_StopTimer(GetLocalInt(oArea, SP_AREA_TIMER_ID));
}
