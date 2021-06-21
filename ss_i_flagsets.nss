/*
Filename:           ss_i_flagsets
System:             Core (flagsets include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 15, 2009
Summary:
Core flagsets include script. This script is consumed by ss_i_core as an include
directive. It contains functions for grouping variables into flags and setting,
getting, and deleting these flags on objects and in the database.

These scripts are from Axe Murderer's Flagsets v1.3, modified for Shadows &
Silver's needs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Persistence include script
#include "ss_i_persistence"

/******************************************************************************/
/*                            Function Prototypes                             */
/******************************************************************************/

// ---< FlagToString >---
// ---< ss_i_flagsets >---
// Returns the specified flagset as a string of 1's and 0's in the form
// "XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX" where FLAG1 is on the far right and
// FLAG32 the far left.
// nSet - the flagset variable.
string FlagToString(int nSet);

// ---< GroupFlagToString >---
// ---< ss_i_flagsets >---
// Returns the specified flag group from the given flagset as a string of 1's
// and 0's in the form "XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX" where FLAG1 is
// on the far right and FLAG32 the far left.
// nSet   - the flagset variable.
// nGroup - the flag group to get the flags from.
string GroupFlagToString(int nSet, int nGroup);

// ---< SetFlag >---
// ---< ss_i_flagsets >---
// Turns a flag or set of flags on or off in a flagset variable and returns the
// value of the flagset.
// nSet  - the flagset variable.
// nFlag - the flags to set or clear.
// bOn   - turn flags on if TRUE, off if FALSE
int SetFlag(int nSet, int nFlag, int bOn = TRUE);

// ---< ClearFlag >---
// ---< ss_i_flagsets >---
// Clears a flag or set of flags in a flagset variable and returns the value of
// the flagset.
// nSet  - the flagset variable.
// nFlag - the flags to turn off.
int ClearFlag(int nSet, int nFlag);

// ---< GetFlag >---
// ---< ss_i_flagsets >---
// Returns the values of the flag(s) specified from the given flagset.
// nSet  - the flagset variable.
// nFlag - the flags to turn off.
int GetFlag(int nSet, int nFlag);

// ---< GetIsFlagSet >---
// ---< ss_i_flagsets >---
// Returns TRUE or FALSE if the flags specified in nFlag are turned on. The bAny
// parameter is used to request an ANY or ALL test.
// nSet  - the flagset variable.
// nFlag - the flags to test.
// bAny  - TRUE means test for any of the flags being set.
//         FALSE means test for all of the flags being set.
int GetIsFlagSet(int nSet, int nFlag, int bAny = TRUE);

// ---< GetIsFlagClear >---
// ---< ss_i_flagsets >---
// Returns TRUE or FALSE if the flags specified in nFlag are turned off. The
// bAll parameter is used to request an ANY or ALL test.
// nSet  - the flagset variable.
// nFlag - the flags to test.
// bAll  - TRUE means test for all of the flags being clear.
//         FALSE means test for any of the flags being clear.
int GetIsFlagClear(int nSet, int nFlag, int bAll = TRUE);

// ---< SetGroupFlag >---
// ---< ss_i_flagsets >---
// Turns a flag or set of flags on or off in a flag group of a flagset variable
// and returns the value of the flagset.
// nSet   - the flagset variable.
// nGroup - the flag group to apply the changes to.
// nFlag  - the flags to set or clear.
// bOn    - turn flags on if TRUE, off if FALSE
int SetGroupFlag(int nSet, int nGroup, int nFlag, int bOn = TRUE);

// ---< SetGroupFlagValue >---
// ---< ss_i_flagsets >---
// Sets the group value for a group flag and returns the value of the flagset.
// nSet   - the flagset variable.
// nGroup - the flag group to apply the changes to.
// nValue - the value to set.
int SetGroupFlagValue(int nSet, int nGroup, int nValue);

// ---< ClearGroupFlag >---
// ---< ss_i_flagsets >---
// Turns a flag or set of flags off in a flag group of a flagset variable and
// returns the value of the flagset.
// nSet   - the flagset variable.
// nGroup - the flag group to apply the changes to.
// nFlag  - the flags to clear.
// bOn    - turn flags on if TRUE, off if FALSE
int ClearGroupFlag(int nSet, int nGroup, int nFlag);

// ---< GetGroupFlag >---
// ---< ss_i_flagsets >---
// Returns the values of the flag(s) specified from the specified flag group
// of the given flagset.
// nSet   - the flagset variable.
// nGroup - the flag group to get the flags from.
// nFlag  - the flags to return.
int GetGroupFlag(int nSet, int nGroup, int nFlag);

// ---< GetGroupFlagValue >---
// ---< ss_i_flagsets >---
// Returns the group value of the specified group in the nSet flagset.
// nSet   - the flagset variable.
// nGroup - the flag group to get the value of.
int GetGroupFlagValue(int nSet, int nGroup);

// ---< GetIsGroupFlagSet >---
// ---< ss_i_flagsets >---
// Returns TRUE or FALSE if the flags specified in nFlag are turned on in the
// flag group specified by nGroup. The bAny parameter is used to request an ANY
// or ALL test.
// nSet   - the flagset variable.
// nGroup - the flag group to get the flags from.
// nFlag  - the flags to test.
// bAny   - TRUE means test for any of the flags being set.
//          FALSE means test for all of the flags being set.
int GetIsGroupFlagSet(int nSet, int nGroup, int nFlag, int bAny = TRUE);

// ---< GetIsGroupFlagClear >---
// ---< ss_i_flagsets >---
// Returns TRUE or FALSE if the flags specified in nFlag are turned off in the
// flag group specified by nGroup. The bAll parameter is used to request an ANY
// or ALL test.
// nSet   - the flagset variable.
// nFlag  - the flags to test.
// nGroup - the flag group to get the flags from.
// bAll   - TRUE means test for all of the flags being cleared.
//          FALSE means test for any of the flags being cleared.
int GetIsGroupFlagClear(int nSet, int nGroup, int nFlag, int bAll = TRUE);

// ---< SetLocalFlag >---
// ---< ss_i_flagsets >---
// Sets a local flag variable on an object.
// oObject   - the object to have the local flagset attached.
// sVariable - the flagset name to set the flag in.
// nFlag     - the flag(s) to set or clear.
// bOn       - turn flags on if TRUE, off if FALSE
void SetLocalFlag(object oObject, string sVariable, int nFlag, int bOn = TRUE);

// ---< ClearLocalFlag >---
// ---< ss_i_flagsets >---
// Clears a local flag variable on an object.
// oObject   - the object to have the local flagset attached.
// sVariable - the flagset name to set the flag in.
// nFlag     - the flag(s) to clear.
void ClearLocalFlag(object oObject, string sVariable, int nFlag);

// ---< GetLocalFlag >---
// ---< ss_i_flagsets >---
// Returns the value of a local flag(s) from an object.
// oObject   - the object that has the local flagset attached.
// sVariable - the flagset name to retrieve the flag(s) from.
// nFlag     - the flag(s) to be retrieved.
int GetLocalFlag(object oObject, string sVariable, int nFlag = ALLFLAGS);

// ---< GetIsLocalFlagSet >---
// ---< ss_i_flagsets >---
// Returns TRUE if the flag(s) in the flagset named by sVariable on oObject are
// set.
// oObject   - the object that has the local flagset attached.
// sVariable - the flagset name to retrieve the flag(s) from.
// nFlag     - the flag(s) to be retrieved.
int GetIsLocalFlagSet(object oObject, string sVariable, int nFlag = ALLFLAGS);

// ---< GetIsLocalFlagClear >---
// ---< ss_i_flagsets >---
// Returns TRUE if the flag(s) in the flagset named by sVariable on oObject is
// not set.
// oObject   - the object that has the local flagset attached.
// sVariable - the flagset name to retrieve the flag(s) from.
// nFlag     - the flag(s) to be retrieved.
int GetIsLocalFlagClear(object oObject, string sVariable, int nFlag = ALLFLAGS);

// ---< DeleteLocalFlag >---
// ---< ss_i_flagsets >---
// Removes the specified flag(s) from the given local flagset variable.
// oObject   - the object that has the local flagset attached.
// sVariable - the flagset name to delete the flag(s) from.
// nFlag     - the flag(s) to be deleted.
void DeleteLocalFlag(object oObject, string sVariable, int nFlag = ALLFLAGS);

// ---< SetLocalGroupFlag >---
// ---< ss_i_flagsets >---
// Sets a local group flag variable on an object.
// oObject   - the object to have the local flagset attached.
// sVariable - the flagset name to set the flag in.
// nGroup    - the group to set or clear the flags in.
// nFlag     - the flag(s) to set or clear.
// bOn       - turn flags on if TRUE, off if FALSE
void SetLocalGroupFlag(object oObject, string sVariable, int nGroup, int nFlag, int bOn = TRUE);

// ---< ClearLocalGroupFlag >---
// ---< ss_i_flagsets >---
// Clears a local group flag variable on an object.
// oObject   - the object to have the local flagset attached.
// sVariable - the flagset name to set the flag in.
// nGroup    - the group to set or clear the flags in.
// nFlag     - the flag(s) to clear.
void ClearLocalGroupFlag(object oObject, string sVariable, int nGroup, int nFlag);

// ---< SetLocalGroupFlagValue >---
// ---< ss_i_flagsets >---
// Sets a local group flag variable on an object as a value.
// oObject   - the object to have the local flagset attached.
// sVariable - the flagset name to set the flag in.
// nGroup    - the group to set the value in.
// nValue    - the value to set.
void SetLocalGroupFlagValue(object oObject, string sVariable, int nGroup, int nValue);

// ---< GetLocalGroupFlag >---
// ---< ss_i_flagsets >---
// Returns the value(s) of a local group flag(s) from an object.
// oObject   - the object that has the local flagset attached.
// sVariable - the flagset name to retrieve the flag(s) from.
// nGroup    - the group to get the flags from.
// nFlag     - the flag(s) to be retrieved.
int GetLocalGroupFlag(object oObject, string sVariable, int nGroup, int nFlag);

// ---< GetLocalGroupFlagValue >---
// ---< ss_i_flagsets >---
// Returns the value of a local group flag number from an object.
// oObject   - the object that has the local flagset attached.
// sVariable - the flagset name to retrieve the value from.
// nGroup    - the group to get the value from.
int GetLocalGroupFlagValue(object oObject, string sVariable, int nGroup);

// ---< DeleteLocalGroupFlag >---
// ---< ss_i_flagsets >---
// Removes the specified flag(s) from the specified group of the given local
// flagset variable.
// oObject   - the object that has the local flagset attached.
// sVariable - the flagset name to delete the flag(s) from.
// nGroup    - the group to delete the flags from.
// nFlag     - the flag(s) to be deleted.
void DeleteLocalGroupFlag(object oObject, string sVariable, int nGroup, int nFlag);

// ---< HexToInt >---
// ---< ss_i_flagsets >---
// Returns the integer form of the hex string sHex.
// sHex cannot be longer than 8 characters unless the first two letters are '0x'
// (or '0X'; in that case the string can be 10 characters long). It can be
// shorter than 8 letters. Only numbers and letters 'a'-'f' and 'A'-'F' are
// allowed. If any of these rules is violated the function considers it an
// invalid hex number and returns the value 0.
int HexToInt(string sHex);

// ---< SetPersistentFlag >---
// ---< ss_i_flagsets >---
// Sets a persistent flag variable on an object.
// sVarName - the flagset name to set the flag in.
// nFlag    - the flag(s) to set.
// bOn      - the value to set the flag to, TRUE = set, FALSE = clear.
// oObject  - the object to have the persistent flagset attached. If invalid,
//            will be set to the module.
void SetPersistentFlag(string sVarName, int nFlag, int bOn = TRUE, object oObject = OBJECT_INVALID);

// ---< ClearPersistentFlag >---
// ---< ss_i_flagsets >---
// Clears a persistent flag variable on an object.
// sVarName - the flagset name to set the flag in.
// nFlag    - the flag(s) to clear.
// oObject  - the object to have the persistent flagset attached. If invalid,
//            will be set to the module.
void ClearPersistentFlag(string sVarName, int nFlag, object oObject = OBJECT_INVALID);

// ---< GetPersistentFlag >---
// ---< ss_i_flagsets >---
// Returns the value of a local flag(s) from an object.
// sVarName - the flagset name to retrieve the flag(s) from.
// nFlag    - the flag(s) to be retrieved.
// oObject  - the object that has the persistent flagset attached. If invalid,
//            will be set to the module.
int GetPersistentFlag(string sVarName, int nFlag = ALLFLAGS, object oObject = OBJECT_INVALID);

// ---< SetPersistentGroupFlag >---
// ---< ss_i_flagsets >---
// Sets a persistent group flag variable on an object.
// sVarName - the flagset name to set the flag in.
// nGroup   - the group to set or clear the flags in.
// nFlag    - the flag(s) to set or clear.
// bOn      - turn flags on if TRUE, off if FALSE
// oObject  - the object to have the persistent flagset attached. If invalid,
//            will be set to the module.
void SetPersistentGroupFlag(string sVarName, int nGroup, int nFlag, int bOn = TRUE, object oObject = OBJECT_INVALID);

// ---< ClearPersistentGroupFlag >---
// ---< ss_i_flagsets >---
// Clears a persistent group flag variable on an object.
// sVarName - the flagset name to set the flag in.
// nGroup   - the group to set or clear the flags in.
// nFlag    - the flag(s) to clear.
// oObject  - the object to have the persistent flagset attached. If invalid,
//            will be set to the module.
void ClearPersistentGroupFlag(string sVarName, int nGroup, int nFlag, object oObject = OBJECT_INVALID);

// ---< SetPersistentGroupFlagValue >---
// ---< ss_i_flagsets >---
// Sets a persistent group flag variable on an object as a value.
// sVarName - the flagset name to set the flag in.
// nGroup   - the group to set the value in.
// nValue   - the value to set.
// oObject  - the object to have the persistent flagset attached. If invalid,
//            will be set to the module.
void SetPersistentGroupFlagValue( string sVarName, int nGroup, int nValue, object oObject = OBJECT_INVALID);

// ---< GetPersistentGroupFlag >---
// ---< ss_i_flagsets >---
// Returns the value(s) of a persistent group flag(s) from an object.
// sVarName - the flagset name to retrieve the flag(s) from.
// nGroup   - the group to get the flags from.
// nFlag    - the flag(s) to be retrieved.
// oObject  - the object that has the persistent flagset attached. If invalid,
//            will be set to the module.
int GetPersistentGroupFlag(string sVarName, int nGroup, int nFlag, object oObject = OBJECT_INVALID);

// ---< GetPersistentGroupFlagValue >---
// ---< ss_i_flagsets >---
// Returns the value of a persistent group flag number from an object.
// sVarName - the flagset name to retrieve the value from.
// nGroup   - the group to get the value from.
// oObject  - the object that has the persistent flagset attached. If invalid,
//            will be set to the module.
int GetPersistentGroupFlagValue(string sVarName, int nGroup, object oObject = OBJECT_INVALID);

// ---< DeletePersistentFlag >---
// ---< ss_i_flagsets >---
// Removes the specified flag(s) from the given persistent flagset variable.
// sVarName - the flagset name to delete the flag(s) from.
// nFlag    - the flag(s) to be deleted.
// oObject  - the object that has the persistent flagset attached. If invalid,
//            will be set to the module.
void DeletePersistentFlag(string sVarName, int nFlag = ALLFLAGS, object oObject = OBJECT_INVALID);

// ---< DeletePersistentGroupFlag >---
// ---< ss_i_flagsets >---
// Removes the specified flag(s) from the specified group of the given
// persistent flagset variable.
// sVarName - the flagset name to delete the flag(s) from.
// nGroup   - the group to delete the flags from.
// nFlag    - the flag(s) to be deleted.
// oObject  - the object that has the persistent flagset attached. If invalid,
//            will be set to the module.
void DeletePersistentGroupFlag(string sVarName, int nGroup, int nFlag, object oObject = OBJECT_INVALID);


/******************************************************************************/
/*                           Function Implementation                          */
/******************************************************************************/

string FlagToString(int nSet)
{
    if (nSet == 0)
        return "0000 0000 0000 0000 0000 0000 0000 0000";

    string sSet = "";
    int    nTinyCount = 0;

    for (nTinyCount = 1; nTinyCount <= 8; nTinyCount++)
    {
        string sTiny = GetSubString(DECTOBINARY, (nSet & TINYGROUP1) * 4, 4);
        if ((nSet >>= 4) < 0)
            nSet &= 0x0FFFFFFF;
        sSet = sTiny + ((sSet == "") ? "" : " ") + sSet;
    }
    return sSet;
}

string GroupFlagToString(int nSet, int nGroup)
{
    if (nGroup == NOGROUPS)
        return "0000 0000 0000 0000 0000 0000 0000 0000";

    nSet &= nGroup;
    while((nGroup & FLAG1) != FLAG1)
    {
        if ((nSet   >>= 1) < 0) nSet   &= 0x7FFFFFFF;
        if ((nGroup >>= 1) < 0) nGroup &= 0x7FFFFFFF;
    }
    return FlagToString(nSet);
}

int SetFlag(int nSet, int nFlag, int bOn = TRUE)
{
    return (bOn ? (nSet | nFlag) : (nSet & ~nFlag));
}

int ClearFlag(int nSet, int nFlag)
{
    return SetFlag(nSet, nFlag, FALSE);
}

int GetFlag(int nSet, int nFlag)
{
    return (nSet & nFlag);
}

int GetIsFlagSet(int nSet, int nFlag, int bAny = TRUE)
{
    if (nFlag == NOFLAGS)
        return FALSE;
    return (bAny ? ((nSet & nFlag) != NOFLAGS) : ((nSet & nFlag) == nFlag));
}

int GetIsFlagClear(int nSet, int nFlag, int bAll = TRUE)
{
    if (nFlag == NOFLAGS)
        return FALSE;
    return !GetIsFlagSet(nSet, nFlag, !bAll);
}

int SetGroupFlag(int nSet, int nGroup, int nFlag, int bOn = TRUE)
{
    if ((nFlag == NOFLAGS) || (nGroup == NOGROUPS))
        return nSet;

    int nShift = 0;
    int nLimit = nGroup;

    while ((nLimit != NOFLAGS) && GetIsFlagClear(nLimit, FLAG1))
    {
        ++nShift;
        nLimit >>= 1;
        if (nLimit < 0)
            nLimit &= 0x7FFFFFFF;
    }
    return ((nLimit == NOFLAGS) ? nSet : SetFlag(nSet, ((nFlag & nLimit) << nShift), bOn));
}

int SetGroupFlagValue(int nSet, int nGroup, int nValue)
{
    if (nGroup == NOGROUPS)
        return nSet;
    return SetGroupFlag(SetGroupFlag(nSet, nGroup, nValue), nGroup, ~nValue, FALSE);
}

int ClearGroupFlag(int nSet, int nGroup, int nFlag)
{
    return SetGroupFlag(nSet, nGroup, nFlag, FALSE);
}

int GetGroupFlag(int nSet, int nGroup, int nFlag)
{
    if ((nFlag == NOFLAGS) || (nGroup == NOGROUPS))
        return NOFLAGS;

    int nShift = 0;
    int nLimit = nGroup;
    while ((nLimit != NOFLAGS) && GetIsFlagClear(nLimit, FLAG1))
    {
        ++nShift;
        nLimit >>= 1;
        if (nLimit < 0)
            nLimit &= 0x7FFFFFFF;
    }

    int nGroupFlag = GetFlag(nSet, ((nFlag & nLimit) << nShift));
    if ((nGroupFlag < 0) && (nShift > 0))
    {
        nGroupFlag >>= 1;
        nGroupFlag &= 0x7FFFFFFF;
        --nShift;
    }
    return ((nLimit == NOFLAGS) ? NOFLAGS : (nGroupFlag >> nShift));
}

int GetGroupFlagValue(int nSet, int nGroup)
{
    if (nGroup == NOGROUPS)
        return NOFLAGS;
    return GetGroupFlag(nSet, nGroup, GROUPVALUE);
}

int GetIsGroupFlagSet(int nSet, int nGroup, int nFlag, int bAny = TRUE)
{
    if ((nFlag == NOFLAGS) || (nGroup == NOGROUPS))
        return FALSE;

    int nShift = 0;
    int nLimit = nGroup;
    while ((nLimit != NOFLAGS) && GetIsFlagClear(nLimit, FLAG1))
    {
        ++nShift;
        nLimit >>= 1;
        if (nLimit < 0)
            nLimit &= 0x7FFFFFFF;
    }
    return ((nLimit == NOFLAGS) ? FALSE : GetIsFlagSet(nSet, ((nFlag & nLimit) << nShift), bAny));
}

int GetIsGroupFlagClear(int nSet, int nGroup, int nFlag, int bAll = TRUE)
{
    if ((nFlag == NOFLAGS) || (nGroup == NOGROUPS))
        return FALSE;
    return !GetIsGroupFlagSet(nSet, nGroup, nFlag, !bAll);
}

void SetLocalFlag(object oObject, string sVariable, int nFlag, int bOn = TRUE)
{
    if (!GetIsObjectValid(oObject) || (sVariable == ""))
        return;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    SetLocalInt(oObject, sVariable + FLAGS_SUFFIX, SetFlag(nSet, nFlag, bOn));
}

void ClearLocalFlag(object oObject, string sVariable, int nFlag)
{
    if (!GetIsObjectValid(oObject) || (sVariable == ""))
        return;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    SetLocalInt(oObject, sVariable + FLAGS_SUFFIX, ClearFlag(nSet, nFlag));
}

int GetLocalFlag(object oObject, string sVariable, int nFlag = ALLFLAGS)
{
    if (!GetIsObjectValid(oObject) || (sVariable == ""))
        return 0;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    return GetFlag(nSet, nFlag);
}

int GetIsLocalFlagSet(object oObject, string sVariable, int nFlag = ALLFLAGS)
{
    if (!GetIsObjectValid(oObject) || (sVariable == ""))
        return 0;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    return GetIsFlagSet(nSet, nFlag);
}

int GetIsLocalFlagClear(object oObject, string sVariable, int nFlag = ALLFLAGS)
{
    if (!GetIsObjectValid(oObject) || (sVariable == ""))
        return 0;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    return GetIsFlagClear(nSet, nFlag);
}

void DeleteLocalFlag(object oObject, string sVariable, int nFlag = ALLFLAGS)
{
    if (!GetIsObjectValid(oObject) || (sVariable == ""))
        return;

    if (nFlag == ALLFLAGS)
        DeleteLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    else
        SetLocalFlag(oObject, sVariable, nFlag, FALSE);
}

void SetLocalGroupFlag(object oObject, string sVariable, int nGroup, int nFlag, int bOn = TRUE)
{
    if (!GetIsObjectValid(oObject) || (sVariable == "") || (nGroup == NOGROUPS))
        return;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    SetLocalInt(oObject, sVariable + FLAGS_SUFFIX, SetGroupFlag(nSet, nGroup, nFlag, bOn));
}

void ClearLocalGroupFlag(object oObject, string sVariable, int nGroup, int nFlag)
{
    if (!GetIsObjectValid(oObject) || (sVariable == "") || (nGroup == NOGROUPS))
        return;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    SetLocalInt(oObject, sVariable + FLAGS_SUFFIX, ClearGroupFlag(nSet, nFlag, nGroup));
}

void SetLocalGroupFlagValue(object oObject, string sVariable, int nGroup, int nValue)
{
    if (!GetIsObjectValid(oObject) || (sVariable == "") || (nGroup == NOGROUPS))
        return;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    SetLocalInt(oObject, sVariable + FLAGS_SUFFIX, SetGroupFlagValue(nSet, nGroup, nValue));
}

int GetLocalGroupFlag(object oObject, string sVariable, int nGroup, int nFlag)
{
    if (!GetIsObjectValid(oObject) || (sVariable == "") || (nGroup == NOGROUPS))
        return 0;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    return GetGroupFlag(nSet, nGroup, nFlag);
}

int GetLocalGroupFlagValue(object oObject, string sVariable, int nGroup)
{
    if (!GetIsObjectValid(oObject) || (sVariable == "") || (nGroup == NOGROUPS))
        return 0;
    int nSet = GetLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    return GetGroupFlagValue(nSet, nGroup);
}

void DeleteLocalGroupFlag(object oObject, string sVariable, int nGroup, int nFlag)
{
    if (!GetIsObjectValid(oObject) || (sVariable == "") || (nGroup == NOGROUPS))
        return;
    if ((nFlag == ALLFLAGS) && (nGroup == ALLGROUPS))
        DeleteLocalInt(oObject, sVariable + FLAGS_SUFFIX);
    else
        ClearLocalGroupFlag(oObject, sVariable, nGroup, nFlag);
}

int HexToInt(string sHex)
{
    sHex = GetStringLowerCase(sHex);
    if (GetStringLeft(sHex, 2) == "0x")
        sHex = GetStringRight(sHex, GetStringLength(sHex) -2);

    if ((sHex == "") || (GetStringLength(sHex) > 8))
        return 0;

    string sConvert = "0123456789abcdef";
    int nValue = 0;
    int nMult  = 1;
    while(sHex != "")
    {
        int nDigit = FindSubString(sConvert, GetStringRight(sHex, 1));
        if (nDigit < 0)
            return 0;
        nValue += nMult *nDigit;
        nMult  *= 16;
        sHex    = GetStringLeft(sHex, GetStringLength(sHex) -1);
    }
    return nValue;
}

void SetPersistentFlag(string sVarName, int nFlag, int bOn = TRUE, object oObject = OBJECT_INVALID)
{
    int nSet = ss_GetDatabaseInt(sVarName + FLAGS_SUFFIX, oObject);
    ss_SetDatabaseInt(sVarName + FLAGS_SUFFIX, SetFlag(nSet, nFlag, bOn), oObject);
}

void ClearPersistentFlag(string sVarName, int nFlag, object oObject = OBJECT_INVALID)
{
    int nSet = ss_GetDatabaseInt(sVarName + FLAGS_SUFFIX, oObject);
    ss_SetDatabaseInt(sVarName + FLAGS_SUFFIX, ClearFlag(nSet, nFlag), oObject);
}

int GetPersistentFlag(string sVarName, int nFlag = ALLFLAGS, object oObject = OBJECT_INVALID)
{
    int nSet = ss_GetDatabaseInt(sVarName + FLAGS_SUFFIX, oObject);
    return GetFlag(nSet, nFlag);
}

void SetPersistentGroupFlag(string sVarName, int nGroup, int nFlag, int bOn = TRUE, object oObject = OBJECT_INVALID)
{
    if ((sVarName == "") || (nGroup == NOGROUPS))
        return;
    int nSet = ss_GetDatabaseInt(sVarName + FLAGS_SUFFIX, oObject);
    ss_SetDatabaseInt(sVarName + FLAGS_SUFFIX, SetGroupFlag(nSet, nGroup, nFlag, bOn), oObject);
}

void ClearPersistentGroupFlag(string sVarName, int nGroup, int nFlag, object oObject = OBJECT_INVALID)
{
    if ((sVarName == "") || (nGroup == NOGROUPS))
        return;
    int nSet = ss_GetDatabaseInt(sVarName + FLAGS_SUFFIX, oObject);
    ss_SetDatabaseInt(sVarName + FLAGS_SUFFIX, ClearGroupFlag(nSet, nGroup, nFlag), oObject);
}

void SetPersistentGroupFlagValue(string sVarName, int nGroup, int nValue, object oObject = OBJECT_INVALID)
{
    if ((sVarName == "") || (nGroup == NOGROUPS))
        return;
    int nSet = ss_GetDatabaseInt(sVarName + FLAGS_SUFFIX, oObject);
    ss_SetDatabaseInt(sVarName + FLAGS_SUFFIX, SetGroupFlagValue(nSet, nGroup, nValue), oObject);
}

int GetPersistentGroupFlag(string sVarName, int nGroup, int nFlag, object oObject = OBJECT_INVALID)
{
    if ((sVarName == "") || (nGroup == NOGROUPS))
        return 0;
    int nSet = ss_GetDatabaseInt(sVarName + FLAGS_SUFFIX, oObject);
    return GetGroupFlag(nSet, nGroup, nFlag);
}

int GetPersistentGroupFlagValue(string sVarName, int nGroup, object oObject = OBJECT_INVALID)
{
    if ((sVarName == "") || (nGroup == NOGROUPS))
        return 0;
    int nSet = ss_GetDatabaseInt(sVarName + FLAGS_SUFFIX, oObject);
    return GetGroupFlagValue(nSet, nGroup);
}

void DeletePersistentFlag(string sVarName, int nFlag = ALLFLAGS, object oObject = OBJECT_INVALID)
{
    if (sVarName == "")
        return;
    if (nFlag == ALLFLAGS)
        ss_DeleteDatabaseVariable(sVarName + FLAGS_SUFFIX, oObject);
    else
        SetPersistentFlag(sVarName, nFlag, FALSE, oObject);
}

void DeletePersistentGroupFlag(string sVarName, int nGroup, int nFlag, object oObject = OBJECT_INVALID)
{
    if ((sVarName == "") || (nGroup == NOGROUPS))
        return;
    if ((nFlag == ALLFLAGS) && (nGroup == ALLGROUPS))
        ss_DeleteDatabaseVariable(sVarName + FLAGS_SUFFIX, oObject);
    else
        ClearPersistentGroupFlag(sVarName, nGroup, nFlag, oObject);
}
