/*
Filename:           wp_spawn
System:             Walk Waypoints (creature spawn event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       May 4, 2009
Summary:
Creature OnSpawn script for the Walk Waypoints system. It makes the creature
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
    wp_WalkWayPoints();
}
