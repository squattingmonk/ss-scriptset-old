/*
Filename:           ai_events
System:             Memetic AI (library script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 23, 2009
Summary:
Memetic AI library script. This library contains some sample events. All of
these should be easy to understand. This library will grow and ultimately be a
collection of reuseable higher-order behaviors.

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

/*-----------------------------------------------------------------------------
 *    Meme:  ai_e_fight
 *  Author:  William Bull
 *    Date:  September, 2002
 * Purpose:  This is an event that looks for a valid enemy that's not dead and
 *           causes an attack meme to attack it. It's really just a sample, not
 *           to be considered perfect and reusable.
 -----------------------------------------------------------------------------
 * Object "AttackMeme": This is a dormant, AI_PRIORITY_NONE meme that represents
 *                      how the creature attacks. The event will set the "Enemy"
 *                      object ref and increase it to medium priority.
 -----------------------------------------------------------------------------*/


void ai_e_fight_go()
{
    ai_DebugStart("FightEvent");

    object oMeme = GetLocalObject(MEME_SELF, "AttackMeme");

    // An enemy has either been seen, damaged us, or died.  Look for a new enemy
    object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

    if (GetIsObjectValid(oTarget) && !GetIsDead(oTarget))
    {
        if (GetLocalObject(oMeme, "Enemy") != oTarget)
        {
            SetLocalObject(oMeme, "Enemy", oTarget);

            if (ai_GetPriority(oMeme) == AI_PRIORITY_MEDIUM)
                ai_RestartMeme(oMeme);
            else
            {
                ai_SetPriority(oMeme, AI_PRIORITY_MEDIUM);
                ai_UpdateActions();
            }
        }
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_e_prioritize
 *  Author:  William Bull
 *    Date:  September, 2002
 * Purpose:  This is an event that's used to gradually change the priority
 *           of another meme, over time. A list of adjustment values can be
 *           added to this repeating event. It will iterate over this list,
 *           gradually changing the priority. Be wary of setting the interval
 *           too short; this was intended to change a behavior over the course
 *           of several minutes or hours.
 -----------------------------------------------------------------------------
 * Int[]   "Modifier"   : The priority the meme should be set to.
 * Int[]   "Priority"   : The modifier the meme should be set to.
 * Float[] "Delay"      : The amount of time to wait for the next priority adjustment
 * Int[]   "DelayJitter": A random factor to default "in sync" priority changes
 * Object[] ""          : A list of memes to be adjusted.
 -----------------------------------------------------------------------------*/

void ai_e_prioritize_go()
{
    ai_DebugStart("Event name='"+ _GetName(MEME_SELF) + "'", AI_DEBUG_COREAI);
    object oMeme;
    int    i         = GetLocalInt       (MEME_SELF, AI_COUNTER);
    int    nModifier = ai_GetIntByIndex  (MEME_SELF, i, "Modifier");
    int    nPriority = ai_GetIntByIndex  (MEME_SELF, i, "Priority");
    int    nJitter   = ai_GetIntByIndex  (MEME_SELF, i, "DelayJitter");
    float  fDelay    = ai_GetFloatByIndex(MEME_SELF, i, "Delay");

    int j = 0;
    while (1)
    {
        oMeme = ai_GetObjectByIndex(MEME_SELF, j, "Meme");
        if (!GetIsObjectValid(oMeme)) break;

        ai_PrintString("Set priority " + IntToString(nPriority * 100 + nModifier) + ".");
        ai_SetPriority(oMeme, nPriority, nModifier);

        j++;
    }

    ai_UpdateActions(); // Inside an event, whenever you call ai_SetPriority, you must call ai_UpdateActions();

    i++;

    if (i >= ai_GetIntCount(MEME_SELF, "Priority"))
    {
        if (!ai_GetMemeFlag(MEME_SELF, AI_MEME_REPEAT))
        {
            SetLocalInt(MEME_SELF, AI_HAS_TIME_TRIGGER, 0);
            ai_DebugEnd();
            return;
        }

        i = 0;
    }

    SetLocalInt(MEME_SELF, AI_COUNTER, i);

    // Reschedule with an optional jitter.
    DelayCommand(fDelay + Random(nJitter + 1) - nJitter, ai_ActivateEvent(MEME_SELF));

    ai_DebugEnd();
}

//void ai_e_home_go()
//{
    // Document the "home state variable"
    // Receives message like Time of Day, take string data, and sets
    // home state variable. Then it kickstars a meme.
    // Then the meme appends the home state variable onto some string
    // to get lists of areas, etc.
    // The meme looks at "Home Area at <state> 1..2...3"
    // If he searches the home area and he's not there ... he needs to
    // spawn a child meme.
    // Is there a warp time envelop? We'll need an autoincrementing guid
    // that can be checked by the delay command to see if the current
    // process of moving is happening. We need to invalidate this id
    // on meme_brk (?) of the meme is interrupted by a higher meme -- but not
    // a child meme interruption. (Need to double check that a child meme
    // does not call _brk in the conventional manner.) (Need a function
    // to kill off child memes and restart the suspended parent.)
    // The first thing to do is see if any of the gateways in the immediate
    // area connect to an area I'm allowed to go to, starting with the closest
    // gateway.
    // If you are in an area you're ok with ... you need to see if you need
    // to be near any particular objects. If so, you need to find a landmark
    // object that's close to it.
//}

/*-----------------------------------------------------------------------------
 *   Event:  ai_e_setai
 *  Author:  William Bull
 *    Date:  November, 2003
 * Purpose:  This is an event that listens for the last exiting PC and causes
 *           the NPC to reduce its AI level -- putting its asleep.
 *
 *           This event works in conjunction with the memetic cb scripts for
 *           OnAreaEnter and OnAreaExit. These scripts send messages to NPCs
 *           as they enter and leave an area, keeping there AI level in sync.
 -----------------------------------------------------------------------------
 * int "Suspend": This is the AI level the NPC takes when the last PC leaves
 *                   its area. By default this is AI_LEVEL_VERY_LOW.
 * int "Normal": This is the AI level the NPC takes when a PC enters its area
 *                   its area. By default this is AI_LEVEL_LOW.
 * int "Combat": This is the AI level the NPC takes when it engages in combat.
 *                   By default this is AI_LEVEL_NORMAL.
 -----------------------------------------------------------------------------*/

void ai_e_setai_ini()
{
    SetLocalInt(MEME_SELF, "Suspend", AI_LEVEL_VERY_LOW);
    SetLocalInt(MEME_SELF, "Normal",  AI_LEVEL_LOW);
    SetLocalInt(MEME_SELF, "Combat",  AI_LEVEL_NORMAL);

    string sChannel = "Area Channel: " + GetTag(GetArea(OBJECT_SELF));
    ai_SubscribeMessage(MEME_SELF, "Area/Enter/Self", "");
    ai_SubscribeMessage(MEME_SELF, "Area/Exit/Self",  "");

    ai_SubscribeMessage(MEME_SELF, "Area/Enter/First PC", sChannel);
    ai_SubscribeMessage(MEME_SELF, "Area/Exit/Last PC",   sChannel);

    ai_SubscribeMessage(MEME_SELF, "SetAI", sChannel);

    // Set up initial
}

// A message has been received ... either you have entered
void ai_e_setai_go()
{
    ai_DebugStart("Event type='Set AI'", AI_DEBUG_COREAI);

    struct message stMsg = ai_GetLastMessage();

    if (stMsg.sMessageName == "SetAI")
    {
        int nLevel = stMsg.nData;
        SetAILevel(OBJECT_SELF, nLevel);
        ai_PrintString("Setting AI level to '" + IntToString(nLevel) + "'.");
    }

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
        ai_LibraryImplements("ai_e_fight",      AI_METHOD_GO,   0x0100+0x01);
        ai_LibraryImplements("ai_e_prioritize", AI_METHOD_GO,   0x0200+0x01);

        ai_LibraryImplements("ai_e_setai",      AI_METHOD_GO,   0x0300+0x01);
        ai_LibraryImplements("ai_e_setai",      AI_METHOD_INIT, 0x0300+0xff);

        //ai_LibraryImplements("<name>",          AI_METHOD_GO,   0x??00+0x01);
        //ai_LibraryImplements("<name>",          AI_METHOD_INIT, 0x??00+0xff);

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
        case 0x0100: ai_e_fight_go();                     break;

        case 0x0200: ai_e_prioritize_go();                break;

        case 0x0300: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_e_setai_go();      break;
                         case 0xff: ai_e_setai_ini();     break;
                     }   break;
        /*
        case 0x??00: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: <name>_go();          break;
                         case 0xff: <name>_ini();         break;
                     }   break;
        */
    }

    ai_DebugEnd();
}
