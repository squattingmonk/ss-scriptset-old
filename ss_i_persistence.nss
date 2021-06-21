/*
Filename:           ss_i_persistence
System:             Core (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Dec. 15, 2008
Summary:
Core system include script. This file holds the persistence functions commonly
used throughout the core system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Local persistence include file
#include "ss_i_locals"

// Natural Bioware Database Extension include script
#include "nbde_inc"


/******************************************************************************/
/*                          SQL Function Prototypes                           */
/******************************************************************************/

// ---< SQLInit >---
// ---< ss_i_persistence >---
// Sets placeholders for ODBC requests and responses, reserving 1KB for memory.
void SQLInit();

// ---< SQLExecDirect >---
// ---< ss_i_persistence >---
// Executes statement sSQL in SQL.
void SQLExecDirect(string sSQL);

// ---< SQLFetch >---
// ---< ss_i_persistence >---
// Positions the cursor on the next row of the resultset
// Call this before using SQLGetData().
// Returns: SQL_SUCCESS if there is a row
//          SQL_ERROR if there are no more rows
int SQLFetch();

// ---< SQLGetData >---
// ---< ss_i_persistence >---
// Returns the value of column nCol in the current row of result set.
string SQLGetData(int nCol);

// ---< SQLLocationToString >---
// ---< ss_i_persistence >---
// Returns a string value when given a location. All data is ultimately entered
// into the database as a string, so this function should be called in any
// function that passes a location value to the database.
string SQLLocationToString(location lLocation);

// ---< SQLStringToLocation >---
// ---< ss_i_persistence >---
// Returns a location value when given the string form of the location. All data
// is ultimately entered into the database as a string, so this function should
// be called in any function that calls a location value from the database.
location SQLStringToLocation(string sLocation);

// ---< SQLVectorToString >---
// ---< ss_i_persistence >---
// Returns a string value when given a vector. All data is ultimately entered
// into the database as a string, so this function should be called in any
// function that passes a vector value to the database.
string SQLVectorToString(vector vVector);

// ---< SQLStringToVector >---
// ---< ss_i_persistence >---
// Returns a vector value when given the string form of the location. All data
// is ultimately entered into the database as a string, so this function should
// be called in any function that calls a vector value from the database.
vector SQLStringToVector(string sVector);

// ---< SQLEncodeSpecialChars >---
// ---< ss_i_persistence >---
// Replaces the special character ' with ~. This function should be called in
// any function that passes text strings to the database.
string SQLEncodeSpecialChars(string sString);

// ---< SQLDecodeSpecialChars >---
// ---< ss_i_persistence >---
// Replaces the special character ~ with '. This function should be called in
// any function that passes text strings to the database.
string SQLDecodeSpecialChars(string sString);

// ---< SQLDoesTableExist >---
// ---< ss_i_persistence >---
// Checks if table sTableName exists in the database.
int SQLDoesTableExist(string sTableName);

// ---< SQLCreateMissingTable >---
// ---< ss_i_persistence >---
// Creates a table in the database named sTableName using the commands in sSQL
// if the table does not already exist.
void SQLCreateMissingTable(string sTableName, string sSQL);

/******************************************************************************/
/*                         SQL Function Implementation                        */
/******************************************************************************/

void SQLInit()
{
    int i;
    string sMemory;

    for (i = 0; i < 8; i++)
        sMemory +=
            "...............................................................................................................................................................................................................................................................";

    SetLocalString(GetModule(), SQL_SPACER, sMemory);
}

void SQLExecDirect(string sSQL)
{
    SetLocalString(GetModule(), SQL_EXEC, sSQL);
}

int SQLFetch()
{
    string sRow;
    object oModule = GetModule();

    SetLocalString(oModule, SQL_FETCH, GetLocalString(oModule, SQL_SPACER));
    sRow = GetLocalString(oModule, SQL_FETCH);
    if (GetStringLength(sRow) > 0)
    {
        SetLocalString(oModule, SQL_CURRENT_ROW, sRow);
        return SQL_SUCCESS;
    }
    else
    {
        SetLocalString(oModule, SQL_CURRENT_ROW, "");
        return SQL_ERROR;
    }
}

string SQLGetData(int nCol)
{
    int iPos;
    string sResultSet = GetLocalString(GetModule(), SQL_CURRENT_ROW);

    int nCount = 0;
    string sColValue = "";

    iPos = FindSubString(sResultSet, "¬");
    if ((iPos == -1) && (nCol == 1))
    {
        sColValue = sResultSet;
    }
    else if (iPos == -1)
    {
        sColValue = "";
    }
    else
    {
        while (nCount != nCol)
        {
            nCount++;
            if (nCount == nCol)
                sColValue = GetStringLeft(sResultSet, iPos);
            else
            {
                sResultSet = GetStringRight(sResultSet, GetStringLength(sResultSet) - iPos - 1);
                iPos = FindSubString(sResultSet, "¬");
            }

            if (iPos == -1)
                iPos = GetStringLength(sResultSet);
        }
    }

    return sColValue;
}

string SQLVectorToString(vector vVector)
{
    return SQL_VECTOR_X + FloatToString(vVector.x) + SQL_VECTOR_Y + FloatToString(vVector.y) +
        SQL_VECTOR_Z + FloatToString(vVector.z) + SQL_VECTOR_END;
}

vector SQLStringToVector(string sVector)
{
    float fX, fY, fZ;
    int iPos, nCount;
    int iLen = GetStringLength(sVector);

    if (iLen > 0)
    {
        iPos = FindSubString(sVector, SQL_VECTOR_X) + 12;
        nCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sVector, iPos, nCount));

        iPos = FindSubString(sVector, SQL_VECTOR_Y) + 12;
        nCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sVector, iPos, nCount));

        iPos = FindSubString(sVector, SQL_VECTOR_Z) + 12;
        nCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sVector, iPos, nCount));
    }

    return Vector(fX, fY, fZ);
}

string SQLLocationToString(location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    vector vPosition = GetPositionFromLocation(lLocation);
    float fOrientation = GetFacingFromLocation(lLocation);
    string sReturnValue;

    if (GetIsObjectValid(oArea))
        sReturnValue =
            SQL_AREA + GetTag(oArea) + SQL_VECTOR_X + FloatToString(vPosition.x) +
            SQL_VECTOR_Y + FloatToString(vPosition.y) + SQL_VECTOR_Z +
            FloatToString(vPosition.z) + SQL_ORIENTATION + FloatToString(fOrientation) + SQL_VECTOR_END;

    return sReturnValue;
}

location SQLStringToLocation(string sLocation)
{
    location lReturnValue;
    object oArea;
    vector vPosition;
    float fOrientation, fX, fY, fZ;

    int iPos, nCount;
    int iLen = GetStringLength(sLocation);

    if (iLen > 0)
    {
        iPos = FindSubString(sLocation, SQL_AREA) + 6;
        nCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        oArea = GetObjectByTag(GetSubString(sLocation, iPos, nCount));

        iPos = FindSubString(sLocation, SQL_VECTOR_X) + 12;
        nCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sLocation, iPos, nCount));

        iPos = FindSubString(sLocation, SQL_VECTOR_Y) + 12;
        nCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sLocation, iPos, nCount));

        iPos = FindSubString(sLocation, SQL_VECTOR_Z) + 12;
        nCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sLocation, iPos, nCount));

        vPosition = Vector(fX, fY, fZ);

        iPos = FindSubString(sLocation, SQL_ORIENTATION) + 13;
        nCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fOrientation = StringToFloat(GetSubString(sLocation, iPos, nCount));

        lReturnValue = Location(oArea, vPosition, fOrientation);
    }

    return lReturnValue;
}

string SQLEncodeSpecialChars(string sString)
{
    if (FindSubString(sString, "'") == -1)
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "'")
            sReturn += "~";
        else
            sReturn += sChar;
    }
    return sReturn;
}

string SQLDecodeSpecialChars(string sString)
{
    if (FindSubString(sString, "~") == -1)
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "~")
            sReturn += "'";
        else
            sReturn += sChar;
    }
    return sReturn;
}

int SQLDoesTableExist(string sTableName)
{
    SQLExecDirect(SQL_SELECT_COUNT + sTableName);
    if (SQLFetch() != SQL_SUCCESS)
        return FALSE;
    string sValue = SQLGetData(1);
    if (sValue == "0" || StringToInt(sValue) > 0)
        return TRUE;
    return FALSE;
}

void SQLCreateMissingTable(string sTableName, string sSQL)
{
    if (!SQLDoesTableExist(sTableName))
    {
        SQLExecDirect(sSQL);
        if (!SQLDoesTableExist(sTableName))
            WriteTimestampedLogEntry(SQL_ERROR_COULD_NOT_CREATE_TABLE + sTableName + "'.");
    }
}



/******************************************************************************/
/*                        Database Function Prototypes                        */
/******************************************************************************/

// ---< ss_InitializeDatabase >---
// ---< ss_i_persistence >---
// Establishes space in memory for database transactions and sets up any MySQL
// tables missing from the database.
void ss_InitializeDatabase();

// ---< ss_SetDatabaseFloat >---
// ---< ss_i_persistence >---
// Sets a persistent float of sVarName with a value of fValue on oObject in the
// database. If oObject is invalid, oObject will be set to the module instead.
void ss_SetDatabaseFloat(string sVarName, float fValue, object oObject = OBJECT_INVALID);

// ---< ss_SetDatabaseInt >---
// ---< ss_i_persistence >---
// Sets a persistent int of sVarName with a value of nValue on oObject in the
// database. If oObject is invalid, oObject will be set to the module instead.
void ss_SetDatabaseInt(string sVarName, int nValue, object oObject = OBJECT_INVALID);

// ---< ss_SetDatabaseLocation >---
// ---< ss_i_persistence >---
// Sets a persistent location of sVarName with a value of lValue on oObject in
// the database. If oObject is invalid, oObject will be set to the module
// instead.
void ss_SetDatabaseLocation(string sVarName, location lValue, object oObject = OBJECT_INVALID);

// ---< ss_SetDatabaseString >---
// ---< ss_i_persistence >---
// Sets a persistent string of sVarName with a value of sValue on oObject in the
// database. If oObject is invalid, oObject will be set to the module instead.
void ss_SetDatabaseString(string sVarName, string sValue, object oObject = OBJECT_INVALID);

// ---< ss_SetDatabaseObject >---
// ---< ss_i_persistence >---
// Sets a persistent object of sVarName with a value of oValue on oObject in the
// database. If oObject is invalid, oObject will be set to the module instead.
void ss_SetDatabaseObject(string sVarName, object oValue, object oObject = OBJECT_INVALID);

// ---< ss_SetDatabaseVector >---
// ---< ss_i_persistence >---
// Sets a persistent vector of sVarName with a value of vValue on oObject in the
// database.If oObject is invalid, oObject will be set to the module instead.
void ss_SetDatabaseVector(string sVarName, vector vValue, object oObject = OBJECT_INVALID);

// ---< ss_GetDatabaseFloat >---
// ---< ss_i_persistence >---
// Returns a persistent float of sVarName from oObject in the database. If
// oObject is invalid, oObject will be set to the module instead.
float ss_GetDatabaseFloat(string sVarName, object oObject = OBJECT_INVALID);

// ---< ss_GetDatabaseInt >---
// ---< ss_i_persistence >---
// Returns a persistent int of sVarName from oObject in the database. If oObject
// is invalid, oObject will be set to the module instead.
int ss_GetDatabaseInt(string sVarName, object oObject = OBJECT_INVALID);

// ---< ss_GetDatabaseLocation >---
// ---< ss_i_persistence >---
// Returns a persistent location of sVarName from oObject in the database. If
// oObject is invalid, oObject will be set to the module instead.
location ss_GetDatabaseLocation(string sVarName, object oObject = OBJECT_INVALID);

// ---< ss_GetDatabaseString >---
// ---< ss_i_persistence >---
// Returns a persistent string of sVarName from oObject in the database. If
// oObject is invalid, oObject will be set to the module instead.
string ss_GetDatabaseString(string sVarName, object oObject = OBJECT_INVALID);

// ---< ss_GetDatabaseOObject >---
// ---< ss_i_persistence >---
// Returns a persistent object of sVarName from oObject in the database. If
// oObject is invalid, oObject will be set to the module instead.
object ss_GetDatabaseObject(string sVarName, object oObject = OBJECT_INVALID, object oOwner = OBJECT_INVALID);

// ---< ss_GetDatabaseVector >---
// ---< ss_i_persistence >---
// Returns a persistent vector of sVarName from oObject in the database. If
// oObject is invalid, oObject will be set to the module instead.
vector ss_GetDatabaseVector(string sVarName, object oObject = OBJECT_INVALID);

// ---< ss_DeleteDatabaseVariable >---
// ---< ss_i_persistence >---
// Deletes the persistent float of sVarName from oObject in the database. If
// oObject is invalid, oObject will be set to the module instead.
void ss_DeleteDatabaseVariable(string sVarName, object oObject = OBJECT_INVALID);

// ---< ss_DeleteDatabaseObject >---
// ---< ss_i_persistence >---
// Deletes the persistent object of sVarName from oObject in the database. If
// oObject is invalid, oObject will be set to the module instead.
void ss_DeleteDatabaseObject(string sVarName, object oObject = OBJECT_INVALID);


/******************************************************************************/
/*                      Database Function Implementation                      */
/******************************************************************************/


void ss_InitializeDatabase()
{
    SQLInit();
    SQLExecDirect(SQL_SHOW_DATABASES);
    if (SQLFetch() != SQL_SUCCESS)
    {
        WriteTimestampedLogEntry(SQL_ERROR_COULD_NOT_CONNECT);
        return;
    }

    SQLCreateMissingTable(SQL_TABLE_PWDATA, SQL_CREATE_TABLE_PWDATA);
    SQLCreateMissingTable(SQL_TABLE_PCDATA, SQL_CREATE_TABLE_PCDATA);
    SQLCreateMissingTable(SQL_TABLE_PLAYERS, SQL_CREATE_TABLE_PLAYERS);
    SQLCreateMissingTable(SQL_TABLE_CHARACTERS, SQL_CREATE_TABLE_CHARACTERS);
    SQLCreateMissingTable(SQL_TABLE_PWOBJECTDATA, SQL_CREATE_TABLE_PWOBJECTDATA);
    SQLCreateMissingTable(SQL_TABLE_PCOBJECTDATA, SQL_CREATE_TABLE_PCOBJECTDATA);
}

void ss_SetDatabaseFloat(string sVarName, float fValue, object oObject = OBJECT_INVALID)
{
    string sValue = FloatToString(fValue);
    ss_SetDatabaseString(sVarName, sValue, oObject);
}

void ss_SetDatabaseInt(string sVarName, int nValue, object oObject = OBJECT_INVALID)
{
    string sValue = IntToString(nValue);
    ss_SetDatabaseString(sVarName, sValue, oObject);
}

void ss_SetDatabaseLocation(string sVarName, location lValue, object oObject = OBJECT_INVALID)
{
    string sValue = SQLLocationToString(lValue);
    ss_SetDatabaseString(sVarName, sValue, oObject);
}

void ss_SetDatabaseString(string sVarName, string sValue, object oObject = OBJECT_INVALID)
{
    string sSQL;

    sVarName = SQLEncodeSpecialChars(sVarName);

    if (GetIsPC(oObject))
    {
        string sPCID = ss_GetPlayerString(oObject, SS_PCID);
        sSQL = "REPLACE INTO pcdata (PCID, VarName, Value) VALUES('" + sPCID + "', '" + sVarName + "', '" + sValue + "')";
    }
    else
    {
        if (!GetIsObjectValid(oObject))
            oObject = GetModule();

        string sTag = GetTag(oObject);
        sSQL = "REPLACE INTO pwdata (Tag, VarName, Value) VALUES('" + sTag + "', '" + sVarName + "', '" + sValue + "')";
    }

    SQLExecDirect(sSQL);
}

void ss_SetDatabaseVector(string sVarName, vector vValue, object oObject = OBJECT_INVALID)
{
    string sValue = SQLVectorToString(vValue);
    ss_SetDatabaseString(sVarName, sValue, oObject);
}

float ss_GetDatabaseFloat(string sVarName, object oObject = OBJECT_INVALID)
{
    string sReturn = ss_GetDatabaseString(sVarName, oObject);

    if (sReturn == "")
        sReturn = "0";

    return StringToFloat(sReturn);
}

int ss_GetDatabaseInt(string sVarName, object oObject = OBJECT_INVALID)
{
    string sReturn = ss_GetDatabaseString(sVarName, oObject);

    if (sReturn == "")
        sReturn = "0";

    return StringToInt(sReturn);
}

location ss_GetDatabaseLocation(string sVarName, object oObject = OBJECT_INVALID)
{
    return SQLStringToLocation(ss_GetDatabaseString(sVarName, oObject));
}

string ss_GetDatabaseString(string sVarName, object oObject = OBJECT_INVALID)
{
    string sReturnValue;
    string sSQL;

    sVarName = SQLEncodeSpecialChars(sVarName);

    if (GetIsPC(oObject))
    {
        string sPCID = ss_GetPlayerString(oObject, SS_PCID);
        sSQL = "SELECT Value FROM pcdata WHERE VarName='" + sVarName + "' AND PCID='" + sPCID + "'";
    }
    else
    {
        if (!GetIsObjectValid(oObject))
            oObject = GetModule();

        string sTag = GetTag(oObject);
        sSQL = "SELECT Value FROM pwdata WHERE VarName='" + sVarName + "' AND Tag='" + sTag + "'";
    }

    SQLExecDirect(sSQL);

    if(SQLFetch() == SQL_SUCCESS)
        sReturnValue = SQLDecodeSpecialChars(SQLGetData(1));
    else
        WriteTimestampedLogEntry("Error executing: " + sSQL);

    return sReturnValue;
}

vector ss_GetDatabaseVector(string sVarName, object oObject = OBJECT_INVALID)
{
    return SQLStringToVector(ss_GetDatabaseString(sVarName, oObject));
}

void ss_DeleteDatabaseVariable(string sVarName, object oObject = OBJECT_INVALID)
{
    string sSQL;

    sVarName = SQLEncodeSpecialChars(sVarName);

    if (GetIsPC(oObject))
    {
        string sPCID = ss_GetPlayerString(oObject, SS_PCID);
        sSQL = "DELETE FROM pcdata WHERE PCID='" + sPCID + "' AND VarName='" + sVarName + "'";
    }
    else
    {
        if (!GetIsObjectValid(oObject))
            oObject = GetModule();

        string sTag = GetTag(oObject);
        sSQL = "DELETE FROM pwdata WHERE Tag='" + sTag + "' AND VarName='" + sVarName + "'";
    }

    SQLExecDirect(sSQL);
}

void ss_SetDatabaseObject(string sVarName, object oValue, object oObject = OBJECT_INVALID)
{
    string sSQL;

    sVarName = SQLEncodeSpecialChars(sVarName);

    if (GetIsPC(oObject))
    {
        string sPCID = ss_GetPlayerString(oObject, SS_PCID);
        sSQL = "REPLACE INTO pcobjectdata (PCID, VarName, Value) VALUES('" + sPCID
               + "', '" + sVarName + "', %s)";
    }
    else
    {
        if (oObject == OBJECT_INVALID)
            oObject = GetModule();

        string sTag = GetTag(oObject);
        sTag = SQLEncodeSpecialChars(sTag);
        sSQL = "REPLACE INTO pwobjectdata (Tag, VarName, Value) VALUES('" + sTag
               + "', '" + sVarName + "', %s)";
    }

    SetLocalString(GetModule(), SQL_SCORCO, sSQL);
    StoreCampaignObject (SQL_NWNX, "-", oValue);
}

object ss_GetDatabaseObject(string sVarName, object oObject = OBJECT_INVALID, object oOwner = OBJECT_INVALID)
{
    string sSQL;

    sVarName = SQLEncodeSpecialChars(sVarName);

    if (GetIsPC(oObject))
    {
        string sPCID = ss_GetPlayerString(oObject, SS_PCID);
        sSQL = "SELECT Value FROM pcobjectdata WHERE PCID='" + sPCID
               + "' AND VarName='" + sVarName + "'";
    }
    else
    {
        if (oObject == OBJECT_INVALID)
            oObject = GetModule();

        string sTag = GetTag(oObject);
        sTag = SQLEncodeSpecialChars(sTag);
        sSQL = "SELECT Value FROM pwobjectdata WHERE Tag='" + sTag
               + "' AND VarName='" + sVarName + "'";
    }

    SetLocalString(GetModule(), SQL_SCORCO, sSQL);
    if (!GetIsObjectValid(oOwner))
        oOwner = oObject;
    return RetrieveCampaignObject (SQL_NWNX, "-", GetLocation(oOwner), oOwner);
}

void ss_DeleteDatabaseObject(string sVarName, object oObject = OBJECT_INVALID)
{
    string sSQL;

    sVarName = SQLEncodeSpecialChars(sVarName);

    if (GetIsPC(oObject))
    {
        string sPCID = ss_GetPlayerString(oObject, SS_PCID);
        sSQL = "DELETE FROM pcobjectdata WHERE PCID='" + sPCID + "' AND VarName='" + sVarName + "'";
    }
    else
    {
        if (!GetIsObjectValid(oObject))
            oObject = GetModule();

        string sTag = GetTag(oObject);
        sSQL = "DELETE FROM pwobjectdata WHERE Tag='" + sTag + "' AND VarName='" + sVarName + "'";
    }

    SQLExecDirect(sSQL);
}
