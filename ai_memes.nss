/*
Filename:           ai_memes
System:             Memetic AI (library)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       June 14, 2009
Summary:
Core Library of Memes
This is the default library of memetic objects. It contains some sample memes.
All of these should be easy to understand, execept for ai_m_sequence; this is a
private meme stored in ai_i_main.

This library will grow and ultimately be a standard collection of reuseable
higher-order behaviors.

Many memes read variables from the NPC directly. This allows builders to tweak
the NPC behavior through the toolkit. When an NPC becomes an instance of a
class, the class _go script may set these variables on the NPC to auto-configure
them for the user. Unfortunately these settings won't be visible in the toolkit
and may be overridden by the class.

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
#include "x0_i0_anims"


/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_donothing (Do Nothing)
 *  Author:  William Bull
 *    Date:  April, 2003
 * Purpose:  This is a dummy meme that quits, immediately. It is useful for
 *           generators that want to spawn a number of solution memes. In
 *           the future it will be used by a problem solver.
 -----------------------------------------------------------------------------
 * No data.
 -----------------------------------------------------------------------------*/

void ai_m_donothing_end()
{
    return;
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_flee
 *  Author:  William Bull
 *    Date:  April, 2003
 * Purpose:  This is a simple meme that has the creature move away from
 *           something, then sets its priority to NONE.
 -----------------------------------------------------------------------------
 * No data.
 -----------------------------------------------------------------------------*/

void ai_m_flee_go()
{
    ai_DebugStart("Flee event = 'Go'", AI_DEBUG_COREAI);
    object oTarget = GetLocalObject(MEME_SELF, "Target");
    int    bRun    = GetLocalInt   (MEME_SELF, "Run");
    float  fRange  = GetLocalFloat (MEME_SELF, "Range");
    int    nCount = ai_GetStringCount(MEME_SELF);
    string sText  = ai_GetStringByIndex(MEME_SELF, Random(nCount));

    if (sText != " " && sText != "")
    {
        ai_PrintString("Saying: '"+sText+"'.");
        ActionSpeakString(sText);
    }

    ActionMoveAwayFromObject(oTarget, bRun, fRange);
    ai_DebugEnd();
    return;
}

void ai_m_flee_end()
{
    ai_DebugStart("Flee event = 'End'", AI_DEBUG_COREAI);
    ai_SetPriority(MEME_SELF, AI_PRIORITY_NONE);
    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_walkwp (Walk WayPoints)
 *  Author:  William Bull
 *    Date:  September, 2002
 * Purpose:  This is an enhanced Bioware-compatible walk waypoint behavior. It
 *           traverses a set of waypoints that correspond to the tag of the NPC.
 -----------------------------------------------------------------------------
 * No data.
 -----------------------------------------------------------------------------*/

// Utility function to get the waypoint with the right two-digit name.
object GetWaypoint(int nCurrent)
{
    object oResult = OBJECT_INVALID;

    if (GetIsNight() || GetIsDusk())
    {
        if (nCurrent < 10)
            return GetWaypointByTag("WN_" + GetTag(OBJECT_SELF) + "_0" + IntToString(nCurrent));
        else
            return GetWaypointByTag("WN_" + GetTag(OBJECT_SELF) + "_"  + IntToString(nCurrent));
    }

    if (oResult == OBJECT_INVALID)
    {
        if (nCurrent < 10)
            return GetWaypointByTag("WP_" + GetTag(OBJECT_SELF) + "_0" + IntToString(nCurrent));
        else
            return GetWaypointByTag("WP_" + GetTag(OBJECT_SELF) + "_"  + IntToString(nCurrent));
    }

    return oResult;
}

void ai_m_walkwp_ini()
{
    ai_DebugStart("WalkWP event = 'Init'", AI_DEBUG_COREAI);

    object oWaypoint = OBJECT_INVALID;
    int    nCurrent  = GetLocalInt(MEME_SELF, "CurrentWPIndex");
    float  fDist     = 0.0;
    float  fClosest  = 9999.0;
    object oClosest;
    int    nClosest, i;

    // Let's find our closest waypoint and start from there.
    // This may *not* be exactly what Bioware's WalkWP does, but it's useful.
    if (nCurrent == 0)
    {
        ai_PrintString("Looking for closest waypoint.");
        oWaypoint = GetWaypoint(1);
        object oObjectArea = GetArea( OBJECT_SELF );
        for (i = 1; GetIsObjectValid(oWaypoint); i++)
        {
            fDist = GetDistanceBetween(OBJECT_SELF, oWaypoint);
            if (fDist < fClosest)
            {
                if (GetArea(oWaypoint) == oObjectArea)
                {
                    fClosest = fDist;
                    nClosest = i;
                    oClosest = oWaypoint;
                    ai_PrintString("Closest waypoint is now "+GetTag(oWaypoint)+" .");
                }
            }
            oWaypoint = GetWaypoint(i);
        }
        nCurrent = nClosest;
        oWaypoint = oClosest;
    }

    SetLocalInt(MEME_SELF, "CurrentWPIndex", nCurrent);
    SetLocalObject(MEME_SELF, "CurrentWP", oWaypoint);

    ai_DebugEnd();
}

void ai_m_walkwp_go()
{
    ai_DebugStart("WalkWP event = 'Go'", AI_DEBUG_COREAI);

    object oWP  = GetLocalObject(MEME_SELF, "CurrentWP");
    int    bRun = GetLocalInt(MEME_SELF, "Run");

    if (GetLocalInt(MEME_SELF, "StealthMode"))
        ActionUseSkill(SKILL_HIDE, OBJECT_SELF);
    if (GetLocalInt(MEME_SELF, "SearchMode"))
        ActionUseSkill(SKILL_SEARCH, OBJECT_SELF);
    if (GetIsObjectValid(oWP))
    {
        ai_PrintString("Moving to object.");
        // This only does a bee-line movement if there is NOT a door immediately in
        // front of the NPC, he will not position himself to use the door to get to
        // the object. The best reason I can think of for this is that Bioware's
        // ActionMoveToObject has been optimized to move towards moving tracked
        // positions. The lookup in the walk mesh is expensive and avoided.
        //ActionMoveToObject(oWP, iRun);
        ActionMoveToLocation(GetLocation(oWP), bRun);
    }

    ai_DebugEnd();
}

void ai_m_walkwp_end()
{
    ai_DebugStart("WalkWP event = 'End'", AI_DEBUG_COREAI);

    object oWaypoint, oSequence;
    int    nCurrent  = GetLocalInt(MEME_SELF, "CurrentWPIndex");

    // I should be going to my day/night post.
    if (nCurrent == 0)
    {
        if (GetIsNight() || GetIsDusk())
        {
            oWaypoint = GetWaypointByTag("NIGHT_" + GetTag(OBJECT_SELF));
            if (GetIsObjectValid(oWaypoint) && GetDistanceBetween(OBJECT_SELF, oWaypoint) < 1.5)
            {
                oSequence = GetLocalObject(MEME_SELF, "NightPostSequence");
                nCurrent++;
            }
        }
        else
        {
            oWaypoint = GetWaypointByTag("POST_" + GetTag(OBJECT_SELF));
            if (GetIsObjectValid(oWaypoint) && GetDistanceBetween(OBJECT_SELF, oWaypoint) < 1.5)
            {
                oSequence = GetLocalObject(MEME_SELF, "PostSequence");
                nCurrent++;
            }
        }

        if (!GetIsObjectValid(oSequence))
            oSequence = GetLocalObject(MEME_SELF, "WaypointSequence");
        // If there are no posts, just start walking.
        if (!GetIsObjectValid(oWaypoint))
        {
            // If there are not posts or waypoints, destroy this meme as a preventative measure.
            if (!GetIsObjectValid(GetWaypoint(1)))
            {
                ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
                ai_DebugEnd();
                return;
            }
            nCurrent++;
        }
    }

    // I just reached one of my waypoints.
    else
    {
        oWaypoint = GetWaypoint(nCurrent);
        if (GetDistanceBetween(OBJECT_SELF, oWaypoint) < 1.5)
        {
            ai_PrintString("Reached waypoint "+IntToString(nCurrent)+".");
            if (GetIsDay() || GetIsDawn())
                oSequence = GetLocalObject(MEME_SELF, "WaypointSequence");
            else
            {
                oSequence = GetLocalObject(MEME_SELF, "NightWaypointSequence");
                if (!GetIsObjectValid(oSequence))
                    oSequence = GetLocalObject(MEME_SELF, "WaypointSequence");
            }
        }
        nCurrent++;
    }

    // Let's pick the next waypoint -- slightly different from the NWN function.
    // This enforces that the NPC hits each point. It doesn't resume from the
    // closest one. (Perhaps not the best behavior.)
    if (nCurrent > 0)
    {
        oWaypoint = GetWaypoint(nCurrent);
        if (!GetIsObjectValid(oWaypoint))
        {
            ai_PrintString("Waypoint "+IntToString(nCurrent)+" is not valid.");
            nCurrent = 0;
        }
    }

    if (GetIsObjectValid(oSequence))
        ai_StartSequence(oSequence);
    SetLocalInt   (MEME_SELF, "CurrentWPIndex", nCurrent);
    SetLocalObject(MEME_SELF, "CurrentWP", oWaypoint);

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_attack
 *  Author:  William Bull
 *    Date:  August, 2002
 * Purpose:  Causes the NPC to attack something. It assumes it is a repeating
 *           meme, changing its priority to none when completed to return to a
 *           "dormant" state. If it's not a repeating meme, it'll still work.
 *
 *   Notes:  This is a terrible example of a meme, it hardcodes a signal "3"
 *           to be sent when it successfully attacks. This should be changed.
 -----------------------------------------------------------------------------
 * Object "Enemy": The creature you should be attacking.
 -----------------------------------------------------------------------------*/

void ai_m_attack_go()
{
    ai_DebugStart("Attack event='Go'", AI_DEBUG_COREAI);
    object oEnemy = GetLocalObject(MEME_SELF, "Enemy");
    ActionForceMoveToObject(oEnemy, TRUE, 2.0);
    ActionAttack(oEnemy);
    ai_DebugEnd();
}

void ai_m_attack_end()
{
    ai_DebugStart("Attack event='End'", AI_DEBUG_COREAI);
    ai_SetPriority(MEME_SELF, AI_PRIORITY_NONE);
    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_goto
 *  Author:  William Bull
 *    Date:  July, 2002
 * Purpose:  This goes to a place and says something.
 -----------------------------------------------------------------------------
 * Object Target: the thing to move towards
 * String List "Start": Strings to be said as you begin to move.
 * String List "Success": Strings to be said when you get somewhere.
 * Integer "Run": A bool that says to run or not.
 -----------------------------------------------------------------------------*/

void ai_m_goto_go()
{
    ai_DebugStart("Goto event = 'Go'", AI_DEBUG_COREAI);

    object oTarget = ai_GetObjectByIndex(MEME_SELF, 0, "Target");

    int i = Random(ai_GetStringCount(MEME_SELF, "Start"));
    string sText = ai_GetStringByIndex(MEME_SELF, i, "Start");

    // If there are no more people to walk to, stop.
    if (!GetIsObjectValid(oTarget))
    {
        ai_SetMemeResult(FALSE);
        ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
        ai_PrintString("I'm done walking.");
        ai_DebugEnd();
        return;
    }

    // For debugging purposes, I'll have the creature glow here.
    effect e = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, e, OBJECT_SELF, 2.0);

    // We can say something as we're going there
    if (sText != " " && sText != "")
    {
        ai_PrintString("Saying: '"+sText+"'.");
        ActionSpeakString(sText);
    }

    if (GetLocalInt(MEME_SELF, "Run"))
        ActionMoveToObject(oTarget, TRUE, 1.5);
    else
        ActionMoveToObject(oTarget, FALSE, 1.5);

    // We can say something when we got there
    i = Random(ai_GetStringCount(MEME_SELF, "End"));
    sText = ai_GetStringByIndex(MEME_SELF, i, "End");

    if (sText != " " && sText != "")
    {
        ai_PrintString("Saying: '"+sText+"'.");
        ActionSpeakString(sText);
    }

    // We just wait for a second to give you a chance to see the creature got
    // there. The creature will stand for a second before resuming other
    // behaviors. In case you're wondering, yes, this is arbitrarily put here.

    // These little things can reinforce the natural look of the behavior.
    // For example, notice that this behavior speaks a string. What would be
    // smart is to change this 1.0 to a value calculated based on the length
    // of the string to be spoken. This is left as an exercise to the reader.
    // (That means you.)

    ActionWait(1.0);

    ai_DebugEnd();
}

// We successfully saw someone; lets remove them from our list.
void ai_m_goto_end()
{
    ai_DebugStart("Goto event='End'", AI_DEBUG_COREAI);
    ai_RemoveObjectByIndex(MEME_SELF, 0, "Target");
    ai_RemoveStringByIndex(MEME_SELF, 0);

    // If there are no more people to walk to, stop.
    if (ai_GetObjectCount(MEME_SELF, "Target") == 0)
    {
        ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
        ai_DebugEnd();
        return;
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_say
 *  Author:  William Bull
 *    Date:  September, 2002
 * Purpose:  This randomly selects on thing and says it.
 -----------------------------------------------------------------------------
 * String List "": Strings to be said.
 -----------------------------------------------------------------------------*/

void ai_m_say_go()
{
    ai_DebugStart("Say event = 'Go'", AI_DEBUG_COREAI);

    int    nCount = ai_GetStringCount  (MEME_SELF);
    string sText  = ai_GetStringByIndex(MEME_SELF, Random(nCount));

    if (sText != " " && sText != "")
    {
        ai_PrintString("Saying: '"+sText+"'.");
        ActionSpeakString(sText);
        ActionWait(3.0);
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_sendsignal
 *  Author:  William Bull
 *    Date:  January, 2002
 * Purpose:  This sends a signal.
 -----------------------------------------------------------------------------
 * struct message "Message": The message to be sent. The channel is extracted
 *                           from the message.
 -----------------------------------------------------------------------------*/

void ai_m_sendsignal_end()
{
    ai_DebugStart("ai_m_sendsignal event = 'Go'", AI_DEBUG_COREAI);

    struct message stMsg = ai_GetLocalMessage(MEME_SELF, "Message");
    ai_BroadcastMessage(stMsg, stMsg.sChannelName);

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_wait
 *  Author:  William Bull
 *    Date:  September, 2002
 * Purpose:  This is rough example of waiting for a relative or an absolute
 *           amount of time. It does some idle animations, and assumes it is
 *           created with the AI_MEME_REPEAT flag.
 -----------------------------------------------------------------------------
 * Float "Duration": The total time you'd like to wait (optional)
 * Float "EndTime": When you'd like to stop waiting. (optional)
 -----------------------------------------------------------------------------*/

void ai_m_wait_go()
{
    ai_DebugStart("Wait event = 'Go'", AI_DEBUG_COREAI);

    float fDuration  = GetLocalFloat(MEME_SELF, "Duration");
    float fEndTime   = GetLocalFloat(MEME_SELF, "EndTime");
    float fPause     = IntToFloat(Random(3)+1);
    float fRemaining = fEndTime - ai_GetFloatTime();

    if (fEndTime == 0.0)
    {
        fEndTime   = ai_GetFloatTime() + fDuration;
        fRemaining = fDuration;
        SetLocalFloat(MEME_SELF, "EndTime", fEndTime);
    }

    if (fPause > fRemaining)
        fPause = fRemaining;

    ai_PrintString("Waiting for "+FloatToString(fPause)+" seconds.");
    ai_PrintString("Total time to wait is "+FloatToString(fDuration)+" seconds.");
    ai_PrintString("End time is"+FloatToString(fEndTime)+" seconds.");
    ai_PrintString("Current time is "+FloatToString(ai_GetFloatTime())+" seconds.");
    ai_PrintString("Remaining time is "+FloatToString(fRemaining)+" seconds.");

    if (fRemaining < 0.5)
    {
        ai_PrintString("Done waiting, clearing end time.");
        if (fRemaining < 0.0)
            fRemaining = 0.0;
        ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
        SetLocalFloat(MEME_SELF, "EndTime", 0.0);
        ActionWait(fRemaining);
    }
    else
    {
        ai_SetMemeFlag(MEME_SELF, AI_MEME_REPEAT);
        switch (Random(4))
        {
            case 0:
                ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR,1.0, fPause);
                break;
            case 1:
                ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.0, fPause);
                break;
            case 2:
                ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2, 1.0, fPause);
                break;
            case 3:
                ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD);
                ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT);
                break;
        }
        ActionWait(fPause);
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_wander
 *  Author:  William Bull
 *    Date:  September, 2002
 * Purpose:  This is rough example of random walk with some added visuals. It
 *           should be rewritten to NOT use ActionRandomWalk or use the new
 *           MemeRestart() function with timeouts. Otherwise this meme assumes
 *           you are using it in conjunction with another meme that will
 *           preempt it - the cause the random walk to stop.
 -----------------------------------------------------------------------------
 * No data.
 -----------------------------------------------------------------------------*/

void ai_m_wander_go()
{
    ai_DebugStart("Wander event = 'Go'", AI_DEBUG_COREAI);

    /* For debugging purposes, I'll have the creature glow here. */
    effect e = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, e, OBJECT_SELF, 12.0);

    switch (Random(3))
    {
        case 0:
            ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT));
            ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT));
            break;
        case 1:
            ActionDoCommand(ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2, 2.0));
            break;
        case 2:
            ActionDoCommand(ActionPlayAnimation(ANIMATION_LOOPING_PAUSE, 2.0));
            break;
        case 3:
            ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD));
            ActionDoCommand(ActionWait(1.5));
            ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD));
            break;
    }
    ActionDoCommand(ActionRandomWalk());

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *  Randomized Animations to kill the time
  -----------------------------------------------------------------------------*/
void PlayRandomFF()
{
        float fSpeed = 0.5f + (IntToFloat(Random(11)) / 10.0f);
        switch (Random(20))
        {
            case 0: case 1: case 2:
                ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, fSpeed);
                break;
            case 3: case 4: case 5:
                ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, fSpeed);
                break;
            case 6: case  7: case  8:
            case 9: case 10: case 11:
                ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, fSpeed);
                break;
            case 12:
                ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, fSpeed);
                break;
        }
        return;
}

void PlayIdleAnimations(float fPause)
{
        switch (Random(20))
        {
            case 0:
                ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR,1.0, fPause);
                break;
            case 1: case 2: case 3:
            case 4: case 5: case 6:
                ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2,1.0, fPause);
                break;
            case 7: case 8: case 9:
                PlayRandomFF();
                ActionWait(fPause);
                PlayRandomFF();
                break;
            default:
                ActionWait(fPause);

        }
        return;
}


/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_waitforever
 * Purpose:  This very simple Meme keeps playing idle Animations lasting 1 to 3
 *           seconds.
 *           It sets itself REPEAT+RESUME, so it will never stop.
 *           It is an ideal "background" Meme, to be created at very low priority
 *    Note:  no parms required.
-----------------------------------------------------------------------------*/

void ai_m_waitforever_ini()
{
    ai_DebugStart("WaitForever event = 'Ini'", AI_DEBUG_COREAI);

    ai_SetMemeFlag(MEME_SELF, AI_MEME_REPEAT | AI_MEME_RESUME);  // be sure we go on

    ai_DebugEnd();
}

void ai_m_waitforever_go()
{
    ai_DebugStart("WaitForever event = 'Go'", AI_DEBUG_COREAI);

    PlayIdleAnimations(IntToFloat(Random(3)+1));

    ai_DebugEnd();
}


/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_pause
 * Purpose:  This is rough example of waiting for an amount of time.
 *           It does some idle animations, and sets the AI_MEME_REPEAT flag
 *           to keep going for the required amount of time.
 *    Note:  This is a modified form of ai_m_wait that uses "ai_i_time" functions
 -----------------------------------------------------------------------------
 * Int   "TrueDuration": The total time you want to be idle, expressed in TrueTime
 * Float "GameDuration": The total time you'd like to wait, expressed in GameTime
 *             note: if both are set TrueDuration takes precedence
-----------------------------------------------------------------------------*/

void ai_m_pause_ini()
{
    ai_DebugStart("Pause event = 'Ini'", AI_DEBUG_COREAI);

    int   nDuration = GetLocalInt(MEME_SELF,   "TrueDuration");
    float fDuration = GetLocalFloat(MEME_SELF, "GameDuration");

    if (nDuration)
    {
        fDuration = ai_TimeToGameTime(nDuration);
        SetLocalFloat(MEME_SELF, "GameDuration", fDuration);
    }

    int   nEndDate = ai_GetCurrentDate();
    float fEndTime = ai_GetCurrentGameTime() + fDuration;
    if (fEndTime >= ai_GameHours(24))
    {
        int nDays = FloatToInt(fEndTime) / FloatToInt(ai_GameHours(24));
        nEndDate += nDays;
        fEndTime -= (ai_GameHours(24) * nDays);
    }

    SetLocalInt(MEME_SELF, "EndDate", nEndDate);
    SetLocalFloat(MEME_SELF, "EndTime", fEndTime);

    ai_SetMemeFlag(MEME_SELF, AI_MEME_REPEAT);  // be sure we repeat

    ai_DebugEnd();
}


void ai_m_pause_go()
{
    ai_DebugStart("Pause event = 'Go'", AI_DEBUG_COREAI);

    float fDuration  = GetLocalFloat(MEME_SELF, "GameDuration");
    int   nEndDate   = GetLocalInt(MEME_SELF, "EndDate");
    float fEndTime   = GetLocalFloat(MEME_SELF, "EndTime");
    float fPause     = IntToFloat(Random(3)+1);
    float fRemaining = ai_GameInterval(ai_GetCurrentGameTime(), fEndTime,
                                       ai_GetCurrentDate(),     nEndDate);

    if (fPause > fRemaining)
        fPause = fRemaining;

    ai_PrintString("Pausing for " + FloatToString(fPause)+" seconds.");
    ai_PrintString("Total time to pause is " + FloatToString(fDuration) + " seconds.");
    ai_PrintString("End date is" + IntToString(nEndDate) + " days.");
    ai_PrintString("End time is" + FloatToString(fEndTime) + " seconds.");
    ai_PrintString("Current date is" + IntToString(ai_GetCurrentDate()) + " days.");
    ai_PrintString("Current time is " + FloatToString(ai_GetCurrentGameTime()) + " seconds.");
    ai_PrintString("Remaining time is " + FloatToString(fRemaining) + " seconds.");

    if (fRemaining < 0.5)
    {
        ai_PrintString("Done pausing, clearing REPEAT flag.");

        if (fRemaining < 0.0)
            fRemaining = 0.0;

        ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT); // Stop repreating when finished
        ActionWait(fRemaining);
    }
    else
        PlayIdleAnimations(fPause);

    ai_DebugEnd();
}


/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_pauseuntil
 * Purpose:  This is rough example of waiting until a given time.
 *           It does some idle animations, and sets the MEME_REPEAT flag
 *           to keep going for the required amount of time.
 *    Note:  This is a modified form of ai_m_wait that uses "ai_i_time" functions
 -----------------------------------------------------------------------------
 * Int   "EndTime": The time-of-day you want to wait for, expressed in TrueTime
 * Int   "EndDate": The date the pause will end; if omitted it will be Today,
 *                  or Tomorrow if EndTime is earlier than the moment of Meme
 *                  creation
-----------------------------------------------------------------------------*/

void ai_m_pauseuntil_ini()
{
    ai_DebugStart("PauseUntil event = 'Ini'", AI_DEBUG_COREAI);

    int nEndDate = GetLocalInt(MEME_SELF, "EndDate");
    int nEndTime = GetLocalInt(MEME_SELF, "EndTime");

    if (!nEndDate)  // date omitted
       if (nEndTime > ai_GetCurrentTime())
            nEndDate = ai_GetCurrentDate();
       else
            nEndDate = ai_GetCurrentDate() + 1;

    float fEndTime = ai_TimeToGameTime(nEndTime);

    SetLocalInt(MEME_SELF, "EndDate", nEndDate);
    SetLocalFloat(MEME_SELF, "EndTime", fEndTime);

    ai_SetMemeFlag(MEME_SELF, AI_MEME_REPEAT);  // be sure we repeat

    ai_DebugEnd();
}


void ai_m_pauseuntil_go()
{
    ai_DebugStart("Pause_until event = 'Go'", AI_DEBUG_COREAI);

    int   nEndDate   = GetLocalInt(MEME_SELF, "EndDate");
    float fEndTime   = GetLocalFloat(MEME_SELF, "EndTime");
    float fPause     = IntToFloat(Random(3)+1);
    float fRemaining = ai_GameInterval(ai_GetCurrentGameTime(), fEndTime,
                                       ai_GetCurrentDate(),     nEndDate);

    if (fPause > fRemaining)
        fPause = fRemaining;

    ai_PrintString("Pausing for " + FloatToString(fPause) + " seconds.");
    ai_PrintString("End date is" + IntToString(nEndDate) + " days.");
    ai_PrintString("End time is" + FloatToString(fEndTime) + " seconds.");
    ai_PrintString("Current date is" + IntToString(ai_GetCurrentDate()) + " days.");
    ai_PrintString("Current time is " + FloatToString(ai_GetCurrentGameTime()) + " seconds.");
    ai_PrintString("Remaining time is " + FloatToString(fRemaining) + " seconds.");

    if (fRemaining < 0.5)
    {
        ai_PrintString("Done pausing, clearing REPEAT flag.");

        if (fRemaining < 0.0)
            fRemaining = 0.0;
        ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);

        ActionWait(fRemaining);
    }
    else
        PlayIdleAnimations(fPause);

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_converse (Start a conversation)
 *  Author:  William Bull
 *    Date:  September, 2002 - March, 2004
 * Purpose:  This brings up a conversation dialog and optionally performs
 *           conversation animations. It can preserve a sitting NPC's posture.
 -----------------------------------------------------------------------------
 * Variables read from the NPC:
 *
 *        MT: Talk Standing      MT: Talk Animated
 *        MT: Talk Busy          MT: Talk Timeout
 *        MT: Talk Sendoff       MT: Talk ResRef
 *
 -----------------------------------------------------------------------------
 * Variables set on the Meme:
 *
 * object "Speaker": the PC engage in a conversation.
 * int    "Stand"  : 1/0 - the NPC should stand when a conversation starts
 * float  "Timeout": the amount of seconds the NPC will talk before
 *                   auto-terminating the dialog.
 * string "Sendoff": the string to say when the conversation times out,
 *                   prematurely ending the conversation.
 * int    "Private": 1/0 - the conversation is private
 * string "sResRef": the resref of the conversation dialog, if empty the
 *                   default NPC dialog is used (the one set in the toolkit).
 -----------------------------------------------------------------------------*/

void _EndConversation(object oSpeaker, object oMeme)
{
    // If the conversation meme ended, is was preempted, ignore this delay command.
    if ((!GetIsObjectValid(oMeme)) || (ai_GetActiveMeme() != oMeme))
        return;

    ClearAllActions();

    // We say a string when we've been in this conversation too long.
    string sSendOff = ai_GetConfigString(MEME_SELF, "Sendoff");
    if (sSendOff != "")
        ActionSpeakString(sSendOff);

    // Use Bioware's function, found in x0_i0_anims, to do conversation animations
    if (ai_GetLocalInt(MEME_SELF, "Animate"))
    {
        int nHD = GetHitDice(OBJECT_SELF) - GetHitDice(oSpeaker);
        AnimActionPlayRandomGoodbye(nHD);
    }

    // The module must have a dialog called "c_null". This dialog has one node
    // which ends the conversation. It's an awkward way to
    SetLocalString(MEME_SELF, "ResRef", "c_null");
    ActionDoCommand(ai_RestartSystem());
}

void ai_m_converse_go()
{
    ai_DebugStart("Converse timing='go'", AI_DEBUG_COREAI);

    // NPC Configurable Variables
    int    bMakeSpeakerStand = GetLocalInt       (MEME_SELF,   "Stand");
    int    bMakeMeStand      = GetLocalInt       (MEME_SELF,   "Stand");
    int    bPrivate          = ai_GetLocalInt    (MEME_SELF,   "Private");
    int    bAnimate          = ai_GetLocalInt    (MEME_SELF,   "Animate");
    float  fTimeout          = ai_GetLocalFloat  (OBJECT_SELF, "Timeout");
    string sResRef           = ai_GetConfigString(MEME_SELF,   "ResRef");

    // Meme Specific Variables
    object oSpeaker = GetLocalObject(MEME_SELF, "Speaker");

    if (!GetIsObjectValid(oSpeaker))
    {
        ai_DebugEnd();
        return;
    }

    if (fTimeout == 0.0)
        fTimeout = 120.0;

    // These wrappers work around the sitting bugs to allow
    // conversations to start without interruption.
    if (!bMakeMeStand)      ActionDoCommand(SetCommandable(FALSE));
    if (!bMakeSpeakerStand) ActionDoCommand(SetCommandable(FALSE, oSpeaker));

    ActionStartConversation(oSpeaker, sResRef, bPrivate);

    if (!bMakeMeStand)
        ActionDoCommand(DelayCommand(0.0, SetCommandable(TRUE)));
    if (!bMakeSpeakerStand)
        ActionDoCommand(DelayCommand(0.0, SetCommandable(TRUE, oSpeaker)));

    // Bioware function, found in x0_i0_anims
    if (bAnimate)
        AnimActionPlayRandomTalkAnimation(GetHitDice(OBJECT_SELF) - GetHitDice(oSpeaker));
    else
        ActionWait(fTimeout);

    DelayCommand(fTimeout, _EndConversation(oSpeaker, MEME_SELF));

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_converse (Start a conversation)
 *  Timing:  Meme Initialized
 * Purpose:  This makes sure local variables are reset.
 -----------------------------------------------------------------------------*/

void ai_m_converse_ini()
{
    ai_DebugStart("Converse timing='ini'", AI_DEBUG_COREAI);

    ai_InheritFrom(MEME_SELF, OBJECT_SELF);

    // Should you get up when you talk? Perform basic animations?
    ai_MapInt("Stand",   "MT: Talk Standing", MEME_SELF);
    ai_MapInt("Animate", "MT: Talk Animated", MEME_SELF);

    // While engaged in a conversating, what do you say?
    ai_MapString("Goodbye", "MT: Talk Busy", MEME_SELF);
    ai_MapString("ResRef",  "MT: Talk ResRef", MEME_SELF);

    // How long do you talk? What do you say when you timeout?
    ai_MapFloat ("Timeout", "MT: Talk Timeout", MEME_SELF);
    ai_MapString("Goodbye", "MT: Talk Sendoff", MEME_SELF);

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_converse (Start a conversation)
 *  Timing:  Meme Interrupted
 * Purpose:  This cancels the conversation dialog and resumes the memetic code.
 *           This would be nicer if there was a function EndConversation().
 -----------------------------------------------------------------------------*/

void ai_m_converse_end()
{
    ai_DebugStart("Converse timing='interrupted'", AI_DEBUG_COREAI);
    DelayCommand(0.0, ai_RestartSystem());
    ai_DebugEnd();
}

void ai_m_converse_brk()
{
    ai_DebugStart("Converse timing='interrupted'", AI_DEBUG_COREAI);

    ClearAllActions();
    SetLocalString(MEME_SELF, "ResRef", "c_null");
    ActionDoCommand(ai_RestartSystem());

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_equipappropriate (EquipAppropriateWeapons)
 *  Author:  Joel Marting (a.k.a. Garad Moonbeam) - Taken from Jasperre's AI
 *    Date:  April, 2003
 * Purpose:  This meme allows the NPC to equip weapons appropriate for the target.
 -----------------------------------------------------------------------------
 * Object "Target": The target
 -----------------------------------------------------------------------------*/
void ai_m_equipappropriate_ini()
{
    ai_DebugStart("Meme name='EquipAppropriateWeapons' event='Initialize'", AI_DEBUG_COREAI);

    if(GetLocalFloat(MEME_SELF, "MIN_RANGED_DISTANCE")!=0.0f)
        SetLocalFloat(MEME_SELF, "MIN_RANGED_DISTANCE", 3.0);

    ai_DebugEnd();
}

void ai_m_equipappropriate_go()
{
    ai_DebugStart("Meme name='EquipAppropriateWeapons' event='Go'", AI_DEBUG_COREAI);

    object oSelf      = OBJECT_SELF;
    object oTarget    = GetLocalObject(MEME_SELF, "Target");
    object oRanged    = GetLocalObject(oSelf, "DW_RANGED");
    float  fMinRanged = GetLocalFloat (MEME_SELF, "MIN_RANGED_DISTANCE");
    int    bRanged    = GetIsObjectValid(oRanged);

    if (bRanged && GetItemPossessor(oRanged) != oSelf)
    {
        ai_PrintString("No ranged weapon.");

        DeleteLocalObject(oSelf, "DW_RANGED");
        bRanged = FALSE;
    }

    object oRight = (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));

    if (bRanged && (oRight != oRanged) && GetDistanceToObject(oTarget) > fMinRanged)
    {
        ai_PrintString("Equipping ranged weapon.");

        ActionEquipItem(oRanged, INVENTORY_SLOT_RIGHTHAND);
    }
    else if (GetDistanceToObject(oTarget) <= fMinRanged || !bRanged)
    {
        object oPrimary = GetLocalObject(oSelf, "DW_PRIMARY");
        int    bPrimary = GetIsObjectValid(oPrimary);

        if (bPrimary && GetItemPossessor(oPrimary) != oSelf)
        {
            ai_PrintString("No primary hand weapon.");

            DeleteLocalObject(oSelf, "DW_PRIMARY");
            bPrimary = FALSE;
        }

        object oSecondary = GetLocalObject(oSelf, "DW_SECONDARY");
        int    bSecondary = GetIsObjectValid(oSecondary);

        if (bPrimary && GetItemPossessor(oSecondary) != oSelf)
        {
            ai_PrintString("No secondary hand weapon.");

            DeleteLocalObject(oSelf, "DW_SECONDARY");
            bSecondary = FALSE;
        }

        object oShield = GetLocalObject(oSelf, "DW_SHIELD");
        int    bShield = GetIsObjectValid(oShield);

        if (bPrimary && GetItemPossessor(oShield) != oSelf)
        {
            ai_PrintString("No shield.");

            DeleteLocalObject(oSelf, "DW_SHIELD");
            bShield = FALSE;
        }

        object oTwoHanded = GetLocalObject(oSelf, "DW_TWO_HANDED");
        int    bTwoHanded = GetIsObjectValid(oTwoHanded);

        if (bTwoHanded && GetItemPossessor(oTwoHanded) != oSelf)
        {
            ai_PrintString("No two-handed weapon.");

            DeleteLocalObject(oSelf, "DW_TWO_HANDED");
            bTwoHanded = FALSE;
        }

        object oLeft = (GetItemInSlot(INVENTORY_SLOT_LEFTHAND));

         // Complete change - it will check the slots, if not equip, then do so.
        if (bPrimary && (oRight != oPrimary))
        {
            ai_PrintString("Equipping primary weapon: " + GetName(oPrimary));

            ActionEquipItem(oPrimary, INVENTORY_SLOT_RIGHTHAND);
        }

        if (bSecondary && (oLeft != oSecondary))
        {
            ai_PrintString("Equipping secondary weapon: " + GetName(oSecondary));

            ActionEquipItem(oSecondary, INVENTORY_SLOT_LEFTHAND);
        }
        else if (!bSecondary && bShield && (oLeft != oShield))
        {
            ai_PrintString("Equipping shield: " + GetName(oShield));

            ActionEquipItem(oShield, INVENTORY_SLOT_LEFTHAND);
        }

        if (!bPrimary && bTwoHanded && (oRight != oTwoHanded))
        {
            ai_PrintString("Equipping two-handed weapon: " + GetName(oTwoHanded));

            ActionEquipItem(oTwoHanded, INVENTORY_SLOT_RIGHTHAND);
        }

        // If all else fails...TRY most damaging melee weapon.
        if (!bPrimary && !bTwoHanded)
        {
            ai_PrintString("Couldn't find weapon. Using ActionEquipMostDamagingMelee instead.");

            ActionEquipMostDamagingMelee(oTarget, TRUE);
        }
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_knockdoor (WizardKnock)
 *  Author:  Joel Marting (a.k.a. Garad Moonbeam)
 *    Date:  April, 2003
 * Purpose:  This meme allows the NPC to cast knock on a locked door.
 -----------------------------------------------------------------------------
 * Object "Door": The door that's in the way
 -----------------------------------------------------------------------------*/
void ai_m_knockdoor_go()
{
    ai_DebugStart("Meme name='WizardKnock' event='Go'", AI_DEBUG_COREAI);

    object oBlocking = GetLocalObject(MEME_SELF, "Door");

    if (GetLocked(oBlocking))
        ActionCastSpellAtObject(SPELL_KNOCK, oBlocking);

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_disabletrap (DisableTrap)
 *  Author:  Joel Marting (a.k.a. Garad Moonbeam)
 *    Date:  April, 2003
 * Purpose:  This meme allows the NPC to disable a trap.
 -----------------------------------------------------------------------------
 * Object "Trap": The trap to disable
 -----------------------------------------------------------------------------*/
 void ai_m_disabletrap_go()
 {
    ai_DebugStart("Meme name='DisableTrap' event='Go'", AI_DEBUG_COREAI);

    object oGenerator   = ai_GetParentGenerator(MEME_SELF);
    int    bAutoDisable = GetLocalInt(oGenerator, "bAutoDisable");
    object oTrap        = GetLocalObject(MEME_SELF, "Trap");

    SetLocalObject(NPC_SELF, "Trap", oTrap);

    object oResult  = ai_CallFunction("SkillCheck_DisableTrap", OBJECT_SELF);
    int    bSuccess = GetLocalInt(oResult, "SC_RESULT1");
    int    nDiff    = GetLocalInt(oResult, "SC_RESULT2");

    DeleteLocalInt(oResult, "SC_RESULT1");
    DeleteLocalInt(oResult, "SC_RESULT2");
    DeleteLocalObject(NPC_SELF, "Trap");

    int nCount;
    string sText;

    if (bSuccess || bAutoDisable)
    {
        ai_PrintString("Succeeded at DisableTrap check");

        PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 6.0);
        SetTrapDisabled(oTrap);
        nCount = ai_GetStringCount  (MEME_SELF, "SuccessString");
        sText  = ai_GetStringByIndex(MEME_SELF, Random(nCount), "SuccessString");

        if (sText != " " && sText != "")
        {
            ai_PrintString("Saying: '"+sText+"'.");
            ActionSpeakString(sText);
        }
    }
    // If the check failed, force an open attempt to trigger the trap
    else
    {
        ai_PrintString("Failed DisableTrap skill check");

        nCount  = ai_GetStringCount  (MEME_SELF, "FailureString");
        sText   = ai_GetStringByIndex(MEME_SELF, Random(nCount), "FailureString");

        if (sText != " " && sText != "")
        {
            ai_PrintString("Saying: '" + sText + "'.");
            ActionSpeakString(sText);
        }
        if (nDiff >= 5)
            DoDoorAction(oTrap, DOOR_ACTION_OPEN);
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_unlockdoor (UnlockDoor)
 *  Author:  Joel Marting (a.k.a. Garad Moonbeam)
 *    Date:  April, 2003
 * Purpose:  This meme allows the NPC to unlock a locked door that is blocking it.
 -----------------------------------------------------------------------------
 * Object   "Door": The door that is blocking you.
 * Int      "bHasKey": TRUE if creature has the key to this door, FALSE otherwise
 -----------------------------------------------------------------------------*/
 void ai_m_unlockdoor_go()
 {
    ai_DebugStart("Meme name='UnlockDoor' event = 'Go'", AI_DEBUG_COREAI);

    object oBlocking = GetLocalObject(MEME_SELF, "Door");
    int    bHasKey   = GetLocalInt   (MEME_SELF, "bHasKey");

    if (bHasKey)
    {
        ai_PrintString("I've got the key, I'll use that.");
        PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 5.0);
        SetLocked(oBlocking, FALSE);
    }
    else
    {
        ai_PrintString("I'm going to have to pick it.");

        SetLocalObject(NPC_SELF, "Door", oBlocking);

        object oResult  = ai_CallFunction("SkillCheck_OpenLock", OBJECT_SELF);
        int    bSuccess = GetLocalInt(oResult, "SC_RESULT");

        DeleteLocalInt(oResult, "SC_RESULT");
        DeleteLocalObject(NPC_SELF, "Door");

        int nCount;
        string sText;

        if (bSuccess)
        {
            ai_PrintString("Succeeded at OpenLock.");

            DoDoorAction(oBlocking, DOOR_ACTION_UNLOCK);
            nCount = ai_GetStringCount  (MEME_SELF, "SuccessString");
            sText  = ai_GetStringByIndex(MEME_SELF, Random(nCount), "SuccessString");

            if (sText != " " && sText != "")
            {
                ai_PrintString("Saying: '"+sText+"'.");
                ActionSpeakString(sText);
            }
        }
        else
        {
            ai_PrintString("I failed at my pick attempt. Maybe I should adjust my tactics next time.");

            PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 5.0);

            nCount = ai_GetStringCount  (MEME_SELF, "FailureString");
            sText  = ai_GetStringByIndex(MEME_SELF, Random(nCount), "FailureString");

            if (sText != " " && sText != "")
            {
                ai_PrintString("Saying: '"+sText+"'.");
                ActionSpeakString(sText);
            }

            ai_SetMemeResult(FALSE);
        }
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_opendoor (OpenDoor)
 *  Author:  Joel Marting (a.k.a. Garad Moonbeam)
 *    Date:  April, 2003
 * Purpose:  This meme allows the NPC to open a door that is blocking it.
 -----------------------------------------------------------------------------
 * Object "Door": The door that is blocking you.
 -----------------------------------------------------------------------------*/
 void ai_m_opendoor_go()
 {
    ai_DebugStart("Meme name='OpenDoor' event = 'Go'", AI_DEBUG_COREAI);

    object oBlocking = GetLocalObject(MEME_SELF, "Door");

    if (GetIsDoorActionPossible(oBlocking, DOOR_ACTION_OPEN))
        DoDoorAction(oBlocking, DOOR_ACTION_OPEN);
    else
    {
        PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5);
        ai_SetMemeResult(FALSE);
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_m_animate
 * Purpose:  This is the first cut of a multi-purpose animation meme.
 -----------------------------------------------------------------------------
 * Int   "EndTime": The optional time-of-day you want to stop this animation
 * Int   "EndDate": The optional date you want the animation to stop
 *
-----------------------------------------------------------------------------*/


void ai_m_animate_ini()
{
    ai_DebugStart("Animation timing='ini'", AI_DEBUG_COREAI);

    int   nDuration = GetLocalInt(MEME_SELF,   "TrueDuration");
    float fDuration = GetLocalFloat(MEME_SELF, "Duration");

    if (nDuration)
    {
        fDuration = ai_TimeToGameTime(nDuration);
        SetLocalFloat(MEME_SELF, "Duration", fDuration);
    }

    SetLocalInt(MEME_SELF, "EndDate", 0);
    SetLocalFloat(MEME_SELF, "EndTime", 0.0);

    ai_DebugEnd();
}

void ai_m_animate_go()
{
    ai_DebugStart("Animation timing='go'", AI_DEBUG_COREAI);

    float fRemaining;
    float fEndTime  = GetLocalFloat(MEME_SELF, "EndTime");
    int   nEndDate  = GetLocalInt(MEME_SELF,   "EndDate");

    float fDuration = GetLocalFloat(MEME_SELF, "Duration");
    float fWaitLag  = GetLocalFloat(MEME_SELF, "WaitLag");
    float fSpeed    = GetLocalFloat(MEME_SELF, "Speed");
    int nAnimation  = GetLocalInt(MEME_SELF,   "Animation");
    int nIsAction   = GetLocalInt(MEME_SELF,   "IsAction");
    int nResume     = GetLocalInt(MEME_SELF,   "IsResumable");
    int nContinue   = GetLocalInt(MEME_SELF,   "IsContinuous");

    if (nAnimation < 1)
    {
        ai_PrintString("No animation specified. Aborting.");
        ai_DebugEnd();
        return;
    }

    if (nResume)
    {
        ai_PrintString("Adding the AI_MEME_RESUME flag.");
        ai_AddMemeFlag(MEME_SELF, AI_MEME_RESUME);
    }

    if (fSpeed == 0.0)
    {
        ai_PrintString("Speed undefined, resetting to 1.0.");
        fSpeed = 1.0;
    }

    if (fEndTime <= 0.0)
    {
        nEndDate = ai_GetCurrentDate();
        fEndTime = ai_GetCurrentGameTime() + fDuration;

        if (fEndTime >= ai_GameHours(24))
        {
            int nDays = FloatToInt(fEndTime) / FloatToInt(ai_GameHours(24));
            nEndDate += nDays;
            fEndTime -= (ai_GameHours(24) * nDays);
        }

        SetLocalInt(MEME_SELF, "EndDate", nEndDate);
        SetLocalFloat(MEME_SELF, "EndTime", fEndTime);
    }

    fRemaining = ai_GameInterval(ai_GetCurrentGameTime(), fEndTime, ai_GetCurrentDate(), nEndDate);

    ai_PrintString("End date is "+IntToString(nEndDate)+" days.");
    ai_PrintString("End time is "+FloatToString(fEndTime)+" seconds.");
    ai_PrintString("Current date is "+IntToString(ai_GetCurrentDate())+" days.");
    ai_PrintString("Current time is "+FloatToString(ai_GetCurrentGameTime())+" seconds.");
    ai_PrintString("Duration is "+FloatToString(fDuration)+" seconds.");
    ai_PrintString("Remaining time is "+FloatToString(fRemaining)+" seconds.");

    SpeakString("Animation Duration: " + FloatToString(fRemaining));

    if (fRemaining < 0.5)
    {
        ai_PrintString("Finished animation, clearing REPEAT flag and reprioritizing meme.");
        SpeakString("Finished animation.");

        if (fRemaining < 0.0)
            fRemaining = 0.0;

        if (nContinue)
            ai_PrintString("Meme is continous, not clearing the REPEAT flag.");
        else
            ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);

        ActionWait(fRemaining);

    }
    else
    {
        ai_AddMemeFlag(MEME_SELF, AI_MEME_REPEAT);  // be sure we repeat

        switch (nAnimation)
        {
            case ANIMATION_FIREFORGET_BOW :
            case ANIMATION_FIREFORGET_DODGE_DUCK :
            case ANIMATION_FIREFORGET_DODGE_SIDE :
            case ANIMATION_FIREFORGET_DRINK :
            case ANIMATION_FIREFORGET_GREETING :
            case ANIMATION_FIREFORGET_HEAD_TURN_LEFT :
            case ANIMATION_FIREFORGET_HEAD_TURN_RIGHT :
            case ANIMATION_FIREFORGET_PAUSE_BORED :
            case ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD :
            case ANIMATION_FIREFORGET_READ :
            case ANIMATION_FIREFORGET_SALUTE :
            case ANIMATION_FIREFORGET_STEAL :
            case ANIMATION_FIREFORGET_TAUNT :
            case ANIMATION_FIREFORGET_VICTORY1 :
            case ANIMATION_FIREFORGET_VICTORY2 :
            case ANIMATION_FIREFORGET_VICTORY3 :
                SpeakString("Fire and Forget");
                ActionPlayAnimation(nAnimation);
                break;
            default :
                SpeakString("Looping");
                ActionPlayAnimation(nAnimation, fSpeed, fRemaining);
                break;
        }

        /*
        if (nIsAction)
        {
            float fWait;
            if (nResume)
                fWait = fRemaining - fWaitLag;
            else
                fWait = fRemaining;

            if (fWait < 0.0)
                fWait = 0.0;
            ai_PrintString("Waiting for " + FloatToString(fWait) + " seconds.");
            SpeakString("Waiting for " + FloatToString(fWait) + " seconds.");
            ActionWait(fWait);
        }
        else
        {
            ai_PrintString("Not waiting.");
            SpeakString("Not waiting.");
        }
        */
        SpeakString("Animation activated.");
        ai_DebugEnd();
        return;
    }

    ai_DebugEnd();
}

void ai_m_animate_end()
{
    ai_DebugStart("Animation timing='end'", AI_DEBUG_COREAI);
    SpeakString("Animation ending.");
    /*
    int    nEndDate   = GetLocalInt(MEME_SELF, "EndDate");
    float  fEndTime   = GetLocalFloat(MEME_SELF, "EndTime");
    float  fRemaining = ai_GameInterval(ai_GetCurrentGameTime(), fEndTime, ai_GetCurrentDate(), nEndDate);
    ai_PrintString("Finished animation, clearing REPEAT flag and reprioritizing meme.");
    ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);
    SpeakString("Animation END: clearing repeat flag.");

    ai_SetPriority(MEME_SELF, AI_PRIORITY_NONE);
    */
    ai_PrintString("Resetting end date and time.");
    SetLocalInt(MEME_SELF, "EndDate", 0);
    SetLocalFloat(MEME_SELF, "EndTime", 0.0);

    ai_ClearMemeFlag(MEME_SELF, AI_MEME_REPEAT);

    ai_DebugEnd();
}

void ai_m_idle_go()
{
    ai_DebugStart("Idle", AI_DEBUG_COREAI);

    string sResponse = ai_Respond("Idle");
    if (sResponse == "")
    {
        ai_PrintString("No response were selected, waiting...");
        ActionWait(6.0);
    }

    ai_DebugEnd();
}

/*------------------------------------------------------------------------------
 *   Script: Library Initialization and Scheduling
 *
 *   This main() defines this script as a library. The following two steps
 *   handle registration and execution of the scripts inside this library. It
 *   is assumed that a call to ai_LoadLibraries() has occured OnModuleLoad. This
 *   lets the ai_ExecuteScript() function know how to find the functions in this
 *   library. You can create your own library by copying this file and adding
 *   a MemeticLibraryX variable to the meme vault to register your new library.
 ------------------------------------------------------------------------------*/

void main()
{
    ai_DebugStart("Library name='" + MEME_LIBRARY + "'");

    //  Step 1: Library Setup
    //
    //  This is run once to bind your scripts to a unique number.
    //  The number is composed of a top half - for the "class" and lower half
    //  for the specific "method". If you are adding your own scripts, copy
    //  the example, make sure to change the first number. Then edit the
    //  switch statement following this if statement.

    if (MEME_DECLARE_LIBRARY)
    {
        ai_LibraryImplements("ai_m_sequence",         AI_METHOD_GO,    0x0100+0x01);
        ai_LibraryImplements("ai_m_sequence",         AI_METHOD_BREAK, 0x0100+0x02);
        ai_LibraryImplements("ai_m_sequence",         AI_METHOD_END,   0x0100+0x03);
        ai_LibraryImplements("ai_m_sequence",         AI_METHOD_INIT,  0x0100+0xff);

        ai_LibraryImplements("ai_m_attack",           AI_METHOD_GO,    0x0200+0x01);
        ai_LibraryImplements("ai_m_attack",           AI_METHOD_END,   0x0200+0x02);

        ai_LibraryImplements("ai_m_goto",             AI_METHOD_GO,    0x0300+0x01);
        ai_LibraryImplements("ai_m_goto",             AI_METHOD_END,   0x0300+0x02);

        ai_LibraryImplements("ai_m_say",              AI_METHOD_GO,    0x0400);
        ai_LibraryImplements("ai_m_wait",             AI_METHOD_GO,    0x0500);
        ai_LibraryImplements("ai_m_wander",           AI_METHOD_GO,    0x0600);

        ai_LibraryImplements("ai_m_walkwp",           AI_METHOD_GO,    0x0700+0x01);
        ai_LibraryImplements("ai_m_walkwp",           AI_METHOD_END,   0x0700+0x02);
        ai_LibraryImplements("ai_m_walkwp",           AI_METHOD_INIT,  0x0700+0xff);

        ai_LibraryImplements("ai_m_waitforever",      AI_METHOD_GO,    0x0800+0x01);
        ai_LibraryImplements("ai_m_waitforever",      AI_METHOD_INIT,  0x0800+0xff);

        ai_LibraryImplements("ai_m_pause",            AI_METHOD_GO,    0x0900+0x01);
        ai_LibraryImplements("ai_m_pause",            AI_METHOD_INIT,  0x0900+0xff);

        ai_LibraryImplements("ai_m_pauseuntil",       AI_METHOD_GO,    0x0A00+0x01);
        ai_LibraryImplements("ai_m_pauseuntil",       AI_METHOD_INIT,  0x0A00+0xff);

        ai_LibraryImplements("ai_m_sendsignal",       AI_METHOD_END,   0x0B00);

        ai_LibraryImplements("ai_m_donothing",        AI_METHOD_END,   0x0C00);

        ai_LibraryImplements("ai_m_flee",             AI_METHOD_GO,    0x0D00+0x01);
        ai_LibraryImplements("ai_m_flee",             AI_METHOD_END,   0x0D00+0x02);

        ai_LibraryImplements("ai_m_converse",         AI_METHOD_GO,    0x0E00+0x01);
        ai_LibraryImplements("ai_m_converse",         AI_METHOD_BREAK, 0x0E00+0x02);
        ai_LibraryImplements("ai_m_converse",         AI_METHOD_END,   0x0E00+0x03);
        ai_LibraryImplements("ai_m_converse",         AI_METHOD_INIT,  0x0E00+0xff);

        ai_LibraryImplements("ai_m_equipappropriate", AI_METHOD_GO,    0x0F00+0x01);
        ai_LibraryImplements("ai_m_equipappropriate", AI_METHOD_INIT,  0x0F00+0xff);

        ai_LibraryImplements("ai_m_opendoor",         AI_METHOD_GO,    0x1000+0x01);
        ai_LibraryImplements("ai_m_unlockdoor",       AI_METHOD_GO,    0x2000+0x01);
        ai_LibraryImplements("ai_m_disabletrap",      AI_METHOD_GO,    0x3000+0x01);
        ai_LibraryImplements("ai_m_knockdoor",        AI_METHOD_GO,    0x4000+0x01);

        ai_LibraryImplements("ai_m_idle",             AI_METHOD_GO,    0x5000+0x01);

        //ai_LibraryImplements("<name>",                AI_METHOD_GO,    0x??00+0x01);
        //ai_LibraryImplements("<name>",                AI_METHOD_BREAK, 0x??00+0x02);
        //ai_LibraryImplements("<name>",                AI_METHOD_END,   0x??00+0x03);
        //ai_LibraryImplements("<name>",                AI_METHOD_INIT,  0x??00+0xff);

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
                         case 0x01: ai_m_sequence_go();  break;
                         case 0x02: ai_m_sequence_brk(); break;
                         case 0x03: ai_m_sequence_end(); break;
                         case 0xff: ai_m_sequence_ini(); break;
                     }   break;

        case 0x0200: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_attack_go();  break;
                         case 0x02: ai_m_attack_end(); break;
                     }   break;

        case 0x0300: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_goto_go();  break;
                         case 0x02: ai_m_goto_end(); break;
                     }   break;

        case 0x0400: ai_m_say_go();    break;
        case 0x0500: ai_m_wait_go();   break;
        case 0x0600: ai_m_wander_go(); break;

        case 0x0700: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_walkwp_go();  break;
                         case 0x02: ai_m_walkwp_end(); break;
                         case 0xff: ai_m_walkwp_ini(); break;
                     }   break;

        case 0x0800: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_waitforever_go();  break;
                         case 0xff: ai_m_waitforever_ini(); break;
                     }   break;

        case 0x0900: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_pause_go();  break;
                         case 0xff: ai_m_pause_ini(); break;
                     }   break;

        case 0x0A00: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_pauseuntil_go();  break;
                         case 0xff: ai_m_pauseuntil_ini(); break;
                     }   break;

        case 0x0B00: ai_m_sendsignal_end(); break;
        case 0x0C00: ai_m_donothing_end();  break;

        case 0x0D00: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_flee_go();  break;
                         case 0x02: ai_m_flee_end(); break;
                     }   break;

        case 0x0E00: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_converse_go();  break;
                         case 0x02: ai_m_converse_brk(); break;
                         case 0x03: ai_m_converse_end(); break;
                         case 0xff: ai_m_converse_ini(); break;
                     }   break;

        case 0x0F00: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_m_equipappropriate_go();   break;
                         case 0xff: ai_m_equipappropriate_ini();  break;
                     }   break;

        case 0x1000: ai_m_opendoor_go();     break;
        case 0x2000: ai_m_unlockdoor_go();   break;
        case 0x3000: ai_m_disabletrap_go();  break;
        case 0x4000: ai_m_knockdoor_go();    break;

        case 0x5000: ai_m_idle_go();         break;

        /*
        case 0x??00: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: <name>_go();  break;
                         case 0x02: <name>_brk(); break;
                         case 0x03: <name>_end(); break;
                         case 0xff: <name>_ini(); break;
                     }   break;
        */
    }

    ai_DebugEnd();
}
