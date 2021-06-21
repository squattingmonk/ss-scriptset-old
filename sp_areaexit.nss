/*
Filename:           sp_areaexit
System:             Spawn System (area exit event hook-in script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       March 11, 2008
Summary:

This script will start the area despawn timer if there are no players left.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Spawn system core include script.
#include "sp_i_main"

void main()
{
  object oArea = OBJECT_SELF;

  if (!GetLocalInt(oArea, SS_PLAYERS_IN_AREA) && GetLocalInt(OBJECT_SELF, SP_AREA_SPAWNS_ACTIVE))
  {
      ss_StartTimer(GetLocalInt(oArea, SP_AREA_TIMER_ID));
  }
}
