/*
Filename:           wp_heartbeat
System:             Walk Waypoints (creature heartbeat event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 11, 2009
Summary:
Creature OnHeartbeat script for the Walk Waypoints system. It makes the creature
walk his waypoints.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "wp_i_main"

void main()
{
    if (wp_GetWalkCondition(WP_WALK_FLAG_CONSTANT))
    {
        wp_DetectStuckWayWalker();
        wp_WalkWayPoints(WP_DEFAULT_RUN_TO_WAYPOINTS, WP_DEFAULT_PAUSE_AT_WAYPOINT, TRUE);
    }
}
