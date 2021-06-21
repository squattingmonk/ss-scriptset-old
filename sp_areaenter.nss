/*
Filename:           sp_areaenter
System:             Spawn (area enter event hook-in script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       January 14, 2008
Summary:
This script will run any area spawns when a PC enters.

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
    object oPC = GetEnteringObject();
    object oArea = OBJECT_SELF;

    // Check if the despawn timer has already been created. If not, create.
    if (!GetLocalInt(oArea, SP_AREA_TIMER_ID))
    {
        int nTimerID = ss_CreateTimer(oArea, SP_DESPAWN_TIMER_SCRIPT, SP_DESPAWN_EMPTY_AREA_DELAY);
        SetLocalInt(oArea, SP_AREA_TIMER_ID, nTimerID);
    }


    if (GetIsPC(oPC))
    {
        // Run Area Spawns if they aren't there already.
        if (!GetLocalInt(oArea, SP_AREA_SPAWNS_ACTIVE))
            sp_DoAreaSpawns();

        // Stop the despawn timer
     else ss_StopTimer(GetLocalInt(oArea, SP_AREA_TIMER_ID));
    }
}

