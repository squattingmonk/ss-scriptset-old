/*
Filename:           ai_i_response
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 29, 2009
Summary:
Memetic AI include script. This file holds class functions commonly used
throughout the Memetic AI system.

These are the functions used to build response tables. These tables hold lists
of library functions that are used to solve problems. The core memetic toolkit
includes memetic objects which ask an NPC to solve recognized problems or
situations. At this time, this includes boredom, combat, and blocked doors. In
the future this may be expanded to the observation of enemies, friends, and acts
of lawlessness.

A nice use of this system is to have NPCs change their idle table according to a
schedule. The result is that NPCs will efficiently perform work behaviors
possibly interleved with common idle behaviors.

Response tables may be contained within class objects or on an NPC. When a
problem is attempted to be resolved a response on the NPC is tried, then on each
class. The order of the class instanciation reflects the trial order.

Refer to the documentation within this script for more information.

Note: This will produce is a table-driven response system that merges tables
across classes. Each class represents a behavior trait that might draw in
memetic objects or enhance their response tables with additional functions.
Generally these response functions create child memes to solve a problem or
react to a situation.

The tables are broken up into five bands. The start band is used to evaluate a
situation and switch tables in response to the situation at hand. All entries in
the table are executed and their return results are ignored. The next three
bands high, medium, and low contain responses to a problem. It is possible to
preserve where you left off in the band, so you can resume later. One of the
bands is chosen, each entry in the band is tried until one returns a valid
object. At this point the table's fifth band, end, runs. All of these functions
are executed. If any band function returns a valid object, the processing is
complete, otherwise the next class is selected and the process starts over.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_class"


// 1. Function Tables
//
// This script registers functions stored in memetic libraries. This script
// assumes you know how to add a function to a library. These tables hold the
// names of your registered funciton and the % chance is it tried organized into
// bands that represent a % chance the set of responses are tried. Classes are
// tied in order of the call to ai_InstanceOf.

// 2. Frequency Bands
//
// Response tables are broken up into five bands: start, high, medium, low, end.
// All the functions in the start and end bands always run if the table is being
// processed. The one of the middle bands is selected and each function is tried.
// When one returns a valid object, the band is complete. The NPC and all of its
// classes can each have a table which responds to a situation.
//
// These consts register the response to be run regardless of the band, before
// or after any other functions are executed. These are commonly used to
// evaluate the situation and change the table. If a first response changes the
// table, the high, medium, or low responses of the *new* table are used. If a
// response in the either band returns a valid object then no other class tables
// are run. If the first band returns a value then the middle bands are skipped.
//
// const string AI_RESPONSE_START = "AI_RTS_";
// const string AI_RESPONSE_END   = "AI_RTE_";
//
// These flags partition up the responses 60%, 30%, 10%. The table responses
// are immediately paired down to one of these bands before responding.
// So 60% of the time, the NPC will draw from the high probability band.
// That doesn't mean that a single response has a 60% chance of be choosen --
// just that 60% of the time the pool of responses is looked at, sequentially.
// If a response in this band returns a valid object then no other responses in
// this band is processed -- the ending responses are then processed.
// If a response in this band returns a valid object then no other responses in
// other class tables are evaluated. We assume the response is beind handled.
// If a response in this band changes the active response table, this table
// change will not be noticed until the next time the problem is resolved.
//
// const string AI_RESPONSE_HIGH   = "AI_RTH_";
// const string AI_RESPONSE_MEDIUM = "AI_RTM_";
// const string AI_RESPONSE_LOW    = "AI_RTL_";

// 3. Usage
//
// Generally, inside of a class _ini responses are added to tables and a table
// is assigned to handle a response. A meme will eventually cause a situation to
// be responded to. Each table defined on the NPC and all of its classes is
// processed. Generally, a response function in the table should create a child
// meme, where the parent is MEME_SELF - aka the meme that called ai_Respond().
// This gives the calling meme the opportunity to know if the child meme
// succeeded. It is also legal to directly call actions within the table.
// Unfortunately this does not allow the response meme to know if the attempted
// response was a success. The approach to implementing this varies if you are
// trying to solve a problem and want to search through your response table
// (like opening a door) or if you want to simply react (like in combat) at the
// start of your table, anew.

/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ---< ai_Respond >---
// ---< ai_i_response >---
// This activates the NPC's response tables that are bound to a specific
// situation. Each class can set its own preferred response table, and the
// tables can be changed at any time for a specific context. For example, if a
// meme calls ai_Respond() and the class tables decide to change the tables they
// use to respond to the situation, this is kept local to the meme. More than
// one meme responding to a situation will have their own local response context.
//
// This selects a probability band and activates each table in each class. It
// also activates the NPC's local response table, allowing each NPC to build a
// custom overriding personality trait. For example, if combat occurs, you can
// add a custom response to a single NPC by calling:
//
// Note: the 0% is ignored for AI_RESPONSE_START and AI_RESPONSE_END bands -- they always run.
// ai_AddResponse(OBJECT_SELF, "MyCombatTable", "MyFunction", 0, RESPONSE_START);
// ai_SetResponseTable(OBJECT_SELF, "Combat", "MyCombatTable", "");
//
// Now, whenever ai_Response("Combat") is called, MyFunction will be called first.
//
// If the NPC's response table doesn't respond, its class responses are processed.
// The order is dependent on the order in which the NPC becomes an instance of
// a class. The most recently added instance is executed last.
//
// Parameters:
// - sSitutation: this is the name of the table to execute.
// - oResponseArg: this is an argument (and object) that is passed to the
//   functions in the response table. This allows a situation to pass a object
//   to be acted upon. For example, a door might be passed or the last combat
//   target.
// - bResume: a flag to determine if the table should evaluate where it last
//   finished. The last band selected is remembered as well as which class table
//   was last processed. This is useful when you want to search through a
//   response table to solve problems. This is being used to solve problems like
//   door handling.
//
// This returns "" if no responses were choosen successfully. Otherwise it
// returns the name of a function that was tried. It's possible that more than
// one function executed during the start and end bands.
string ai_Respond(string sSituation, object oResponseArg=OBJECT_INVALID, int bResume=FALSE);

// ---< ai_SetActiveResponseTable >---
// ---< ai_i_response >---
// This defines the table that should be used to solve a specific problem. The
// problem name should be known in advance. This allows NPCs to prepare several
// response tables and switch them to change solution tactics.
//
// Parameters:
// - sSituation: this the name of the problem your table solves. This is what is
//   passed to ai_Respond.
// - sTable: this is the name of the table with the responses.
// - sClass: this is name of the class whose table is being changed. If you set
//   this to "" then you will be changing the NPC's default table overriding all
//   the classes. If you leave this as "*" it will detect the class that your
//   code context is working on behalf of. For example, if you are writing a
//   function in a response table that wants to switch the table, you may not
//   know which class your table belongs to -- the "*" will detect this
//   automatically.
// - oTarget: this is the object that the table is set on. If you leave this
//   invalid it will try and set the table change on the most local context,
//   probably the meme. It is possile to pass the NPC or NPC_SELF to set an
//   overriding response definition.
void ai_SetActiveResponseTable(string sSituation, string sTable, string sClass="*", object oTarget = OBJECT_INVALID);

// ---< ai_GetActiveResponseTable >---
// ---< ai_i_response >---
// Returns the currently active response table for a given situation. This does
// not take any class inheritance into account. It only returns local tables.
//
// Parameters:
// - sSitutation: this is the situation whose table you want.
// - sClass: this is the name of the class whose table you want. It is possible
//   to pass "" to look for the NPC's overriding response or leave the value as
//   "*" to find a class.
string ai_GetActiveResponseTable(string sSituation, string sClass="*", object oTarget = OBJECT_INVALID);

// ---< ai_ActivateResponseTable >---
// ---< ai_i_response >---
// Returns true if the table successfully executed a response function or if the
// final fucntion is executed. This is is not a success or fail result. It only
// signifies that a response has been chosen.
//
// When this called by ai_Respond, the table owner will be the class object.
// This allows the response function to call ai_SetResponseTable passing the
// class as the parameter.
string ai_ActivateResponseTable(object oTarget, string sTable, string sWhichBand, object oArgument=OBJECT_INVALID, int bResume=FALSE);

// ---< ai_DeleteResponseTable >---
// ---< ai_i_response >---
// Removes a response table. If it was the active table, there will be no local
// response table on oTarget, so you must call ai_SetResponseTable() to assign a
// new table to response to the situation.
void ai_DeleteResponseTable(object oTarget, string sTable);

// ---< ai_HasResponseTable >---
// ---< ai_i_response >---
// This checks to see if the object has a response table with the given name.
int ai_HasResponseTable(object oTarget, string sTable, string sWhichBand = "");

// ---< ai_AddResponse >---
// ---< ai_i_response >---
void ai_AddResponse(object oTarget, string sTable, string sFunction, int nPercent = 50, string sBand = AI_RESPONSE_MEDIUM);

// ---< ai_SetResponseChance >---
// ---< ai_i_response >---
void ai_SetResponseChance(object oTarget, string sTable, string sFunction, int nNewPercent, string sWhichBand);

// ---< ai_RemoveResponse >---
// ---< ai_i_response >---
void ai_RemoveResponse(object oTarget, string sTable, string sFunction, string sWhichBand);

/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

/*
    This is called within a class's _ini script when the class is first defining
    its reponse table. In this case, MEME_SELF is the class and there is no
    NPC_SELF. Or does this have to be called in the _go script, setting the
    active table appropriately? I assume that the shared data on the class
    must be on the class object -- which means that it must be defined in the
    _ini. In which case the call with sClass="*" gets the AI_ACTIVE_CLASS.
    This tells us the name. Now, the MEME_SELF (in this case the class) should
    have a ClassName/Situation string on it.

    This function may be called by a function in a response table. Setting the
    value on MEME_SELF puts the local table state on the actual meme which
    calls ai_Respond().
*/

void ai_SetActiveResponseTable(string sSituation, string sTable, string sClass="*", object oTarget = OBJECT_INVALID)
{
    if (sClass == "*") sClass = GetLocalString(MEME_SELF, AI_ACTIVE_CLASS);
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (!GetIsObjectValid(oTarget)) oTarget = NPC_SELF;
    if (!GetIsObjectValid(oTarget)) return;

    ai_DebugStart("ai_SetResponseTable", AI_DEBUG_TOOLKIT);

    ai_PrintString("Set response table for class: "+sClass+" situation: "+sSituation+" to respond with table: "+sTable);
    ai_SetLocalString(oTarget, AI_RESPONSE + sClass + "/" + sSituation, sTable);

    ai_DebugEnd();
}

/*
    This function has the responsibility of looking around to find the table.
    It's possible that the current MEME has it, or the NPC has its own default,
    or the class has the real default. If oTarget is invalid, the function has
    to start looking for the value...
*/
string ai_GetActiveResponseTable(string sSituation, string sClass="*", object oTarget = OBJECT_INVALID)
{
    ai_DebugStart("ai_GetResponseTable", AI_DEBUG_TOOLKIT);

    // sClass * is a request to look up the class ancestory
    if (sClass == "*") sClass = GetLocalString(MEME_SELF, AI_ACTIVE_CLASS);

    string sTable;
    string sTableName = AI_RESPONSE + sClass + "/" + sSituation;

    // Search for the right table
    if (oTarget == OBJECT_INVALID)
    {
        sTable = ai_GetLocalString(MEME_SELF, sTableName);
        if (sTable == "") sTable = ai_GetLocalString(NPC_SELF, sTableName);
        if (sTable == "") sTable = ai_GetLocalString(OBJECT_SELF, sTableName);
        if (sTable == "" && sClass != "") sTable = ai_GetLocalString(ai_GetClassObject(sClass), sTableName);
    }
    else
        sTable = ai_GetLocalString(oTarget, sTableName);

    ai_DebugEnd();
    return sTable;
}

/* Implementataion Notes

   Each class can define a response table. The table is composed of five
   bands: start, high, medium, low, end. The high, medium, and low bands
   have a matching probability entry. The start and end bands do not have
   probabilities. The are executed in order.

   AI_RTS_<tablename>  string list            (function)
   AI_RTH_<tablename>  string list, int list  (function, probability)
   AI_RTM_<tablename>  string list, int list  (function, probability)
   AI_RTL_<tablename>  string list, int list  (function, probability)
   AI_RTE_<tablename>  string list            (function)

   ai_Respond() is responsible for recording which table it's processing.
   This includes which band and which class (or the npc if it's just starting)
   so that it can resume by calling ai_ActivateTable() with AI_LAST_RESPONSE

   ai_GetActiveResponseTable is called by ai_Respond for each class or NPC that
   should respond to the situation. It gets the table to be activated. This
   information is stored on the MEME_SELF and can be changed by the functions
   to switch the activate table.
*/
string ai_Respond(string sSituation, object oArgument=OBJECT_INVALID, int bResume=FALSE)
{
    int i, nCount;
    object oClass, oVault;
    string sBand, sTable, sNewTable, sResult, sEnd, sClass;
    string sAncestor  = GetLocalString(MEME_SELF, AI_ACTIVE_CLASS);

    if (bResume == TRUE)
        sBand  = GetLocalString(MEME_SELF, AI_LAST_RESPONSE_BAND);

    if (sBand == "")
    {
        i = Random(100);
        if (i > 40) sBand = AI_RESPONSE_HIGH;
        else if (i > 10) sBand = AI_RESPONSE_MEDIUM;
        else sBand = AI_RESPONSE_LOW;

        if (bResume == TRUE)
            SetLocalString(MEME_SELF, AI_LAST_RESPONSE_BAND, sBand);
    }

    // Does this NPC react to this situation in his own special way, regardless of his class?
    sTable = ai_GetActiveResponseTable(sSituation, "");

    if (sTable != "")
    {
        // This table is not acting on behalf of any class, so active class
        // is cleared.
        SetLocalString(MEME_SELF, AI_ACTIVE_CLASS, "");
        sResult = ai_ActivateResponseTable(OBJECT_SELF, sTable, AI_RESPONSE_START, oArgument);

        // The start functions are allowed to change the table on us.
        sTable = ai_GetActiveResponseTable(sSituation, "");
        if (sResult == "") sResult = ai_ActivateResponseTable(OBJECT_SELF, sTable, sBand, oArgument, bResume);
        if (sResult == "") sResult = ai_ActivateResponseTable(OBJECT_SELF, sTable, AI_RESPONSE_END, oArgument);
    }

    // If the NPC didn't respond
    if (sResult == "")
    {
        oVault = ai_GetMemeVault();

        // Do each class band, in order
        nCount = ai_GetStringCount(NPC_SELF, AI_MEME_PARENTS);

        if (bResume == TRUE)
            i  = GetLocalInt(MEME_SELF, AI_LAST_RESPONSE_CLASS);

        for (i=0; i < nCount; i++)
        {
            sClass = ai_GetStringByIndex(NPC_SELF, i, AI_MEME_PARENTS);
            if (bResume == TRUE) SetLocalInt(MEME_SELF, AI_LAST_RESPONSE_CLASS, i);

            // The functions within the table are acting on behalf of this class.
            SetLocalString(MEME_SELF, AI_ACTIVE_CLASS, sClass);
            oClass = GetLocalObject(oVault, AI_CLASS + sClass);

            sResult = ai_ActivateResponseTable(oClass, sTable, AI_RESPONSE_START, oArgument);
            // The start functions are allowed to change the table on us.
            sTable = ai_GetActiveResponseTable(sSituation);
            if (sResult == "") sResult = ai_ActivateResponseTable(oClass, sTable, sBand, oArgument, bResume);
            if (sResult == "") sResult = ai_ActivateResponseTable(oClass, sTable, AI_RESPONSE_END, oArgument);
            if (sResult != "") break;
        }
    }
    else
        ai_PrintString("The NPC has stopped other classes from responding because of ("+sResult+") or ("+sEnd+").");

    // Restore this meme to its original owner class -- this allows class bias to be applied correctly.
    SetLocalString(MEME_SELF, AI_ACTIVE_CLASS, sAncestor);

    return sResult;
}


string ai_ActivateResponseTable(object oTarget, string sTable, string sWhichBand, object oArgument=OBJECT_INVALID, int bResume=FALSE)
{
    string sTableName = sWhichBand+sTable;
    if (ai_GetStringCount(oTarget, sTableName) == 0)
        return ""; // Notice if you have nothing in your band your start/end aren't run

    ai_DebugStart("ai_ActivateResponseTable band='"+sWhichBand+"'", AI_DEBUG_COREAI);

    int i, nChance, nChanceResult;
    int nCount = ai_GetStringCount(oTarget, sTableName);
    string sResponse;

    if (bResume) i = GetLocalInt(MEME_SELF, AI_LAST_RESPONSE);

    for (i; i < nCount; i++)
    {
        sResponse = ai_GetStringByIndex(oTarget, i, sTableName);
        if (sWhichBand != AI_RESPONSE_START && sWhichBand != AI_RESPONSE_END)
        {
            nChance       = ai_GetIntByIndex(oTarget, i, sTableName);
            nChanceResult = Random(100);
        }
        else
        {
            nChance = 1;
            nChanceResult = 0;
        }
        ai_PrintString(IntToString(nChanceResult)+" &lt; "+IntToString(nChance)+" --- "+sResponse);

        ai_PrintString("Attempting reponse: "+sResponse);
        if ((nChanceResult < nChance) && GetIsObjectValid(ai_CallFunction(sResponse, oArgument)))
        {
            // We should remember where we left off
            if (sWhichBand != AI_RESPONSE_START && sWhichBand != AI_RESPONSE_END)
                SetLocalInt(MEME_SELF, AI_LAST_RESPONSE, i+1);
            else SetLocalInt(MEME_SELF, AI_LAST_RESPONSE, 0);

            // Stop looking
            break;
        }
        else
            ai_PrintString("Response skipped.");
    }

    ai_DebugEnd();
    SetLocalInt(MEME_SELF, AI_LAST_RESPONSE, 0);
    return sResponse;
}

void ai_DeleteResponseTable(object oTarget, string sTable)
{
    ai_DeleteStringRefs(oTarget, AI_RESPONSE_START+sTable);
    ai_DeleteStringRefs(oTarget, AI_RESPONSE_END+sTable);

    ai_DeleteStringRefs(oTarget, AI_RESPONSE_HIGH+sTable);
    ai_DeleteIntRefs(oTarget,    AI_RESPONSE_HIGH+sTable);

    ai_DeleteStringRefs(oTarget, AI_RESPONSE_MEDIUM+sTable);
    ai_DeleteIntRefs(oTarget,    AI_RESPONSE_MEDIUM+sTable);

    ai_DeleteStringRefs(oTarget, AI_RESPONSE_LOW+sTable);
    ai_DeleteIntRefs(oTarget,    AI_RESPONSE_LOW+sTable);
}

int ai_HasResponseTable(object oTarget, string sTable, string sWhichBand = "")
{
    if (sWhichBand != "")
        return ai_GetStringCount(oTarget, sWhichBand+sTable);

    if (ai_GetStringCount(oTarget, AI_RESPONSE_START+sTable)  > 0) return 1;
    if (ai_GetStringCount(oTarget, AI_RESPONSE_END+sTable)    > 0) return 1;
    if (ai_GetStringCount(oTarget, AI_RESPONSE_HIGH+sTable)   > 0) return 1;
    if (ai_GetStringCount(oTarget, AI_RESPONSE_MEDIUM+sTable) > 0) return 1;
    if (ai_GetStringCount(oTarget, AI_RESPONSE_LOW+sTable)    > 0) return 1;

    return 0;
}

// Our list API does not preserve order when you remove them, so we will just
// blank the entries. This means that if constantly add and remove responses
// you are *leaking* memory. This will be the case until the MeRemove* functions
// are updated to pack the array after removal.
void ai_RemoveResponse(object oTarget, string sTable, string sFunction, string sWhichBand)
{
    int nIndex = ai_FindStringRef(oTarget, sWhichBand+sTable, sTable);
    ai_SetStringByIndex(oTarget, nIndex, "", sWhichBand+sTable);

    if (sWhichBand != AI_RESPONSE_START && sWhichBand != AI_RESPONSE_END)
        ai_SetIntByIndex(oTarget, nIndex, 0, sWhichBand+sTable);
}

// This will not move a function out of a band. It only adjusts the function's
// percentage. To move out of a band you must do an add and remove.
void ai_SetResponseChance(object oTarget, string sTable, string sFunction, int nNewPercent, string sWhichBand)
{
    int nIndex = ai_FindStringRef(oTarget, sWhichBand+sTable, sTable);
    if (nIndex != -1)
        ai_SetIntByIndex(oTarget, nIndex, nNewPercent, sWhichBand+sTable);
}

void ai_AddResponse(object oTarget, string sTable, string sFunction, int nPercent=50, string sBand=AI_RESPONSE_MEDIUM)
{
    ai_AddStringRef(oTarget, sFunction, sBand+sTable);
    if (sBand != AI_RESPONSE_START && sBand != AI_RESPONSE_END)
        ai_AddIntRef(oTarget, nPercent, sBand+sTable);
}


// To be done at a later date.
//void ai_MoveResponseUp(object oTarget, string sTable, string sFunction);
//void ai_MoveResponseDown(object oTarget, string sTable, string sFunction);


// void main(){}
