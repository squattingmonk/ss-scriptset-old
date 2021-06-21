/*
Filename:           g_i_generic
System:             Generic (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7, 2009
Summary:
Generic system include script. This file holds the functions and constants
commonly used throughout the generic system.

Most of the constants herein are tags of creatures, items, and waypoints. There
are also names of conversations and scripts. These are here for easy reference
from other scripts.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Core include script
#include "ss_i_core"

// Configuration include script
#include "g_c_generic"

// Generic constants include script
#include "g_i_constants"


/******************************************************************************/
/*                             Global Variables                               */
/******************************************************************************/
object oTokenHolder = GetObjectByTag(SS_TOKENHOLDER);
object o2DACache    = GetObjectByTag(SS_2DA_CACHE);


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// >-------< Action >-------<
// <g_i_generic>
// A very neat way to use functions such as CreateObject as actions
// Use: Action(CreateObject(...))
void Action(object oObject);

// >-------< ss_GetPC >-------<
// <g_i_generic>
// Returns the nNth PC in the module, including DMs if bIncludeDMs is TRUE.
object ss_GetPC(int nNth = 0, int bIncludeDMs = FALSE);

// >----< ss_GetLevelByXP >----<
// <g_i_generic>
// Returns the level of a character with nXP
int ss_GetLevelByXP(int nXP);

// >----< ss_GetLevel >----<
// <g_i_generic>
// Returns the level of oPC.
int ss_GetLevel(object oPC);

// >----< ss_GetXPByLevel >----<
// <g_i_generic>
// Returns the XP required for nLevel
int ss_GetXPByLevel(int nLevel);

// >----< ss_GetIsLocationValid >----<
// <g_i_generic>
// Returns TRUE if lLocation is a valid location
int ss_GetIsLocationValid(location lLocation);

// >----< ss_GetNearestValidLocation >----<
// <g_i_generic>
// Returns the nearest valid location (Where a creature can be placed) to lLocation
location ss_GetNearestValidLocation(location lLocation);

// >-------< ss_ToggleEncountersInArea >-------<
// <g_i_generic>
// Toggle all encounters in oArea On/Off (TRUE/FALSE)
void ss_ToggleEncountersInArea(object oArea, int bActive);

// >-------< ss_GetIsPCInArea >-------<
// <g_i_generic>
// Returns TRUE if there is at least 1 PC in oArea.
int ss_GetIsPCInArea(object oArea = OBJECT_SELF);

// >-------< ss_Random >-------<
// <g_i_generic>
// Improved version of the Random function, uses milliseconds as seed.
// Get an integer between 0 and nMaxInteger-1.
// Return value on error: 0
int ss_Random(int nMaxInteger);

// >----< ss_GetSpellLevel >----<
// <g_i_generic>
// Returns spell level for the spell ID
// Different classes might have differnt levels of the same spell
// For innate spell level leave the class field empty.
// Return value on invalid SpellID = -1.
int ss_GetSpellLevel(int nSpellID, int nCasterClass = -1);

// >----< ss_GetCasterFocusAbility >----<
// <g_i_generic>
// Returns the ABILITY_* of the caster used to cast the last spell
int ss_GetCasterFocusAbility(object oCaster);

// >----< ss_ItemProperty >----<
// <g_i_generic>
// Generates an itemproperty. Like IPGetItemPropertyByID, but complete and bugfree.
// For the values to be passed as nParam*, check the IP's function (ItemProperty*)
itemproperty ss_ItemProperty(int nPropID, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, int nParam4 = 0);

// >----< ss_ReadFlavorText >----<
// <g_i_generic>
// Reads the flavor text set on oObject to oPC.
void ss_ReadFlavorText(object oObject, object oPC);

// >-------< ss_GetItemCount >-------<
// <ss_i_generic>
// returns the number of items in oTarget's inventory.
int ss_GetItemCount(object oTarget);

// >-------< ss_GetRandomLocation >-------<
// <ss_i_generic>
// Returns a random location in oArea
location ss_GetRandomLocation(object oArea = OBJECT_SELF, int bNoZ = TRUE);

// >-------< ss_GetItemEquipSlot >-------<
// <ss_i_generic>
// Returns the inventory slot in which you can equip oItem
// In case of rings and weapons, it favors the left hand
// Returns -1 if the item can't be equiped.
int ss_GetItemEquipSlot(object oItem);

// >-------< ss_SkillCheck >-------<
// <ss_i_generic>
// Returns oUser's check of nSkill and broacasts the results.
// Optional parameters:
// - nBoradcastLevel: who to broadcast the roll to.
//   Possible values:
//   - 0: DMs only.
//   - 1: DMs and the player only.
//   - 2: DMs and floating text on the player.
int ss_SkillCheck(int nSkill, object oUser, int nBroadcastLevel = 1);

// >-------< ss_GetTerrainEffect >-------<
// <ss_i_generic>
// Returns the terrain effect of oTrigger.
effect ss_GetTerrainEffect(object oTrigger);

// >-------< ss_GetTerrainEffect >-------<
// <ss_i_generic>
// Returns the TRUE if oPC is recognized as a member of the design team. If
// bIncludeDMs is TRUE, it works for DMs even if they are possessing a creature.
int ss_GetIsTeamMember(object oPC, int bIncludeDMs = TRUE);


// >-------< ss_SendMessageToTeam >-------<
// <ss_i_generic>
// Sends a message to the DMs and all players with the team token item.
void ss_SendMessageToTeam(string sMessage, string sColor);

// >----< ss_SetCustomToken >----<
// <g_i_generic>
// Improved version of SetCustomToken. Allows for retrieviing with ss_GetCustomToken
void ss_SetCustomToken(int nCustomTokenNumber, string sTokenValue);

// >----< ss_GetCustomToken >----<
// <g_i_generic>
// Returns the Custom Token set by ss_SetCustomToken.
string ss_GetCustomToken(int nCustomTokenNumber);

// >----< ss_RemoveEffectType >----<
// <g_i_generic>
//Will remove an effect of type nEffectType and nSubType from oTarget.
//  nEffectType is the constant EFFECT_TYPE_*
//      Using -1 instead of EFFECT_TYPE_* and setting bAll to TRUE
//      will allow the removal of all effects of nSubType
//  nSubType is the constant SUBTYPE_*
//  bAll determines whether all effects of the type will be removed
void ss_RemoveEffectType(object oTarget, int nEffectType, int nSubType = SUBTYPE_MAGICAL, int bAll = FALSE);

// >----< ss_Get2DAString >----<
// <g_i_generic>
// More powerful version of Get2DAString. Caches it's reads, so it'll be more performant.
string ss_Get2DAString(string s2DA, string sColumn, int nRow, int bCache = TRUE);

// >----< ss_HexStringToInt >----<
// <g_i_generic>
// Converts a hexadecimal string into a decimal integer.
int ss_HexStringToInt(string sHex);

// >----< ss_GetEncumberanceLevel >----<
// <g_i_generic>
// Returns 2 on Heavy Encumberence, 1 on Normal, and 0 on no.
int ss_GetEncumberanceLevel(object oPC = OBJECT_SELF);

// >----< ss_SetArrayInt >----<
// <g_i_generic>
// Sets an int of sVarName with nValue on oObject.
// Optional parameters:
// - nIndex: the numeric identifier of the array value. If 0, the next empty
//   index in the array will be used.
// - sKey: a string to associate with the array value.
// - oObject: the object to set the array value on. If invalid, the global data
//   point is used instead.
// Example array usage:
// - I want to store information on an NPC telling how much gold and XP to give
//   out for different quest items that may be brought to him. I will make
//   sVarName = QUEST_ITEM, let nIndex be the number of the item he's looking
//   for (starting from 1 and going up), make sKey be GP or XP, and make nValue
//   be the amount of GP or XP that will be gained. If I want to give 10 GP and
//   XP for the first item and 20 GP and 15 XP for the second item, I'd make the
//   functions like so:
//   - ss_SetArrayInt("QUEST_ITEM", 10, 1, "GP", oNPC);
//   - ss_SetArrayInt("QUEST_ITEM", 10, 1, "XP", oNPC);
//   - ss_SetArrayInt("QUEST_ITEM", 20, 2, "GP", oNPC);
//   - ss_SetArrayInt("QUEST_ITEM", 15, 2, "XP", oNPC);
//   And my output would look like this:
//   - QUEST_ITEM_1_GP int 10
//   - QUEST_ITEM_1_XP int 10
//   - QUEST_ITEM_2_GP int 20
//   - QUEST_ITEM_2_XP int 15
void ss_SetArrayInt(string sVarName, int nValue, int nIndex = 0, string sKey = "", object oObject = OBJECT_INVALID);












/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

void Action(object oObject)
{  }

int ss_GetLevelByXP (int nXP)
{
    float fXP    = IntToFloat(nXP)/100;
    float fLevel = (sqrt(8*fXP+1) + 1)/2;
    int   nLevel = FloatToInt(fLevel);
    return nLevel;
}

object ss_GetPC(int nNth = 0, int bIncludeDMs = FALSE)
{
    object oPC = GetFirstPC();
    int nIndex;

    while (nIndex < nNth)
    {
        oPC = GetNextPC();
        nIndex++;
    }

    if (GetIsDM(oPC) && !bIncludeDMs)
        oPC = GetNextPC();

    return oPC;
}

int ss_GetLevel (object oPC)
{
    int   nXP    = GetXP(oPC);
    float fXP    = IntToFloat(nXP)/100;
    float fLevel = (sqrt(8*fXP+1) + 1)/2;
    int   nLevel = FloatToInt(fLevel);

    return nLevel;
}

int ss_GetXPByLevel(int nLevel)
{
    int nXP = (((nLevel - 1)*nLevel)/2)*1000;
    return nXP;
}

int ss_GetIsLocationValid(location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    vector V     = GetPositionFromLocation(lLocation);
    if (oArea == OBJECT_INVALID || V.x < 0.0 || V.y < 0.0) return FALSE;
    return TRUE;

}

location ss_GetNearestValidLocation(location lLocation)
{
    object oNPC = ss_GetGlobalObject(SS_RESREF_NPC);
    location lStart = GetStartingLocation();

    if (!GetIsObjectValid(oNPC))
    {
        oNPC = GetObjectByTag(SS_RESREF_NPC);
        if (!GetIsObjectValid(oNPC))
            oNPC = CreateObject(OBJECT_TYPE_CREATURE, SS_RESREF_NPC, lStart);

        ss_SetGlobalObject(SS_RESREF_NPC, oNPC);
    }
    AssignCommand(oNPC, ActionJumpToLocation(lLocation));
    lLocation = GetLocation(oNPC);
    AssignCommand(oNPC, ActionJumpToLocation(lStart));
    return lLocation;
}

void ss_ToggleEncountersInArea(object oArea, int bActive)
{
    object oEncounter = GetFirstInPersistentObject(oArea, OBJECT_TYPE_ENCOUNTER);
    while (oEncounter != OBJECT_INVALID)
    {
         SetEncounterActive(bActive, oEncounter);
         oEncounter = GetNextInPersistentObject(oArea, OBJECT_TYPE_ENCOUNTER);
    }
}

int ss_GetIsPCInArea(object oArea = OBJECT_SELF)
{
    // this is a fast way to check for players without using a loop
    object oPC = GetFirstObjectInArea(oArea);
    if(!GetIsPC(oPC)) oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oPC);

    if (GetIsPC(oPC)) return TRUE;
    return FALSE;
}

int ss_Random(int nMaxInteger)
{
    return (GetTimeMillisecond() + Random(nMaxInteger)) % nMaxInteger;
}

int ss_GetSpellLevel(int nSpellID, int nCasterClass = -1)
{
    string sColumn;
    string s2DA="spells";

    switch (nCasterClass)
    {
       case CLASS_TYPE_BARD: sColumn="Bard";         break;
       case CLASS_TYPE_CLERIC: sColumn="Cleric";     break;
       case CLASS_TYPE_DRUID: sColumn="Druid";       break;
       case CLASS_TYPE_PALADIN: sColumn="Paladin";   break;
       case CLASS_TYPE_RANGER: sColumn="Ranger";     break;
       case CLASS_TYPE_WIZARD:
       case CLASS_TYPE_SORCERER:       // Wizards and Sorcerers use the same column.
                                sColumn="Wiz_Sorc";  break;
       default: sColumn="Innate";                    break;
       }

    string sLevel = Get2DAString(s2DA, sColumn, nSpellID);
    if (sLevel=="") return -1;
    else return StringToInt(sLevel);
}

int ss_GetCasterFocusAbility(object oCaster)
{

    int nClass = GetLastSpellCastClass();
    int nAbility = -1;

    // I might have forgotten a class, safeguard added to let the DMs know. :)
    switch (nClass)
    {
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_PALEMASTER: nAbility = ABILITY_INTELLIGENCE; break;

        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_SHIFTER:
        case CLASS_TYPE_DIVINE_CHAMPION:
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_PALADIN: nAbility = ABILITY_WISDOM; break;

        case CLASS_TYPE_BARD:
        case CLASS_TYPE_DRAGON_DISCIPLE:
        case CLASS_TYPE_SORCERER: nAbility = ABILITY_CHARISMA; break;
    }
    if (nAbility == -1) SendMessageToAllDMs("<cœ99> ss_GetCasterFocusAbility is missing a caster class. (Class ID: " + IntToString(nClass) + ")</c>");

    return nAbility;
}

itemproperty ss_ItemProperty(int nPropID, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, int nParam4 = 0)
{
    itemproperty ip;

    // Commented out lines means that such itemproperty doesn't exist, and the constant was not removed from nwscript.nss

    switch(nPropID)
    {
        case ITEM_PROPERTY_ABILITY_BONUS:                            ip = ItemPropertyAbilityBonus(nParam1, nParam2);                       break;
        case ITEM_PROPERTY_AC_BONUS:                                 ip = ItemPropertyACBonus(nParam1);                                     break;
        case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:              ip = ItemPropertyACBonusVsAlign(nParam1, nParam2);                     break;
        case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:                  ip = ItemPropertyACBonusVsDmgType(nParam1, nParam2);                   break;
        case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:                 ip = ItemPropertyACBonusVsRace(nParam1, nParam2);                      break;
        case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:           ip = ItemPropertyACBonusVsSAlign(nParam1, nParam2);                    break;
        case ITEM_PROPERTY_ADDITIONAL:                               ip = ItemPropertyAdditional(nParam1);                                  break;
        case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:                     ip = ItemPropertyArcaneSpellFailure(nParam1);                          break;
        case ITEM_PROPERTY_ATTACK_BONUS:                             ip = ItemPropertyAttackBonus(nParam1);                                 break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:          ip = ItemPropertyAttackBonusVsAlign(nParam1, nParam2);                 break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:             ip = ItemPropertyAttackBonusVsRace(nParam1, nParam2);                  break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:       ip = ItemPropertyAttackBonusVsSAlign(nParam1, nParam2);                break;
        case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:               ip = ItemPropertyWeightReduction(nParam1);                             break;
        case ITEM_PROPERTY_BONUS_FEAT:                               ip = ItemPropertyBonusFeat(nParam1);                                   break;
        case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:              ip = ItemPropertyBonusLevelSpell(nParam1, nParam2);                    break;
        case ITEM_PROPERTY_CAST_SPELL:                               ip = ItemPropertyCastSpell(nParam1, nParam2);                          break;
        case ITEM_PROPERTY_DAMAGE_BONUS:                             ip = ItemPropertyDamageBonus(nParam1, nParam2);                        break;
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:          ip = ItemPropertyDamageBonusVsAlign(nParam1, nParam2, nParam3);        break;
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:             ip = ItemPropertyDamageBonusVsRace(nParam1, nParam2, nParam3);         break;
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:       ip = ItemPropertyDamageBonusVsSAlign(nParam1, nParam2, nParam3);       break;
        case ITEM_PROPERTY_DAMAGE_REDUCTION:                         ip = ItemPropertyDamageReduction(nParam1, nParam2);                    break;
        case ITEM_PROPERTY_DAMAGE_RESISTANCE:                        ip = ItemPropertyDamageResistance(nParam1, nParam2);                   break;
        case ITEM_PROPERTY_DAMAGE_VULNERABILITY:                     ip = ItemPropertyDamageVulnerability(nParam1, nParam2);                break;
        case ITEM_PROPERTY_DARKVISION:                               ip = ItemPropertyDarkvision();                                         break;
        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:                  ip = ItemPropertyDecreaseAbility(nParam1, nParam2);                    break;
        case ITEM_PROPERTY_DECREASED_AC:                             ip = ItemPropertyDecreaseAC(nParam1, nParam2);                         break;
        case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:                ip = ItemPropertyAttackPenalty(nParam1);                               break;
        case ITEM_PROPERTY_DECREASED_DAMAGE:                         ip = ItemPropertyDamagePenalty(nParam1);                               break;
        case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:           ip = ItemPropertyEnhancementPenalty(nParam1);                          break;
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS:                  ip = ItemPropertyReducedSavingThrow(nParam1, nParam2);                 break;
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:         ip = ItemPropertyReducedSavingThrowVsX(nParam1, nParam2);              break;
        case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:                 ip = ItemPropertyDecreaseSkill(nParam1, nParam2);                      break;
        case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:        ip = ItemPropertyContainerReducedWeight(nParam1);                      break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:                        ip = ItemPropertyEnhancementBonus(nParam1);                            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:     ip = ItemPropertyEnhancementBonusVsAlign(nParam1, nParam2);            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:        ip = ItemPropertyEnhancementBonusVsRace(nParam1, nParam2);             break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT: ip = ItemPropertyEnhancementBonusVsSAlign(nParam1, nParam2);           break;
        case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:                  ip = ItemPropertyExtraMeleeDamageType(nParam1);                        break;
        case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:                 ip = ItemPropertyExtraRangeDamageType(nParam1);                        break;
        case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:                      ip = ItemPropertyFreeAction();                                         break;
        case ITEM_PROPERTY_HASTE:                                    ip = ItemPropertyHaste();                                              break;
        case ITEM_PROPERTY_HEALERS_KIT:                              ip = ItemPropertyHealersKit(nParam1);                                  break;
        case ITEM_PROPERTY_HOLY_AVENGER:                             ip = ItemPropertyHolyAvenger();                                        break;
        case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:                     ip = ItemPropertyDamageImmunity(nParam1, nParam2);                     break;
        case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:                   ip = ItemPropertyImmunityMisc(nParam1);                                break;
        case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:                  ip = ItemPropertySpellImmunitySpecific(nParam1);                       break;
        case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:                    ip = ItemPropertySpellImmunitySchool(nParam1);                         break;
        case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:                 ip = ItemPropertyImmunityToSpellLevel(nParam1);                        break;
        case ITEM_PROPERTY_IMPROVED_EVASION:                         ip = ItemPropertyImprovedEvasion();                                    break;
        case ITEM_PROPERTY_KEEN:                                     ip = ItemPropertyKeen();                                               break;
        case ITEM_PROPERTY_LIGHT:                                    ip = ItemPropertyLight(nParam1, nParam2);                              break;
        case ITEM_PROPERTY_MASSIVE_CRITICALS:                        ip = ItemPropertyMassiveCritical(nParam1);                             break;
        case ITEM_PROPERTY_MATERIAL:                                 ip = ItemPropertyMaterial(nParam1);                                    break;
        case ITEM_PROPERTY_MIGHTY:                                   ip = ItemPropertyMaxRangeStrengthMod(nParam1);                         break;
//      case ITEM_PROPERTY_MIND_BLANK:                                                                                                      break;
        case ITEM_PROPERTY_MONSTER_DAMAGE:                           ip = ItemPropertyMonsterDamage(nParam1);                               break;
        case ITEM_PROPERTY_NO_DAMAGE:                                ip = ItemPropertyNoDamage();                                           break;
        case ITEM_PROPERTY_ON_HIT_PROPERTIES:                        ip = ItemPropertyOnHitProps(nParam1, nParam2, nParam3);                break;
        case ITEM_PROPERTY_ON_MONSTER_HIT:                           ip = ItemPropertyOnMonsterHitProperties(nParam1, nParam2);             break;
        case ITEM_PROPERTY_ONHITCASTSPELL:                           ip = ItemPropertyOnHitCastSpell(nParam1, nParam2);                     break;
//      case ITEM_PROPERTY_POISON:                                                                                                          break;
        case ITEM_PROPERTY_QUALITY:                                  ip = ItemPropertyQuality(nParam1);                                     break;
        case ITEM_PROPERTY_REGENERATION:                             ip = ItemPropertyRegeneration(nParam1);                                break;
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:                    ip = ItemPropertyVampiricRegeneration(nParam1);                        break;
        case ITEM_PROPERTY_SAVING_THROW_BONUS:                       ip = ItemPropertyBonusSavingThrow(nParam1, nParam2);                   break;
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:              ip = ItemPropertyBonusSavingThrowVsX(nParam1, nParam2);                break;
        case ITEM_PROPERTY_SKILL_BONUS:                              ip = ItemPropertySkillBonus(nParam1, nParam2);                         break;
        case ITEM_PROPERTY_SPECIAL_WALK:                             ip = ItemPropertySpecialWalk(nParam1);                                 break;
        case ITEM_PROPERTY_SPELL_RESISTANCE:                         ip = ItemPropertyBonusSpellResistance(nParam1);                        break;
        case ITEM_PROPERTY_THIEVES_TOOLS:                            ip = ItemPropertyThievesTools(nParam1);                                break;
        case ITEM_PROPERTY_TRAP:                                     ip = ItemPropertyTrap(nParam1, nParam2);                               break;
        case ITEM_PROPERTY_TRUE_SEEING:                              ip = ItemPropertyTrueSeeing();                                         break;
        case ITEM_PROPERTY_TURN_RESISTANCE:                          ip = ItemPropertyTurnResistance(nParam1);                              break;
        case ITEM_PROPERTY_UNLIMITED_AMMUNITION:                     ip = ItemPropertyUnlimitedAmmo(nParam1);                               break;
        case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:           ip = ItemPropertyLimitUseByAlign(nParam1);                             break;
        case ITEM_PROPERTY_USE_LIMITATION_CLASS:                     ip = ItemPropertyLimitUseByClass(nParam1);                             break;
        case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:               ip = ItemPropertyLimitUseByRace(nParam1);                              break;
        case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:        ip = ItemPropertyLimitUseBySAlign(nParam1);                            break;
//      case ITEM_PROPERTY_USE_LIMITATION_TILESET:                                                                                          break;
        case ITEM_PROPERTY_VISUALEFFECT:                             ip = ItemPropertyVisualEffect(nParam1);                                break;
        case ITEM_PROPERTY_WEIGHT_INCREASE:                          ip = ItemPropertyWeightIncrease(nParam1);                              break;

        default:            break;
    }

    return ip;
}

int ss_GetDayPeriod()
{
    if (GetIsNight())
        return SS_NIGHT;
    else if (GetIsDawn())
        return SS_DAWN;
    else if (GetIsDusk())
        return SS_DUSK;
    else
        return SS_DAY;

}

void ss_ReadFlavorText(object oPC, object oObject)
{
    string sText;
    string sPrefix;

    int nPeriod = ss_GetDayPeriod();
    switch (nPeriod)
    {
        case SS_DAY:   sPrefix = SS_FLAVOR_TEXT_DAY;   break;
        case SS_NIGHT: sPrefix = SS_FLAVOR_TEXT_NIGHT; break;
        case SS_DAWN:  sPrefix = SS_FLAVOR_TEXT_DAWN;  break;
        case SS_DUSK:  sPrefix = SS_FLAVOR_TEXT_DUSK;  break;
    }

    // Check if the time of day has valid text or if a conversation should start instead
    sText = GetLocalString(oObject, sPrefix);
    if (sText == "")
    {
        sPrefix = SS_FLAVOR_TEXT;
        sText = GetLocalString(oObject, sPrefix);

        if (sText == "")
            return;
    }

    // If it is meant to run only once per PC, check if the PC has already tripped the event
    if (GetLocalInt(oObject, sPrefix + SS_FLAVOR_TEXT_ONCE_PER_PC))
    {
        string sPCID = ss_GetPlayerString(oPC, SS_PCID);
        if (GetLocalInt(oObject, sPrefix + sPCID))
            return;
        SetLocalInt(oObject, sPrefix + sPCID, TRUE);
    }

    // Apply color effects
    string sRGB  = GetLocalString(oObject, sPrefix + SS_FLAVOR_TEXT_RGB);
    sText = StringToRGBString(sText, sRGB);

    // Send the message to the PC
    FloatingTextStringOnCreature(sText, oPC, FALSE);
}


// >-------< ss_GetItemCount >-------<
// <ss_i_generic>
// returns the number of items in oTarget's inventory.
int ss_GetItemCount(object oTarget)
{
    int i = 0;
    object oItem = GetFirstItemInInventory(oTarget);

    while (oItem != OBJECT_INVALID)
    {
       i++;
       oItem = GetNextItemInInventory(oTarget);
    }

    return i;
}

location ss_GetRandomLocation(object oArea = OBJECT_SELF, int bNoZ = TRUE)
{
   int nAreaH = GetAreaSize(AREA_HEIGHT, oArea);
   int nAreaW = GetAreaSize(AREA_WIDTH, oArea);

   float fX = IntToFloat(ss_Random(10*nAreaH)+1);
   float fY = IntToFloat(ss_Random(10*nAreaW)+1);
   float fZ = 0.0f;
     if (bNoZ != TRUE) fZ = IntToFloat(ss_Random(21)-10);

   vector vPosition = Vector(fX, fY, fZ);

   float fOrientation = IntToFloat(ss_Random(360));

   return Location(oArea, vPosition , fOrientation);
}

int ss_GetItemEquipSlot(object oItem)
{
     int nSlot;
     switch (GetBaseItemType(oItem))
     {
        case BASE_ITEM_AMULET:
          nSlot = INVENTORY_SLOT_NECK;
          break;
        case BASE_ITEM_ARMOR:
          nSlot = INVENTORY_SLOT_CHEST;
          break;
        case BASE_ITEM_ARROW:
          nSlot = INVENTORY_SLOT_ARROWS;
          break;
        case BASE_ITEM_BASTARDSWORD:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_BATTLEAXE:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_BELT:
          nSlot = INVENTORY_SLOT_BELT;
          break;
        case BASE_ITEM_BOLT:
          nSlot = INVENTORY_SLOT_BOLTS;
          break;
        case BASE_ITEM_BOOTS:
          nSlot = INVENTORY_SLOT_BOOTS;
          break;
        case BASE_ITEM_BRACER:
          nSlot = INVENTORY_SLOT_ARMS;
          break;
        case BASE_ITEM_BULLET:
          nSlot = INVENTORY_SLOT_BULLETS;
          break;
        case BASE_ITEM_CLOAK:
          nSlot = INVENTORY_SLOT_CLOAK;
          break;
        case BASE_ITEM_CLUB:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_DAGGER:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_DART:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_DIREMACE:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_DOUBLEAXE:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_GLOVES:
          nSlot = INVENTORY_SLOT_ARMS;
          break;
        case BASE_ITEM_GREATAXE:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_GREATSWORD:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_HALBERD:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_HANDAXE:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_HEAVYCROSSBOW:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_HEAVYFLAIL:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_HELMET:
          nSlot = INVENTORY_SLOT_HEAD;
          break;
        case BASE_ITEM_KAMA:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_KATANA:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_KUKRI:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_LARGESHIELD:
          nSlot = INVENTORY_SLOT_LEFTHAND;
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_LIGHTFLAIL:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_LIGHTHAMMER:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_LIGHTMACE:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_LONGBOW:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_LONGSWORD:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_MAGICSTAFF:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_MORNINGSTAR:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_QUARTERSTAFF:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_RAPIER:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_RING:
          nSlot = INVENTORY_SLOT_RIGHTRING;
          break;
        case BASE_ITEM_SCIMITAR:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_SCYTHE:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_SHORTBOW:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_SHORTSPEAR:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_SHORTSWORD:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_SHURIKEN:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_SICKLE:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_SLING:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_SMALLSHIELD:
          nSlot = INVENTORY_SLOT_LEFTHAND;
          break;
        case BASE_ITEM_THROWINGAXE:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;
        case BASE_ITEM_TORCH:
          nSlot = INVENTORY_SLOT_LEFTHAND;
          break;
        case BASE_ITEM_TOWERSHIELD:
          nSlot = INVENTORY_SLOT_LEFTHAND;
          break;
        case BASE_ITEM_TWOBLADEDSWORD:
          nSlot = INVENTORY_SLOT_RIGHTHAND;
          break;

        default: nSlot = -1; break;
     }

     return nSlot;
}

int ss_SkillCheck(int nSkill, object oUser, int nBroadcastLevel = 1)
{
    int nRank = GetSkillRank(nSkill, oUser);
    int nRoll = d20();
    string sSkill;
    switch (nSkill)
    {
        case SKILL_ANIMAL_EMPATHY:   sSkill = SS_TEXT_SKILL_ANIMAL_EMPATHY;   break;
        case SKILL_APPRAISE:         sSkill = SS_TEXT_SKILL_APPRAISE;         break;
        case SKILL_BLUFF:            sSkill = SS_TEXT_SKILL_BLUFF;            break;
        case SKILL_CONCENTRATION:    sSkill = SS_TEXT_SKILL_CONCENTRATION;    break;
        case SKILL_CRAFT_ARMOR:      sSkill = SS_TEXT_SKILL_CRAFT_ARMOR;      break;
        case SKILL_CRAFT_TRAP:       sSkill = SS_TEXT_SKILL_CRAFT_TRAP;       break;
        case SKILL_CRAFT_WEAPON:     sSkill = SS_TEXT_SKILL_CRAFT_WEAPON;     break;
        case SKILL_DISABLE_TRAP:     sSkill = SS_TEXT_SKILL_DISABLE_TRAP;     break;
        case SKILL_DISCIPLINE:       sSkill = SS_TEXT_SKILL_DISCIPLINE;       break;
        case SKILL_HEAL:             sSkill = SS_TEXT_SKILL_HEAL;             break;
        case SKILL_HIDE:             sSkill = SS_TEXT_SKILL_HIDE;             break;
        case SKILL_INTIMIDATE:       sSkill = SS_TEXT_SKILL_INTIMIDATE;       break;
        case SKILL_LISTEN:           sSkill = SS_TEXT_SKILL_LISTEN;           break;
        case SKILL_LORE:             sSkill = SS_TEXT_SKILL_LORE;             break;
        case SKILL_MOVE_SILENTLY:    sSkill = SS_TEXT_SKILL_MOVE_SILENTLY;    break;
        case SKILL_OPEN_LOCK:        sSkill = SS_TEXT_SKILL_OPEN_LOCK;        break;
        case SKILL_PARRY:            sSkill = SS_TEXT_SKILL_PARRY;            break;
        case SKILL_PERFORM:          sSkill = SS_TEXT_SKILL_PERFORM;          break;
        case SKILL_PERSUADE:         sSkill = SS_TEXT_SKILL_PERSUADE;         break;
        case SKILL_PICK_POCKET:      sSkill = SS_TEXT_SKILL_PICK_POCKET;      break;
        case SKILL_RIDE:             sSkill = SS_TEXT_SKILL_RIDE;             break;
        case SKILL_SEARCH:           sSkill = SS_TEXT_SKILL_SEARCH;           break;
        case SKILL_SET_TRAP:         sSkill = SS_TEXT_SKILL_SET_TRAP;         break;
        case SKILL_SPELLCRAFT:       sSkill = SS_TEXT_SKILL_SPELLCRAFT;       break;
        case SKILL_SPOT:             sSkill = SS_TEXT_SKILL_SPOT;             break;
        case SKILL_TAUNT:            sSkill = SS_TEXT_SKILL_TAUNT;            break;
        case SKILL_TUMBLE:           sSkill = SS_TEXT_SKILL_TUMBLE;           break;
        case SKILL_USE_MAGIC_DEVICE: sSkill = SS_TEXT_SKILL_USE_MAGIC_DEVICE; break;
    }

    if (nBroadcastLevel > 0)
    {
        string sMessage = GetName(oUser) + " " + sSkill + SS_TEXT_SKILL_CHECK + IntToString(nRoll) +
                            " + " + IntToString(nRank) + " = " + IntToString(nRoll + nRank);
        SendMessageToAllDMs(sMessage);
        if (nBroadcastLevel == 1)
            SendMessageToPC(oUser, sMessage);
        else if (nBroadcastLevel == 2)
            FloatingTextStringOnCreature(sMessage, oUser);
    }

    return nRank + nRoll;
}

effect ss_GetTerrainEffect(object oTrigger)
{
    // Single integer for all GetLocalInt functions.
    int nValue;

    effect eSpeed;
    effect eArmorClass;
    effect eAttackBonus;
    effect eDamageBonus;
    effect eDexBonus;
    effect eSaveUniversal;
    effect eSaveWill;
    effect eSaveReflex;
    effect eSaveFortitude;
    effect eSkillHide;
    effect eSkillMoveSilently;
    effect eSkillDiscipline;
    effect eSkillListen;
    effect eSkillSpot;
    effect eSkillSearch;
    effect eSkillTumble;
    effect eSkillRide;
    effect eSkillConcentration;
    effect eSkillParry;
    effect eSkillSpellcraft;
    effect eSpellFailure;
    effect eSpellResistance;
    effect eConcealment;
    effect eDamageReduction;
    effect eMissChance;
    effect eRegenerate;
    effect eHaste;
    effect eSlow;
    effect eLink;


    // Speed
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SPEED);
    if (nValue > 0) eSpeed = EffectMovementSpeedIncrease(nValue);
    else eSpeed = EffectMovementSpeedDecrease(-nValue);

    // Armor Class
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_ARMOR_CLASS);
    if (nValue > 0) eArmorClass = EffectACIncrease(nValue);
    else eArmorClass = EffectACDecrease(-nValue);

    // Attack Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_ATTACK_BONUS);
    if (nValue > 0) eAttackBonus = EffectAttackIncrease(nValue);
    else eAttackBonus = EffectAttackDecrease(-nValue);

    // Damage Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_DAMAGE_BONUS);
    if (nValue > 0) eDamageBonus = EffectDamageIncrease(nValue, DAMAGE_TYPE_BASE_WEAPON);
    else eDamageBonus = EffectDamageDecrease(-nValue, DAMAGE_TYPE_BASE_WEAPON);

    // Dexterity Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_DEX_BONUS);
    if (nValue > 0) eDexBonus = EffectAbilityIncrease(ABILITY_DEXTERITY, nValue);
    else eDexBonus = EffectAbilityDecrease(ABILITY_DEXTERITY, -nValue);

    // Universal Save Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SAVE_UNIVERSAL);
    if (nValue > 0) eSaveUniversal = EffectSavingThrowIncrease(SAVING_THROW_ALL, nValue);
    else eSaveUniversal = EffectSavingThrowDecrease(SAVING_THROW_ALL, -nValue);

    // Will Save Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SAVE_WILL);
    if (nValue > 0) eSaveWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, nValue);
    else eSaveWill = EffectSavingThrowDecrease(SAVING_THROW_WILL, -nValue);

    // Reflex Save Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SAVE_REFLEX);
    if (nValue > 0) eSaveReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nValue);
    else eSaveReflex = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, -nValue);

    // Fortitude Save Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SAVE_FORTITUDE);
    if (nValue > 0) eSaveFortitude = EffectSavingThrowIncrease(SAVING_THROW_FORT, nValue);
    else eSaveFortitude = EffectSavingThrowDecrease(SAVING_THROW_FORT, -nValue);

    // Hide Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_HIDE);
    if (nValue > 0) eSkillHide = EffectSkillIncrease(SKILL_HIDE, nValue);
    else eSkillHide = EffectSkillDecrease(SKILL_HIDE, -nValue);

    // Move Silently Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_MOVE_SILENTLY);
    if (nValue > 0) eSkillMoveSilently = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nValue);
    else eSkillMoveSilently = EffectSkillDecrease(SKILL_MOVE_SILENTLY, -nValue);

    // Discipline Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_DISCIPLINE);
    if (nValue > 0) eSkillDiscipline = EffectSkillIncrease(SKILL_DISCIPLINE, nValue);
    else eSkillDiscipline = EffectSkillDecrease(SKILL_DISCIPLINE, -nValue);

    // Listen Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_LISTEN);
    if (nValue > 0) eSkillListen = EffectSkillIncrease(SKILL_LISTEN, nValue);
    else eSkillListen = EffectSkillDecrease(SKILL_LISTEN, -nValue);

    // Spot Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_SPOT);
    if (nValue > 0) eSkillSpot = EffectSkillIncrease(SKILL_SPOT, nValue);
    else eSkillSpot = EffectSkillDecrease(SKILL_SPOT, -nValue);

    // Search Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_SEARCH);
    if (nValue > 0) eSkillSearch = EffectSkillIncrease(SKILL_SEARCH, nValue);
    else eSkillSearch = EffectSkillDecrease(SKILL_SEARCH, -nValue);

    // Tumble Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_TUMBLE);
    if (nValue > 0) eSkillTumble = EffectSkillIncrease(SKILL_TUMBLE, nValue);
    else eSkillTumble = EffectSkillDecrease(SKILL_TUMBLE, -nValue);

    // Ride Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_RIDE);
    if (nValue > 0) eSkillRide = EffectSkillIncrease(SKILL_RIDE, nValue);
    else eSkillRide = EffectSkillDecrease(SKILL_RIDE, -nValue);

    // Concentration Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_CONCENTRATION);
    if (nValue > 0) eSkillConcentration = EffectSkillIncrease(SKILL_CONCENTRATION, nValue);
    else eSkillConcentration = EffectSkillDecrease(SKILL_CONCENTRATION, -nValue);

    // Parry Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_PARRY);
    if (nValue > 0) eSkillParry = EffectSkillIncrease(SKILL_PARRY, nValue);
    else eSkillParry = EffectSkillDecrease(SKILL_PARRY, -nValue);

    // Spellcraft Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SKILL_SPELLCRAFT);
    if (nValue > 0) eSkillSpellcraft = EffectSkillIncrease(SKILL_SPELLCRAFT, nValue);
    else eSkillSpellcraft = EffectSkillDecrease(SKILL_SPELLCRAFT, -nValue);

    // Concealment Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_CONCEALMENT);
    eConcealment = EffectConcealment(nValue);

    // Damage Reduction
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_DAMAGE_REDUCTION);
    eDamageReduction = EffectDamageReduction(nValue, DAMAGE_POWER_NORMAL);

    // Miss Chance
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_MISS_CHANCE);
    eMissChance = EffectMissChance(nValue, MISS_CHANCE_TYPE_VS_RANGED);

    // Regenerate Bonus
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_REGENERATE);
    eRegenerate = EffectRegenerate(nValue, 6.0f);

    // Haste / Slow effect
    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_HASTE);
    if (nValue) eHaste = EffectHaste();

    nValue = GetLocalInt(oTrigger, SS_TERRAIN_EFFECT_SLOW);
    if (nValue) eSlow = EffectSlow();


    eLink = EffectLinkEffects(eAttackBonus, eArmorClass);
    eLink = EffectLinkEffects(eLink, eConcealment);
    eLink = EffectLinkEffects(eLink, eDamageBonus);
    eLink = EffectLinkEffects(eLink, eDamageReduction);
    eLink = EffectLinkEffects(eLink, eDexBonus);
    eLink = EffectLinkEffects(eLink, eHaste);
    eLink = EffectLinkEffects(eLink, eMissChance);
    eLink = EffectLinkEffects(eLink, eRegenerate);
    eLink = EffectLinkEffects(eLink, eSaveFortitude);
    eLink = EffectLinkEffects(eLink, eSaveReflex);
    eLink = EffectLinkEffects(eLink, eSaveUniversal);
    eLink = EffectLinkEffects(eLink, eSaveWill);
    eLink = EffectLinkEffects(eLink, eSkillConcentration);
    eLink = EffectLinkEffects(eLink, eSkillDiscipline);
    eLink = EffectLinkEffects(eLink, eSkillHide);
    eLink = EffectLinkEffects(eLink, eSkillListen);
    eLink = EffectLinkEffects(eLink, eSkillMoveSilently);
    eLink = EffectLinkEffects(eLink, eSkillParry);
    eLink = EffectLinkEffects(eLink, eSkillRide);
    eLink = EffectLinkEffects(eLink, eSkillSearch);
    eLink = EffectLinkEffects(eLink, eSkillSpellcraft);
    eLink = EffectLinkEffects(eLink, eSkillSpot);
    eLink = EffectLinkEffects(eLink, eSkillTumble);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eSpeed);
    eLink = EffectLinkEffects(eLink, eSpellFailure);
    eLink = EffectLinkEffects(eLink, eSpellResistance);

    eLink = SupernaturalEffect(eLink);

    return eLink;

}

int ss_GetIsTeamMember(object oPC, int bIncludeDMs = TRUE)
{
    if (GetItemPossessedBy(oPC, SS_ITEM_TEAM_TOKEN_TAG) != OBJECT_INVALID)
        return TRUE;

    if (bIncludeDMs)
        if (GetIsDM(oPC) || GetIsDMPossessed(oPC) || GetIsDM(GetMaster(oPC)))
            return TRUE;

    return FALSE;
}

// >-------< ss_SendMessageToTeam >-------<
// <ss_i_generic>
// Sends a message to the DMs and all players with the team token item.
// sColor - COLOR_* constants
void ss_SendMessageToTeam(string sMessage, string sColor)
{
     WriteTimestampedLogEntry("[TEAM] "+sMessage);
     string sSend = ss_GetStringColored(sMessage, sColor);
     SendMessageToAllDMs(sSend);
     object oPC = GetFirstPC();
     while (oPC != OBJECT_INVALID)
     {
         if (ss_GetIsTeamMember(oPC, FALSE))
             SendMessageToPC(oPC, sSend);
         oPC = GetNextPC();
     }

}

// >----< ss_SetCustomToken >----<
// <g_i_generic>
// Improved version of SetCustomToken. Allows for retrieviing with ss_GetCustomToken
void ss_SetCustomToken(int nCustomTokenNumber, string sTokenValue)
{
     SetCustomToken(nCustomTokenNumber, sTokenValue);
     SetLocalString(oTokenHolder, IntToString(nCustomTokenNumber), sTokenValue);
}

// >----< ss_GetCustomToken >----<
// <g_i_generic>
// Returns the Custom Token set by ss_SetCustomToken.
string ss_GetCustomToken(int nCustomTokenNumber)
{
   return GetLocalString(oTokenHolder, IntToString(nCustomTokenNumber));
}

// >----< ss_RemoveEffectType >----<
// <g_i_generic>
//Will remove an effect of type nEffectType and nSubType from oTarget.
//  nEffectType is the constant EFFECT_TYPE_*
//      Using -1 instead of EFFECT_TYPE_* and setting bAll to TRUE
//      will allow the removal of all effects of nSubType
//  nSubType is the constant SUBTYPE_*
//  bAll determines whether all effects of the type will be removed
void ss_RemoveEffectType(object oTarget, int nEffectType, int nSubType = SUBTYPE_MAGICAL, int bAll = FALSE)
{
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect))
    {
        if ((GetEffectType(eEffect) == nEffectType) || (nEffectType == -1))
        {
            if (GetEffectSubType(eEffect) == nSubType)
            {
                RemoveEffect(oTarget, eEffect);
                if (!bAll) return;
            }
        }
        eEffect = GetNextEffect(oTarget);
    }
}


string ss_Get2DAString(string s2DA, string sColumn, int nRow, int bCache = TRUE)
{
   if (SS_USE_ENGINE_2DA_READS_ONLY) return Get2DAString(s2DA, sColumn, nRow);

   if (SS_CACHE_ALL_2DA_READS == TRUE) bCache = TRUE;
   string sCache = s2DA + "|" +sColumn + "|" + IntToString(nRow);
   string sRet = GetLocalString(o2DACache,sCache);
   if (sRet != "")
   {
        return sRet;
   }
   sRet = Get2DAString(s2DA, sColumn, nRow);
   if (sRet != "" && bCache)
   {
        SetLocalString(o2DACache, sCache, sRet);
   }
   return sRet;
}


// >----< ss_HexStringToInt >----<
// <g_i_generic>
// Converts a hexadecimal string into a decimal integer.
int ss_HexStringToInt(string sHex)
{
    sHex = GetStringLowerCase(sHex);
    if(GetStringLeft(sHex, 2) == "0x")
        sHex = GetStringRight(sHex, GetStringLength(sHex) - 2);
    int nLoop = GetStringLength(sHex) - 1;
    string sConv = "0123456789abcdef";
    int nReturn;
    int nVal;
    while(sHex != "")
    {
        nVal = FindSubString(sConv, GetStringLeft(sHex, 1));
        nVal = nVal * FloatToInt(pow(16.0, IntToFloat(nLoop)));
        nReturn += nVal;
        sHex = GetStringRight(sHex, nLoop);
        nLoop--;
    }
    return nReturn;
}

// >----< ss_GetEncumberanceLevel >----<
// <g_i_generic>
// Returns 2 on Heavy Encumberence, 1 on Normal, and 0 on no.
int ss_GetEncumberanceLevel(object oPC = OBJECT_SELF)
{

    int nWeight = GetWeight(oPC);
    int nStr = GetAbilityScore(oPC, ABILITY_STRENGTH);

    int nEnc = StringToInt(ss_Get2DAString("encumbrance", "Heavy", nStr));
    if(nWeight > nEnc) return 2;

    nEnc = StringToInt(ss_Get2DAString("encumbrance", "Normal", nStr));
    if(nWeight > nEnc) return 1;

    return 0;
}
