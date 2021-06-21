/*
Filename:           wp_i_main
System:             Walk Waypoints  (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       March. 15, 2009
Summary:
Walk Waypoints system primary include script. This file holds the functions
commonly used throughout the Walk Waypoints system.

Many of the scripts contained herein are based on those included in Rhone's
Hour-Based Waypoint Walker and Axe Murderer's Killer Walk Waypoints, customized
for Shadows & Silver's needs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "wp_c_main"
#include "x0_i0_spawncond"


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ---< wp_GetWalkCondition >---
// ---< wp_i_main >---
// Returns whether the specified WalkWayPoints condition is set on oCreature.
int wp_GetWalkCondition(int nCondition, object oCreature = OBJECT_SELF);

// ---< wp_SetWalkCondition >---
// ---< wp_i_main >---
// Sets a WalkWayPoints condition nCondition with a value of bValid on oCreature.
void wp_SetWalkCondition(int nCondition, int bValid = TRUE, object oCreature = OBJECT_SELF);

// ---< wp_GetWaypointSuffix >---
// ---< wp_i_main >---
// Returns a waypoint number suffix, padded if necessary.
string wp_GetWaypointSuffix(int i);

// ---< wp_DetectStuckWayWalker >---
// ---< wp_i_main >---
// Attempts to detect and unstick waywalkers that have become stuck against a
// wall or cannot find a transition to a cross-area waypoint.
// Call this from OnHeartbeat just before the call to wp_WalkWaypoints.
// The parameters should be the same as those used by wp_WalkWayPoints.
void wp_DetectStuckWayWalker(int nRun = WP_DEFAULT_RUN_TO_WAYPOINTS, float fPause = WP_DEFAULT_PAUSE_AT_WAYPOINT);

// ---< wp_LookUpWalkWayPoints >---
// ---< wp_i_main >---
// Looks up the caller's waypoints and stores them on him.
void wp_LookUpWalkWayPoints();

// ---< wp_GetNextWaypoint >---
// ---< wp_i_main >---
// Retrieves oWalker's next waypoint for his walk progression.
void wp_GetNextWaypoint(object oWalker = OBJECT_SELF);

// ---< wp_WalkWayPoints >---
// ---< wp_i_main >---
// Creates and starts a timer to track the bleeding of oPC.
void wp_WalkWayPoints(int nRun = WP_DEFAULT_RUN_TO_WAYPOINTS, float fPause = WP_DEFAULT_PAUSE_AT_WAYPOINT, int bCalledFromHeartbeat = FALSE);




/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

int wp_GetWalkCondition(int nCondition, object oCreature = OBJECT_SELF)
{
    return (GetLocalFlag(oCreature, WP_WALK_CONDITION, nCondition));
}

void wp_SetWalkCondition(int nCondition, int bValid = TRUE, object oCreature = OBJECT_SELF)
{
    SetLocalFlag(oCreature, WP_WALK_CONDITION, nCondition, bValid);
}

string wp_GetWaypointSuffix(int i)
{
    return (((i < 10) ? "0" : "") + IntToString(i));
}

void wp_DetectStuckWayWalker(int nRun = WP_DEFAULT_RUN_TO_WAYPOINTS, float fPause = WP_DEFAULT_PAUSE_AT_WAYPOINT)
{
    // If stuck detection system is not enabled, do nothing...
    if (!WP_ENABLE_STUCK_DETECTION)
        return;

    object oWalker = OBJECT_SELF;

    // Try to detect when the guy gets stuck and attempt to get him going again.
    if (GetCommandable() && GetLocalInt(oWalker, WP_WALKING_TO) && ((GetCurrentAction(oWalker) == ACTION_MOVETOPOINT) || (GetCurrentAction(oWalker) == ACTION_WAIT)))
    {
        // He is trying to get to a waypoint.
        location lCheckStuckLocation = GetLocalLocation(oWalker, WP_CHECK_STUCK_LOCATION);
        if ((GetAreaFromLocation(lCheckStuckLocation) == GetArea(oWalker)) && (GetDistanceBetweenLocations(lCheckStuckLocation, GetLocation(oWalker)) <= 3.00))
        {
            // Hasn't moved since last heartbeat. Bump up the primary counter.
            int nCheckStuckCount = GetLocalInt(oWalker, WP_CHECK_STUCK_COUNT_PRIMARY);
            SetLocalInt(oWalker, WP_CHECK_STUCK_COUNT_PRIMARY, ++nCheckStuckCount);

            switch (GetLocalInt(oWalker, WP_WALKWAY_DEBUG_VOLUME))
            {
                case 3: SpeakString("Stuck Count " + IntToString(nCheckStuckCount), TALKVOLUME_TALK);  break;
                case 4: SpeakString("Stuck Count " + IntToString(nCheckStuckCount), TALKVOLUME_SHOUT); break;
            }

            if (nCheckStuckCount > WP_STUCK_DETECTION_PRIMARY_THRESHOLD)
            {
                // Well he seems stuck, reset the counter, clear his actions.
                DeleteLocalInt(oWalker, WP_WALKING_TO);
                DeleteLocalInt(oWalker, WP_CHECK_STUCK_COUNT_PRIMARY);

                // Bump up his secondary counter and check for bad stuckness.
                int nCheckStuckCount2 = GetLocalInt(oWalker, WP_CHECK_STUCK_COUNT_SECONDARY);
                SetLocalInt(oWalker, WP_CHECK_STUCK_COUNT_SECONDARY, ++nCheckStuckCount2);

                switch (GetLocalInt(oWalker, WP_WALKWAY_DEBUG_VOLUME))
                {
                    case 3: SpeakString("Stuck Secondary " + IntToString(nCheckStuckCount2), TALKVOLUME_TALK);  break;
                    case 4: SpeakString("Stuck Secondary " + IntToString(nCheckStuckCount2), TALKVOLUME_SHOUT); break;
                }

                if (nCheckStuckCount2 > WP_STUCK_DETECTION_SECONDARY_THRESHOLD)
                {
                    // Ok this isn't working. He is stuck for sure now, so just
                    // jump him to his target if it is in the same area he is.
                    DeleteLocalInt(oWalker, WP_CHECK_STUCK_COUNT_SECONDARY);
                    if (!GetIsFighting(oWalker) && !IsInConversation(oWalker))
                    {
                        object oWaypoint = GetLocalObject(oWalker, WP_CURRENT_WAYPOINT);

                        if (GetIsObjectValid(oWaypoint) && (GetArea(oWaypoint) == GetArea(oWalker)))
                        {
                            // Send him to the waypoint.
                            ClearAllActions(TRUE);
                            ActionDoCommand(DelayCommand(1.0, SetCommandable(TRUE)));
                            ActionDoCommand(SetLocalInt(oWalker, WP_WALKING_TO, TRUE));
                            ActionJumpToObject(oWaypoint);
                            ActionDoCommand(DeleteLocalInt(oWalker, WP_WALKING_TO));
                            SetCommandable(FALSE);
                            DeleteLocalInt(oWalker, WP_CHECK_STUCK_COUNT_PRIMARY);
                            DeleteLocalInt(oWalker, WP_CHECK_STUCK_COUNT_SECONDARY);
                            DeleteLocalLocation(oWalker, WP_CHECK_STUCK_LOCATION);
                        }

                    }
                }
                else
                {
                    // Make him repeat the same waypoint and temporarily give
                    // him a better AI level. Subsequent times through here
                    // (i.e. secondary = 2, 3, 4) we try to move him 2.5m left,
                    // then right, then backwards.
                    if (!GetIsFighting(oWalker) && !IsInConversation(oWalker))
                    {
                        int nOrginalAI = GetAILevel();
                        ClearAllActions(TRUE);
                        ActionDoCommand(SetCommandable(TRUE));
                        ActionDoCommand(DelayCommand(4.0, SetAILevel(oWalker, nOrginalAI)));
                        ActionDoCommand(SetAILevel(oWalker, ((nCheckStuckCount2 > 1) ? AI_LEVEL_VERY_HIGH : AI_LEVEL_HIGH)));

                        if ((nCheckStuckCount2 % 3) == 1)
                        {
                            // Make him move a little to the left.
                            float  fAngle = GetFacing(oWalker) +90.0;
                            while (fAngle >= 360.0) fAngle -= 360.0;
                            while (fAngle <    0.0) fAngle += 360.0;
                            vector vLeft  = GetPosition(oWalker);
                            vector vUnit  = VectorNormalize(AngleToVector(fAngle));
                            vUnit *= 2.5;
                            vLeft += vUnit;
                            ActionMoveToLocation(Location(GetArea(oWalker), vLeft, GetFacing(oWalker)));
                        }
                        else if ((nCheckStuckCount2 % 3) == 2)
                        {
                            // Make him move a little backwards.
                            float  fAngle = GetFacing(oWalker) +170.0;
                            while (fAngle >= 360.0) fAngle -= 360.0;
                            while (fAngle <    0.0) fAngle += 360.0;
                            vector vBack = GetPosition(oWalker);
                            vector vUnit = VectorNormalize(AngleToVector(fAngle));
                            vUnit *= 2.5;
                            vBack += vUnit;
                            ActionMoveToLocation(Location(GetArea(oWalker), vBack, GetFacing(oWalker)));
                        }
                        else if ((nCheckStuckCount2 % 3) == 0)
                        {
                            // Make him move a little to the right.
                            float  fAngle = GetFacing(oWalker) -90.0;
                            while (fAngle >= 360.0) fAngle -= 360.0;
                            while (fAngle <    0.0) fAngle += 360.0;
                            vector vRight = GetPosition(oWalker);
                            vector vUnit  = VectorNormalize(AngleToVector(fAngle));
                            vUnit *= 2.5;
                            vRight += vUnit;
                            ActionMoveToLocation(Location(GetArea(oWalker), vRight, GetFacing(oWalker)));
                        }
                        ActionDoCommand(wp_WalkWayPoints(nRun, fPause));
                        SetCommandable(FALSE);

                        switch (GetLocalInt(oWalker, WP_WALKWAY_DEBUG_VOLUME))
                        {
                            case 3: SpeakString("Attempting to unstick", TALKVOLUME_TALK);  break;
                            case 4: SpeakString("Attempting to unstick", TALKVOLUME_SHOUT); break;
                        }
                    }
                }
            }
        }
        else
        {
            // Making progress, clear counter & remember location.
            DeleteLocalInt(oWalker, WP_CHECK_STUCK_COUNT_PRIMARY);
            DeleteLocalInt(oWalker, WP_CHECK_STUCK_COUNT_SECONDARY);
            SetLocalLocation(oWalker, WP_CHECK_STUCK_LOCATION, GetLocation(oWalker));
        }
    }
    else
    {
        // Not trying to get to a waypoint.
        DeleteLocalInt(oWalker, WP_CHECK_STUCK_COUNT_PRIMARY);
        DeleteLocalInt(oWalker, WP_CHECK_STUCK_COUNT_SECONDARY);
        DeleteLocalLocation(oWalker, WP_CHECK_STUCK_LOCATION);
    }
}

void wp_LookUpWalkWayPoints()
{
    int    nHour;
    int    nNth = 1;
    object oWaypoint;
    object oWalker = OBJECT_SELF;
    string sWalker = GetTag(oWalker);

    for (nHour; nHour < 24; nHour++)
    {
        string sHour = IntToString(nHour);
        string sTag = GetLocalString(oWalker, WP_TAG + WP_HOUR + sHour);
        sTag = ((sTag != "") ? sTag : GetLocalString(oWalker, WP_TAG));
        sTag = WP_PREFIX + ((sTag != "") ? sTag : sWalker) + WP_HOUR + sHour + "_";
        nNth = 1;
        if (!WP_ENABLE_CROSS_AREA_WALKWAYPOINTS)
            oWaypoint = GetNearestObjectByTag(sTag + wp_GetWaypointSuffix(nNth));
        else
            oWaypoint = GetObjectByTag(sTag + wp_GetWaypointSuffix(nNth));

        // No waypoints
        if (!GetIsObjectValid(oWaypoint))
            SetLocalInt(oWalker, WP_HOUR_PREFIX + sHour + WP_NUMBER, -1);
        else
        {
            // Look up and store all the waypoints
            while (GetIsObjectValid(oWaypoint))
            {
                SetLocalObject(oWalker, WP_HOUR_PREFIX + sHour + "_" + IntToString(nNth++), oWaypoint);

                if (!WP_ENABLE_CROSS_AREA_WALKWAYPOINTS)
                    oWaypoint = GetNearestObjectByTag(sTag + wp_GetWaypointSuffix(nNth));
                else
                    oWaypoint = GetObjectByTag(sTag + wp_GetWaypointSuffix(nNth));
            }
            SetLocalInt(oWalker, WP_HOUR_PREFIX + sHour + WP_NUMBER, --nNth);
        }
    }

    SetLocalInt(oWalker, WP_CURRENT_WAYPOINT, -1);
}

// Get the creature's next waypoint. If this is the first time we're getting a
// waypoint, we go to the nearest waypoint in our new set.
object wp_GetNextWalkWayPoint(object oWalker = OBJECT_SELF)
{
    int nHour = GetTimeHour();
    int nCurrentWaypoint = GetLocalInt(oWalker, WP_CURRENT_WAYPOINT);

    // If the NPC is running wp_WalkWayPoints for the first time (e.g. he just
    // spawned), then we set WP_LAST_HOUR_WALKED to an hour ahead of the current
    // time. That way, every hour can be checked for waypoints.
    if (nCurrentWaypoint == -1)
    {
        if (nHour == 23)
            SetLocalInt(oWalker, WP_LAST_HOUR_WALKED, 0);
        else
            SetLocalInt(oWalker, WP_LAST_HOUR_WALKED, nHour + 1);
    }

    int nPoints;
    int nLastWalked = GetLocalInt(oWalker, WP_LAST_HOUR_WALKED);
    int nLastChecked = GetLocalInt(oWalker, WP_LAST_HOUR_CHECKED);

    // If nLastChecked is not equal to the current hour, check to see if there
    // are new waypoints. nLastChecked will be set to the current hour so we
    // don't bother checking for new waypoints again until the next hour.
    if (nHour != nLastChecked)
    {
        nCurrentWaypoint = -1;
        SetLocalInt(oWalker, WP_CURRENT_WAYPOINT, -1);

        // This loop checks every hour, starting with the current hour and
        // counting backwards, until we either find an hour for which the NPC
        // has waypoints to walk (so an NPC with 8am waypoints will keep walking
        // them for every hour until the next hour he has waypoints set for) or
        // we reach WP_LAST_HOUR_WALKED (at which point we don't need to look
        // any further).
        while (nHour != nLastWalked)
        {
            nPoints = GetLocalInt(oWalker, WP_HOUR_PREFIX + IntToString(nHour) + WP_NUMBER);
            if (nPoints > 0)
                break;

            nHour--;
            if (nHour < 0)
                nHour = 23;
        }

        SetLocalInt(oWalker, WP_LAST_HOUR_WALKED, nHour);
        SetLocalInt(oWalker, WP_LAST_HOUR_CHECKED, GetTimeHour());
    }
    else
    {
        nHour = nLastWalked;
        nPoints = GetLocalInt(oWalker, WP_HOUR_PREFIX + IntToString(nHour) + WP_NUMBER);
    }

    // If we only have one waypoint, just go there
    if (nPoints == 1)
        return GetLocalObject(oWalker, WP_HOUR_PREFIX + IntToString(nHour) + "_1");

    // Determine the circuit the walker uses.
    int nProgression = GetLocalInt(oWalker, WP_WALK_PROGRESSION + WP_HOUR + IntToString(GetTimeHour()));
    nProgression = ((nProgression != 0) ? nProgression : GetLocalInt(oWalker, WP_WALK_PROGRESSION + WP_HOUR + IntToString(nHour)));
    nProgression = ((nProgression != 0) ? nProgression : GetLocalInt(oWalker, WP_WALK_PROGRESSION));
    nProgression = ((nProgression != 0) ? nProgression : WP_DEFAULT_WALK_PROGRESSION);

    // Get the current waypoint and check to see if this is the first time.
    if (nCurrentWaypoint == -1)
        nCurrentWaypoint = 1;
    // Not the first time, waypoints have been found and cached.
    else if (!GetLocalInt(oWalker, WP_WALKING_TO))
    {
        // He is not in the process of walking to a waypoint. Get his circuit.
        if (nProgression == WP_WALK_PROGRESSION_CIRCULAR)
        {
            // If he has reached the end of the circuit, loop back to 1.
            if (++nCurrentWaypoint > nPoints)
                nCurrentWaypoint = 1;
        }
        else if (nProgression == WP_WALK_PROGRESSION_RANDOM)
        {
            // He is walking in a random circuit, so choose a random waypoint.
            nCurrentWaypoint = ss_Random(nPoints + 1);
        }
        else
        {
            // He is walking the palindrome circuit order.
            // Check if he's walking forward or backwards.
            if (wp_GetWalkCondition(WP_WALK_FLAG_BACKWARDS, oWalker))
            {
                if (--nCurrentWaypoint == 0)
                {
                    nCurrentWaypoint = 2;
                    wp_SetWalkCondition(WP_WALK_FLAG_BACKWARDS, FALSE, oWalker);
                }
            }
            else if (++nCurrentWaypoint > nPoints)
            {
                nCurrentWaypoint -= 2;
                wp_SetWalkCondition(WP_WALK_FLAG_BACKWARDS, TRUE, oWalker);
            }
        }
    }

    // Make sure circular and random walkers never go backwards in the sequence.
    if (nProgression != WP_WALK_PROGRESSION_PALINDROMIC)
        wp_SetWalkCondition(WP_WALK_FLAG_BACKWARDS, FALSE, oWalker);

    // Set our current point and return
    object oReturn = GetLocalObject(oWalker, WP_HOUR_PREFIX + IntToString(nHour) + "_" + IntToString(nCurrentWaypoint));
    SetLocalInt(oWalker, WP_CURRENT_WAYPOINT, nCurrentWaypoint);
    SetLocalObject(oWalker, WP_CURRENT_WAYPOINT, oReturn);
    return oReturn;

    // TODO: Allow conditionals that check if a waypoint should be walked to?
}

void wp_WalkWayPoints(int nRun = WP_DEFAULT_RUN_TO_WAYPOINTS, float fPause = WP_DEFAULT_PAUSE_AT_WAYPOINT, int bCalledFromHeartbeat = FALSE)
{
    object oWalker = OBJECT_SELF;
    // If Walk Waypoints is suspended for the walker or globally, abort.
    if (ss_GetGlobalInt(WP_DISABLE_WALK_WAYPOINTS) || GetLocalInt(oWalker, WP_DISABLE_WALK_WAYPOINTS))
        return;

    // Check if the walker is still performing animations.
    if (GetCurrentAction(oWalker) != ACTION_INVALID)
        DeleteLocalInt(oWalker, WP_PLAYING_ANIMATION);

    // Don't interfere with non-interruptable actions.
    if (!GetCommandable())
        return;

    // If the walker can see an enemy, abort.
    object oNearestEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    if (GetIsObjectValid(oNearestEnemy))
        if (GetObjectSeen(oNearestEnemy, oWalker))
            return;

    // Don't interrupt current circuit.
    int bIsFighting       = GetIsFighting(oWalker);
    int bIsInConversation = IsInConversation(oWalker);
    int bMoving           = GetCurrentAction(oWalker) == ACTION_MOVETOPOINT;
    int bWaiting          = GetCurrentAction(oWalker) == ACTION_WAIT;
    int bAnimating        = GetLocalInt(oWalker, WP_PLAYING_ANIMATION);
    if (bIsFighting || bIsInConversation || bMoving || bWaiting || bAnimating)
        return;

    // Initialize if necessary
    if (!wp_GetWalkCondition(WP_WALK_FLAG_INITIALIZED))
    {
        wp_LookUpWalkWayPoints();
        wp_SetWalkCondition(WP_WALK_FLAG_INITIALIZED);

        // Use appropriate skills, only once
        // TODO: replace these with custom flagset variables?
        if (GetSpawnInCondition(NW_FLAG_STEALTH))
            SetActionMode(oWalker, ACTION_MODE_STEALTH, TRUE);

        if (GetSpawnInCondition(NW_FLAG_SEARCH))
            SetActionMode(oWalker, ACTION_MODE_DETECT, TRUE);
    }

    // Try to reduce the number of calls to wp_GetNextWalkWayPoint that occur
    // when cross-area NPCs enter a different area and perceive all the
    // creatures there. All those perception events each cause wp_WalkWayPoints
    // to fire which in turn causes wp_GetNextWalkWayPoint to run which advances
    // the NPCs patrol route (WP_CURRENT_WAYPOINT) even though he hasn't visited
    // any of the waypoints. This often causes the NPC to turn and walk into a
    // wall immediately upon entering an area.
    object oCurrentArea = GetArea(oWalker);
    object oPreviousArea = GetLocalObject(oWalker, WP_PREVIOUS_AREA);

    if (!GetIsObjectValid(oCurrentArea))
        return;  // Don't do anything during area transitions.

    if (oCurrentArea != oPreviousArea)
    {
        if (GetIsObjectValid(oPreviousArea))
        {
            // NPC just made a cross-area transition since the last call to
            // wp_WalkWayPoints. If he is already moving to his next waypoint,
            // do nothing.
            if (bCalledFromHeartbeat)
                SetLocalObject(oWalker, WP_PREVIOUS_AREA, oCurrentArea);
            if (GetLocalInt(oWalker, WP_WALKING_TO))
                return;
        }
        else
            SetLocalObject(oWalker, WP_PREVIOUS_AREA, oCurrentArea);
    }

    // Move to the next waypoint
    object oWaypoint = wp_GetNextWalkWayPoint(oWalker);
    if (GetIsObjectValid(oWaypoint))
    {
        // Initialize all variables by pulling them from the waypoint and
        // validating the values found. Set invalid values to their defaults.
        int    nNth               = 1;
        string sNth               = IntToString(nNth);
        float  fWaypointPause     = GetLocalFloat(oWaypoint, WP_WALKWAY_PAUSE);
        int    nAnimation         = GetLocalInt(oWaypoint, WP_WALKWAY_ANIMATION + sNth) - 1;
        float  fAnimationSpeed    = GetLocalFloat(oWaypoint, WP_WALKWAY_ANIMATION + sNth + WP_SPEED);
        float  fAnimationDuration = GetLocalFloat(oWaypoint, WP_WALKWAY_ANIMATION + sNth + WP_DURATION);
        fWaypointPause     = ((fWaypointPause < 0.0) ? 0.0 : ((fWaypointPause == 0.0) ? fPause : fWaypointPause));
        nAnimation         = ((((nAnimation >= 0)   && (nAnimation <= 30)) ||
                             ((nAnimation >= 100) && (nAnimation <= 116))) ? nAnimation : - 1);
        fAnimationSpeed    = ((fAnimationSpeed <= 0.0) ? 1.0 : fAnimationSpeed);
        fAnimationDuration = ((fAnimationDuration <= 0.0) ? 0.0 : fAnimationDuration);

        wp_SetWalkCondition(WP_WALK_FLAG_CONSTANT);
        ClearAllActions();

        // If the variable WP_WALKWAY_DEBUG_VOLUME is set to 1-4 on the NPC
        // then make him speak or shout his destination waypoint.
        string sDebug = GetTag(oWaypoint);
        switch (GetLocalInt(oWalker, WP_WALKWAY_DEBUG_VOLUME))
        {
            case 1: case 3: SpeakString(sDebug, TALKVOLUME_TALK);  break;
            case 2: case 4: SpeakString(sDebug, TALKVOLUME_SHOUT); break;
        }

        // Determine whether to run to the waypoint.
        nRun = ((nRun == 0) ? GetLocalInt(oWalker, WP_RUN) : nRun);
        nRun = ((nRun == 0) ? GetLocalInt(oWalker, WP_RUN + WP_HOUR + IntToString(GetTimeHour())) : nRun);
        nRun = ((nRun == 0) ? GetLocalInt(oWaypoint, WP_RUN) : nRun);

        // Sets the variable WP_WALKWAY_FORCE_MOVE. If present it uses the
        // ActionForceMove instead of ActionMove. Also sets the internal
        // variable WP_WALKING_TO which is used to determine when the NPC has
        // been issued the command to walk to the waypoint but has yet to arrive
        // there. Used by wp_DetectStuckWayWalker().
        DeleteLocalInt(oWalker, WP_WALKING_TO);
        ActionDoCommand(SetLocalInt(oWalker, WP_WALKING_TO, TRUE));
        float fForceMove = GetLocalFloat(oWalker, WP_WALKWAY_FORCE_MOVE);
        if (fForceMove > 0.0)
            ActionForceMoveToObject(oWaypoint, nRun, 1.0, fForceMove);
        else
            ActionMoveToObject(oWaypoint, nRun);
        ActionDoCommand(DeleteLocalInt(oWalker, WP_WALKING_TO));

        if (GetLocalInt(oWaypoint, WP_WAYPOINT_SET_FACING))
            ActionDoCommand(SetFacing(GetFacing(oWaypoint)));

        // Use the pause variable if found.
        if (fWaypointPause > 0.0)
            ActionWait(fWaypointPause);

        // Play the animation if found.
        if (nAnimation >= 0)
        {
            ActionDoCommand(SetLocalInt(oWalker, WP_PLAYING_ANIMATION, TRUE));
            while (nAnimation >= 0)
            {
                ActionPlayAnimation(nAnimation, fAnimationSpeed, fAnimationDuration);

                if (fWaypointPause > 0.0)
                    ActionWait(fWaypointPause);

                nNth++;
                sNth = IntToString(nNth);
                fWaypointPause     = GetLocalFloat(oWaypoint, WP_WALKWAY_PAUSE);
                nAnimation         = GetLocalInt(oWaypoint, WP_WALKWAY_ANIMATION + sNth) - 1;
                fAnimationSpeed    = GetLocalFloat(oWaypoint, WP_WALKWAY_ANIMATION + sNth + WP_SPEED);
                fAnimationDuration = GetLocalFloat(oWaypoint, WP_WALKWAY_ANIMATION + sNth + WP_DURATION);

                fWaypointPause     = ((fWaypointPause < 0.0) ? 0.0 : ((fWaypointPause == 0.0) ? fPause : fWaypointPause));
                nAnimation         = ((((nAnimation >= 0)   && (nAnimation <= 30)) ||
                                     ((nAnimation >= 100) && (nAnimation <= 116))) ? nAnimation : - 1);
                fAnimationSpeed    = ((fAnimationSpeed <= 0.0) ? 1.0 : fAnimationSpeed);
                fAnimationDuration = ((fAnimationDuration <= 0.0) ? 0.0 : fAnimationDuration);
            }

            ActionDoCommand(DelayCommand(fAnimationDuration + 0.05, DeleteLocalInt(oWalker, WP_PLAYING_ANIMATION)));
        }

        // Run scripts attached to the waypoint
        int nIndex = 1;
        string sScript = GetLocalString(oWaypoint, WP_WALKWAY_SCRIPT + IntToString(nIndex));
        if (sScript != "")
        {
            ActionDoCommand(SetLocalInt(oWalker, WP_DISABLE_WALK_WAYPOINTS, TRUE));

            while (sScript != "")
            {
                ActionDoCommand(ExecuteScript(sScript, oWalker));
                if (fWaypointPause > 0.0)
                    ActionWait(fWaypointPause);
                sScript = GetLocalString(oWaypoint, WP_WALKWAY_SCRIPT + IntToString(++nIndex));
            }

            ActionDoCommand(DeleteLocalInt(oWalker, WP_DISABLE_WALK_WAYPOINTS));
        }

        ActionDoCommand(wp_WalkWayPoints(WP_DEFAULT_RUN_TO_WAYPOINTS, fPause));
    }
}

// void main() {}
