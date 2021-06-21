/*
Filename:           ai_landmarks
System:             Memetic AI (library)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       July 21, 2009
Summary:
Landmark memes library
This is a library of landmark meme objects. It contains patterns used to
navigate trails and interact with landmarks.

At the end of this library you will find a main() function. This contains the
code that registers and runs the scripts in this library. Read the instructions
to add your own objects to this library or to a new library.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_main"

const string AI_LM_DESTINATION         = "AI_LM_DESTINATION";         // Our final destination
const string AI_LM_DESTINATION_GATEWAY = "AI_LM_DESTINATION_GATEWAY"; // Gateway in the destination's area (cached)
// Note: Computing the destination gateway is an expensive comparison, so we cache this to speed things up.

const string AI_LM_CURRENT_DESTINATION = "AI_LM_CURRENT_DESTINATION"; // Detects if destination changes
const string AI_LM_CURRENT_GATEWAY     = "AI_LM_CURRENT_GATEWAY";     // Local gateway destination (cached)
const string AI_LM_CURRENT_LANDMARK    = "AI_LM_CURRENT_LANDMARK";    // Current landmark we are headed to
const string AI_LM_CURRENT_TRAIL       = "AI_LM_CURRENT_TRAIL";       // Current trail endpoint we are headed to
const string AI_LM_CURRENT_WP          = "AI_LM_CURRENT_WP";          // Current trail waypoint we are headed to
const string AI_LM_CURRENT_DIRECTION   = "AI_LM_CURRENT_DIRECTION";   // Current trail direction we are following
const string AI_LM_CURRENT_TARGET      = "AI_LM_CURRENT_TARGET";      // Current object we are headed to
const string AI_LM_CURRENT_RETRIES     = "AI_LM_CURRENT_RETRIES";     // Number of failed attempts to get to AI_LM_CURRENT_TARGET

const string AI_LM_LAST_LOCATION       = "AI_LM_LAST_LOCATION";       // Last location before interruption

const string AI_LM_TEXT_PROCESSING_LANDMARKS = "The system is still processing landmarks. Waiting...";
const string AI_LM_TEXT_DESTINATION_INVALID  = "Error: No destination to walk towards!";
const string AI_LM_TEXT_TARGET_INVALID       = "Error: No target to walk towards!";

// This function recomputes the trail to the destination.
void _Lost(object oDest)
{
    ai_DebugStart("GotoLandmark state='lost'", AI_DEBUG_COREAI);

    // Update stored state
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_DESTINATION, oDest);

    // Clear internal state
    SetLocalObject(MEME_SELF, AI_LM_DESTINATION_GATEWAY, OBJECT_INVALID);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_GATEWAY,     OBJECT_INVALID);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK,    OBJECT_INVALID);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_TRAIL,       OBJECT_INVALID);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_WP,          OBJECT_INVALID);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_TARGET,      OBJECT_INVALID);
    SetLocalInt   (MEME_SELF, AI_LM_CURRENT_DIRECTION,   0);

    // Record where we got lost
    SetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION, GetLocation(OBJECT_SELF));

    // Find the nearest trail waypoint
    struct TrailVect_s stTrail = ai_FindNearestTrail(OBJECT_SELF, oDest, 15.0); // Instead of 15.0, define in config file? - SM
    if (!GetIsObjectValid(stTrail.oWaypoint))
    {
        ai_PrintString("Can't find any trails nearby!");

        // Just because we can't find any nearby trails doesn't mean we failed.
        // We can still try to get to a gateway that takes us to our destination.

        // We'll build this later. For now, abort.
        ai_DebugEnd();
        return;
    }

    // If we've found a direct route
    if (GetIsObjectValid(stTrail.oTrail))
    {
        ai_PrintString("Found a local route.");

        // Best case scenario. The landmark is in our area and the trail takes
        // us directly to it.

        // Store the final values
        SetLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK,  stTrail.oLandmark);
        SetLocalObject(MEME_SELF, AI_LM_CURRENT_TRAIL,     stTrail.oTrail);
        SetLocalObject(MEME_SELF, AI_LM_CURRENT_TARGET,    stTrail.oWaypoint);
        SetLocalObject(MEME_SELF, AI_LM_CURRENT_WP,        stTrail.oWaypoint);
        SetLocalInt   (MEME_SELF, AI_LM_CURRENT_DIRECTION, stTrail.nDirection);

        ai_DebugEnd();
        return;
    }

    // Otherwise we found a nearby trail that doesn't lead directly to the
    // destination (i.e., it leads through a gateway). We should handle this
    // through a child meme, which I'll do later.
    ai_PrintString("Bad trail!");

    ai_DebugEnd();
    return;
}

// Initialize variables
void ai_m_gotolandmark_ini()
{
    ai_DebugStart("GotoLandmark event='ini'", AI_DEBUG_COREAI);

    SetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION,       GetLocation(OBJECT_SELF));
    SetLocalObject  (MEME_SELF, AI_LM_CURRENT_DESTINATION, OBJECT_INVALID);

    // Must repeat to walk from trail point to trail point.
    ai_AddMemeFlag(MEME_SELF, AI_MEME_REPEAT);

    ai_DebugEnd();
}

// Walk to target
void ai_m_gotolandmark_go()
{
    ai_DebugStart("GotoLandmark event='go'", AI_DEBUG_COREAI);

    // Wait until the landmark system is done processing.
    if (ai_IsProcessingLandmarks())
    {
        // Wait and then continue
        ai_PrintString(AI_LM_TEXT_PROCESSING_LANDMARKS);
        ai_DebugEnd();
        return;
    }

    object oDest      = GetLocalObject(MEME_SELF, AI_LM_DESTINATION);
    object oCurDest   = GetLocalObject(MEME_SELF, AI_LM_CURRENT_DESTINATION);
    object oCurTarget = GetLocalObject(MEME_SELF, AI_LM_CURRENT_TARGET);

    // If we have nowhere to go
    if (!GetIsObjectValid(oDest))
    {
        // End the meme
        ai_PrintString(AI_LM_TEXT_DESTINATION_INVALID);
        ai_DebugEnd();
        return;
    }

    // If we're going to the wrong destination, or going nowhere
    if ((oCurDest != oDest) || (!GetIsObjectValid(oCurTarget)))
    {
        // Calculate a target and continue
        ai_PrintString(AI_LM_TEXT_TARGET_INVALID);
        ai_DebugEnd();
        return;
    }

    object oSelf = OBJECT_SELF;

    // We were going somewhere, so go to our target
    // If the target is in our area, we'll go to our last known location first
    if (GetArea(oSelf) == GetArea(oCurTarget))
    {
        location lLastLoc = GetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION);

        // If going to our last location isn't out of our way
        if (GetDistanceBetween(oSelf, oCurTarget) > GetDistanceBetweenLocations(lLastLoc, GetLocation(oCurTarget)))
        {
            ActionDoCommand(ActionMoveToLocation(lLastLoc));
            SpeakString("Moving to last location.");
        }
    }

    // Go to our last target object
    ai_PrintString("Walking to: '"+GetTag(oCurTarget)+"'");
    SpeakString("Walking to: '"+GetTag(oCurTarget)+"'");
    ActionDoCommand(ActionMoveToObject(oCurTarget));

    ai_DebugEnd();
}

// Determine new target
void ai_m_gotolandmark_end()
{
    ai_DebugStart("GotoLandmark event='end'", AI_DEBUG_COREAI);

    // Wait until the landmark system is done processing.
    if (ai_IsProcessingLandmarks())
    {
        ActionWait(1.0);
        ai_PrintString(AI_LM_TEXT_PROCESSING_LANDMARKS);
        ai_DebugEnd();
        return;
    }

    object oDest = GetLocalObject(MEME_SELF, AI_LM_DESTINATION);

    // If we have nowhere to go
    if (!GetIsObjectValid(oDest))
    {
        ai_PrintString(AI_LM_TEXT_DESTINATION_INVALID);
        ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
        ai_DebugEnd();
        return;
    }

    struct GatewayVect_s stGateVect;
    struct TrailVect_s   stTrailVect;

    // Initialize the variables
    location lLastLoc = GetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION);
    object oCurDest   = GetLocalObject(MEME_SELF, AI_LM_CURRENT_DESTINATION);
    object oCurTarget = GetLocalObject(MEME_SELF, AI_LM_CURRENT_TARGET);
    object oDestGate  = GetLocalObject(MEME_SELF, AI_LM_DESTINATION_GATEWAY);
    object oCurGate   = GetLocalObject(MEME_SELF, AI_LM_CURRENT_GATEWAY);
    object oCurLM     = GetLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK);
    object oCurTrail  = GetLocalObject(MEME_SELF, AI_LM_CURRENT_TRAIL);
    object oCurWP     = GetLocalObject(MEME_SELF, AI_LM_CURRENT_WP);
    int    nDir       = GetLocalInt   (MEME_SELF, AI_LM_CURRENT_DIRECTION);
    int    nRetry     = GetLocalInt   (MEME_SELF, AI_LM_CURRENT_RETRIES);
    int    bLost      = FALSE;

    // Now we'll evaluate whether we need to recompute the trail or not.
    // There's several possibilities:
    // 1: Our destination has changed or was never set.
    // 2: We have to target to walk to.
    // 3: We didn't get to our target after 5 tries.
    // 4: We didn't get to our target but have retries left, so we retry.
    // 5: We've gotten a step closer to our destination and need a new target.
    // Of these possibilities, we need to recompute if 1, 2, or 3 is the case.

    // If we're going to the wrong destination, or going nowhere
    if ((oCurDest != oDest) || (!GetIsObjectValid(oCurTarget)))
    {
        ai_PrintString("Destination has changed!");
        bLost = TRUE;
    }
    // If we're not at our target destination, try again
    else if (GetDistanceBetween(OBJECT_SELF, oCurTarget) > 2.0)
    {
        // If we haven't exceeded our retry count
        if (nRetry < 5)
        {
            ai_PrintString("Didn't get there yet, trying again");
            SetLocalInt(MEME_SELF, AI_LM_CURRENT_RETRIES, nRetry + 1);
            ai_DebugEnd();
            return;
        }

        bLost = TRUE;
    }

    if (bLost)
    {
        // Recompute
        _Lost(oDest);
        ai_DebugEnd();
        return;
    }

    // If this is the trail waypoint we were headed to
    if (oCurTarget == oCurWP)
    {
        ai_PrintString("Got to waypoint " + GetTag(oCurTarget));
        SpeakString("Got to waypoint " + GetTag(oCurTarget));

        // Select the next waypoint
        oCurWP = ai_GetTrailNextWP(oCurWP, nDir);
        if (GetIsObjectValid(oCurWP))
            oCurTarget = oCurWP; // Another step in the trail. Walk to it.
        else
            oCurTarget = oCurLM; // End of the trail. Walk to the landmark.
    }
    else if (oCurTarget == oCurLM)
    {
        // This is the landmark we were headed to
        ai_PrintString("Got to landmark " + GetTag(oCurLM));

        // If we're done
        if (oCurLM == oDest)
        {
            ai_PrintString("I'm at my destination, w00t!");
            ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
            ai_DebugEnd();
            return;
        }

        // Figure out what the next landmark is
        stTrailVect = ai_GetShortestNextTrail(oCurLM, oDest, oCurGate, oDestGate);

        // Update our course
        oCurWP    = stTrailVect.oWaypoint;
        oCurTrail = stTrailVect.oTrail;
        oCurLM    = stTrailVect.oLandmark;  // Gateways are landmarks too!
        nDir      = stTrailVect.nDirection;

        oCurTarget = oCurWP;

        SpeakString("New target: " +GetTag(oCurTarget));
    }

    ai_PrintString("New course: oCurWP='"+GetTag(oCurWP)+"' oCurTrail='"+GetTag(oCurTrail)+"' oCurLM='"+GetTag(oCurLM)+"' nDir='"+IntToString(nDir)+"'");

    // Update stored state
    SetLocalObject(MEME_SELF, AI_LM_DESTINATION_GATEWAY, oDestGate);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_DESTINATION, oCurDest);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_GATEWAY,     oCurGate);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK,    oCurLM);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_TRAIL,       oCurTrail);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_WP,          oCurWP);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_TARGET,      oCurTarget);
    SetLocalInt   (MEME_SELF, AI_LM_CURRENT_DIRECTION,   nDir);
    SetLocalInt   (MEME_SELF, AI_LM_CURRENT_RETRIES,     nRetry);

    ai_DebugEnd();
}

void ai_m_gotolandmark_brk()
{
    ai_DebugStart("GotoLandmark event='brk'", AI_DEBUG_COREAI);

    // Interruptions don't count as a retry
    SetLocalInt(MEME_SELF, AI_LM_CURRENT_RETRIES, 0);

    // If we are interrupted, we risk being drawn off our path. We want to
    // remember where we got interrupted. If we stray too far, we really should
    // look around for another trail that might be closer and will take us to
    // our destination.
    SetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION, GetLocation(OBJECT_SELF));

    ai_DebugEnd();
}


/*------------------------------------------------------------------------------
 *   Script: Library Initialization and Scheduling
 *
 *   This main() defines this script as a library. The following two steps
 *   handle registration and execution of the scripts inside this library. It
 *   is assumed that a call to ai_LoadLibrary() has occured in the ModuleLoad
 *   callback. This lets the ai_ExecuteScript() function know how to find the
 *   functions in this library. You can create your own library by copying this
 *   file and editing "ai_hooks" to register the name of your new library.
 ------------------------------------------------------------------------------*/
void main()
{
    ai_DebugStart("Library name='"+MEME_LIBRARY+"'");

    //  Step 1: Library Setup
    //
    //  This is run once to bind your scripts to a unique number.
    //  The number is composed of a top half - for the "class" and lower half
    //  for the specific "method". If you are adding your own scripts, copy
    //  the example, make sure to change the first number. Then edit the
    //  switch statement following this if statement.

    if (MEME_DECLARE_LIBRARY)
    {
        ai_LibraryImplements("ai_m_gotolandmark",      "_go",  0x0100+0x01);
        ai_LibraryImplements("ai_m_gotolandmark",      "_brk", 0x0100+0x02);
        ai_LibraryImplements("ai_m_gotolandmark",      "_end", 0x0100+0x03);
        ai_LibraryImplements("ai_m_gotolandmark",      "_ini", 0x0100+0xff);

        //ai_LibraryImplements("<name>",        "_go",     0x??00+0x01);
        //ai_LibraryImplements("<name>",        "_brk",    0x??00+0x02);
        //ai_LibraryImplements("<name>",        "_end",    0x??00+0x03);
        //ai_LibraryImplements("<name>",        "_ini",    0x??00+0xff);

        ai_DebugEnd();
        return;
    }

    //  Step 2: Library Dispatcher
    //
    //  These switch statements are what decide to run your scripts, based
    //  on the numbers you provided in Step 1. Notice that you only need
    //  an inner switch statement if you exported more than one method
    //  (like go and end). Also notice that the value used by the case statement
    //  is the two numbers added up.

    switch (MEME_ENTRYPOINT & 0xff00)
    {
        case 0x0100: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_gotolandmark_go();  break;
                         case 0x02: ai_m_gotolandmark_brk(); break;
                         case 0x03: ai_m_gotolandmark_end(); break;
                         case 0xff: ai_m_gotolandmark_ini(); break;
                     }   break;

        /*
        case 0x??00: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: <name>_go();     break;
                         case 0x02: <name>_brk();    break;
                         case 0x03: <name>_end();    break;
                         case 0xff: <name>_ini();    break;
                     }   break;
        */
    }

    ai_DebugEnd();
}
