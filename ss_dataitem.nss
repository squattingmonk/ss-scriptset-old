/*
Filename:           ss_playerdata
System:             Core (player data item script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 20th, 2009
Summary:
This script fires whenever the player data item is activated.


Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ss_i_core"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent == X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC = GetItemActivator();
        AssignCommand(oPC, ActionStartConversation(oPC, SS_PLAYER_MENU_DIALOG, TRUE, FALSE));
    }

}

