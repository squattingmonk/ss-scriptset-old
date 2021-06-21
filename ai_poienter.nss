/*
Filename:           ai_poienter
System:             Memetic AI (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       July 28, 2009
Summary:
Point of Interest Emitter Enter event hook-in script for the Memetic AI system.
Handles generators for each of the creature events. This is called when a
creature walks close to a location or creature that has an area of effect
emitter created by calls to ai_DefineEmitter() and ai_AddEmitterTo*(). It
handles notifying the incoming creature of the PoI.

You should never need to use this. Ever. It is handled internally.

This script is called when a creature enters into the general vicinity of a
creature or location that is emitting PoI information. This script determines if
the creature is a viable recepter of the information then records this value
and causes the ai_poihb to run. This evaluates the players to see if they are
within the PoI emitter area and notifies them accordingly.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "ai_i_main"


void _DestroyCachedInt(object oEmitter, string sVarName, string sIteratorName);

void main()
{
    object oEmitter  = GetAreaOfEffectCreator();
    object oCreature = GetEnteringObject();

    // If the PoI is created on a creature, it will trigger the AoE; we can
    // ignore this creature.
    if (oCreature == GetLocalObject(oEmitter, POI_TARGET))
        return;

    ai_DebugStart("EnterEmitterArea", AI_DEBUG_TOOLKIT);

    ai_PrintString("Entering object is "+_GetName(oCreature)+".");

    struct message stMsg;
    object oModule = GetModule();
    string sFunction, sName, sID = ObjectToString(oCreature);
    int    i, bModified, bSuccess, nFlags, nMask, nSuccessCache, nSuccess = POI_FAILED;

    // These are used to cache the players value and allow them to expire
    // after some fixed period of time.
    int    testCacheDuration;
    int    gcIterator;
    string sVarName;
    string sIteratorName;

    // Iterate over the emitter chain on the emitter object. This is a list of
    // emitter definition names which have been defined on the module, describing
    // the rules for the emitter -- such as what it emits and to whom.
    for (i = ai_GetStringCount(oEmitter, POI_EMITTER) - 1; i >= 0; i--)
    {
        sName = ai_GetStringByIndex(oEmitter, i, POI_EMITTER);

        ai_PrintString("Processing '"+sName+"' emitter.");

        // There are three flags which say if this PoI is restricted to PCs, DMs,
        // or NPCs. If this creature does not match at least one of these flags,
        // it can discount this PoI immediately.
        nFlags = GetLocalInt(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_FLAGS);
        if (GetIsPC(oCreature))
        {
            ai_PrintString("PC Entered");
            nMask = POI_EMIT_TO_PC;
        }
        else if (GetIsDM(oCreature))
        {
            ai_PrintString("DM Entered");
            nMask = POI_EMIT_TO_DM;
        }
        else
        {
            ai_PrintString("NPC Entered");
            nMask = POI_EMIT_TO_NPC;
        }

        if (!(nMask & nFlags)) break;

        // This value records objects that have been evaluated and processed.
        // Just becuase they have entered into the area doesn't mean that they
        // should have a chance to observe the information. Sometimes they get
        // one shot and that's it. If that's the case, they will have a non-zero
        // value on the emitter, like POI_ODOR_TESTCACHE_0x02332.
        sVarName = "POI_"+sName+"_TEST_CACHE_"+sID;
        nSuccessCache = GetLocalInt(oEmitter, sVarName);
        if (nSuccessCache == 0)
        {
            ai_PrintString("I don't remember checking if this creature can see this PoI.");

            sFunction = GetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_ENTER_FILTER);
            ai_PrintString("Test function is named: " + sFunction);

            // If this function succeeds, this person can perceive the PoI.
            if (sFunction == "")
                bSuccess = TRUE;
            else if (ai_CallFunction(sFunction, oCreature, oEmitter) != OBJECT_INVALID)
                bSuccess = TRUE;
            else
                bSuccess = FALSE;

            if (bSuccess)
            {
                // Now add them to a list of people to be notified via ai_poihb
                ai_AddObjectRef(oEmitter, oCreature, sName);
                bModified = TRUE;
                nSuccess  = POI_PASSED;
            }
            else
                nSuccess = POI_FAILED;

            // ** START CACHE **
            // Depending on the flags of this emitter, we may need to record
            // that this creature attempted - but failed - to notice the PoI.
            testCacheDuration = GetLocalInt(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_TEST_CACHE);
            ai_PrintString("This has a cache duration of "+IntToString(testCacheDuration)+" seconds.");

            // If it's zero, we never record the value, meanining we always
            // retest them. (For example, "did you solve the quest yet?" The
            // results are not assumed to be deterministic.)
            if (testCacheDuration != 0)
            {
                ai_PrintString("Caching the success value: "+IntToString(nSuccess));
                SetLocalInt(oEmitter, sVarName, nSuccess);
            }

            // If it's positive, we will destroy the value that may have been
            // recorded. We use a rather contrived process to ensure that if the
            // value is updated, old calls to DelayCommand are invalidate.
            else if (testCacheDuration > 0)
            {
                sIteratorName = "POI_"+sName+"_TEST_CACHE_ITERATOR_"+sID;
                gcIterator = GetLocalInt(oEmitter, sIteratorName);
                SetLocalInt(oEmitter, sIteratorName, gcIterator + 1);
                DelayCommand(IntToFloat(testCacheDuration), _DestroyCachedInt(oEmitter, sVarName, sIteratorName)); // _DestroyCachedInt() can be found in ai_i_util
            }
            // ** END CACHE **
        }
        // We have cached the result of this creature's filter test. Use it.
        else
        {
            ai_PrintString("Oh, I've seen this critter before. I remember it's value.");
            if (nSuccessCache == POI_PASSED)
            {
                ai_PrintString("It's allowed to sense this PoI emitter.");
                ai_AddObjectRef(oEmitter, oCreature, sName);
                bModified = TRUE;
                nSuccess = POI_FAILED;
            }
            else
                ai_PrintString("It's not allowed to sense this PoI emitter.");
        }
    }

    if (bModified)
    {
        if (!GetLocalInt(oEmitter, POI_SCHEDULER))
        {
            SetLocalInt(oEmitter, POI_SCHEDULER, TRUE);
            DelayCommand(0.1, ExecuteScript("ai_poihb", oEmitter));
        }
    }

    ai_DebugEnd();
}
