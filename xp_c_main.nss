/*
Filename:           xp_c_main
System:             Experience (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Apr. 25, 2008
Summary:
XP System user configuration variable settings. This script is consumed by
xp_i_main as an include directive. It contains user-definable toggles for the XP
system.

This script is freely editable by the mod builder. It should not contain any
functions or constants that should not be overrideable by the user; please put
those in xp_i_main.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// The tag of the waypoint which will store important variables of the XP
// system. Only change this if you are using a different waypoint than that
// included in the ERF.
// Default value: XP_DATAPOINT
const string XP_DATAPOINT = "XP_DATAPOINT";


/********************************************/
/* System Toggles                           */
/********************************************/

// Toggles the XP testing mode. If set to true, this will enable debug
// information on XP functions and interactions. Turn off on module release.
const int XP_TESTING_MODE = TRUE;

// Toggles whether the XP system will use SetXP rather than GiveXPToCreature to
// grant XP. This allows the system to bypass any hardcoded penalties to XP gain
// such as those from multiclassing.
const int XP_USE_SETXP = TRUE;

// Toggles whether PC level gets computed based on his total XP instead of
// using GetLevelBy functions. This prevents players from exploiting the system
// by not leveling up when they gain enough XP to reach the next level.
const int XP_USE_TOTAL_XP_TO_COMPUTE_LEVEL = TRUE;

// Toggles whether total level will be used to modify XP. If this is set to
// FALSE, all of the XP_MODIFIER_LEVEL_* constants below will have no effect.
const int XP_USE_LEVEL_MODIFIERS = TRUE;

// Toggles whether class will be used to modify XP. If this is set to FALSE,
// classes will not receive different modifiers to total XP given.
const int XP_USE_CLASS_MODIFIERS = TRUE;

// Toggles whether race will be used to modify XP. If this is set to FALSE,
// races will not receive different modifiers to total XP given.
const int XP_USE_RACE_MODIFIERS = TRUE;

// Toggles whether subrace will be used to modify XP. If this is set to FALSE,
// subraces will not receive different modifiers to total XP given.
const int XP_USE_SUBRACE_MODIFIERS = TRUE;

// Toggles whether XP type will be used to modify XP. If this is set to FALSE,
// XP will not be modified based on the type of XP.
const int XP_USE_TYPE_MODIFIERS = TRUE;

// Toggles whether class will be used to modify XP based on the XP type.
// NOTE: If XP_USE_TYPE_MODIFIERS is set to FALSE, this will have no effect
// no matter what its setting.
const int XP_USE_CLASS_TYPE_MODIFIERS = TRUE;

// Toggles whether or not the user will receive a message telling him what type
// of XP he earned when gaining XP. This has no effect if XP_USE_TYPE_MODIFIERS
// is set to FALSE.
const int XP_USE_TYPE_MESSAGES = TRUE;

// The minimum XP that can be gained.
const int XP_GLOBAL_MIN = 0;

// The maximum XP that can be gained. Set this to 0 for no maximum (not recommended).
const int XP_GLOBAL_MAX = 1000;


/********************************************/
/* Global, Level, Class, and Type Modifiers */
/********************************************/

// This setting controls how fast PCs level up in general (similar to the XP
// slider in the toolset). To gain a level, a PC needs to kill a combined CR of
// (PC LEVEL * 1000) / XP_MODIFIER_GLOBAL on average. Thus, higher for more XP.
// e.g., A level 10 needs to kill 100 CR 10 mobs to level using the default 10.0
//       global modifier. He will only need 50 CR 10 mobs if you set it to 20.0
//       Set this to 1000.0 and he only needs one CR10 mob to level.
// Default value: 10.0.
const float XP_MODIFIER_GLOBAL = 10.0;

// These settings modify XP gains based on the total level of the PC, allowing
// you to change the rate at which the PC levels. The default settings make
// leveling easy at low levels and extremely hard in epic levels. The pc would
// need to kill 100 level 10 creatures to level from 10 to 11, but several
// thousand CR 40 creatures to level from 39 to 40 with the default settings,
// not counting group bonus or other advanced modifiers.
// A value of 1 (01.000) means no xp change.
// Use value less than 1.0 to reduce the xp and greater than 1.0 to increase it.
const float XP_MODIFIER_LEVEL_1  = 11.000; // Default 11.000 (1000% bonus)
const float XP_MODIFIER_LEVEL_2  = 06.000; // Default 06.000 (500% bonus)
const float XP_MODIFIER_LEVEL_3  = 04.000; // Default 04.000 (300% bonus)
const float XP_MODIFIER_LEVEL_4  = 03.000; // Default 03.000 (200% bonus)
const float XP_MODIFIER_LEVEL_5  = 02.000; // Default 02.000 (100% bonus)
const float XP_MODIFIER_LEVEL_6  = 01.000; // Default 01.000 (0% bonus)
const float XP_MODIFIER_LEVEL_7  = 01.000; // Default 01.000 (0% bonus)
const float XP_MODIFIER_LEVEL_8  = 01.000; // Default 01.000 (0% bonus)
const float XP_MODIFIER_LEVEL_9  = 01.000; // Default 01.000 (0% bonus)
const float XP_MODIFIER_LEVEL_10 = 01.000; // Default 01.000 (0% bonus)
const float XP_MODIFIER_LEVEL_11 = 00.850; // Default 00.850 (15% penalty)
const float XP_MODIFIER_LEVEL_12 = 00.850; // Default 00.850 (15% penalty)
const float XP_MODIFIER_LEVEL_13 = 00.800; // Default 00.800 (20% penalty)
const float XP_MODIFIER_LEVEL_14 = 00.800; // Default 00.800 (20% penalty)
const float XP_MODIFIER_LEVEL_15 = 00.750; // Default 00.750 (25% penalty)
const float XP_MODIFIER_LEVEL_16 = 00.750; // Default 00.750 (25% penalty)
const float XP_MODIFIER_LEVEL_17 = 00.700; // Default 00.700 (30% penalty)
const float XP_MODIFIER_LEVEL_18 = 00.700; // Default 00.700 (30% penalty)
const float XP_MODIFIER_LEVEL_19 = 00.650; // Default 00.650 (35% penalty)
const float XP_MODIFIER_LEVEL_20 = 00.650; // Default 00.650 (35% penalty)
const float XP_MODIFIER_LEVEL_21 = 00.600; // Default 00.600 (40% penalty)
const float XP_MODIFIER_LEVEL_22 = 00.550; // Default 00.550 (45% penalty)
const float XP_MODIFIER_LEVEL_23 = 00.500; // Default 00.500 (50% penalty)
const float XP_MODIFIER_LEVEL_24 = 00.450; // Default 00.450 (55% penalty)
const float XP_MODIFIER_LEVEL_25 = 00.400; // Default 00.400 (60% penalty)
const float XP_MODIFIER_LEVEL_26 = 00.350; // Default 00.350 (65% penalty)
const float XP_MODIFIER_LEVEL_27 = 00.300; // Default 00.300 (70% penalty)
const float XP_MODIFIER_LEVEL_28 = 00.200; // Default 00.200 (80% penalty)
const float XP_MODIFIER_LEVEL_29 = 00.100; // Default 00.100 (90% penalty)
const float XP_MODIFIER_LEVEL_30 = 00.090; // Default 00.090 (91% penalty)
const float XP_MODIFIER_LEVEL_31 = 00.090; // Default 00.090 (91% penalty)
const float XP_MODIFIER_LEVEL_32 = 00.080; // Default 00.080 (92% penalty)
const float XP_MODIFIER_LEVEL_33 = 00.080; // Default 00.080 (92% penalty)
const float XP_MODIFIER_LEVEL_34 = 00.070; // Default 00.070 (93% penalty)
const float XP_MODIFIER_LEVEL_35 = 00.070; // Default 00.070 (93% penalty)
const float XP_MODIFIER_LEVEL_36 = 00.060; // Default 00.060 (94% penalty)
const float XP_MODIFIER_LEVEL_37 = 00.060; // Default 00.060 (94% penalty)
const float XP_MODIFIER_LEVEL_38 = 00.050; // Default 00.050 (95% penalty)
const float XP_MODIFIER_LEVEL_39 = 00.040; // Default 00.040 (96% penalty)

// These settings modify the total XP gained by members of a certain class. By
// changing these, you can limit how much XP a particular class gets.
// A value of 1 (1.00) means there is no change in the XP awarded.
const float XP_MODIFIER_CLASS_BARBARIAN            = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_BARD                 = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_CLERIC               = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_DRUID                = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_FIGHTER              = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_MONK                 = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_PALADIN              = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_RANGER               = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_ROGUE                = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_SORCERER             = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_WIZARD               = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_ARCANE_ARCHER        = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_ASSASSIN             = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_BLACKGUARD           = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_DIVINE_CHAMPION      = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_DRAGON_DISCIPLE      = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_DWARVEN_DEFENDER     = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_HARPER               = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_PALE_MASTER          = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_PURPLE_DRAGON_KNIGHT = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_SHADOWDANCER         = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_SHIFTER              = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_CLASS_WEAPON_MASTER        = 1.00; // Default 1.00 (0% bonus)

// These settings modify the total XP gained by members of a certain race. By
// changing these, you can limit how much XP a particular race gets.
// A value of 1 (1.00) means there is no change in the XP awarded.
const float XP_MODIFIER_RACE_DWARF    = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_RACE_ELF      = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_RACE_GNOME    = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_RACE_HALFELF  = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_RACE_HALFLING = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_RACE_HALFORC  = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_RACE_HUMAN    = 1.00; // Default 1.00 (0% bonus)

// These settings are the class-based modifiers to XP awards based on the type
// of XP gained. Class-based XP is broken down into Ability, Combat, Crafting,
// Discovery, and Magic.
// A value of 1 (1.00) means there is no change in the XP awarded.
// The percentage of XP members of each class will earn for ability usage:
const float XP_MODIFIER_TYPE_ABILITY_BARBARIAN            = 0.30; // Default 0.30 (70% penalty)
const float XP_MODIFIER_TYPE_ABILITY_BARD                 = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_ABILITY_CLERIC               = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_ABILITY_DRUID                = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_ABILITY_FIGHTER              = 0.30; // Default 0.30 (70% penalty)
const float XP_MODIFIER_TYPE_ABILITY_MONK                 = 0.90; // Default 0.90 (10% penalty)
const float XP_MODIFIER_TYPE_ABILITY_PALADIN              = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_ABILITY_RANGER               = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_ABILITY_ROGUE                = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_ABILITY_SORCERER             = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_ABILITY_WIZARD               = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_ABILITY_ARCANE_ARCHER        = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_ABILITY_ASSASSIN             = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_ABILITY_BLACKGUARD           = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_ABILITY_DIVINE_CHAMPION      = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_ABILITY_DRAGON_DISCIPLE      = 0.80; // Default 0.80 (20% penalty)
const float XP_MODIFIER_TYPE_ABILITY_DWARVEN_DEFENDER     = 0.30; // Default 0.30 (70% penalty)
const float XP_MODIFIER_TYPE_ABILITY_HARPER               = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_ABILITY_PALE_MASTER          = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_ABILITY_PURPLE_DRAGON_KNIGHT = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_ABILITY_SHADOWDANCER         = 0.90; // Default 0.90 (10% penalty)
const float XP_MODIFIER_TYPE_ABILITY_SHIFTER              = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_ABILITY_WEAPON_MASTER        = 0.25; // Default 0.25 (75% penalty)

// The percentage of XP members of each class will earn for combat:
const float XP_MODIFIER_TYPE_COMBAT_BARBARIAN            = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_COMBAT_BARD                 = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_COMBAT_CLERIC               = 0.35; // Default 0.35 (65% penalty)
const float XP_MODIFIER_TYPE_COMBAT_DRUID                = 0.45; // Default 0.45 (55% penalty)
const float XP_MODIFIER_TYPE_COMBAT_FIGHTER              = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_COMBAT_MONK                 = 0.75; // Default 0.75 (25% penalty)
const float XP_MODIFIER_TYPE_COMBAT_PALADIN              = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_COMBAT_RANGER               = 0.75; // Default 0.75 (25% penalty)
const float XP_MODIFIER_TYPE_COMBAT_ROGUE                = 0.65; // Default 0.65 (35% penalty)
const float XP_MODIFIER_TYPE_COMBAT_SORCERER             = 0.35; // Default 0.35 (65% penalty)
const float XP_MODIFIER_TYPE_COMBAT_WIZARD               = 0.30; // Default 0.30 (70% penalty)
const float XP_MODIFIER_TYPE_COMBAT_ARCANE_ARCHER        = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_COMBAT_ASSASSIN             = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_COMBAT_BLACKGUARD           = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_COMBAT_DIVINE_CHAMPION      = 0.75; // Default 0.75 (25% penalty)
const float XP_MODIFIER_TYPE_COMBAT_DRAGON_DISCIPLE      = 0.45; // Default 0.45 (55% penalty)
const float XP_MODIFIER_TYPE_COMBAT_DWARVEN_DEFENDER     = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_COMBAT_HARPER               = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_COMBAT_PALE_MASTER          = 0.40; // Default 0.40 (60% penalty)
const float XP_MODIFIER_TYPE_COMBAT_PURPLE_DRAGON_KNIGHT = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_COMBAT_SHADOWDANCER         = 0.40; // Default 0.40 (60% penalty)
const float XP_MODIFIER_TYPE_COMBAT_SHIFTER              = 0.45; // Default 0.45 (55% penalty)
const float XP_MODIFIER_TYPE_COMBAT_WEAPON_MASTER        = 1.00; // Default 1.00 (0% bonus)

// The percentage of XP members of each class will earn for crafting:
const float XP_MODIFIER_TYPE_CRAFTING_BARBARIAN            = 0.30; // Default 0.30 (70% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_BARD                 = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_CRAFTING_CLERIC               = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_DRUID                = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_FIGHTER              = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_MONK                 = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_PALADIN              = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_RANGER               = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_ROGUE                = 0.75; // Default 0.75 (25% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_SORCERER             = 0.75; // Default 0.75 (25% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_WIZARD               = 0.80; // Default 0.80 (20% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_ARCANE_ARCHER        = 0.80; // Default 0.80 (20% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_ASSASSIN             = 0.75; // Default 0.75 (25% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_BLACKGUARD           = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_DIVINE_CHAMPION      = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_DRAGON_DISCIPLE      = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_DWARVEN_DEFENDER     = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_HARPER               = 0.80; // Default 0.80 (20% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_PALE_MASTER          = 0.80; // Default 0.80 (20% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_PURPLE_DRAGON_KNIGHT = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_SHADOWDANCER         = 0.75; // Default 0.75 (25% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_SHIFTER              = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_CRAFTING_WEAPON_MASTER        = 0.45; // Default 0.45 (55% penalty)

// The percentage of XP members of each class will earn for discovery:
const float XP_MODIFIER_TYPE_DISCOVERY_BARBARIAN            = 0.10; // Default 0.10 (90% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_BARD                 = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_DISCOVERY_CLERIC               = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_DRUID                = 0.90; // Default 0.90 (10% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_FIGHTER              = 0.30; // Default 0.30 (70% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_MONK                 = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_PALADIN              = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_RANGER               = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_DISCOVERY_ROGUE                = 0.75; // Default 0.75 (25% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_SORCERER             = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_WIZARD               = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_ARCANE_ARCHER        = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_DISCOVERY_ASSASSIN             = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_BLACKGUARD           = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_DIVINE_CHAMPION      = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_DRAGON_DISCIPLE      = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_DWARVEN_DEFENDER     = 0.25; // Default 0.25 (75% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_HARPER               = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_DISCOVERY_PALE_MASTER          = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_PURPLE_DRAGON_KNIGHT = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_SHADOWDANCER         = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_SHIFTER              = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_DISCOVERY_WEAPON_MASTER        = 0.30; // Default 0.30 (70% penalty)

// The percentage of XP members of each class will earn for magic usage:
const float XP_MODIFIER_TYPE_MAGIC_BARBARIAN            = 0.05; // Default 0.05 (95% penalty)
const float XP_MODIFIER_TYPE_MAGIC_BARD                 = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_MAGIC_CLERIC               = 0.50; // Default 0.50 (50% penalty)
const float XP_MODIFIER_TYPE_MAGIC_DRUID                = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_MAGIC_FIGHTER              = 0.05; // Default 0.05 (95% penalty)
const float XP_MODIFIER_TYPE_MAGIC_MONK                 = 0.20; // Default 0.20 (80% penalty)
const float XP_MODIFIER_TYPE_MAGIC_PALADIN              = 0.30; // Default 0.30 (70% penalty)
const float XP_MODIFIER_TYPE_MAGIC_RANGER               = 0.25; // Default 0.25 (75% penalty)
const float XP_MODIFIER_TYPE_MAGIC_ROGUE                = 0.25; // Default 0.25 (75% penalty)
const float XP_MODIFIER_TYPE_MAGIC_SORCERER             = 1.00; // Default 1.00 (0% bonus)
const float XP_MODIFIER_TYPE_MAGIC_WIZARD               = 0.80; // Default 0.80 (20% penalty)
const float XP_MODIFIER_TYPE_MAGIC_ARCANE_ARCHER        = 0.60; // Default 0.60 (40% penalty)
const float XP_MODIFIER_TYPE_MAGIC_ASSASSIN             = 0.25; // Default 0.25 (75% penalty)
const float XP_MODIFIER_TYPE_MAGIC_BLACKGUARD           = 0.30; // Default 0.30 (70% penalty)
const float XP_MODIFIER_TYPE_MAGIC_DIVINE_CHAMPION      = 0.25; // Default 0.25 (75% penalty)
const float XP_MODIFIER_TYPE_MAGIC_DRAGON_DISCIPLE      = 0.90; // Default 0.90 (10% penalty)
const float XP_MODIFIER_TYPE_MAGIC_DWARVEN_DEFENDER     = 0.05; // Default 0.05 (95% penalty)
const float XP_MODIFIER_TYPE_MAGIC_HARPER               = 0.40; // Default 0.40 (60% penalty)
const float XP_MODIFIER_TYPE_MAGIC_PALE_MASTER          = 0.70; // Default 0.70 (30% penalty)
const float XP_MODIFIER_TYPE_MAGIC_PURPLE_DRAGON_KNIGHT = 0.30; // Default 0.30 (70% penalty)
const float XP_MODIFIER_TYPE_MAGIC_SHADOWDANCER         = 0.25; // Default 0.25 (75% penalty)
const float XP_MODIFIER_TYPE_MAGIC_SHIFTER              = 0.55; // Default 0.55 (45% penalty)
const float XP_MODIFIER_TYPE_MAGIC_WEAPON_MASTER        = 0.05; // Default 0.05 (95% penalty)


/********************************************/
/* Ability XP Defaults and Modifiers        */
/********************************************/

// This modifies the weight of Ability XP. Raise or lower this to increase or
// decrease Ability XP gain across the board, regardless of class.
// Set this to 0.00 to disable Ability XP entirely.
const float XP_MODIFIER_TYPE_ABILITY = 1.00; // Default 1.00

// The minimum XP for using an ability.
const int XP_ABILITY_MIN = 0;

// The maximum XP. Set this to 0 for no maximum (not recommended).
const int XP_ABILITY_MAX = 500;

// The base amount of XP for using skills and attrubutes. This number is
// multiplied the DC of the check minus 15 times XP_MODIFIER_GLOBAL.
const int XP_ABILITY_DEFAULT_XP = 1;

// The base amount of XP a PC gets for using the Bard Song ability. This is
// multiplied by the square of the number of PCs benefitted times the bard's
// class level times the persistent bard song XP reduction times XP_MODIFIER_GLOBAL.
// Set this to 0 to disable XP from Bard Song entirely.
const int XP_ABILITY_DEFAULT_BARDSONG = 1;

// The amount XP is reduced for each time the bard sings.
const float XP_ABILITY_REDUCTION_PER_BARDSONG = 0.01; // Default 0.01 (1% reduction)

// The maximum percentage XP can be reduced by using Bard Song.
// Set this to 1.00 to allow XP for using Bard Song to be reduced to 0.
const float XP_ABILITY_REDUCTION_PER_BARDSONG_MAXIMUM = 0.95; // Default 0.95 (95% reduction)


/********************************************/
/* Combat XP Defaults and Modifiers         */
/********************************************/

// This modifies the weight of Combat XP. Raise or lower this to increase or
// decrease Combat XP gain across the board, regardless of class.
// Set this to 0.00 to disable Combat XP entirely.
const float XP_MODIFIER_TYPE_COMBAT = 1.00; // Default 1.00

// The highest CR creature a PC can gain XP for killing.
const float XP_COMBAT_CR_MAX = 60.0;

// The minimum XP for a kill. If set higher than 0, this will override any XP
// reduction from CR or party level difference in the settings below.
const int XP_COMBAT_MIN = 0;

// The maximum XP for a kill. Set this to 0 for no maximum (not recommended).
const int XP_COMBAT_MAX = 500;

// The amount XP is reduced each time the PC kills a creature with a specific
// tag. This is stored persistently.
// Set this to 0.00 to disable combat XP reduction entirely.
const float XP_COMBAT_REDUCTION_PER_KILL = 0.10; // Default 0.10 (10% reduction)

// The amount XP is reduced each time the PC kills a creature with a specific
// tag that is one of his favored enemies. This is stored persistently.
// Set this to 0.00 to disable combat XP reduction for favored enemies entirely.
const float XP_COMBAT_REDUCTION_PER_FAVORED_ENEMY_KILL = 0.01; // Default 0.01 (1% reduction)

// The maximum amount XP can be reduced by killing a creature with a specific tag.
// Set this to 1.00 to allow XP for killing a creature to be reduced to 0.
const float XP_COMBAT_REDUCTION_PER_KILL_MAXIMUM = 0.95; // Default 0.95 (95% reduction)

// Party members (except the killer) need to be within this many meters of the
// creature to get XP from its death. If set to 0.0, distance does not matter.
const float XP_COMBAT_MAXIMUM_DISTANCE_FROM_KILL = 30.0;

// An amount by which XP earned from a kill will be multiplied for the PC who
// strikes the killing blow. If set to 0, the killer will receive no bonus.
const float XP_MODIFIER_COMBAT_KILLINGBLOW = 0.1; // Default 0.1 (10% bonus)

// An amount by which XP earned from a kill will be multiplied for partied PCs.
// Formula is (GroupSize - 1) * XP_MODIFIER_COMBAT_PARTY.
const float XP_MODIFIER_COMBAT_PARTY = 0.1; // Default 0.01 (10% bonus)

// The XP reduction scale for a PC's level being different than his kill's CR.
// Set lower for less reduction and higher for more.
// If set to 0, this disables all reduction of XP based on CR difference.
const float XP_MODIFIER_COMBAT_CR_SCALE = 1.0; // Default 1.0

// The XP reduction scale for a PC's level being different than the average
// party level.
// Set lower for less reduction and higher for more.
// If set to 0, this disables all reduction of XP based on level difference.
const float XP_MODIFIER_COMBAT_PARTY_SCALE = 1.0; // Default 1.0

// An amount by which the PC's level may surpass a creature's CR before he gains
// reduced XP for killing it.
// If set to 40, PCs receive no reduction for being higher level than the CR.
const float XP_COMBAT_CR_LESS_THAN_LEVEL_REDUCTION = 3.0;

// An amount by which the PC's level may surpass from a creature's CR before he
// gains no XP for killing it.
// If set to 41, PCs never receive no XP for being apart in level.
const float XP_COMBAT_CR_LESS_THAN_LEVEL_NOXP = 10.0;

// An amount by which the creature's CR may surpass a PC's level before he gains
// reduced XP for killing it.
// If set to XP_COMBAT_CR_MAX, PCs receive no reduction for being lower level
// than the CR.
const float XP_COMBAT_CR_GREATER_THAN_LEVEL_REDUCTION = 20.0;

// An amount by which the creature's CR may surpass a PC's level before he gains
// no XP for killing it.
// If set to XP_COMBAT_CR_MAX + 1, PCs never receive no XP for being lower level
// than the CR.
const float XP_COMBAT_CR_GREATER_THAN_LEVEL_NOXP = 30.0;

// An amount by which the PC's level may deviate from the party average before
// he gains reduced XP for combat kills.
// If set to 40, PCs receive no reduction for being apart in level.
const float XP_COMBAT_PARTY_LEVEL_DISTANCE_REDUCTION = 3.0;

// An amount by which the PC's level may deviate from the party average before
// he gains no XP from combat kills.
// If set to 41, PCs never receive no XP for being apart in level.
const float XP_COMBAT_PARTY_LEVEL_DISTANCE_NOXP = 6.0;

// These settings divide up XP among the various possible party members. Each
// member takes XP based on the weight of their setting (highest should be 1).
// For example, with the default settings, a party of two PCs, 1 familiar, and 1
// summoned creature gets a total XP divisor of 2.50. If they kill a 1000XP
// monster, both PCs only receive 400 XP each, since 1000 * 2.50 = 400.
// If you set XP_DIVISOR_PC != 1.00, you can let PCs gain more or less than an
// even share of the XP (i.e., < 1.00 for more XP, > 1.00 for less).
const float XP_COMBAT_DIVISOR_PC              = 1.00; // Default 1.00
const float XP_COMBAT_DIVISOR_DOMINATED       = 0.50; // Default 0.50
const float XP_COMBAT_DIVISOR_HENCHMAN        = 0.50; // Default 0.50
const float XP_COMBAT_DIVISOR_SUMMONED        = 0.30; // Default 0.30
const float XP_COMBAT_DIVISOR_ANIMALCOMPANION = 0.20; // Default 0.20
const float XP_COMBAT_DIVISOR_FAMILIAR        = 0.20; // Default 0.20
const float XP_COMBAT_DIVISOR_UNKNOWN         = 0.50; // Default 0.50 (used for associates of unknown types)


/********************************************/
/* Crafting XP Defaults and Modifiers       */
/********************************************/

// This modifies the weight of Crafting XP. Raise or lower this to increase or
// decrease Crafting XP gain across the board, regardless of class.
// Set this to 0.00 to disable Crafting XP entirely.
const float XP_MODIFIER_TYPE_CRAFTING = 1.00; // Default 1.00

// The minimum XP for crafting an item.
const int XP_CRAFTING_MIN = 0;

// The maximum XP for crafting an item. Set this to 0 for no maximum (not
// recommended).
const int XP_CRAFTING_MAX = 500;

// The base amount of XP a PC gets for crafting an item. This is multiplied by
// the DC of the crafting attempt minus 10.
const int XP_CRAFTING_DEFAULT = 10;


/********************************************/
/* Discovery XP Defaults and Modifiers      */
/********************************************/

// This modifies the weight of Discovery XP. Raise or lower this to increase or
// decrease Discovery XP gain across the board, regardless of class.
// Set this to 0.00 to disable Discovery XP entirely.
const float XP_MODIFIER_TYPE_DISCOVERY = 1.00; // Default 1.00

// The minimum XP for discovering something new.
const int XP_DISCOVERY_MIN = 0;

// The maximum XP for discovering something new. Set this to 0 for no maximum
// (not recommended).
const int XP_DISCOVERY_MAX = 500;

// The default amount of XP given to the player when he enters a previously
// unexplored area. This is multiplied by XP_MODIFIER_GLOBAL.
// Set this to 0 to disable XP from area exploration entirely.
const int XP_DISCOVERY_DEFAULT_AREA_EXPLORATION = 10;

// The default amount of XP given to the player when he discovers something new.
// This is multiplied by XP_MODIFIER_GLOBAL.
// Set this to 0 to disable XP from general discovery entirely.
const int XP_DISCOVERY_DEFAULT_GENERAL = 5;


/********************************************/
/* Magic XP Defaults and Modifiers          */
/********************************************/

// This modifies the weight of Magic XP. Raise or lower this to increase or
// decrease Magic XP gain across the board, regardless of class.
// Set this to 0.00 to disable Magic XP entirely.
const float XP_MODIFIER_TYPE_MAGIC = 1.00; // Default 1.00

// The minimum XP for harnessing magic.
const int XP_MAGIC_MIN = 0;

// The maximum XP for harnessing magic. Set this to 0 for no maximum (not
// recommended).
const int XP_MAGIC_MAX = 500;

// The default amount of XP given to the player when he casts a spell. This is
// multiplied by XP_MODIFIER_GLOBAL.
// Set this to 0 to disable XP from spellcasting entirely.
const int XP_MAGIC_DEFAULT_SPELL_CAST = 10;

// The amount XP is reduced each time a specific spell is cast.
// Set this to 0.00 to disable combat XP reduction entirely.
const float XP_MAGIC_REDUCTION_PER_SPELL_CAST = 0.10; // default 0.10 (10% reduction)

// The maximum amount XP can be reduced from casting a specific spell.
// Set this to 1.00 to allow XP for killing a creature to be reduced to 0.
const float XP_MAGIC_REDUCTION_PER_SPELL_CAST_MAXIMUM = 0.95; // Default 0.95 (95% reduction)
