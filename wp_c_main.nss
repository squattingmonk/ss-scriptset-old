/*
Filename:           wp_c_main
System:             Walk Waypoints (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 15, 2009
Summary:
Walk Waypoints system configuration settings. This script contains
user-definable toggles and settings for the Walk Waypoints system.

This script is freely editable by developers. It should not contain any
constants that should not be overridable by other builders. Please put those in
wp_i_constants.

All below constants may be overridden, but do not alter the names of the
constants.

This script is consumed by wp_i_main as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "wp_i_constants"

// Whether NPCs should run to their next waypoint by default.
const int WP_DEFAULT_RUN_TO_WAYPOINTS = FALSE;

// The default pause after reaching a waypoint before taking further actions.
// Setting this higher will reduce server load at the cost of reduced WalkWP
// performance.
// Default value: 1.0
const float WP_DEFAULT_PAUSE_AT_WAYPOINT = 1.0;

// This is the default progression NPCs use when walking waypoints if one is not
// defined for them.
// Possible values:
// - WP_WALK_PROGRESSION_PALINDROMIC (1, 2, 3, 4, 3, 2...)
// - WP_WALK_PROGRESSION_CIRCULAR    (1, 2, 3, 4, 1, 2...)
// - WP_WALK_PROGRESSION_RANDOM
const int WP_DEFAULT_WALK_PROGRESSION = WP_WALK_PROGRESSION_PALINDROMIC;

// If TRUE, this will allow NPCs waypoint walkers to cross areas.
// Default value: TRUE
const int WP_ENABLE_CROSS_AREA_WALKWAYPOINTS = TRUE;

// If set to TRUE, this will enable the stuck detection system. This attempts to
// set stuck NPCs moving, teleporing those that it can't.
const int WP_ENABLE_STUCK_DETECTION = TRUE;

// This is the number of rounds before the NPC is considered stuck and a
// correction is attempted to try to get him walking again.
const int WP_STUCK_DETECTION_PRIMARY_THRESHOLD = 1;

// This is the number of corrections attempted before all hope is given up on
// the stuck NPC walking and he simply jumps to the waypoint.
const int WP_STUCK_DETECTION_SECONDARY_THRESHOLD = 4;

