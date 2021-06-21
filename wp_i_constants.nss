/*
Filename:           wp_i_constants
System:             Walk Waypoints (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 15, 2009
Summary:
Walk Waypoints system constants definition script. This file contains the
constants commonly used in the Walk Waypoints system. This script is consumed by
wp_i_main as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "g_i_generic"

// WP Walk Progressions
const int WP_WALK_PROGRESSION_PALINDROMIC = 1;
const int WP_WALK_PROGRESSION_CIRCULAR    = 2;
const int WP_WALK_PROGRESSION_RANDOM      = 3;

// Local variables
const string WP_DISABLE_WALK_WAYPOINTS = "WP_DISABLE_WALK_WAYPOINTS";
const string WP_PLAYING_ANIMATION = "WP_PLAYING_ANIMATION";
const string WP_WALK_PROGRESSION = "WP_WALK_PROGRESSION";

const string WP_PREVIOUS_AREA = "WP_PREVIOUS_AREA";
const string WP_WALKING_TO = "WP_WALKING_TO";
const string WP_CURRENT_WAYPOINT = "WP_CURRENT_WAYPOINT";
const string WP_LAST_HOUR_WALKED = "WP_LAST_HOUR_WALKED";
const string WP_LAST_HOUR_CHECKED = "WP_LAST_HOUR_CHECKED";

const string WP_WALKWAY_PAUSE = "WP_WALKWAY_PAUSE";
const string WP_WALKWAY_ANIMATION = "WP_WALKWAY_ANIMATION_";
const string WP_WALKWAY_DEBUG_VOLUME = "WP_WALKWAY_DEBUG_VOLUME";
const string WP_WALKWAY_FORCE_MOVE = "WP_WALKWAY_FORCE_MOVE";
const string WP_WALKWAY_SCRIPT = "WP_WALKWAY_SCRIPT_";

const string WP_WAYPOINT_SET_FACING = "WP_WAYPOINT_SET_FACING";

const string WP_CHECK_STUCK_LOCATION = "WP_CHECK_STUCK_LOCATION";
const string WP_CHECK_STUCK_COUNT_PRIMARY = "WP_CHECK_STUCK_COUNT_PRIMARY";
const string WP_CHECK_STUCK_COUNT_SECONDARY = "WP_CHECK_STUCK_COUNT_SECONDARY";

// Variable particles
const string WP_PREFIX      = "WP_";
const string WP_RUN         = "WP_RUN";
const string WP_TAG         = "WP_TAG";
const string WP_HOUR        = "_HOUR_";
const string WP_NUMBER      = "_NUMBER";
const string WP_SPEED       = "_SPEED";
const string WP_DURATION    = "_DURATION";
const string WP_HOUR_PREFIX = "WP_HOUR_";

// Walk conditions flagset
const string WP_WALK_CONDITION = "WalkCondition";

// If set, the creature's waypoints have been initialized.
const int WP_WALK_FLAG_INITIALIZED = FLAG1; // 0x00000001

// If set, the creature will walk its waypoints constantly,
// moving on in each OnHeartbeat event. Otherwise,
// it will walk to the next only when triggered by an
// OnPerception event.
const int WP_WALK_FLAG_CONSTANT    = FLAG2; // 0x00000002

// Set when the creature is walking back
const int WP_WALK_FLAG_BACKWARDS   = FLAG3; // 0x00000004


// Text strings

