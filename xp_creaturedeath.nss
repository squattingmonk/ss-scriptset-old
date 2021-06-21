/*
Filename:           xp_creaturedeath
System:             Experience (creature death event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Apr. 29, 2008
Summary:
Creature OnDeath script for the experience system. This will give combat XP to
the party when they kill the caller. To modify how much XP it gives, set any of
the following variables on the creature:

VarName            Type    Value       Description
XP_NO_XP           int     1           The creature gives no XP to its killers.
XP_MODIFIER_COMBAT float   -1.0 - *    A number to multiply the XP given by the creature. If -1.0, the creature gives no XP.
XP_BONUS_COMBAT    int     *           A number to add to the total XP given by the creature (positive or negative).
                                       If this is used in combination with XP_MODIFIER = -1.0, the creature
                                       will give this much XP instead of basing the award on its CR.

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
    object oCreature = OBJECT_SELF;
    if (!GetLocalInt(oCreature, XP_NO_XP))
        xp_AwardKillXP(oCreature, GetLastKiller());
}
