/*
Filename:           htf_reststart
System:             Hunger, Thirst, & Fatigue (rest started hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
OnPlayerRestStarted script for the HTF system. This script checks if the PC has
enough fatigue points to perform a quick rest. If so, it adds the appropriate
item to the rest menu.

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
    int nSkipDialog = GetLocalInt(oPC, SS_SKIP_REST_DIALOG);
    if (!nSkipDialog && htf_GetAllowQuickRest(oPC))
        ss_AddRestMenuItem(oPC, HTF_TEXT_QUICK_REST, HTF_QUICK_REST_SCRIPT);
}
