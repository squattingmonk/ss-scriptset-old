/*
Filename:           ss_a_restmenu3
System:             Core (rest menu action script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 20, 2009
Summary:
Action script fired when the 3rd item in the rest menu dialog
is selected.

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
    string sActionScript = GetLocalString(oPC, SS_REST_MENU_ACTION_SCRIPT + "3");
    ExecuteScript(sActionScript, oPC);
}

