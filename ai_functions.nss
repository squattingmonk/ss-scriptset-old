/*
Filename:           ai_functions
System:             Memetic AI (library script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jul. 03, 2009
Summary:
Memetic AI library script. This is a library of functions that can be added to
an NPC's response tables response table.

How does this work?

The functions in this library can be added to an NPC's response tables, either
in the NPC's spawn script or in a class. With each call to ai_AddResponse, the
NPC's pool of possible actions is increased. These functions are executed in
order, within the table. If the function returns an object, the meme assumes it
has choosen to run and stops trying functions.

At the end of this library you will find a main() function. This contains the
code that registers and runs the classes in this library. Read the instructions
to add your own classes to this library or to a new library.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_main"

// ----- Begin ambient functions -----------------------------------------------
// The ambient behavior meme uses two variables on NPC_SELF.
// The AmbientTable variable points to the current response table structure.
// The AMBIENT_DEFAULT variable points to the default table structure.
// Functions can change the current ambient table in response to internal
// state changes, like "lunch time" or "work". Of course, dedicated event
// handlers can also receive messages and switch response tables accordingly.



// This function checks to see if this NPC is supposed to be in a particular area.
// The names of the areas are stored on the NPC. You can have more than one list
// of legal area tags. Like this: "Home Area at Night 1", "Home Area at Dawn 1".
// You tell this function which list to use by setting "Home State".
// You can also list a series of home objects that the NPC will try and stand
// if, they are around. Like this: "Home Object at Night 1", "Home Object at Work 1".
object DoGoHome()
{
    // First, if there are no areas listed for the given "Home State" then
    // the NPC is allowed to be anywhere.

    string sHomeState = ai_GetConfigString(OBJECT_SELF, "MT: Home State");
    if (sHomeState == "") return OBJECT_INVALID;

    object oMeme = ai_CreateMeme("ai_m_gotoarea");
    SetLocalString(oMeme, "AreaConfString", "MT: Home Area at "+sHomeState);

    return oMeme;
}

object DoRandomWalk()
{
    ai_PrintString("DoRandomWalk");

    object oMeme = ai_CreateMeme("ai_m_wander", AI_PRIORITY_DEFAULT, 0, 0);
    ai_StopMeme(oMeme, 6.0 + 6.0 * Random(2)); // Approx. one to three rounds
    return NPC_SELF;
}

object DoNothing()
{
    ai_PrintString("DoNothing");

    ActionWait(6.0); // Approx. one round
    return NPC_SELF;
}

// This is an example of an ambient animation function. It uses a
// generic animation meme to perform the sitting animation...
object DoSit()
{
    ai_PrintString("DoSit");

    object oSit = ai_CreateMeme("ai_m_animate", AI_PRIORITY_DEFAULT, 0, 0);

    SetLocalFloat(oSit, "Duration", 20.0);
    SetLocalInt  (oSit, "Animation", ANIMATION_LOOPING_SIT_CROSS);
    SetLocalInt  (oSit, "IsResumable", TRUE);

    return NPC_SELF;
}

/*------------------------------------------------------------------------------
 *   Script: Library Initialization and Scheduling
 *
 *   This main() defines this script as a library. The following two steps
 *   handle registration and execution of the scripts inside this library. It
 *   is assumed that a call to ai_LoadLibrary() has occured in the ModuleLoad
 *   callback. This lets the ai_ExecuteScript() function know how to find the
 *   functions in this library. You can create your own library by copying this
 *   file and editing the ai_hooks to register the name of your new library.
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
        ai_LibraryFunction("DoRandomWalk",                   0x0100);
        ai_LibraryFunction("DoNothing",                      0x0200);
        ai_LibraryFunction("DoSit",                          0x0300);
        ai_LibraryFunction("DoGoHome",                       0x0400);

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
        case 0x0100: ai_SetResult(DoRandomWalk()); break;
        case 0x0200: ai_SetResult(DoNothing());    break;
        case 0x0300: ai_SetResult(DoSit());        break;
        case 0x0400: ai_SetResult(DoGoHome());     break;

    }

    ai_DebugEnd();
}
