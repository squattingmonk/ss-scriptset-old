/*
Filename:           bd_death
System:             Bleeding and Death (player death event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 11, 2009
Summary:
OnPlayerDeath script for the Bleeding and Death system. It pops up the death GUI.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "bd_i_main"

void main()
{
    object oPC = GetLastPlayerDied();

    // If something else has set the player's state to alive, abort.
    if (ss_GetPlayerInt(oPC, SS_PLAYER_STATE) != SS_PLAYER_STATE_DEAD)
        return;

    // If this is the death area, resurrect the PC and abort.
    if (GetTag(GetArea(oPC)) == BD_DEATH_AREA)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        return;
    }

    PopUpDeathGUIPanel(oPC, TRUE, TRUE, 1, BD_TEXT_DEATH_GUI_MESSAGE);
    bd_BeginRespawnTimer(oPC);
}
