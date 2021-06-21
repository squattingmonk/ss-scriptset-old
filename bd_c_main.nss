/*
Filename:           bd_c_main
System:             Bleeding and Death (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 09, 2009
Summary:
Bleeding and Death system configuration settings. This script contains
user-definable toggles and settings for the Bleeding and Death system.

This script is freely editable by developers. It should not contain any
constants that should not be overridable by other builders. Please put those in
bd_i_constants.

All below constants may be overridden, but do not alter the names of the
constants.

This script is consumed by bd_i_main as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// The number of seconds between when the player character bleeds while dying.
// Note this is seconds in real time, not game time.
// Default value: 6 seconds
const float BD_BLEED_DELAY = 6.0;

// The percent chance the PC will recover from the dying state. One check is
// made each round the PC is dying.
// Default value: 5
const int BD_RECOVERY_CHANCE = 5;

// The percent chance the PC will keep bleeding. On check is made each round the
// PC is dying.
// Default value: 50
const int BD_BLEED_CHANCE = 50;

// Amount of hitpoints lost when a player character bleeds.
// Default value: 1
const int BD_BLEED_DAMAGE = 1;

// The number of hitpoints per level the player should have after recovering.
// Set to 0 to give the player only 1 hit point, regardless of level.
// Default value: 2
const int BD_RECOVERY_HIT_POINTS_PER_LEVEL = 2;

// The number by which the PC's max hit points are divided by to get his max
// negative hit points.
// Example: If this value is set to 2 and the PC's max hit points is 40, then he
// dies at -20 hit points (40 / 2).
// Default value: 2
const int BD_NEGATIVE_HP_LIMIT_DIVISOR = 2;

// The minimum negative hit points a character must have before dying.
// Default value: 10
const int BD_DEATH_RANGE_MIN = 10;

// The maximum negative hit points a character can have before dying.
// Default value: 100 (do not set higher than the negative HP limit in nwnx.ini)
const int BD_DEATH_RANGE_MAX = 100;

// The base percent chance that a player will miraculously recover from death.
const int BD_MIRACULOUS_RECOVERY_CHANCE = 25;

// The bonus to miraculous recovery a player receives per level.
const int BD_MIRACULOUS_RECOVERY_LEVEL_BONUS = 1;

// The bonus to miraculous recovery a player receives per point in Constitution.
const int BD_MIRACULOUS_RECOVERY_CONSTITUTION_BONUS = 1;

// The penalty to miraculous recovery a player receives per previous miraculous
// recovery.
const int BD_MIRACULOUS_RECOVERY_PREVIOUS_RECOVERY_PENALTY = 3;

// The tag of the area the PC is to be sent to on death.
const string BD_DEATH_AREA = "bd_deathplane";

// The number of seconds between when the player dies and when he is forcibly
// sent to the fugue plane.
// Default value: 600.0 (ten minutes)
const float BD_SECONDS_TO_LINGER_AFTER_DEATH = 600.0;
