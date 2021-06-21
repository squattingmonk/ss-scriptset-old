/*
Filename:           prr_a_dmtpcrdl
System:             Persistent Reputation & Reaction (prr_dmtool conversation action)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool action script that adjusts the PC's reputation with the NPC by the
low amount set in prr_c_main.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "prr_i_main"

void main()
{
    object oNPC = OBJECT_SELF;
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, PRR_DM_TOOL_CURRENT_TARGET);
    prr_AdjustExternalReputation(oNPC, oPC, - PRR_SHIFT_LOW);
}

