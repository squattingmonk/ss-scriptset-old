/*
Filename:           htf_death
System:             Hunger, Thirst, & Fatigue (player death event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
OnPlayerDeath script for the HTF system. This script will destroy stored values
for HTF meters.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// HTF system include script.
#include "htf_i_main"

void main()
{
    object oPC = GetLastPlayerDied();
    int nTimerID = GetLocalInt(oPC, HTF_DRUNK_TIMERID);
    ss_KillTimer(nTimerID);

    DeleteLocalFloat(oPC, HTF_CURRENT_HUNGER);
    DeleteLocalFloat(oPC, HTF_CURRENT_THIRST);
    DeleteLocalFloat(oPC, HTF_CURRENT_FATIGUE);
    DeleteLocalFloat(oPC, HTF_CURRENT_ALCOHOL);

    DeleteLocalInt(oPC, HTF_DRUNK_TIMERID);
    DeleteLocalInt(oPC, HTF_IS_HUNGRY);
    DeleteLocalInt(oPC, HTF_IS_THIRSTY);
    DeleteLocalInt(oPC, HTF_IS_FATIGUED);
}
