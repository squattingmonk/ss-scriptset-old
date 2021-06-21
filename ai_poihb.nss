/*
Filename:           ai_poihb
System:             Memetic AI (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       July 28, 2009
Summary:
Point of Interest Emitter Heartbeat event hook-in script for the Memetic AI
system. This is periodically called when an emitter is of a size < 10m and a
creature has entered the 10m area to check to see if they are close. Once they
are close, they may be notified of the point of interested by emitting various
information, etc.

You should never need to use this. Ever. It is handled internally.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "ai_i_main"

void main()
{
    object oEmitter = OBJECT_SELF;

    if (!GetIsObjectValid(oEmitter))
        return;

    if (GetLocalInt(oEmitter, POI_EMITTER_PAUSED) != 0)
        return;

    ai_DebugStart("EmitterAreaHeartbeat", AI_DEBUG_TOOLKIT);


    int      bValid;    // Is the given creature within the radius for the given emitter
    float    fDistance; // The distance the creature must be within to be notified
    object   oCreature; // The creature in the AoE which may be near enough
    string   sName;     // The name of the emitter which is being expressed
    location lLoc;      // The location of the emitter or the emitting creature
    object   oModule = GetModule();
    int      i, j, bRespawn, bUniqueSize;
    string   sID, sFunction;

    // These are used to cache the players value and allow them to expire
    // after some fixed period of time.
    int    notifyCacheDuration;
    int    gcIterator;
    string sVarName;
    string sIteratorName;


    SetLocalInt(oEmitter, POI_SCHEDULER, FALSE);

    // Let's find out where we are. Unfortunately we have to recompute this
    // every time as the emitter owner could be moving.
    object oTarget = GetLocalObject(oEmitter, POI_TARGET);
    if (oTarget == OBJECT_INVALID) lLoc = GetLocation(oEmitter); // This is a location-based emitter.
    else                           lLoc = GetLocation(oTarget);  // This is a creature-based emitter.

    // There is great room for optimization in these loops, but as I don't know
    // how aggressively PoIs are going to be used, I will concentrate on
    // functionality first.

    // In this context, oEmitter is the emitter object. It has a list of emitter
    // names stored on it.
    for (i = ai_GetStringCount(oEmitter, POI_EMITTER) - 1; i >= 0; i--)
    {
        // Let's evaluate all the creatures which haven't gotten close enough
        // but can notice the PoI. If they're on this list and in the emitting
        // area, notify them.
        sName     = ai_GetStringByIndex(oEmitter, i, POI_EMITTER);
        fDistance = GetLocalFloat(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_DISTANCE);

        if (fDistance != POI_LARGE && fDistance != POI_SMALL)
            bUniqueSize = TRUE;

        ai_PrintString("Emitter distance is "+FloatToString(fDistance)+".");

        // If this emitter is paused, don't bother - move to the next emitter.
        if (GetLocalInt(oEmitter, POI_EMITTER_PAUSED + sName))
            break;

        ai_PrintString("Checking emitter '"+sName+"'");

        for (j = ai_GetObjectCount(oEmitter, sName) - 1; j >= 0; j--)
        {
            oCreature = ai_GetObjectByIndex(oEmitter, j, sName);
            sID = ObjectToString(oCreature);

            ai_PrintString("Checking to see if this critter is close enough to sense the emitter.");

            // 10m and 5m Distances are auto-notified; other distances must be manually verified.
            if ((fDistance == POI_LARGE || fDistance == POI_SMALL))
                bValid = TRUE;
            else if (GetDistanceBetweenLocations(GetLocation(oCreature),lLoc) <= fDistance)
                bValid = TRUE;
            else bValid = FALSE;

            ai_PrintString("Is in range = "+IntToString(bValid));

            // So if the creature is on the list and within the distance, emit to it.
            if (bValid && (GetLocalInt(oEmitter, "POI_"+sName+"_NOTIFY_CACHE_"+sID) != 1))
            {
                if (GetLocalInt(oCreature, POI_EMITTER+sName) != 2) // Not inside area
                {
                    SetLocalInt(oCreature, POI_EMITTER+sName, 2);   // Notate that the player has visited and is in the area

                    ai_PrintString("This guy is in the sensory area and hasn't sensed it earlier than the notification cache duration.");

                    // Execute a function
                    sFunction = GetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_ACTIVATE_FUNCTION);
                    if (sFunction != "")
                    {
                        ai_PrintString("An activation function is scheduled to execture.");
                        DelayCommand(0.0, Action(ai_CallFunction(sFunction, oCreature, oEmitter)));
                    }

                    if (GetIsPC(oCreature) || GetIsDM(oCreature))
                    {
                        ai_PrintString("Emitting PoI sensory notification to a player.");

                        string sResRef    = GetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_RESREF);
                        string sEnterText = GetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_ENTER_TEXT);

                        // Automatically do some floating text.
                        if (sEnterText != "")
                            FloatingTextStringOnCreature(sEnterText, oCreature, FALSE);

                        // Start a dialog which may being a conversation, run a script, etc.
                        if (sResRef != "" )
                        {
                            ai_PrintString("Starting Dialog "+sResRef+"with "+GetName(oCreature));

                            // Set up some globals for the resref
                            SetLocalObject(oModule, POI_EMITTER_SELF,   oEmitter);
                            SetLocalObject(oModule, POI_EMITTER_OWNER,  oTarget);
                            SetLocalObject(oModule, POI_EMITTER_TARGET, oCreature);

                            // Start the conversation
                            ActionStartConversation(oCreature, sResRef, TRUE);
                        }
                    }
                    else
                    {
                        ai_PrintString("Emitting PoI (entering) sensory notification message to a creature.");
                        struct message stEnterMsg = ai_GetLocalMessage(oModule, POI_EMITTER_IN + sName);
                        ai_SendMessage(stEnterMsg, stEnterMsg.sChannelName, oCreature);
                    }

                    // ** START CACHE **
                    // We may want to notate that this creature has been notified of the PoI Emitter

                    notifyCacheDuration = GetLocalInt(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_NOTIFY_CACHE);
                    sVarName = "POI_"+sName+"_NOTIFY_CACHE_"+sID;

                    // If it's zero, we never record the value.
                    if (notifyCacheDuration != 0)
                    {
                        ai_PrintString("We have notified this critter about the PoI, now we cache that fact.");
                        SetLocalInt(oEmitter, sVarName, TRUE);
                    }

                    // If it's not-negative, we will destroy the value that may have been recorded.
                    // We use a rather contrived process to ensure that if the value is updated, old
                    // calls to DelayCommand are invalidate.
                    if (notifyCacheDuration > 0)
                    {
                        sIteratorName = "POI_"+sName+"_NOTIFY_CACHE_ITERATOR_"+sID;
                        gcIterator = GetLocalInt(oEmitter, sIteratorName);
                        SetLocalInt(oEmitter, sIteratorName, gcIterator + 1);
                        DelayCommand(IntToFloat(notifyCacheDuration), _DestroyCachedInt(oEmitter, sVarName, sIteratorName)); // _DestroyCachedInt() can be found in ai_i_util
                    }
                    // ** END CACHE **
                }
            }
            // Otherwise the creature was just in the area but no longer is.
            // This block is equivalent to ai_poiexit for areas that are < 10.0m
            // or 5.0m. One issue is that they may walk back into the area - so
            // they should stil be tracked.
            else if (GetLocalInt(oCreature, POI_EMITTER + sName) == 2) // Was Inside Area -- I think
            {
                SetLocalInt(oCreature, POI_EMITTER + sName, 1); // Notate that the player has visited but is not in the area

                // Keep the creature on the list. This list represents creatures
                // which should be tracked. We should only remove them when they
                // fully leave the PoI area. Otherwise, we should still track
                // them, in case they return.
                // ai_AddObjectRef(oEmitter, oCreature, sName);

                ai_PrintString("The creature is not in the area and has been notified earlier.", FALSE, AI_DEBUG_UTILITY);
                // Float exit text. Only needed if the radius != 10 or 5, and we can't do this in ai_poiexit
                string sExitText = GetLocalString(GetModule(), POI_EMITTER_PREFIX + sName + POI_EMITTER_EXIT_TEST);

                // Automatically do some floating text.
                if (GetIsPC(oCreature) || GetIsDM(oCreature))
                {
                    if (sExitText != "")
                        FloatingTextStringOnCreature(sExitText, oCreature, FALSE);
                }
                else
                {
                    ai_PrintString("Emitting PoI (exiting) sensory notification to a creature.");
                    struct message stEnterMsg = ai_GetLocalMessage(oModule, POI_EMITTER_OUT + sName);
                    ai_SendMessage(stEnterMsg, stEnterMsg.sChannelName, oCreature);
                }

                // Run Exit Script
                sFunction = GetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_EXIT_FUNCTION);
                if (sFunction != "")
                {
                    ai_PrintString("An exit function is scheduled to execture.");
                    DelayCommand(0.0, Action(ai_CallFunction(sFunction, oCreature, oEmitter)));
                }

                // Clean up the variable we stuck on the player.
                DeleteLocalInt(oCreature, POI_EMITTER + sName);
            }
        }

        if (ai_GetObjectCount(oEmitter, sName))
            bRespawn = TRUE;
    }

    // Respawn this script if there are players on the list and the distance of
    // one of the emitters is less than 5m or 10m. All the 5m or 10m emitters
    // will have been notified and removed from the list. The other ones will
    // need to be watched by creating a polling loop. The durating on this
    // DelayCommand will effect the responsiveness of the PoI Emitter.
    if (bRespawn && bUniqueSize)
    {
        SetLocalInt(oEmitter, POI_SCHEDULER, TRUE);
        DelayCommand(2.0+IntToFloat(Random(2)) /* What the heck, let's give this a try. */, ExecuteScript("ai_poihb", oEmitter));
    }

    ai_DebugEnd();
}

