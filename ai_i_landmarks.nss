/*
Filename:           ai_i_landmarks
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jul. 7, 2009
Summary:
Memetic AI include script. This file holds landmark functions commonly used
throughout the Memetic AI system. The landmark system is a sort of universal
walk waypoints system that connects areas across the module, letting NPCs find
their way across the module.

The Landmark System
===================

The Landmark system is based on a very simple network routing algorithm.
Landmarks are connected by Trails. Each landmark has a table of all other
landmarks in the area and the trail(s) that will get you a step closer.

Initially, we search each area trail waypoints and register them with the origin
landmarks. Then, each landmark examines its neighbours and merges their routing
tables with its own. The process is repeated until all merges don't result in
any changes.

Area Transitions
================

The above algorithm describes how the intra-area routing tables are computed.
Inter-area trails are denoted by Gateways. Gateways are landmarks that point to
a different area. Gateways attach to up to 1 landmark via Gateway Trails.

Once all of the intra-area tables are done, we gather up all of the gateways and
perform a similar computation. Instead of searching for adjacent trails, the
gateways are connected if there exists some local path from one to another.
Inter-area trails are registered in the regular way.

Once this is established, the same general algorithm is run. Each gateway merges
its neighbours with its own routing table.

General Path-Finding Algorithm
==============================

At the highest level, we find a path to the nearest gateway that connects to
your destination area. After arriving at the gateway, we examine the gateway's
routing table to find the next area to go to, follow that trail and repeat.

Usually, the NPC does not start standing at a landmark. So, we normally try to
walk to the nearest trail waypoint and use it to get to a landmark. Optionally,
we can quickly examine the landmarks at each end to avoid doubling back over the
trail.

Beyond "Shortest Path"
======================

The algorithm so far is great for finding the shortest path from A to B.
Unfortunately, it doesn't consider other factors such as danger or whether the
path is even known to the NPC. These more sophisticated selections are generally
beyond the scope of the basic landmark system. However, the routing tables do
describe all adjacent trails that will get us to a destination (as long as we
don't double back through the current landmark).

Armed with this extra information, more sophisticated walking memes can choose
potentially longer, but more appropriate paths to a particular destination for a
particular NPC.

The Evil TMI (Too Many Instructions)
====================================

Pre-computation for the Landmark system is *extremely* intensive, so the code is
unusually contorted to avoid TMIs. We avoid TMIs by subdividing the code into
very small pieces using DelayCommand(). The general form of this trick is:

operation()
{
    if (!done)
        DelayCommand(_operation());
    else
        DelayCommand(operation2());
}

_operation()
{
    dotask();
    operation();
}

The operation() function calls _operation, which loops through its commands and,
when done, calls operation(). operation() checks if it supposed to be finished
and, if so, calls operation2(), which calls _operation2(), and so on.

Spotting a TMI problem
======================

The first clue that something went awry is when NPC have difficulties reaching a
particlar destination. We can examine the routing tables by enabling debugging
and looking for unclosed tags in the landmark logs. It will usually be quite
obvious, a function will suddenly stop and a new DelayCommand()ed landmark
processing function will start.

NOTE: Enabling debugging for the landmark system increases the probability that
the extra logging will trigger a TMI of its own.

Control Flow
============

The graph below describes the control flow of the landmark algorithms.

ai_ProcessLandmarks()<----------------------------------------------------------------|
 |-> 1 EnumerateLandmarks()      <-| Recursive call when finished                     |
     |-> n _EnumerateLandmarks() ->|                                                  |
     |-> 1 EnumerateGateways()      <-| Recursive call when finished                  |
         |-> n _EnumerateGateways() ->|                                               |
         |-> 1 EnumerateTrails()      <-| Recursive call when finished                |
             |-> n _EnumerateTrails() ->|                                             |
             |-> 1 EnumerateGatewayTrails()      <-| Recursive call when finished     |
                 |-> n _EnumerateGatewayTrails() ->|                                  |
                 |-> 1 UpdateLandmarks()      <-| Recursive call when finished        |
                     |-> n _UpdateLandmarks() ->|                                     |
                     |-> 1 AdjacentGateways()      <-| Recursive call when finished   |
                         |-> n _AdjacentGateways() ->|                                |
                         |-> 1 UpdateGateways()      <-| Recursive call when finished |
                             |-> n _UpdateGateways() ->|                              |
                             |------------------------------------------------------->|

Legend: 1 - Runs once when called
        n - Runs many times when called

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_class"

/*
 * Data Structures
 *
 * Module
 *  int      LM_BUSY - Indicates that landmarks are being computed
 *
 *  object[] LM_AREAS          - List of areas
 *  object   LM_AREA_<AreaTag> - Area registered with module
 *
 * Area
 *  object[] LM_GATEWAYS  - List of gateways
 *  object[] LM_LANDMARKS - List of internal landmarks
 *  object[] LM_LWGate    - List of internal gateway landmarks
 *
 *  int      LM_CHANGED - A routing table entry has changed in the current
 *                        routing table construction pass
 *
 * Gateway
 *  object LM_GATEWAY - Connected remote gateway
 *
 *  object LM_LANDMARK - Connected local landmark
 *  object LM_TRAIL    - Trail to connected local landmark
 *
 * Landmark
 *  object LM_GATEWAY    - Adjacent gateway
 *  object LM_GATE_TRAIL - Trail to adjacent gateway
 *
 *  object[] LM_TRAILS   - List of adjacent local trails
 *  object[] LM_GATEWAYS - List of adjacent local gateway landmarks
 *
 *  // Weighting class dependent
 *  object[] LM_DEST - List of reachable landmarks
 *
 *  int[]    LM_ROUTE_SHORTEST_<Dest> - Index of shortest trail to the destination
 *  object[] LM_ROUTE_TRAIL_<Dest>    - List of trails that lead to the destination
 *  string[] LM_ROUTE_PATH_<Dest>     - List of delimited path to destination via the trail
 *  float[]  LM_ROUTE_WEIGHT_<Dest>   - List of distance to the destination via the trail
 *
 *  object[] LM_GATE_DEST - List of reachable gateway landmarks
 *
 *  int[]    LM_GATE_ROUTE_SHORTEST_<Dest> - Index of shortest trail to the destination gateway
 *  object[] LM_GATE_ROUTE_TRAIL_<Dest>    - List of trails that lead to the destination gateway
 *  string[] LM_GATE_ROUTE_PATH_<Dest>     - List of delimited path to destination gateway via the trail
 *  float[]  LM_GATE_ROUTE_WEIGHT_<Dest>   - List of distance to the destination gateway via the trail
 *
 * Trail
 *  object LM_FAR_AREA      - Area of landmark on opposite end of trail (gateway only)
 *  object LM_LANDMARK_NEAR - Landmark closest to trail waypoint
 *  object LM_LANDMARK_FAR  - Landmark closest to opposite end of trail
 *  object LM_TRAIL_NEAR    - Waypoint on opposite end of trail
 *
 *  // Weighting class dependent
 *  float  LM_WEIGHT_DIST - Length of trail in meters
 *
 */


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ----- Private Landmark Processing Prototypes --------------------------------

void EnumerateLandmarks(int bDone = FALSE);
void _EnumerateLandmarks(int nTagID = 1, int nNth = 0);

void EnumerateGateways(int bDone = FALSE);
void _EnumerateGateways(int nTagID = 1, int nNth = 0);

void EnumerateTrails(int bDone = FALSE);
void _EnumerateTrails(int nLM1 = 1, int nLM2 = 1, int nNth = 0, int nMaxLM = -1);

void EnumerateGatewayTrails(int bDone = FALSE);
void _EnumerateGatewayTrails(int nLMG = 1, int nLML = 1, int nNth = 0, int nMaxGM = -1, int nMaxLM = -1);

void _UpdateLandmarks(object oModule, int nArea, int nLastArea, object oArea, int nLM, int nLastLM, object oLM, int nAdjTrail, int nLastAdjTrail);
void UpdateLandmarks(int bDone = FALSE);

void _AdjacentGateways(object oModule, int nArea, int nLastArea, object oArea, int nLM, int nLastLM, object oLM, int nAdjLM, object oAdjLM);
void AdjacentGateways(int bDone = FALSE);

void _UpdateGateways(object oModule, int nArea, int nLastArea, object oArea, int nLM, int nLastLM, object oLM, int nAdjLM, int nAdjLM, object oAdjLM);
void UpdateGateways(int bDone = FALSE);

// ----- Public Landmark Processing Prototypes ---------------------------------

// ---< ai_ProcessLandmarks >---
// ---< ai_i_landmarks >---
// Returns TRUE if landmarks are still getting initialized. APIs from
void ai_ProcessLandmarks(int bDone = FALSE);

void ai_AddRoute(object oChanged, object oLandmark, object oDest, object oTrail, float fDist, string sPath, int bGate);

void ai_DumpLandmarks(object oArea);
void ai_DumpLandmark(object oArea, object oLandmark);


// ----- Public Synchronization Prototypes -------------------------------------
int ai_IsProcessingLandmarks();


// ----- Public Shortest Path Prototypes ---------------------------------------
void ai_ShortestPathTest(object oObj, string sStart, string sStartArea, string sEnd, string sEndArea, int bDone = FALSE);
int  ai_ShortestPathInit(object oObj, object oStart, object oEnd, object oStartGate = OBJECT_INVALID, object oEndGate = OBJECT_INVALID);
int  ai_ShortestPathGo  (object oObj);
int  ai_ShortestPathDone(object oObj);

void   ai_WalkShortestPathTest(object oObj, int bDone = FALSE);
int    ai_WalkShortestPathInit(object oObj);
object ai_WalkShortestPathNext(object oObj, int bForce = FALSE);
int    ai_WalkShortestPathDone(object oObj);


// ----- Public Shortest Path Prototypes ---------------------------------------
object ai_GetClosestGatewayInArea(object oLocalGateway, object oDestArea);
struct TrailVect_s   ai_GetShortestTrailFromWP(object oWP, object oDest);


struct GatewayVect_s ai_GetShortestGateway  (object oLandmark, object oDest);


// ---< ai_GetShortestNextTrail >---
// ---< ai_i_landmarks >---
// Determines the next trail and destinations to follow in the shortest path to
// a destination. When travelling accross areas, finding oDestGate is
// computationally expensive and can lead to TMI issues. If such a computation
// is required, an error message will be logged and the function will return
// with all OBJECT_INVALIDs.
//
// Parameters:
// - oLandmark: The current landmark to search from.
// - oDest: The local landmark you are trying to get to. This is either the
//   final destination or a local gateway.
// - oGate: The local gateway landmark you are trying to get to if the final
//   destination is outside of the current area.
// - oDestGate: The gateway in the final destination's area that we are trying
//   to get to.
//
// This function returns a TrailVect_s structure. The structure describes the
// next waypoint on the trail to follow as well as the landmark that the trail
// leads to (may be a gateway). If the function determines that an area
// transition is required, the returned landmark will be the gateway landmark in
// the adjacent area.
struct TrailVect_s ai_GetShortestNextTrail(object oLandmark, object oDest, object oGate = OBJECT_INVALID, object oDestGate = OBJECT_INVALID);

float ai_GetShortestDistance(object oLandmark, object oDest, object oGate = OBJECT_INVALID, object oDestGate = OBJECT_INVALID);

// ----- Public Trail Prototypes -----------------------------------------------
object ai_GetFirstNearestTrail(object oSelf = OBJECT_SELF, int Nth = 1, float fDistance = 5.0);
object ai_GetNextNearestTrail(object oSelf = OBJECT_SELF, int Nth = 1, float fDistance = 5.0);

struct TrailVect_s ai_FindNearestTrail(object oSelf = OBJECT_SELF, object oLandmark = OBJECT_INVALID, float fDistance = 5.0);

object ai_GetTrailEnd(object oWP, int nDirection);
object ai_GetTrailNextWP(object oWP, int nDirection);

int    ai_GetTrailDirection(object oTrail, object oLandmark);
object ai_GetTrailLandmark(object oTrail, int nDirection);
float  ai_GetTrailLength(object oTrail, int nDirection);


// ----- Public Landmark Prototypes --------------------------------------------
object ai_GetReachableLandmarkCount  (object oLandmark);
object ai_GetReachableLandmarkByIndex(object oLandmark, int nIndex = 0);

object ai_GetReachableGateawyCount  (object oLandmark);
object ai_GetReachableGatewayByIndex(object oLandmark, int nIndex = 0);

object ai_GetAdjacentLandmarkCount  (object oLandmark);
object ai_GetAdjacentLandmarkByIndex(object oLandmark, int nIndex = 0);

object ai_GetAdjacentTrailCount   (object oLandmark, object oDest);
object ai_GetAdjacentTrailByIndex (object oLandmark, object oDest, int nIndex);


// ----- Public Gateway Prototypes ---------------------------------------------
int    ai_IsGateway(object oLandmark);

object ai_GetReachableAreaCount  (object oGateway);
object ai_GetReachableAreaByIndex(object oGateway, int nIndex = 0);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

// ----- Private Utility Functions ---------------------------------------------

// Returns i as a padded string
string _ZeroIntToString(int i)
{
    // Normalize the values
    i = (i < 0 ? 0 : (i > 99 ? 99 : i));

    // Pad the string
    if (i < 10) return ("0"+IntToString(i));
    else        return (IntToString(i));
}

// Returns the last two characters of s
string _GetSuffix(string s)
{
    return GetStringRight(s, 2);
}

// Returns all but the suffix of s
string _GetPrefix(string s)
{
    return GetStringLeft(s, GetStringLength(s) - 2);
}

// Returns the nNth nearest waypoint to oRef with sTag. If oRef is an area,
// returns the nNth waypoint with that tag in oRef. Could return oRef if oRef's
// tag is sTag.
object GetNearestWaypointByTag(string sTag, object oRef = OBJECT_SELF, int nNth = 1)
{
    // Sanity Check
    if (!GetIsObjectValid(oRef))
        return OBJECT_INVALID;

    // Is oRef an area?
    if (GetIsAreaNatural(oRef) != AREA_INVALID)
        oRef = GetFirstObjectInArea(oRef);

    int i, j;
    object oWaypoint;

    // Is our reference object a waypoint?
    if (GetObjectType(oRef) == OBJECT_TYPE_WAYPOINT)
        oWaypoint = oRef;
    else
        oWaypoint = GetNearestObject(OBJECT_TYPE_WAYPOINT, oRef, ++j);

    while (GetIsObjectValid(oWaypoint))
    {
        // Check the tag
        if (GetTag(oWaypoint) == sTag)
        {
            if (nNth == (++i))    // Advance the counter
                return oWaypoint; // Return this waypoint
        }

        oWaypoint = GetNearestObject(OBJECT_TYPE_WAYPOINT, oRef, ++j);
    }

    return OBJECT_INVALID;
}

// ----- Private Landmark Functions --------------------------------------------

/**
  * Area Local Landmark Waypoint Detection "Thread"
  *
  * This function repeatedly self-schedules via DelayCommand() to do the
  * actual landmark detection. When it is complete, it will call
  * EnumerateLandmarks(TRUE) to indicate that it is done.
  */
void _EnumerateLandmarks(int nTagID = 1, int nNth = 0)
{
    ai_DebugStart("_EnumerateLandmarks nTagID='"+IntToString(nTagID)+"'", AI_DEBUG_TOOLKIT);

    object oArea, oLM, oModule = GetModule();
    string sLM, sArea;
    int    i;

    // Only process exactly one chunk to avoid TMI
    for (i = 0; i < EnumerateLandmarksChunk; i++)
    {
        sLM = LM_LANDMARK_PREFIX + _ZeroIntToString(nTagID);
        oLM = GetObjectByTag(sLM, nNth);

        // If there is no such object
        if (!GetIsObjectValid(oLM))
        {
            // If this is the first attempt reading the tag, we're done
            if (nNth == 0)
            {
                // Remember the max landmark ID
                SetLocalInt(oModule, LM_LANDMARKS, nTagID - 1);

                // Schedule EnumerateLandmarks() to run again
                DelayCommand(0.0, EnumerateLandmarks(TRUE));
                ai_DebugEnd();
                return;
            }
            else
            {
                // We're done with this tag
                nTagID++;
                nNth = 0;
                continue;
            }
        }
        else if (GetObjectType(oLM) != OBJECT_TYPE_WAYPOINT)
        {
            // If this isn't a waypoint object, skip it
            ai_PrintString("WARNING: Non-landmark object has a valid landmark name.");
            nNth++;
            continue;
        }

        // Register the area if not already done
        oArea = GetArea(oLM);
        sArea = GetTag(oArea);
        if (!GetLocalInt(oModule, LM_AREA + sArea))
        {
            ai_PrintString("New area '" + sArea + "'");
            ai_AddObjectRef(oModule, oArea, LM_AREAS);
            SetLocalInt(oModule, LM_AREA + sArea, TRUE);
        }

        ai_PrintString("New landmark '" + sLM + "' in '" + sArea + "'");

        // Add the landmark to a reverse lookup index
        SetLocalInt(oArea, sLM, ai_GetObjectCount(oArea, LM_LANDMARKS));

        // Add the landmark to it's area's list
        ai_AddObjectRef(oArea, oLM, LM_LANDMARKS);

        // Next landmark
        nNth++;
    }

    // Call myself for another chunk
    DelayCommand(0.0, _EnumerateLandmarks(nTagID, nNth));

    ai_DebugEnd();
}

/**
  * Detect Area Local Landmark Waypoints
  *
  * This function schedules the _EnumerateLandmark() "thread" and then "waits"
  * until the processing of _EnumerateLandmarks() is complete. Once complete,
  * it schedules the next phase of landmark processing.
  *
  * Landmarks are junction points for one or more trails. They serve as
  * decision points for characters using the landmark system.
  *
  * Landmarks have tags of the form: "LM_" + <ID>, where <ID> is a number
  * uniquely identifying the landmark within the area. The <ID> numbers
  * should be contiguous for all landmarks within an area, starting at 01.
  * Warnings will be logged if this is not the case.
  */
void EnumerateLandmarks(int bDone = FALSE)
{
    ai_DebugStart("EnumerateLandmarks bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    object oModule = GetModule();

    // If we're being invoked for the first time
    if (!bDone)
    {
        // Send progress message here

        // Start enumerating landmarks by scheduling _EnumerateLandmarks()
        DelayCommand(0.0, _EnumerateLandmarks());

    // Otherwise, we're being called because _EnumerateLandmarks() is done
    }
    else
    {
        // If we found some landmarks
        if (ai_GetObjectCount(oModule, LM_AREAS))
        {
            // Call "EnumerateGateways" to enter next phase
            EnumerateGateways();
        }
        else
        {
            // Clean-up variables
            DeleteLocalInt(oModule, LM_LANDMARKS);
            ai_PrintString("WARNING: No landmarks detected!");
        }
    }

    ai_DebugEnd();
}

/**
  * Cross Area Gateway Waypoint Detection "Thread"
  *
  * This function repeatedly self-schedules via DelayCommand() to do the
  * actual gateway detection. When it is complete, it will call
  * EnumerateGateways(TRUE) to indicate that it is done.
  */
void _EnumerateGateways(int nTagID = 1, int nNth = 0)
{
    ai_DebugStart("_EnumerateGateways nTagID='"+IntToString(nTagID)+"' nNth='"+IntToString(nNth)+"'", AI_DEBUG_TOOLKIT);

    object oArea, oGW, oGWDest, oGWDestArea, oModule = GetModule();
    string sGW, sGWDest, sGWDestArea, sArea;
    int    i, j;

    // Only process exactly one chunk to avoid TMI
    for (i = 0; i < EnumerateGatewaysChunk; i++)
    {
        sGW = LM_GATEWAY_PREFIX + _ZeroIntToString(nTagID);
        oGW = GetObjectByTag(sGW, nNth);

        // If there is no such object
        if (!GetIsObjectValid(oGW))
        {
            // If this is the first attempt reading the tag, we're done
            if (nNth == 0)
            {
                // Remember the max gateway ID
                SetLocalInt(oModule, LM_GATEWAYS, nTagID - 1);

                // Schedule EnumerateGateways() to run again
                DelayCommand(0.0, EnumerateGateways(TRUE));
                ai_DebugEnd();
                return;
            }
            else
            {
                // We're done with this tag
                nTagID++;
                nNth = 0;
                continue;
            }
        }
        else if (GetObjectType(oGW) != OBJECT_TYPE_WAYPOINT)
        {
            // If this isn't a waypoint object, skip it
            ai_PrintString("WARNING: Non-gateway object has a valid gateway name");
            nNth = nNth++;
            continue;
        }

        // Register the area if not already done
        oArea = GetArea(oGW);
        sArea = GetTag(oArea);
        if (!GetLocalInt(oModule, LM_AREA + sArea))
        {
            ai_PrintString("New area '" + sArea + "'");
            ai_AddObjectRef(oModule, oArea, LM_AREAS);
            SetLocalInt(oModule, LM_AREA + sArea, 1);
        }

        // Find the remote gateway that this gateway connects to
        sGWDestArea = ai_GetConfigString(oGW, "MT: Destination Area");
        if (sGWDestArea == "")
        {
            ai_PrintString("WARNING: Gateway '"+ sGW +"' doesn't connect to another area");
            oGWDestArea = OBJECT_INVALID;
        }
        else
        {
            for (j = 0;; j++)
            {
                oGWDestArea = GetObjectByTag(sGWDestArea, j);
                if (!GetIsObjectValid(oGWDestArea))
                {
                    ai_PrintString("WARNING: No area called '" + sGWDestArea + "'");
                    break;
                }

                if (GetObjectType(oGWDestArea) == GetObjectType(oArea)) break;
            }
        }

        if (GetIsObjectValid(oGWDestArea))
        {
            sGWDest = ai_GetConfigString(oGW, "MT: Destination GW");
            if (sGWDest == "")
            {
                ai_PrintString("WARNING: Gateway '" + sGW + "' doesn't connect to another gateway in area '" + sGWDestArea + "'");
                oGWDest = OBJECT_INVALID;
            }
            else
            {
                for (j = 0;; j++)
                {
                    oGWDest = GetObjectByTag(sGWDest, j);
                    if (!GetIsObjectValid(oGWDest))
                    {
                        ai_PrintString("WARNING: No gateway call '" + sGWDest + "' in area '" + sGWDestArea + "'");
                        break;
                    }

                    if (GetArea(oGWDest) == oGWDestArea) break;
                }
            }
        }

        ai_PrintString("New gateway '" + sGW + "' in '" + GetTag(oArea) + "' connecting to '" + sGWDest + "' in '" + sGWDestArea + "'");

        // Add the gateway to a reverse lookup index
        SetLocalInt(oArea, sGW, ai_GetObjectCount(oArea, LM_GATEWAYS));

        // Add the gateway to it's area's list
        ai_AddObjectRef(oArea, oGW, LM_GATEWAYS);

        // Connect the two gateways
        SetLocalObject(oGW,     LM_GATEWAY, oGWDest);
        SetLocalObject(oGWDest, LM_GATEWAY, oGW);

        // Next duplicate
        nNth++;
    }

    // Call myself for another chunk
    DelayCommand(0.0, _EnumerateGateways(nTagID, nNth));

    ai_DebugEnd();
}

/**
  * Detect Cross Area Gateway Landmarks Waypoints
  *
  * This function schedules the _EnumerateGateways() "thread" and then "waits"
  * until the processing of _EnumerateGateways() is complete. Once complete,
  * it schedules the next phase of landmark processing.
  *
  * Users place Gateway waypoints at cross-area transitions such as
  * doors. For simplicity's sake, a gateway is always connected to a landmark
  * in the same area via a single "gateway trail". There should only ever be
  * one landmark going to a gateway, but you can have many landmarks leading to
  * that preceding landmark. So if it is necessary for several landmarks to
  * lead to a single gateway, make them go to a final landmark which in turn
  * connects to the gateway.
  *
  * Gateways have tags of the form: "GW_" + <ID>, where <ID> is a number
  * uniquely identifying the gateway within the area. The <ID> numbers
  * should be contiguous for all gateways within an area, starting at "1".
  * Warnings will be logged if this is not the case.
  *
  * Gateways have two variable "conf strings" called "MT: Destination Area" and
  * "MT: Destination GW" uniquely identifying a remote gateway, which this
  * gateway connects to. Warnings will be logged for gateways that do not
  * reference other gateways, or for gateways pairs that do not mutually
  * reference each other.
  */
void EnumerateGateways(int bDone = FALSE)
{
    ai_DebugStart("EnumerateGateways bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    object oArea, oModule = GetModule();
    int    i, nCount;

    // If we're being invoked for the first time
    if (!bDone)
    {
        // Send progress message here

        // Start enumerating gateways by scheduling _EnumerateLandmarks()
        DelayCommand(0.0, _EnumerateGateways());

    // Otherwise, we're being called because _EnumerateLandmarks() is done
    }
    else
    {
        // Clean-up area registration flags, we don't need them anymore
        nCount = ai_GetObjectCount(oModule, LM_AREAS);
        for (i = 0; i < nCount; i++)
        {
            oArea = ai_GetObjectByIndex(oModule, i, LM_AREAS);
            DeleteLocalInt(oModule, LM_AREA + GetTag(oArea));
        }

        // Call "EnumerateTrails" to enter next phase
        EnumerateTrails();
    }

    ai_DebugEnd();
}

/**
  * Area Local Trail Waypoint Detection "Thread"
  *
  * This function repeatedly self-schedules via DelayCommand() to do the
  * actual trail detection. When it is complete, it will call
  * EnumerateTrails(TRUE) to indicate that it is done.
  *
  * We are simulating the following loop:
  *     for (nLM1 = 1; nLM1 < nMaxLM; nLM1++)
  *     {
  *         for (nLM2 = 1; nLM2 < nMaxLM; nLM2++)
  *         {
  *             for (nNth = 0; oTrail != OBJECT_INVALID; nNth++)
  *             {
  *                 for (nTrailLast = 2; oTrailLast != OBJECT_INVALID; nTrailLast++)
  *                 {
  *                     do
  *                     {
  *                         // Get next duplicate
  *                     }
  *                     while (GetArea(oTrailLast) != oArea);
  *
  *                     // Count trail length
  *                 }
  *                 // Cache info on the trails
  *                 // Register trails with both landmarks
  *             }
  *         }
  *     }
  *
  * Unfortunately, this algorithm is O(nArea * nLMCount^2) or O(n^2). The
  * good news is that we only need to no this once to initialize.
  */
void _EnumerateTrails(int nLM1 = 1, int nLM2 = 1, int nNth = 0, int nMaxLM = -1)
{
    ai_DebugStart("_EnumerateTrails nLM1='"+IntToString(nLM1)+"' nLM2='"+IntToString(nLM2)+"' nNth='"+IntToString(nNth)+"' nMaxLM='"+IntToString(nMaxLM)+"'", AI_DEBUG_TOOLKIT);

    object  oArea, oLM1, oLM2, oTrailFirst, oTrailLast, oTrailLastPrev, oModule = GetModule();
    int     nLM1Index, nLM2Index, nTrailLast, nTrailLastDupe, nChunk, nTrailDupe;
    string  sTrail, sTrailFirst, sTrailLast;
    float   fTrailLength;

    // If this is the first run, do some initialization
    if (nMaxLM <= 0)
        nMaxLM = GetLocalInt(oModule, LM_LANDMARKS);

    // Only process exactly one chunk to avoid TMI
    for (nChunk = 0; nChunk < EnumerateTrailsChunk; nChunk++)
    {
        // The trail name is the same, regardless of duplicates
        sTrail      = LM_LOCAL_TRAIL_PREFIX + _ZeroIntToString(nLM1) + "_" + _ZeroIntToString(nLM2) + "_";
        sTrailFirst = sTrail + "01";

        // Get the first trail waypoint (if available)
        oTrailFirst = GetObjectByTag(sTrailFirst, nNth);
        if (!GetIsObjectValid(oTrailFirst))
        {
            // No more duplicates, try the next trail
            nNth = 0;
            nLM2++;
            if (nLM2 > nMaxLM)
            {
                nLM2 = 0;
                nLM1++;

                // If we are totally done
                if (nLM1 > nMaxLM)
                {
                    // Schedule EnumerateTrails() to run again
                    DelayCommand(0.0, EnumerateTrails(TRUE));
                    ai_DebugEnd();
                    return;
                }
            }
            continue;
        }

        // Pseudo exception loop
        do
        {
            oArea  = GetArea(oTrailFirst);

            // Get the two landmarks being linked together
            nLM1Index = GetLocalInt(oArea, LM_LANDMARK_PREFIX + _ZeroIntToString(nLM1));
            oLM1      = ai_GetObjectByIndex(oArea, nLM1Index, LM_LANDMARKS);
            if (!GetIsObjectValid(oLM1))
            {
                ai_PrintString("WARNING: ["+GetTag(oArea)+"] "+sTrailFirst+" references non-existant "+LM_LANDMARK_PREFIX+_ZeroIntToString(nLM1)+"!");
                break;
            }

            nLM2Index = GetLocalInt(oArea, LM_LANDMARK_PREFIX + _ZeroIntToString(nLM2));
            oLM2      = ai_GetObjectByIndex(oArea, nLM2Index, LM_LANDMARKS);
            if (!GetIsObjectValid(oLM2))
            {
                ai_PrintString("WARNING: ["+GetTag(oArea)+"] "+sTrailFirst+" references non-existant "+LM_LANDMARK_PREFIX+_ZeroIntToString(nLM2)+"!");
                break;
            }

            // This sucks, but we need to know the trail length
            fTrailLength   = GetDistanceBetween(oLM1, oTrailFirst);
            oTrailLastPrev = oTrailFirst;
            for (nTrailLast = 2; nTrailLast <= 99; nTrailLast++)
            {
                sTrailLast = sTrail + _ZeroIntToString(nTrailLast);

                // We need to find the potential trail end in the same area
                oTrailLast = GetNearestWaypointByTag(sTrailLast, oTrailFirst);
                if (!GetIsObjectValid(oTrailLast))
                {
                    // We can't find the next step, we're done
                    nTrailLast = 100;
                    break;
                }

                // We've found the next step in the trail
                fTrailLength  += GetDistanceBetween(oTrailLastPrev, oTrailLast);
                oTrailLastPrev = oTrailLast;
            }

            oTrailLast    = oTrailLastPrev;
            fTrailLength += GetDistanceBetween(oTrailLast, oLM2);

            ai_PrintString("New local trail '" + sTrailFirst + "' in '" + GetTag(oArea) + "'");

            // Cache results on the "01" waypoint
            SetLocalObject(oTrailFirst, LM_LANDMARK_NEAR, oLM1);
            SetLocalObject(oTrailFirst, LM_LANDMARK_FAR,  oLM2);
            SetLocalObject(oTrailFirst, LM_TRAIL_NEAR,    oTrailFirst);
            SetLocalObject(oTrailFirst, LM_TRAIL_FAR,     oTrailLast);
            SetLocalFloat (oTrailFirst, LM_WEIGHT_DIST,   fTrailLength);

            // Register the route on the far landmark
            ai_AddRoute(oArea, oLM2, oLM1, oTrailFirst, fTrailLength, _GetSuffix(GetTag(oLM1)), 0);

            // Register adjacent at the destination
            ai_AddObjectRef(oLM1, oTrailFirst, LM_TRAILS);

            // Cache results on the "nn" waypoint
            if (oTrailFirst != oTrailLast)
            {
                SetLocalObject(oTrailLast, LM_LANDMARK_NEAR, oLM2);
                SetLocalObject(oTrailLast, LM_LANDMARK_FAR,  oLM1);
                SetLocalObject(oTrailLast, LM_TRAIL_NEAR,    oTrailLast);
                SetLocalObject(oTrailLast, LM_TRAIL_FAR,     oTrailFirst);
                SetLocalFloat (oTrailLast, LM_WEIGHT_DIST,   fTrailLength);
            }

            // Register the route on the near landmark
            ai_AddRoute(oArea, oLM1, oLM2, oTrailFirst, fTrailLength, _GetSuffix(GetTag(oLM2)), 0);

            // Register adjacent at the destination
            ai_AddObjectRef(oLM2, oTrailLast, LM_TRAILS);
        }
        while (FALSE);

        // The alternative is to drop the exception loop and increment at the
        // top. But then nNth does not reflect the current duplicate we're on.

        // We increment the duplicate counter after processing.
        nNth++;
    }

    // We exceeded our chunk, self-schedule again
    DelayCommand(0.0, _EnumerateTrails(nLM1, nLM2, nNth, nMaxLM));

    ai_DebugEnd();
}

/**
  * Detect Area Local Trail Waypoints
  *
  * This function schedules the _EnumerateTrails() "thread" and then "waits"
  * until the processing of _EnumerateTrails() is complete. Once complete, it
  * schedules the next phase of landmark processing.
  *
  * Trails are single paths that connect landmarks together. Trails are bi-
  * directional.
  *
  * Trails have tags of the form: "LT_" + <ID1> + "_" + <ID2> + "_" + <Count>,
  * where <ID1> and <ID2> are numbers identifying the two area-local landmarks
  * that they connect. This implies that a pair of local landmarks cannot be
  * connected by more than one trail. Warnings will be logged if the landmark
  * ID numbers are not valid.
  *
  * The <Count> field is a two-digit number that sets the walking order of
  * waypoints within the same trail. A valid trail must begin with a count of
  * "01". Otherwise it will not be detected properly.
  */
void EnumerateTrails(int bDone = FALSE)
{
    ai_DebugStart("EnumerateTrails bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    object oModule = GetModule();

    // If we're being invoked for the first time
    if (!bDone)
    {
        // Send progress message here

        // Start enumerating landmarks by scheduling _EnumerateLandmarks()
        DelayCommand(0.0, _EnumerateTrails());

    // Otherwise, we're being called because _EnumerateLandmarks() is done
    }
    else
    {
        // Call "EnumerateGatewayTrails" to enter next phase
        EnumerateGatewayTrails();
    }

    ai_DebugEnd();
}

/**
  * Gateways Trail Waypoints Detection "Thread"
  *
  * This function repeatedly self-schedules via DelayCommand() to do the
  * actual trail detection. When it is complete, it will call
  * EnumerateGatewayTrails(TRUE) to indicate that it is done.
  *
  * We are simulating the following loop:
  *     for (iGM = 1; iGM < iMaxGM; iGM++) {
  *         for (iLM = 1; iLM < iMaxLM; iLM++) {
  *             for (nNth = 0; oTrail != OBJECT_INVALID; nNth++) {
  *                 for (iTrailLast = 2; oTrailLast != OBJECT_INVALID; iTrailLast++) {
  *                     do {
  *                         // Get next duplicate
  *                     } while (GetArea(oTrailLast) != oArea);
  *
  *                     // Count trail length
  *                 }
  *                 // Cache info on the trails
  *                 // Register trails with both landmarks
  *             }
  *         }
  *     }
  *
  * Unfortunately, this algorithm is O(iArea * iLMCount^2) or O(n^2). The
  * good news is that we only need to so this once to initialize.
  */
void _EnumerateGatewayTrails(int nGW = 1, int nLM = 1, int nNth = 0, int nMaxGW = -1, int nMaxLM = -1)
{
    ai_DebugStart("_EnumerateGatewayTrails nGW='"+IntToString(nGW)+"' nLM='"+IntToString(nLM)+"' nNth='"+IntToString(nNth)+"' nMaxGW='"+IntToString(nMaxGW)+"' nMaxLM='"+IntToString(nMaxLM)+"'", AI_DEBUG_TOOLKIT);

    object oArea, oGW, oLM, oTrailFirst, oTrailLast, oTrailLastPrev, oModule = GetModule();
    int    nGWIndex, nLMIndex, nTrailLast, nTrailLastDupe, nChunk, nTrailDupe;
    string sLM, sTrail, sTrailFirst, sTrailLast;
    float  fTrailLength;

    // If this is the first run, do some initialization
    if (nMaxGW <= 0)
        nMaxGW = GetLocalInt(oModule, LM_GATEWAYS);

    if (nMaxLM <= 0)
        nMaxLM = GetLocalInt(oModule, LM_LANDMARKS);

    // Only process exactly one chunk to avoid TMI
    for (nChunk = 0; nChunk < EnumerateTrailsChunk; nChunk++)
    {
        // The trail name is the same, regardless of duplicates
        sTrail      = LM_GATEWAY_TRAIL_PREFIX + _ZeroIntToString(nGW) + "_" + _ZeroIntToString(nLM) + "_";
        sTrailFirst = sTrail + "01";

        // Get the first trail waypoint (if available)
        oTrailFirst = GetObjectByTag(sTrailFirst, nNth);
        if (!GetIsObjectValid(oTrailFirst))
        {
            // No more duplicates, try the next trail
            nNth = 0;
            nLM++;
            if (nLM > nMaxLM)
            {
                nLM = 0;
                nGW++;

                // If we are totally done
                if (nGW > nMaxGW)
                {
                    // Schedule EnumerateGatewayTrails() to run again
                    DelayCommand(0.0, EnumerateGatewayTrails(TRUE));
                    ai_DebugEnd();
                    return;
                }
            }
            continue;
        }

        // Pseudo exception loop
        do
        {
            oArea  = GetArea(oTrailFirst);

            // Get the two landmarks being linked together
            nGWIndex = GetLocalInt(oArea, LM_GATEWAY_PREFIX + IntToString(nGW));
            oGW      = ai_GetObjectByIndex(oArea, nGWIndex, LM_GATEWAYS);
            if (!GetIsObjectValid(oGW))
            {
                ai_PrintString("WARNING: ["+GetTag(oArea)+"] "+sTrailFirst+" references non-existant "+LM_GATEWAY_PREFIX+_ZeroIntToString(nGW)+"!");
                break;
            }

            nLMIndex = GetLocalInt(oArea, LM_LANDMARK_PREFIX + IntToString(nLM));
            oLM      = ai_GetObjectByIndex(oArea, nLMIndex, LM_LANDMARKS);
            if (!GetIsObjectValid(oLM))
            {
                ai_PrintString("WARNING: ["+GetTag(oArea)+"] "+sTrailFirst+" references non-existant "+LM_LANDMARK_PREFIX+_ZeroIntToString(nLM)+"!");
                break;
            }
            sLM = GetTag(oLM);

            // This sucks, but we need to know the trail length
            fTrailLength   = GetDistanceBetween(oGW, oTrailFirst);
            oTrailLastPrev = oTrailFirst;
            for (nTrailLast = 2; nTrailLast <= 99; nTrailLast++)
            {
                sTrailLast = sTrail + _ZeroIntToString(nTrailLast);

                // We need to find the potential trail end in the same area
                for (nTrailLastDupe = 0; ; nTrailLastDupe++)
                {
                    oTrailLast = GetNearestWaypointByTag(sTrailLast, oTrailFirst, nTrailLastDupe);
                    if (!GetIsObjectValid(oTrailLast))
                    {
                        // We can't find the next step, we're done
                        nTrailLast = 100;
                        break;
                    }

                    // If we've found the next step in the trail
                    fTrailLength  += GetDistanceBetween(oTrailLastPrev, oTrailLast);
                    oTrailLastPrev = oTrailLast;
                }
            }
            oTrailLast    = oTrailLastPrev;
            fTrailLength += GetDistanceBetween(oTrailLast, oLM);

            ai_PrintString("New gateway trail '" + sTrailFirst + "' in '" + GetTag(oArea) + "' from '" + GetTag(oGW) + "' to '" + sLM + "'");

            // If we haven't registered the landmark as a gateway
            if (!GetLocalInt(oArea, LM_LANDMARK_GATE + sLM))
            {
                ai_PrintString("Registering '" + sLM + "' as a gateway landmark");
                ai_AddObjectRef(oArea, oLM, LM_LANDMARK_GATES);
                SetLocalInt(oArea, LM_LANDMARK_GATE + sLM, TRUE);
            }

            ai_AddObjectRef(oLM, oGW, LM_GATEWAYS);

            // Cache results on the "01" waypoint
            SetLocalObject(oTrailFirst, LM_LANDMARK_NEAR, oGW);
            SetLocalObject(oTrailFirst, LM_LANDMARK_FAR,  oLM);
            SetLocalObject(oTrailFirst, LM_TRAIL_NEAR,    oTrailFirst);
            SetLocalObject(oTrailFirst, LM_TRAIL_FAR,     oTrailLast);
            SetLocalFloat (oTrailFirst, LM_WEIGHT_DIST,   fTrailLength);

            // Register the route on the gateway
            SetLocalObject(oGW, LM_LANDMARKS, oLM);
            SetLocalObject(oGW, LM_TRAILS,    oTrailFirst);

            // Cache results on the "nn" waypoint
            if (oTrailFirst == oTrailLast)
            {
                SetLocalObject(oTrailLast, LM_LANDMARK_FAR,  oGW);
                SetLocalObject(oTrailLast, LM_LANDMARK_NEAR, oLM);
                SetLocalObject(oTrailLast, LM_TRAIL_NEAR,    oTrailLast);
                SetLocalObject(oTrailLast, LM_TRAIL_FAR,     oTrailFirst);
                SetLocalFloat (oTrailLast, LM_WEIGHT_DIST,   fTrailLength);
            }

            // Register the route on the gateway landmark
            SetLocalObject(oLM, LM_GATEWAY,     oGW);
            SetLocalObject(oLM, LM_GATE_TRAILS, oTrailLast);
        }
        while (FALSE);

        // The alternative is to drop the exception loop and increment at the
        // top. But then nNth does not reflect the current duplicate we're on.

        // We increment the duplicate counter after processing.
        nNth++;
    }

    // We exceeded our chunk, self-schedule again
    DelayCommand(0.0, _EnumerateGatewayTrails(nGW, nLM, nNth, nMaxGW, nMaxLM));

    ai_DebugEnd();
}

/*
 * Detect Gateways Trail Waypoints
 *
 * This function schedules the _EnumerateGateTrails() "thread" and then
 * enters a self-scheduled "loop" via DelayCommand() until the processing of
 * _EnumerateGateTrails() is complete. Once complete, it schedules the next
 * phase of landmark processing.
 *
 * Gateway trails are single paths that connect an area-local landmark with
 * a cross-area gateway landmark. Gateway trails are bi-directional.
 *
 * Gateway trails have tags of the form: "GT_" + <IDG> + "_" + <IDL> + <Count>,
 * where <IDG> is a two digit number identifying the gateway landmark that
 * the trail connects to. The <IDL> field is a two digit number identifying
 * the area-local landmark that the trail connects to. Warnings will be logged
 * if either <IDG> or <IDL> are not valid.
 *
 * The <Count> field sets the walking order of waypoints within the
 * same trail. A valid trail must begin with a count of "01". Otherwise it
 * will not be detected properly.
 */
void EnumerateGatewayTrails(int bDone = FALSE)
{
    ai_DebugStart("EnumerateGatewayTrails bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    object oModule = GetModule();

    // If we're being invoked for the first time
    if (!bDone)
    {
        // Send progress message here

        // Start enumerating landmarks by scheduling _EnumerateLandmarks()
        DelayCommand(0.0, _EnumerateGatewayTrails());
    }
    else
    {
        // Otherwise, we're being called because _EnumerateLandmarks() is done
        // TODO: Delete flags on area

        // Call "UpdateLandmarks" to enter next phase
        UpdateLandmarks();
    }

    ai_DebugEnd();
}

/*
 * Local Landmark Routing Table Construction "Thread"
 *
 * This function repeatedly self-schedules via DelayCommand() to construct each
 * landmark's routing table. When it is complete, it will call
 * UpdateLandmarks(TRUE) to indicate that it is done.
 *
 * We are simulating the following loop:
 *  for (iArea = 0; iArea < iAreas; iArea++) {
 *      while (Area routing tables have not stabilized) {
 *          for (iLM = 0; iLM < iLMs; iLM++) {
 *              for (iAdjLM = 0; iAdjLM < iAdjLMs; iAdjLM++) {
 *                  // Merge routing table
 *              }
 *          }
 *      }
 *  }
 *
 * NOTE: We can trim some fat by just keeping the shortest path info.
 */
void _UpdateLandmarks(object oModule,
                      int nArea,     int nLastArea,     object oArea,
                      int nLM,       int nLastLM,       object oLM,
                      int nAdjTrail, int nLastAdjTrail)
{
    ai_DebugStart("_UpdateLandmarks oModule='"+GetTag(oModule)+"' nArea='"+IntToString(nArea)+"' nLastArea='"+IntToString(nLastArea)+"' oArea='"+GetTag(oArea)+"' nLM='"+IntToString(nLM)+"' nLastLM='"+IntToString(nLastLM)+"' oLM='"+GetTag(oLM)+"' nAdjTrail='"+IntToString(nAdjTrail)+"' nLastAdjTrail='"+IntToString(nLastAdjTrail)+"'", AI_DEBUG_TOOLKIT);

    object oAdjTrail, oAdjLM, oDest;
    string sRouteTrail, sRouteWeight, sRoutePath, sRouteShortest, sPath;
    int    i, j, reach, shortest, nRouteShortest;
    float  fLen, fAdjLen;

    // oAdjTrail changes each time through this function
    oAdjTrail = ai_GetObjectByIndex(oLM, nAdjTrail, LM_TRAILS);
    fAdjLen   = GetLocalFloat      (oAdjTrail, LM_WEIGHT_DIST);
    oAdjLM    = GetLocalObject     (oAdjTrail, LM_LANDMARK_FAR);
    if (oAdjLM == oLM)
        oAdjLM = GetLocalObject(oAdjTrail, LM_LANDMARK_NEAR);

    ai_PrintString("Looking at adjacent landmark: "+GetTag(oAdjLM));

    // Loop through neighbour's reachable landmarks
    reach = ai_GetObjectCount(oAdjLM, LM_DEST);
    ai_PrintString("Reachable landmarks: "+IntToString(reach));
    for (i = 0; i < reach; i++)
    {
        // Get the next reachable landmark
        oDest = ai_GetObjectByIndex(oAdjLM, i, LM_DEST);
        ai_PrintString("Examining destination: "+GetTag(oDest));

        // Skip route to self
        if (oDest != oLM)
        {
            // Lookup the reachable landmark in the routing table
            sRouteTrail    = LM_ROUTE_TRAIL    +GetTag(oDest);
            sRouteWeight   = LM_ROUTE_WEIGHT   +GetTag(oDest);
            sRoutePath     = LM_ROUTE_PATH     +GetTag(oDest);
            sRouteShortest = LM_ROUTE_SHORTEST +GetTag(oDest);

            // All of the shortest routes have the same length, get it once
            fLen = ai_GetFloatByIndex(oAdjLM, ai_GetIntByIndex(oAdjLM, 0, sRouteShortest), sRouteWeight);
            if (fLen == 0.0)
                ai_PrintString("WARNING: Zero length is the shortest!?!?!");

            // Process the shortest route cache
            shortest = ai_GetIntCount(oAdjLM, sRouteShortest);
            ai_PrintString("Shortest Routes: "+IntToString(shortest));
            for (j = 0; j < shortest; j++) {
                nRouteShortest = ai_GetIntByIndex(oAdjLM, j, sRouteShortest);
                sPath = ai_GetStringByIndex(oAdjLM, nRouteShortest, sRoutePath);
                ai_PrintString("1: "+sPath+" ? "+_GetSuffix(GetTag(oLM)));

                // Prevent routing loops
                if (FindSubString(sPath, _GetSuffix(GetTag(oLM))) == -1)
                {
                    // Add the route
                    ai_AddRoute(oArea, oLM, oDest, oAdjTrail, fLen + fAdjLen, sPath, 0);
                    break;
                }
            }
        }
    }

    // If we're done this landmark
    if (nAdjTrail >= nLastAdjTrail)
    {
        // If we've done this area
        if (nLM >= nLastLM)
        {
            // If the area hasn't changed
            if (!GetLocalInt(oArea, LM_CHANGED))
            {
                // We don't need LM_CHANGED anymore
                DeleteLocalInt(oArea, LM_CHANGED);

                if (nArea >= nLastArea)
                {
                    // We're done with landmark processing
                    DelayCommand(0.0, UpdateLandmarks(TRUE));
                    ai_DebugEnd();
                    return;
                }

                // Work on the next area
                nArea++;
                oArea   = ai_GetObjectByIndex(oModule, nArea, LM_AREAS);
                nLastLM = ai_GetObjectCount(oArea, LM_LANDMARKS) - 1;
                DeleteLocalInt(oArea, LM_CHANGED);
            }

            // Regardless of what happens, we're starting an area from scratch
            SetLocalInt(oArea, LM_CHANGED, 0);
            nLM = 0;
        }
        else
        {
            // Otherwise, more landmarks to go in the area
            nLM++;
        }

        // Regardless of what happens, we're working on a different landmark
        oLM = ai_GetObjectByIndex(oArea, nLM, LM_LANDMARKS);
        nLastAdjTrail = ai_GetObjectCount(oLM, LM_TRAILS) - 1;
        nAdjTrail = 0;
    }
    else
    {
        // Otherwise, more adjacent trails to go in the landmark
        nAdjTrail++;
    }

    // Regardless of what happens, we're working on a different adjacent trail
    ai_GetObjectByIndex(oLM, nAdjTrail, LM_TRAILS);

    // Self-schedule
    DelayCommand(0.0, _UpdateLandmarks(oModule,
                                       nArea,     nLastArea, oArea,
                                       nLM,       nLastLM,   oLM,
                                       nAdjTrail, nLastAdjTrail));

    ai_DebugEnd();
}

/*
 * Local Landmark Routing Table Construction
 *
 * This function schedules the _UpdateLandmarks() "thread" and then enters a
 * self-scheduled "loop" via DelayCommand() until the processing of
 * _UpdateLandmarks() is complete. Once complete, it schedules the next phase
 * of landmark processing.
 */
void UpdateLandmarks(int bDone = FALSE)
{
    ai_DebugStart("UpdateLandmarks bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    // If we're being invoked for the first time
    if (!bDone)
    {
        // Send progress message here

        // Start enumerating landmarks by scheduling _UpdateLandmarks()
        object  oModule = GetModule();
        object  oArea   = ai_GetObjectByIndex(oModule, 0, LM_AREAS);
        object  oLM     = ai_GetObjectByIndex(oArea,   0, LM_LANDMARKS);
        DelayCommand(0.0, _UpdateLandmarks(oModule,    0, ai_GetObjectCount(oModule, LM_AREAS) - 1,
                                           oArea,      0, ai_GetObjectCount(oArea,   LM_LANDMARKS) - 1,
                                           oLM,        0, ai_GetObjectCount(oLM,     LM_TRAILS) - 1));

    // Otherwise, we're being called because _EnumerateLandmarks() is done
    }
    else
    {
        // Dump the routing tables from each area
        //object oArea, oModule = GetModule();
        //int    i, count = ai_GetObjectCount(oModule, i, LM_AREAS);
        //for (i = 0; i < count; i++)
        //{
        //    oArea = ai_GetObjectByIndex(oModule, i, LM_AREAS);
        //    DelayCommand(0.0, ai_DumpLandmarks(oArea));
        //}

        // Call AdjacentGateways() to enter next phase
        AdjacentGateways();
    }

    ai_DebugEnd();
}

void _AdjacentGateways(object oModule,
                       int nArea, int nLastArea, object oArea,
                       int nLM,   int nLastLM,   object oLM,
                       int nAdjLM,               object oAdjLM)
{
    ai_DebugStart("_AdjacentGateways oModule='"+GetTag(oModule)+"' nArea='"+IntToString(nArea)+"' nLastArea='"+IntToString(nLastArea)+"' oArea='"+GetTag(oArea)+"' nLM='"+IntToString(nLM)+"' nLastLM='"+IntToString(nLastLM)+"' oLM='"+GetTag(oLM)+"' nAdjLM='"+IntToString(nAdjLM)+"' oAdjLM='"+GetTag(oAdjLM)+"'", AI_DEBUG_TOOLKIT);

    string  sArea, sAdjLM, sLMGate;
    object  oLMGate;
    float   fWeight;
    int     index;

    if (nLM == nAdjLM)
    {
        ai_PrintString("Inter-area adjacency");

        // Connect to remote area
        oLMGate = GetLocalObject(GetLocalObject(GetLocalObject(oLM, LM_GATEWAY), LM_GATEWAY), LM_LANDMARKS);
        sLMGate = GetTag(oLMGate);
        fWeight = GetLocalFloat(GetLocalObject(oLM,     LM_GATE_TRAILS), LM_WEIGHT_DIST) +
                  GetLocalFloat(GetLocalObject(oLMGate, LM_GATE_TRAILS), LM_WEIGHT_DIST);

        // Register adjacent gateway landmarks
        ai_AddObjectRef(oLM, oLMGate, LM_LANDMARK_GATES);
//        ai_AddObjectRef(oLMGate, oLM, LM_LANDMARK_GATES);

        ai_AddRoute(oModule, oLM, oLMGate, OBJECT_INVALID, fWeight, GetTag(GetArea(oLMGate))+_GetSuffix(sLMGate), TRUE);
//        ai_AddRoute(oModule, oLMGate, oLM, OBJECT_INVALID, fWeight, GetTag(oArea)+_GetSuffix(GetTag(oLM)), TRUE);

    }
    else
    {
        ai_PrintString("Intra-area adjacency");

        /* Only associate with reachable gateways */
        sAdjLM = GetTag(oAdjLM);
        if (ai_GetObjectCount(oLM, LM_ROUTE_TRAIL+sAdjLM))
        {
            index   = ai_GetIntByIndex  (oLM, 0,     LM_ROUTE_SHORTEST+sAdjLM);
            fWeight = ai_GetFloatByIndex(oLM, index, LM_ROUTE_WEIGHT  +sAdjLM);

            sArea = GetTag(oArea);

            // Register adjacent gateway landmarks
            ai_AddObjectRef(oLM, oAdjLM, LM_LANDMARK_GATES);
            ai_AddObjectRef(oAdjLM, oLM, LM_LANDMARK_GATES);

            ai_AddRoute(oModule, oLM, oAdjLM, OBJECT_INVALID, fWeight, sArea+_GetSuffix(sAdjLM), 1);
            ai_AddRoute(oModule, oAdjLM, oLM, OBJECT_INVALID, fWeight, sArea+_GetSuffix(GetTag(oLM)), 1);
        }
    }

    // Examine the next adjacent landmark
    if (nAdjLM >= nLastLM)
    {
        if (nLM >= nLastLM)
        {
            nLM = 0;
            if (nArea >= nLastArea)
            {
                // Done
                DelayCommand(0.0, AdjacentGateways(TRUE));
                ai_DebugEnd();
                return;
            }
            else
            {
                nArea++;
                oArea   = ai_GetObjectByIndex(oModule, nArea, LM_AREAS);
                nLastLM = ai_GetObjectCount  (oArea,          LM_LANDMARK_GATES) - 1;
            }

        }
        else
            nLM++;

        oLM    = ai_GetObjectByIndex(oArea, nLM, LM_LANDMARK_GATES);
        nAdjLM = nLM;
    }
    else
        nAdjLM++;

    oAdjLM = ai_GetObjectByIndex(oArea, nAdjLM, LM_LANDMARK_GATES);

    // Self-schedule
    DelayCommand(0.0, _AdjacentGateways(oModule,
                                        nArea,  nLastArea, oArea,
                                        nLM,    nLastLM,   oLM,
                                        nAdjLM,            oAdjLM));

    ai_DebugEnd();
}

void AdjacentGateways(int bDone = FALSE)
{
    ai_DebugStart("AdjacentGateways bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    // If we're being invoked for the first time
    if (!bDone)
    {
        // Send progress message here

        // Start processing gateway adjacency by scheduling _AdjacentGateways()
        object oModule = GetModule();
        object oArea   = ai_GetObjectByIndex(oModule, 0, LM_AREAS);
        object oLM     = ai_GetObjectByIndex(oArea,   0, LM_LANDMARK_GATE);
        DelayCommand(0.0, _AdjacentGateways (oModule, 0, ai_GetObjectCount(oModule, LM_AREAS) - 1,
                                             oArea,   0, ai_GetObjectCount(oArea,   LM_LANDMARK_GATE) - 1,
                                             oLM,     0, oLM));
    }
    else
    {
        // Otherwise, we're being called because _AdjacentGateways() is done
        // Dump the routing tables from each area to the log
        //object oArea, oModule  = GetModule();
        //int    i, count = ai_GetObjectCount(oModule, i, LM_AREAS);
        //for (i = 0; i < count; i++)
        //{
        //    oArea = ai_GetObjectByIndex(oModule, i, LM_AREAS);
        //    DelayCommand(0.0, ai_DumpLandmarks(oArea));
        //}

        // Call UpdateGateways() to enter next phase
        UpdateGateways();
    }

    ai_DebugEnd();
}

void _UpdateGateways(object oModule,
                     int nArea,  int nLastArea,  object oArea,
                     int nLM,    int nLastLM,    object oLM,
                     int nAdjLM, int nLastAdjLM, object oAdjLM)
{
    ai_DebugStart("_UpdateGateways oModule='"+GetTag(oModule)+"' nArea='"+IntToString(nArea)+"' nLastArea='"+IntToString(nLastArea)+"' oArea='"+GetTag(oArea)+"' nLM='"+IntToString(nLM)+"' nLastLM='"+IntToString(nLastLM)+"' oLM='"+GetTag(oLM)+"' nAdjLM='"+IntToString(nAdjLM)+"' nLastAdjLM='"+IntToString(nLastAdjLM)+"' oAdjLM='"+GetTag(oAdjLM)+"'", AI_DEBUG_TOOLKIT);

    object oAdjArea, oDest;
    string sAdjLM, sRouteTrail, sRouteWeight, sRoutePath, sRouteShortest, sPath;
    int    i, j, reach, shortest, nRouteShortest;
    float  fAdjLen, fLen;

    oAdjArea = GetArea(oAdjLM);
    sAdjLM   = GetTag(oAdjLM);
    fAdjLen  = ai_GetFloatByIndex(oLM, 0, LM_ROUTE_WEIGHT + GetTag(oAdjArea) + sAdjLM);
    ai_PrintString("Looking at adjacent gateway landmark: "+sAdjLM+"("+GetTag(oAdjArea)+")");

    // Loop through neighbour's reachable landmarks
    reach = ai_GetObjectCount(oAdjLM, LM_GATE_DEST);
    ai_PrintString("Reachable gateway landmarks: "+IntToString(reach));
    for (i = 0; i < reach; i++)
    {
        // Get the next reachable landmark
        oDest = ai_GetObjectByIndex(oAdjLM, i, LM_GATE_DEST);
        ai_PrintString("Examining destination: "+GetTag(oDest)+"("+GetTag(GetArea(oDest))+")");

        // Skip route to self
        if (oDest != oLM)
        {
            // Lookup the reachable landmark in the routing table
            sRouteTrail    = LM_GATE_ROUTE_TRAIL    +GetTag(GetArea(oDest))+GetTag(oDest);
            sRouteWeight   = LM_GATE_ROUTE_WEIGHT   +GetTag(GetArea(oDest))+GetTag(oDest);
            sRoutePath     = LM_GATE_ROUTE_PATH     +GetTag(GetArea(oDest))+GetTag(oDest);
            sRouteShortest = LM_GATE_ROUTE_SHORTEST +GetTag(GetArea(oDest))+GetTag(oDest);

            // All of the shortest routes have the same length, get it once
            fLen = ai_GetFloatByIndex(oAdjLM, ai_GetIntByIndex(oAdjLM, 0, sRouteShortest), sRouteWeight);
            if (fLen == 0.0)
                ai_PrintString("WARNING: Zero length is the shortest!?!?!");

            // Process the shortest route cache
            shortest = ai_GetIntCount(oAdjLM, sRouteShortest);
            ai_PrintString("Shortest Routes: "+IntToString(shortest));
            for (j = 0; j < shortest; j++)
            {
                nRouteShortest = ai_GetIntByIndex(oAdjLM, j, sRouteShortest);
                sPath = ai_GetStringByIndex(oAdjLM, nRouteShortest, sRoutePath);
                ai_PrintString("1: "+sPath+" ? "+GetTag(GetArea(oLM))+_GetSuffix(GetTag(oLM)));

                // Prevent routing loops
                if (FindSubString(sPath, GetTag(GetArea(oLM))+_GetSuffix(GetTag(oLM))) == -1)
                {
                    // Add the route
                    ai_AddRoute(oModule, oLM, oDest, OBJECT_INVALID, fLen + fAdjLen, sPath, TRUE);
                    break;
                }
            }
        }
    }

    // If we're done this landmark
    if (nAdjLM >= nLastAdjLM)
    {
        // If we're done this area
        if (nLM >= nLastLM)
        {
            // If we're done this module
            if (nArea >= nLastArea)
            {
                // If the module hadsn't changed
                if (!GetLocalInt(oModule, LM_CHANGED))
                {
                    // We don't need LM_Changed anymore
                    DeleteLocalInt(oModule, LM_CHANGED);

                    // We're done gateway processing
                    DelayCommand(0.0, UpdateGateways(TRUE));
                    ai_DebugEnd();
                    return;
                }
                else
                {
                    // Otherwise, do the module again
                    SetLocalInt(oModule, LM_CHANGED, 0);
                    nArea = 0;
                }
            }
            else
            {
                // Otherwise, more areas to go in the module
                // Work on the next area
                nArea++;
            }

            // Regardless of what happens, we're starting an area from scratch
            oArea   = ai_GetObjectByIndex(oModule, nArea, LM_AREAS);
            nLastLM = ai_GetObjectCount(oArea, LM_LANDMARKS) - 1;
            nLM = 0;
        }
        else
        {
            // Otherwise, more landmarks to go in the area
            nLM++;
        }

        // Regardless of what happens, we're working on a different landmark
        oLM = ai_GetObjectByIndex(oArea, nLM, LM_GATEWAYS);
        nLastAdjLM = ai_GetObjectCount(oLM, LM_GATEWAYS) - 1;
        nAdjLM = 0;
    }
    else
    {
        // Otherwise, more adjacent trails to go in the landmark
        nAdjLM++;
    }

    // Regardless of what happens, we're working on a different adjacent landmark
    oAdjLM = ai_GetObjectByIndex(oLM, nAdjLM, LM_GATEWAYS);

    // Self-schedule
    DelayCommand(0.0, _UpdateGateways(oModule,
                                      nArea,  nLastArea,  oArea,
                                      nLM,    nLastLM,    oLM,
                                      nAdjLM, nLastAdjLM, oAdjLM));

    ai_DebugEnd();
}

void UpdateGateways(int bDone = FALSE)
{
    ai_DebugStart("UpdateGateways bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    // If we're being invoked for the first time
    if (!bDone)
    {
        // Send progress message here

        // Start enumerating landmarks by scheduling _UpdateLandmarks()
        object oModule  = GetModule();
        object oArea    = ai_GetObjectByIndex(oModule, 0, LM_AREAS);
        object oGate    = ai_GetObjectByIndex(oArea,   0, LM_GATEWAYS);
        object oAdjGate = ai_GetObjectByIndex(oGate,   0, LM_GATEWAYS);
        DelayCommand(0.0, _UpdateGateways    (oModule, 0, ai_GetObjectCount(oModule, LM_AREAS) - 1,
                                              oArea,   0, ai_GetObjectCount(oArea,   LM_GATEWAYS) - 1,
                                              oGate,   0, ai_GetObjectCount(oGate,   LM_GATEWAYS) - 1, oAdjGate));
    }
    else
    {
        // Otherwise, we're being called because _UpdateGateways() is done
        // Dump the routing tables from each area
        object oArea, oModule = GetModule();
        int i, count = ai_GetObjectCount(oModule, LM_AREAS);

        for (i = 0; i < count; i++)
        {
            oArea = ai_GetObjectByIndex(oModule, i, LM_AREAS);
            DelayCommand(0.0, ai_DumpLandmarks(oArea));
        }

        // Call ai_ProcessLandmarks(TRUE) to enter last phase
        ai_ProcessLandmarks(TRUE);
    }

    ai_DebugEnd();
}

void ai_ProcessLandmarks(int bDone = FALSE)
{
    ai_DebugStart("ai_ProcessLandmarks bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    object oModule = GetModule();

    // If we're being invoked for the first time
    if (!bDone)
    {
        // If the landmark system is not present
        if (!GetLocalInt(oModule, LM_PRESENT))
        {
            // Send progress message here

            // Indicate that the landmark system is busy
            SetLocalInt(oModule, LM_BUSY, TRUE);

            // Indicate that the landmark system is present
            SetLocalInt(oModule, LM_PRESENT, TRUE);

            // Start landmark processing by calling EnumerateLandmarks()
            EnumerateLandmarks();
        }
    }
    else
    {
        // Otherwise, we're being called because landmark processing is done
        // The landmark system is not busy anymore, done
        DeleteLocalInt(oModule, LM_BUSY);
    }

    ai_DebugEnd();
}

/*
 * ai_AddRoute
 *
 * Potentially adds / modifies a routing table entry.
 */
void ai_AddRoute(object oChanged, object oLandmark, object oDest, object oTrail, float fDist, string sPath, int bGate)
{
    ai_DebugStart("ai_AddRoute oChanged='"+GetTag(oChanged)+"' oLandmark='"+GetTag(oLandmark)+"' oDest='"+GetTag(oDest)+"' oTrail='"+GetTag(oTrail)+"' fDist='"+FloatToString(fDist)+"' sPath='"+sPath+"' bGate='"+IntToString(bGate)+"'", AI_DEBUG_TOOLKIT);

    string sRouteShortest, sRouteTrail, sRouteWeight, sRoutePath, sDest, sNewPath;
    float  fShortestLen;
    int    i, count;
    object oEntry;

    if (bGate == 0)
    {
        sDest = GetTag(oDest);
        sRouteShortest = LM_ROUTE_SHORTEST +sDest;
        sRouteTrail    = LM_ROUTE_TRAIL    +sDest;
        sRouteWeight   = LM_ROUTE_WEIGHT   +sDest;
        sRoutePath     = LM_ROUTE_PATH     +sDest;
        sDest          = LM_DEST;
        sNewPath       = sPath+"%"+_GetSuffix(GetTag(oLandmark));
    }
    else
    {
        sDest = GetTag(GetArea(oDest))+GetTag(oDest);
        sRouteShortest = LM_GATE_ROUTE_SHORTEST+sDest;
        sRouteTrail    = LM_GATE_ROUTE_TRAIL   +sDest;
        sRouteWeight   = LM_GATE_ROUTE_WEIGHT  +sDest;
        sRoutePath     = LM_GATE_ROUTE_PATH    +sDest;
        sDest          = LM_GATE_DEST;
        sNewPath       = sPath+"%"+GetTag(GetArea(oDest))+_GetSuffix(GetTag(oLandmark));
    }

    // Search for an existing routing table entry
    count = ai_GetObjectCount(oLandmark, sRouteTrail);
    ai_PrintString("count "+IntToString(count));
    for (i = 0; i < count; i++)
    {
        // If we found the matching entry
        oEntry = ai_GetObjectByIndex(oLandmark, i, sRouteTrail);
        if (bGate)
            ai_PrintString("entry "+IntToString(i)+" "+GetTag(oEntry));
        if ((oEntry == oTrail) || (!(GetIsObjectValid(oEntry)) && !(GetIsObjectValid(oTrail))))
        {
            // Skip larger distances
            if (bGate)
                ai_PrintString("entry dist"+FloatToString(ai_GetFloatByIndex(oLandmark, i, sRouteWeight)));
            if (fDist >= ai_GetFloatByIndex(oLandmark, i, sRouteWeight))
            {
                ai_PrintString("Skipped");
                ai_DebugEnd();
                return;
            }

            // Update with smaller distance
            ai_SetFloatByIndex (oLandmark, i, fDist,    sRouteWeight);
            ai_SetStringByIndex(oLandmark, i, sNewPath, sRoutePath);

            /*
             * Deal with the shortest trail cache
             *
             * If this trail used to be the shortest, it would only change if
             * it got even shorter. In that case, the entire cache would be
             * flushed, so we don't need to worry about duplicates.
             *
             * We are guaranteed that the cache has already been initialized
             */
            fShortestLen = ai_GetFloatByIndex(oLandmark, ai_GetIntByIndex(oLandmark, 0, sRouteShortest), sRouteWeight);
            if (fDist < fShortestLen)
            {
                // Clear the old list
                ai_DeleteIntRefs(oLandmark, sRouteShortest);
            }
            if (fDist == fShortestLen)
            {
                // Register route among shortest
                ai_AddIntRef(oLandmark, i, sRouteShortest);
            }

            // Mark the area / module as changed
            SetLocalInt(oChanged, LM_CHANGED, TRUE);

            ai_PrintString("Updated");
            ai_DebugEnd();
            return;
        }
    }

    // If this destination was not reachable before
    if (count == 0)
    {
        // Register newly reachable landmark
        ai_PrintString("First");
        ai_AddObjectRef(oLandmark, oDest, sDest);

        // Register first route as shortest
        ai_AddIntRef(oLandmark, 0, sRouteShortest);
    }
    else
    {
        /*
         * Deal with shortest path cache
         *
         * At this point we know that one exists, because there's already a
         * a route, just that this is a new way to get there.
         */
        fShortestLen = ai_GetFloatByIndex(oLandmark, ai_GetIntByIndex(oLandmark, 0, sRouteShortest), sRouteWeight);
        if (fDist < fShortestLen)
        {
            // Clear the old list
            ai_DeleteIntRefs(oLandmark, sRouteShortest);
            ai_AddIntRef(oLandmark, count, sRouteShortest);
            ai_PrintString("New shortest");
        }
        if (fDist == fShortestLen)
        {
            // Register new route among shortest
            ai_AddIntRef(oLandmark, count, sRouteShortest);
            ai_PrintString("Another shortest");
        }
    }

    // Add new routing table entry
    ai_AddObjectRef(oLandmark, oTrail,   sRouteTrail);
    ai_AddFloatRef (oLandmark, fDist,    sRouteWeight);
    ai_AddStringRef(oLandmark, sNewPath, sRoutePath);

    // Mark the area / module as changed
    SetLocalInt(oChanged, LM_CHANGED, TRUE);

    ai_PrintString("Added");
    ai_DebugEnd();
}

/*
 * ai_DumpLandmarks
 *
 * Outputs the current state of the routing table for each landmark in the area
 * to the log. The dump is best read in raw text as the indenting is lost when
 * examined in an XML viewer.
 */
void ai_DumpLandmarks(object oArea)
{
    // It gets very expensive looping the routing table for no reason
    if (!ai_IsDebugging(AI_DEBUG_TOOLKIT))
        return;

    ai_DebugStart("ai_DumpLandmarks oArea='"+GetTag(oArea)+"'", AI_DEBUG_TOOLKIT);

    object oLandmark;
    int    i, count = ai_GetObjectCount(oArea, LM_LANDMARKS);

    // Dump every landmark in the area
    for (i = 0; i < count; i++)
    {
        oLandmark = ai_GetObjectByIndex(oArea, i, LM_LANDMARKS);
        DelayCommand(0.0, ai_DumpLandmark(oArea, oLandmark));
    }

    ai_DebugEnd();
}

void ai_DumpLandmark(object oArea, object oLandmark)
{
    // It gets very expensive looping the routing table for no reason
    if (!ai_IsDebugging(AI_DEBUG_TOOLKIT)) return;

    ai_DebugStart("ai_DumpLandmark oArea='"+GetTag(oArea)+"' oLandmark='"+GetTag(oLandmark)+"'", AI_DEBUG_TOOLKIT);

    string sRouteShortest, sRouteTrail, sRouteWeight, sRoutePath, sDest;
    object oDest, oTrail;
    float  fLen;
    int    i, j, dest, trail;

    // Dump every reachable destination from the landmark
    dest = ai_GetObjectCount(oLandmark, LM_DEST);
    for (i = 0; i < dest; i++)
    {
        oDest = ai_GetObjectByIndex(oLandmark, i, LM_DEST);
        sDest = GetTag(oDest);
        ai_PrintString("  Destination: "+sDest);

        sRouteShortest = LM_ROUTE_SHORTEST +sDest;
        sRouteTrail    = LM_ROUTE_TRAIL    +sDest;
        sRouteWeight   = LM_ROUTE_WEIGHT   +sDest;
        sRoutePath     = LM_ROUTE_PATH     +sDest;

        // Dump all routes to the destination
        trail = ai_GetObjectCount(oLandmark, sRouteTrail);
        for (j = 0; j < trail; j++)
        {
            oTrail = ai_GetObjectByIndex(oLandmark, j, sRouteTrail);
            fLen   = ai_GetFloatByIndex (oLandmark, j, sRouteWeight);
            if (fLen == ai_GetFloatByIndex(oLandmark, ai_GetIntByIndex(oLandmark, 0, sRouteShortest), sRouteWeight))
                ai_PrintString("    Via Trail: "+GetTag(oTrail)+" *Distance: "+FloatToString(fLen)+" meters");
            else
                ai_PrintString("    Via Trail: "+GetTag(oTrail)+"  Distance: "+FloatToString(fLen)+" meters");
        }
    }

    // Dump every reachable gateway from the landmark
    dest = ai_GetObjectCount(oLandmark, LM_GATE_DEST);
    for (i = 0; i < dest; i++)
    {
        oDest = ai_GetObjectByIndex(oLandmark, i, LM_GATE_DEST);
        sDest = GetTag(oDest);
        ai_PrintString("  Gateway: "+sDest+" ("+GetTag(GetArea(oDest))+")");

        sDest = GetTag(GetArea(oDest))+GetTag(oDest);
        sRouteShortest = LM_GATE_ROUTE_SHORTEST +sDest;
        sRouteTrail    = LM_GATE_ROUTE_TRAIL    +sDest;
        sRouteWeight   = LM_GATE_ROUTE_WEIGHT   +sDest;
        sRoutePath     = LM_GATE_ROUTE_PATH     +sDest;

        // Dump all routes to the destination
        trail = ai_GetObjectCount(oLandmark, sRouteTrail);
        for (j = 0; j < trail; j++)
        {
            oTrail = ai_GetObjectByIndex(oLandmark, j, sRouteTrail);
            fLen   = ai_GetFloatByIndex (oLandmark, j, sRouteWeight);
            if (fLen == ai_GetFloatByIndex(oLandmark, ai_GetIntByIndex(oLandmark, 0, sRouteShortest), sRouteWeight))
                ai_PrintString("    Via Trail: "+GetTag(oTrail)+" *Distance: "+FloatToString(fLen)+" meters");
            else
                ai_PrintString("    Via Trail: "+GetTag(oTrail)+"  Distance: "+FloatToString(fLen)+" meters");
        }
    }

    ai_DebugEnd();
}


// ----- Public Synchronization Functions --------------------------------------

int ai_IsProcessingLandmarks()
{
    return GetLocalInt(GetModule(), LM_BUSY);
}


// ----- Public Shortest Path Functions  ---------------------------------------

object ai_GetClosestGatewayInArea(object oLocalGateway, object oDestArea)
{
    object oRemoteGateway, oTemp;
    int    i, nGatewayCount = ai_GetObjectCount(oDestArea, LM_LANDMARK_GATES);
    float  fShortest = 9999999.0;
    float  fTemp = 999999.0;

    for (i = 0; i < nGatewayCount; i++)
    {
        oTemp = ai_GetObjectByIndex(oDestArea, i, LM_LANDMARK_GATES);
        fTemp = ai_GetFloatByIndex(oTemp, i, LM_GATE_ROUTE_WEIGHT+GetTag(oLocalGateway));
        if (fTemp < fShortest)
            oRemoteGateway = oTemp;
    }
    return oRemoteGateway;
}

struct TrailVect_s ai_GetShortestTrailFromWP(object oWP, object oDest)
{
    ai_DebugStart("ai_GetShortestTrailFromWP oWP='"+GetTag(oWP)+"' oDest='"+GetTag(oDest)+"'", AI_DEBUG_TOOLKIT);

    struct TrailVect_s stTrail;

    object oLM1 = ai_GetTrailLandmark(oWP, 1);
    object oLM2 = ai_GetTrailLandmark(oWP, -1);

    string sLM1  = GetTag(oLM1);
    string sLM2  = GetTag(oLM2);
    string sDest = GetTag(oDest);

    int    nNextLM1 = GetLocalInt(oLM1, LM_ROUTE_SHORTEST+sDest);
    int    nNextLM2 = GetLocalInt(oLM2, LM_ROUTE_SHORTEST+sDest);

    object oNextLM1 = ai_GetObjectByIndex(oLM1, nNextLM1, LM_ROUTE_TRAIL+sDest);
    object oNextLM2 = ai_GetObjectByIndex(oLM2, nNextLM2, LM_ROUTE_TRAIL+sDest);

    float  fNextLM1 = ai_GetFloatByIndex(oLM1, nNextLM1, LM_ROUTE_WEIGHT+sDest);
    float  fNextLM2 = ai_GetFloatByIndex(oLM2, nNextLM2, LM_ROUTE_WEIGHT+sDest);

    // Initialize the struct values
    stTrail.oWaypoint  = OBJECT_INVALID;
    stTrail.oTrail     = OBJECT_INVALID;
    stTrail.oLandmark  = OBJECT_INVALID;
    stTrail.nDirection = 0;

    if ((!GetIsObjectValid(oNextLM1)) && (!GetIsObjectValid(oNextLM2)))
    {
        ai_DebugEnd();
        return (stTrail);
    }

    if (!GetIsObjectValid(oNextLM1))
    {
        stTrail.oTrail     = oNextLM2;
        stTrail.oLandmark  = ai_GetTrailLandmark(oWP, -1);
        stTrail.nDirection = -1;
    }
    else if (!GetIsObjectValid(oNextLM2))
    {
        stTrail.oTrail     = oNextLM1;
        stTrail.oLandmark  = ai_GetTrailLandmark(oWP, 1);
        stTrail.nDirection = 1;
    }
    else if (fNextLM2 <= fNextLM1)
    {
        stTrail.oTrail     = oNextLM2;
        stTrail.oLandmark  = ai_GetTrailLandmark(oWP, -1);
        stTrail.nDirection = -1;
    }
    else
    {
        stTrail.oTrail     = oNextLM1;
        stTrail.oLandmark  = ai_GetTrailLandmark(oWP, 1);
        stTrail.nDirection = 1;
    }
    stTrail.oWaypoint = oWP;

                    PrintString("stTrail.oWaypoint: "  + GetTag(stTrail.oWaypoint)
                              + " stTrail.oLandmark: " + GetTag(stTrail.oLandmark)
                              + " stTrail.oTrail: "    + GetTag(stTrail.oTrail)
                              + " stTrail.nDirection: "+ IntToString(stTrail.nDirection));


    ai_DebugEnd();
    return (stTrail);
}

struct GatewayVect_s ai_GetShortestGateway(object oLandmark, object oDest)
{
    ai_DebugStart("ai_GetShortestGateway oLandmark='"+GetTag(oLandmark)+"' oDest='"+GetTag(oDest)+"'", AI_DEBUG_TOOLKIT);

    struct GatewayVect_s stBest;

    object oArea, oDestArea, oLGate, oDGate;
    int    nLGateCount, nDGateCount, nLGate, nDGate;
    float  fDist, fBestDist;

    // Initialize
    stBest.oGate     = OBJECT_INVALID;
    stBest.oDestGate = OBJECT_INVALID;
    oArea            = GetArea(oLandmark);
    oDestArea        = GetArea(oDest);

    // Of all the local gateways...
    nLGateCount = ai_GetObjectCount(oArea, LM_LANDMARK_GATES);
    for (nLGate = 0; nLGate < nLGateCount; nLGate++)
    {
        oLGate = ai_GetObjectByIndex(oArea, nLGate, LM_LANDMARK_GATES);

        // ... that we can get to...
        if (ai_GetObjectCount(oLandmark, LM_ROUTE_TRAIL + GetTag(oLGate)))
        {
            // ... Of all the destination gateways...
            nDGateCount = ai_GetObjectCount(oDestArea, LM_LANDMARK_GATES);
            for (nDGate = 0; nDGateCount; nDGate++)
            {
                oDGate = ai_GetObjectByIndex(oDestArea, nDGate, LM_LANDMARK_GATES);

                // ... that can get to the destination landmark...
                if (ai_GetObjectCount(oDest, LM_ROUTE_TRAIL+GetTag(oDGate)))
                {
                    // ... and reach our local gateway...
                    if (ai_GetObjectCount(oDGate, LM_GATE_ROUTE_TRAIL+GetTag(oLGate)))
                    {
                        fDist = ai_GetShortestDistance(oLandmark, oLGate) +
                                ai_GetShortestDistance(oLGate,    oDGate) +
                                ai_GetShortestDistance(oDGate,    oDest);

                        // ... and is the shortest so far
                        if (!(GetIsObjectValid(stBest.oGate)) || (fBestDist > fDist))
                        {
                            stBest.oGate     = oLGate;
                            stBest.oDestGate = oDGate;
                            fBestDist        = fDist;
                        }
                    }
                }
            }
        }
    }

    ai_DebugEnd();
    return (stBest);
}

struct TrailVect_s ai_GetShortestNextTrail(object oLandmark, object oDest, object oGate = OBJECT_INVALID, object oDestGate = OBJECT_INVALID)
{
    ai_DebugStart("ai_GetShortestNextTrail oLandmark='"+GetTag(oLandmark)+"' oDest='"+GetTag(oDest)+"' oGate='"+GetTag(oGate)+"' oDestGate='"+GetTag(oDestGate)+"'", AI_DEBUG_TOOLKIT);

    struct TrailVect_s   stTrail;
    struct GatewayVect_s stGate;

    string sDest;
    int    index;

    stTrail.oWaypoint = OBJECT_INVALID;

    // If we're looking in the same area
    if (GetArea(oLandmark) == GetArea(oDest))
    {
        // Find the shortest route to the destination
        sDest             = GetTag(oDest);
        index             = GetLocalInt        (oLandmark,        LM_ROUTE_SHORTEST+sDest);
        stTrail.oWaypoint = ai_GetObjectByIndex(oLandmark, index, LM_ROUTE_TRAIL   +sDest);

        PrintString("stTrail.oWaypoint = " + GetTag(stTrail.oWaypoint));

        // Note: If the area is partitioned, we'll fall through to the longer search
        // What is partitioning? - SM
    }

    // We're looking for the next step in a long journey (expensive)
    if (!GetIsObjectValid(stTrail.oWaypoint))
    {
        // Determine whether have enough gateway info already
        if ((!GetIsObjectValid(oGate)) || (!GetIsObjectValid(oDestGate)) ||
             (GetArea(oLandmark) != GetArea(oGate)) ||
             (GetArea(oDest) != GetArea(oDestGate)))
        {
            // Do expensive search for where we want to go
            PrintString("<Assert>Asking for TMI trouble here!</Assert>");
            //stGate = ai_GetShortestGateway(oLandmark, oDest);

            stTrail.oWaypoint  = OBJECT_INVALID;
            stTrail.oTrail     = OBJECT_INVALID;
            stTrail.oLandmark  = OBJECT_INVALID;
            stTrail.nDirection = 0;
            ai_DebugEnd();
            return (stTrail);
        }
        else
        {
            stGate.oGate     = oGate;
            stGate.oDestGate = oDestGate;
        }

        // If we're already at the local gateway
        if (stGate.oGate == oLandmark)
        {
            // Cross into another area
            sDest             = GetTag(stGate.oDestGate);
            index             = GetLocalInt        (oLandmark,        LM_GATE_ROUTE_SHORTEST+sDest);
            stTrail.oWaypoint = ai_GetObjectByIndex(oLandmark, index, LM_GATE_ROUTE_TRAIL   +sDest);
        }
        else
        {
            // Head to the local gateway
            sDest             = GetTag(stGate.oGate);
            index             = GetLocalInt        (oLandmark,        LM_ROUTE_SHORTEST+sDest);
            stTrail.oWaypoint = ai_GetObjectByIndex(oLandmark, index, LM_ROUTE_TRAIL   +sDest);
        }
    }

    // Determine the direction
    if (_GetSuffix(GetTag(stTrail.oWaypoint)) == "01")
        stTrail.nDirection = 1;
    else
        stTrail.nDirection = -1;

    // Figure out which endpoint and landmark we are headed to
    stTrail.oTrail    = GetLocalObject(stTrail.oWaypoint, LM_TRAIL_FAR);
    stTrail.oLandmark = GetLocalObject(stTrail.oWaypoint, LM_LANDMARK_FAR);

    PrintString("Far trail: " + GetTag(stTrail.oTrail) + " Far landmark: " + GetTag(stTrail.oLandmark));

    ai_DebugEnd();
    return (stTrail);
}

float ai_GetShortestDistance(object oLandmark, object oDest, object oGate = OBJECT_INVALID, object oDestGate = OBJECT_INVALID)
{
    ai_DebugStart("ai_GetShortestDistance oLandmark='"+GetTag(oLandmark)+"' oDest='"+GetTag(oDest)+"' oGate='"+GetTag(oGate)+"' oDestGate='"+GetTag(oDestGate)+"'", AI_DEBUG_TOOLKIT);

    string sTag;
    object oArea     = GetArea(oLandmark);
    object oDestArea = GetArea(oDest);
    float  fDist;
    int    index;

    if (oArea != oDestArea)
    {
        // Sanity checks
        if ((oArea != GetArea(oGate)) || (oDestArea != GetArea(oDestGate)))
        {
            ai_DebugEnd();
            return (-1.0);
        }

        // Distance oLandmark -> oGate
        sTag  = GetTag(oGate);
        index = GetLocalInt       (oLandmark,        LM_ROUTE_SHORTEST+sTag);
        fDist = ai_GetFloatByIndex(oLandmark, index, LM_ROUTE_WEIGHT  +sTag);

        // Distance oGate -> oDestGate
        sTag   = GetTag(oDestArea)+GetTag(oDestGate);
        index  = GetLocalInt       (oGate,        LM_GATE_ROUTE_SHORTEST+sTag);
        fDist += ai_GetFloatByIndex(oGate, index, LM_GATE_ROUTE_WEIGHT  +sTag);

        // Distance oDestGate -> oDest
        sTag   = GetTag(oDest);
        index  = GetLocalInt      (oDestGate,        LM_ROUTE_SHORTEST+sTag);
        fDist += ai_GetFloatByIndex(oDestGate, index, LM_ROUTE_WEIGHT  +sTag);
    }
    else if (oLandmark != oDest)
    {
        // Distance oLandmark -> oDest
        sTag  = GetTag(oDest);
        index = GetLocalInt       (oLandmark,        LM_ROUTE_SHORTEST+sTag);
        fDist = ai_GetFloatByIndex(oLandmark, index, LM_ROUTE_WEIGHT  +sTag);
    }
    else
        fDist = 0.0;

    ai_DebugEnd();
    return (fDist);
}


// ----- Public Trail Functions ------------------------------------------------

struct TrailVect_s ai_FindNearestTrail(object oSelf = OBJECT_SELF, object oDest = OBJECT_INVALID, float fTolerance = 2.0)
{
    ai_DebugStart("ai_FindNearestTrail oSelf='"+GetTag(oSelf)+"' oDest='"+GetTag(oDest)+"' fTolerance='"+FloatToString(fTolerance)+"'", AI_DEBUG_TOOLKIT);

    struct TrailVect_s  stTrail;
    string sDest, sWP, sPrefix, sSuffix;
    object oWP, oFirstWP, oStartLM, oEndLM;
    float  fStartDist, fEndDist, fTrailDist;

    // Get the nearest trail
    location lLandmark = GetLocation(oSelf);
    oWP = GetFirstObjectInShape(SHAPE_CUBE, fTolerance, lLandmark, FALSE, OBJECT_TYPE_WAYPOINT);
    while (GetIsObjectValid(oWP))
    {
        // Don't mistake any ordinary waypoint for a trail waypoint
        sWP = GetTag(oWP);
        if (GetStringLeft(sWP, 3) == LM_LOCAL_TRAIL_PREFIX)
            break;

        oWP = GetNextObjectInShape(SHAPE_CUBE, fTolerance, lLandmark, FALSE, OBJECT_TYPE_WAYPOINT);
    }

    stTrail.oWaypoint  = OBJECT_INVALID;
    stTrail.oTrail     = OBJECT_INVALID;
    stTrail.oLandmark  = OBJECT_INVALID;
    stTrail.nDirection = 0;

    // Handle not found case
    if (!GetIsObjectValid(oWP))
    {
        ai_PrintString("No trails found nearby!");
        ai_DebugEnd();
        return (stTrail);
    }

    stTrail.oWaypoint = oWP;

    // If we want a trail to a particular destination
    if (GetIsObjectValid(oDest))
    {
        // Find the best trail to get us where we want to go

        sDest = GetTag(oDest);
        while (GetIsObjectValid(oWP))
        {
            sPrefix = _GetPrefix(sWP);
            sSuffix = _GetSuffix(sWP);

            oFirstWP = GetNearestWaypointByTag(sPrefix + "01", OBJECT_SELF);
            oStartLM = GetLocalObject(oFirstWP, LM_LANDMARK_NEAR);
            oEndLM   = GetLocalObject(oFirstWP, LM_LANDMARK_FAR);

            // This is the code used for picking out the index of the shortest
            // trail leading from one landmark to another. Perhaps something
            // like this could be used to get trails with other conditions? - SM
            //
            // Get the distance from both ends of the trail
            //int nStartLM = GetLocalInt(oStartLM, LM_ROUTE_SHORTEST+sDest);
            //int nEndLM   = GetLocalInt(oEndLM,   LM_ROUTE_SHORTEST+sDest);

            fStartDist = ai_GetFloatByIndex(oStartLM, 0, LM_ROUTE_WEIGHT+sDest); // Distance from starting landmark to destination
            fEndDist   = ai_GetFloatByIndex(oEndLM,   0, LM_ROUTE_WEIGHT+sDest); // Distance from ending landmark to destination
            fTrailDist = GetLocalFloat(oFirstWP, LM_WEIGHT_DIST);                // Length of the trail

            PrintString("oStartLM = " + GetTag(oStartLM));
            PrintString("oEndLM   = " + GetTag(oEndLM));
            PrintString("fStartDist = " + FloatToString(fStartDist));
            PrintString("fEndDist   = " + FloatToString(fEndDist));

            // If there's a trail from the starting landmark to the destination
            if (fStartDist > 0.0)
            {
                // If there's a trail from the starting landmark, then we should
                // head towards the ending landmark.

                stTrail.oWaypoint  = oWP;
                stTrail.oLandmark  = GetLocalObject(oFirstWP, LM_LANDMARK_FAR);
                stTrail.oTrail     = GetLocalObject(oFirstWP, LM_TRAIL_FAR);
                stTrail.nDirection = 1;

                PrintString("stTrail.oWaypoint: "  + GetTag(stTrail.oWaypoint)
                          + " stTrail.oLandmark: " + GetTag(stTrail.oLandmark)
                          + " stTrail.oTrail: "    + GetTag(stTrail.oTrail)
                          + " stTrail.nDirection: 1");
            }

            // If there's a trail from the ending landmark to the destination
            // and not from the starting landmark
            if ((fEndDist > 0.0) && (!GetIsObjectValid(stTrail.oTrail) || (fEndDist - fTrailDist) > fStartDist))
            {
                // If there's no valid trail from the starting landmark, then
                // the only possibility is that the starting landmark is the
                // destination. On the other hand, if there was a valid trail
                // from the starting landmark, and that trail is shorter than
                // the trail from the ending landmark, then we still want to go
                // to the startng landmark.

                stTrail.oWaypoint  = oWP;
                stTrail.oLandmark  = GetLocalObject(oFirstWP, LM_LANDMARK_NEAR);
                stTrail.oTrail     = oFirstWP;
                stTrail.nDirection = -1;

                PrintString("stTrail.oWaypoint: "  + GetTag(stTrail.oWaypoint)
                          + " stTrail.oLandmark: " + GetTag(stTrail.oLandmark)
                          + " stTrail.oTrail: "    + GetTag(stTrail.oTrail)
                          + " stTrail.nDirection: -1");
            }

            // Advance to next trail
            oWP = GetNextObjectInShape(SHAPE_CUBE, fTolerance, lLandmark, FALSE, OBJECT_TYPE_WAYPOINT);
        }
    }

    ai_DebugEnd();
    return (stTrail);
}

object ai_GetTrailNextWP(object oWP, int nDir)
{
    ai_DebugStart("ai_GetTrailNextWP oWP='"+GetTag(oWP)+"' nDir='"+IntToString(nDir)+"'", AI_DEBUG_TOOLKIT);

    string sWP     = GetTag(oWP);
    string sPrefix = _GetPrefix(sWP);
    string sSuffix = _GetSuffix(sWP);
    object oNextWP;

    if      (nDir > 0) nDir = 1;
    else if (nDir < 0) nDir = -1;

    string sTag = sPrefix + _ZeroIntToString(StringToInt(sSuffix) + nDir);
    PrintString("<Assert>TAG: " + sTag + "</Assert>");
    object oWaypoint = GetNearestWaypointByTag(sTag, oWP);

    if (!GetIsObjectValid(oWaypoint))
        PrintString("<Assert>TAG: " + sTag + " is not valid!</Assert>");

    ai_DebugEnd();
//    return GetNearestWaypointByTag(sTag, oWP);
    return oWaypoint;
}

object ai_GetTrailLandmark(object oWP, int nDir)
{
    ai_DebugStart("ai_GetTrailLandmark oWP='"+GetTag(oWP)+"' nDir='"+IntToString(nDir)+"'", AI_DEBUG_TOOLKIT);

    string sWP      = GetTag(oWP);
    string sPrefix  = _GetPrefix(sWP);
    object oFirstWP = GetNearestWaypointByTag(sPrefix + "01", oWP);

    ai_DebugEnd();
    if      (nDir > 0) return GetLocalObject(oFirstWP, LM_LANDMARK_FAR);
    else if (nDir < 0) return GetLocalObject(oFirstWP, LM_LANDMARK_NEAR);
    else               return GetLocalObject(oWP,      LM_LANDMARK_NEAR);
}

object ai_GetTrailEnd(object oWP, int nDir)
{
    ai_DebugStart("ai_GetTrailEnd oWP='"+GetTag(oWP)+"' nDir='"+IntToString(nDir)+"'", AI_DEBUG_TOOLKIT);

    string sWP      = GetTag(oWP);
    string sPrefix  = _GetPrefix(sWP);
    object oFirstWP = GetNearestWaypointByTag(sPrefix + "01", oWP);

    ai_DebugEnd();
    if      (nDir > 0) return GetLocalObject(oFirstWP, LM_TRAIL_FAR);
    else if (nDir < 0) return oFirstWP;
    else               return oWP;
}

// ----- Public Shortest Path Functions ----------------------------------------
void _ShortestPathTest(object oObj, object oStart, object oEnd)
{
    ai_DebugStart("_ShortestPathTest", AI_DEBUG_TOOLKIT);

    if (ai_ShortestPathGo(oObj))
    {
        // Done processing
        DelayCommand(0.0, ai_ShortestPathTest(oObj,
                                             GetTag(oStart), GetTag(GetArea(oStart)),
                                             GetTag(oEnd),   GetTag(GetArea(oEnd)), TRUE));
    }
    else
    {
        // Keep processing
        DelayCommand(0.0, _ShortestPathTest(oObj, oStart, oEnd));
    }

    ai_DebugEnd();
}

void ai_ShortestPathTest(object oObj, string sStart, string sStartArea, string sEnd, string sEndArea, int bDone = FALSE)
{
    ai_DebugStart("ai_ShortestPathTest oObj='"+GetTag(oObj)+"' sStart='"+sStart+"' sStartArea='"+sStartArea+"' sEnd='"+sEnd+"' sEndArea='"+sEndArea+"' bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    object oStart, oStartArea, oEnd, oEndArea;
    int    i;

    if (!bDone)
    {
        // Figure out the start and end areas
        oStartArea = GetObjectByTag(sStartArea);
        if (!GetIsObjectValid(oStartArea))
        {
            ai_PrintString("Error: Bad start area");
            ai_DebugEnd();
            return;
        }

        oEndArea = GetObjectByTag(sEndArea);
        if (!GetIsObjectValid(oEndArea))
        {
            ai_PrintString("Error: Bad end area");
            ai_DebugEnd();
            return;
        }

        // Figure out the start and end landmarks
        for (i = 0;; i++)
        {
            oStart = GetObjectByTag(sStart, i);
            if (!GetIsObjectValid(oStart))
            {
                ai_PrintString("Error: Bad start landmark");
                ai_DebugEnd();
                return;
            }

            if (GetArea(oStart) == oStartArea)
                break;
        }
        for (i = 0;; i++)
        {
            oEnd = GetObjectByTag(sEnd, i);
            if (!GetIsObjectValid(oEnd))
            {
                ai_PrintString("Error: Bad end landmark");
                ai_DebugEnd();
                return;
            }
            if (GetArea(oEnd) == oEndArea)
                break;
        }

        // Initialize processing
        ai_ShortestPathInit(oObj, oStart, oEnd);

        // Start processing
        DelayCommand(0.0, _ShortestPathTest(oObj, oStart, oEnd));

    }
    else
    {
        ai_PrintString("Shortest path: '"+GetTag(GetLocalObject(oObj, LM_START))+"' -> '"+GetTag(GetLocalObject(oObj, LM_START_GATE))+"' -> '"+GetTag(GetLocalObject(oObj, LM_END_GATE))+"' -> '"+GetTag(GetLocalObject(oObj, LM_END))+"'");

        // Cleanup
        ai_ShortestPathDone(oObj);
    }

    ai_DebugEnd();
}

int ai_ShortestPathInit(object oObj, object oStart, object oEnd, object oStartGate = OBJECT_INVALID, object oEndGate = OBJECT_INVALID)
{
    ai_DebugStart("ai_ShortestPathInit oObj='"+GetTag(oObj)+"' oStart='"+GetTag(oStart)+"' oEnd='"+GetTag(oEnd)+"' oStartGate='"+GetTag(oStartGate)+"' oEndGate='"+GetTag(oEndGate)+"'", AI_DEBUG_TOOLKIT);

    // Avoid double init
    if (GetLocalInt(oObj, LM_SHORTEST_PATH_INIT))
        return FALSE;

    // Initialize the object
    SetLocalObject(oObj, LM_START,           oStart);
    SetLocalObject(oObj, LM_END,             oEnd);
    SetLocalObject(oObj, LM_START_GATE,      oStartGate);
    SetLocalObject(oObj, LM_END_GATE,        oEndGate);
    SetLocalObject(oObj, LM_BEST_START_GATE, OBJECT_INVALID);
    SetLocalObject(oObj, LM_BEST_END_GATE,   OBJECT_INVALID);

    SetLocalInt(oObj, LM_START_GATE, FALSE);
    SetLocalInt(oObj, LM_END_GATE,   FALSE);

    SetLocalInt(oObj, LM_SHORTEST_PATH_DONE, FALSE);

    // If oStart and oEnd are in the same area and no particular gateways are given
    if ((GetArea(oStart) == GetArea(oEnd)) && (!GetIsObjectValid(oStartGate)) && (!GetIsObjectValid(oEndGate)))
    {
        // If you can go directly from oStart to oEnd
        if (ai_GetObjectCount(oStart, LM_ROUTE_SHORTEST+GetTag(oEnd)))
        {
            // We're already done
            SetLocalInt(oObj, LM_SHORTEST_PATH_DONE, TRUE);
        }
    }

    // Mark the object as initialized
    SetLocalInt(oObj, LM_SHORTEST_PATH_INIT, TRUE);

    ai_DebugEnd();
    return TRUE;
}

int ai_ShortestPathGo(object oObj)
{
    ai_DebugStart("ai_ShortestPathGo oObj='"+GetTag(oObj)+"'", AI_DEBUG_TOOLKIT);

    // Wait for busy landmark processing to finish
    if (ai_IsProcessingLandmarks())
    {
        ai_DebugEnd();
        return FALSE;
    }

    // Are we done yet?
    if (GetLocalInt(oObj, LM_SHORTEST_PATH_DONE))
    {
        ai_DebugEnd();
        return TRUE;
    }

    object oStart     = GetLocalObject(oObj, LM_START);
    object oEnd       = GetLocalObject(oObj, LM_END);
    object oStartArea = GetArea(oStart);
    object oEndArea   = GetArea(oEnd);
    object oStartGate;
    object oEndGate;
    float  fDist;
    int    nStartGate = GetLocalInt(oObj, LM_START_GATE);
    int    nEndGate   = GetLocalInt(oObj, LM_END_GATE);
    int    nLastStartGate;
    int    nLastEndGate;

    // Load the current start and end gates
    oStartGate = ai_GetObjectByIndex(oStartArea, nStartGate, LM_LANDMARK_GATES);
    oEndGate   = ai_GetObjectByIndex(oEndArea,   nEndGate,   LM_LANDMARK_GATES);

    ai_PrintString("Examining: '"+GetTag(oStart)+"' -> '"+GetTag(oStartGate)+"' ('"+GetTag(GetArea(oStartGate))+"') -> '"+GetTag(oEndGate)+"' ('"+GetTag(GetArea(oEndGate))+"') -> '"+GetTag(oEnd)+"'");

    // If oStart -> oStartGate...
    if ((oStart == oStartGate) || (ai_GetObjectCount(oStart, LM_ROUTE_SHORTEST+GetTag(oStartGate))))
    {
        // ... And oEndGate -> oEnd...
        if ((oEndGate == oEnd) || (ai_GetObjectCount(oEndGate, LM_ROUTE_SHORTEST+GetTag(oEnd))))
        {
            // ... And oStartGate -> oEndGate
            if (ai_GetObjectCount(oStartGate, LM_GATE_ROUTE_TRAIL+GetTag(oEndArea)+GetTag(oEndGate)))
            {
                // ... And is the shortest so far
                fDist = ai_GetShortestDistance(oStart, oEndGate, oStartGate, oEndGate);
                if ((!GetIsObjectValid(GetLocalObject(oObj, LM_BEST_START_GATE))) || (GetLocalFloat(oObj, LM_BEST_DISTANCE) > fDist))
                {
                    ai_PrintString("New best path");
                    SetLocalObject(oObj, LM_BEST_START_GATE, oStartGate);
                    SetLocalObject(oObj, LM_BEST_END_GATE,   oEndGate);
                    SetLocalFloat (oObj, LM_BEST_DISTANCE,   fDist);
                }
                else
                    ai_PrintString("Path too long "+FloatToString(GetLocalFloat(oObj, LM_BEST_DISTANCE))+" <= "+FloatToString(fDist));
            }
            else
                ai_PrintString("oStartGate !> oEndGate");
        }
        else
            ai_PrintString("oEndGate !> oEnd");
    }
    else
        ai_PrintString("oStart !> oStartGate");

    // If we're done end gateway
    if (nStartGate >= ai_GetObjectCount(oStartArea, LM_LANDMARK_GATES) - 1)
    {
        // If we're done searching
        if (nEndGate >= ai_GetObjectCount(oEndArea, LM_LANDMARK_GATES) - 1)
        {
            // Transfer best gateways
            SetLocalObject(oObj, LM_START_GATE, GetLocalObject(oObj, LM_BEST_START_GATE));
            SetLocalObject(oObj, LM_END_GATE,   GetLocalObject(oObj, LM_BEST_END_GATE));

            // Clean-up temporary variables
            DeleteLocalObject(oObj, LM_BEST_START_GATE);
            DeleteLocalObject(oObj, LM_BEST_END_GATE);
            DeleteLocalFloat (oObj, LM_BEST_DISTANCE);

            // Done
            SetLocalInt(oObj, LM_SHORTEST_PATH_DONE, 1);
            ai_DebugEnd();
            return TRUE;
        }
        else
        {
            // Otherwise, more end gateways to look at
            nEndGate++;
        }

        // Regardless of what happens, we're working on a different landmark
        oEndGate = ai_GetObjectByIndex(oEndArea, nEndGate, LM_LANDMARK_GATES);
        nStartGate = 0;
    }
    else
    {
        // Otherwise, more start gateways to look at
        nStartGate++;
    }

    // Regardless of what happens, we're working on a different start gateway
    oStartGate = ai_GetObjectByIndex(oStartArea, nStartGate, LM_LANDMARK_GATES);

    // Update state
    SetLocalInt(oObj, LM_START_GATE, nStartGate);
    SetLocalInt(oObj, LM_END_GATE,   nEndGate);

    // Not done yet
    ai_DebugEnd();
    return FALSE;
}

int ai_ShortestPathDone(object oObj)
{
    ai_DebugStart("ai_ShortestPathDone oObj='"+GetTag(oObj)+"'", AI_DEBUG_TOOLKIT);

    // Avoid uninitialized host objects
    if (!GetLocalInt(oObj, LM_SHORTEST_PATH_INIT))
        return FALSE;

    // Cleanup the object
    DeleteLocalObject(oObj, LM_START);
    DeleteLocalObject(oObj, LM_END);
    DeleteLocalObject(oObj, LM_START_GATE);
    DeleteLocalObject(oObj, LM_END_GATE);
    DeleteLocalObject(oObj, LM_BEST_START_GATE);
    DeleteLocalObject(oObj, LM_BEST_END_GATE);

    DeleteLocalInt(oObj, LM_START_GATE);
    DeleteLocalInt(oObj, LM_END_GATE);

    DeleteLocalInt(oObj, LM_SHORTEST_PATH_DONE);
    DeleteLocalInt(oObj, LM_SHORTEST_PATH_INIT);

    ai_DebugEnd();
    return TRUE;
}

void _WalkShortestPathTest(object oObj)
{
    ai_DebugStart("_WalkShortestPathTest", AI_DEBUG_TOOLKIT);

    // FLAG: WTF is up with this function?

    int     bResult;

    // Do some work
    bResult = TRUE;
    if (bResult == TRUE)
    {
        // Done processing
        DelayCommand(0.0, ai_WalkShortestPathTest(oObj, TRUE));
    }
    else
    {
        // Keep processing
        DelayCommand(0.0, _WalkShortestPathTest(oObj));
    }

    ai_DebugEnd();
}

void ai_WalkShortestPathTest(object oObj, int bDone = FALSE)
{
    ai_DebugStart("ai_WalkShortestPathTest oObj='"+GetTag(oObj)+"' bDone='"+IntToString(bDone)+"'", AI_DEBUG_TOOLKIT);

    if (!bDone)
    {
        // Initialize processing
        ai_WalkShortestPathInit(oObj);

        // Start processing
        DelayCommand(0.0, _WalkShortestPathTest(oObj));

    }
    else
    {
        ai_PrintString("Done");

        // Cleanup
        ai_WalkShortestPathDone(oObj);
    }

    ai_DebugEnd();
}

int ai_WalkShortestPathInit(object oObj)
{
    ai_DebugStart("ai_WalkShortestPathInit oObj='"+GetTag(oObj)+"'", AI_DEBUG_TOOLKIT);

    // Avoid double init
    if (GetLocalInt(oObj, LM_WALK_SHORTEST_PATH_INIT)) return FALSE;

    // We need shortest path computed already
    if (!GetLocalInt(oObj, LM_SHORTEST_PATH_INIT)) return FALSE;

    object oStart;
    object oStartGate;

    // Start at the very beginning
    oStartGate = GetLocalObject(oObj, LM_START_GATE);
    SetLocalObject(oObj, LM_CURRENT_GATE, oStartGate);

    oStart = GetLocalObject(oObj, LM_START);
    SetLocalObject(oObj, LM_CURRENT_LANDMARK, oStart);
    SetLocalObject(oObj, LM_CURRENT,          oStart);

    // Mark the object as initialized
    SetLocalInt(oObj, LM_WALK_SHORTEST_PATH_INIT, TRUE);

    ai_DebugEnd();
    return TRUE;
}

object ai_WalkShortestPathNext(object oObj, int bForce = FALSE)
{
    ai_DebugStart("ai_WalkShortestPathNext oObj='"+GetTag(oObj)+"'", AI_DEBUG_TOOLKIT);

    object  oCurr = GetLocalObject(oObj, LM_CURRENT);
    object  oDest;

    // Try going to the next landmark
    oDest = GetLocalObject(oObj, LM_CURRENT_LANDMARK);
    if ((!GetIsObjectValid(oDest)) || (oCurr == oDest))
    {
        // Try going to the local gateway
        oDest = GetLocalObject(oObj, LM_CURRENT_GATE);
        if ((!GetIsObjectValid(oDest)) || (oCurr == oDest))
        {
            // Try going to the end gateway
            oDest = GetLocalObject(oObj, LM_END_GATE);
            if ((!GetIsObjectValid(oDest)) || (oCurr == oDest))
            {
                // Try going to the final destination
                oDest = GetLocalObject(oObj, LM_END);
                if (GetArea(oCurr) != GetArea(oDest))
                {
                    // We're lost!!!
                    ai_PrintString("WARN: We're lost!");
                    ai_DebugEnd();
                    return OBJECT_INVALID;
                }
                else
                {
                    // We are at the end gateway headed to the end landmark
                }
            }
            else
            {
                // We are at a local gateway headed to another area
                string sCurr = GetTag(oCurr);

                // If this is gateway landmark
                if (GetStringLeft(sCurr, 3) == LM_GATEWAY_PREFIX)
                {
                    // Figure out the next gateway in the next area

                    // Find the gateway landmark in the other area we will connect to

                    // Trail connects remote gateway to its landmark

                    // Area transition to the gateway in the next area
                    SetLocalObject(oObj, LM_CURRENT, GetLocalObject(oCurr, LM_GATEWAY));
                }
                else
                {
                    ai_PrintString("ERROR: Not a gateway or gateway landmark: '"+sCurr+"'");
                    ai_DebugEnd();
                    return OBJECT_INVALID;
                }
            }

        }
        else
        {
            // We are at a local landmark headed to a local gateway
            object oTemp;
            string sRouteShortest;
            string sRouteTrail;
            string sDest;

            // Precompute common strings
            sDest = GetTag(oDest);
            sRouteShortest = LM_ROUTE_SHORTEST+sDest;
            sRouteTrail    = LM_ROUTE_TRAIL   +sDest;

            // Find the trail to follow to the next landmark
            oTemp = ai_GetObjectByIndex(oCurr, ai_GetIntByIndex(oCurr, 0, sRouteShortest), sRouteTrail);
            SetLocalObject(oObj, LM_CURRENT_TRAIL, oTemp);

            // Find the next landmark to go to
            oTemp = GetLocalObject(oTemp, LM_LANDMARK_FAR);
            if (oTemp == oCurr)
                oTemp = GetLocalObject(oTemp, LM_LANDMARK_NEAR);

            SetLocalObject(oObj, LM_CURRENT_LANDMARK, oTemp);

            oCurr = GetLocalObject(oObj, LM_CURRENT_TRAIL);
        }
    }
    else
    {
        // We are on a local trail headed to a local landmark
        object oTemp, oCurrArea = GetArea(oCurr);
        string sDest, sCurr     = GetTag(oCurr);
        string sPrefix          = _GetPrefix(sCurr);
        int    i;

        // If we are on a local trail
        if (GetStringLeft(sCurr, 3) == LM_LOCAL_TRAIL_PREFIX)
        {
            // Figure out the name of the next trail
            sDest = _GetPrefix(sCurr) + _ZeroIntToString(StringToInt(_GetSuffix(sCurr)) + 1);
        }
        // If we are on a gateway trail
        else if (GetStringLeft(sCurr, 3) == LM_GATEWAY_TRAIL_PREFIX)
        {
            // If we're headed out of the area
            sDest = GetTag(GetLocalObject(oObj, LM_CURRENT_LANDMARK));
            if (GetStringLeft(sDest, 3) == LM_GATEWAY_PREFIX)
            {
                // Figure out the name of the next trail (decrement)
                sDest = _GetPrefix(sCurr) + _ZeroIntToString(StringToInt(_GetSuffix(sCurr)) - 1);
            }
            else
            {
                // Otherwise, we're headed into the area
                // Figure out the name of the next trail (increment)
                sDest = _GetPrefix(sCurr) + _ZeroIntToString(StringToInt(_GetSuffix(sCurr)) + 1);
            }
        }
        else
        {
            // Otherwise, we're not on a trail!!!
            ai_PrintString("ERROR: Not a trail: '"+sCurr+"'");
            ai_DebugEnd();
            return OBJECT_INVALID;
        }

        // Find the next trail
        for (i = 0;; i++)
        {
            oTemp = GetObjectByTag(sDest, i);

            // There no more trail waypoints, head to the next landmark
            if (!GetIsObjectValid(oTemp))
            {
                oCurr = GetLocalObject(oObj, LM_CURRENT_LANDMARK);
                break;

            }
            else if (GetArea(oTemp) == GetArea(oCurr))
            {
                // We found the next trail waypoint
                oCurr = oTemp;
                break;
            }
        }

        // Store the results
        SetLocalObject(oObj, LM_CURRENT_TRAIL, oCurr);
        SetLocalObject(oObj, LM_CURRENT,       oCurr);
    }

    ai_DebugEnd();
    return oCurr;
}

int ai_WalkShortestPathDone(object oObj)
{
    ai_DebugStart("ai_WalkShortestPathDone oObj='"+GetTag(oObj)+"'", AI_DEBUG_TOOLKIT);

    // Avoid uninitialized host objects
    if (!GetLocalInt(oObj, LM_WALK_SHORTEST_PATH_INIT))
        return FALSE;

    // Cleanup the object
    DeleteLocalObject(oObj, LM_CURRENT);
    DeleteLocalInt   (oObj, LM_WALK_SHORTEST_PATH_DONE);
    DeleteLocalInt   (oObj, LM_WALK_SHORTEST_PATH_INIT);

    ai_DebugEnd();
    return TRUE;
}

//void main() {}
