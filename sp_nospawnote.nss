/*
Filename:           sp_nospawnonote
System:             Spawn System (Trigger OnEnter script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       January 15, 2009
Summary:

On Enter script for the No Spawn trigger. Jumps newly spawned creatures to
another location if they are spawned inside it.


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
     object oArea = GetArea(OBJECT_SELF);
     if (!GetLocalInt(oArea, SP_AREA_SPAWNING_IN_PROGRESS))
        return;

     object oCreature = GetEnteringObject();
     if (!GetLocalInt(oCreature, SP_CREATURE_IS_AREASPAWN))
        return;
     AssignCommand(oCreature, ActionJumpToLocation(ss_GetRandomLocation(oArea)));
}

