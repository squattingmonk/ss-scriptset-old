/*
Filename:           g_i_names
System:             Generic (include script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       April 7, 2009
Summary:

This library deals with functions that switch scripting constants to string names.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "g_i_generic"




/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/



// >----< ss_GetAbilityName >----<
// <g_i_names>
// Returns the name of nAbility
// (NOTE: All first letters are capitals)
string ss_GetAbilityName(int nAbility);

// >----< ss_GetRaceName >----<
// <g_i_names>
// Returns the name of nRacialType.  (NOTE: All first letters are capitals)
string ss_GetRaceName(int nRacialType);

// >----< ss_GetFeatName >----<
// <g_i_names>
// Returns the name of nFeat
string ss_GetFeatName(int nFeat);

// >----< ss_GetFeatDescription >----<
// <g_i_names>
// Returns the description of nFeat
string ss_GetFeatDescription(int nFeat);

// >----< ss_GetSkillDescription >----<
// <g_i_names>
// Returns the description of nSkill
string ss_GetSkillDescription(int nSkill);

// >----< ss_GetSkillName >----<
// <g_i_names>
// Returns the name of nSkill. (NOTE: All first letters are capitals)
string ss_GetSkillName(int nSkill);


// >----< ss_GetClassName >----<
// <g_i_names>
// Returns the name of nClass (NOTE: All first letters are capitals)
string ss_GetClassName(int nClass);

// >----< ss_GetName >----<
// <g_i_names>
// Returns the name of nBaseItem (First letter is capital)
string ss_GetBaseItemName(int nBaseItem);

// >----< ss_GetDamageTypeName >----<
// <g_i_names>
// Returns the name of nDamageType
string ss_GetDamageTypeName(int nDamageType);











/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/




string ss_GetAbilityName(int nAbility)
{
    string sAbility;
    switch (nAbility)
    {
        case ABILITY_CHARISMA:        sAbility = "Charisma";      break;
        case ABILITY_CONSTITUTION:    sAbility = "Constitution";  break;
        case ABILITY_DEXTERITY:       sAbility = "Dexterity";     break;
        case ABILITY_INTELLIGENCE:    sAbility = "Intelligence";  break;
        case ABILITY_STRENGTH:        sAbility = "Strength";      break;
        case ABILITY_WISDOM:          sAbility = "Wisdom";        break;
    }
    return sAbility;
}

string ss_GetRaceName(int nRacialType)
{
    string ssRace = "";
    switch(nRacialType)
    {
        case RACIAL_TYPE_ABERRATION:
            sRace = "Aberration";
            break;
        case RACIAL_TYPE_ANIMAL:
            sRace = "Animal";
            break;
        case RACIAL_TYPE_BEAST:
            sRace = "Beast";
            break;
        case RACIAL_TYPE_CONSTRUCT:
            sRace = "Construct";
            break;
        case RACIAL_TYPE_DRAGON:
            sRace = "Dragon";
            break;
        case RACIAL_TYPE_DWARF:
            sRace = "Dwarf";
            break;
        case RACIAL_TYPE_ELEMENTAL:
            sRace = "Elemental";
            break;
        case RACIAL_TYPE_ELF:
            sRace = "Elf";
            break;
        case RACIAL_TYPE_FEY:
            sRace = "Fey";
            break;
        case RACIAL_TYPE_GIANT:
            sRace = "Giant";
            break;
        case RACIAL_TYPE_GNOME:
            sRace = "Gnome";
            break;
        case RACIAL_TYPE_HALFELF:
            sRace = "Half Elf";
            break;
        case RACIAL_TYPE_HALFLING:
            sRace = "Halfling";
            break;
        case RACIAL_TYPE_HALFORC:
            sRace = "Half Orc";
            break;
        case RACIAL_TYPE_HUMAN:
            sRace = "Human";
            break;
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
            sRace = "Goblinoid";
            break;
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
            sRace = "Monstrous";
            break;
        case RACIAL_TYPE_HUMANOID_ORC:
            sRace = "Orc";
            break;
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
            sRace = "Reptilian";
            break;
        case RACIAL_TYPE_MAGICAL_BEAST:
            sRace = "Magical Beast";
            break;
        case RACIAL_TYPE_OOZE:
            sRace = "Ooze";
            break;
        case RACIAL_TYPE_OUTSIDER:
            sRace = "Outsider";
            break;
        case RACIAL_TYPE_SHAPECHANGER:
            sRace = "Shapechanger";
            break;
        case RACIAL_TYPE_UNDEAD:
            sRace = "Undead";
            break;
        case RACIAL_TYPE_VERMIN:
            sRace = "Vermin";
            break;
        default:
            break;
    }
    return sRace;
}

string ss_GetFeatName(int nFeat)
{
    return GetStringByStrRef(StringToInt(ss_Get2DAString("feat", "FEAT", nFeat)));
}

string ss_GetFeatDescription(int nFeat)
{
    return GetStringByStrRef(StringToInt(ss_Get2DAString("feat", "DESCRIPTION", nFeat)));
}

string ss_GetSkillDescription(int nSkill)
{
    return GetStringByStrRef(StringToInt(ss_Get2DAString("skills", "Description", nSkill)));
}

string ss_GetSkillName(int nSkill)
{

//    return GetStringByStrRef(StringToInt(ss_Get2DAString("skills", "Name", nSkill)));
//      This is a lot faster, but requires modification if we add new skills.
    string sSkill;
    switch (nSkill)
    {
        case SKILL_ANIMAL_EMPATHY:      sSkill = "Animal Empathy";      break;
        case SKILL_APPRAISE:            sSkill = "Appraise";            break;
        case SKILL_BLUFF:               sSkill = "Bluff";               break;
        case SKILL_CONCENTRATION:       sSkill = "Concentration";       break;
        case SKILL_CRAFT_ARMOR:         sSkill = "Craft Armour";        break;
        case SKILL_CRAFT_TRAP:          sSkill = "Craft Trap";          break;
        case SKILL_CRAFT_WEAPON:        sSkill = "Craft Weapon";        break;
        case SKILL_DISABLE_TRAP:        sSkill = "Disable Trap";        break;
        case SKILL_DISCIPLINE:          sSkill = "Discipline";          break;
        case SKILL_HEAL:                sSkill = "Heal";                break;
        case SKILL_HIDE:                sSkill = "Hide";                break;
        case SKILL_INTIMIDATE:          sSkill = "Intimidate";          break;
        case SKILL_LISTEN:              sSkill = "Listen";              break;
        case SKILL_LORE:                sSkill = "Lore";                break;
        case SKILL_MOVE_SILENTLY:       sSkill = "Move Silently";       break;
        case SKILL_OPEN_LOCK:           sSkill = "Open Lock";           break;
        case SKILL_PARRY:               sSkill = "Parry";               break;
        case SKILL_PERFORM:             sSkill = "Perform";             break;
        case SKILL_PERSUADE:            sSkill = "Persuade";            break;
        case SKILL_PICK_POCKET:         sSkill = "Pick Pocket";         break;
        case SKILL_SEARCH:              sSkill = "Search";              break;
        case SKILL_SET_TRAP:            sSkill = "Set Trap";            break;
        case SKILL_SPELLCRAFT:          sSkill = "Spellcraft";          break;
        case SKILL_SPOT:                sSkill = "Spot";                break;
        case SKILL_TAUNT:               sSkill = "Taunt";               break;
        case SKILL_TUMBLE:              sSkill = "Tumble";              break;
        case SKILL_USE_MAGIC_DEVICE:    sSkill = "Use Magic Device";    break;
        case SKILL_RIDE:                sSkill = "Ride";                break;
    }
    return sSkill;
}

string ss_GetClassName(int nClass)
{
    string sClass;
    switch (nClass)
    {
        case CLASS_TYPE_ABERRATION:         sClass = "Aberration";        break;
        case CLASS_TYPE_ANIMAL:             sClass = "Animal";            break;
        case CLASS_TYPE_ARCANE_ARCHER:      sClass = "Arcane Archer";     break;
        case CLASS_TYPE_ASSASSIN:           sClass = "Assassin";          break;
        case CLASS_TYPE_BARBARIAN:          sClass = "Barbarian";         break;
        case CLASS_TYPE_BARD:               sClass = "Bard";              break;
        case CLASS_TYPE_BEAST:              sClass = "Beast";             break;
        case CLASS_TYPE_BLACKGUARD:         sClass = "Blackguard";        break;
        case CLASS_TYPE_CLERIC:             sClass = "Cleric";            break;
        case CLASS_TYPE_COMMONER:           sClass = "Commoner";          break;
        case CLASS_TYPE_CONSTRUCT:          sClass = "Construct";         break;
        case CLASS_TYPE_DIVINE_CHAMPION:    sClass = "Divine Champion";   break;
        case CLASS_TYPE_DRAGON:             sClass = "Dragon";            break;
        case CLASS_TYPE_DRAGON_DISCIPLE:    sClass = "Dragon Disciple";   break;
        case CLASS_TYPE_DRUID:              sClass = "Druid";             break;
        case CLASS_TYPE_DWARVEN_DEFENDER:   sClass = "Dwarven Defender";  break;
        case CLASS_TYPE_ELEMENTAL:          sClass = "Elemental";         break;
        case CLASS_TYPE_EYE_OF_GRUUMSH:     sClass = "Eye of Gruumsh";    break;
        case CLASS_TYPE_FEY:                sClass = "Fey";               break;
        case CLASS_TYPE_FIGHTER:            sClass = "Fighter";           break;
        case CLASS_TYPE_GIANT:              sClass = "Giant";             break;
        case CLASS_TYPE_HARPER:             sClass = "Harper";            break;
        case CLASS_TYPE_HUMANOID:           sClass = "Humanoid";          break;
        case CLASS_TYPE_MAGICAL_BEAST:      sClass = "Magical Beast";     break;
        case CLASS_TYPE_MONK:               sClass = "Monk";              break;
        case CLASS_TYPE_MONSTROUS:          sClass = "Monstrous";         break;
        case CLASS_TYPE_OOZE:               sClass = "Ooze";              break;
        case CLASS_TYPE_OUTSIDER:           sClass = "Outsider";          break;
        case CLASS_TYPE_PALADIN:            sClass = "Paladin";           break;
        case CLASS_TYPE_PALE_MASTER:        sClass = "Pale master";       break;
        case CLASS_TYPE_RANGER:             sClass = "Ranger";            break;
        case CLASS_TYPE_ROGUE:              sClass = "Rogue";             break;
        case CLASS_TYPE_SHADOWDANCER:       sClass = "Shadowdancer";      break;
        case CLASS_TYPE_SHAPECHANGER:       sClass = "Shapechanger";      break;
        case CLASS_TYPE_SHIFTER:            sClass = "Shifter";           break;
        case CLASS_TYPE_SHOU_DISCIPLE:      sClass = "Disciple";          break;
        case CLASS_TYPE_SORCERER:           sClass = "Sorcerer";          break;
        case CLASS_TYPE_UNDEAD:             sClass = "Undead";            break;
        case CLASS_TYPE_VERMIN:             sClass = "Vermin";            break;
        case CLASS_TYPE_WEAPON_MASTER:      sClass = "Weapon Master";     break;
        case CLASS_TYPE_WIZARD:             sClass = "Wizard";            break;
       case CLASS_TYPE_PURPLE_DRAGON_KNIGHT:sClass="Purple Dragon Knight";break;
        default:                            sClass = "";                  break;
    }
    return sClass;
}

string ss_GetBaseItemName(int nBaseItem)
{
    string sItemName;
    switch (nBaseItem)
    {
        /* the numbers 23, 30, 48 and 67 do not exist as base item constants */
        case BASE_ITEM_AMULET:              sItemName = "Amulet";               break;
        case BASE_ITEM_ARMOR:               sItemName = "Armour";               break;
        case BASE_ITEM_ARROW:               sItemName = "Arrow";                break;
        case BASE_ITEM_BASTARDSWORD:        sItemName = "Bastard sword";        break;
        case BASE_ITEM_BATTLEAXE:           sItemName = "Battleaxe";            break;
        case BASE_ITEM_BELT:                sItemName = "Belt";                 break;
        case BASE_ITEM_BLANK_POTION:        sItemName = "Empty potion";         break;
        case BASE_ITEM_BLANK_SCROLL:        sItemName = "Blank scroll";         break;
        case BASE_ITEM_BLANK_WAND:          sItemName = "Unused wand";          break;
        case BASE_ITEM_BOLT:                sItemName = "Bolt";                 break;
        case BASE_ITEM_BOOK:                sItemName = "Book";                 break;
        case BASE_ITEM_BOOTS:               sItemName = "Boots";                break;
        case BASE_ITEM_BRACER:              sItemName = "Bracer";               break;
        case BASE_ITEM_BULLET:              sItemName = "Bullet";               break;
        case BASE_ITEM_CBLUDGWEAPON:        sItemName = "Creature bludgeoning weapon";  break;
        case BASE_ITEM_CLOAK:               sItemName = "Cloak";                break;
        case BASE_ITEM_CLUB:                sItemName = "Club";                 break;
        case BASE_ITEM_CPIERCWEAPON:        sItemName = "Creature piercing weapon";  break;
        case BASE_ITEM_CRAFTMATERIALMED:    sItemName = "Crafting material medium"; break;
        case BASE_ITEM_CRAFTMATERIALSML:    sItemName = "Crafting material small";  break;
        case BASE_ITEM_CREATUREITEM:        sItemName = "Creature item";        break;
        case BASE_ITEM_CSLASHWEAPON:        sItemName = "Creature slashing weapon"; break;
        case BASE_ITEM_CSLSHPRCWEAP:        sItemName = "Creature slashing/piercing weapon";    break;
        case BASE_ITEM_DAGGER:              sItemName = "Dagger";               break;
        case BASE_ITEM_DART:                sItemName = "Dart";                 break;
        case BASE_ITEM_DIREMACE:            sItemName = "Dire mace";            break;
        case BASE_ITEM_DOUBLEAXE:           sItemName = "Double axe";           break;
        case BASE_ITEM_DWARVENWARAXE:       sItemName = "Waraxe";               break;
        case BASE_ITEM_ENCHANTED_POTION:    sItemName = "Filled potion";        break;
        case BASE_ITEM_ENCHANTED_SCROLL:    sItemName = "Scribed scroll";       break;
        case BASE_ITEM_ENCHANTED_WAND:      sItemName = "Enchanted wand";       break;
        case BASE_ITEM_GEM:                 sItemName = "Gem";                  break;
        case BASE_ITEM_GLOVES:              sItemName = "Gloves";               break;
        case BASE_ITEM_GOLD:                sItemName = "Gold";                 break;
        case BASE_ITEM_GREATAXE:            sItemName = "Greataxe";             break;
        case BASE_ITEM_GREATSWORD:          sItemName = "Greatsword";           break;
        case BASE_ITEM_GRENADE:             sItemName = "Grenade";              break;
        case BASE_ITEM_HALBERD:             sItemName = "Halberd";              break;
        case BASE_ITEM_HANDAXE:             sItemName = "Hand axe";             break;
        case BASE_ITEM_HEALERSKIT:          sItemName = "Healer's kit";         break;
        case BASE_ITEM_HEAVYCROSSBOW:       sItemName = "Heavy crossbow";       break;
        case BASE_ITEM_HEAVYFLAIL:          sItemName = "Heavy flail";          break;
        case BASE_ITEM_HELMET:              sItemName = "Helmet";               break;
        case BASE_ITEM_KAMA:                sItemName = "Kama";                 break;
        case BASE_ITEM_KATANA:              sItemName = "Katana";               break;
        case BASE_ITEM_KEY:                 sItemName = "Key";                  break;
        case BASE_ITEM_KUKRI:               sItemName = "Kukri";                break;
        case BASE_ITEM_LARGEBOX:            sItemName = "Large Box";            break;
        case BASE_ITEM_LARGESHIELD:         sItemName = "Large shield";         break;
        case BASE_ITEM_LIGHTCROSSBOW:       sItemName = "Light crossbow";       break;
        case BASE_ITEM_LIGHTFLAIL:          sItemName = "Light flail";          break;
        case BASE_ITEM_LIGHTHAMMER:         sItemName = "Light hammer";         break;
        case BASE_ITEM_LIGHTMACE:           sItemName = "Light mace";           break;
        case BASE_ITEM_LONGBOW:             sItemName = "Longbow";              break;
        case BASE_ITEM_LONGSWORD:           sItemName = "Longsword";            break;
        case BASE_ITEM_MAGICROD:            sItemName = "Magic rod";            break;
        case BASE_ITEM_MAGICSTAFF:          sItemName = "Magic staff";          break;
        case BASE_ITEM_MAGICWAND:           sItemName = "Magic wand";           break;
        case BASE_ITEM_MISCLARGE:           sItemName = "Miscelaneous large";   break;
        case BASE_ITEM_MISCMEDIUM:          sItemName = "Miscelaneous medium";  break;
        case BASE_ITEM_MISCSMALL:           sItemName = "Miscelaneous small";   break;
        case BASE_ITEM_MISCTALL:            sItemName = "Miscelaneous tall";    break;
        case BASE_ITEM_MISCTHIN:            sItemName = "Miscelaneous thin";    break;
        case BASE_ITEM_MISCWIDE:            sItemName = "Miscelaneous wide";    break;
        case BASE_ITEM_MORNINGSTAR:         sItemName = "Morningstar";          break;
        case BASE_ITEM_POTIONS:             sItemName = "Potion";               break;
        case BASE_ITEM_QUARTERSTAFF:        sItemName = "Quarterstaff";         break;
        case BASE_ITEM_RAPIER:              sItemName = "Rapier";               break;
        case BASE_ITEM_RING:                sItemName = "Ring";                 break;
        case BASE_ITEM_SCIMITAR:            sItemName = "Scimitar";             break;
        case BASE_ITEM_SCROLL:              sItemName = "Scroll";               break;
        case BASE_ITEM_SCYTHE:              sItemName = "Scythe";               break;
        case BASE_ITEM_SHORTBOW:            sItemName = "Shortbow";             break;
        case BASE_ITEM_SHORTSPEAR:          sItemName = "Short spear";          break;
        case BASE_ITEM_SHORTSWORD:          sItemName = "Short sword";          break;
        case BASE_ITEM_SHURIKEN:            sItemName = "Shuriken";             break;
        case BASE_ITEM_SICKLE:              sItemName = "Sickle";               break;
        case BASE_ITEM_SLING:               sItemName = "Sling";                break;
        case BASE_ITEM_SMALLSHIELD:         sItemName = "Small shield";         break;
        case BASE_ITEM_SPELLSCROLL:         sItemName = "Spell scroll";         break;
        case BASE_ITEM_THIEVESTOOLS:        sItemName = "Thieves tools";        break;
        case BASE_ITEM_THROWINGAXE:         sItemName = "Throwing axe";         break;
        case BASE_ITEM_TORCH:               sItemName = "Torch";                break;
        case BASE_ITEM_TOWERSHIELD:         sItemName = "Tower shield";         break;
        case BASE_ITEM_TRAPKIT:             sItemName = "Trap kit";             break;
        case BASE_ITEM_TRIDENT:             sItemName = "Trident";              break;
        case BASE_ITEM_TWOBLADEDSWORD:      sItemName = "Two-bladed sword";     break;
        case BASE_ITEM_WARHAMMER:           sItemName = "Warhammer";            break;
        case BASE_ITEM_WHIP:                sItemName = "Whip";                 break;
    }
    return sItemName;
}

string ss_GetDamageTypeName(int nDamageType)
{
    string sString;
    switch (nDamageType)
    {
        case DAMAGE_TYPE_ACID:          sString = "Acid";               break;
        case DAMAGE_TYPE_BASE_WEAPON:   sString = "Physical";           break;
        case DAMAGE_TYPE_BLUDGEONING:   sString = "Bludgeoning";        break;
        case DAMAGE_TYPE_COLD:          sString = "Cold";               break;
        case DAMAGE_TYPE_DIVINE:        sString = "Divine";             break;
        case DAMAGE_TYPE_ELECTRICAL:    sString = "Electrical";         break;
        case DAMAGE_TYPE_FIRE:          sString = "Fire";               break;
        case DAMAGE_TYPE_MAGICAL:       sString = "Magical";            break;
        case DAMAGE_TYPE_NEGATIVE:      sString = "Negative";           break;
        case DAMAGE_TYPE_PIERCING:      sString = "Piercing";           break;
        case DAMAGE_TYPE_POSITIVE:      sString = "Positive";           break;
        case DAMAGE_TYPE_SLASHING:      sString = "Slashing";           break;
        case DAMAGE_TYPE_SONIC:         sString = "Sonic";              break;
    }
    return sString;
}

