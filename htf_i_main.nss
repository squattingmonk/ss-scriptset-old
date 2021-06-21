/*
Filename:           htf_i_main
System:             Hunger, Thirst, & Fatigue  (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
Hunger, Thirst, & Fatigue system primary include script. This file holds the
functions commonly used throughout the HTF system.

The scripts contained herein are based on those included in the HRC2 HTF systems
by Edward Beck, customized for compatibility with Shadows & Silver's needs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Generic include script
#include "g_i_generic"

// Rest configuration script
#include "htf_c_main"

// Rest constants definitions script
#include "htf_i_constants"


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ---< htf_InitialCheck >---
// ---< htf_i_main >---
// Performs the initial hunger, thirst, and fatigue checks on oPC, initializing
// the HTF timers on him. This is called OnClientEnter.
void htf_InitialCheck(object oPC);

// ---< htf_DisplayInfoBars >---
// ---< htf_i_main >---
// Displays the HTF info bars for oPC if he hasn't turned them off.
void htf_DisplayInfoBars(object oPC);

// ---< htf_DoHungerFortitudeCheck >---
// ---< htf_i_main >---
// Makes oPC make a fortitude check of 10 + each previous hunger check. If he
// fails, he loses 10 fatigue points.
void htf_DoHungerFortitudeCheck(object oPC);

// ---< htf_DoThirstFortitudeCheck >---
// ---< htf_i_main >---
// Makes oPC make a fortitude check of 10 + each previous thirst check. If he
// fails, he loses 10 fatigue points.
void htf_DoThirstFortitudeCheck(object oPC);

// ---< htf_DoFatigueFortitudeCheck >---
// ---< htf_i_main >---
// Makes oPC make a fortitude check of 10 + each previous fatigue check. If he
// fails, he is unable to gain fatigue points until he rests.
void htf_DoFatigueFortitudeCheck(object oPC);

// ---< htf_PerformChecks >---
// ---< htf_i_main >---
// Calculates oPC's hourly HTF drain and performs hunger, thirst, fatigue, and
// alcohol checks.
void htf_PerformChecks(object oPC);

// ---< htf_ApplyHungerBonus >---
// ---< htf_i_main >---
// Applies any hunger bonus effects stored in oItem's variables to oPC, also
// adding it as a fatigue bonus as long as he hasn't had fatigue gain disabled.
void htf_ApplyHungerBonus(object oPC, object oItem);

// ---< htf_ApplyThirstBonus >---
// ---< htf_i_main >---
// Applies any thirst bonus effects stored in oItem's variables to oPC, also
// adding it as a fatigue bonus as long as he hasn't had fatigue gain disabled.
void htf_ApplyThirstBonus(object oPC, object oItem);

// ---< htf_ApplyFatigueBonus >---
// ---< htf_i_main >---
// Applies any fatigue bonus effects stored in oItem's variables to oPC.
void htf_ApplyFatigueBonus(object oPC, object oItem);

// ---< htf_ApplyOtherFoodEffects >---
// ---< htf_i_main >---
// Applies any feedback, poison, disease, sleep, or hit point effects stored in
// oItem's variables to oPC.
void htf_ApplyOtherFoodEffects(object oPC, object oItem);

// ---< htf_ApplyAlchoholEffects >---
// ---< htf_i_main >---
// Applies any alcohol effects stored in oItem's variables to oPC.
void htf_ApplyAlchoholEffects(object oPC, object oItem);

// ---< htf_ConsumeFoodItem >---
// ---< htf_i_main >---
// Makes oPC consume oItem, applying any effects on it to oPC.
void htf_ConsumeFoodItem(object oPC, object oItem);

// ---< htf_DoDrunkenAntics >---
// ---< htf_i_main >---
// Makes oPC perform random drunken actions. This is called by htf_drunktimer.
void htf_DoDrunkenAntics(object oPC);

// ---< htf_FillCanteen >---
// ---< htf_i_main >---
// Fills oPC's canteen oCanteen at oSource, replenishing its charges and gaining
// all of oSource's effects.
void htf_FillCanteen(object oPC, object oCanteen, object oSource);

// ---< htf_EmptyCanteen >---
// ---< htf_i_main >---
// Empties oCanteen, depleting its charges.
void htf_EmptyCanteen(object oCanteen);

// ---< htf_UseCanteen >---
// ---< htf_i_main >---
// Fires when oPC uses oCanteen. If the canteen is targetted at oPC, it will
// make him take a drink if there are still charges left. If he targets it at a
// placeable, it will fill the canteen, treating the placeable as the source. If
// there is no valid target and he is inside an HTF trigger, it will fill the
// canteen, treating the trigger as the source.
void htf_UseCanteen(object oPC, object oCanteen);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

void htf_InitialCheck(object oPC)
{
    if (!GetLocalInt(oPC, HTF_IS_THIRSTY) && GetLocalFloat(oPC, HTF_CURRENT_THIRST) == 0.0)
        SetLocalFloat(oPC, HTF_CURRENT_THIRST, 1.0);
    if (!GetLocalInt(oPC, HTF_IS_HUNGRY) && GetLocalFloat(oPC, HTF_CURRENT_HUNGER) == 0.0)
        SetLocalFloat(oPC, HTF_CURRENT_HUNGER, 1.0);
    if (!GetLocalInt(oPC, HTF_IS_FATIGUED) && GetLocalFloat(oPC, HTF_CURRENT_FATIGUE) == 0.0)
        SetLocalFloat(oPC, HTF_CURRENT_FATIGUE, 1.0);

    int nTimerID = ss_CreateTimer(oPC, HTF_TIMER_SCRIPT, HoursToSeconds(1));
    ss_StartTimer(nTimerID);

}

void htf_DisplayInfoBars(object oPC)
{
    if (!ss_GetPlayerInt(oPC, HTF_SUPPRESS_INFO_BARS))
    {
        int nThirstCount  = FloatToInt(GetLocalFloat(oPC, HTF_CURRENT_THIRST) * 100.0);
        int nHungerCount  = FloatToInt(GetLocalFloat(oPC, HTF_CURRENT_HUNGER) * 100.0);
        int nFatigueCount = FloatToInt(GetLocalFloat(oPC, HTF_CURRENT_FATIGUE) * 100.0);

        // Do hunger bars
        string sGreenBar  = ss_GetStringColored(GetSubString(HTF_INFO_BAR, 0, nHungerCount), COLOR_GREEN);
        string sRedBar    = ss_GetStringColored(GetSubString(HTF_INFO_BAR, nHungerCount, 100 -  nHungerCount), COLOR_RED);
        SendMessageToPC(oPC, HTF_TEXT_HUNGER + sGreenBar + sRedBar);

        // Do thirst bars
        sGreenBar = ss_GetStringColored(GetSubString(HTF_INFO_BAR, 0, nThirstCount), COLOR_GREEN);
        sRedBar   = ss_GetStringColored(GetSubString(HTF_INFO_BAR, nThirstCount, 100 -  nThirstCount), COLOR_RED);
        SendMessageToPC(oPC, HTF_TEXT_THIRST + sGreenBar + sRedBar);

        // Do fatigue bars
        sGreenBar = ss_GetStringColored(GetSubString(HTF_INFO_BAR, 0, nFatigueCount), COLOR_GREEN);
        sRedBar   = ss_GetStringColored(GetSubString(HTF_INFO_BAR, nFatigueCount, 100 -  nFatigueCount), COLOR_RED);
        SendMessageToPC(oPC, HTF_TEXT_FATIGUE + sGreenBar + sRedBar);
    }
}

void htf_DoHungerFortitudeCheck(object oPC)
{
    SetLocalInt(oPC, HTF_IS_HUNGRY, TRUE);
    int nHungerSaveCount = GetLocalInt(oPC, HTF_HUNGER_SAVE_COUNT);
    SendMessageToPC(oPC, HTF_TEXT_HUNGER_SAVE);
    if (!FortitudeSave(oPC, nHungerSaveCount + 10))
    {
        float fFatigue = GetLocalFloat(oPC, HTF_CURRENT_FATIGUE);
        ss_SetPlayerFloat(oPC, HTF_CURRENT_FATIGUE, fFatigue - 0.10);
    }
    SetLocalInt(oPC, HTF_HUNGER_SAVE_COUNT, nHungerSaveCount + 1);
}

void htf_DoThirstFortitudeCheck(object oPC)
{
    SetLocalInt(oPC, HTF_IS_THIRSTY, TRUE);
    int nThirstSaveCount = GetLocalInt(oPC, HTF_THIRST_SAVE_COUNT);
    SendMessageToPC(oPC, HTF_TEXT_THIRST_SAVE);
    if (!FortitudeSave(oPC, nThirstSaveCount + 10))
    {
        float fFatigue = GetLocalFloat(oPC, HTF_CURRENT_FATIGUE);
        ss_SetPlayerFloat(oPC, HTF_CURRENT_FATIGUE, fFatigue - 0.10);
    }
    SetLocalInt(oPC, HTF_THIRST_SAVE_COUNT, nThirstSaveCount + 1);
}

void htf_DoFatigueFortitudeCheck(object oPC)
{
    SetLocalInt(oPC, HTF_IS_FATIGUED, TRUE);
    int nFatigueSaveCount = GetLocalInt(oPC, HTF_FATIGUE_SAVE_COUNT);
    int nFatigueHours = GetLocalInt(oPC, HTF_FATIGUE_HOUR_COUNT);
    SendMessageToPC(oPC, HTF_TEXT_FATIGUE_SAVE);
    if (!FortitudeSave(oPC, nFatigueSaveCount + 10))
        SetLocalInt(oPC, HTF_DISABLE_FATIGUE_GAIN, TRUE);
    SetLocalInt(oPC, HTF_FATIGUE_SAVE_COUNT, nFatigueSaveCount + 1);
    SetLocalInt(oPC, HTF_FATIGUE_HOUR_COUNT, nFatigueHours + 1);
}

void htf_PerformChecks(object oPC)
{
    // If the player is dead, cancel alcohol timer and abort
    if (ss_GetPlayerInt(oPC, SS_PLAYER_STATE) == SS_PLAYER_STATE_DEAD)
    {
        DeleteLocalFloat(oPC, HTF_CURRENT_ALCOHOL);
        int nTimerID = GetLocalInt(oPC, HTF_DRUNK_TIMERID);
        ss_KillTimer(nTimerID);
        DeleteLocalInt(oPC, HTF_DRUNK_TIMERID);
        return;
    }

    int nConScore = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
    float fHungerDrop  = 1.0 / (HTF_BASE_HUNGER_HOURS + nConScore);
    float fThirstDrop  = 1.0 / (HTF_BASE_THIRST_HOURS + nConScore);
    float fFatigueDrop = 1.0 / (HTF_BASE_FATIGUE_HOURS + nConScore);
    int ad = 26 - nConScore;
    ad = (ad <= 0 ? 1 : ad);
    float fAlcoholDrop = 2.0 / ad;

    float fCurrentHunger = GetLocalFloat(oPC, HTF_CURRENT_HUNGER);
    if (fCurrentHunger > 0.0)
        fCurrentHunger = fCurrentHunger - fHungerDrop;
    if (fCurrentHunger < 0.0)
        fCurrentHunger = 0.0;

    float fCurrentThirst = GetLocalFloat(oPC, HTF_CURRENT_THIRST);
    if (fCurrentThirst > 0.0)
        fCurrentThirst = fCurrentThirst - fThirstDrop;
    if (fCurrentThirst < 0.0)
        fCurrentThirst = 0.0;

    float fCurrentFatigue = GetLocalFloat(oPC, HTF_CURRENT_FATIGUE);
    if (fCurrentFatigue > 0.0)
        fCurrentFatigue = fCurrentFatigue - fFatigueDrop;
    if (fCurrentFatigue < 0.0)
        fCurrentFatigue = 0.0;

    float fCurrentAlcohol = GetLocalFloat(oPC, HTF_CURRENT_ALCOHOL);
    if (fCurrentAlcohol > 0.0)
        fCurrentAlcohol = fCurrentAlcohol - fAlcoholDrop;
    if (fCurrentAlcohol < 0.0)
        fCurrentAlcohol = 0.0;
    if (fCurrentAlcohol < 0.4)
    {
        int nTimerID = GetLocalInt(oPC, HTF_DRUNK_TIMERID);
        ss_KillTimer(nTimerID);
        DeleteLocalInt(oPC, HTF_DRUNK_TIMERID);
    }

    SetLocalFloat(oPC, HTF_CURRENT_HUNGER, fCurrentHunger);
    SetLocalFloat(oPC, HTF_CURRENT_THIRST, fCurrentThirst);
    SetLocalFloat(oPC, HTF_CURRENT_FATIGUE, fCurrentFatigue);
    SetLocalFloat(oPC, HTF_CURRENT_ALCOHOL, fCurrentAlcohol);
    if (HTF_DISPLAY_INFO_BARS)
        htf_DisplayInfoBars(oPC);

    if (fCurrentHunger == 0.0)
        htf_DoHungerFortitudeCheck(oPC);
    else
        DeleteLocalInt(oPC, HTF_HUNGER_SAVE_COUNT);

    if (fCurrentThirst == 0.0)
        htf_DoThirstFortitudeCheck(oPC);
    else
        DeleteLocalInt(oPC, HTF_THIRST_SAVE_COUNT);

    fCurrentFatigue = GetLocalFloat(oPC, HTF_CURRENT_FATIGUE);
    int nFatigueHours = GetLocalInt(oPC, HTF_FATIGUE_HOUR_COUNT);
    if (fCurrentFatigue <= 0.0 || nFatigueHours > (HTF_BASE_FATIGUE_HOURS + nConScore))
        htf_DoFatigueFortitudeCheck(oPC);
    else
    {
        DeleteLocalInt(oPC, HTF_FATIGUE_SAVE_COUNT);
        SetLocalInt(oPC, HTF_FATIGUE_HOUR_COUNT, nFatigueHours + 1);
    }
}

void htf_ApplyHungerBonus(object oPC, object oItem)
{
    float fHungerValue = GetLocalFloat(oItem, HTF_HUNGER_VALUE) / 300.0;
    if (fHungerValue > 0.0)
    {
        float fCurrentHunger = GetLocalFloat(oPC, HTF_CURRENT_HUNGER) + fHungerValue;
        if (fCurrentHunger > 1.0)
        {
            fCurrentHunger = 1.0;
            SendMessageToPC(oPC, HTF_TEXT_NOT_HUNGRY);
        }
        SetLocalFloat(oPC, HTF_CURRENT_HUNGER, fCurrentHunger);
        DeleteLocalInt(oPC, HTF_IS_HUNGRY);

        if (!GetLocalInt(oPC, HTF_DISABLE_FATIGUE_GAIN))
        {
            float fCurrentFatigue = GetLocalFloat(oPC, HTF_CURRENT_FATIGUE) + fHungerValue;
            if (fCurrentFatigue > 1.0)
                fCurrentFatigue = 1.0;

            SetLocalFloat(oPC, HTF_CURRENT_FATIGUE, fCurrentFatigue);
            DeleteLocalInt(oPC, HTF_IS_FATIGUED);
        }
    }
}

void htf_ApplyThirstBonus(object oPC, object oItem)
{
    float fThirstValue = GetLocalFloat(oItem, HTF_THIRST_VALUE) / 100.0;
    if (fThirstValue > 0.0)
    {
        float fCurrentThirst = GetLocalFloat(oPC, HTF_CURRENT_THIRST) + fThirstValue;
        if (fCurrentThirst > 1.0)
        {
            fCurrentThirst = 1.0;
            SendMessageToPC(oPC, HTF_TEXT_NOT_THIRSTY);
        }

        SetLocalFloat(oPC, HTF_CURRENT_THIRST, fCurrentThirst);
        DeleteLocalInt(oPC, HTF_IS_THIRSTY);
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));

        if (!GetLocalInt(oPC, HTF_DISABLE_FATIGUE_GAIN))
        {
            float fCurrentFatigue = GetLocalFloat(oPC, HTF_CURRENT_FATIGUE) + fThirstValue;
            if (fCurrentFatigue > 1.0)
                fCurrentFatigue = 1.0;

            SetLocalFloat(oPC, HTF_CURRENT_FATIGUE, fCurrentFatigue);
            DeleteLocalInt(oPC, HTF_IS_FATIGUED);
        }
    }
}

void htf_ApplyFatigueBonus(object oPC, object oItem)
{
    float fFatigueValue = GetLocalFloat(oItem, HTF_FATIGUE_VALUE) / 600.0;
    if (fFatigueValue > 0.0)
    {
        float fCurrentFatigue = GetLocalFloat(oPC, HTF_CURRENT_FATIGUE) + fFatigueValue;
        if (fCurrentFatigue > 1.0)
            fCurrentFatigue = 1.0;

        SetLocalFloat(oPC, HTF_CURRENT_FATIGUE, fCurrentFatigue);
        DeleteLocalInt(oPC, HTF_IS_FATIGUED);
    }
}

void htf_ApplyOtherFoodEffects(object oPC, object oItem)
{
    float fDelay = GetLocalFloat(oItem, HTF_DELAY);
    string fFeedback = GetLocalString(oItem, HTF_FEEDBACK);
    if (fFeedback != "")
        DelayCommand(fDelay, SendMessageToPC(oPC, fFeedback));

    int nPoison = GetLocalInt(oItem, HTF_POISON);
    if (nPoison)
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(nPoison), oPC));

    int nDisease = GetLocalInt(oItem, HTF_DISEASE);
    if (nDisease)
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisease(nDisease), oPC));

    if (GetLocalInt(oItem, HTF_SLEEP))
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSleep(), oPC,  HoursToSeconds(1) / 4));

    int nHPbonus = GetLocalInt(oItem, HTF_HPBONUS);
    if (nHPbonus && GetCurrentHitPoints(oPC) == GetMaxHitPoints(oPC))
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nHPbonus), oPC, HoursToSeconds(1) / 2);
    else if (nHPbonus)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHPbonus), oPC);
}

void htf_ApplyAlchoholEffects(object oPC, object oItem)
{
    float fAlcoholValue = GetLocalFloat(oItem, HTF_ALCOHOL_VALUE) / 200.0;
    if (fAlcoholValue > 0.0)
    {
        float fCurrentAlcohol = GetLocalFloat(oPC, HTF_CURRENT_ALCOHOL) + fAlcoholValue;
        if (fCurrentAlcohol > 1.0)
            fCurrentAlcohol = 1.0;
        SetLocalFloat(oPC, HTF_CURRENT_ALCOHOL, fCurrentAlcohol);
        if (GetLocalInt(oPC, HTF_DRUNK_TIMERID) == 0 && fCurrentAlcohol >= 0.4)
        {
            int nTimerID = ss_CreateTimer(oPC, HTF_DRUNK_TIMER_SCRIPT, 150.0);
            SetLocalInt(oPC, HTF_DRUNK_TIMERID, nTimerID);
            ss_StartTimer(nTimerID);
        }

        int nDropRate = 26 - GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
        if (nDropRate <= 0)
            nDropRate = 1;
        float fDuration = (HoursToSeconds(1) * ((fCurrentAlcohol * nDropRate))) / 2;
        if (fCurrentAlcohol == 1.0)
        {
            if (!FortitudeSave(oPC, 15))
            {
                if (GetRacialType(oPC) == RACIAL_TYPE_ELF || GetRacialType(oPC) == RACIAL_TYPE_HALFELF)
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 120.0);
                else
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSleep(), oPC, 120.0);
                AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_PASSED_OUT));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, 120.0);
            }
        }
        int DC = FloatToInt(fCurrentAlcohol * 17);
        int nFortSave = GetFortitudeSavingThrow(oPC);
        if (fCurrentAlcohol >= 0.95 && nFortSave + d20() < DC)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellFailure(25), oPC, fDuration);
        if (fCurrentAlcohol >= 0.85 && nFortSave + d20() < DC)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(20), oPC, fDuration);
        if (fCurrentAlcohol >= 0.75 && nFortSave + d20() < DC)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_STRENGTH, 1), oPC, fDuration);
        if (fCurrentAlcohol >= 0.65 && nFortSave + d20() < DC)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CHARISMA, 1), oPC, fDuration);
        if (fCurrentAlcohol >= 0.55 && nFortSave + d20() < DC)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_DEXTERITY, 1), oPC, fDuration);
        if (fCurrentAlcohol >= 0.45 && nFortSave + d20() < DC)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1), oPC, fDuration);
        if (fCurrentAlcohol >= 0.35 && nFortSave + d20() < DC)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_WISDOM, 1), oPC, fDuration);
        if (fCurrentAlcohol >= 0.25 && nFortSave + d20() < DC)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(1), oPC, fDuration);

        if (DC >= 5 && fCurrentAlcohol < 1.0 && nFortSave + d20() < DC)
        {
            switch (d6())
            {
                case 1: AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_BELCHES)); break;
                case 2: AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_HICCUPS)); break;
                case 3: AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_STUMBLES));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oPC, 10.0);
                        break;
                case 4: AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_FALLS_DOWN));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 3.0);
                        break;
                case 5:
                case 6: AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 3.0)); break;
            }
        }
    }
}

void htf_ConsumeFoodItem(object oPC, object oItem)
{
    htf_ApplyHungerBonus(oPC, oItem);
    htf_ApplyThirstBonus(oPC, oItem);
    htf_ApplyFatigueBonus(oPC, oItem);
    htf_ApplyOtherFoodEffects(oPC, oItem);
    htf_ApplyAlchoholEffects(oPC, oItem);
}

void htf_DoDrunkenAntics(object oPC)
{
    if (GetCurrentAction(oPC) == ACTION_REST)
        return;

    effect eEffect = GetFirstEffect(oPC);
    while (GetEffectType(eEffect) != EFFECT_TYPE_INVALIDEFFECT)
    {
        if (GetEffectType(eEffect) == EFFECT_TYPE_BLINDNESS)
            return;
        eEffect = GetNextEffect(oPC);
    }

    switch (d6())
    {
        case 1: AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_BELCHES)); break;
        case 2: AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_HICCUPS)); break;
        case 3:
        case 4: AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_STUMBLES));
                AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 3.0));
                break;
        case 5: AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_FALLS_DOWN));
                AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 3.0));
                break;
        case 6: AssignCommand(oPC, SpeakString(HTF_TEXT_ALCOHOL_DRY_HEAVES));
                AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, 1.5));
                break;
    }
}

void htf_FillCanteen(object oPC, object oCanteen, object oSource)
{
    if (GetLocalFloat(oSource, HTF_THIRST_VALUE) == 0.0)
    {
        SendMessageToPC(oPC, SS_TEXT_CANNOT_USE_ON_TARGET);
        return;
    }
    SetLocalObject(oCanteen, HTF_CANTEEN_SOURCE, oSource);
    SetLocalInt(oCanteen, HTF_CURRENT_CHARGES, GetLocalInt(oCanteen, HTF_MAX_CHARGES));
    SendMessageToPC(oPC, HTF_TEXT_FILL_CANTEEN + GetName(oCanteen));
}

void htf_EmptyCanteen(object oCanteen)
{
    DeleteLocalObject(oCanteen, HTF_CANTEEN_SOURCE);
    DeleteLocalInt(oCanteen, HTF_CURRENT_CHARGES);
}

void htf_UseCanteen(object oPC, object oCanteen)
{
    object oTarget = GetItemActivatedTarget();
    location lTarget = GetItemActivatedTargetLocation();
    if (oTarget == oPC)
    {
        int nCurrentCharges = GetLocalInt(oCanteen, HTF_CURRENT_CHARGES);
        object oSource = GetLocalObject(oCanteen, HTF_CANTEEN_SOURCE);
        if (nCurrentCharges == 0 || !GetIsObjectValid(oSource))
        {   //self-fix the canteen if its contents source is invalid.
            SendMessageToPC(oPC, HTF_TEXT_CANTEEN_EMPTY);
            htf_EmptyCanteen(oCanteen);
        }
        else
        {
            nCurrentCharges--;
            SetLocalInt(oCanteen, HTF_CURRENT_CHARGES, nCurrentCharges);
            SendMessageToPC(oPC, HTF_TEXT_TAKE_A_DRINK);
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
            htf_ConsumeFoodItem(oPC, oSource);
        }
        return;
    }

    if (oTarget == oCanteen)
    {
        SendMessageToPC(oPC, HTF_TEXT_EMPTY_CANTEEN + GetName(oCanteen));
        htf_EmptyCanteen(oCanteen);
        return;
    }

    if (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID));
            htf_FillCanteen(oPC, oCanteen, oTarget);
        }
        else
            SendMessageToPC(oPC, SS_TEXT_CANNOT_USE_ON_TARGET);
        return;
    }

    oTarget = GetLocalObject(oPC, HTF_TRIGGER);
    if (!GetIsObjectValid(oTarget))
        SendMessageToPC(oPC, HTF_TEXT_NO_PLACE_TO_FILL);
    else
    {
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW));
        htf_FillCanteen(oPC, oCanteen, oTarget);
    }
}

int htf_GetClassQuickRestsPerDay(int nClass)
{
    switch (nClass)
    {
        case CLASS_TYPE_BARBARIAN:            return HTF_QUICK_RESTS_PER_DAY_CLASS_BARBARIAN;        break;
        case CLASS_TYPE_BARD:                 return HTF_QUICK_RESTS_PER_DAY_CLASS_BARD;             break;
        case CLASS_TYPE_CLERIC:               return HTF_QUICK_RESTS_PER_DAY_CLASS_CLERIC;           break;
        case CLASS_TYPE_DRUID:                return HTF_QUICK_RESTS_PER_DAY_CLASS_DRUID;            break;
        case CLASS_TYPE_FIGHTER:              return HTF_QUICK_RESTS_PER_DAY_CLASS_FIGHTER;          break;
        case CLASS_TYPE_MONK:                 return HTF_QUICK_RESTS_PER_DAY_CLASS_MONK;             break;
        case CLASS_TYPE_PALADIN:              return HTF_QUICK_RESTS_PER_DAY_CLASS_PALADIN;          break;
        case CLASS_TYPE_RANGER:               return HTF_QUICK_RESTS_PER_DAY_CLASS_RANGER;           break;
        case CLASS_TYPE_ROGUE:                return HTF_QUICK_RESTS_PER_DAY_CLASS_ROGUE;            break;
        case CLASS_TYPE_SORCERER:             return HTF_QUICK_RESTS_PER_DAY_CLASS_SORCERER;         break;
        case CLASS_TYPE_WIZARD:               return HTF_QUICK_RESTS_PER_DAY_CLASS_WIZARD;           break;
        case CLASS_TYPE_ARCANE_ARCHER:        return HTF_QUICK_RESTS_PER_DAY_CLASS_ARCANE_ARCHER;    break;
        case CLASS_TYPE_ASSASSIN:             return HTF_QUICK_RESTS_PER_DAY_CLASS_ASSASSIN;         break;
        case CLASS_TYPE_BLACKGUARD:           return HTF_QUICK_RESTS_PER_DAY_CLASS_BLACKGUARD;       break;
        case CLASS_TYPE_DIVINE_CHAMPION:      return HTF_QUICK_RESTS_PER_DAY_CLASS_DIVINE_CHAMPION;  break;
        case CLASS_TYPE_DRAGON_DISCIPLE:      return HTF_QUICK_RESTS_PER_DAY_CLASS_DRAGON_DISCIPLE;  break;
        case CLASS_TYPE_DWARVEN_DEFENDER:     return HTF_QUICK_RESTS_PER_DAY_CLASS_DWARVEN_DEFENDER; break;
        case CLASS_TYPE_HARPER:               return HTF_QUICK_RESTS_PER_DAY_CLASS_HARPER;           break;
        case CLASS_TYPE_PALE_MASTER:          return HTF_QUICK_RESTS_PER_DAY_CLASS_PALE_MASTER;      break;
        case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return HTF_QUICK_RESTS_PER_DAY_CLASS_PALE_MASTER;      break;
        case CLASS_TYPE_SHADOWDANCER:         return HTF_QUICK_RESTS_PER_DAY_CLASS_SHADOWDANCER;     break;
        case CLASS_TYPE_SHIFTER:              return HTF_QUICK_RESTS_PER_DAY_CLASS_SHIFTER;          break;
        case CLASS_TYPE_WEAPON_MASTER:        return HTF_QUICK_RESTS_PER_DAY_CLASS_WEAPON_MASTER;    break;
    }
    return 8;
}

float htf_GetQuickRestFatigueCost(object oPC)
{
    int nRests;
    int nIndex = 1;
    int nCharLevel = ss_GetLevel(oPC);
    int nClass = GetClassByPosition(1, oPC);
    int nLevel = GetLevelByPosition(1, oPC);

    while (nClass != CLASS_TYPE_INVALID)
    {
        nIndex++;
        nRests += htf_GetClassQuickRestsPerDay(nClass) * nLevel;
        nClass = GetClassByPosition(nIndex, oPC);
        nLevel = GetLevelByPosition(nIndex, oPC);
    }

    nRests /= nCharLevel;
    nRests += GetAbilityModifier(ABILITY_CONSTITUTION, oPC);

    float fFatigueCost = 1.0 / nRests;

    SetLocalFloat(oPC, HTF_QUICK_REST_FATIGUE_COST, fFatigueCost);
    return fFatigueCost;
}

int htf_GetAllowQuickRest(object oPC)
{
    float fCurrentFatigue = GetLocalFloat(oPC, HTF_CURRENT_FATIGUE);
    float fFatigueCost = htf_GetQuickRestFatigueCost(oPC);
    return (fCurrentFatigue > fFatigueCost);
}

void htf_DoQuickRest(object oPC)
{
    float fCurrentFatigue = GetLocalFloat(oPC, HTF_CURRENT_FATIGUE);
    float fFatigueCost = GetLocalFloat(oPC, HTF_QUICK_REST_FATIGUE_COST);

    if (fCurrentFatigue < fFatigueCost)
        return;

    int nHealAmount = GetMaxHitPoints(oPC) / 4;
    effect eHeal = EffectHeal(nHealAmount);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
    SetLocalFloat(oPC, HTF_CURRENT_FATIGUE, fCurrentFatigue - fFatigueCost);
}
