/*
Filename:           htf_canteen
System:             Hunger, Thirst, & Fatigue (item script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
This script fires whenever the a canteen is activated.

If you wish to support canteens that use a different tag, you should save a copy
of this script as the name of the tag you want to support.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "htf_i_main"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC   = GetItemActivator();
        object oItem = GetItemActivated();
        htf_UseCanteen(oPC, oItem);
    }
}
