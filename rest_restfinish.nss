/*
Filename:           rest_restfinish
System:             Rest (rest finished hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
OnPlayerRestFinished script for the Rest system. If the PC has not been flagged
to not allow spell and feat recovery during rest, this resets the PC's spells
and feats to the values they were at prior to resting. If recovery was allowed,
then the time of this rest recovery is saved for that PC. This also adjusts the
PC's hit points to only heal ss_GetPostRestHealAmount.

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
    int bAllowSpellRecovery = ss_GetAllowSpellRecovery(oPC);
    if (!bAllowSpellRecovery)
        ss_SetAvailableSpellsToSavedValues(oPC);

    int bAllowFeatRecovery = ss_GetAllowFeatRecovery(oPC);
    if (!bAllowFeatRecovery)
        ss_SetAvailableSpellsToSavedValues(oPC);

    if (bAllowSpellRecovery && bAllowFeatRecovery)
        rest_SaveLastRecoveryRestTime(oPC);

    ss_LimitPostRestHeal(oPC, ss_GetPostRestHealAmount(oPC));
}
