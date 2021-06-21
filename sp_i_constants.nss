/*
Filename:           sp_i_constants
System:             Spawn System (include script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       January 14, 2009
Summary:

Spawn System constants definition script. This file contains the constants
commonly used in the spawn system. This script is consumed by sp_i_main as an
include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


// Waypoint / Trigger tags
const string SP_AREA_SPAWNPOINT             = "SP_AREA_SPAWNPOINT";
const string SP_UNIQUE_SPAWNPOINT           = "SP_UNIQUE_SPAWNPOINT";
const string SP_NO_SPAWN_TRIGGER            = "SP_NO_SPAWN_TRIGGER";

// Local Variable Names
const string SP_AREA_SPAWNS_ACTIVE          = "SP_AREA_SPAWNS_ACTIVE";
const string SP_EQUIPMENT_CHEST_TAG         = "SP_EQUIPMENT_CHEST_TAG";
const string SP_EQUIPMENT_CHEST_PROBABILITY = "SP_EQUIPMENT_CHEST_PROBABILITY";
const string SP_CREATURE_RESREF             = "SP_CREATURE_RESREF";
const string SP_CREATURE_PROBABILITY        = "SP_CREATURE_PROBABILITY";
const string SP_CREATURE_IS_UNIQUE          = "SP_CREATURE_IS_UNIQUE";
const string SP_CREATURE_IS_AREASPAWN       = "SP_CREATURE_IS_AREASPAWN";
const string SP_CREATURE_NO_DESPAWN         = "SP_CREATURE_NO_DESPAWN";
const string SP_AREA_TIMER_ID               = "SP_AREA_TIMER_ID";
const string SP_EXECUTE_TIMER               = "SP_EXECUTE_TIMER";
const string SP_AREA_SPAWNING_IN_PROGRESS   = "SP_AREA_SPAWNING_IN_PROGRESS";
const string SP_SPAWN_ACTIVE_START_HOUR     = "SP_SPAWN_ACTIVE_START_HOUR";
const string SP_SPAWN_ACTIVE_STOP_HOUR      = "SP_SPAWN_ACTIVE_STOP_HOUR";

const string SP_DESPAWN_TIMER_SCRIPT        = "sp_despawntimer";

// Maximal number of head model to be used.
// Needs to be changed everytime a new head model has been added.
const int SP_HEADMODEL_MAX_MALE_DWARF       = 1;
const int SP_HEADMODEL_MAX_MALE_ELF         = 1;
const int SP_HEADMODEL_MAX_MALE_GNOME       = 1;
const int SP_HEADMODEL_MAX_MALE_HALFELF     = 1;
const int SP_HEADMODEL_MAX_MALE_HALFLING    = 1;
const int SP_HEADMODEL_MAX_MALE_HALFORC     = 1;
const int SP_HEADMODEL_MAX_MALE_HUMAN       = 1;
const int SP_HEADMODEL_MAX_FEMALE_DWARF     = 1;
const int SP_HEADMODEL_MAX_FEMALE_ELF       = 1;
const int SP_HEADMODEL_MAX_FEMALE_GNOME     = 1;
const int SP_HEADMODEL_MAX_FEMALE_HALFELF   = 1;
const int SP_HEADMODEL_MAX_FEMALE_HALFLING  = 1;
const int SP_HEADMODEL_MAX_FEMALE_HALFORC   = 1;
const int SP_HEADMODEL_MAX_FEMALE_HUMAN     = 1;


// Error messages
const string SP_ERROR_INVALID_CREATURE_SPAWN = "[SPAWN SYSTEM] Error - Invalid Spawn Creature: ";
