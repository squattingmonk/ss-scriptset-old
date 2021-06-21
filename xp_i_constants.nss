/*
Filename:           xp_i_constants
System:             Experience (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Apr. 25, 2008
Summary:
XP system core constants definitions. (internal use only, NOT user configurable)

This file holds the constants commonly used throughout the XP system.

This script is accessible from xp_i_main.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Prefixes
const string XP_SUBRACE_PREFIX = "XP_SUBRACE_";
const string XP_PC_MODIFIER_PREFIX = "XP_MODIFIER_";
const string XP_AREA_EXPLORED_PREFIX = "XP_AREA_EXPLORED_";
const string XP_TRIGGER_EXPLORED_PREFIX = "XP_TRIGGER_EXPLORED_";
const string XP_UNLOCKED_PREFIX = "XP_UNLOCKED_";
const string XP_DISARMED_PREFIX = "XP_DISARMED_";
const string XP_SPELL_CASTS_PREFIX = "XP_SPELL_CASTS_";
const string XP_COMBAT_REDUCTION_PREFIX = "XP_COMBAT_REDUCTION_";

// Local int names
const string XP_MODIFIER = "XP_MODIFIER";
const string XP_STORED_LEVEL = "XP_STORED_LEVEL";

const string XP_BONUS_GENERIC   = "XP_BONUS_GENERIC";
const string XP_BONUS_ABILITY   = "XP_BONUS_ABILITY";
const string XP_BONUS_COMBAT    = "XP_BONUS_COMBAT";
const string XP_BONUS_CRAFTING  = "XP_BONUS_CRAFTING";
const string XP_BONUS_DISCOVERY = "XP_BONUS_DISCOVERY";
const string XP_BONUS_MAGIC     = "XP_BONUS_MAGIC";
const string XP_BONUS_QUEST     = "XP_BONUS_QUEST";
const string XP_BONUS_ROLEPLAY  = "XP_BONUS_ROLEPLAY";

const string XP_MODIFIER_GENERIC   = "XP_MODIFIER_GENERIC";
const string XP_MODIFIER_ABILITY   = "XP_MODIFIER_ABILITY";
const string XP_MODIFIER_COMBAT    = "XP_MODIFIER_COMBAT";
const string XP_MODIFIER_CRAFTING  = "XP_MODIFIER_CRAFTING";
const string XP_MODIFIER_DISCOVERY = "XP_MODIFIER_DISCOVERY";
const string XP_MODIFIER_MAGIC     = "XP_MODIFIER_MAGIC";
const string XP_MODIFIER_QUEST     = "XP_MODIFIER_QUEST";
const string XP_MODIFIER_ROLEPLAY  = "XP_MODIFIER_ROLEPLAY";

const string XP_NO_XP = "XP_NO_XP";

// External int names
const string XP_PC_MODIFIER_GENERIC   = "XP_MODIFIER_0";
const string XP_PC_MODIFIER_ABILITY   = "XP_MODIFIER_1";
const string XP_PC_MODIFIER_COMBAT    = "XP_MODIFIER_2";
const string XP_PC_MODIFIER_CRAFTING  = "XP_MODIFIER_3";
const string XP_PC_MODIFIER_DISCOVERY = "XP_MODIFIER_4";
const string XP_PC_MODIFIER_MAGIC     = "XP_MODIFIER_5";
const string XP_PC_MODIFIER_QUEST     = "XP_MODIFIER_6";
const string XP_PC_MODIFIER_ROLEPLAY  = "XP_MODIFIER_7";

const int XP_TYPE_GENERIC   = 0;
const int XP_TYPE_ABILITY   = 1;
const int XP_TYPE_COMBAT    = 2;
const int XP_TYPE_CRAFTING  = 3;
const int XP_TYPE_DISCOVERY = 4;
const int XP_TYPE_MAGIC     = 5;
const int XP_TYPE_QUEST     = 6;
const int XP_TYPE_ROLEPLAY  = 7;
const int XP_TYPE_NONE      = -1;

const string XP_MODIFIERS_INITIALIZED = "XP_MODIFIERS_INITIALIZED";
const string XP_BARDSONG_USES = "XP_BARDSONG_USES";

const string XP_TEXT_GAIN = "XP Gain: ";
const string XP_TEXT_LOSS = "XP Loss: ";

const string XP_TEXT_ABILITY_XP   = "Ability XP";
const string XP_TEXT_COMBAT_XP    = "Combat XP";
const string XP_TEXT_CRAFTING_XP  = "Crafting XP";
const string XP_TEXT_DISCOVERY_XP = "Discovery XP";
const string XP_TEXT_MAGIC_XP     = "Magic XP";
const string XP_TEXT_QUEST_XP     = "Quest XP";
const string XP_TEXT_ROLEPLAY_XP  = "Role-Playing XP";

const string XP_TEXT_DISCOVERED_NEW_AREA = "You discovered a new area!";
const string XP_TEXT_DISCOVERED_SOMETHING_NEW = "You discovered something new!";
