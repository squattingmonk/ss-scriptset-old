/*
Filename:           rest_c_main
System:             Rest (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 29, 2008
Summary:
Rest system configuration settings. This script contains user-definable toggles
and settings for the Rest system.

This script is freely editable by developers. It should not contain any
constants that should not be overridable by other builders. Please put those in
rest_i_constants.

All below constants may be overridden, but do not alter the names of the
constants.

This script is consumed by rest_i_main as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Minimum time in real seconds that must pass since the last time a PC rested
// and recovered spells, feats, and health for him to recover them again when
// he rests. To not require any minimum elapsed time, set the value to 0.
// Recommended Equation: [Minutes per game hour] * 60 * 4; (4 game hours)
// Default value: 1440 (4 game hours at 6 RL minutes per game hour)
const int REST_MINIMUM_RECOVERY_TIME = 1440;

// Amount of hit points per level the PC heals when resting after the minimum
// time above has passed. To allow PCs to heal to maximum hitpoints, set the
// value to -1. Note that some with rest event hook-in scripts may alter the
// final amount of HP healed after the rest to a value different than what would
// result from the value you specify below, even if the value is -1.
// The default value is -1.
const int REST_HP_HEALED_PER_REST_PER_LEVEL = -1;

// Set this value to true to create a fade to black and snoring visual effect on
// PCs who rest with recovery.
const int REST_SLEEP_EFFECTS = TRUE;

// Set this to true to only allow resting inside designated trigger zones or
// within 4 meters of a campfire.
const int REST_REQUIRE_TRIGGER_OR_CAMPFIRE = TRUE;

// The tag of the campfire placeable to be used.
const string REST_CAMPFIRE = "rest_campfire";

// The number of game hours a campfire should last.
const int REST_CAMPFIRE_BURN_TIME = 4;
