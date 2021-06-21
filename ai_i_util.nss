/*
Filename:           ai_i_util
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 3, 2009
Summary:
Memetic AI include script. This file holds utility functions commonly used
throughout the Memetic AI system. These are the foundation functions which are
used to manipulate memetic data structures.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_list"


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ---< ai_CreateMemeVault >---
// ---< ai_i_util >---
// Creates and registers the Memetic Vault if it's not already created. The
// memetic vault holds memetic objects and all variables global to MemeticAI.
void ai_CreateMemeVault();

// ---< ai_GetMemeVault >---
// ---< ai_i_util >---
// Returns the Meme Vault, creating it if it's not already created.
object ai_GetMemeVault();


// ------ Core Memetics --------------------------------------------------------

// ---< ai_LoadLibrary >---
// ---< ai_i_util >---
// Loads library sLibrary. The scripts inside the lib are registered and are
// accessible via a call to ai_ExecuteScript().
void ai_LoadLibrary(string sLibrary);

// ---< ai_LoadLibraries >---
// ---< ai_i_util >---
// Loads all libraries defined on the global data point. This should be done
// once within the module's startup. The scripts inside the lib are registered
// and are accessible via a call to ai_ExecuteScript().
// To allow this function to load a library, place a string variable called
// MemeticLibraryX (where X is an index, beginning at 1) whose value is the name
// of the library to register.
void ai_LoadLibraries();

// ---< ai_LibraryImplements >---
// ---< ai_i_util >---
// This registers an object callback that is inside a library script. It is used
// to tell the system that your function is available and has a unique number.
// You must provide a string that defines that timing for the callback. For
// example, if you are writing a class you may register a timing of _ini or _go.
// These timing strings correspond to calls to ai_ExecuteScript(). This is an
// internal function that is used by the Memetic Toolkit to make things happen
// at the right time. It is our equivalent to calling
// BiowareFunction_CallCallback(oObject, "OnBlocked"); <-- which doesn't exist.
//
// It is recommended that you look at an example to understand how this works,
// in conjunction with the switch statmement that dispatches to the functions
// inside the script. Go into any library file and look at the main() function.
// Parameters:
// - sMeme: The name for the memetic object. It is used during a call to
//   ai_CreateMeme();
// - sMethod: The string that represents the callback for the memetic object.
//   There are fixed sMethod strings, for each type of memetic object.
//   - Memes have _brk, _go, _end
//   - Generators have _see, _atk, _blk, and many others.
// - nEntry: This is a number that the library code uses to denote which
//   function should be called. When the library is activated, the global
//   MEME_ENTRYPOINT may have this number. If it does, then the library script
//   knows it is being asked to run this exported function.
void ai_LibraryImplements(string sMeme, string sMethod, int nEntry = ALLFLAGS);

// ---< ai_LibraryFunction >---
// ---< ai_i_util >---
// This exports a function defined in a script that returns a result.
// It is not a function or method of a memetic object -- just a simple function.
// - sFunction: The name you want others to call your function with. Used when
//   they call ai_CallFunction().
// - nEntry: A number the library code uses to denote which function is called.
//   The global MEME_ENTRYPOINT may have this number when the script is
//   executed. If it does, that means this exported function should be run.
void ai_LibraryFunction(string sFunction, int nEntry = ALLFLAGS);

// ---< ai_GetArgument >---
// ---< ai_i_util >---
// This is used by library "functions", can be called via ai_CallFunction().
// This function gets the object that was optionally passed into the library
// function using ai_CallFunction(). This should only be used inside of a library.
object ai_GetArgument();

// ---< ai_SetResult >---
// ---< ai_i_util >---
// Sets an object that can be retrieved by a call to ai_CallFunction(). It is up
// to you to creatively create a new object or use an existing object to pass
// your data with this function. When someone calls ai_CallFunction(), the
// library function is called and is expected to call ai_SetResult(), otherwise
// ai_CallFunction() returns OBJECT_INVALID.
void ai_SetResult(object oResult);

// ---< ai_InitializeNPC >---
// ---< ai_i_util >---
// Sets up the data structures to initialize a Memetic NPC. It places in the
// Memetic Vault a container object that holds all of the NPC's memetic
// datastructures. After calling this function, you can return the NPC's memetic
// object by calling ai_GetNPCSelf();
object ai_InitializeNPC(object oTarget = OBJECT_INVALID);

// ---< ai_ExecuteScript >---
// ---< ai_i_util >---
// Executes sScript, dispatching into a library if the script is registered as a
// lib-script, and sets up a MEME_SELF global so the script can set local data
// on a private object.
// Parameters:
// - sMethod: The name of the callback to the memetic object (e.g., "_go").
// - oSelf: Who actually executes the script. If the script performs Actions*(),
//   it will be on this object's action queue.
// - oInstance: The memetic object, accessed by the MEME_SELF global variable.
//   This allows the memetic callback to get access to local data.
void ai_ExecuteScript(string sScript, string sMethod, object oSelf = OBJECT_SELF, object oInstance = OBJECT_INVALID);

// ---< ai_CallFunction >---
// ---< ai_i_util >---
// Dynamically calls a Function that is defined in a Library Script, returning
// an object result. This object must be defined by the function script via a
// call to ai_SetResult(anObject).
// Parameters:
// - sFunction: The name of the function to be called. If it is not from a pre-
//   loaded library, it will attempt to automatically load a library with the
//   same name as sFunction.
// - oArgument: This is an object that may be passed to the function, which can
//   be retrieved via ai_GetArgument().
// - oSelf: Who actually calls the function. If the function performs Actions*()
//   it will be on this object's action queue.
// - oInstance: The memetic object, accessed by the MEME_SELF global variable.
//   This allows the memetic callback to get access to local data.
object ai_CallFunction(string sFunction, object oArgument = OBJECT_INVALID, object oSelf = OBJECT_SELF, object oInstance = OBJECT_INVALID);

// ---< _MakeObject >---
// ---< ai_i_util >---
// Private function. You should not need to use this.
// Creates an object within the memetic vault. To track these objects, reference
// variables are set up as safeguards against the failure of Bioware's scripts.
object _MakeObject(object oContainer, string sName, int nType, string sPrefix = "");

// ---< _MoveObject >---
// ---< ai_i_util >---
// Private function. You should not need to use this.
// Moves an object in the memetic vault. To track these objects, reference
// variables are set up as safeguards against the failure of Bioware's scripts.
void _MoveObject(object oContainer, object oObject, object oDestContainer, string sPrefix = "");

// ---< _RemoveObject >---
// ---< ai_i_util >---
// Private function. You should not need to use this.
// Removes an object from the memetic vault. To track these objects, reference
// variables are set up as safeguards against the failure of Bioware's scripts.
void _RemoveObject(object oContainer, object oObject, string sPrefix = "");


// ----- Datastructure Utilities -----------------------------------------------

// ---< ai_GetNPCSelf >---
// ---< ai_i_util >---
// Returns the memetic container for oTarget. If the NPC is not memetic, this
// will return OBJECT_INVALID. The memetic container is where you should store
// all your memetic data about a creature. That way, if you would like to create
// a new creature (for appearance's sake, or to change stastics), you can
// reattach it to this object. As a convention, you should not set data on any
// memetic creature. Instead set it on the memetic container object.
object ai_GetNPCSelf(object oTarget = OBJECT_SELF);

// ----- Response Table Functions ----------------------------------------------

// This implementation is old; see ai_i_response.

// ---< ai_AddResponse >---
// ---< ai_i_util >---
// Adds an entry to a response table. The entries in the table correspond to the
// behaviors in ai_m_docombat.
// Parameters:
// - sResponseFunction: the name of a function to be called. It is  assumed that
//   this function will return a valid object if it successfully completes.
//   Otherwise it should return OBJECT_VALID and another function will be called
//   to try to respond to the situation.
//  - nChance: This is the percentage chance that this function will be called.
//void ai_AddResponse(object oTarget, string sTable, string sResponseFunction, int nChance);

// ---< ai_HasResponseTable >---
// ---< ai_i_util >---
// Returns the number of entries in the target object's response table. If there
// are none, then the table is invalid.
//int ai_HasResponseTable(object oTarget, string sTable);

// ---< ai_DeleteResponseTable >---
// ---< ai_i_util >---
// Removes the response table from the object. If the target object used to
// inherit the table from another object, but has modified a local version of
// the table, bDeleteDeclaration can be passed as TRUE, causing the target to
// delete its local version and regain the inherited version. Otherwise the
// table will be deleted and will not inherit the original table.
//void ai_DeleteResponseTable(object oTarget, string sTable, int bDeleteDeclaration = FALSE);

// ---< ai_ActivateResponseTable >---
// ---< ai_i_util >---
// Tries all the responses in the table, defined by ai_AddResponse(). Each entry
// If one entry succeeds, this function will return TRUE; otherwise FALSE is
// returned.
// Parameters:
// - oTarget: the object that has (or inherits) the response table.
// - sTable: the name of the response table as described in ai_AddResponse().
//string ai_ActivateResponseTable(object oTarget, string sTable, object oArgument = OBJECT_INVALID);



// ----- Variable Binding Routines ---------------------------------------------

// ---< ai_UpdateLocals >---
// ---< ai_i_util >---
// Copies variables from a source to oTarget. The source and target variable are
// defined via the ai_Bind*() functions.
// - oTarget: An object that was the oTarget parameter to ai_Bind*(). If this
//   object is a memetic sequence, the command to update will be propogated to
//   each item in the sequence.
//   Note: This allows a sequence S to have children C1, C2, ... Cn. Each child
//   can bind some parameters to the sequence's variable. S <-> Cn. Then several
//   of the children can be adjusted by changing the variables on the sequence
//   and calling ai_UpdateLocals().
void ai_UpdateLocals(object oTarget);

// ---< ai_BindLocalObject >---
// ---< ai_i_util >---
// Copies the variable from oSource to oTarget when ai_UpdateLocals() is called.
void ai_BindLocalObject(object oSource, string sSourceVariable, object oTarget, string sTargetVariable);

// ---< ai_BindLocalFloat >---
// ---< ai_i_util >---
// Copies the variable from oSource to oTarget when ai_UpdateLocals() is called.
void ai_BindLocalFloat(object oSource, string sSourceVariable, object oTarget, string sTargetVariable);

// ---< ai_BindLocalInt >---
// ---< ai_i_util >---
// Copies the variable from oSource to oTarget when ai_UpdateLocals() is called.
void ai_BindLocalInt(object oSource, string sSourceVariable, object oTarget, string sTargetVariable);

// ---< ai_BindLocalString >---
// ---< ai_i_util >---
// Copies the variable from oSource to oTarget when ai_UpdateLocals() is called.
void ai_BindLocalString(object oSource, string sSourceVariable, object oTarget, string sTargetVariable);

// ---< ai_BindLocalLocation >---
// ---< ai_i_util >---
// Copies the variable from oSource to oTarget when ai_UpdateLocals() is called.
void ai_BindLocalLocation(object oSource, string sSourceVariable, object oTarget, string sTargetVariable);

// ----- Auto Adjusting Variables- ---------------------------------------------

// ---< ai_SetTemporaryFlag >---
// ---< ai_i_util >---
// Creates a flag that will be set to zero after a duration.
// - oObject: The target object which will hold the temporary variable.
// - sVarName: The name of the variable.
// - nValue: The value you want to be set on the variable.
// - nDuration: The number of seconds from now until the variable should be
//   set to zero. If you pass a duration of 0, the variable will stay at that
//   value until you call this function again with a non-zero duration.
// Note: This will not collide with any other variables named sVarName.
void ai_SetTemporaryFlag(object oObject, string sVarName, int nValue, int nDuration);

// ---< ai_GetTemporaryFlag >---
// ---< ai_i_util >---
// Returns the value of a temporary flag variable of sVarName from oObject. This
// variable is set by a call to ai_SetTemporaryFlag.
int ai_GetTemporaryFlag(object oObject, string sVarName);

// ---< ai_SetDecayingInt >---
// ---< ai_i_util >---
// Sets an int variable of sVarName with nValue on oObject that is gradually
// reduced to zero. This does not use DelayCommand and does not destroy the
// variable. The decay does not take any CPU resources. The decay will start
// immediately.
// - fSlope: The amount of change over time which will cause the int to reach 0.
//   The decrease will follow the downward slope of a bell-shaped curve. A (0 or
//   positive) value can be supplied to change the speed of the decay:
//   - if fSlope is 1 (default) an Int starting at 100 will decay to 0 in 100 seconds
//   - a slope more then 1 will accelerate the decay
//   - a slope less then 1 will slow the decay
//   - if the slope is 0 then the int will remain constant
void ai_SetDecayingInt(object oObject, string sVarName, int nValue, float fSlope=1.0f);

// ---< ai_SetDecayingIntByTTL >---
// ---< ai_i_util >---
// Set an int of sVarName with nValue on oObject that is reduced to zero within
// fLifetime seconds. This does not use DelayCommand and does not destroy the
// variable. The decay does not take any CPU resources. It is a cover for
// ai_SetDecayingInt().
void ai_SetDecayingIntByTTL(object oObject, string sVarName, int nValue, float fLifetime);

// ---< ai_GetDecayingInt >---
// ---< ai_i_util >---
// Returns the current value of the decaying Int set with ai_SetDecayingInt()
int ai_GetDecayingInt(object oObject, string sVarName);

// ---< ai_ClearDecayingInt >---
// ---< ai_i_util >---
// Deletes a decaying Int set with ai_SetDecayingInt()
void ai_ClearDecayingInt(object oObject, string sVarName);

// ----- Flag Utilities --------------------------------------------------------

// ---< ai_AddMemeFlag >---
// ---< ai_i_util >---
// Sets an internal flag on oObject. For example, if you wanted a meme to start
// repeating, you could call ai_AddMemeFlag(oMeme, AI_MEME_REPEAT).
void ai_AddMemeFlag(object oObject, int nFlag);

// ---< ai_ClearMemeFlag >---
// ---< ai_i_util >---
//  Removes an nFlag from a oObject.
void ai_ClearMemeFlag(object oObject, int nFlag);

// ---< ai_GetMemeFlag >---
// ---< ai_i_util >---
// Returns whether nFlag is set on oObject. For example, if you wanted to see if
// a meme resumed and repeated, you call:
//     if (ai_GetMemeFlag(oMeme, AI_MEME_RESUME & AI_MEME_REPEAT)) { ... }
int ai_GetMemeFlag(object oObject, int nFlag);

// ---< ai_SetMemeFlag >---
// ---< ai_i_util >---
// Clears all of the flags on oObject and sets just nFlag. This is an efficient
// combination of Clear and Add.
void ai_SetMemeFlag(object oObject, int nFlag);

// ----- Class & Inheritance Functions -----------------------------------------

// ---< ai_RegisterClass >---
// ---< ai_i_util >---
// Creates the datastructures needed to represent a class in the game. A class
// object is an object which has "declared" variables on it. This will also
// execute the class script's "_ini" (initialization) method. This script may be
// declared in a library. It is commonly used to declare variables on the class
// that may be inherited by instances of the class.
// - sClassName: A unique class name.
// - oClassObject: You may provide your own class object. If you do not, an
//   invisible storage object will be created for you.
object ai_RegisterClass(string sClassName, object oClassObject = OBJECT_INVALID);

// ----- Other Utilities -------------------------------------------------------

// ---< ai_GetIsVisible >---
// ---< ai_i_util >---
// Checks if oSource can see oTarget.
int ai_GetIsVisible(object oTarget, object oSource = OBJECT_SELF);

// ---< _KeyCombine >---
// ---< ai_i_util >---
// This is an internal function to the class system. Its job is to combine two
// unique keys into a new unique a+b key. This allows the toolkit to track
// multiple inheritance with a single unique identifier.
string _KeyCombine(string a, string b);

// ---< _NewKey >---
// ---< ai_i_util >---
// This is an internal function to the class system. Its job is to create a
// unique key that can be combined with _KeyCombine.
string _NewKey();

/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

void ai_CreateMemeVault()
{
    object oModule = GetModule();
    object oVault = GetLocalObject(oModule, AI_MEME_VAULT);
    if (!GetIsObjectValid(oVault))
    {
        oVault = CreateObject(OBJECT_TYPE_STORE, AI_MEME_VAULT, GetStartingLocation());
        SetLocalObject(oModule, AI_MEME_VAULT, oVault);
        MEME_VAULT = oVault;
        object oMeme = CreateItemOnObject(AI_MEME_OBJECT, oVault);
        SetLocalObject(oModule, AI_MEME_OBJECT, oMeme);
    }
}

object ai_GetMemeVault()
{
    object oVault = GetLocalObject(GetModule(), AI_MEME_VAULT);
    if (!GetIsObjectValid(oVault))
    {
        ai_CreateMemeVault();
        oVault = GetLocalObject(GetModule(), AI_MEME_VAULT);
    }

    return oVault;
}


// ---- Basic Response Tables --------------------------------------------------

/*

void ai_AddResponse(object oTarget, string sTable, string sResponseFunction, int nChance)
{
    ai_PrintString("Adding entry to "+sTable+" response table: "+IntToString(nChance)+"% chance "+sResponseFunction+" will occur.");
    ai_AddStringRef(oTarget, sResponseFunction, AI_RESPONSE_TABLE + sTable);
    ai_AddIntRef(oTarget, nChance, AI_RESPONSE_TABLE + sTable);
}

int ai_HasResponseTable(object oTarget, string sTable)
{
    return ai_GetStringCount(oTarget, AI_RESPONSE_TABLE + sTable);
}

void ai_DeleteResponseTable(object oTarget, string sTable, int bDeleteDeclaration = 0)
{
    ai_DeleteStringRefs(oTarget, AI_RESPONSE_TABLE + sTable, bDeleteDeclaration);
    ai_DeleteIntRefs(oTarget, AI_RESPONSE_TABLE + sTable, bDeleteDeclaration);
}

string ai_ActivateResponseTable(object oTarget, string sTable, object oArgument = OBJECT_INVALID)
{
    sTable = AI_RESPONSE_TABLE+sTable;
    int i, nChance, nChanceResult;
    int nCount = ai_GetStringCount(oTarget, sTable);
    string sResponse;

    for (i = 0; i < nCount; i++)
    {
        sResponse = ai_GetStringByIndex(oTarget, i, sTable);
        nChance   = ai_GetIntByIndex(oTarget, i, sTable);

        nChanceResult = Random(100);
        ai_PrintString(IntToString(nChanceResult)+" &lt; "+IntToString(nChance)+" --- "+sResponse, FALSE, AI_DEBUG_COREAI);

        // I removed "GetLocalString(oTarget, sResponse)" because not everyone will use
        // overrides. This needs to be standardized. Personally I would advise only
        // filling the table with the values you need. An NPC overrides the table, not
        // the functions to be called.
        if (nChanceResult < nChance && GetIsObjectValid(ai_CallFunction(sResponse, oArgument)))
        {
            ai_PrintString("Response taken for "+sTable+": " + sResponse + " by " + _GetName(OBJECT_SELF), FALSE, AI_DEBUG_COREAI);
            return sResponse;
        }
    }
    ai_PrintString("No response taken for "+sTable+".");
    return "";
}

*/

// ---- Auto-expiring integer variables ----------------------------------------

void _ClearTemporaryFlag(object oObject, string sVarName, int nTimeStamp, string sClassName)
{
    ai_DebugStart("_ClearTemporaryFlag", AI_DEBUG_UTILITY);

    if (GetLocalInt(oObject, AI_TEMPORARY_TIMESTAMP + sVarName) == nTimeStamp)
        DeleteLocalInt(oObject, AI_TEMPORARY_VARIABLE + sVarName);

    ai_DebugEnd();
}

void ai_SetTemporaryFlag(object oObject, string sVarName, int nValue, int nDuration)
{
    ai_DebugStart("ai_SetTemporaryFlag", AI_DEBUG_UTILITY);

    // The namespace variable allows several creatures to store their flag on the same creature
    string sClassName = ObjectToString(OBJECT_SELF);
    int nTimeStamp = GetLocalInt(oObject, AI_TEMPORARY_TIMESTAMP + sClassName) + 1;
    SetLocalInt(oObject, AI_TEMPORARY_TIMESTAMP + sVarName, nTimeStamp);
    SetLocalInt(oObject, AI_TEMPORARY_VARIABLE + sVarName, nValue);

    // If you pass a 0 for time, this will lock in the value as "on".
    if (nDuration > 0)
        DelayCommand(IntToFloat(nDuration), _ClearTemporaryFlag(oObject, sVarName, nTimeStamp, sClassName));

    ai_DebugEnd();
}

int ai_GetTemporaryFlag(object oObject, string sVarName)
{
    ai_DebugStart("ai_GetTemporaryFlag", AI_DEBUG_UTILITY);

    int nResult = GetLocalInt(oObject, AI_TEMPORARY_VARIABLE + ObjectToString(OBJECT_SELF) + sVarName);

    ai_DebugEnd();
    return nResult;
}

void ai_ClearDecayingInt(object oObject, string sVarName)
{
    ai_DebugStart("ai_ClearDecayingInt", AI_DEBUG_UTILITY);

    DeleteLocalInt(oObject, AI_DECAYING_VARIABLE + sVarName);
    DeleteLocalFloat(oObject, AI_DECAYING_START + sVarName);
    DeleteLocalFloat(oObject, AI_DECAYING_SLOPE + sVarName);

    ai_DebugEnd();
}

void ai_SetDecayingInt(object oObject, string sVarName, int nValue, float fSlope=1.0f)
{
    ai_DebugStart("ai_SetDecayingInt", AI_DEBUG_UTILITY);

    if (!nValue) // zero value, just drop the variable
        ai_ClearDecayingInt(oObject, sVarName);
    else
    {
        float fNow = GetTimeSecond()       +
                    (GetTimeMinute() * 60) +
                     HoursToSeconds(GetTimeHour() + ((GetCalendarDay() - 1) * 24));
        SetLocalInt(oObject, AI_DECAYING_VARIABLE + sVarName, nValue);
        SetLocalFloat(oObject, AI_DECAYING_START + sVarName, fNow);
        SetLocalFloat(oObject, AI_DECAYING_SLOPE + sVarName, fSlope);
    }

    ai_DebugEnd();
}

int ai_GetDecayingInt(object oObject, string sVarName)
{
    ai_DebugStart("ai_GetDecayingInt", AI_DEBUG_UTILITY);

    int nResult = GetLocalInt(oObject, AI_DECAYING_VARIABLE + sVarName);
    if (nResult) // skip if zero
    {
        float fX =   GetTimeSecond()       +
                    (GetTimeMinute() * 60) +
                     HoursToSeconds(GetTimeHour() + ((GetCalendarDay() - 1) * 24));
        fX -= GetLocalFloat(oObject, AI_DECAYING_START + sVarName);

        if (fX < 0.0)                           // wrapped around end-of-month
            fX += HoursToSeconds(672);          // hours in a month 24 * 28

        fX *= 0.02145966f;          // adjustment factor = sqrt(ln(100)) / 100
        float fSlope = GetLocalFloat(oObject, AI_DECAYING_SLOPE + sVarName);
        float fFactor = pow(2.71828182845904523536028747135266 ,   // e
                           (fSlope * fX * fX));
        nResult = FloatToInt(nResult / fFactor);

        if (!nResult) // became zero, drop the variable
            ai_ClearDecayingInt(oObject, sVarName);
    }

    ai_DebugEnd();
    return nResult;
}

void ai_SetDecayingIntByTTL(object oObject, string sVarName, int nValue, float fGameTimeToLive)
{
    ai_DebugStart("ai_SetDecayingIntByTTL", AI_DEBUG_UTILITY);

    float fSlope = log(IntToFloat(abs(nValue)));
    fSlope /= pow((fGameTimeToLive * 0.02145966f ), 2.0f);
    ai_SetDecayingInt(oObject, sVarName, nValue, fSlope);

    ai_DebugEnd();
}

// This function will likely be tweaked as the system improves. It is the
// reusable function for determinining if an NPC sees another creature. This
// should take into account a variety of internal states (like the use of a
// feat, or a natural detection ability). At this time it is pretty simple.
int ai_GetIsVisible(object oTarget, object oSource = OBJECT_SELF)
{
    ai_DebugStart("ai_GetIsVisible", AI_DEBUG_UTILITY);

    if (!GetObjectSeen(oTarget, oSource))
    {
        ai_DebugEnd();
        return FALSE;
    }

    if (GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oTarget) ||
        GetHasSpellEffect(SPELL_INVISIBILITY, oTarget))
    {
        if (GetHasSpellEffect(SPELL_TRUE_SEEING, oSource) ||
            GetHasSpellEffect(SPELL_SEE_INVISIBILITY, oSource))
        {
            ai_DebugEnd();
            return TRUE;
        }

        ai_DebugEnd();
        return FALSE;
    }

    ai_DebugEnd();
    return TRUE;

    /* Notes - some things which may be an issue, later:
    Blindness? Darkness?
    Smell?
    Lighting Conditions
    Invisibility
    Distance
    Hidden / Stealth
    Special Cases (A cannot see B)
    Field of Vision
    Size of creature
    Motion tracking "T-Rex"

    EffectDarkness
    EffectBlindness
    EffectInvisibility
    EffectSeeInvisible
    GetCreatureSize
    GetStealthMode
    EffectDisappear
    EffectDeath
    EffectTrueSeeing
    EffectUltravision
    GetDetectMode
    FEAT_ALERTNESS
    FEAT_KEEN_SENSE
    FEAT_LOWLIGHTVISION
    FEAT_LUCKY
    FEAT_NATURE_SENSE
    FEAT_PARTIAL_SKILL_AFFINITY_SPOT
    FEAT_PARTIAL_SKILL_AFFINITY_SEARCH
    FEAT_SKILL_AFFINITY_SPOT
    FEAT_SKILL_AFFINITY_SEARCH
    FEAT_SKILL_AFFINITY_MOVE_SILENTLY
    FEAT_SKILL_FOCUS_HIDE
    FEAT_PARTIAL_SKILL_AFFINITY_LISTEN
    FEAT_SKILL_AFFINITY_CONCENTRATION
    FEAT_SKILL_FOCUS_LISTEN
    FEAT_SKILL_FOCUS_SEARCH
    */
}

// -----------------------------------------------------------------------------

object ai_GetNPCSelf(object oTarget = OBJECT_SELF)
{
    return GetLocalObject(oTarget, AI_NPC_SELF);
}

object ai_GetNPCSelfOwner(object oNPCSelf)
{
    return GetLocalObject(oNPCSelf, AI_MEME_OWNER);
}

/* Object Functions
 * These are the base functions for creating a data structure object to hold
 * varaibles -- representing various memetic objects or bags which hold these
 * objects. These functions also create the references on the bags using the
 * object ref functions.
 */

object _MakeObject(object oTarget, string sName, int nType, string sListName = "")
{
    ai_DebugStart("_MakeObject", AI_DEBUG_UTILITY);
    object oResult;

    if (!GetIsObjectValid(NPC_SELF))
        PrintString("<Assert>Cannot make object, NPC_SELF invalid.</Assert>");

    oResult = CopyItem(GetLocalObject(GetModule(), AI_MEME_OBJECT), oTarget);

    if (!GetIsObjectValid(oResult))
        PrintString("<Assert>Failed to CreateItemOnObject.</Assert>");

    SetName(oResult, sName);
    SetLocalInt(oResult, AI_MEME_TYPE, nType);

    ai_AddObjectRef(oTarget, oResult, sListName);
    ai_DebugEnd();
    return oResult;
}

// Do not use this; I use it. But that doesn't mean you should use it. :)
void _MoveObject(object oContainer, object oObject, object oDestContainer, string sListName = "")
{
    ai_DebugStart("_MoveObject", AI_DEBUG_UTILITY);

    NPC_SELF = GetLocalObject(OBJECT_SELF, AI_NPC_SELF);

    if (GetIsObjectValid(oDestContainer) && GetIsObjectValid(oObject) && GetIsObjectValid(oContainer))
    {
        ai_RemoveObjectRef(oContainer, oObject, sListName);
        ai_AddObjectRef(oDestContainer, oObject, sListName);
    }
    else
        ai_PrintString("Error: _MoveObject failed for "+_GetName(OBJECT_SELF)+"!");

    ai_DebugEnd();
}


void _RemoveObject(object oTarget, object oObject, string sListName = "")
{
    ai_DebugStart("_RemoveObject name='"+_GetName(oObject)+"'", AI_DEBUG_UTILITY);

    ai_RemoveObjectRef(oTarget, oObject, sListName);
    DestroyObject(oObject);

    ai_DebugEnd();
}


// Setup Meme Bags
// Used to construct the containers which hold memetic objects.
// Warning: If you call ai_InitializeNPC on another creature, your global
// NPC_SELF is screwed. Beware.
object ai_InitializeNPC(object oTarget = OBJECT_INVALID)
{
    ai_DebugStart("ai_InitializeNPC", AI_DEBUG_TOOLKIT);

    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;
    object oSelf = ai_GetNPCSelf(oTarget);

    if (!GetIsObjectValid(oSelf))
    {
        object oMemeVault = ai_GetMemeVault();
        if (oMemeVault == OBJECT_INVALID)
            PrintString("<Assert>Cannot find the meme vault waypoint -- this is a critical error!</Assert>");
        else
            ai_PrintString("MemeVault is present, good.");

        oSelf = CopyObject(GetLocalObject(GetModule(), AI_MEME_OBJECT), GetLocation(oMemeVault), oMemeVault, "Memetic NPC Self");

        if (!GetIsObjectValid(oSelf))
            ai_PrintString("Assert: Failed to create NPC_SELF on object:"+_GetName(oTarget));
        else
            ai_PrintString("NPC_SELF initialized, item successfully created.");

        if (oTarget == OBJECT_SELF)
            NPC_SELF = oSelf;

        SetLocalObject(oTarget, AI_NPC_SELF,   oSelf);
        SetLocalObject(oSelf,   AI_MEME_OWNER, oTarget);
        SetName(oSelf, GetName(oTarget)+"s Memetic Object");

        // Create the generator bag, which holds references to the memes it generates
        object oBag = _MakeObject(oSelf, "GeneratorBag", AI_TYPE_GENERATOR_BAG);
        SetLocalObject(oSelf, AI_GENERATOR_BAG, oBag);

        // Create the event bag, which holds event memes
        oBag = _MakeObject(oSelf, "EventBag", AI_TYPE_EVENT_BAG);
        SetLocalObject(oSelf, AI_EVENT_BAG, oBag);

        // Create the priority bags, which hold a list of prioritized memes
        oBag = _MakeObject(oSelf, "PriorityBag1", AI_TYPE_PRIORITY_BAG);
        SetLocalObject(oSelf, AI_MEME_PRIORITY_BAG + "1", oBag);
        oBag = _MakeObject(oSelf, "PriorityBag2", AI_TYPE_PRIORITY_BAG);
        SetLocalObject(oSelf, AI_MEME_PRIORITY_BAG + "2", oBag);
        oBag = _MakeObject(oSelf, "PriorityBag3", AI_TYPE_PRIORITY_BAG);
        SetLocalObject(oSelf, AI_MEME_PRIORITY_BAG + "3", oBag);
        oBag = _MakeObject(oSelf, "PriorityBag4", AI_TYPE_PRIORITY_BAG);
        SetLocalObject(oSelf, AI_MEME_PRIORITY_BAG + "4", oBag);
        oBag = _MakeObject(oSelf, "PriorityBag5", AI_TYPE_PRIORITY_BAG);
        SetLocalObject(oSelf, AI_MEME_PRIORITY_BAG + "5", oBag);
        oBag = _MakeObject(oSelf, "SuspendBag", AI_TYPE_PRIORITY_SUSPEND);
        SetLocalObject(oSelf, AI_SUSPEND_BAG, oBag);
    }

    // NPC_SELF is a global that represents the memetic self (as opposed to
    // OBJECT_SELF). This is the object that should hold your variables and will
    // be saved, when saving NPCs is supported.
    if (oTarget == OBJECT_SELF)
        NPC_SELF = oSelf;

    ai_DebugEnd();
    return oSelf;
}

// Run a Memetic Script
// This executes a script such as ai_m_attack_go and constructs a Self object for
// storing local data to the script.
void ai_ExecuteScript(string sScript, string sMethod, object oSelf = OBJECT_SELF, object oInstance = OBJECT_INVALID)
{
    if (sScript == "")
        return;

    ai_DebugStart("ai_ExecuteScript script = '" + sScript + sMethod + "'", AI_DEBUG_TOOLKIT);

    object oVault = ai_GetMemeVault();
    string sLib = GetLocalString(oVault, AI_MEME_SCRIPT + sScript);
    int nEntry;

    if (sLib == "")
    {
        // The script is not in a loaded library, so attempt to auto-load
        ai_LoadLibrary(sScript);
        sLib = GetLocalString(oVault, AI_MEME_SCRIPT + sScript);

        if (sLib == "")
        {
            // The meme is not in a library
            sLib = "*nolib*";
            SetLocalString(oVault, AI_MEME_SCRIPT + sScript, sLib);
        }
    }

    if (sLib == "*nolib*")
        // The meme is not in a library
        sLib = sScript + sMethod;
    else
    {
        nEntry = GetLocalInt(oVault, AI_MEME_ENTRY + sLib + sScript + sMethod);
        if (!nEntry)
        {
            // The meme doesn't implement this method
            ai_DebugEnd();
            return;
        }
    }

    SetLocalString(oVault, AI_MEME_LAST_EXECUTED, sLib);
    SetLocalString(oVault, AI_MEME_LAST_CALLED, sScript);
    SetLocalString(oVault, AI_MEME_LAST_METHOD, sMethod);
    SetLocalInt(oVault, AI_MEME_LAST_ENTRY_POINT, nEntry);
    object self = GetLocalObject(oSelf, AI_MEME_SELF);

    if (oInstance != OBJECT_INVALID)
        SetLocalObject(oSelf, AI_MEME_SELF, oInstance);

    ExecuteScript(sLib, oSelf);

    if (oInstance != OBJECT_INVALID)
        SetLocalObject(oSelf, AI_MEME_SELF, self);

    ai_DebugEnd();
}

// Library Functions
// Used for Meme-code Libraries maintenance

void ai_LoadLibrary(string sLib)
{
    ai_DebugStart("ai_LoadLibrary library = '" + sLib + "'", AI_DEBUG_TOOLKIT);

    object oVault = ai_GetMemeVault();

    SetLocalString(oVault, AI_MEME_LAST_EXECUTED, sLib);
    SetLocalString(oVault, AI_MEME_LAST_CALLED, sLib);
    SetLocalString(oVault, AI_MEME_LAST_METHOD, AI_METHOD_LOAD);
    SetLocalInt(oVault, AI_MEME_LAST_ENTRY_POINT, 0);
    ExecuteScript(sLib, oVault);

    ai_DebugEnd();
}

void ai_LoadLibraries()
{
    int nIndex = 1;
    object oVault = ai_GetMemeVault();
    string sLib = GetLocalString(oVault, AI_LIBRARY + IntToString(nIndex));

    while (sLib != "")
    {
        ai_LoadLibrary(sLib);
        sLib = GetLocalString(oVault, AI_LIBRARY + IntToString(++nIndex));
    }
}

// Dynamically calls a Function in a Library
object ai_CallFunction(string sFunction, object oArgument = OBJECT_INVALID, object oSelf = OBJECT_SELF, object oInstance = OBJECT_INVALID)
{
    ai_DebugStart("ai_CallFunction function = '" + sFunction + "'", AI_DEBUG_TOOLKIT);

    object oVault = ai_GetMemeVault();
    string sLib = GetLocalString(oVault, AI_MEME_SCRIPT + sFunction);

    if (sLib == "")
    {
        // Not in any loaded library, so attempt to auto-load
        ai_LoadLibrary(sFunction);
        sLib = GetLocalString(oVault, AI_MEME_SCRIPT + sFunction);
        if (sLib == "")
        {
            sLib = "*nolib*";
            SetLocalString(oVault, AI_MEME_SCRIPT + sFunction, sLib);
        }
    }

    if (sLib == "*nolib*")
    {
        // the function is not in a library
        ai_DebugEnd();
        return OBJECT_INVALID;
    }

    int nEntry = GetLocalInt(oVault, AI_MEME_ENTRY + sLib + sFunction);
    if (!nEntry)
    {
        // Function isn't implemented
        ai_DebugEnd();
        return OBJECT_INVALID;
    }

    SetLocalString(oVault, AI_MEME_LAST_EXECUTED, sLib);
    SetLocalString(oVault, AI_MEME_LAST_CALLED, sFunction);
    SetLocalString(oVault, AI_MEME_LAST_METHOD, "");
    SetLocalInt(oVault, AI_MEME_LAST_ENTRY_POINT, nEntry);
    SetLocalObject(oVault, AI_MEME_FUNCTION_ARGUMENT, oArgument);

    object oSaveResult = GetLocalObject(oVault, AI_MEME_FUNCTION_RESULT);
    SetLocalObject(oVault, AI_MEME_FUNCTION_RESULT, OBJECT_INVALID);
    object self = GetLocalObject(oSelf, AI_MEME_SELF);

    if (oInstance != OBJECT_INVALID)
        SetLocalObject(oSelf, AI_MEME_SELF, oInstance);

    ExecuteScript(sLib, oSelf);

    if (oInstance != OBJECT_INVALID)
        SetLocalObject(oSelf, AI_MEME_SELF, self);

    object oResult = GetLocalObject(oVault, AI_MEME_FUNCTION_RESULT);
    SetLocalObject(oVault, AI_MEME_FUNCTION_RESULT, oSaveResult);

    ai_DebugEnd();
    return oResult;
}

void ai_LibraryImplements(string sMeme, string sMethod, int nEntry = ALLFLAGS)
{
    ai_DebugStart("ai_LibraryImplements meme = '" + sMeme + "'" + " method = '" + sMethod + "'" + " entry = '"+IntToString(nEntry) + "'", AI_DEBUG_TOOLKIT);
    object oVault = ai_GetMemeVault();
    string sLib   = GetLocalString(oVault, AI_MEME_LAST_EXECUTED);
    string sExist = GetLocalString(oVault, AI_MEME_SCRIPT + sMeme);

    if (sLib != sExist)
    {
        if (sExist != "")
            ai_PrintString("Warning! Library " + sLib + " is overriding " + sMeme + " implementation by Library " + sExist);
        SetLocalString(oVault, AI_MEME_SCRIPT + sMeme, sLib);
    }

    int nOldEntry = GetLocalInt(oVault, AI_MEME_ENTRY + sLib + sMeme + sMethod);
    if (nOldEntry)
        ai_PrintString("Warning! Library" + sLib + " method " + sMethod + " of " + sMeme + " already declared. Old EP=" + IntToString(nOldEntry) + " new EP="+IntToString(nEntry));

    SetLocalInt(oVault, AI_MEME_ENTRY + sLib + sMeme + sMethod, nEntry);

    ai_DebugEnd();
}

void ai_LibraryFunction(string sFunction, int nEntry = ALLFLAGS)
{
    ai_DebugStart("ai_LibraryFunction function = '" + sFunction + "'" + " entry = '" + IntToString(nEntry) + "'", AI_DEBUG_TOOLKIT);
    object oVault = ai_GetMemeVault();
    string sLib   = GetLocalString(oVault, AI_MEME_LAST_EXECUTED);
    string sExist = GetLocalString(oVault, AI_MEME_SCRIPT + sFunction);
    if (sLib != sExist)
    {
        if (sExist != "")
            ai_PrintString("Warning! Library "+sLib+" is overriding "+sFunction+" implementation by Library "+sExist);
        SetLocalString(oVault, AI_MEME_SCRIPT + sFunction, sLib);
    }

    int nOldEntry = GetLocalInt(oVault, AI_MEME_ENTRY + sLib + sFunction);
    if (nOldEntry)
        ai_PrintString("Warning! Library"+sLib+" function "+sFunction+" already declared. Old EP="+IntToString(nOldEntry)+" new EP="+IntToString(nEntry));

    SetLocalInt(oVault, AI_MEME_ENTRY + sLib + sFunction, nEntry);
    ai_DebugEnd();
}

object ai_GetArgument()
{
    return MEME_ARGUMENT;
}

void ai_SetResult(object oResult)
{
    SetLocalObject(ai_GetMemeVault(), AI_MEME_FUNCTION_RESULT, oResult);
}

// ----- List handling functions -----------------------------------------------

// This is an internal function; it takes a list of strings and creates
// an exploded string list with the given name. This works on lists that
// look might like: "red, green,blue, dark orange, black,white"
void ai_ExplodeList(object oTarget, string sCompressedList, string sListName)
{
    ai_DebugStart("ai_ExplodeList"+" input='"+sCompressedList+"'", AI_DEBUG_UTILITY);
    int    len  = GetStringLength(sCompressedList);
    int    offset;
    string text = sCompressedList;
    string item;

    // This function parses the list "a, b,c,d, e,f" and processes each item.
    do
    {
        // Remove white space from the front of text
        // Rember, we're in a loop here so we may have just gone from:
        // "a, b" to " b" after "a," is stripped away. Since we want to
        // process "b" not " b" we strip away all spaces. Observe that
        // this does not allow for "a , b". In this case item will be "a ".
        while(FindSubString(text, " ") == 0) text = GetStringRight(text, --len);

        // Now find where the first item ends -- look for a comma.
        offset = FindSubString(text, ",");

        // If we found a comma there's more than one item; peel it off and
        // truncate the left side of list, removing the item and its comma.
        if (offset != -1)
        {
            item  = GetStringLeft(text, offset);
            len   -= offset+1;
            text  = GetStringRight(text, len);
        }
        // Otherwise the offset is -1, we didn't find a comma - there is only one item left.
        else
        {
            item = text;
            text = "";
        }

        // Now process the next item off the list
        ai_AddStringRef(oTarget, item, sListName);
    } while (text != "");

    ai_DebugEnd();
}

// ----- Variable Binding Routines ---------------------------------------------

// This version does not update sequences.
void _UpdateLocals(object oTarget)
{
    ai_DebugStart("ai_UpdateLocals", AI_DEBUG_UTILITY);
    int i;

    // Copy Object Values
    for (i = ai_GetObjectCount(oTarget, AI_BIND_OBJECT_SOURCE_OBJECT) - 1; i >= 0; i--)
    {
        SetLocalObject(oTarget,
                       ai_GetStringByIndex(oTarget, i, AI_BIND_OBJECT_TARGET_VARIABLE),
                       GetLocalObject(ai_GetObjectByIndex(oTarget, i, AI_BIND_OBJECT_SOURCE_OBJECT),
                                      ai_GetStringByIndex(oTarget, i, AI_BIND_OBJECT_SOURCE_VARIABLE)));
    }

    // Copy Float Values
    for (i = ai_GetObjectCount(oTarget, AI_BIND_FLOAT_SOURCE_OBJECT) - 1; i >= 0; i--)
    {
        SetLocalFloat(oTarget,
                       ai_GetStringByIndex(oTarget, i, AI_BIND_FLOAT_TARGET_VARIABLE),
                       GetLocalFloat(ai_GetObjectByIndex(oTarget, i, AI_BIND_FLOAT_SOURCE_OBJECT),
                                      ai_GetStringByIndex(oTarget, i, AI_BIND_FLOAT_SOURCE_VARIABLE)));    }

    // Copy Int Values
    for (i = ai_GetObjectCount(oTarget, AI_BIND_INT_SOURCE_OBJECT) - 1; i >= 0; i--)
    {
        SetLocalInt(oTarget,
                       ai_GetStringByIndex(oTarget, i, AI_BIND_INT_TARGET_VARIABLE),
                       GetLocalInt(ai_GetObjectByIndex(oTarget, i, AI_BIND_INT_SOURCE_OBJECT),
                                      ai_GetStringByIndex(oTarget, i, AI_BIND_INT_SOURCE_VARIABLE)));    }

    // Copy String Values
    for (i = ai_GetObjectCount(oTarget, AI_BIND_STRING_SOURCE_OBJECT) - 1; i >= 0; i--)
    {
        SetLocalString(oTarget,
                       ai_GetStringByIndex(oTarget, i, AI_BIND_STRING_TARGET_VARIABLE),
                       GetLocalString(ai_GetObjectByIndex(oTarget, i, AI_BIND_STRING_SOURCE_OBJECT),
                                      ai_GetStringByIndex(oTarget, i, AI_BIND_STRING_SOURCE_VARIABLE)));
    }

    // Copy Location Values
    for (i = ai_GetObjectCount(oTarget, AI_BIND_LOCATION_SOURCE_OBJECT) - 1; i >= 0; i--)
    {
        SetLocalLocation(oTarget,
                       ai_GetStringByIndex(oTarget, i, AI_BIND_LOCATION_TARGET_VARIABLE),
                       GetLocalLocation(ai_GetObjectByIndex(oTarget, i, AI_BIND_LOCATION_SOURCE_OBJECT),
                                      ai_GetStringByIndex(oTarget, i, AI_BIND_LOCATION_SOURCE_VARIABLE)));
    }

    ai_DebugEnd();
}

void ai_UpdateLocals(object oTarget)
{
    object oSequence, oObject;
    int nType = GetLocalInt(oTarget, AI_MEME_TYPE);
    int i;

    if (nType == AI_TYPE_SEQUENCE)
        oSequence = oTarget;
    else if (nType == AI_TYPE_SEQUENCE_REF)
        oSequence = GetLocalObject(oTarget, AI_MEME_SEQUENCE);

    if (oSequence != OBJECT_INVALID)
    {
        for (i = ai_GetObjectCount(oSequence) - 1; i >= 0; i--)
        {
            oObject = ai_GetObjectByIndex(oSequence, i);
            ai_UpdateLocals(oObject);
        }
    }
    else
        _UpdateLocals(oTarget);
}

void ai_BindLocalObject(object oSource, string sSourceVariable, object oTarget, string sTargetVariable)
{
    ai_DebugStart("ai_BindLocalObject", AI_DEBUG_UTILITY);

    ai_AddObjectRef(oTarget, oSource, AI_BIND_OBJECT_SOURCE_OBJECT);
    ai_AddStringRef(oTarget, sTargetVariable, AI_BIND_OBJECT_TARGET_VARIABLE);
    ai_AddStringRef(oTarget, sSourceVariable, AI_BIND_OBJECT_SOURCE_VARIABLE);

    ai_DebugEnd();
}

void ai_BindLocalFloat(object oSource, string sSourceVariable, object oTarget, string sTargetVariable)
{
    ai_DebugStart("ai_BindLocalFloat", AI_DEBUG_UTILITY);

    ai_AddObjectRef(oTarget, oSource, AI_BIND_FLOAT_SOURCE_OBJECT);
    ai_AddStringRef(oTarget, sTargetVariable, AI_BIND_FLOAT_TARGET_VARIABLE);
    ai_AddStringRef(oTarget, sSourceVariable, AI_BIND_FLOAT_SOURCE_VARIABLE);

    ai_DebugEnd();
}

void ai_BindLocalInt(object oSource, string sSourceVariable, object oTarget, string sTargetVariable)
{
    ai_DebugStart("ai_BindLocalInt", AI_DEBUG_UTILITY);

    ai_AddObjectRef(oTarget, oSource, AI_BIND_INT_SOURCE_OBJECT);
    ai_AddStringRef(oTarget, sTargetVariable, AI_BIND_INT_TARGET_VARIABLE);
    ai_AddStringRef(oTarget, sSourceVariable, AI_BIND_INT_SOURCE_VARIABLE);

    ai_DebugEnd();
}

void ai_BindLocalString(object oSource, string sSourceVariable, object oTarget, string sTargetVariable)
{
    ai_DebugStart("ai_BindLocalString", AI_DEBUG_UTILITY);

    ai_AddObjectRef(oTarget, oSource, AI_BIND_STRING_SOURCE_OBJECT);
    ai_AddStringRef(oTarget, sTargetVariable, AI_BIND_STRING_TARGET_VARIABLE);
    ai_AddStringRef(oTarget, sSourceVariable, AI_BIND_STRING_SOURCE_VARIABLE);

    ai_DebugEnd();
}

void ai_BindLocalLocation(object oSource, string sSourceVariable, object oTarget, string sTargetVariable)
{
    ai_DebugStart("ai_BindLocalLocation", AI_DEBUG_UTILITY);

    ai_AddObjectRef(oTarget, oSource, AI_BIND_LOCATION_SOURCE_OBJECT);
    ai_AddStringRef(oTarget, sTargetVariable, AI_BIND_LOCATION_TARGET_VARIABLE);
    ai_AddStringRef(oTarget, sSourceVariable, AI_BIND_LOCATION_SOURCE_VARIABLE);

    ai_DebugEnd();
}

/* Class Functions */

// Create the virtual class object.
object ai_RegisterClass(string sClassName, object oClassObject = OBJECT_INVALID)
{
    ai_DebugStart("ai_RegisterClass", AI_DEBUG_UTILITY);

    string sClassKey = _NewKey();
    object oVault = ai_GetMemeVault();

    if (oVault == OBJECT_INVALID)
        PrintString("<Assert>Error: MemeVault object not found. This is a critical error!</Assert>");

    if (oClassObject == OBJECT_INVALID)
        oClassObject = CopyItem(GetLocalObject(GetModule(), AI_MEME_OBJECT), oVault);
        //  oClassObject = CreateObject(OBJECT_TYPE_ITEM, AI_CLASS_RESREF, GetLocation(oVault));

    if (oClassObject == OBJECT_INVALID)
        ai_PrintString("Error: Failed to make a class object! ai_i_util: ai_RegisterClass()");

    // This is used so that its "class bias" can be applied to any memes that
    // it makes, or its decendents make. All decendents of this class will
    // copy this name down.
    SetLocalString(oClassObject, AI_ACTIVE_CLASS, sClassName);

    SetName(oClassObject, sClassName);
    DelayCommand(0.0, ai_ExecuteScript("ai_c_"+sClassName, AI_METHOD_INIT, OBJECT_SELF, oClassObject));
    ai_PrintString("Registering class, "+sClassName+".");
    SetLocalObject(oVault, AI_CLASS + sClassName, oClassObject);
    SetLocalObject(oVault, AI_CLASS_KEY_PREFIX + sClassKey, oClassObject);
    SetLocalString(oVault, AI_CLASS_KEY_PREFIX + sClassName, sClassKey);

    // Note: something very similar to this also occurs in ai_InstanceOf()
    //       but here we are just defining one class, in that function you'll
    //       see this key is combined with others and a new object is made
    //       that holds several keys.

    SetLocalString(oClassObject, AI_CLASS_KEY, sClassKey);

    ai_DebugEnd();
    return oClassObject;
}

void ai_CancelCommand(object oCommand)
{
    DestroyObject(oCommand);
}

// Meme Flag Functions
// These are simple flag functions with one exception for sequences - Some meme
// flags should not be set directly on a sequence by a user. The set flag
// function makes sure the right flag is set.

void ai_AddMemeFlag(object oObject, int nFlag)
{
    SetLocalFlag(oObject, AI_MEME_FLAGS, nFlag);
}

void ai_ClearMemeFlag(object oObject, int nFlag)
{
    int nType = GetLocalInt(oObject, AI_MEME_TYPE);

    // If this is a sequence, make sure we set up repeating properly
    if ((GetIsFlagSet(nType, AI_TYPE_SEQUENCE_REF)) && (GetIsFlagSet(nFlag, AI_MEME_REPEAT)))
    {
        nFlag = ClearFlag(nFlag, AI_MEME_REPEAT);
        nFlag = SetFlag(nFlag, AI_SEQUENCE_REPEAT);
    }

    ClearLocalFlag(oObject, AI_MEME_FLAGS, nFlag);
}

int ai_GetMemeFlag(object oObject, int nFlag)
{
    return GetIsLocalFlagSet(oObject, AI_MEME_FLAGS, nFlag);
}

void ai_SetMemeFlag(object oObject, int nFlag)
{
    SetLocalFlag(oObject, AI_MEME_FLAGS, nFlag);
}

// This is an advanced convienence function. It is used in conjunction with
// DelayCommand to safely destroy an int on a target. Before calling
// DelayCommand(fTime, _DestroyCachedInt(...)) an iterator variable needs to
// be incremented, such that it is starting at 1. In this way if a new timer
// is created to destroy the int, the old expiration timers stop working.
void _DestroyCachedInt(object oTarget, string sVarName, string sIteratorName)
{
    int nIterator = GetLocalInt(oTarget, sIteratorName);
    if (nIterator == 1)
    {
        DeleteLocalInt(oTarget, sVarName);
        DeleteLocalInt(oTarget, sIteratorName);
        return;
    }
    if (nIterator)
        SetLocalInt(oTarget, sIteratorName, nIterator - 1);
}


string _KeyCombine(string a, string b)
{
    string  x = "";
    int     alen = GetStringLength(a);
    int     blen = GetStringLength(b);
    int     i;

    if (alen < blen)
    {
        for (i = 0; i < alen; i += 3)
        {
            x = x + IntToString(((StringToInt(GetSubString(a, i, 3)) - 100) |
                                 (StringToInt(GetSubString(b, i, 3)) - 100)) + 100);
        }
        x = x + GetSubString(b, i, blen - i);
    }
    else
    {
        for (i = 0; i < blen; i += 3)
        {
            x = x + IntToString(((StringToInt(GetSubString(a, i, 3)) - 100) |
                                 (StringToInt(GetSubString(b, i, 3)) - 100)) + 100);
        }
        x = x + GetSubString(a, i, alen - i);
    }

    return x;
}

string _NewKey()
{
    object oVault = ai_GetMemeVault();
    string x       = "";
    int    nKey    = GetLocalInt(oVault, AI_KEY_COUNT);

    SetLocalInt(oVault, AI_KEY_COUNT, nKey + 1);

    while (nKey >= 8)
    {
        x = x + "100";
        nKey -= 8;
    }
    x = x + IntToString((1 << nKey) + 100);

    return x;
}

int ai_GetTime()
{
    return GetTimeSecond() +
           (GetTimeMinute()        * AI_TIME_ONE_MINUTE) +
           (GetTimeHour()          * AI_TIME_ONE_HOUR) +
           ((GetCalendarDay() - 1) * AI_TIME_ONE_DAY);
}

float ai_GetFloatTime()
{
    return IntToFloat(ai_GetTime())+(IntToFloat(GetTimeMillisecond())/1000);
}


// void main(){}
