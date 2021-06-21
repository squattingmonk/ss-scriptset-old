/*
Filename:           htf_cliententer
System:             Hunger, Thirst, & Fatigue (client enter event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
OnClientEnter script for the HTF system. This script will begin the HTF check
timers on the player when he logs in.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// HTF system include script.
#include "htf_i_main"

void main()
{
    object oPC = GetEnteringObject();
    if (GetIsPC(oPC))
        htf_InitialCheck(oPC);
}
