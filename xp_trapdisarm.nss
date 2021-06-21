/*
Filename:           xp_trapdisarm
System:             Experience (OnDisarm event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       June. 24, 2008
Summary:
Placeable, trigger, or door OnDisarm script for the experience system. This
script will award ability XP to a player when he disarms a trap. This XP can
only be gained from this object once per character per server reset.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// XP system include script.
#include "xp_i_main"

void main()
{
    object oPC = GetLastDisarmed();

    if (!GetIsPC(oPC))
        return;

    object oTrapped = OBJECT_SELF;
    object oCreator = GetTrapCreator(oTrapped);

    if (oPC == oCreator)
        return;

    string sPCID = ss_GetPlayerString(oPC, SS_PCID);

    if (!GetLocalInt(oTrapped, XP_DISARMED_PREFIX + sPCID))
    {
        int nDC = GetTrapDisarmDC(oTrapped);
        xp_AwardSkillXP(oPC, nDC, oTrapped);
        SetLocalInt(oTrapped, XP_DISARMED_PREFIX + sPCID, 1);
    }
}
