/*
Filename:           g_i_constants
System:             Generic (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 14, 2009
Summary:
Generic system constants definition script. This file contains the constants
commonly used in the generic system. This script is consumed by g_i_generic as
an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Include generic libraries
#include "g_i_creatures"
#include "g_i_waypoints"
#include "g_i_dialogs"
#include "g_i_items"

// General constants
const int SS_DAY   = 0;
const int SS_NIGHT = 1;
const int SS_DAWN  = 2;
const int SS_DUSK  = 3;

// Local variable names
const string SS_FLAVOR_TEXT       = "FlavorText";
const string SS_FLAVOR_TEXT_DAY   = "FlavorText_Day";
const string SS_FLAVOR_TEXT_NIGHT = "FlavorText_Night";
const string SS_FLAVOR_TEXT_DUSK  = "FlavorText_Dusk";
const string SS_FLAVOR_TEXT_DAWN  = "FlavorText_Dawn";

const string SS_TERRAIN_EFFECT_SPEED               = "SpeedAdjustment";
const string SS_TERRAIN_EFFECT_ARMOR_CLASS         = "ArmorClassAdjustment";
const string SS_TERRAIN_EFFECT_ATTACK_BONUS        = "AttackBonusAdjustment";
const string SS_TERRAIN_EFFECT_MISS_CHANCE         = "RangedAttackMissChance";
const string SS_TERRAIN_EFFECT_DEX_BONUS           = "DexterityAdjustment";
const string SS_TERRAIN_EFFECT_CONCEALMENT         = "Concealment";
const string SS_TERRAIN_EFFECT_DAMAGE_BONUS        = "DamageAdjustment";
const string SS_TERRAIN_EFFECT_DAMAGE_REDUCTION    = "DamageReductionAdjustment";
const string SS_TERRAIN_EFFECT_HASTE               = "Haste";
const string SS_TERRAIN_EFFECT_REGENERATE          = "Regeneration";
const string SS_TERRAIN_EFFECT_SAVE_UNIVERSAL      = "SavingThrowUniversal";
const string SS_TERRAIN_EFFECT_SAVE_REFLEX         = "SavingThrowReflex";
const string SS_TERRAIN_EFFECT_SAVE_WILL           = "SavingThrowWill";
const string SS_TERRAIN_EFFECT_SAVE_FORTITUDE      = "SavingThrowFortitude";
const string SS_TERRAIN_EFFECT_SLOW                = "Slow";
const string SS_TERRAIN_EFFECT_SPELL_FAILURE       = "SpellFailure";
const string SS_TERRAIN_EFFECT_SPELL_RESISTANCE    = "SpellResistance";
const string SS_TERRAIN_EFFECT_SKILL_HIDE          = "HideAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_MOVE_SILENTLY = "MoveSilentlyAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_DISCIPLINE    = "DisciplineAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_SPOT          = "SpotAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_SEARCH        = "SearchAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_LISTEN        = "ListenAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_TUMBLE        = "TumbleAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_RIDE          = "RideAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_SPELLCRAFT    = "SpellcraftAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_CONCENTRATION = "ConcentrationAdjustment";
const string SS_TERRAIN_EFFECT_SKILL_PARRY         = "ParryAdjustment";

const string SS_SPEAK_STRING                       = "SpeakString";
const string SS_SPEAK_STRING_COLOR                 = "SpeakStringRGB";


// Database variable names


// Affixes
const string SS_FLAVOR_TEXT_RGB         = "_RGB";
const string SS_FLAVOR_TEXT_ONCE_PER_PC = "_OncePerPC";


// Text strings

// Skill check message construction:
// GetName(oSkillUser) + " " + SS_TEXT_SKILL_* + SS_TEXT_SKILL_CHECK + rollresult + " + " + modifier + " = " + total
// "JimBob Heal skill check. Roll: 10 + 4 = 14"
const string SS_TEXT_SKILL_CHECK = " skill check. Roll: ";

const string SS_TEXT_SKILL_ANIMAL_EMPATHY   = "Animal Empathy";
const string SS_TEXT_SKILL_APPRAISE         = "Appraise";
const string SS_TEXT_SKILL_BLUFF            = "Bluff";
const string SS_TEXT_SKILL_CONCENTRATION    = "Concentration";
const string SS_TEXT_SKILL_CRAFT_ARMOR      = "Craft Armor";
const string SS_TEXT_SKILL_CRAFT_TRAP       = "Craft Trap";
const string SS_TEXT_SKILL_CRAFT_WEAPON     = "Craft Weapon";
const string SS_TEXT_SKILL_DISABLE_TRAP     = "Disable Trap";
const string SS_TEXT_SKILL_DISCIPLINE       = "Discipline";
const string SS_TEXT_SKILL_HEAL             = "Heal";
const string SS_TEXT_SKILL_HIDE             = "Hide";
const string SS_TEXT_SKILL_INTIMIDATE       = "Intimidate";
const string SS_TEXT_SKILL_LISTEN           = "Listen";
const string SS_TEXT_SKILL_LORE             = "Lore";
const string SS_TEXT_SKILL_MOVE_SILENTLY    = "Move Silently";
const string SS_TEXT_SKILL_OPEN_LOCK        = "Open Lock";
const string SS_TEXT_SKILL_PARRY            = "Parry";
const string SS_TEXT_SKILL_PERFORM          = "Perform";
const string SS_TEXT_SKILL_PERSUADE         = "Persuade";
const string SS_TEXT_SKILL_PICK_POCKET      = "Pick Pocket";
const string SS_TEXT_SKILL_RIDE             = "Ride";
const string SS_TEXT_SKILL_SEARCH           = "Search";
const string SS_TEXT_SKILL_SET_TRAP         = "Set Trap";
const string SS_TEXT_SKILL_SPELLCRAFT       = "Spellcraft";
const string SS_TEXT_SKILL_SPOT             = "Spot";
const string SS_TEXT_SKILL_TAUNT            = "Taunt";
const string SS_TEXT_SKILL_TUMBLE           = "Tumble";
const string SS_TEXT_SKILL_USE_MAGIC_DEVICE = "Use Magic Device";

