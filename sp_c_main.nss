/*
Filename:           sp_c_main
System:             Spawn System (include script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       January 15, 2009
Summary:

Spawn System configuration script. This file contains the constants used to
configure the system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Seconds to wait before all creatures are despawned from an empty area.
const float SP_DESPAWN_EMPTY_AREA_DELAY = 120.0;  // Default 120 (2 minutes)

// Turns the Random equipment sub-system on/off
const int SP_USE_RANDOM_EQUIPMENT_SUBSYSTEM = TRUE;

// Turns the NPC Random Appearance sub-system on/off
const int SP_USE_NRA_SUBSYSTEM  =   TRUE;

// Turns the Stat Randomization sub-system on/off
const int SP_USE_STAT_RANDOMIZATION_SUBSYSTEM = TRUE;

// The maximum amount a randomized stat can differ from the one in the creature
const int SP_STAT_RANDOMIZATION_OFFSET = 4;  // Default 4


//HIVES SUBSYSTEM IS NOT FINISHED

// Turns the Hives sub-system on/off
const int SP_USE_HIVES_SUBSYSTEM    =   TRUE;

// Modifies the hive's growth speed
const float SP_HIVES_GROWTH_MODIFICATION = 1.0; // Default 1.0 (No modification)

