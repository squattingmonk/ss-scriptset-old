/*
Filename:           htf_restfinish
System:             Hunger, Thirst, & Fatigue (rest finished hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
OnPlayerRestFinished script for the HTF system. This resets the PC's fatigue
meter and allows him to gain fatigue points from food and drink if it was
previously disallowed. It also ends any effects from alcohol on the PC.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "htf_i_main"

void main()
{
    object oPC = GetLastPCRested();
    int nTimerID = GetLocalInt(oPC, HTF_DRUNK_TIMERID);
    ss_KillTimer(nTimerID);
    DeleteLocalInt(oPC, HTF_DRUNK_TIMERID);
    DeleteLocalFloat(oPC, HTF_CURRENT_ALCOHOL);

    if (ss_GetPostRestHealAmount(oPC) > 0)
    {
        SetLocalFloat(oPC, HTF_CURRENT_FATIGUE, 1.0);
        DeleteLocalInt(oPC, HTF_IS_FATIGUED);
        DeleteLocalInt(oPC, HTF_FATIGUE_SAVE_COUNT);
        DeleteLocalInt(oPC, HTF_FATIGUE_HOUR_COUNT);
    }
}
