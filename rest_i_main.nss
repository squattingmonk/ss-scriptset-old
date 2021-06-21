/*
Filename:           rest_i_main
System:             Rest (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 29, 2009
Summary:
Rest system primary include script. This file holds the functions commonly used
throughout the rest system.

The scripts contained herein are based on those included in the HRC2 Rest system
by Edward Beck, customized for compatibility with Shadows & Silver's needs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Core include script
#include "ss_i_core"

// Rest configuration script
#include "rest_c_main"

// Rest constants definitions script
#include "rest_i_constants"


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ---< rest_SaveLastRecoveryRestTime >---
// ---< rest_i_main >---
// Saves a value derived from the time since the server was started when oPC
// finishes a rest in which his spells and feats were recovered properly. This
// value is used in determining the elapsed time since oPCs last recovery rest
// when he next tries to rest.
// Original function by Edward Beck
void rest_SaveLastRecoveryRestTime(object oPC);

// ---< rest_RemainingTimeForRecoveryInRest >---
// ---< rest_i_main >---
// Returns time in real seconds remaining before recovery in rest is allowed
// according to REST_MINIMUM_RECOVERY_TIME and the time elapsed since oPC last
// recovered during rest.
// Original function by Edward Beck
int rest_RemainingTimeForRecoveryInRest(object oPC);

// ---< rest_ApplySleepEffects >---
// ---< rest_i_main >---
// Fades the screen to black and plays the sleep VFX on oPC.
// Original function by Edward Beck
void rest_ApplySleepEffects(object oPC);

// ---< rest_CheckIfCampfireIsOut >---
// ---< rest_i_main >---
// Checks to see if oCampfire has run out of fuel. If it has, it burns out. If
// not, then a PC has added firewood, so it will check later.
// Original function by Edward Beck
void rest_CheckIfCampfireIsOut(object oCampfire);

// ---< rest_UseFirewood >---
// ---< rest_i_main >---
// Makes a campfire at the location oPC targetted oFirewood. If the target was a
// campfire rather than an empty location, it adds the wood to it, increasing
// the campfire's burn time.
// Original function by Edward Beck
void rest_UseFirewood(object oPC, object oFirewood);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

void rest_SaveLastRecoveryRestTime(object oPC)
{
    int nRestTime = ss_GetSecondsSinceServerStart();
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    ss_SetGlobalInt(sPCID + REST_LAST_PC_REST_TIME, nRestTime);
}

int rest_RemainingTimeForRecoveryInRest(object oPC)
{
    int nCurrentTime = ss_GetSecondsSinceServerStart();
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    int nLastRest = ss_GetGlobalInt(sPCID + REST_LAST_PC_REST_TIME);
    int nElapsedTime = nCurrentTime - nLastRest;

    if (nLastRest > 0 && nElapsedTime < REST_MINIMUM_RECOVERY_TIME)
        return REST_MINIMUM_RECOVERY_TIME - nElapsedTime;
    else
        return 0;
}

void rest_ApplySleepEffects(object oPC)
{
    FadeToBlack(oPC);
    int nRacialType = GetRacialType(oPC);
    if (nRacialType != RACIAL_TYPE_ELF && nRacialType != RACIAL_TYPE_HALFELF)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLEEP), oPC);
    DelayCommand(2.0, FadeFromBlack(oPC));
}

void rest_CheckIfCampfireIsOut(object oCampfire)
{
    int nStartTime = GetLocalInt(oCampfire, REST_CAMPFIRE_START_TIME);
    int nCurrentTime = ss_GetSecondsSinceServerStart();
    int nBurnHours = GetLocalInt(oCampfire, REST_CAMPFIRE_BURN);
    float nBurnTime = IntToFloat(nCurrentTime - nStartTime);
    if (HoursToSeconds(nBurnHours) <= nBurnTime)
        DestroyObject(oCampfire);
    else
        DelayCommand(HoursToSeconds(nBurnHours) - nBurnTime, rest_CheckIfCampfireIsOut(oCampfire));
}

void rest_UseFirewood(object oPC, object oFirewood)
{
    object oTarget = GetItemActivatedTarget();
    if (GetIsObjectValid(oTarget))
    {
        if (GetTag(oTarget) == REST_CAMPFIRE)
        {
            int nBurnHours = GetLocalInt(oTarget, REST_CAMPFIRE_BURN);
            nBurnHours += REST_CAMPFIRE_BURN_TIME;
            SetLocalInt(oTarget, REST_CAMPFIRE_BURN, nBurnHours);
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0));
            FloatingTextStringOnCreature(REST_TEXT_ADD_FIREWOOD, oPC);
            DestroyObject(oFirewood);
        }
        else
            SendMessageToPC(oPC, SS_TEXT_CANNOT_USE_ON_TARGET);
    }
    else
    {
        location lTarget = GetItemActivatedTargetLocation();
        object oCampfire = CreateObject(OBJECT_TYPE_PLACEABLE, REST_CAMPFIRE, lTarget);
        SetLocalInt(oCampfire, REST_CAMPFIRE_BURN, REST_CAMPFIRE_BURN_TIME);
        int nStartTime = ss_GetSecondsSinceServerStart();
        SetLocalInt(oCampfire, REST_CAMPFIRE_START_TIME, nStartTime);
        DelayCommand(HoursToSeconds(3), rest_CheckIfCampfireIsOut(oCampfire));
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0));
        FloatingTextStringOnCreature(REST_TEXT_USE_FIREWOOD, oPC);
        DestroyObject(oFirewood);
    }
}
