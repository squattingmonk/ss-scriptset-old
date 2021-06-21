/*
Filename:           psc_disturbed
System:             Persistent Storage Chest (hook-in script)
Author:             Sherincall
Date Created:       Nov. 4th, 2008
Summary:
OnDisturbed script for Persistent Storage Chest (PSC) system. Handles adding and
removing items from the database once the caller's inventory is disturbed.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:
*/

#include "psc_i_main"


void main()
{
    int nDisturbType = GetInventoryDisturbType();
    object oItem = GetInventoryDisturbItem();

    if (nDisturbType == INVENTORY_DISTURB_TYPE_ADDED)
        psc_AddItem(oItem, OBJECT_SELF);
    else if (nDisturbType == INVENTORY_DISTURB_TYPE_REMOVED)
        psc_DeleteItem(oItem, OBJECT_SELF);

}
