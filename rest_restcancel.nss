/*
Filename:           rest_restcancel
System:             Rest (rest canceled hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
OnPlayerRestCanceled script for the Rest system. If the PC has not been flagged
to skip the cancel rest code, this resets the PC's hit points, spells, and feats
to the values they were at prior to resting.

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
    ss_SetPlayerHitPointsToSavedValue(oPC);
    ss_SetAvailableSpellsToSavedValues(oPC);
    ss_SetAvailableFeatsToSavedValues(oPC);
}
