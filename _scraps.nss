/*-----------------------------------------------------------------------------
 * Function:  ai_m_gotolandmark (Walks the closest trail)
 *   Author:  Daryl Low
 *     Date:  July, 2003
 *  Purpose:  Takes the shortest path to get to the destination. Is smart
 *            enough to traverse between areas if need be.
 *- Input Arguments -----------------------------------------------------------
 * object "Destination": This is the destination landmark
 *- Local State ---------------------------------------------------------------
 * object "DestGate": Destination landmark's gateway (if applicable)
 *
 * object "CurDest":  Current destination (to detect if destination changes)
 * object "CurGate":  Local gateway destination (if applicable)
 * object "CurLM":    Local landmark destination
 * object "CurTrail": Local trail endpoint destination
 * object "CurWP":    Local trail waypoint
 * int    "CurDir":   Direction from waypoint to next landmark
 *
 * object "CurTarget": Curent object we are heading for
 * int    "CurRetry":  Number of failed attempts for the current target
 *
 * location "LastLocation": Last known location before interruption
 *----------------------------------------------------------------------------*/

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

const string AI_LM_LAST_LOCATION     = "AI_LM_LAST_LOCATION"; // Last location before interruption

const string AI_LM_TEXT_PROCESSING_LANDMARKS = "The system is still processing landmarks. Waiting...";
const string AI_LM_TEXT_DESTINATION_INVALID  = "Error: No destination to walk towards!";

// This function creates a child meme called ai_m_gotolandmark_lost to get a new
// target to walk towards.
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

    // Spawn a child to plot our new course
    object oChild = ai_CreateMeme("ai_m_gotolandmark_lost", AI_PRIORITY_DEFAULT, 0, AI_MEME_RESUME | AI_MEME_REPEAT, MEME_SELF);
    SetLocalObject(oChild, AI_LM_DESTINATION, oDest);

    ai_DebugEnd();
    return;
}

void ai_m_gotolandmark_ini()
{
    ai_DebugStart("GotoLandmark event='ini'", AI_DEBUG_COREAI);

    SetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION,       GetLocation(OBJECT_SELF));
    SetLocalObject  (MEME_SELF, AI_LM_CURRENT_DESTINATION, OBJECT_INVALID);

    // Must repeat to walk from trail point to trail point.
    ai_AddMemeFlag(MEME_SELF, AI_MEME_REPEAT);

    ai_DebugEnd();
}

void ai_m_gotolandmark_go()
{
    ai_DebugStart("GotoLandmark event='go'", AI_DEBUG_COREAI);

    if (ai_IsProcessingLandmarks())
    {
        ai_PrintString(AI_LM_TEXT_PROCESSING_LANDMARKS);
        ai_DebugEnd();
        return;
    }

    location lLastLoc = GetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION);

    object oDest      = GetLocalObject(MEME_SELF, AI_LM_DESTINATION);
    object oCurDest   = GetLocalObject(MEME_SELF, AI_LM_CURRENT_DESTINATION);
    object oCurTarget = GetLocalObject(MEME_SELF, AI_LM_CURRENT_TARGET);

    // If we have nowhere to go
    if (!GetIsObjectValid(oDest))
    {
        ai_PrintString(AI_LM_TEXT_DESTINATION_INVALID);
        ai_DebugEnd();
        return;
    }

    // If we're going to the wrong destination, or going nowhere
    if ((oCurDest != oDest) || (!GetIsObjectValid(oCurTarget)))
    {
        // Try to get unlost
        _Lost(oDest);
        ai_DebugEnd();
        return;
    }

    object oSelf = OBJECT_SELF;

    // We were going somewhere, so go to our target
    // If the target is in our area, we'll go to our last known location first
    if (GetArea(oSelf) == GetArea(oCurTarget))
    {
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

void ai_m_gotolandmark_end()
{
    ai_DebugStart("GotoLandmark event='end'", AI_DEBUG_COREAI);

    // We can get very confused if we use incomplete landmark info
    if (ai_IsProcessingLandmarks())
    {
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

    location lLastLoc = GetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION);

    struct GatewayVect_s stGateVect;
    struct TrailVect_s   stTrailVect;

    object oDestGate  = GetLocalObject(MEME_SELF, AI_LM_DESTINATION_GATEWAY);
    object oCurDest   = GetLocalObject(MEME_SELF, AI_LM_CURRENT_DESTINATION);
    object oCurGate   = GetLocalObject(MEME_SELF, AI_LM_CURRENT_GATEWAY);
    object oCurLM     = GetLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK);
    object oCurTrail  = GetLocalObject(MEME_SELF, AI_LM_CURRENT_TRAIL);
    object oCurWP     = GetLocalObject(MEME_SELF, AI_LM_CURRENT_WP);
    object oCurTarget = GetLocalObject(MEME_SELF, AI_LM_CURRENT_TARGET);
    int    nDir       = GetLocalInt   (MEME_SELF, AI_LM_CURRENT_DIRECTION);
    int    nRetry     = GetLocalInt   (MEME_SELF, AI_LM_CURRENT_RETRIES);
    int    bLost      = FALSE;

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

    // If we've fallen through to this point, there's one of four possibilities:
    // 1: We've gotten a step closer to our destination and need a new target to
    //    walk towards. In this case, we're not lost.
    // 2: The object we're walking towards is no longer valid. We're lost.
    // 3: Our final destination has been changed somehow. We're lost.
    // 4: We've tried five times to get to our target destination. We're lost.
    // Being lost means we need to recompute the route we're taking to get to
    // our destination. We pass this off to the ai_m_gotolandmark_lost meme.

    // Whether we're lost or not, we're done retrying the same spot
    nRetry = 0;
    SetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION, GetLocation(OBJECT_SELF));

    // If we're lost
    if (bLost)
    {
        // Try to get unlost
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
            oCurTarget = oCurWP;
        else
        {
            // We're at the end of the trail, walk to the landmark itself
            //oCurTarget = oCurLM;

            // If this is the gateway we were headed to
            if (oCurLM == oCurGate)
            {
                ai_PrintString("Got to gateway " + GetTag(oCurLM));

                // If we're done
                if (oCurLM == oDest)
                {
                    ai_PrintString("I'm at my destination, w00t!");
                    ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
                    ai_DebugEnd();
                    return;
                }

                // Figure out what the next gateway is
                stTrailVect = ai_GetShortestNextTrail(oCurGate, oDest, oCurGate, oDestGate);

                // Update our course
                oCurWP    = stTrailVect.oWaypoint;
                oCurTrail = stTrailVect.oTrail;
                oCurGate  = stTrailVect.oLandmark;
                oCurLM    = stTrailVect.oLandmark;  // Gateways are landmarks too!
                nDir      = stTrailVect.nDirection;

                oCurTarget = oCurWP;
            }
            else
            {
                // This is the landmark we were headed to
                ai_PrintString("Got to landmark " + GetTag(oCurLM));
                SpeakString("Got to the end of the trail: " + GetTag(oCurLM));

                // If we're done
                if (oCurLM == oDest)
                {
                    ai_PrintString("I'm at my destination, w00t!");
                    ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
                    ai_DebugEnd();
                    return;
                }

                // Figure out what the next gateway is
                stTrailVect = ai_GetShortestNextTrail(oCurLM, oDest, oCurGate, oDestGate);

                // Update our course
                oCurWP    = stTrailVect.oWaypoint;
                oCurTrail = stTrailVect.oTrail;
                oCurLM    = stTrailVect.oLandmark;  // Gateways are landmarks too!
                nDir      = stTrailVect.nDirection;

                oCurTarget = oCurWP;

                SpeakString("New target: " +GetTag(oCurTarget));
            }
        }
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

// If we are interrupted, we risk being drawn off our path. We want to
// remember where we got interrupted. If we stray too far, we really should
// look around for another trail that might be closer and will take us to our
// destination.
void ai_m_gotolandmark_brk()
{
    ai_DebugStart("GotoLandmark event='brk'", AI_DEBUG_COREAI);

    // Interruptions don't count as a retry
    SetLocalInt(MEME_SELF, AI_LM_CURRENT_RETRIES, 0);

    SetLocalLocation(MEME_SELF, AI_LM_LAST_LOCATION, GetLocation(OBJECT_SELF));

    ai_DebugEnd();
}


/*-----------------------------------------------------------------------------
 * Function:  ai_m_gotolandmark_lost (Computes best path to destination)
 *   Author:  Daryl Low
 *     Date:  July, 2003
 *  Purpose:  Takes the shortest path to get to the destination. Is smart
 *            enough to traverse between areas if need be.
 *- Input Arguments -----------------------------------------------------------
 * object "Destination": This is the destination landmark
 *- Output Results (on parent) ------------------------------------------------
 * object "DestGate":  Destination landmark's gateway (if applicable)
 * object "CurGate":   First local gateway destination (if applicable)
 * object "CurLM":     First local landmark destination
 * object "CurTrail":  First local trail endpoint destination
 * object "CurWP":     First local trail waypoint
 * object "CurTarget": Will be set to the first local waypoint
 * int    "CurDir":    Direction from first waypoint to first landmark
 *- Local State ---------------------------------------------------------------
 * object "CurDest":   Desintation landmark
 * object "CurLM":     Nearest landmark
 * object "CurWP":     Nearest waypoint
 * int    "CurDir":    Final direction from the waypoint
 *
 * object "LArea":     Local landmark's area
 * object "DArea":     Destination landmark's area
 *
 * object "LGate":     Local candidate gateway
 * object "DGate":     Destination candidate gateway
 * int    "LGate":     Index of local candidate gateway
 * int    "DGate":     Index of destination candidate gateway
 *
 * object "BestLGate": Best local gateway so far
 * object "BestDGate": Best destination gateway so far
 * float  "BestDist":  Best total trip distance so far
 *----------------------------------------------------------------------------*/

const string AI_LM_LOST_STATE = "AI_LM_LOST_STATE"; // Tracks internal state

const int    AI_LM_LOST_ERROR       = -1;
const int    AI_LM_LOST_INIT        = 0;
const int    AI_LM_LOST_SEARCH_INIT = 1;
const int    AI_LM_LOST_SEARCH      = 2;
const int    AI_LM_LOST_DONE        = 3;

const string AI_LM_LOST_LANDMARK_AREA            = "AI_LM_LOST_LANDMARK_AREA";            // Local landmark's area
const string AI_LM_LOST_DESTINATION_AREA         = "AI_LM_LOST_DESTINATION_AREA";         // Destination landmark's area
const string AI_LM_LOST_LANDMARK_GATEWAY         = "AI_LM_LOST_LANDMARK_GATEWAY";         // Local candidate gateway
const string AI_LM_LOST_DESTINATION_GATEWAY      = "AI_LM_LOST_DESTINATION_GATEWAY";      // Destination candidate gateway
const string AI_LM_LOST_BEST_LANDMARK_GATEWAY    = "AI_LM_LOST_BEST_LANDMARK_GATEWAY";    // Best local gateway so far
const string AI_LM_LOST_BEST_DESTINATION_GATEWAY = "AI_LM_LOST_BEST_DESTINATION_GATEWAY"; // Best destination gateway so far
const string AI_LM_LOST_BEST_DISTANCE            = "AI_LM_LOST_BEST_DISTANCE";            // Best total trip distance so far



void _gotolandmark_lost_init();
void _gotolandmark_lost_done();

void ai_m_gotolandmark_lost_ini()
{
    ai_DebugStart("GotoLandmark_Lost state='ini'", AI_DEBUG_COREAI);

    // Default to failure
    ai_SetMemeResult(FALSE);

    // Do real initialization when the meme runs to avoid TMI
    SetLocalInt(MEME_SELF, AI_LM_LOST_STATE, AI_LM_LOST_INIT);

    ai_AddMemeFlag(MEME_SELF, AI_MEME_RESUME | AI_MEME_REPEAT);
    ai_DebugEnd();
}

void ai_m_gotolandmark_lost_go()
{
    ai_DebugStart("GotoLandmark_Lost state='go'", AI_DEBUG_COREAI);

    // Checking the gateways is expensive, so do nothing unless we're really
    // searching. This is a last resort and something we only want to try to do
    // if we have to cross areas (getting to local landmarks will be caught
    // before now).
    if (GetLocalInt(MEME_SELF, AI_LM_LOST_STATE) != AI_LM_LOST_SEARCH)
    {
        ai_DebugEnd();
        return;
    }

    object oCurLM = GetLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK);
    object oLGate = GetLocalObject(MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY);
    string sLGate = GetTag(oLGate);

    // All we're doing here is finding if we can get to the destination and
    // gateway is the best one to take. Since we cached this information
    // OnModuleLoad, this is easier. We only make a notation of the shortest
    // route; it's up to the rest of the meme to determine whether to use it.

    // If we can get to the local gateway...
    ai_PrintString("Can '"+GetTag(oCurLM)+"' get to '"+sLGate+"'?");
    if ((oCurLM == oLGate) || (ai_GetObjectCount(oCurLM, LM_ROUTE_TRAIL + sLGate)))
    {
        object oCurDest, oBestLGate, oBestDGate;
        object oParent = ai_GetParentMeme(MEME_SELF);
        object oDGate  = GetLocalObject(MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY);
        string sDGate  = GetTag(oDGate);
        float  fBestDist, fDist;

        // ... that can get to the destination gateway...
        ai_PrintString("Can '"+sLGate+"' get to '"+sDGate+"'?");
        if (ai_GetObjectCount(oDGate, LM_GATE_ROUTE_TRAIL + sLGate))
        {
            oCurDest = GetLocalObject(oParent, AI_LM_CURRENT_DESTINATION);

            // ... that can get to the destination landmark...
            ai_PrintString("Can '"+sDGate+"' get to '"+GetTag(oCurDest)+"'?");
            if ((oCurDest == oDGate) || (ai_GetObjectCount(oCurDest, LM_ROUTE_TRAIL + sDGate)))
            {
                oBestLGate = GetLocalObject(MEME_SELF, AI_LM_LOST_BEST_LANDMARK_GATEWAY);
                oBestDGate = GetLocalObject(MEME_SELF, AI_LM_LOST_BEST_DESTINATION_GATEWAY);
                fBestDist  = GetLocalFloat (MEME_SELF, AI_LM_LOST_BEST_DISTANCE);

                fDist = ai_GetShortestDistance(oCurLM, oLGate) +
                        ai_GetShortestDistance(oLGate, oDGate) +
                        ai_GetShortestDistance(oDGate, oCurDest);
                ai_PrintString("fDist: "+FloatToString(fDist));

                // ... finally is the best so far
                if (!(GetIsObjectValid(oBestLGate)) || (fBestDist > fDist))
                {
                    ai_PrintString("Candidate: ['"+sLGate+"','"+sDGate+","+FloatToString(fDist)+"]");
                    SetLocalObject(MEME_SELF, AI_LM_LOST_BEST_LANDMARK_GATEWAY,    oLGate);
                    SetLocalObject(MEME_SELF, AI_LM_LOST_BEST_DESTINATION_GATEWAY, oDGate);
                    SetLocalFloat (MEME_SELF, AI_LM_LOST_BEST_DISTANCE,            fDist);
                }
            }
        }
    }
    // Otherwise, don't bother with this local gateway
    else
        SetLocalInt(MEME_SELF, AI_LM_CURRENT_DIRECTION, -1);

    ai_DebugEnd();
}

void ai_m_gotolandmark_lost_end()
{
    ai_DebugStart("GotoLandmark_Lost state='end'", AI_DEBUG_COREAI);

    int nState = GetLocalInt(MEME_SELF, AI_LM_LOST_STATE);
    ai_PrintString("State: "+IntToString(nState));

    // Perform initialization here, where we have less chance of TMI
    if (nState == AI_LM_LOST_INIT)
    {
        // Initialize
        _gotolandmark_lost_init();
        ai_DebugEnd();
        return;
    }

    // If we've already found a destination
    if (nState == AI_LM_LOST_DONE)
    {
        // We're done
        _gotolandmark_lost_done();
        ai_DebugEnd();
        return;
    }

    object oLArea = GetLocalObject(MEME_SELF, AI_LM_LOST_LANDMARK_AREA);
    object oDArea = GetLocalObject(MEME_SELF, AI_LM_LOST_DESTINATION_AREA);

    int nLGate;
    int nDGate;

    // If we're crossing areas and need to find the best gateway
    if (nState == AI_LM_LOST_SEARCH_INIT)
    {
        // Start at [0,0]
        ai_PrintString("'"+GetTag(oLArea)+"' has "+IntToString(ai_GetObjectCount(oLArea, LM_GATEWAYS))+" gateways");
        SetLocalInt   (MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY,    0);
        SetLocalInt   (MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY, 0);
        SetLocalObject(MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY,    ai_GetObjectByIndex(oLArea, 0, LM_GATEWAYS));
        SetLocalObject(MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY, ai_GetObjectByIndex(oDArea, 0, LM_GATEWAYS));

        SetLocalInt(MEME_SELF, AI_LM_LOST_STATE, AI_LM_LOST_SEARCH);
        ai_PrintString("State: SEARCH ("+IntToString(AI_LM_LOST_SEARCH)+")");
        ai_DebugEnd();
        return;
    }

    // Either we're searching for a good gateway or we couldn't find any nearby
    // trails, in which case we'll look for a good gateway to get to.
    nDGate = GetLocalInt(MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY) + 1;
    if ((nDGate == 0) || (nDGate >= ai_GetObjectCount(oDArea, LM_GATEWAYS)))
    {
        nDGate = 0;
        nLGate = GetLocalInt(MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY) + 1;

        if (nLGate >= ai_GetObjectCount(oLArea, LM_GATEWAYS))
        {
            // We're done
            SetLocalInt(MEME_SELF, AI_LM_LOST_STATE, AI_LM_LOST_DONE);
            ai_PrintString("State: DONE ("+IntToString(AI_LM_LOST_DONE)+")");
            ai_DebugEnd();
            return;
        }

        SetLocalInt   (MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY, nLGate);
        SetLocalObject(MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY, ai_GetObjectByIndex(oLArea, nLGate, LM_GATEWAYS));
    }

    SetLocalInt   (MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY, nDGate);
    SetLocalObject(MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY, ai_GetObjectByIndex(oDArea, nDGate, LM_GATEWAYS));

    ai_PrintString("Will examine: ['" + GetTag(GetLocalObject(MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY))+ "','"
                                      + GetTag(GetLocalObject(MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY))+"']");
    ai_DebugEnd();
}

void _gotolandmark_lost_init()
{
    ai_DebugStart("_gotolandmark_lost_init", AI_DEBUG_COREAI);

    struct TrailVect_s  stTrailVect;

    object oParent  = ai_GetParentMeme(MEME_SELF);
    object oCurDest = GetLocalObject(MEME_SELF, AI_LM_DESTINATION);
    object oCurWP;

    // Find the nearest trail waypoint
    stTrailVect = ai_FindNearestTrail(OBJECT_SELF, oCurDest, 15.0); // Will only search 15m radius? - SM
    if (!GetIsObjectValid(stTrailVect.oWaypoint))
    {
        ai_PrintString("Can't find any trails nearby!");

        // Just because we can't find any nearby trails doesn't mean we failed.
        // We can still try to get to a gateway that takes us to our destination.

        SetLocalInt(MEME_SELF, AI_LM_LOST_STATE, AI_LM_LOST_ERROR);
        ai_PrintString("State: ERROR ("+IntToString(AI_LM_LOST_ERROR)+")");
        ai_DebugEnd();
        return;
    }

    // If we've already found a direct route
    if (GetIsObjectValid(stTrailVect.oTrail))
    {
        ai_PrintString("Found a local route");

        // Best case scenario. The landmark is in our area and the trail takes
        // us directly to it.

        // Store the final values
        SetLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK,  stTrailVect.oLandmark);
        SetLocalObject(MEME_SELF, AI_LM_CURRENT_WP,        stTrailVect.oWaypoint);
        SetLocalInt   (MEME_SELF, AI_LM_CURRENT_DIRECTION, stTrailVect.nDirection);

        SetLocalObject(MEME_SELF, AI_LM_LOST_BEST_LANDMARK_GATEWAY,    OBJECT_INVALID);
        SetLocalObject(MEME_SELF, AI_LM_LOST_BEST_DESTINATION_GATEWAY, OBJECT_INVALID);

        SetLocalInt(MEME_SELF, AI_LM_LOST_STATE, AI_LM_LOST_DONE);
        ai_PrintString("State: DONE ("+IntToString(AI_LM_LOST_DONE)+")");
        ai_DebugEnd();
        return;
    }

    // Store the first local trail waypoint
    oCurWP = stTrailVect.oWaypoint;

    // Cache the nearest waypoint and one of the landmarks it leads to
    // This indicates that the initialization completed successfully
    object oCurLM = ai_GetTrailLandmark(oCurWP, -1);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_DESTINATION, oCurDest);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK,   oCurLM);
    SetLocalObject(MEME_SELF, AI_LM_CURRENT_WP,         oCurWP);
    SetLocalInt   (MEME_SELF, AI_LM_CURRENT_DIRECTION,  0);
    ai_PrintString("CurLM='"+GetTag(oCurLM)+"'");

    // Cache the local and destination areas
    SetLocalObject(MEME_SELF, AI_LM_LOST_LANDMARK_AREA,    GetArea(OBJECT_SELF));
    SetLocalObject(MEME_SELF, AI_LM_LOST_DESTINATION_AREA, GetArea(oCurDest));

    // Initialize the rest of the internal state
    SetLocalInt(MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY,    0);
    SetLocalInt(MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY, 0);

    SetLocalObject(MEME_SELF, AI_LM_LOST_BEST_LANDMARK_GATEWAY,    OBJECT_INVALID);
    SetLocalObject(MEME_SELF, AI_LM_LOST_BEST_DESTINATION_GATEWAY, OBJECT_INVALID);

    SetLocalInt(MEME_SELF, AI_LM_LOST_STATE, AI_LM_LOST_SEARCH_INIT);
    ai_PrintString("State: SEARCH_INIT ("+IntToString(AI_LM_LOST_SEARCH_INIT)+")");
    ai_AddMemeFlag(MEME_SELF, AI_MEME_RESUME | AI_MEME_REPEAT); // Why is this here? - SM
    ai_DebugEnd();
    return;
}

void _gotolandmark_lost_done()
{
    ai_DebugStart("_gotolandmark_lost_done", AI_DEBUG_COREAI);

    // Update parent
    if (GetLocalInt(MEME_SELF, AI_LM_LOST_STATE) == AI_LM_LOST_DONE)
    {
        struct TrailVect_s stTrailVect;

        object oParent   = ai_GetParentMeme(MEME_SELF);
//        object oCurGate  = GetLocalObject(MEME_SELF, AI_LM_LOST_BEST_LANDMARK_GATEWAY);
        object oCurWP    = GetLocalObject(MEME_SELF, AI_LM_CURRENT_WP);
        object oCurLM    = GetLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK);
        object oCurTrail = GetLocalObject(MEME_SELF, AI_LM_CURRENT_TRAIL);
        int    nCurDir   = GetLocalInt   (MEME_SELF, AI_LM_CURRENT_DIRECTION);

//        SetLocalObject(oParent, AI_LM_DESTINATION_GATEWAY, GetLocalObject(MEME_SELF, AI_LM_LOST_BEST_DESTINATION_GATEWAY));
//        SetLocalObject(oParent, AI_LM_CURRENT_GATEWAY,     oCurGate);
        SetLocalObject(oParent, AI_LM_CURRENT_WP,          oCurWP);
        SetLocalObject(oParent, AI_LM_CURRENT_LANDMARK,    oCurLM);
        SetLocalObject(oParent, AI_LM_CURRENT_TRAIL,       oCurTrail);
        SetLocalInt   (oParent, AI_LM_CURRENT_DIRECTION,   nCurDir);
        SetLocalObject(oParent, AI_LM_CURRENT_TARGET,      oCurWP);

/*        // Decide which way to go on the trail
        if (GetIsObjectValid(oCurGate))
            stTrailVect = ai_GetShortestTrailFromWP(oCurWP, oCurGate);
        else
            stTrailVect = ai_GetShortestTrailFromWP(oCurWP, GetLocalObject(MEME_SELF, AI_LM_CURRENT_DESTINATION));

        SetLocalObject(oParent, AI_LM_CURRENT_LANDMARK,  stTrailVect.oLandmark);
        SetLocalObject(oParent, AI_LM_CURRENT_TRAIL,     stTrailVect.oTrail);
        SetLocalInt   (oParent, AI_LM_CURRENT_DIRECTION, stTrailVect.nDirection);
*/

        ai_SetMemeResult(TRUE);
    }

    // Clean-up local variables
    DeleteLocalObject(MEME_SELF, AI_LM_CURRENT_DESTINATION);
    DeleteLocalObject(MEME_SELF, AI_LM_CURRENT_LANDMARK);
    DeleteLocalObject(MEME_SELF, AI_LM_CURRENT_TRAIL);
    DeleteLocalObject(MEME_SELF, AI_LM_CURRENT_WP);
    DeleteLocalInt   (MEME_SELF, AI_LM_CURRENT_DIRECTION);

    DeleteLocalObject(MEME_SELF, AI_LM_LOST_LANDMARK_AREA);
    DeleteLocalObject(MEME_SELF, AI_LM_LOST_DESTINATION_AREA);

    DeleteLocalObject(MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY);
    DeleteLocalObject(MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY);
    DeleteLocalInt   (MEME_SELF, AI_LM_LOST_LANDMARK_GATEWAY);
    DeleteLocalInt   (MEME_SELF, AI_LM_LOST_DESTINATION_GATEWAY);

    DeleteLocalObject(MEME_SELF, AI_LM_LOST_BEST_LANDMARK_GATEWAY);
    DeleteLocalObject(MEME_SELF, AI_LM_LOST_BEST_DESTINATION_GATEWAY);
    DeleteLocalFloat (MEME_SELF, AI_LM_LOST_BEST_DISTANCE);

    // We're finished, so stop repeating
    ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
    ai_DebugEnd();
}


