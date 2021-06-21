/*
Filename:           bd_dying
System:             Bleeding and Death (player dying event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 11, 2009
Summary:
OnPlayerDying script for the Bleeding and Death system. It begins PC bleeding.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "bd_i_main"

void main()
{
    object oPC = GetLastPlayerDying();

    // If this is the death area, resurrect the PC and abort.
    if (GetTag(GetArea(oPC)) == BD_DEATH_AREA)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        return;
    }

    if (ss_GetPlayerInt(oPC, SS_PLAYER_STATE) == SS_PLAYER_STATE_DYING)
        bd_BeginPlayerBleeding(oPC);
}
