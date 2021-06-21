/*
Filename:           htf_c_main
System:             Hunger, Thirst, & Fatigue (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2008
Summary:
HTF system configuration settings. This script contains user-definable toggles
and settings for the HTF system.

This script is freely editable by developers. It should not contain any
constants that should not be overridable by other builders. Please put those in
htf_i_constants.

All below constants may be overridden, but do not alter the names of the
constants.

This script is consumed by htf_i_main as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// This plus the PC's base constitution score is the number of in-game hours he
// can go without drinking water with no chance of ill effects. After this time
// is up, he makes a DC 10 + (nubmer of previous checks) fortitude save every
// hour. Failing the check causes his fatigue meter to drop by 10 points.
const int HTF_BASE_THIRST_HOURS = 4;

// This plus the PC's base constitution score is the number of in-game hours he
// can go without eating food with no chance of ill effects. After this time
// is up, he makes a DC 10 + (number of previous checks) fortitude save every
// hour. Failing the check causes his fatigue meter to drop by 10 points.
const int HTF_BASE_HUNGER_HOURS = 12;

// This plus the PC's base constitution score is the number of in-game hours he
// can go without resting with no chance of ill effects. After this time period
// is up, he makes a DC 10 + (number of previous checks) fortitude save every
// hour. Failing the check makes him unable to increase his fatigue meter until
// he rests again.
const int HTF_BASE_FATIGUE_HOURS = 24;

// Toggles whether or not the HTF info bars are shown to the PC each hour.
const int HTF_DISPLAY_INFO_BARS = TRUE;

// This is base number of times per day each class can take a quick rest.
const int HTF_QUICK_RESTS_PER_DAY_CLASS_BARBARIAN            = 12;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_BARD                 = 6;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_CLERIC               = 8;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_DRUID                = 8;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_FIGHTER              = 10;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_MONK                 = 8;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_PALADIN              = 10;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_RANGER               = 6;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_ROGUE                = 6;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_SORCERER             = 6;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_WIZARD               = 6;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_ARCANE_ARCHER        = 8;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_ASSASSIN             = 6;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_BLACKGUARD           = 10;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_DIVINE_CHAMPION      = 10;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_DRAGON_DISCIPLE      = 8;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_DWARVEN_DEFENDER     = 12;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_HARPER               = 6;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_PALE_MASTER          = 6;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_PURPLE_DRAGON_KNIGHT = 10;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_SHADOWDANCER         = 6;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_SHIFTER              = 8;
const int HTF_QUICK_RESTS_PER_DAY_CLASS_WEAPON_MASTER        = 10;
