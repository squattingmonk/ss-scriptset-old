/*
Filename:           ai_i_poi
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jul. 27, 2009
Summary:
Memetic AI include script. This file holds PoI (dynamic trigger) functions
commonly used throughout the Memetic AI system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_class"

/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ----- Points of Interest Emitters (Dynamic Tigger Areas) --------------------

// ---< ai_DefineEmitter >---
// ---< ai_i_poi >---
// Define a dynamic trigger area, to be used by points of interest (locations
// and creatures). This does not create any objects; it only registers a
// datastructure to be used, later, by the ai_AddEmitter*() functions. Think of
// this function as defining a named template.
//
// [Note: Anywhere you see Point of Interest (PoI) just assume I mean emitter.
// The difference shouldn't concern you at this point in time.]
//
// Parameters:
// - sName: This is a unique name for these settings. If you define another
//   emitter with the same name, you will overwrite these values. There is no
//   way to delete an emitter definition at this time.
// - sResRef: The resref of the dialog to present to the user. If empty, no
//   dialog is created.
// - sTestFunction: This is the name of a Library Function (for more info, see
//   ai_LibraryImplements()). The function receives one argument - the player or
//   NPC that entered the area. The function decides if this creature should
//   receive the PoI notification (sEnterText, sResRef, nSignal, etc.). If the
//   function returns OBJECT_INVALID, the creature is not notified. Anything
//   other return result is considered TRUE. This is a filter function, several
//   samples filters can be found in lib_filter. FLAG: where is that file? - SM
// - sActivationFunction: This is the name of a Library Function (for more info,
//   see ai_LibraryImplements()). The argument of the function is the entering
//   creature. This will only be called if the creature has passed the sFilter
//   check and is within the emitter area.
// - sExitFunction: This is the name of a Library Function (for more info, see
//   ai_LibraryImplements()). The argument of the function is the exiting
//   creature. This will only be called if the creature has passed the sFilter
//   check and is within the emitter area.
// - sEnterText: A string which will appear over the head of the player and in
//   their log. This does nothing to NPCs which enter into the area.
// - sExitText: The opposite of enter text - shown when leaving the area.
// - nFlags: This controls who will receive the PoI information. These can be
//   masked together. For example, all non-npcs would be:
//   ( POI_EMIT_TO_PC | POI_EMIT_TO_DM )
//   Possible values:
//   - POI_EMIT_TO_PC  - Players
//   - POI_EMIT_TO_NPC - Creatures
//   - POI_EMIT_TO_DM  - Dungeon Masters
// - fDistance: The size of the PoI area. It is highly recommended that you try
//   and only use 10m PoI's. Otherwise, the area will poll - equivalent to a
//   heartbeat script. This will take up CPU time, tracking the creature after
//   it comes within 10m. Unfortunately you cannot have a PoI that is greater
//   than 10m. FLAG: How can we fix this? - SM
// - fCacheTest: As a creature enters the PoI, it may be tested with fFilter.
//   The result of this may be cached. This defines the length of time, in
//   seconds,  to cache this value.
//   Possible values:
//   - 1. If the value is negative (-1): the value is permenantly cached.
//   - 2. If the value is zero (0): the value is never stored. [DEFAULT]
//   - 3. If the value is positive (30): this is the number of seconds before
//        the creature will be retested.
// - fCacheNotify: As the creature enters the PoI, it may be notified via a
//   dialog or floaty text. According to this value, the emitter can remember
//   when the creature is last notified:
//   Possible values:
//   - 1. If the value is negative (-1): the creature is only ever notified once.
//   - 2. If the value is zero (0): the creature will always be notified. [DEFAULT]
//   - 3. If the value is positive (30): this is number of seconds before they
//        are notified again.
// FLAG: What is sFilter? - SM
void ai_DefineEmitter(string sName, string sTestFunction = "", string sActivationFunction = "", string sExitFunction = "",string sResRef = "", string sEnterText = "", string sExitText = "", int nFlags = POI_EMIT_TO_PC, float fDistance = POI_SMALL, int fCacheTest = 0, int fCacheNotify = 0);

// ---< ai_DefineEmitterMessage >---
// ---< ai_i_poi >---
// Cause the emitter to send a message to the NPC that enters and exits the
// dynamic trigger area.
// Parameters:
// - sName: The sName should match the name of a previously defined emitter.
// - stEnterMsg: A message defining the message name, channel and data.
// - stExitMsg: A message defining the message name, channel and data.
void ai_DefineEmitterMessage(string sName, struct message stEnterMsg, struct message stExitMsg);

// ---< ai_AddEmitterToCreature >---
// ---< ai_i_poi >---
// Attach a dynamic trigger area, previously defined by ai_DefineEmitter(), to a
// creature. (It is not possible to attach an emitter to an object, only
// creatures and locations. If you want to attach one to a placeable, attach it
// to the placeable's location instead.)
void ai_AddEmitterToCreature(object oCreature, string sName); // You can attach multiple emitters to a creature.

// ---< ai_AddEmitterToLocation >---
// ---< ai_i_poi >---
// Attach a dynamic trigger area, previously defined by ai_DefineEmitter(), to a
// location. (It is not possible to attach an emitter to an object, only
// creatures and locations. If you want to attach one to a placeable, attach it
// to the placeable's location instead.) This returns an object that represents
// the emitter. Use this object for all other functions which want to start or
// stop an emitter.
object ai_AddEmitterToLocation(location lLocation, string sName); // Returns an object representing the emitter effect.

// ---< ai_RemoveEmitter >---
// ---< ai_i_poi >---
// Removes a dynamic trigger area from a creature, given the emitter name as
// defined by ai_DefineEmitter().
// Parameters:
// - oTarget: The creature which is emitting, or the object returned from
//   ai_AddEmitterToLocation.
// - sName: The name of the specific emitter. Remember, a creature or emitter
//   object at a location may hold multiple emitters. If none is provided, it
//   will clean up all emitter data. It will also destroy the object created by
//   ai_AddEmitterToLocation. The creature's AI_EMITTER local variable will be
//   set to OBJECT_INVALID.
void ai_RemoveEmitter(object oTarget, string sName = ""); // No name, removes all of them.

// ---< ai_PauseEmitter >---
// ---< ai_i_poi >---
// Causes the named emitter to stop notifying creatures, although it will still
// check to see if they pass the filter test and cache the result.
// Parameters:
// - oTarget: The creature which is emitting, or the object returned from
//   ai_AddEmitterToLocation.
// - sName: The name of the specific emitter. Remember, a creature or emitter
//   object at a location may hold multiple emitters. If none is provided all
//   will be paused, automatically. In this case, resuming them automatically
//   will NOT work. You must call ai_ResumeEmitter for each emitter.
void ai_PauseEmitter(object oTarget, string sName = "");

// ---< ai_ResumeEmitter >---
// ---< ai_i_poi >---
// Causes a paused named emitter to resume. If anyone is in the vicinity, they
// are processed, like normal.
// Parameters:
// - oTarget: The creature which is emitting, or the object returned from
//   ai_AddEmitterToLocation.
// - sName: The name of the specific emitter. Remember, a creature or emitter
//   object at a location may hold multiple emitters. If they were all paused
//   automatically, you must resume each one by name.
void ai_ResumeEmitter(object oTarget, string sName);

// ---< ai_AddEmitterByTag >---
// ---< ai_i_poi >---
// This function will find every object in your module that has a given tag and
// attach an emitter to it. It is generally called once when your module is
// starting up. Before calling this function you will need to call
// ai_DefineEmitter() for each emitter.
//
// This function automates the process of setting up PoI emitters. For example,
// if you wanted to all of your NPCs to notice lampposts, you could attach
// emitters to all them in your game by calling:
//    ai_DefineEmitter("notice-lamp", "", "", "", "", "", "", AI_EMIT_TO_PC, AI_POI_LARGE, 0, 0);
//    ai_DefineEmitterMsg("notice-lamp", msg1, msg2);
//    ai_AddEmitterByTag("lamppost", "notice-lamp");
// Assuming that you have created messages msg1 and msg2, this will send an NPC
// a message msg1 when they walk within 10m of any object with the lamppost tag.
void ai_AddEmitterByTag(string sTagName, string sEmitter);

// -------- PoI Binding Utilities ----------------------------------------------

// ---< ai_InitializeEmitters >---
// ---< ai_i_poi >---
// Automatically loads emitters on objects as defined in ai_c_main.
void ai_InitializeEmitters();


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

// ----- PoI Emitter Functions -------------------------------------------------
// Used to automate the process of defining dynamic trigger areas that start
// conversions or emit signals.

void _CreatePoIAtLocation(location lLocation, string sName)
{
    ai_DebugStart("_CreatePoIAtLocation", AI_DEBUG_UTILITY);

    float fDistance = GetLocalFloat(GetModule(), POI_EMITTER_PREFIX + sName + POI_EMITTER_DISTANCE);
    int   aoeID;

    if (fDistance <= POI_SMALL) aoeID = POI_AOE_SMALL;
    else                        aoeID = POI_AOE_LARGE;

    // PoI stands for Point of Interest, in case you missed that somewhere...
    effect ePoI = EffectAreaOfEffect(aoeID, "ai_poienter", "****", "ai_poiexit"); // Do NOT call ai_poihb here -- I call it manually to control the polling.
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, ePoI, lLocation);

    // We have to do some odd things to keep access to this particular AoE
    // This will be used when you want to remove the effect
    object oAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lLocation);
    SetLocalObject(OBJECT_SELF, POI_AOE, oAoE);

    ai_DebugEnd();
}

void _CreatePoI(object oTarget, string sName)
{
    ai_DebugStart("CreatingPoI", AI_DEBUG_UTILITY);

    float fDistance = GetLocalFloat(GetModule(), POI_EMITTER_PREFIX + sName + POI_EMITTER_DISTANCE);
    int   aoeID;

    if (fDistance <= POI_SMALL) aoeID = POI_AOE_SMALL;
    else                        aoeID = POI_AOE_LARGE;

    // PoI stands for Point of Interest, in case you missed that somewhere...
    effect ePoI = EffectAreaOfEffect(aoeID, "ai_poienter", "****", "ai_poiexit");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoI, oTarget);

    // We have to do some odd things to keep access to this particular AoE
    // This will be used when you want to remove the effect
    object oAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, GetLocation(oTarget));
    SetLocalObject(OBJECT_SELF, POI_AOE, oAoE);

    ai_DebugEnd();
}


void ai_AddEmitterToCreature(object oCreature, string sName) // You can attach multiple emitters to a creature.
{
    ai_DebugStart("ai_AddEmitterToCreature", AI_DEBUG_UTILITY);

    if (GetObjectType(oCreature) != OBJECT_TYPE_CREATURE)
    {
        ai_PrintString("ERROR: ai_AddEmitterToCreature called on non-creature.");
        ai_DebugEnd();
        return;
    }

    // We must have the emitter object create the PoI.
    // The script will call GetAreaOfEffectCreator() to get this object.
    // It will hold the list of active emitters.
    // Yes, this is actually a hack because I cannot get the object an effect is
    // tied to via the effect object.
    object oEmitter = GetLocalObject(oCreature, POI_EMITTER);

    if (!GetIsObjectValid(oEmitter))
    {
        ai_PrintString("Creating proxy emitter object.");
        oEmitter = CreateObject(OBJECT_TYPE_PLACEABLE, POI_RESREF, GetLocation(oCreature));

        if (!GetIsObjectValid(oEmitter))
            ai_PrintString("Emitter object not created.");

        SetLocalObject(oCreature, POI_EMITTER, oEmitter);  // Point to the emitter source
        SetLocalObject(oEmitter,  POI_TARGET,  oCreature); // Point from the source to the actual emitting object
        SetLocalObject(oEmitter,  POI_EMITTER, oEmitter);  // Circular - you can always get POI_EMITTER to get the emitter
    }

    // New we store the PoI name and make sure the emitter starts the AoE, if necessary
    ai_AddStringRef(oEmitter, sName, POI_EMITTER);
    ai_PrintString("There are "+IntToString(ai_GetStringCount(oEmitter, POI_EMITTER))+" PoI emitters on this object.");

    if (ai_GetStringCount(oEmitter, POI_EMITTER) == 1)
    {
        ai_PrintString("Creating initial AreaOfEffect.");
        AssignCommand(oEmitter, _CreatePoI(oCreature, sName));
    }
    ai_DebugEnd();
}

object ai_GetEmitterAtLocation(location lLocation)
{
    ai_DebugStart("ai_GetEmitterAtLocation", AI_DEBUG_UTILITY);
    object oResult, oEmitter = GetFirstObjectInShape(SHAPE_CUBE, 1.0, lLocation, FALSE, OBJECT_TYPE_PLACEABLE);

    while (oEmitter != OBJECT_INVALID)
    {
        if (ai_GetStringCount(oEmitter, POI_EMITTER))
        {
            oResult = oEmitter;
            oEmitter = OBJECT_INVALID;
        }
        else oEmitter = GetNextObjectInShape(SHAPE_CUBE, 1.0, lLocation, FALSE, OBJECT_TYPE_PLACEABLE);
    }

    ai_DebugEnd();
    return oResult;
}

object ai_AddEmitterToLocation(location lLocation, string sName)
{
    ai_DebugStart("ai_AddEmitterToLocation emitter-name='"+sName+"'", AI_DEBUG_UTILITY);

    int nCount;
    object oEmitter, oCursor = GetFirstObjectInShape(SHAPE_CUBE, 1.0, lLocation, FALSE, OBJECT_TYPE_PLACEABLE);

    if (oCursor == OBJECT_INVALID)
        ai_PrintString("I haven't found any placeables at this location...");

    while (oCursor != OBJECT_INVALID)
    {
        nCount = ai_GetStringCount(oCursor, POI_EMITTER);
        ai_PrintString("I have found an object ("+_GetName(oCursor)+") with "+IntToString(nCount)+" emitters.");

        if (nCount)
        {
            oEmitter = oCursor;
            oCursor = OBJECT_INVALID;
        }
        else oCursor = GetNextObjectInShape(SHAPE_CUBE, 1.0, lLocation, FALSE, OBJECT_TYPE_PLACEABLE);
    }

    if (oEmitter == OBJECT_INVALID)
    {
        ai_PrintString("Creating initial emitter placeholder.");
        oEmitter = CreateObject(OBJECT_TYPE_PLACEABLE, POI_RESREF, lLocation);
        SetLocalObject(oEmitter, POI_EMITTER, oEmitter); // Circular reference intended
        SetLocalObject(oEmitter, POI_TARGET, oEmitter);  // Circular reference intended

        if (!GetIsObjectValid(oEmitter))
            ai_PrintString("Error: failed to create emitter placeholder.");

        DelayCommand(0.0, AssignCommand(oEmitter, _CreatePoIAtLocation(lLocation, sName) ));
    }

    ai_PrintString("Adding the emitter: "+sName+". ("+_GetName(oEmitter)+")");
    ai_AddStringRef(oEmitter, sName, POI_EMITTER);
    ai_PrintString("There are now "+IntToString(ai_GetStringCount(oEmitter, POI_EMITTER))+" emitters.");

    ai_DebugEnd();
    return oEmitter; // This is returned so that it can be easily destroyed later.
}

void ai_DefineEmitter(string sName, string sTestFunc = "", string sActivateFunction = "", string sExitFunction = "",
                     string sResRef = "", string sEnterText = "", string sExitText = "",
                     int nFlags = POI_EMIT_TO_PC, float fDistance = POI_SMALL /* 5.0 */,
                     int fCacheTest = 0, int fCacheNotify = 0)
{
    ai_DebugStart("ai_DefineEmitter emitter-name='"+sName+"'", AI_DEBUG_UTILITY);

    object oModule = GetModule();
    // Just register the unique name for access, later
    // Think of the shared namespace as optimization - if six creatures register
    // "odor", it will just get set to the last creature's definition.
    SetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_RESREF,            sResRef);
    SetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_ENTER_TEXT,        sEnterText);
    SetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_EXIT_TEXT,         sExitText);
    SetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_ENTER_FILTER,      sTestFunc);
    SetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_ACTIVATE_FUNCTION, sActivateFunction);
    SetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_EXIT_FUNCTION,     sExitFunction);
    SetLocalInt   (oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_FLAGS,             nFlags);
    SetLocalFloat (oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_DISTANCE,          fDistance);
    SetLocalInt   (oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_TEST_CACHE,        fCacheTest);
    SetLocalInt   (oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_NOTIFY_CACHE,      fCacheNotify);

    ai_DebugEnd();
}

void ai_DefineEmitterMessage(string sName, struct message stEnterMsg, struct message stExitMsg)
{
    ai_SetLocalMessage(GetModule(), POI_EMITTER_IN  + sName, stEnterMsg);
    ai_SetLocalMessage(GetModule(), POI_EMITTER_OUT + sName, stExitMsg);
}

void ai_RemoveEmitter(object oObject, string sName)
{
    ai_DebugStart("ai_RemoveEmitter name='"+sName+"'", AI_DEBUG_UTILITY);

    int i;
    string sID;
    // First, find the true emitter
    object oEmitter = GetLocalObject(oObject,  POI_EMITTER);
    object oTarget  = GetLocalObject(oEmitter, POI_TARGET);
    object oAOE;

    if (!GetIsObjectValid(oEmitter))
    {
        ai_PrintString("This is not an emitter or an emitting creature.");
        ai_DebugEnd();
        return;
    }

    if (sName != "")
    {
        ai_PrintString("There are currently "+IntToString(ai_GetStringCount(oEmitter, sName))+" emitters.");
        ai_PrintString("Removing emitter...");
        ai_RemoveStringRef(oEmitter, sName,  POI_EMITTER);
    }

    ai_PrintString("There are now "+IntToString(ai_GetStringCount(oEmitter, POI_EMITTER))+" emitters left.");

    // If possible, just destroy the emitter rather than doing garbage collection
    if ((sName == "") || (ai_GetStringCount(oEmitter, POI_EMITTER) == 0))
    {
        // First find the AOE
        oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oTarget);

        ai_PrintString("Removing entire emitter.");
        if (!GetIsObjectValid(oAOE))
            ai_PrintString("Error: Cannot find area of effect to destroy.");
        else
            ai_PrintString("I have the AOE to destroy ("+GetTag(oAOE)+")");

        DestroyObject(oAOE);
        if (oTarget != OBJECT_INVALID)
            SetLocalObject(oTarget, POI_EMITTER, OBJECT_INVALID);
        DestroyObject(oEmitter);
    }
    // Otherwise clean up the cached data the emitter collected
    else
    {
        ai_PrintString("Cleaning up any potential cached information.");

        // We will only clean up what we currently know about. I leave it up to
        // your expiration timers to do the rest. If the user didn't set a
        // duration -- it's their loss in memory. I removed alternative attempts
        // at garbage collection. Ultimately they were far more costly to the
        // average case.
        for (i = ai_GetObjectCount(oEmitter, sName) - 1; i >= 0; i--)
        {
            sID = ObjectToString(ai_GetObjectByIndex(oEmitter, i, sName));

            // This value is cached to represent that the creature passed or
            // failed the filter check
            DeleteLocalInt(oEmitter, "POI_"+sName+"_TEST_CACHE_"+sID);

            // This value is cached to represent that the creature has been
            // emitted to -- and shouldn't be again
            DeleteLocalInt(oEmitter, "POI_"+sName+"_NOTIFY_CACHE_"+sID);

            // These values are used by pending delay commands to know if they
            // should destroy the previous cache values. If a destruction
            // function runs and the value is 1 it will destroy the int; if 0 it
            // does nothing; if > 0 it decrements.
            DeleteLocalInt(oEmitter, "POI_"+sName+"_NOTIFY_CACHE_ITERATOR_"+sID);
            DeleteLocalInt(oEmitter, "POI_"+sName+"_TEST_CACHE_ITERATOR_"+sID);
        }
        ai_DeleteObjectRefs(oEmitter, sName);
    }

    ai_DebugEnd();
}

void ai_PauseEmitter(object oTarget, string sName = "")
{
    ai_DebugStart("ai_PauseEmitter", AI_DEBUG_UTILITY);

    // First, find the true emitter
    object oEmitter = GetLocalObject(oTarget, POI_EMITTER);

    if (!GetIsObjectValid(oEmitter))
    {
        ai_PrintString("This is not an emitter, or an emitting creature.");
        ai_DebugEnd();
        return;
    }

    SetLocalInt(oEmitter, POI_EMITTER_PAUSED + sName, TRUE);
    ai_DebugEnd();
}

void ai_ResumeEmitter(object oTarget, string sName)
{
    ai_DebugStart("ai_ResumeEmitter", AI_DEBUG_UTILITY);

    // First, find the true emitter
    object oEmitter = GetLocalObject(oTarget, POI_EMITTER);
    if (!GetIsObjectValid(oEmitter))
    {
        ai_PrintString("This is not an emitter, or an emitting creature.");
        ai_DebugEnd();
        return;
    }

    SetLocalInt(oEmitter, POI_EMITTER_PAUSED + sName, FALSE);
    DelayCommand(0.1, ExecuteScript("ai_poihb", oEmitter));

    ai_DebugEnd();
}

// -------- PoI Binding Utilities ----------------------------------------------

// _AddEmitterToTag
// This is an internal function that breaks up the assigning of emitters to
// objects in stages, to avoid TMI. It calls itself for each chunk; it is
// used by ai_AddEmitterByTag.
void _AddEmitterToTag(string sTag, string sEmitter, int Nth)
{
    ai_DebugStart("_AddEmitterToTag sTag='"+sTag+"' sEmitter='"+sEmitter+"' Nth='"+IntToString(Nth)+"'");

    location l;
    object oTarget = GetObjectByTag(sTag, Nth);
    int i = Nth + 20; // Adds the emitter to 20 objects

    for (i; i > Nth && oTarget != OBJECT_INVALID; Nth++)
    {
        ai_ExecuteScript("ai_poi_" + sEmitter, AI_METHOD_GO, oTarget);
        oTarget = GetObjectByTag(sTag, Nth + 1);
    }

    if (oTarget != OBJECT_INVALID)
        DelayCommand(0.0, _AddEmitterToTag(sTag, sEmitter, Nth + 1));

    ai_DebugEnd();
}

void ai_AddEmitterByTag(string sTagName, string sEmitter)
{
    ai_PrintString("Adding emitter " + sEmitter + " to tag " + sTagName);
    DelayCommand(0.0, _AddEmitterToTag(sTagName, sEmitter, 0));
}

void ai_InitializeEmitters()
{
    ai_DebugStart("ai_InitializeEmitters", AI_DEBUG_TOOLKIT);

    object oModule = OBJECT_SELF;
    string sTag, sEmitter;
    int    nCount;

    // Build a list of the tags and emitters to initialize
    ai_ExplodeList(oModule, AI_POI_TAGS,     POI_TAGS);
    ai_ExplodeList(oModule, AI_POI_EMITTERS, POI_EMITTERS);

    // Register all the emitters and call their init functions
    for (nCount = ai_GetStringCount(oModule, POI_EMITTERS); nCount > 0; nCount--)
    {
        sEmitter = ai_GetStringByIndex(oModule, nCount - 1, POI_EMITTERS);

        if (!GetLocalInt(oModule, POI_EMITTER_PREFIX + sEmitter))
        {
            ai_ExecuteScript("ai_poi_" + sEmitter, AI_METHOD_INIT);
            SetLocalInt(oModule, POI_EMITTER_PREFIX + sEmitter, TRUE);
        }
    }

    // Now loop through the tags and place the emitters on them
    for (nCount = ai_GetStringCount(oModule, POI_TAGS); nCount > 0; nCount--)
    {
        sTag     = ai_GetStringByIndex(oModule, nCount - 1, POI_TAGS);
        sEmitter = ai_GetStringByIndex(oModule, nCount - 1, POI_EMITTERS);

        ai_AddEmitterByTag(sTag, sEmitter);
    }

    ai_DebugEnd();
}
