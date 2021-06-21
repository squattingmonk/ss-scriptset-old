/*
Filename:           xp_unlock
System:             Experience (OnUnLock event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       June. 23, 2008
Summary:
Door or placeable OnUnLock script for the experience system. This script will
award ability XP to a player when he unlocks the door or placeable. This XP can
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
    object oPC = GetLastUnlocked();

    if (!GetIsPC(oPC))
        return;

    object oUnlocked = OBJECT_SELF;
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    int nDC = GetLockUnlockDC(oUnlocked);

    if (!GetLocalInt(oUnlocked, XP_UNLOCKED_PREFIX + sPCID))
    {
        xp_AwardSkillXP(oPC, nDC, oUnlocked);
        SetLocalInt(oUnlocked, XP_UNLOCKED_PREFIX + sPCID, 1);
    }
}
