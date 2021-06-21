/*
Filename:           htf_timer
System:             Hunger, Thirst, & Fatigue (timer script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
Runs hunger, thirst, and fatigue checks on the PC each time the script is fired
from the elapsed timer.

Revision Info should only be included for post-release revisions.
-----------------

Revision Date:
Revision Author:
Revision Summary:

*/

#include "htf_i_main"

void main()
{
    object oPC = OBJECT_SELF;
    htf_PerformChecks(oPC);
}
