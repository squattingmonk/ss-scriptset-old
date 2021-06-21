/*
Filename:           g_targetonattack
System:             Generic  (hook-in script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       March 13, 2009
Summary:

OnPhysicalAttacked script for the Archery Target / Dartboard.
If hit by a missile weapon, it will say where it hit.


Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "g_i_generic"

void main()
{
    object oTarget = OBJECT_SELF;
    object oAttacker = GetLastAttacker(oTarget);
    object oWeapon = GetLastWeaponUsed(oAttacker);

    // Sanity check - Ranged weapon?
    if(!GetWeaponRanged(oWeapon)) return;

    // d20 roll as base, apply penalties/bonuses to this:
    int nRoll = d20();

    // Critical Miss.
    if(nRoll == 1)
    {
       SpeakString(ss_GetStringColoredRGB("[missed]", 255, 0, 0));
       return;
    }

    // Critical hit. Rather than automatic hit, just a nice bonus
    if(nRoll == 20) nRoll += 5;


    //Base Attack Bonus
    nRoll += GetBaseAttackBonus(oAttacker);
    //Dexterity Bonus
    nRoll += GetAbilityModifier(ABILITY_DEXTERITY, oAttacker);
    // +3 bonus for called shot
    if(GetHasFeat(FEAT_CALLED_SHOT, oAttacker)) nRoll += 3;





    // Weapon focus/specialization and Improved Critical all add +1 bonus.
    switch(GetBaseItemType(oWeapon))
    {
      case BASE_ITEM_DART:  if(GetHasFeat(FEAT_WEAPON_FOCUS_DART, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DART, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DART, oAttacker)) nRoll += 1;
                            break;

      case BASE_ITEM_HEAVYCROSSBOW:  if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW, oAttacker)) nRoll += 1;
                                     if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW, oAttacker)) nRoll += 1;
                                     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW, oAttacker)) nRoll += 1;
                                     break;

      case BASE_ITEM_LIGHTCROSSBOW:  if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW, oAttacker)) nRoll += 1;
                            break;

      case BASE_ITEM_LONGBOW:  if(GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LONGBOW, oAttacker)) nRoll += 1;
                            break;

      case BASE_ITEM_SHORTBOW:  if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORTBOW, oAttacker)) nRoll += 1;
                            break;

      case BASE_ITEM_SHURIKEN:  if(GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHURIKEN, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SHURIKEN, oAttacker)) nRoll += 1;
                            break;

      case BASE_ITEM_SLING:  if(GetHasFeat(FEAT_WEAPON_FOCUS_SLING, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SLING, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SLING, oAttacker)) nRoll += 1;
                            break;

      case BASE_ITEM_THROWINGAXE:  if(GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_THROWING_AXE, oAttacker)) nRoll += 1;
                            if(GetHasFeat(FEAT_IMPROVED_CRITICAL_THROWING_AXE, oAttacker)) nRoll += 1;
                            break;
    }



    // Distance penalty is double the number of meters to the target
    float fDistance = GetDistanceBetween(oAttacker, oTarget);
    nRoll -= 2 * FloatToInt(fDistance);


    // Find out where it hit.
    int nHit;

     if (nRoll < 2)  nHit = 0;
else if (nRoll < 4)  nHit = 1;
else if (nRoll < 6)  nHit = 2;
else if (nRoll < 8)  nHit = 3;
else if (nRoll < 10) nHit = 4;
else if (nRoll < 12) nHit = 5;
else if (nRoll < 14) nHit = 6;
else if (nRoll < 16) nHit = 7;
else if (nRoll < 18) nHit = 8;
else if (nRoll < 20) nHit = 9;
else                 nHit = 10;


// Notify the players
string sMessage;

switch (nHit)
{
 case 0: sMessage = ss_GetStringColoredRGB("[missed]", 255, 0, 0);      break;
 case 1: sMessage = ss_GetStringColoredRGB("[1]", 255, 50, 0);          break;
 case 2: sMessage = ss_GetStringColoredRGB("[2]", 255, 100, 0);         break;
 case 3: sMessage = ss_GetStringColoredRGB("[3]", 255, 150, 0);         break;
 case 4: sMessage = ss_GetStringColoredRGB("[4]", 255, 200, 0);         break;
 case 5: sMessage = ss_GetStringColoredRGB("[5]", 255, 255, 0);         break;
 case 6: sMessage = ss_GetStringColoredRGB("[6]", 200, 255, 0);         break;
 case 7: sMessage = ss_GetStringColoredRGB("[7]", 150, 255, 0);         break;
 case 8: sMessage = ss_GetStringColoredRGB("[8]", 100, 255, 0);         break;
 case 9: sMessage = ss_GetStringColoredRGB("[9]", 50, 255, 0);          break;
 case 10: sMessage = ss_GetStringColoredRGB("[BULLSEYE]", 0, 255, 0);   break;

}

SpeakString(sMessage);

}
