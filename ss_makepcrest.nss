/*
Filename:           ss_makepcrest
System:             Core (executed script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 20, 2008
Summary:
This script is called via ExecuteScript from the action script of a node in the
rest menu dialog. It makes the PC actually rest without reopening the dialog.

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
    ss_MakePCRest(oPC);
}

