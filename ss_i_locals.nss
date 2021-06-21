/*
Filename:           ss_i_locals
System:             Core (local persistence include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Nov. 6, 2008
Summary:

Core local persistence include script. This script is consumed by
ss_i_persistence as an include directive. It contains functions for setting,
getting, and deleting local variables on the global data point and player data
items.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// String manipulation include script
#include "ss_i_text"

/******************************************************************************/
/*                    Player Data Item Function Prototypes                    */
/******************************************************************************/

// ---< ss_SetPlayerFloat >---
// ---< ss_i_locals >---
// Sets a variable of type float on oPC's player data item.
// - oPC: the PC associated with this variable.
// - sVarName: name of the variable to assign.
// - fFloat: the value to be set to the variable.
void ss_SetPlayerFloat(object oPC, string sVarName, float fFloat);

// ---< ss_GetPlayerFloat >---
// ---< ss_i_locals >---
// Returns a variable of type float from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to retrieve.
float ss_GetPlayerFloat(object oPC, string sVarName);

// ---< ss_DeletePlayerFloat >---
// ---< ss_i_locals >---
// Deletes a variable of type float of the given name from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to delete.
void ss_DeletePlayerFloat(object oPC, string sVarName);

// ---< ss_SetPlayerInt >---
// ---< ss_i_locals >---
// Sets a variable of type int on oPC's player data item.
// - oPC: the PC associated with this variable.
// - sVarName: name of the variable to assign.
// - nInt: the value to be set to the variable.
void ss_SetPlayerInt(object oPC, string sVarName, int nInt);

// ---< ss_GetPlayerInt >---
// ---< ss_i_locals >---
// Returns a variable of type float from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to retrieve.
int ss_GetPlayerInt(object oPC, string sVarName);

// ---< ss_DeletePlayerInt >---
// ---< ss_i_locals >---
// Deletes a variable of type int of the given name from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to delete.
void ss_DeletePlayerInt(object oPC, string sVarName);

// ---< ss_SetPlayerLocation >---
// ---< ss_i_locals >---
// Sets a variable of type location on oPC's player data item.
// - oPC: the PC associated with this variable.
// - sVarName: name of the variable to assign.
// - lLocation: the value to be set to the variable.
void ss_SetPlayerLocation(object oPC, string sVarName, location lLocation);

// ---< ss_GetPlayerLocation >---
// ---< ss_i_locals >---
// Returns a variable of type float from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to retrieve.
location ss_GetPlayerLocation(object oPC, string sVarName);

// ---< ss_DeletePlayerLocation >---
// ---< ss_i_locals >---
// Deletes a variable of type location of the given name from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to delete.
void ss_DeletePlayerLocation(object oPC, string sVarName);

// ---< ss_SetPlayerString >---
// ---< ss_i_locals >---
// Sets a variable of type string on oPC's player data item.
// - oPC: the PC associated with this variable.
// - sVarName: name of the variable to assign.
// - sString: the value to be set to the variable.
void ss_SetPlayerString(object oPC, string sVarName, string sString);

// ---< ss_GetPlayerString >---
// ---< ss_i_locals >---
// Returns a variable of type float from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to retrieve.
string ss_GetPlayerString(object oPC, string sVarName);

// ---< ss_DeletePlayerFloat >---
// ---< ss_i_locals >---
// Deletes a variable of type string of the given name from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to delete.
void ss_DeletePlayerFloat(object oPC, string sVarName);

// ---< ss_SetPlayerObject >---
// ---< ss_i_locals >---
// Sets a variable of type object on oPC's player data item.
// - oPC: the PC associated with this variable.
// - sVarName: name of the variable to assign.
// - oObject: the value to be set to the variable.
void ss_SetPlayerObject(object oPC, string sVarName, object oObject);

// ---< ss_GetPlayerObject >---
// ---< ss_i_locals >---
// Returns a variable of type float from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to retrieve.
object ss_GetPlayerObject(object oPC, string sVarName);

// ---< ss_DeletePlayerObject >---
// ---< ss_i_locals >---
// Deletes a variable of type object of the given name from oPC's player data item.
// - oPC: the PC associated with this variable
// - sVarName: name of the variable to delete.
void ss_DeletePlayerObject(object oPC, string sVarName);


/******************************************************************************/
/*                  Player Data Item Function Implementation                  */
/******************************************************************************/

void ss_SetPlayerFloat(object oPC, string sVarName, float fFloat)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    SetLocalFloat(oData, sVarName, fFloat);
}

float ss_GetPlayerFloat(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    return GetLocalFloat(oData, sVarName);
}

void ss_DeletePlayerFloat(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    DeleteLocalFloat(oData, sVarName);
}

void ss_SetPlayerInt(object oPC, string sVarName, int nInt)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    SetLocalInt(oData, sVarName, nInt);
}

int ss_GetPlayerInt(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    return GetLocalInt(oData, sVarName);
}

void ss_DeletePlayerInt(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    DeleteLocalInt(oData, sVarName);
}

void ss_SetPlayerLocation(object oPC, string sVarName, location lLocation)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    SetLocalLocation(oData, sVarName, lLocation);
}

location ss_GetPlayerLocation(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    return GetLocalLocation(oData, sVarName);
}

void ss_DeletePlayerLocation(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    DeleteLocalLocation(oData, sVarName);
}

void ss_SetPlayerString(object oPC, string sVarName, string sString)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    SetLocalString(oData, sVarName, sString);
}

string ss_GetPlayerString(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    return GetLocalString(oData, sVarName);
}

void ss_DeletePlayerString(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    DeleteLocalString(oData, sVarName);
}

void ss_SetPlayerObject(object oPC, string sVarName, object oObject)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    SetLocalObject(oData, sVarName, oObject);
}

object ss_GetPlayerObject(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    return GetLocalObject(oData, sVarName);
}

void ss_DeletePlayerObject(object oPC, string sVarName)
{
    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    DeleteLocalObject(oData, sVarName);
}

/******************************************************************************/
/*                    Global Data Point Function Prototypes                   */
/******************************************************************************/

// ---< ss_CreateGlobalDataPoint >---
// ---< ss_i_locals >---
// Creates the global data point object at the module start location.
void ss_CreateGlobalDataPoint();

// ---< ss_GetGlobalDataPoint >---
// ---< ss_i_locals >---
// Returns the global data point.
object ss_GetGlobalDataPoint();

// ---< ss_SetGlobalFloat >---
// ---< ss_i_locals >---
// Sets the global data point's local float variable sVarName to fValue.
void ss_SetGlobalFloat(string sVarName, float fValue);

// ---< ss_GetGlobalFloat >---
// ---< ss_i_locals >---
// Returns the global data point's local float variable sVarName.
float ss_GetGlobalFloat(string sVarName);

// ---< ss_DeleteGlobalFloat >---
// ---< ss_i_locals >---
// Deletes the global data point's local float variable sVarName.
void ss_DeleteGlobalFloat(string sVarName);

// ---< ss_SetGlobalInt >---
// ---< ss_i_locals >---
// Sets the global data point's local int variable sVarName to nValue.
void ss_SetGlobalInt(string sVarName, int nValue);

// ---< ss_GetGlobalInt >---
// ---< ss_i_locals >---
// Returns the global data point's local int variable sVarName.
int ss_GetGlobalInt(string sVarName);

// ---< ss_DeletePlayerObject >---
// ---< ss_i_locals >---
// Deletes the global data point's local int variable sVarName.
void ss_DeleteGlobalInt(string sVarName);

// ---< ss_SetGlobalLocation >---
// ---< ss_i_locals >---
// Sets the global data point's local location variable sVarName to lValue.
void ss_SetGlobalLocation(string sVarName, location lValue);

// ---< ss_GetGlobalLocation >---
// ---< ss_i_locals >---
// Returns the global data point's local location variable sVarName.
location ss_GetGlobalLocation(string sVarName);

// ---< ss_DeleteGlobalLocation >---
// ---< ss_i_locals >---
// Deletes the global data point's local location variable sVarName.
void ss_DeleteGlobalLocation(string sVarName);

// ---< ss_SetGlobalObject >---
// ---< ss_i_locals >---
// Sets the global data point's local object variable sVarName to sValue.
void ss_SetGlobalObject(string sVarName, object oValue);

// ---< ss_GetGlobalObject >---
// ---< ss_i_locals >---
// Returns the global data point's local object variable sVarName.
object ss_GetGlobalObject(string sVarName);

// ---< ss_DeleteGlobalObject >---
// ---< ss_i_locals >---
// Deletes the global data point's local object variable sVarName.
void ss_DeleteGlobalObject(string sVarName);

// ---< ss_SetGlobalString >---
// ---< ss_i_locals >---
// Sets the global data point's local string variable sVarName to sValue.
void ss_SetGlobalString(string sVarName, string sValue);

// ---< ss_GetGlobalString >---
// ---< ss_i_locals >---
// Returns the global data point's local string variable sVarName.
string ss_GetGlobalString(string sVarName);

// ---< ss_DeleteGlobalString >---
// ---< ss_i_locals >---
// Deletes the global data point's local string variable sVarName.
void ss_DeleteGlobalString(string sVarName);



/******************************************************************************/
/*                  Global Data Point Function Implementation                 */
/******************************************************************************/


void ss_CreateGlobalDataPoint()
{
    object oData = GetLocalObject(GetModule(), SS_GLOBAL_DATA_POINT);
    if (!GetIsObjectValid(oData))
    {
        oData = CreateObject(OBJECT_TYPE_WAYPOINT, SS_GLOBAL_DATA_POINT, GetStartingLocation());
        SetLocalObject(GetModule(), SS_GLOBAL_DATA_POINT, oData);
    }
}

object ss_GetGlobalDataPoint()
{
    return GetLocalObject(GetModule(), SS_GLOBAL_DATA_POINT);
}

void ss_SetGlobalFloat(string sVarName, float fValue)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    SetLocalFloat(oDataPoint, sVarName, fValue);
}

float ss_GetGlobalFloat(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    return GetLocalFloat(oDataPoint, sVarName);
}

void ss_DeleteGlobalFloat(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    DeleteLocalFloat(oDataPoint, sVarName);
}

void ss_SetGlobalInt(string sVarName, int nValue)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    SetLocalInt(oDataPoint, sVarName, nValue);
}

int ss_GetGlobalInt(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    return GetLocalInt(oDataPoint, sVarName);
}

void ss_DeleteGlobalInt(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    DeleteLocalInt(oDataPoint, sVarName);
}

void ss_SetGlobalLocation(string sVarName, location lValue)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    SetLocalLocation(oDataPoint, sVarName, lValue);
}

location ss_GetGlobalLocation(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    return GetLocalLocation(oDataPoint, sVarName);
}

void ss_DeleteGlobalLocatoin(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    DeleteLocalLocation(oDataPoint, sVarName);
}

void ss_SetGlobalObject(string sVarName, object oValue)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    SetLocalObject(oDataPoint, sVarName, oValue);
}

object ss_GetGlobalObject(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    return GetLocalObject(oDataPoint, sVarName);
}

void ss_DeleteGlobalObject(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    DeleteLocalObject(oDataPoint, sVarName);
}

void ss_SetGlobalString(string sVarName, string sValue)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    SetLocalString(oDataPoint, sVarName, sValue);
}

string ss_GetGlobalString(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    return GetLocalString(oDataPoint, sVarName);
}

void ss_DeleteGlobalString(string sVarName)
{
    object oDataPoint = ss_GetGlobalDataPoint();
    DeleteLocalString(oDataPoint, sVarName);
}
