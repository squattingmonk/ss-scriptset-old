/*
Filename:           ai_i_list
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 24, 2009
Summary:
Memetic AI include script. This file holds list handling functions commonly used
throughout the Memetic AI system. This script is consumed as an include
directive by ai_i_util.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_debug"


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ---< ai_AddObjectRef >---
// ---< ai_i_list >---
// Adds oObject to an object list on oTarget given the list name sListName. If
// bAddUnique is TRUE, this only adds to the list if it is not already there.
void ai_AddObjectRef(object oTarget, object oObject, string sListName = "", int bAddUnique = FALSE);

// ---< ai_RemoveObjectRef >---
// ---< ai_i_list >---
// Removes the object from the list on the target. If this object was added
// twice, only the first reference is removed.
void ai_RemoveObjectRef(object oTarget, object oObject, string sListName = "");

// ---< ai_RemoveObjectByIndex >---
// ---< ai_i_list >---
// Removes the specified object from the list, given the index. The first item
// in the list is 0.
void ai_RemoveObjectByIndex(object oTarget, int nIndex, string sListName = "");

// ---< ai_GetObjectByName >---
// ---< ai_i_list >---
// Searches through the list with the given list name and looks for the object
// with the given name. If there are more than one, an index may be provided.
object ai_GetObjectByName(object oTarget, string sName, string sListName = "", int nIndex = 0);

// ---< ai_SetObjectByIndex >---
// ---< ai_i_list >---
// Replaces one object in a list, with another. The position is determined by
// index (0 is the first item). If the index is at the end of the list, it will
// be added. If it exceeds the length of the list, an error may be written to
// the log and nothing is added.
void ai_SetObjectByIndex(object oTarget, int nIndex, object oValue, string sListName = "");

// ---< ai_HasObjectRef >---
// ---< ai_i_list >---
// Searches through the list and returns the index in the list or -1 if
// the object is not found.
int ai_HasObjectRef(object oTarget, object oObject, string sListName = "");

// ---< ai_GetObjectByIndex >---
// ---< ai_i_list >---
// Returns an object at the given index. If no object is found at that index,
// OBJECT_INVALID is returned.
object ai_GetObjectByIndex(object oTarget, int nIndex=0, string sListName = "");

// ---< ai_GetObjectCount >---
// ---< ai_i_list >---
// Returns the number of items in the object list with the given list name.
int ai_GetObjectCount(object oTarget, string sListName = "");

// ---< ai_DeleteObjectRefs >---
// ---< ai_i_list >---
// Removes the entire object list with the given name on the target object.
void ai_DeleteObjectRefs(object oTarget, string sListName = "", int nDeleteDeclaration = 0);

// ---< ai_AddStringRef >---
// ---< ai_i_list >---
// Adds a string to a string list on the target given the list name.
void ai_AddStringRef(object oTarget, string oString, string sListName = "", int bAddUnique = FALSE);

// ---< ai_RemoveStringRef >---
// ---< ai_i_list >---
// Removes the string from the list on the target. If this string was added
// twice, only the first reference is removed.
void ai_RemoveStringRef(object oTarget, string oString, string sListName = "");

// ---< ai_RemoveStringByIndex >---
// ---< ai_i_list >---
// Removes the specified string from the list, given the index. The first item
// in the list is 0.
void ai_RemoveStringByIndex(object oTarget, int nIndex, string sListName = "");

// ---< ai_GetStringByIndex >---
// ---< ai_i_list >---
// Returns an string at the given index. If no string is found at that index,
// "" is returned.
string ai_GetStringByIndex(object oTarget, int nIndex=0, string sListName = "");

// ---< ai_GetStringCount >---
// ---< ai_i_list >---
// Returns the number of items in the string list with the given list name.
int ai_GetStringCount(object oTarget, string sListName = "");

// ---< ai_SetStringByIndex >---
// ---< ai_i_list >---
// Replaces one string in a list, with another. The position is determined by
// index (0 is the first item). If the index is at the end of the list, it will
// be added. If it exceeds the length of the list, an error may be written to
// the log and nothing is added.
void ai_SetStringByIndex(object oTarget, int nIndex, string sValue, string sListName = "");

// ---< ai_DeleteStringRefs >---
// ---< ai_i_list >---
// Removes the entire string list with the given name on the target object.
void ai_DeleteStringRefs(object oTarget, string sListName = "", int nDeleteDeclaration = 0);

// ---< ai_AddIntRef >---
// ---< ai_i_list >---
// Adds an integer to an integer list on the target given the list name and namespace.
void ai_AddIntRef(object oTarget, int nValue, string sListName = "", int bAddUnique = FALSE);

// ---< ai_SetIntByIndex >---
// ---< ai_i_list >---
// Replaces one integer in a list, with another. The position is determined by
// index (0 is the first item). If the index is at the end of the list, it will
// be added. If it exceeds the length of the list, an error may be written to
// the log and nothing is added.
void ai_SetIntByIndex(object oTarget, int nIndex, int nValue, string sListName = "");

// ---< ai_RemoveIntRef >---
// ---< ai_i_list >---
// Removes the integer from the list on the target. If this integer was added
// twice, the first reference is removed.
void ai_RemoveIntRef(object oTarget, int nValue, string sListName = "");

// ---< ai_RemoveIntByIndex >---
// ---< ai_i_list >---
// Removes the specified integer from the list, given the index. The first item
// in the list is 0.
void ai_RemoveIntByIndex(object oTarget, int nIndex, string sListName = "");

// ---< ai_GetIntByIndex >---
// ---< ai_i_list >---
// Returns an integer at the given index. If no integer is found at that index,
// 0 is returned.
int ai_GetIntByIndex(object oTarget, int nIndex = 0, string sListName = "");

// ---< ai_GetIntCount >---
// ---< ai_i_list >---
// Returns the number of items in the integer list with the given list name.
int ai_GetIntCount(object oTarget, string sListName = "");

// ---< ai_DeleteIntRefs >---
// ---< ai_i_list >---
// Removes the entire integer list with the given name on the target object.
void ai_DeleteIntRefs(object oTarget, string sListName = "", int nDeleteDeclaration = 0);

// ---< ai_AddFloatRef >---
// ---< ai_i_list >---
// Adds fValue to a float list on oTarget given the list name sListName. If
// bAddUnique is TRUE, this only adds to the list if it is not already there.
void ai_AddFloatRef(object oTarget, float fValue, string sListName = "", int bAddUnique = FALSE);

// ---< ai_RemoveFloatRef >---
// ---< ai_i_list >---
// Removes the float from the list on the target. If this float was added
// twice, only the first reference is removed.
void ai_RemoveFloatRef(object oTarget, float nValue, string sListName = "");

// ---< ai_RemoveFloatByIndex >---
// ---< ai_i_list >---
// Removes the float from the list on the target.
void ai_RemoveFloatByIndex(object oTarget, int nIndex, string sListName = "");

// ---< ai_GetFloatByIndex >---
// ---< ai_i_list >---
// Returns an float at the given index. If no float is found at that index,
// 0.0 is returned.
float ai_GetFloatByIndex(object oTarget, int nIndex = 0, string sListName = "");

// ---< ai_GetFloatCount >---
// ---< ai_i_list >---
// Returns the number of items in the float list with the given list name.
int ai_GetFloatCount(object oTarget, string sListName = "");

// ---< ai_SetFloatByIndex >---
// ---< ai_i_list >---
// Replaces one float in a list with another. The position is determined by
// index (0 is the first item). If the index is at the end of the list, it will
// be added. If it exceeds the length of the list, an error may be written to
// the log and nothing is added.
void ai_SetFloatByIndex(object oTarget, int nIndex, float fValue, string sListName = "");

// ---< ai_DeleteFloatRefs >---
// ---< ai_i_list >---
// Removes the entire float list with the given name on the target object.
void ai_DeleteFloatRefs(object oTarget, string sListName = "", int nDeleteDeclaration = 0);

// ---< ai_CopyObjectRef >---
// ---< ai_i_list >---
// Copy a list from one object to another.
void ai_CopyObjectRef(object oSource, object oDest, string sSourceName, string sTargetName);

// ---< ai_CopyFloatRef >---
// ---< ai_i_list >---
// Copy a list from one object to another.
void ai_CopyFloatRef(object oSource, object oDest, string sSourceName, string sTargetName);

// ---< ai_CopyIntRef >---
// ---< ai_i_list >---
// Copy a list from one object to another.
void ai_CopyIntRef(object oSource, object oDest, string sSourceName, string sTargetName);

// ---< ai_CopyStringRef >---
// ---< ai_i_list >---
// Copy a list from one object to another.
void ai_CopyStringRef(object oSource, object oDest, string sSourceName, string sTargetName);

// ---< _GetObjectOwner >---
// ---< ai_i_list >---
// This is an internal function to the Memetic AI variable inheritance system.
// You should never have to use it.
// Retuns the object that actually owns the variable given a declaration table.
object _GetObjectOwner(object oTarget, string sDeclEntry);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

object _GetObjectOwner(object oTarget, string sDeclEntry)
{
    object oDeclarationTarget = GetLocalObject(oTarget, sDeclEntry);
    if (oDeclarationTarget != OBJECT_INVALID)
        return oDeclarationTarget;

    object oParent = GetLocalObject(oTarget, AI_MEME_PARENT);
    if (oParent != OBJECT_INVALID)
        return _GetObjectOwner(oParent, sDeclEntry);

    return oTarget;
}

// When you are adding items to an inherited list, it is necessary to copy
// the list locally, then apply the changes. If the name is mapped to an
// inherited variable with a different name, it is copied from the list,
// with the mapped name.

// When you set a variable on an object, that variable stops being inherited.
// The object now manages the variable on its own, but it will still
// inherit any other unmodified variables.

void ai_AddObjectRef(object oTarget, object oObject, string sListName = "", int bAddUnique = FALSE)
{
    ai_DebugStart("ai_AddObjectRef target = '" + _GetName(oTarget) + "' object = '" + _GetName(oObject) + "' count = '" + IntToString(GetLocalInt(oTarget, "OC:"+ sListName )) +"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_OL:" + sListName);

    // If we're adding unique we should check to see if this entry already exists
    if (bAddUnique == TRUE)
    {
        int i;
        for (i = GetLocalInt(oTarget, "OC:" + sListName)-1; i >= 0; i--)
        {
            if (GetLocalObject(oTarget, "OL:" + sListName+IntToString(i)) == oObject)
            {
                ai_DebugEnd();
                return ;
            }
        }
    }

    // The new owner of the list must override its inherited values
    SetLocalObject(oTarget, "DECL_OL:" + sListName, oTarget);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_OL:" + sListName);
        if (sMapName == "")
            sMapName = sListName;

        ai_CopyObjectRef(oSource, oTarget, sMapName, sListName);
    }

    int count;
    count = GetLocalInt(oTarget, "OC:" + sListName);

    SetLocalObject(oTarget, "OL:" + sListName + IntToString(count), oObject);
    SetLocalInt(oTarget, "OC:" + sListName, count + 1);

    ai_DebugEnd();
}

void ai_AddStringRef(object oTarget, string sString, string sListName = "", int bAddUnique = FALSE)
{
    ai_DebugStart("ai_AddStringRef", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_SL:" + sListName);

    // If we're adding unique we should check to see if this entry already exists
    if (bAddUnique == TRUE)
    {
        int i;
        for (i = GetLocalInt(oTarget, "SC:" + sListName)-1; i >= 0; i--)
        {
            if (GetLocalString(oTarget, "SL:" + sListName + IntToString(i)) == sString)
            {
                ai_DebugEnd();
                return ;
            }
        }
    }

    // The new owner of the list must override its inherited values
    SetLocalObject(oTarget, "DECL_SL:" + sListName, oTarget);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_SL:" + sListName);
        if (sMapName == "")
            sMapName = sListName;

        ai_CopyObjectRef(oSource, oTarget, sMapName, sListName);
    }

    int count, i;
    count = GetLocalInt(oTarget, "SC:" + sListName);

    SetLocalString(oTarget, "SL:" + sListName + IntToString(count), sString);
    SetLocalInt(oTarget, "SC:" + sListName, count + 1);

    ai_DebugEnd();
}

void ai_AddIntRef(object oTarget, int nValue, string sListName = "", int bAddUnique = FALSE)
{

    ai_DebugStart("ai_AddIntRef target = '" + _GetName(oTarget) + "' value = '" + IntToString(nValue)+ "' count = '" + IntToString(GetLocalInt(oTarget, "IC:" + sListName)) + "'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_IL:" + sListName);

    // If we're adding unique we should check to see if this entry already exists
    if (bAddUnique == TRUE)
    {
        int i;
        for (i = GetLocalInt(oTarget, "IC:" + sListName)-1; i >= 0; i--)
        {
            if (GetLocalInt(oTarget, "IL:" + sListName+IntToString(i)) == nValue)
            {
                ai_DebugEnd();
                return ;
            }
        }
    }

    // The new owner of the list must override its inherited values
    SetLocalObject(oTarget, "DECL_IL:"+sListName, oTarget);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_IL:" + sListName);
        if (sMapName == "")
            sMapName = sListName;

        ai_CopyObjectRef(oSource, oTarget, sMapName, sListName);
    }

    int count, i;
    count = GetLocalInt(oTarget, "IC:" + sListName);

    SetLocalInt(oTarget, "IL:" + sListName + IntToString(count), nValue);
    SetLocalInt(oTarget, "IC:" + sListName, count+1);

    ai_DebugEnd();
}

void ai_AddFloatRef(object oTarget, float fValue, string sListName = "", int bAddUnique = FALSE)
{

    ai_DebugStart("ai_AddFloatRef target = '" + _GetName(oTarget) + "' value = '" + FloatToString(fValue) + "' count = '" + IntToString(GetLocalInt(oTarget, "FC:" + sListName)) + "'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_FL:"+sListName);

    // If we're adding unique we should check to see if this entry already exists
    if (bAddUnique == TRUE)
    {
        int i;
        for (i = GetLocalInt(oTarget, "FC:" + sListName)-1; i >= 0; i--)
        {
            if (GetLocalFloat(oTarget, "FL:" + sListName + IntToString(i)) == fValue)
            {
                ai_DebugEnd();
                return ;
            }
        }
    }

    // The new owner of the list must override its inherited values
    SetLocalObject(oTarget, "DECL_FL:" + sListName, oTarget);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_FL:" + sListName);
        if (sMapName == "")
            sMapName = sListName;

        ai_CopyObjectRef(oSource, oTarget, sMapName, sListName);
    }

    int count, i;
    count = GetLocalInt(oTarget, "FC:" + sListName);

    SetLocalFloat(oTarget, "FL:" + sListName + IntToString(count), fValue);
    SetLocalInt(oTarget, "FC:" + sListName, count + 1);

    ai_DebugEnd();
}

// When a string is copied from a source list to a target list, the source
// list may not own the list. It may be inherited and may have remapped the
// name of the list to something else on the source's parent. The given
// list name is what will be set on the target when the function is done;
// but access to the source variable will always use the source's map name.

// Note: declaration tables always use the list name, not the mapped name.

// WARNING!! Extremely long list management can cause TMI; this list code
// is expensive. It is NOT recommended that you create long lists on classes.
// Especially if you ever forsee an instance modifying this list.
void ai_CopyStringRef(object oSource, object oTarget, string sSourceName, string sTargetName)
{
    string sMapName = sSourceName;

    // We only need to do stuff with declaration tables and inheritance
    // if we have a parent pointer, otherwise just skip this stuff.
    if (GetLocalObject(oSource, AI_MEME_PARENT) != OBJECT_INVALID)
    {
        sMapName = GetLocalString(oSource, "VMAP_SL:" + sSourceName);
        if (sMapName == "")
            sMapName = sSourceName;

        // Get the (possibly) inherited object that owns this list
        oSource = _GetObjectOwner(oSource, "DECL_SL:" + sSourceName);
    }

    // The new owner of the list must override its inherited values
    SetLocalObject(oTarget, "DECL_SL:" + sTargetName, oTarget);

    if (oSource == oTarget) return;

    int count = GetLocalInt(oSource, "SC:" + sMapName);
    SetLocalInt(oTarget, "SC:" + sTargetName, count);
    string sItemName;

    for (count--; count >= 0; count--)
    {
        sItemName = "SL:"+sTargetName+IntToString(count);
        SetLocalString(oTarget, sItemName, GetLocalString(oSource, sMapName));
    }
}

void ai_CopyIntRef(object oSource, object oTarget, string sSourceName, string sTargetName)
{
    string sMapName = sSourceName;

    // We only need to do stuff with declaration tables and inheritance
    // if we have a parent pointer, otherwise just skip this stuff.
    if (GetLocalObject(oSource, AI_MEME_PARENT) != OBJECT_INVALID)
    {
        sMapName = GetLocalString(oSource, "VMAP_IL:"+sSourceName);
        if (sMapName == "") sMapName = sSourceName;

        // Get the (possibly) inherited object that owns this list
        oSource = _GetObjectOwner(oSource, "DECL_IL:"+sSourceName);
    }

    // The new owner of the list must override its inherited values
    SetLocalObject(oTarget, "DECL_IL:"+sTargetName, oTarget);

    if (oSource == oTarget) return;

    int count = GetLocalInt(oSource, "IC:"+sMapName);
    SetLocalInt(oTarget, "IC:"+sTargetName, count);
    string sItemName;

    for (count--; count >= 0; count--)
    {
        sItemName = "IL:"+sTargetName+IntToString(count);
        SetLocalInt(oTarget, sItemName, GetLocalInt(oSource, sMapName));
    }
}

void ai_CopyFloatRef(object oSource, object oTarget, string sSourceName, string sTargetName)
{
    string sMapName = sSourceName;

    // We only need to do stuff with declaration tables and inheritance
    // if we have a parent pointer, otherwise just skip this stuff.
    if (GetLocalObject(oSource, AI_MEME_PARENT) != OBJECT_INVALID)
    {
        sMapName = GetLocalString(oSource, "VMAP_FL:"+sSourceName);
        if (sMapName == "") sMapName = sSourceName;

        // Get the (possibly) inherited object that owns this list
        oSource = _GetObjectOwner(oSource, "DECL_FL:"+sSourceName);
    }

    // The new owner of the list must override its inherited values
    SetLocalObject(oTarget, "DECL_FL:"+sTargetName, oTarget);

    if (oSource == oTarget) return;

    int count = GetLocalInt(oSource, "FC:"+sMapName);
    SetLocalInt(oTarget, "FC:"+sTargetName, count);
    string sItemName;

    for (count--; count >= 0; count--)
    {
        sItemName = "FL:"+sTargetName+IntToString(count);
        SetLocalFloat(oTarget, sItemName, GetLocalFloat(oSource, sMapName));
    }
}

void ai_CopyObjectRef(object oSource, object oTarget, string sSourceName, string sTargetName)
{
    string sMapName = sSourceName;

    // We only need to do stuff with declaration tables and inheritance
    // if we have a parent pointer, otherwise just skip this stuff.
    if (GetLocalObject(oSource, AI_MEME_PARENT) != OBJECT_INVALID)
    {
        sMapName = GetLocalString(oSource, "VMAP_OL:"+sSourceName);
        if (sMapName == "") sMapName = sSourceName;

        // Get the (possibly) inherited object that owns this list
        oSource = _GetObjectOwner(oSource, "DECL_OL:"+sSourceName);
    }

    // The new owner of the list must override its inherited values
    SetLocalObject(oTarget, "DECL_OL:"+sTargetName, oTarget);

    if (oSource == oTarget) return;

    int count = GetLocalInt(oSource, "OC:"+sMapName);
    SetLocalInt(oTarget, "OC:"+sTargetName, count);
    string sItemName;

    for (count--; count >= 0; count--)
    {
        sItemName = "OL:"+sTargetName+IntToString(count);
        SetLocalObject(oTarget, sItemName, GetLocalObject(oSource, sMapName));
    }
}

object ai_GetObjectByIndex(object oTarget, int nIndex = 0, string sListName = "")
{
    ai_DebugStart("ai_GetObjectByIndex target = '"+_GetName(oTarget)+"' count = '"+IntToString(GetLocalInt(oTarget, "OC:"+sListName))+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list, redfine the variable's name, if remapped
    object oParent = _GetObjectOwner(oTarget, "DECL_OL:"+sListName);
    if (oParent != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_OL:"+sListName);
        if (sMapName != "") sListName = sMapName;

        object result = ai_GetObjectByIndex(oParent, nIndex, sListName);
        ai_DebugEnd();
        return result;
    }

    int count = GetLocalInt(oTarget, "OC:"+sListName);
    object oResult;

    if (nIndex >= count)
    {
        ai_DebugEnd();
        return OBJECT_INVALID;
    }

    oResult = GetLocalObject(oTarget, "OL:"+sListName+IntToString(nIndex));
    ai_DebugEnd();
    return oResult;
}

int ai_GetObjectCount(object oTarget, string sListName = "")
{
    // Get the (possibly) inherited object that owns this list, redfine the variable's name, if remapped
    object oParent = _GetObjectOwner(oTarget, "DECL_OL:"+sListName);
    if (oParent != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_OL:"+sListName);
        if (sMapName != "") sListName = sMapName;

        int result = ai_GetObjectCount(oParent, sListName);
        ai_DebugEnd();
        return result;
    }

    return GetLocalInt(oTarget, "OC:"+sListName);
}

object ai_GetObjectByName(object oTarget, string sName, string sListName = "", int nIndex = 0)
{
    ai_DebugStart("ai_GetObjectByName target = '"+_GetName(oTarget)+"' count = '"+IntToString(GetLocalInt(oTarget, "OC:"+sListName))+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list, redfine the variable's name, if remapped
    object oParent = _GetObjectOwner(oTarget, "DECL_OL:"+sListName);
    if (oParent != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_OL:"+sListName);
        if (sMapName != "") sListName = sMapName;

        object result = ai_GetObjectByName(oParent, sName, sListName, nIndex);
        ai_DebugEnd();
        return result;
    }

    int count = GetLocalInt(oTarget, "OC:"+sListName);
    int i, index;
    object oResult;

    for (i = 0; i < count; i++)
    {
        oResult = GetLocalObject(oTarget, "OL:"+sListName+IntToString(i));
        if (_GetName(oResult) == sName || sName == "")
        {
            if (index == nIndex)
            {
                ai_DebugEnd();
                return oResult;
            }
            index++;
        }
    }

    ai_DebugEnd();
    return OBJECT_INVALID;
}

string ai_GetStringByIndex(object oTarget, int nIndex = 0, string sListName = "")
{
    ai_DebugStart("ai_GetStringByIndex", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list, redfine the variable's name, if remapped
    object oParent = _GetObjectOwner(oTarget, "DECL_SL:"+sListName);
    if (oParent != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_SL:"+sListName);
        if (sMapName != "")
            sListName = sMapName;

        string result = ai_GetStringByIndex(oParent, nIndex, sListName);
        ai_DebugEnd();
        return result;
    }

    int count = GetLocalInt(oTarget, "SC:"+sListName);
    if (nIndex >= count)
    {
        ai_DebugEnd();
        return "";
    }

    ai_DebugEnd();
    return GetLocalString(oTarget, "SL:"+sListName+IntToString(nIndex));
}

int ai_GetStringCount(object oTarget, string sListName = "")
{
    ai_DebugStart("ai_GetStringCount parentid='DECL_SL:"+sListName+"' countid='SC:"+sListName+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list, redfine the variable's name, if remapped
    object oParent = _GetObjectOwner(oTarget, "DECL_SL:"+sListName);

    if (oParent != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_SL:"+sListName);
        if (sMapName != "") sListName = sMapName;

        int result = ai_GetStringCount(oParent, sListName);
        ai_DebugEnd();
        return result;
    }

    ai_DebugEnd();
    return GetLocalInt(oTarget, "SC:"+sListName);
}

int ai_GetIntByIndex(object oTarget, int nIndex = 0, string sListName = "")
{
    ai_DebugStart("ai_GetIntByIndex target = '"+_GetName(oTarget)+"' count = '"+IntToString(GetLocalInt(oTarget, "IC:"+sListName))+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list, redfine the variable's name, if remapped
    object oParent = _GetObjectOwner(oTarget, "DECL_IL:"+sListName);
    if (oParent != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_IL:"+sListName);
        if (sMapName != "") sListName = sMapName;

        int result = ai_GetIntByIndex(oParent, nIndex, sListName);
        ai_DebugEnd();
        return result;
    }

    int count = GetLocalInt(oTarget, "IC:"+sListName);
    int nResult;

    if (nIndex >= count)
    {
        ai_DebugEnd();
        return 0;
    }

    nResult = GetLocalInt(oTarget, "IL:"+sListName+IntToString(nIndex));
    ai_DebugEnd();
    return nResult;
}

int ai_GetIntCount(object oTarget, string sListName = "")
{
    // Get the (possibly) inherited object that owns this list, redfine the variable's name, if remapped
    object oParent = _GetObjectOwner(oTarget, "DECL_IL:"+sListName);
    if (oParent != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_IL:"+sListName);
        if (sMapName != "") sListName = sMapName;

        int result = ai_GetIntCount(oParent, sListName);
        ai_DebugEnd();
        return result;
    }

    return GetLocalInt(oTarget, "IC:"+sListName);
}

float ai_GetFloatByIndex(object oTarget, int nIndex = 0, string sListName = "")
{
    ai_DebugStart("ai_GetFloatByIndex target = '"+_GetName(oTarget)+"' count = '"+IntToString(GetLocalInt(oTarget, "FC:"+sListName))+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list, redfine the variable's name, if remapped
    object oParent = _GetObjectOwner(oTarget, "DECL_FL:"+sListName);
    if (oParent != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_FL:"+sListName);
        if (sMapName != "")
            sListName = sMapName;

        float result = ai_GetFloatByIndex(oParent, nIndex, sListName);
        ai_DebugEnd();
        return result;
    }

    int count = GetLocalInt(oTarget, "FC:"+sListName);
    float nResult;

    if (nIndex >= count) {
        ai_DebugEnd();
        return 0.0;
    }

    nResult = GetLocalFloat(oTarget, "FL:"+sListName+IntToString(nIndex));
    ai_DebugEnd();
    return nResult;
}

int ai_GetFloatCount(object oTarget, string sListName = "")
{
    // Get the (possibly) inherited object that owns this list, redfine the variable's name, if remapped
    object oParent = _GetObjectOwner(oTarget, "DECL_IL:"+sListName);
    if (oParent != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_IL:"+sListName);
        if (sMapName != "") sListName = sMapName;

        int result = ai_GetFloatCount(oParent, sListName);
        return result;
    }

    return GetLocalInt(oTarget, "FC:"+sListName);
}

// When you remove an entry you get a local copy of the list that is modified.
// If the object is inheriting a large list the first time this function is
// called, it may take a while to copy all the values. (A while in terms of
// TMI measurement...)

void ai_RemoveStringRef(object oTarget, string sValue, string sListName = "")
{
    ai_DebugStart("ai_RemoveStringRef", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_SL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_SL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyStringRef(oSource, oTarget, sMapName, sListName);
    }

    // Now let's remove the string ref
    int count, i;
    string sRef, sEndRef;
    count = GetLocalInt(oTarget, "SC:"+sListName);
    sEndRef = GetLocalString(oTarget, "SL:"+sListName+IntToString(count-1));

    for (i = 0; i < count; i++)
    {
        sRef = GetLocalString(oTarget, "SL:"+sListName+IntToString(i));
        if (sRef == sValue)
        {
            SetLocalString(oTarget, "SL:"+sListName+IntToString(i), sEndRef);
            count--;
            DeleteLocalString(oTarget, "SL:"+sListName+IntToString(count));
            break;
        }
    }
    SetLocalInt(oTarget, "SC:"+sListName, count);
    ai_DebugEnd();
}

void ai_RemoveObjectRef(object oTarget, object oObject, string sListName = "")
{
    ai_DebugStart("ai_RemoveObjectRef target = '"+_GetName(oTarget)+"' object = '"+_GetName(oObject)+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_OL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_OL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyObjectRef(oSource, oTarget, sMapName, sListName);
    }

    int count, i;
    object oRef, oEndRef;

    count = GetLocalInt(oTarget, "OC:"+sListName);
    oEndRef = GetLocalObject(oTarget, "OL:"+sListName+IntToString(count-1));

    for (i = 0; i < count; i++)
    {
        oRef = GetLocalObject(oTarget, "OL:"+sListName+IntToString(i));
        if (oRef == oObject)
        {
            SetLocalObject(oTarget, "OL:"+sListName+IntToString(i), oEndRef);
            count--;
            DeleteLocalObject(oTarget, "OL:"+sListName+IntToString(count));
            break;
        }
    }
    SetLocalInt(oTarget, "OC:"+sListName, count);
    ai_DebugEnd();
}

void ai_RemoveObjectByIndex(object oTarget, int nIndex, string sListName = "")
{
    ai_DebugStart("ai_RemoveObjectByIndex target = '"+_GetName(oTarget)+"' index = '"+IntToString(nIndex)+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_OL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_OL:"+sListName);
        if (sMapName == "")
            sMapName = sListName;

        ai_CopyObjectRef(oSource, oTarget, sMapName, sListName);
    }

    int    count;
    object endRef;

    count  = GetLocalInt(oTarget, "OC:"+sListName);
    if (nIndex >= count || nIndex < 0)
    {
        ai_DebugEnd();
        return;
    }
    endRef = GetLocalObject(oTarget, "OL:"+sListName+IntToString(count-1));

    if ((nIndex < count) && (count > 0))
    {
        SetLocalObject(oTarget, "OL:"+sListName+IntToString(nIndex), endRef);
        DeleteLocalObject(oTarget, "OL:"+sListName+IntToString(count-1));
        count--;
        SetLocalInt(oTarget, "OC:"+sListName, count);
    }
    ai_DebugEnd();
}

void ai_RemoveStringByIndex(object oTarget, int nIndex, string sListName = "")
{
    ai_DebugStart("ai_RemoveStringByIndex target = '"+_GetName(oTarget)+"' index = '"+IntToString(nIndex)+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_SL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_SL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyStringRef(oSource, oTarget, sMapName, sListName);
    }

    int    count;
    string endRef;

    count  = GetLocalInt(oTarget, "SC:"+sListName);
    if (nIndex >= count || nIndex < 0)
    {
        ai_DebugEnd();
        return;
    }
    endRef = GetLocalString(oTarget, "SL:"+sListName+IntToString(count-1));

    if ((nIndex < count) && (count > 0))
    {
        SetLocalString(oTarget, "SL:"+sListName+IntToString(nIndex), endRef);
        DeleteLocalString(oTarget, "SL:"+sListName+IntToString(count-1));
        SetLocalInt(oTarget, "SC:"+sListName, count-1);
    }

    ai_DebugEnd();
}

void ai_RemoveIntRef(object oTarget, int nValue, string sListName = "")
{
    ai_DebugStart("ai_RemoveIntRef target = '"+_GetName(oTarget)+"' value = '"+IntToString(nValue)+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_IL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_IL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyIntRef(oSource, oTarget, sMapName, sListName);
    }

    int count, i, endRef;
    int nRef;

    count = GetLocalInt(oTarget, "IC:"+sListName);
    endRef = GetLocalInt(oTarget, "IL:"+sListName+IntToString(count-1));

    for (i = 0; i < count; i++)
    {
        nRef = GetLocalInt(oTarget, "IL:"+sListName+IntToString(i));
        if (nRef == nValue)
        {
            SetLocalInt(oTarget, "IL:"+sListName+IntToString(i), endRef);
            count--;
            DeleteLocalInt(oTarget, "IL:"+sListName+IntToString(count));
            break;
        }
    }
    SetLocalInt(oTarget, "IC:"+sListName, count);
    ai_DebugEnd();
}

void ai_RemoveIntByIndex(object oTarget, int nIndex, string sListName = "")
{
    ai_DebugStart("ai_RemoveIntByIndex target = '"+_GetName(oTarget)+"' index = '"+IntToString(nIndex)+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_IL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_IL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyIntRef(oSource, oTarget, sMapName, sListName);
    }

    int count, endRef;

    count  = GetLocalInt(oTarget, "IC:"+sListName);
    if (nIndex >= count || nIndex < 0)
    {
        ai_DebugEnd();
        return;
    }
    endRef = GetLocalInt(oTarget, "IL:"+sListName+IntToString(count-1));

    if ((nIndex < count) && (count > 0))
    {
        SetLocalInt(oTarget, "IL:"+sListName+IntToString(nIndex), endRef);
        DeleteLocalInt(oTarget, "IL:"+sListName+IntToString(count-1));
        count--;
        SetLocalInt(oTarget, "IC:"+sListName, count);
    }

    ai_DebugEnd();
}

void ai_RemoveFloatRef(object oTarget, float fValue, string sListName = "")
{
    ai_DebugStart("ai_RemoveFloatRef target = '"+_GetName(oTarget)+"' value = '"+FloatToString(fValue)+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_FL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_FL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyFloatRef(oSource, oTarget, sMapName, sListName);
    }

    int count, i;
    float nRef, endRef;

    count = GetLocalInt(oTarget, "FC:"+sListName);
    endRef = GetLocalFloat(oTarget, "FL:"+sListName+IntToString(count-1));

    for (i = 0; i < count; i++)
    {
        nRef = GetLocalFloat(oTarget, "FL:"+sListName+IntToString(i));
        if (nRef == fValue)
        {
            SetLocalFloat(oTarget, "FL:"+sListName+IntToString(i), endRef);
            count--;
            DeleteLocalFloat(oTarget, "FL:"+sListName+IntToString(count));
            break;
        }
    }
    SetLocalInt(oTarget, "FC:"+sListName, count);
    ai_DebugEnd();
}

void ai_RemoveFloatByIndex(object oTarget, int nIndex, string sListName = "")
{
    ai_DebugStart("ai_RemoveFloatByIndex target = '"+_GetName(oTarget)+"' index = '"+IntToString(nIndex)+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_FL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_FL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyFloatRef(oSource, oTarget, sMapName, sListName);
    }

    int   count;
    float endRef;

    count  = GetLocalInt(oTarget, "FC:"+sListName);
    if (nIndex >= count || nIndex < 0)
    {
        ai_DebugEnd();
        return;
    }
    endRef = GetLocalFloat(oTarget, "FL:"+sListName+IntToString(count-1));

    if ((nIndex < count) && (count > 0))
    {
        SetLocalFloat(oTarget, "FL:"+sListName+IntToString(nIndex), endRef);
        DeleteLocalFloat(oTarget, "FL:"+sListName+IntToString(count-1));
        count--;
        SetLocalInt(oTarget, "FC:"+sListName, count);
    }

    ai_DebugEnd();
}

int ai_FindStringRef(object oTarget, string sString, string sListName = "")
{
    if (sString == "")
        return -1;
    int i;
    ai_DebugStart("ai_FindStringRef target = '" + _GetName(oTarget) + "' count = '" + IntToString(GetLocalInt(oTarget, "SC:"+sListName))+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_SL:"+sListName);

    // If this has been redirected, check to see if this is called a different
    // name on the inherited object. (i.e. mapped)
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_SL:"+sListName);
        if (sMapName == "")
            sMapName = sListName;
    }

    int nCount = GetLocalInt(oTarget, "SC:"+sListName);

    for(i = 0; i < nCount; i++)
    {
        if (GetLocalString(oTarget, "SL:"+sListName+IntToString(i)) == sString)
        {
            ai_DebugEnd();
            return i;
        }
    }

    return -1;

    ai_DebugEnd();
}

void ai_SetStringByIndex(object oTarget, int nIndex, string sValue, string sListName = "")
{
    ai_DebugStart("ai_SetStringByIndex target = '"+_GetName(oTarget)+"' count = '"+IntToString(GetLocalInt(oTarget, "SC:"+sListName))+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_SL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_SL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyStringRef(oSource, oTarget, sMapName, sListName);
    }

    int count = GetLocalInt(oTarget, "SC:"+sListName);

    if (nIndex > count)
    {
        ai_DebugEnd();
        return;
    }

    if (nIndex == count)
    {
        ai_AddStringRef(oTarget, sValue, sListName);
        ai_DebugEnd();
        return;
    }

    SetLocalString(oTarget, "SL:"+sListName+IntToString(nIndex), sValue);

    ai_DebugEnd();
}

void ai_SetObjectByIndex(object oTarget, int nIndex, object oValue, string sListName = "")
{
    ai_DebugStart("ai_SetObjectByIndex target = '"+_GetName(oTarget)+"' count = '"+IntToString(GetLocalInt(oTarget, "OC:"+sListName))+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_OL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_OL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyObjectRef(oSource, oTarget, sMapName, sListName);
    }

    int count = GetLocalInt(oTarget, "OC:"+sListName);

    if (nIndex > count)
    {
        ai_DebugEnd();
        return;
    }

    if (nIndex == count)
    {
        ai_AddObjectRef(oTarget, oValue, sListName);
        ai_DebugEnd();
        return;
    }

    SetLocalObject(oTarget, "OL:"+sListName+IntToString(nIndex), oValue);

    ai_DebugEnd();
}


void ai_SetIntByIndex(object oTarget, int nIndex, int nValue, string sListName = "")
{
    ai_DebugStart("ai_SetIntByIndex target = '"+_GetName(oTarget)+"' count = '"+IntToString(GetLocalInt(oTarget, "IC:"+sListName))+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_IL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_IL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyIntRef(oSource, oTarget, sMapName, sListName);
    }

    int count = GetLocalInt(oTarget, "IC:"+sListName);

    if (nIndex > count)
    {
        ai_DebugEnd();
        return;
    }

    if (nIndex == count)
    {
        ai_AddIntRef(oTarget, nValue, sListName);
        ai_DebugEnd();
        return;
    }

    SetLocalInt(oTarget, "IL:"+sListName+IntToString(nIndex), nValue);

    ai_DebugEnd();
}

void ai_SetFloatByIndex(object oTarget, int nIndex, float fValue, string sListName = "")
{
    ai_DebugStart("ai_SetFloatByIndex target = '"+_GetName(oTarget)+"' count = '"+IntToString(GetLocalInt(oTarget, "FC:"+sListName))+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_FL:"+sListName);

    // If the list is provided elsewhere, let's copy that list here and then modify it
    if (oSource != oTarget)
    {
        string sMapName = GetLocalString(oTarget, "VMAP_FL:"+sListName);
        if (sMapName == "") sMapName = sListName;

        ai_CopyFloatRef(oSource, oTarget, sMapName, sListName);
    }

    int count = GetLocalInt(oTarget, "FC:"+sListName);

    if (nIndex > count)
    {
        ai_DebugEnd();
        return;
    }

    if (nIndex == count)
    {
        ai_AddFloatRef(oTarget, fValue, sListName);
        ai_DebugEnd();
        return;
    }

    SetLocalFloat(oTarget, "FL:"+sListName+IntToString(nIndex), fValue);

    ai_DebugEnd();
}

void ai_DeleteIntRefs(object oTarget, string sListName = "", int nDeleteDeclaration = 0)
{
    ai_DebugStart("ai_DeleteIntRefs target = '"+_GetName(oTarget)+"' prefix = '"+sListName+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_IL:"+sListName);

    if (oSource == oTarget)
    {
        int count = GetLocalInt(oTarget, "IC:"+sListName);
        int i;

        for (i = 0; i < count; i++)
            DeleteLocalInt(oTarget, "IL:"+sListName+IntToString(i));

        DeleteLocalInt(oTarget, "IC:"+sListName);
    }
    else SetLocalObject(oTarget, "DECL_IL:"+sListName, oTarget);

    if (nDeleteDeclaration)
        DeleteLocalObject(oTarget, "DECL_IL:"+sListName);

    ai_DebugEnd();
}


void ai_DeleteStringRefs(object oTarget, string sListName = "", int nDeleteDeclaration = 0)
{
    ai_DebugStart("ai_DeleteStringRefs target = '"+_GetName(oTarget)+"' prefix = '"+sListName+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_SL:"+sListName);

    if (oSource == oTarget)
    {
        int count = GetLocalInt(oTarget, "SC:"+sListName);
        int i;

        for (i = 0; i < count; i++)
            DeleteLocalString(oTarget, "SL:"+sListName+IntToString(i));

        DeleteLocalInt(oTarget, "SC:"+sListName);
    }
    else SetLocalObject(oTarget, "DECL_SL:"+sListName, oTarget);

    if (nDeleteDeclaration)
        DeleteLocalObject(oTarget, "DECL_SL:"+sListName);


    ai_DebugEnd();
}

void ai_DeleteObjectRefs(object oTarget, string sListName = "", int nDeleteDeclaration = 0)
{
    ai_DebugStart("ai_DeleteObjectRefs target = '"+_GetName(oTarget)+"' prefix = '"+sListName+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_OL:"+sListName);

    if (oSource == oTarget)
    {
        int count = GetLocalInt(oTarget, "OC:"+sListName);
        int i;

        for (i = 0; i < count; i++)
            DeleteLocalObject(oTarget, "OL:"+sListName+IntToString(i));

        DeleteLocalInt(oTarget, "OC:"+sListName);
    }
    else SetLocalObject(oTarget, "DECL_OL:"+sListName, oTarget);

    if (nDeleteDeclaration)
        DeleteLocalObject(oTarget, "DECL_OL:"+sListName);

    ai_DebugEnd();
}


void ai_DeleteFloatRefs(object oTarget, string sListName = "", int nDeleteDeclaration = 0)
{
    ai_DebugStart("ai_DeleteFloatRefs target = '"+_GetName(oTarget)+"' prefix = '"+sListName+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    object oSource = _GetObjectOwner(oTarget, "DECL_FL:"+sListName);

    if (oSource == oTarget)
    {
        int count = GetLocalInt(oTarget, "FC:"+sListName);
        int i;

        for (i = 0; i < count; i++)
            DeleteLocalString(oTarget, "FL:"+sListName+IntToString(i));

        DeleteLocalInt(oTarget, "FC:"+sListName);
    }
    else SetLocalObject(oTarget, "DECL_FL:"+sListName, oTarget);

    if (nDeleteDeclaration)
        DeleteLocalObject(oTarget, "DECL_FL:"+sListName);

    ai_DebugEnd();
}

int ai_HasObjectRef(object oTarget, object oObject, string sListName = "")
{
    ai_DebugStart("ai_HasObjectRef target = '"+_GetName(oTarget)+"' object = '"+_GetName(oObject)+"'", AI_DEBUG_UTILITY);

    // Get the (possibly) inherited object that owns this list
    oTarget = _GetObjectOwner(oTarget, "DECL_OL:"+sListName);

    int count, i;
    object oRef, oEndRef;

    count = GetLocalInt(oTarget, "OC:"+sListName);
    oEndRef = GetLocalObject(oTarget, "OL:"+sListName+IntToString(count-1));

    ai_PrintString("The object list has "+IntToString(count)+" items.");

    for (i = 0; i < count; i++)
    {
        oRef = GetLocalObject(oTarget, "OL:"+sListName+IntToString(i));
        if (oRef == oObject)
        {
            ai_DebugEnd();
            return i;
        }
    }

    ai_DebugEnd();
    return -1;
}

// void main(){}
