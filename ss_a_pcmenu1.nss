/*
Filename:           ss_a_pcmenu1
System:             Core (ss_pcmenu action script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 20th, 2009
Summary:
Action script fired when the 1st menu item in the player menu is selected.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "ss_i_core"

void main()
{
    string sDialogResRef = ss_GetGlobalString(SS_DIALOG_RESREF + "1");
    if (sDialogResRef != "")
        AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, sDialogResRef, TRUE, FALSE));
}

