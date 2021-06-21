/*
Filename:           rest_firewood
System:             Rest (item script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
Rest system item script for the firewood (rest_firewood) item. This script fires
via tag-based scripting for the OnActivate event of this item.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "rest_i_main"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC   = GetItemActivator();
        object oItem = GetItemActivated();
        rest_UseFirewood(oPC, oItem);
    }
}
