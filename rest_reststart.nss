/*
Filename:           rest_reststart
System:             Rest (rest started hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
OnPlayerRestStarted script for the Rest system. This script determines if the
elapsed time since the PC last rested with recovery. If the elapased time is not
enough, then spell and feat recovery are set to FALSE and the post rest heal
amount is set to 0. If enough time has elapsed then the spell and feat recovery
is not changed from its default value of TRUE, and the post rest heal amount is
set to REST_HP_HEALED_PER_REST_PER_LEVEL times the PC's level.

Based on Edward Beck's HCR2 Rest subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "rest_i_main"

void main()
{
    object oPC = GetLastPCRested();
    int nRemainingTime = rest_RemainingTimeForRecoveryInRest(oPC);
    int nSkipDialog = GetLocalInt(oPC, SS_SKIP_REST_DIALOG);

    if (REST_REQUIRE_TRIGGER_OR_CAMPFIRE)
    {
        object oRestTrigger = GetLocalObject(oPC, REST_TRIGGER);
        object oCampfire = GetNearestObjectByTag(REST_CAMPFIRE, oPC);

        if (GetIsObjectValid(oRestTrigger))
        {
            if (GetLocalInt(oRestTrigger, REST_IGNORE_MINIMUM_REST_TIME))
                nRemainingTime = 0;
            string sFeedback = GetLocalString(oRestTrigger, REST_FEEDBACK);
            if (sFeedback != "" && nSkipDialog)
                SendMessageToPC(oPC, sFeedback);
        }
        else if (!GetIsObjectValid(oCampfire) || GetDistanceBetween(oPC, oCampfire) > 4.0)
        {
            ss_SetAllowRest(oPC, FALSE);
            return;
        }
    }

    if (nRemainingTime != 0)
    {
        if (!nSkipDialog)
        {
            string sWaitTime = FloatToString(nRemainingTime / HoursToSeconds(1), 5, 2);
            string sMessage  = REST_TEXT_RECOVER_WITH_REST_IN + sWaitTime + REST_TEXT_HOURS;
            SendMessageToPC(oPC, sMessage);
        }
        ss_SetAllowSpellRecovery(oPC, FALSE);
        ss_SetAllowFeatRecovery(oPC, FALSE);
        ss_SetPostRestHealAmount(oPC, 0);
    }
    else
    {
        if (nSkipDialog && REST_SLEEP_EFFECTS)
            rest_ApplySleepEffects(oPC);
        if (REST_HP_HEALED_PER_REST_PER_LEVEL > -1)
        {
            int nPostRestHealAmount = REST_HP_HEALED_PER_REST_PER_LEVEL * GetHitDice(oPC);
            ss_SetPostRestHealAmount(oPC, nPostRestHealAmount);
        }
    }
    ss_AddRestMenuItem(oPC, SS_TEXT_REST_MENU_DEFAULT);
}
