/*
Filename:           bd_bleedtimer
System:             Bleeding and Death (timer script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 11, 2009
Summary:
Simulates blood loss for a dying player character.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "bd_i_main"

void main()
{
    object oPC = OBJECT_SELF;
    int nPlayerState = ss_GetPlayerInt(oPC, SS_PLAYER_STATE);
    if (nPlayerState != SS_PLAYER_STATE_DYING)
    {
        int nTimerID = GetLocalInt(oPC, BD_BLEED_TIMER_ID);
        DeleteLocalInt(oPC, BD_BLEED_TIMER_ID);
        ss_KillTimer(nTimerID);
    }
    else
    {
        int nCurrentHitPoints = GetCurrentHitPoints(oPC);
        if (nCurrentHitPoints > 0)
        {
            bd_DoPlayerRecovery(oPC);
            return;
        }

        int nLastHitPoints = GetLocalInt(oPC, BD_LAST_HIT_POINTS);
        if (nCurrentHitPoints > nLastHitPoints)
        {
            bd_DoPlayerRecovery(oPC);
            return;
        }

        int nNegativeHPLimit = GetLocalInt(oPC, BD_NEGATIVE_HP_LIMIT);
        if (nCurrentHitPoints > nNegativeHPLimit)
            bd_DoRecoveryCheck(oPC);
        else
        {
            ss_SetPlayerInt(oPC, SS_PLAYER_STATE, SS_PLAYER_STATE_DEAD);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        }
    }
}

