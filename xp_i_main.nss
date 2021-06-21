/*
Filename:           xp_i_main
System:             Experience (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Apr. 25, 2008
Summary:
XP system primary include script. This file holds the functions commonly used
throughout the XP system.

The scripts contained herein are based on those included in Knat's PW Flexible
XP system. Class-based rewards inspired by those in the Vives PW. Customized for
compatibility with Shadows & Silver's needs and database system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Generic include function.
#include "g_i_generic"

// XP system user configuration script.
#include "xp_c_main"

// XP system constants definition script.
#include "xp_i_constants"

/********************************************/
/* Global Variables                         */
/********************************************/

float XP_MODIFIER_COMBAT_PARTY_LEVEL_DIFFERENCE = XP_MODIFIER_COMBAT_PARTY_SCALE / (XP_COMBAT_PARTY_LEVEL_DISTANCE_NOXP - XP_COMBAT_PARTY_LEVEL_DISTANCE_REDUCTION);
float XP_MODIFIER_COMBAT_CR_LESS_THAN_LEVEL     = XP_MODIFIER_COMBAT_CR_SCALE / (XP_COMBAT_CR_LESS_THAN_LEVEL_NOXP - XP_COMBAT_CR_LESS_THAN_LEVEL_REDUCTION);
float XP_MODIFIER_COMBAT_CR_GREATER_THAN_LEVEL  = XP_MODIFIER_COMBAT_CR_SCALE / (XP_COMBAT_CR_GREATER_THAN_LEVEL_NOXP - XP_COMBAT_CR_GREATER_THAN_LEVEL_REDUCTION);


/********************************************/
/* Private Function Prototypes              */
/********************************************/

// Gets the total level of oPC.
int xp_GetLevel(object oPC);

// Gets level XP modifier for level nLevel set in xp_core_c.
float xp_GetLevelModifier(int nLevel);

// Gets class XP modifier for class nClass set in xp_core_c.
float xp_GetClassModifier(int nClass);

// Gets the racial XP modifier for race nRace set in xp_core_c.
float xp_GetRacialModifier(int nRace);

// Gets the subrace XP modifier for subrace sSubRace set on the XP data waypoint.
float xp_GetSubRaceModifier(string sSubRace);

// Gets the type modifier for XP type nType set in xp_core_c.
float xp_GetTypeModifier(int nType);

// Gets the class type modifier for XP type nType and class nClass set in xp_core_c.
float xp_GetClassTypeModifier(int nType, int nClass);

// Gets the XP modifier for PCs whose level is fLevelDistance away from the
// average party level based on the modifiers set in xp_core_c.
float xp_GetAveragePartyLevelDistanceModifier(float fLevelDistance);

// Gets the XP modifier for PCs whose level is fCRDistance away from the killed
// creature's CR based on the modifiers set in xp_core_c.
float xp_GetCRDistanceModifier(float fCRDistance);

// Gets the killing blow XP modifier set in xp_core_c and grants it to oPC if he
// is oKiller.
float xp_GetKillingBlowModifier(object oPC, object oKiller);

// Gets the party XP modifier set in xp_core_c for a group of nGroupSize.
float xp_GetPartyModifier(int nGroupSize);

// Gets the XP soak rate of associate ocreature as defined in xp_core_c.
float xp_GetAssociateDivisor(object oCreature);

// Returns TRUE if oGroupMember is close enough to oDead to get XP for the kill.
int xp_CheckDistance(object oDead, object oGroupMember);

// Checks to make sure nXP is within the bounds of the minimum or maximum XP
// based on type nType and, if it is not, returns a corrected amount.
int xp_FixMinMaxXP(int nXP, int nType);

// Sends a message to oPC that he gained XP of nType. Set bGain to FALSE if oPC
// is losing XP.
void xp_SendXPMessageToPC(object oPC, int nType, int bGain = TRUE);

// Computes oPC's persistent un-typed XP modifier and stores it in the database.
void xp_SetGenericModifier(object oPC);

// Computes oPC's persistent XP modifier of nType and stores it in the database.
void xp_SetTypeModifier(object oPC, int nType);


/********************************************/
/* Private Function Implementation          */
/********************************************/

int xp_GetLevel(object oPC)
{
    if(XP_USE_TOTAL_XP_TO_COMPUTE_LEVEL)
        return FloatToInt(0.5 + sqrt(0.25 + ( IntToFloat(GetXP(oPC)) / 500)));
    else
        return GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) + GetLevelByPosition(3, oPC);
}

float xp_GetLevelModifier(int nLevel)
{
    switch (nLevel)
    {
        case 1:  return XP_MODIFIER_LEVEL_1;  break;
        case 2:  return XP_MODIFIER_LEVEL_2;  break;
        case 3:  return XP_MODIFIER_LEVEL_3;  break;
        case 4:  return XP_MODIFIER_LEVEL_4;  break;
        case 5:  return XP_MODIFIER_LEVEL_5;  break;
        case 6:  return XP_MODIFIER_LEVEL_6;  break;
        case 7:  return XP_MODIFIER_LEVEL_7;  break;
        case 8:  return XP_MODIFIER_LEVEL_8;  break;
        case 9:  return XP_MODIFIER_LEVEL_9;  break;
        case 10: return XP_MODIFIER_LEVEL_10; break;
        case 11: return XP_MODIFIER_LEVEL_11; break;
        case 12: return XP_MODIFIER_LEVEL_12; break;
        case 13: return XP_MODIFIER_LEVEL_13; break;
        case 14: return XP_MODIFIER_LEVEL_14; break;
        case 15: return XP_MODIFIER_LEVEL_15; break;
        case 16: return XP_MODIFIER_LEVEL_16; break;
        case 17: return XP_MODIFIER_LEVEL_17; break;
        case 18: return XP_MODIFIER_LEVEL_18; break;
        case 19: return XP_MODIFIER_LEVEL_19; break;
        case 20: return XP_MODIFIER_LEVEL_20; break;
        case 21: return XP_MODIFIER_LEVEL_21; break;
        case 22: return XP_MODIFIER_LEVEL_22; break;
        case 23: return XP_MODIFIER_LEVEL_23; break;
        case 24: return XP_MODIFIER_LEVEL_24; break;
        case 25: return XP_MODIFIER_LEVEL_25; break;
        case 26: return XP_MODIFIER_LEVEL_26; break;
        case 27: return XP_MODIFIER_LEVEL_27; break;
        case 28: return XP_MODIFIER_LEVEL_28; break;
        case 29: return XP_MODIFIER_LEVEL_29; break;
        case 30: return XP_MODIFIER_LEVEL_30; break;
        case 31: return XP_MODIFIER_LEVEL_31; break;
        case 32: return XP_MODIFIER_LEVEL_32; break;
        case 33: return XP_MODIFIER_LEVEL_33; break;
        case 34: return XP_MODIFIER_LEVEL_34; break;
        case 35: return XP_MODIFIER_LEVEL_35; break;
        case 36: return XP_MODIFIER_LEVEL_36; break;
        case 37: return XP_MODIFIER_LEVEL_37; break;
        case 38: return XP_MODIFIER_LEVEL_38; break;
        case 39: return XP_MODIFIER_LEVEL_39; break;
    }
    return 1.000;
}

float xp_GetClassModifier(int nClass)
{
    switch (nClass)
    {
        case CLASS_TYPE_BARBARIAN:            return XP_MODIFIER_CLASS_BARBARIAN;        break;
        case CLASS_TYPE_BARD:                 return XP_MODIFIER_CLASS_BARD;             break;
        case CLASS_TYPE_CLERIC:               return XP_MODIFIER_CLASS_CLERIC;           break;
        case CLASS_TYPE_DRUID:                return XP_MODIFIER_CLASS_DRUID;            break;
        case CLASS_TYPE_FIGHTER:              return XP_MODIFIER_CLASS_FIGHTER;          break;
        case CLASS_TYPE_MONK:                 return XP_MODIFIER_CLASS_MONK;             break;
        case CLASS_TYPE_PALADIN:              return XP_MODIFIER_CLASS_PALADIN;          break;
        case CLASS_TYPE_RANGER:               return XP_MODIFIER_CLASS_RANGER;           break;
        case CLASS_TYPE_ROGUE:                return XP_MODIFIER_CLASS_ROGUE;            break;
        case CLASS_TYPE_SORCERER:             return XP_MODIFIER_CLASS_SORCERER;         break;
        case CLASS_TYPE_WIZARD:               return XP_MODIFIER_CLASS_WIZARD;           break;
        case CLASS_TYPE_ARCANE_ARCHER:        return XP_MODIFIER_CLASS_ARCANE_ARCHER;    break;
        case CLASS_TYPE_ASSASSIN:             return XP_MODIFIER_CLASS_ASSASSIN;         break;
        case CLASS_TYPE_BLACKGUARD:           return XP_MODIFIER_CLASS_BLACKGUARD;       break;
        case CLASS_TYPE_DIVINE_CHAMPION:      return XP_MODIFIER_CLASS_DIVINE_CHAMPION;  break;
        case CLASS_TYPE_DRAGON_DISCIPLE:      return XP_MODIFIER_CLASS_DRAGON_DISCIPLE;  break;
        case CLASS_TYPE_DWARVEN_DEFENDER:     return XP_MODIFIER_CLASS_DWARVEN_DEFENDER; break;
        case CLASS_TYPE_HARPER:               return XP_MODIFIER_CLASS_HARPER;           break;
        case CLASS_TYPE_PALE_MASTER:          return XP_MODIFIER_CLASS_PALE_MASTER;      break;
        case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return XP_MODIFIER_CLASS_PALE_MASTER;      break;
        case CLASS_TYPE_SHADOWDANCER:         return XP_MODIFIER_CLASS_SHADOWDANCER;     break;
        case CLASS_TYPE_SHIFTER:              return XP_MODIFIER_CLASS_SHIFTER;          break;
        case CLASS_TYPE_WEAPON_MASTER:        return XP_MODIFIER_CLASS_WEAPON_MASTER;    break;
    }
    return 1.00;
}

float xp_GetRacialModifier(int nRace)
{
    switch (nRace)
    {
        case RACIAL_TYPE_DWARF:    return XP_MODIFIER_RACE_DWARF;    break;
        case RACIAL_TYPE_ELF:      return XP_MODIFIER_RACE_ELF;      break;
        case RACIAL_TYPE_GNOME:    return XP_MODIFIER_RACE_GNOME;    break;
        case RACIAL_TYPE_HALFELF:  return XP_MODIFIER_RACE_HALFELF;  break;
        case RACIAL_TYPE_HALFLING: return XP_MODIFIER_RACE_HALFLING; break;
        case RACIAL_TYPE_HALFORC:  return XP_MODIFIER_RACE_HALFORC;  break;
        case RACIAL_TYPE_HUMAN:    return XP_MODIFIER_RACE_HUMAN;    break;
    }
    return 1.00;
}

float xp_GetSubRaceModifier(string sSubRace)
{
    if (sSubRace == "")
        return 1.00;
    object oData = GetObjectByTag(XP_DATAPOINT);
    return GetLocalFloat(oData, XP_SUBRACE_PREFIX + sSubRace);
}

float xp_GetTypeModifier(int nType)
{
    switch (nType)
    {
        case XP_TYPE_ABILITY:   return XP_MODIFIER_TYPE_ABILITY;   break;
        case XP_TYPE_COMBAT:    return XP_MODIFIER_TYPE_COMBAT;    break;
        case XP_TYPE_CRAFTING:  return XP_MODIFIER_TYPE_CRAFTING;  break;
        case XP_TYPE_DISCOVERY: return XP_MODIFIER_TYPE_DISCOVERY; break;
        case XP_TYPE_MAGIC:     return XP_MODIFIER_TYPE_MAGIC;     break;
    }
    return 1.00;
}

float xp_GetClassTypeModifier(int nType, int nClass)
{
    switch (nType)
    {
        case XP_TYPE_ABILITY:
            switch (nClass)
            {
                case CLASS_TYPE_BARBARIAN:            return XP_MODIFIER_TYPE_ABILITY_BARBARIAN;             break;
                case CLASS_TYPE_BARD:                 return XP_MODIFIER_TYPE_ABILITY_BARD;                  break;
                case CLASS_TYPE_CLERIC:               return XP_MODIFIER_TYPE_ABILITY_CLERIC;                break;
                case CLASS_TYPE_DRUID:                return XP_MODIFIER_TYPE_ABILITY_DRUID;                 break;
                case CLASS_TYPE_FIGHTER:              return XP_MODIFIER_TYPE_ABILITY_FIGHTER;               break;
                case CLASS_TYPE_MONK:                 return XP_MODIFIER_TYPE_ABILITY_MONK;                  break;
                case CLASS_TYPE_PALADIN:              return XP_MODIFIER_TYPE_ABILITY_PALADIN;               break;
                case CLASS_TYPE_RANGER:               return XP_MODIFIER_TYPE_ABILITY_RANGER;                break;
                case CLASS_TYPE_ROGUE:                return XP_MODIFIER_TYPE_ABILITY_ROGUE;                 break;
                case CLASS_TYPE_SORCERER:             return XP_MODIFIER_TYPE_ABILITY_SORCERER;              break;
                case CLASS_TYPE_WIZARD:               return XP_MODIFIER_TYPE_ABILITY_WIZARD;                break;
                case CLASS_TYPE_ARCANE_ARCHER:        return XP_MODIFIER_TYPE_ABILITY_ARCANE_ARCHER;         break;
                case CLASS_TYPE_ASSASSIN:             return XP_MODIFIER_TYPE_ABILITY_ASSASSIN;              break;
                case CLASS_TYPE_BLACKGUARD:           return XP_MODIFIER_TYPE_ABILITY_BLACKGUARD;            break;
                case CLASS_TYPE_DIVINE_CHAMPION:      return XP_MODIFIER_TYPE_ABILITY_DIVINE_CHAMPION;       break;
                case CLASS_TYPE_DRAGON_DISCIPLE:      return XP_MODIFIER_TYPE_ABILITY_DRAGON_DISCIPLE;       break;
                case CLASS_TYPE_DWARVEN_DEFENDER:     return XP_MODIFIER_TYPE_ABILITY_DWARVEN_DEFENDER;      break;
                case CLASS_TYPE_HARPER:               return XP_MODIFIER_TYPE_ABILITY_HARPER;                break;
                case CLASS_TYPE_PALE_MASTER:          return XP_MODIFIER_TYPE_ABILITY_PALE_MASTER;           break;
                case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return XP_MODIFIER_TYPE_ABILITY_PURPLE_DRAGON_KNIGHT;  break;
                case CLASS_TYPE_SHADOWDANCER:         return XP_MODIFIER_TYPE_ABILITY_SHADOWDANCER;          break;
                case CLASS_TYPE_SHIFTER:              return XP_MODIFIER_TYPE_ABILITY_SHIFTER;               break;
                case CLASS_TYPE_WEAPON_MASTER:        return XP_MODIFIER_TYPE_ABILITY_WEAPON_MASTER;         break;
            }
        case XP_TYPE_COMBAT:
            switch (nClass)
            {
                case CLASS_TYPE_BARBARIAN:            return XP_MODIFIER_TYPE_COMBAT_BARBARIAN;             break;
                case CLASS_TYPE_BARD:                 return XP_MODIFIER_TYPE_COMBAT_BARD;                  break;
                case CLASS_TYPE_CLERIC:               return XP_MODIFIER_TYPE_COMBAT_CLERIC;                break;
                case CLASS_TYPE_DRUID:                return XP_MODIFIER_TYPE_COMBAT_DRUID;                 break;
                case CLASS_TYPE_FIGHTER:              return XP_MODIFIER_TYPE_COMBAT_FIGHTER;               break;
                case CLASS_TYPE_MONK:                 return XP_MODIFIER_TYPE_COMBAT_MONK;                  break;
                case CLASS_TYPE_PALADIN:              return XP_MODIFIER_TYPE_COMBAT_PALADIN;               break;
                case CLASS_TYPE_RANGER:               return XP_MODIFIER_TYPE_COMBAT_RANGER;                break;
                case CLASS_TYPE_ROGUE:                return XP_MODIFIER_TYPE_COMBAT_ROGUE;                 break;
                case CLASS_TYPE_SORCERER:             return XP_MODIFIER_TYPE_COMBAT_SORCERER;              break;
                case CLASS_TYPE_WIZARD:               return XP_MODIFIER_TYPE_COMBAT_WIZARD;                break;
                case CLASS_TYPE_ARCANE_ARCHER:        return XP_MODIFIER_TYPE_COMBAT_ARCANE_ARCHER;         break;
                case CLASS_TYPE_ASSASSIN:             return XP_MODIFIER_TYPE_COMBAT_ASSASSIN;              break;
                case CLASS_TYPE_BLACKGUARD:           return XP_MODIFIER_TYPE_COMBAT_BLACKGUARD;            break;
                case CLASS_TYPE_DIVINE_CHAMPION:      return XP_MODIFIER_TYPE_COMBAT_DIVINE_CHAMPION;       break;
                case CLASS_TYPE_DRAGON_DISCIPLE:      return XP_MODIFIER_TYPE_COMBAT_DRAGON_DISCIPLE;       break;
                case CLASS_TYPE_DWARVEN_DEFENDER:     return XP_MODIFIER_TYPE_COMBAT_DWARVEN_DEFENDER;      break;
                case CLASS_TYPE_HARPER:               return XP_MODIFIER_TYPE_COMBAT_HARPER;                break;
                case CLASS_TYPE_PALE_MASTER:          return XP_MODIFIER_TYPE_COMBAT_PALE_MASTER;           break;
                case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return XP_MODIFIER_TYPE_COMBAT_PURPLE_DRAGON_KNIGHT;  break;
                case CLASS_TYPE_SHADOWDANCER:         return XP_MODIFIER_TYPE_COMBAT_SHADOWDANCER;          break;
                case CLASS_TYPE_SHIFTER:              return XP_MODIFIER_TYPE_COMBAT_SHIFTER;               break;
                case CLASS_TYPE_WEAPON_MASTER:        return XP_MODIFIER_TYPE_COMBAT_WEAPON_MASTER;         break;
            }
        case XP_TYPE_CRAFTING:
            switch (nClass)
            {
                case CLASS_TYPE_BARBARIAN:            return XP_MODIFIER_TYPE_CRAFTING_BARBARIAN;             break;
                case CLASS_TYPE_BARD:                 return XP_MODIFIER_TYPE_CRAFTING_BARD;                  break;
                case CLASS_TYPE_CLERIC:               return XP_MODIFIER_TYPE_CRAFTING_CLERIC;                break;
                case CLASS_TYPE_DRUID:                return XP_MODIFIER_TYPE_CRAFTING_DRUID;                 break;
                case CLASS_TYPE_FIGHTER:              return XP_MODIFIER_TYPE_CRAFTING_FIGHTER;               break;
                case CLASS_TYPE_MONK:                 return XP_MODIFIER_TYPE_CRAFTING_MONK;                  break;
                case CLASS_TYPE_PALADIN:              return XP_MODIFIER_TYPE_CRAFTING_PALADIN;               break;
                case CLASS_TYPE_RANGER:               return XP_MODIFIER_TYPE_CRAFTING_RANGER;                break;
                case CLASS_TYPE_ROGUE:                return XP_MODIFIER_TYPE_CRAFTING_ROGUE;                 break;
                case CLASS_TYPE_SORCERER:             return XP_MODIFIER_TYPE_CRAFTING_SORCERER;              break;
                case CLASS_TYPE_WIZARD:               return XP_MODIFIER_TYPE_CRAFTING_WIZARD;                break;
                case CLASS_TYPE_ARCANE_ARCHER:        return XP_MODIFIER_TYPE_CRAFTING_ARCANE_ARCHER;         break;
                case CLASS_TYPE_ASSASSIN:             return XP_MODIFIER_TYPE_CRAFTING_ASSASSIN;              break;
                case CLASS_TYPE_BLACKGUARD:           return XP_MODIFIER_TYPE_CRAFTING_BLACKGUARD;            break;
                case CLASS_TYPE_DIVINE_CHAMPION:      return XP_MODIFIER_TYPE_CRAFTING_DIVINE_CHAMPION;       break;
                case CLASS_TYPE_DRAGON_DISCIPLE:      return XP_MODIFIER_TYPE_CRAFTING_DRAGON_DISCIPLE;       break;
                case CLASS_TYPE_DWARVEN_DEFENDER:     return XP_MODIFIER_TYPE_CRAFTING_DWARVEN_DEFENDER;      break;
                case CLASS_TYPE_HARPER:               return XP_MODIFIER_TYPE_CRAFTING_HARPER;                break;
                case CLASS_TYPE_PALE_MASTER:          return XP_MODIFIER_TYPE_CRAFTING_PALE_MASTER;           break;
                case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return XP_MODIFIER_TYPE_CRAFTING_PURPLE_DRAGON_KNIGHT;  break;
                case CLASS_TYPE_SHADOWDANCER:         return XP_MODIFIER_TYPE_CRAFTING_SHADOWDANCER;          break;
                case CLASS_TYPE_SHIFTER:              return XP_MODIFIER_TYPE_CRAFTING_SHIFTER;               break;
                case CLASS_TYPE_WEAPON_MASTER:        return XP_MODIFIER_TYPE_CRAFTING_WEAPON_MASTER;         break;
            }
        case XP_TYPE_DISCOVERY:
            switch (nClass)
            {
                case CLASS_TYPE_BARBARIAN:            return XP_MODIFIER_TYPE_DISCOVERY_BARBARIAN;             break;
                case CLASS_TYPE_BARD:                 return XP_MODIFIER_TYPE_DISCOVERY_BARD;                  break;
                case CLASS_TYPE_CLERIC:               return XP_MODIFIER_TYPE_DISCOVERY_CLERIC;                break;
                case CLASS_TYPE_DRUID:                return XP_MODIFIER_TYPE_DISCOVERY_DRUID;                 break;
                case CLASS_TYPE_FIGHTER:              return XP_MODIFIER_TYPE_DISCOVERY_FIGHTER;               break;
                case CLASS_TYPE_MONK:                 return XP_MODIFIER_TYPE_DISCOVERY_MONK;                  break;
                case CLASS_TYPE_PALADIN:              return XP_MODIFIER_TYPE_DISCOVERY_PALADIN;               break;
                case CLASS_TYPE_RANGER:               return XP_MODIFIER_TYPE_DISCOVERY_RANGER;                break;
                case CLASS_TYPE_ROGUE:                return XP_MODIFIER_TYPE_DISCOVERY_ROGUE;                 break;
                case CLASS_TYPE_SORCERER:             return XP_MODIFIER_TYPE_DISCOVERY_SORCERER;              break;
                case CLASS_TYPE_WIZARD:               return XP_MODIFIER_TYPE_DISCOVERY_WIZARD;                break;
                case CLASS_TYPE_ARCANE_ARCHER:        return XP_MODIFIER_TYPE_DISCOVERY_ARCANE_ARCHER;         break;
                case CLASS_TYPE_ASSASSIN:             return XP_MODIFIER_TYPE_DISCOVERY_ASSASSIN;              break;
                case CLASS_TYPE_BLACKGUARD:           return XP_MODIFIER_TYPE_DISCOVERY_BLACKGUARD;            break;
                case CLASS_TYPE_DIVINE_CHAMPION:      return XP_MODIFIER_TYPE_DISCOVERY_DIVINE_CHAMPION;       break;
                case CLASS_TYPE_DRAGON_DISCIPLE:      return XP_MODIFIER_TYPE_DISCOVERY_DRAGON_DISCIPLE;       break;
                case CLASS_TYPE_DWARVEN_DEFENDER:     return XP_MODIFIER_TYPE_DISCOVERY_DWARVEN_DEFENDER;      break;
                case CLASS_TYPE_HARPER:               return XP_MODIFIER_TYPE_DISCOVERY_HARPER;                break;
                case CLASS_TYPE_PALE_MASTER:          return XP_MODIFIER_TYPE_DISCOVERY_PALE_MASTER;           break;
                case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return XP_MODIFIER_TYPE_DISCOVERY_PURPLE_DRAGON_KNIGHT;  break;
                case CLASS_TYPE_SHADOWDANCER:         return XP_MODIFIER_TYPE_DISCOVERY_SHADOWDANCER;          break;
                case CLASS_TYPE_SHIFTER:              return XP_MODIFIER_TYPE_DISCOVERY_SHIFTER;               break;
                case CLASS_TYPE_WEAPON_MASTER:        return XP_MODIFIER_TYPE_DISCOVERY_WEAPON_MASTER;         break;
            }
        case XP_TYPE_MAGIC:
            switch (nClass)
            {
                case CLASS_TYPE_BARBARIAN:            return XP_MODIFIER_TYPE_MAGIC_BARBARIAN;             break;
                case CLASS_TYPE_BARD:                 return XP_MODIFIER_TYPE_MAGIC_BARD;                  break;
                case CLASS_TYPE_CLERIC:               return XP_MODIFIER_TYPE_MAGIC_CLERIC;                break;
                case CLASS_TYPE_DRUID:                return XP_MODIFIER_TYPE_MAGIC_DRUID;                 break;
                case CLASS_TYPE_FIGHTER:              return XP_MODIFIER_TYPE_MAGIC_FIGHTER;               break;
                case CLASS_TYPE_MONK:                 return XP_MODIFIER_TYPE_MAGIC_MONK;                  break;
                case CLASS_TYPE_PALADIN:              return XP_MODIFIER_TYPE_MAGIC_PALADIN;               break;
                case CLASS_TYPE_RANGER:               return XP_MODIFIER_TYPE_MAGIC_RANGER;                break;
                case CLASS_TYPE_ROGUE:                return XP_MODIFIER_TYPE_MAGIC_ROGUE;                 break;
                case CLASS_TYPE_SORCERER:             return XP_MODIFIER_TYPE_MAGIC_SORCERER;              break;
                case CLASS_TYPE_WIZARD:               return XP_MODIFIER_TYPE_MAGIC_WIZARD;                break;
                case CLASS_TYPE_ARCANE_ARCHER:        return XP_MODIFIER_TYPE_MAGIC_ARCANE_ARCHER;         break;
                case CLASS_TYPE_ASSASSIN:             return XP_MODIFIER_TYPE_MAGIC_ASSASSIN;              break;
                case CLASS_TYPE_BLACKGUARD:           return XP_MODIFIER_TYPE_MAGIC_BLACKGUARD;            break;
                case CLASS_TYPE_DIVINE_CHAMPION:      return XP_MODIFIER_TYPE_MAGIC_DIVINE_CHAMPION;       break;
                case CLASS_TYPE_DRAGON_DISCIPLE:      return XP_MODIFIER_TYPE_MAGIC_DRAGON_DISCIPLE;       break;
                case CLASS_TYPE_DWARVEN_DEFENDER:     return XP_MODIFIER_TYPE_MAGIC_DWARVEN_DEFENDER;      break;
                case CLASS_TYPE_HARPER:               return XP_MODIFIER_TYPE_MAGIC_HARPER;                break;
                case CLASS_TYPE_PALE_MASTER:          return XP_MODIFIER_TYPE_MAGIC_PALE_MASTER;           break;
                case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return XP_MODIFIER_TYPE_MAGIC_PURPLE_DRAGON_KNIGHT;  break;
                case CLASS_TYPE_SHADOWDANCER:         return XP_MODIFIER_TYPE_MAGIC_SHADOWDANCER;          break;
                case CLASS_TYPE_SHIFTER:              return XP_MODIFIER_TYPE_MAGIC_SHIFTER;               break;
                case CLASS_TYPE_WEAPON_MASTER:        return XP_MODIFIER_TYPE_MAGIC_WEAPON_MASTER;         break;
            }
    }
    return 1.00;
}

float xp_GetAveragePartyLevelDistanceModifier(float fLevelDistance)
{
    if (fLevelDistance >= XP_COMBAT_PARTY_LEVEL_DISTANCE_NOXP)
        return 0.0;

    if (fLevelDistance >= XP_COMBAT_PARTY_LEVEL_DISTANCE_REDUCTION)
        return 1 - ((fLevelDistance - XP_COMBAT_PARTY_LEVEL_DISTANCE_REDUCTION) * XP_MODIFIER_COMBAT_PARTY_LEVEL_DIFFERENCE);
    return 1.0;
}

float xp_GetCRDistanceModifier(float fCRDistance)
{
    if (fCRDistance < 0.0)
    {
        fCRDistance = fabs(fCRDistance);
        if (fCRDistance >= XP_COMBAT_CR_LESS_THAN_LEVEL_NOXP )
            return 0.0;

        if (fCRDistance >= XP_COMBAT_CR_LESS_THAN_LEVEL_REDUCTION)
            return 1 - ((fCRDistance - XP_COMBAT_CR_LESS_THAN_LEVEL_REDUCTION) * XP_MODIFIER_COMBAT_CR_LESS_THAN_LEVEL);
    }
    else
    {
        fCRDistance = fabs(fCRDistance);
        if (fCRDistance >= XP_COMBAT_CR_GREATER_THAN_LEVEL_NOXP)
            return 0.0;

        if (fCRDistance >= XP_COMBAT_CR_GREATER_THAN_LEVEL_REDUCTION)
            return 1 - ((fCRDistance - XP_COMBAT_CR_GREATER_THAN_LEVEL_REDUCTION) * XP_MODIFIER_COMBAT_CR_GREATER_THAN_LEVEL);
    }
    return 1.0;
}

float xp_GetKillingBlowModifier(object oPC, object oKiller)
{
    if (oPC == oKiller)
        return 1.0 + XP_MODIFIER_COMBAT_KILLINGBLOW;
    return 1.0;
}

float xp_GetPartyModifier(int nGroupSize)
{
    if (nGroupSize > 1)
        return 1 + ((nGroupSize - 1) * XP_MODIFIER_COMBAT_PARTY);
    return 1.0;
}

int xp_GetObjectBonus(object oObject, int nType=XP_TYPE_GENERIC)
{
    string sVarName;

    switch (nType)
    {
        case XP_TYPE_ABILITY:   sVarName = XP_BONUS_ABILITY;   break;
        case XP_TYPE_COMBAT:    sVarName = XP_BONUS_COMBAT;    break;
        case XP_TYPE_CRAFTING:  sVarName = XP_BONUS_CRAFTING;  break;
        case XP_TYPE_DISCOVERY: sVarName = XP_BONUS_DISCOVERY; break;
        case XP_TYPE_MAGIC:     sVarName = XP_BONUS_MAGIC;     break;
        default:                sVarName = XP_BONUS_GENERIC;   break;
    }

    return GetLocalInt(oObject, sVarName);
}

float xp_GetObjectModifier(object oObject, int nType=XP_TYPE_GENERIC)
{
    string sVarName;

    switch (nType)
    {
        case XP_TYPE_ABILITY:   sVarName = XP_MODIFIER_ABILITY;   break;
        case XP_TYPE_COMBAT:    sVarName = XP_MODIFIER_COMBAT;    break;
        case XP_TYPE_CRAFTING:  sVarName = XP_MODIFIER_CRAFTING;  break;
        case XP_TYPE_DISCOVERY: sVarName = XP_MODIFIER_DISCOVERY; break;
        case XP_TYPE_MAGIC:     sVarName = XP_MODIFIER_MAGIC;     break;
        default:                sVarName = XP_MODIFIER_GENERIC;   break;
    }

    float fReturn = GetLocalFloat(oObject, sVarName);

    if (fReturn == 0.0)
        fReturn = 1.0;
    if (fReturn < 0.0)
        fReturn = 0.0;

    return fReturn;
}

float xp_GetAssociateDivisor(object oCreature)
{
    switch(GetAssociateType(oCreature))
    {
        case ASSOCIATE_TYPE_ANIMALCOMPANION: return XP_COMBAT_DIVISOR_ANIMALCOMPANION;
        case ASSOCIATE_TYPE_DOMINATED:       return XP_COMBAT_DIVISOR_DOMINATED;
        case ASSOCIATE_TYPE_FAMILIAR:        return XP_COMBAT_DIVISOR_FAMILIAR;
        case ASSOCIATE_TYPE_HENCHMAN:        return XP_COMBAT_DIVISOR_HENCHMAN;
        case ASSOCIATE_TYPE_SUMMONED:        return XP_COMBAT_DIVISOR_SUMMONED;
        default: return XP_COMBAT_DIVISOR_UNKNOWN;
    }
    return 1.0;
}

int xp_CheckDistance(object oDead, object oGroupMember)
{
    if (XP_COMBAT_MAXIMUM_DISTANCE_FROM_KILL == 0.0)
        return TRUE;

    float fDistance = GetDistanceBetween(oDead, oGroupMember);
    object oArea1 = GetArea(oDead);
    object oArea2 = GetArea(oGroupMember);
    return (fDistance <= XP_COMBAT_MAXIMUM_DISTANCE_FROM_KILL) && (oArea1 == oArea2);
}

int xp_FixMinMaxXP(int nXP, int nType)
{
    int nMin;
    int nMax;

    switch (nType)
    {
        case XP_TYPE_ABILITY:   nMin = XP_ABILITY_MIN;   nMax = XP_ABILITY_MAX;   break;
        case XP_TYPE_COMBAT:    nMin = XP_COMBAT_MIN;    nMax = XP_COMBAT_MAX;    break;
        case XP_TYPE_CRAFTING:  nMin = XP_CRAFTING_MIN;  nMax = XP_CRAFTING_MAX;  break;
        case XP_TYPE_DISCOVERY: nMin = XP_DISCOVERY_MIN; nMax = XP_DISCOVERY_MAX; break;
        case XP_TYPE_MAGIC:     nMin = XP_MAGIC_MIN;     nMax = XP_MAGIC_MAX;     break;
        default:                nMin = XP_GLOBAL_MIN;    nMax = XP_GLOBAL_MAX;    break;
    }

    if (nXP > nMax && nMax != 0)
        return nMax;
    if (nXP < nMin)
        return nMin;
    return nXP;
}

void xp_SendXPMessageToPC(object oPC, int nType, int bGain = TRUE)
{
    string sMessage;

    if (bGain)
        sMessage = XP_TEXT_GAIN;
    else
        sMessage = XP_TEXT_LOSS;

    switch (nType)
    {
        case XP_TYPE_ABILITY:   sMessage += XP_TEXT_ABILITY_XP;   break;
        case XP_TYPE_COMBAT:    sMessage += XP_TEXT_COMBAT_XP;    break;
        case XP_TYPE_CRAFTING:  sMessage += XP_TEXT_CRAFTING_XP;  break;
        case XP_TYPE_DISCOVERY: sMessage += XP_TEXT_DISCOVERY_XP; break;
        case XP_TYPE_MAGIC:     sMessage += XP_TEXT_MAGIC_XP;     break;
        case XP_TYPE_QUEST:     sMessage += XP_TEXT_QUEST_XP;     break;
        case XP_TYPE_ROLEPLAY:  sMessage += XP_TEXT_ROLEPLAY_XP;  break;
        default: sMessage = ""; break;
    }

    SendMessageToPC(oPC, sMessage);
}

void xp_SetGenericModifier(object oPC)
{
    int nCharLevel = xp_GetLevel(oPC);
    float fModifier = 1.0;

    if (XP_USE_LEVEL_MODIFIERS)
    {
        fModifier *= xp_GetLevelModifier(nCharLevel);
        SetLocalInt(oPC, XP_STORED_LEVEL, nCharLevel);
    }

    if (XP_USE_CLASS_MODIFIERS)
    {
        int nIndex = 1;
        float fPerc  = 0.0;
        int nClass = GetClassByPosition(1, oPC);
        int nLevel = GetLevelByPosition(1, oPC);

        while (nClass != CLASS_TYPE_INVALID)
        {
            nIndex++;
            fPerc += xp_GetClassModifier(nClass) * nLevel;
            nClass = GetClassByPosition(nIndex, oPC);
            nLevel = GetLevelByPosition(nIndex, oPC);
        }

        fPerc /= nCharLevel;
        fModifier *= fPerc;
    }

    if (XP_USE_RACE_MODIFIERS)
        fModifier *= xp_GetRacialModifier(GetRacialType(oPC));

    if (XP_USE_SUBRACE_MODIFIERS)
        fModifier *= xp_GetSubRaceModifier(GetSubRace(oPC));

    if (fModifier > 0.00)
        ss_SetDatabaseFloat(XP_PC_MODIFIER_GENERIC, fModifier, oPC);
    else
        ss_SetDatabaseFloat(XP_PC_MODIFIER_GENERIC, 1.00, oPC);
}

void xp_SetTypeModifier(object oPC, int nType)
{
    if (nType == XP_TYPE_GENERIC)
    {
        xp_SetGenericModifier(oPC);
        return;
    }
    else if (nType == XP_TYPE_QUEST || nType == XP_TYPE_ROLEPLAY)
    {
        SetLocalFloat(oPC, XP_PC_MODIFIER_PREFIX + IntToString(nType), 1.00);
        ss_SetDatabaseFloat(XP_PC_MODIFIER_PREFIX + IntToString(nType), 1.00, oPC);
        return;
    }

    float fTypeMod = xp_GetTypeModifier(nType);

    if (XP_USE_CLASS_TYPE_MODIFIERS)
    {
        float fClassMod = 0.0;
        int nCharLevel = xp_GetLevel(oPC);
        int nIndex = 1;
        int nClass = GetClassByPosition(nIndex, oPC);
        int nLevel = GetLevelByPosition(nIndex, oPC);

        while (nClass != CLASS_TYPE_INVALID)
        {
            nIndex++;
            fClassMod += xp_GetClassTypeModifier(nType, nClass) * nLevel;
            nClass = GetClassByPosition(nIndex, oPC);
            nLevel = GetLevelByPosition(nIndex, oPC);
        }

        fClassMod /= nCharLevel;
        fTypeMod *= fClassMod;
    }
    SetLocalFloat(oPC, XP_PC_MODIFIER_PREFIX + IntToString(nType), fTypeMod);
    ss_SetDatabaseFloat(XP_PC_MODIFIER_PREFIX + IntToString(nType), fTypeMod, oPC);
}

float xp_GetXPModifier(object oPC, int nType)
{
    return ss_GetDatabaseFloat(XP_PC_MODIFIER_PREFIX + IntToString(nType), oPC);
}


/********************************************/
/* Public Function Prototypes               */
/********************************************/

// Computes all persistent XP modifiers on oPC and stores them as local floats.
void xp_BuildXPModifiers(object oPC);

// Returns the persistent XP modifier of nType from oPC.
float xp_GetXPModifier(object oPC, int nType);

// Gives or sets oPC's, based on the setting in xp_core_c.
// Optional parameters:
// - nType: the type of XP to be given (default XP_TYPE_GENERIC).
//   Possible values:
//   - XP_TYPE_GENERIC: gives XP modified by normal settings.
//   - XP_TYPE_ABILITY: gives ability XP
//   - XP_TYPE_COMBAT: gives combat XP
//   - XP_TYPE_CRAFTING: gives crafting XP
//   - XP_TYPE_DISCOVERY: gives discovery XP
//   - XP_TYPE_MAGIC: gives magic XP
//   - XP_TYPE_QUEST: gives quest XP
//   - XP_TYPE_ROLEPLAY: gives role-play XP
//   - XP_TYPE_NONE: gives unmodified XP to the player
// - sMessage: A message to send to the player upon receipt of XP.
void xp_GiveXP(object oPC, int nXP, int nType = XP_TYPE_GENERIC, string sMessage = "");

// Awards discovery XP to oPC for discovering oDiscovered (usually an area or a
// trigger).
// Optional parameters:
// - oDiscovered: the object to be discovered. Defaults to OBJECT_SELF.
void xp_AwardDiscoveryXP(object oPC, object oDiscovered = OBJECT_SELF);

// Awards combat XP to oKiller's party for killing oDead.
void xp_AwardKillXP(object oDead, object oKiller);

// Awards ability XP to oPC for completing a skill of nDC against oTarget.
// Optional parameters:
// - oTarget: an object against which oPC made a successful check.
void xp_AwardSkillXP(object oPC, int nDC, object oTarget = OBJECT_INVALID);

// Persistently reduce XP gained from killing a creature like oTarget.
// Optional parameters:
// - sTag: the tag of an object. Leave blank if oTarget != OBJECT_INVALID
void xp_ReduceKillXP(object oPC, object oTarget, string sTag = "");


/********************************************/
/* Public Function Implementation           */
/********************************************/

void xp_BuildXPModifiers(object oPC)
{
    xp_SetGenericModifier(oPC);

    if (XP_USE_TYPE_MODIFIERS)
    {
        int nType = XP_TYPE_ABILITY;
        while (nType <= XP_TYPE_ROLEPLAY)
        {
            xp_SetTypeModifier(oPC, nType);
            nType++;
        }
    }
    ss_SetDatabaseInt(XP_MODIFIERS_INITIALIZED, TRUE, oPC);
}

void xp_GiveXP(object oPC, int nXP, int nType = XP_TYPE_GENERIC, string sMessage="")
{
    float fMod;
    string sDebug;
    int nCharLevel = xp_GetLevel(oPC);

    if (XP_USE_LEVEL_MODIFIERS && (nCharLevel > GetLocalInt(oPC, XP_STORED_LEVEL)))
        xp_SetGenericModifier(oPC);

    if (nType == XP_TYPE_GENERIC || nType == XP_TYPE_ROLEPLAY)
        fMod = xp_GetXPModifier(oPC, nType);
    else if (nType == XP_TYPE_NONE)
        fMod = 1.0;
    else
        fMod = xp_GetXPModifier(oPC, nType) * xp_GetXPModifier(oPC, XP_TYPE_GENERIC);

    nXP = xp_FixMinMaxXP(nXP, nType);
    sDebug += "Awarding " + IntToString(nXP) + " * " + FloatToString(fMod) + " = ";
    nXP = FloatToInt(nXP * fMod);
    sDebug += IntToString(nXP) + ".";
    ss_Debug(sDebug);

    if (nXP > 0)
    {
        if (sMessage != "")
            SendMessageToPC(oPC, sMessage);
        if (XP_USE_TYPE_MESSAGES)
            xp_SendXPMessageToPC(oPC, nType);
    }

    if (XP_USE_SETXP)
        SetXP(oPC, GetXP(oPC) + nXP);
    else
        GiveXPToCreature(oPC, nXP);
}

void xp_AwardDiscoveryXP(object oPC, object oDiscovered = OBJECT_SELF)
{
    float fMod = xp_GetObjectModifier(oDiscovered);
    int nBonus = xp_GetObjectBonus(oDiscovered);
    int nXP = FloatToInt(((XP_DISCOVERY_DEFAULT_AREA_EXPLORATION * fMod) + nBonus) * XP_MODIFIER_GLOBAL);

    xp_GiveXP(oPC, nXP, XP_TYPE_DISCOVERY);
}

void xp_AwardKillXP(object oDead, object oKiller)
{
    if (XP_MODIFIER_TYPE_COMBAT == 0.00)
        return;

    if (!GetIsObjectValid(oDead) || GetFactionEqual(oKiller, oDead))
        return;

    float fAvgLevel;
    float fDivisor;
    int nGroupSize;
    object oGroupMember = GetFirstFactionMember(oKiller, FALSE);

    while (GetIsObjectValid(oGroupMember))
    {
        if (xp_CheckDistance(oDead, oGroupMember) || oGroupMember == oKiller)
        {
            if (GetIsPC(oGroupMember))
            {
                nGroupSize++;
                fDivisor += XP_COMBAT_DIVISOR_PC;
                fAvgLevel += IntToFloat(xp_GetLevel(oGroupMember));
            }
            else
                fDivisor += xp_GetAssociateDivisor(oGroupMember);
        }
        oGroupMember = GetNextFactionMember(oKiller, FALSE);
    }

    if (nGroupSize == 0)
        return;

    fAvgLevel /= IntToFloat(nGroupSize);

    float fDistanceModifier, fCRModifier, fKillModifier, fFinalModifier, fPartyModifier;
    float fMemberLevel;
    float fCR = GetChallengeRating(oDead);
    float fCreatureModifier = xp_GetObjectModifier(oDead);
    float fCreatureBonus = IntToFloat(xp_GetObjectBonus(oDead, XP_TYPE_COMBAT));

    if (fCR > XP_COMBAT_CR_MAX)
        fCR = XP_COMBAT_CR_MAX;

    float fModCR = ((fCR * fCreatureModifier) + fCreatureBonus) * XP_MODIFIER_GLOBAL;

    oGroupMember = GetFirstFactionMember(oKiller, TRUE);
    while(oGroupMember != OBJECT_INVALID)
    {
        if (xp_CheckDistance(oDead, oGroupMember) || oGroupMember == oKiller)
        {
            fMemberLevel = IntToFloat(xp_GetLevel(oGroupMember));
            fDistanceModifier = xp_GetAveragePartyLevelDistanceModifier(fabs(fAvgLevel - fMemberLevel));
            fCRModifier = xp_GetCRDistanceModifier(fCR - fMemberLevel);
            fKillModifier  = xp_GetKillingBlowModifier(oGroupMember, oKiller);
            fPartyModifier = xp_GetPartyModifier(nGroupSize);
            fFinalModifier = fDistanceModifier * fCRModifier * fKillModifier * fPartyModifier;

            int nXP = FloatToInt((fModCR / fDivisor) * fFinalModifier);

            if (nXP > 0)
                xp_GiveXP(oGroupMember, nXP, XP_TYPE_COMBAT);

            xp_ReduceKillXP(oGroupMember, oDead);
        }
        oGroupMember = GetNextFactionMember(oKiller, TRUE);
    }
}

void xp_AwardSkillXP(object oPC, int nDC, object oTarget = OBJECT_INVALID)
{
    if (XP_MODIFIER_TYPE_ABILITY == 0.00)
        return;

    int nXP;
    int nBonus = xp_GetObjectBonus(oTarget, XP_TYPE_ABILITY);
    float fMod = xp_GetObjectModifier(oTarget, XP_TYPE_ABILITY);

    nXP = (nDC - 15) * XP_ABILITY_DEFAULT_XP;
    nXP = FloatToInt((FloatToInt(nXP * fMod) + nBonus) * XP_MODIFIER_GLOBAL);

    if (nXP > 0)
        xp_GiveXP(oPC, nXP, XP_TYPE_ABILITY);
}

void xp_ReduceKillXP(object oPC, object oTarget, string sTag = "")
{
    if (GetIsObjectValid(oTarget))
        sTag = GetTag(oTarget);

    if (sTag == "")
        return;

    float fMod = ss_GetDatabaseFloat(XP_COMBAT_REDUCTION_PREFIX + sTag, oPC);
    fMod += XP_COMBAT_REDUCTION_PER_KILL;

    if (fMod > XP_COMBAT_REDUCTION_PER_KILL_MAXIMUM)
        fMod = XP_COMBAT_REDUCTION_PER_KILL_MAXIMUM;

    ss_SetDatabaseFloat(XP_COMBAT_REDUCTION_PREFIX + sTag, fMod, oPC);
}
