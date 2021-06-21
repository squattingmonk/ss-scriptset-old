/*
Filename:           psc_i_main
System:             Persistent Storage Chest (include script)
Author:             HerMyT
Date Created:       Apr. 22, 2004
Summary:
PSC system main include script. This file holds the functions commonly used
throughout the PSC subsystem.

The scripts contained herein are based on those included in HerMyT's Persistent
Storage Chest, customized for compatibility with Shadows & Silver's needs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Nov. 9, 2008
Revision Author: Sherincall
Revision Summary:
    - Optimized all functions, performance increased slightly.
    - Cleaned up the code, removed obsolete lines, properly renamed variables,
      added comments and changed layout.
    - Fixed the bug with BioWare's database getting larger. Database is now
      destroyed and recreated on initialization.
    - Removed unused functions.
    - Set so that every chest has it's own database. Database name = Tag of chest.

Revision Date: Dec. 13, 2009
Revision Author: Squatting Monk
Revision Summary:
    - Converted functions from BioWare database to NWNX/MySQL.
    - Optimized all functions.
    - Removed function PSCDeleteIndexItem since it's unused.
    - Changed function signatures naming scheme (now using psc_ prefix).
    - Changed inline strings to constants where possible.

*/

// Core include script
#include "ss_i_core"

/******************************************************************************/
/*                                  Constants                                 */
/******************************************************************************/

const string PSC_SIZE = "PSC_SIZE";
const string PSC_INDEX = "PSC_INDEX";
const string PSC_ITEM_PREFIX = "PSC_ITEM_";
const string PSC_INITIALIZED = "PSC_INITIALIZED";


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// >----< psc_InitializeContainer >----<
// <psc_i_main>
// Initalizes oContainer, deleting any items that are in it and populating it
// with items from the database.
// Call this OnOpened.
void psc_InitializeContainer(object oContainer);

// >----< psc_DeleteItem >----<
// <psc_i_main>
// Deletes oItem from the database associated with oContainer.
// Call this when an item is removed from oContainer.
void psc_DeleteItem(object oItem, object oContainer);

// >----< psc_AddItem >----<
// <psc_i_main>
// Stores oItem int the database associated with oContainer.
// Call this when an item is added to oContainer.
void psc_AddItem(object oItem, object oContainer);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

void psc_InitializeContainer(object oContainer)
{


    int nSize = ss_GetDatabaseInt(PSC_SIZE, oContainer);


    // Destroy any items that might happen to be in the chest upon initializing.
    object oItem = GetFirstItemInInventory(oContainer);
    while (oItem != OBJECT_INVALID)
    {
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(oItem2 != OBJECT_INVALID)
            {
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oContainer);
    }

    // Populate the chest
    int i = 0;
    while (i < nSize)
    {
        i++;
        oItem = ss_GetDatabaseObject(PSC_ITEM_PREFIX + IntToString(i), oContainer);
        ss_Debug(GetName(oItem));
        ss_Debug(IntToString(i));
        SetLocalInt(oItem, PSC_INDEX, i);
        SetLocalObject(oContainer, PSC_ITEM_PREFIX + IntToString(i), oItem);
    }

    // Set flags
    SetLocalInt(oContainer, PSC_SIZE, i);
    SetLocalInt(oContainer, PSC_INITIALIZED, 1);
}

void psc_DeleteItem(object oItem, object oContainer)
{

    int nIndex = GetLocalInt(oItem, PSC_INDEX);
    int nSize = GetLocalInt(oContainer, PSC_SIZE);

    if (nSize > 1)
    {
        if (nIndex == nSize)
        {
            ss_DeleteDatabaseObject(PSC_ITEM_PREFIX + IntToString(nIndex), oContainer);
            DeleteLocalObject(oContainer, PSC_ITEM_PREFIX + IntToString(nIndex));
            nSize--;
            ss_SetDatabaseInt(PSC_SIZE, nSize, oContainer);
            SetLocalInt(oContainer, PSC_SIZE, nSize);
        }
        else
        {
            oItem = GetLocalObject(oContainer, PSC_ITEM_PREFIX + IntToString(nSize));
            SetLocalInt(oItem, PSC_INDEX, nIndex);
            SetLocalObject(oContainer, PSC_ITEM_PREFIX + IntToString(nIndex), oItem);
            ss_SetDatabaseObject(PSC_ITEM_PREFIX + IntToString(nIndex), oItem, oContainer);
            ss_DeleteDatabaseObject(PSC_ITEM_PREFIX + IntToString(nSize), oContainer);
            DeleteLocalObject(oContainer, PSC_ITEM_PREFIX + IntToString(nSize));
            nSize--;
            ss_SetDatabaseInt(PSC_SIZE, nSize, oContainer);
            SetLocalInt(oContainer, PSC_SIZE, nSize);
        }
    }
    else
    {
        DeleteLocalObject(oContainer, PSC_ITEM_PREFIX + IntToString(nIndex));
        ss_DeleteDatabaseObject(PSC_ITEM_PREFIX + IntToString(nIndex), oContainer);
        nSize = 0;
        ss_SetDatabaseInt(PSC_SIZE, nSize, oContainer);
        SetLocalInt(oContainer, PSC_SIZE, nSize);
    }


}

void psc_AddItem(object oItem, object oContainer)
{


    int nSize = GetLocalInt(oContainer, PSC_SIZE);
    nSize++;

    if (nSize < 1)
        nSize = 1;


    ss_SetDatabaseInt(PSC_SIZE, nSize, oContainer);
    SetLocalInt(oContainer, PSC_SIZE, nSize);
    SetLocalObject(oContainer, PSC_ITEM_PREFIX + IntToString(nSize), oItem);
    SetLocalInt(oItem, PSC_INDEX, nSize);
    ss_SetDatabaseObject(PSC_ITEM_PREFIX + IntToString(nSize), oItem, oContainer);
}
