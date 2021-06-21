/*
Filename:           ss_savelocation
System:             Core (timer script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2009
Summary:
Saves the PC's location each time the script is fired from the elapsed timer.

Revision Info should only be included for post-release revisions.
-----------------

Revision Date:
Revision Author:
Revision Summary:

*/

#include "ss_i_core"

void main()
{
    object oPC = OBJECT_SELF;
    if (GetIsObjectValid(oPC) && GetIsPC(oPC))
        ss_SavePCLocation(oPC);
}
