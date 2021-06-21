/*
Filename:           bd_i_main
System:             Bleeding and Death  (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       March. 09, 2009
Summary:
Bleeding and Death system primary include script. This file holds the functions
commonly used throughout the Bleeding and Death system.

Many of the scripts contained herein are based on those included in the HRC2
systems by Edward Beck, customized for Shadows & Silver's needs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "g_i_generic"
#include "bd_c_main"
#include "bd_i_constants"

/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ---< bd_BeginPlayerBleeding >---
// ---< bd_i_main >---
// Creates and starts a timer to track the bleeding of oPC.
void bd_BeginPlayerBleeding(object oPC);

// ---< bd_DoPlayerRecovery >---
// ---< bd_i_main >---
// Makes oPC recover from a dying state. This returns him to 0 HP, gives him
// BD_RECOVERY_HIT_POINTS_PER_LEVEL HP per level, and sets his player state to
// SS_PLAYER_STATE_ALIVE.
void bd_DoPlayerRecovery(object oPC);

// ---< bd_DoBleedDamage >---
// ---< bd_i_main >---
// Does bleed damage to oPC.
void bd_DoBleedDamage(object oPC);

// ---< bd_DoRecoveryCheck >---
// ---< bd_i_main >---
// Checks to see if oPC will recover while dying. Depending on the check, the PC
// may keep bleeding, recover, or have nothing happen.
void bd_DoRecoveryCheck(object oPC);

// ---< bd_DoMiraculousRecoveryCheck >---
// ---< bd_i_main >---
// Checks to see if the player will miraculously recover from death.
int bd_DoMiraculousRecoveryCheck(object oPC);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

void bd_BeginPlayerBleeding(object oPC)
{
    int nCurrentHitPoints = GetCurrentHitPoints(oPC);
    SetLocalInt(oPC, BD_LAST_HIT_POINTS, nCurrentHitPoints);

    int nTimerID = ss_CreateTimer(oPC, BD_BLEED_TIMER_SCRIPT, BD_BLEED_DELAY);
    SetLocalInt(oPC, BD_BLEED_TIMER_ID, nTimerID);

    int nNegativeHPLimit = GetMaxHitPoints(oPC) / BD_NEGATIVE_HP_LIMIT_DIVISOR;

    if (nNegativeHPLimit > BD_DEATH_RANGE_MIN)
        nNegativeHPLimit = BD_DEATH_RANGE_MIN;
    else if (nNegativeHPLimit < BD_DEATH_RANGE_MAX)
        nNegativeHPLimit = BD_DEATH_RANGE_MAX;

    SetLocalInt(oPC, BD_NEGATIVE_HP_LIMIT, nNegativeHPLimit);
    ss_StartTimer(nTimerID);
    // TODO: Make monsters stop attacking player?
}

void bd_DoPlayerRecovery(object oPC)
{
    int nCurrentHitPoints = GetCurrentHitPoints(oPC);
    if (nCurrentHitPoints <= 0)
    {
        int nRecoveryBonus = BD_RECOVERY_HIT_POINTS_PER_LEVEL * GetHitDice(oPC);
        effect eHeal = EffectHeal((0 - nCurrentHitPoints) + nRecoveryBonus);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
    }
    ss_SetPlayerInt(oPC, SS_PLAYER_STATE, SS_PLAYER_STATE_ALIVE);
    // TODO: Make monsters go hostile to PC again?
}

void bd_DoBleedDamage(object oPC)
{
    int nCurrentHitPoints = GetCurrentHitPoints(oPC);
    SetLocalInt(oPC, BD_LAST_HIT_POINTS, nCurrentHitPoints);
    switch(d6())
    {
        case 1: PlayVoiceChat(VOICE_CHAT_HELP, oPC); break;
        case 2: PlayVoiceChat(VOICE_CHAT_PAIN1, oPC); break;
        case 3: PlayVoiceChat(VOICE_CHAT_PAIN2, oPC); break;
        case 4: PlayVoiceChat(VOICE_CHAT_PAIN3, oPC); break;
        case 5: PlayVoiceChat(VOICE_CHAT_HEALME, oPC); break;
        case 6: PlayVoiceChat(VOICE_CHAT_NEARDEATH, oPC); break;
    }
    SendMessageToPC(oPC, BD_TEXT_WOUNDS_BLEED);
    effect eBleedDamage = EffectDamage(BD_BLEED_DAMAGE, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBleedDamage, oPC);
}


void bd_DoRecoveryCheck(object oPC)
{
    int nPlayerState = ss_GetPlayerInt(oPC, SS_PLAYER_STATE);
    if (nPlayerState == SS_PLAYER_STATE_DYING)
    {
        int nRecoveryCheck = d100();
        if (nRecoveryCheck >= (100 - BD_RECOVERY_CHANCE))
        {
            bd_DoPlayerRecovery(oPC);
            SendMessageToPC(oPC,  BD_TEXT_RECOVERED_FROM_DYING);
        }
        else if (nRecoveryCheck >= (100 - BD_RECOVERY_CHANCE - BD_BLEED_CHANCE))
            bd_DoBleedDamage(oPC);
    }
}

void bd_BeginRespawnTimer(object oPC)
{
    int nTimerID = ss_CreateTimer(oPC, BD_RESPAWN_TIMER_SCRIPT, BD_SECONDS_TO_LINGER_AFTER_DEATH);
    SetLocalInt(oPC, BD_RESPAWN_TIMER_ID, nTimerID);
    ss_StartTimer(nTimerID);
}

int bd_DoMiraculousRecoveryCheck(object oPC)
{
    int nLevelBonus = GetHitDice(oPC) * BD_MIRACULOUS_RECOVERY_LEVEL_BONUS;
    int nConstitutionBonus = GetAbilityScore(oPC, ABILITY_CONSTITUTION) + BD_MIRACULOUS_RECOVERY_CONSTITUTION_BONUS;
    int nPreviousRecoveries = ss_GetPlayerInt(oPC, BD_PREVIOUS_MIRACULOUS_RECOVERIES);
    int nPreviousRecoveryPenalty = nPreviousRecoveries * BD_MIRACULOUS_RECOVERY_PREVIOUS_RECOVERY_PENALTY;
    int nRecoveryCheck = d100() + nLevelBonus + nConstitutionBonus - nPreviousRecoveryPenalty;

    if (nRecoveryCheck >= (100 - BD_MIRACULOUS_RECOVERY_CHANCE))
    {
        bd_DoPlayerRecovery(oPC);
        SendMessageToPC(oPC, BD_TEXT_MIRACULOUS_RECOVERY);
        ss_SetPlayerInt(oPC, BD_PREVIOUS_MIRACULOUS_RECOVERIES, nPreviousRecoveries + 1);
        return TRUE;
    }
    else
        return FALSE;
}

void bd_JumpToDeathArea(object oPC)
{
    object oWP = GetObjectByTag(BD_DEATH_WAYPOINT);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
    ss_RemoveEffects(oPC);
    ClearAllActions();
    AssignCommand(oPC, JumpToObject(oWP));
}

void bd_DoRespawn(object oPC)
{
    if (!bd_DoMiraculousRecoveryCheck(oPC))
    {
        bd_JumpToDeathArea(oPC);
    }

    DeleteLocalInt(oPC, BD_RESPAWN_TIMER_RUNS);
}

// void main() {}
