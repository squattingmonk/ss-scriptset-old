/*
Filename:           htf_quickrest
System:             Hunger, Thirst, & Fatigue (executed script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
This script is called via ExecuteScript from the action script of a node in the
rest menu dialog. It makes the PC perform a quick rest.

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
    htf_DoQuickRest(oPC);
}

