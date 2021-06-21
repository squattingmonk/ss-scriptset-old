/*
Filename:           ai_poiemitters
System:             Memetic AI (library script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Aug. 26, 2009
Summary:
Memetic AI library script. This library contains the functions and methods for
creating PoI emitters. Each emitter consists of an _ini function where variables
are declared and a _go function executed when each instance is created.

At the end of this library you will find a main() function. This contains the
code that registers and runs the emitters in this library. Read the instructions
to add your own emitters to this library or to a new library.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_main"


/*-----------------------------------------------------------------------------
 *    Meme:  ai_poi_auto (Auto-Emitter)
 *  Author:  Michael A. Sinclair
 *    Date:  August, 2009
 * Purpose:  This is an auto-emitter which reads variables from an object and
             creates an emitter based on them. Since OBJECT_SELF is only valid
             in the _go function, we define the emitter there, so _ini is empty.
 -----------------------------------------------------------------------------*/

// This is called once. Its job is to declare the emitter.
void ai_poi_auto_ini()
{

}

// This is called every time a new instance of this emitter is made. Its job is
// to create the emitter on the target (OBJECT_SELF).
void ai_poi_auto_go()
{
    ai_DebugStart("ai_poi_example event='go'", AI_DEBUG_TOOLKIT);

    object oTarget  = OBJECT_SELF;
    int    nIndex   = 1;
    string sIndex   = IntToString(nIndex);
    string sEmitter = GetLocalString(oTarget, POI_EMITTER_PREFIX + sIndex);
    string sResRef, sEnterText, sExitText, sTestFunction, sActivateFunction, sExitFunction;
    int    nID, nFlags, nCacheTest, nCacheNotify;
    float  fDistance;

    while (sEmitter != "")
    {
        if (GetStringLowerCase(sEmitter) == "auto")
        {
            // Assign a unique name to the emitter
            nID      = GetLocalInt(GetModule(), POI_NEXT_NAME);
            sEmitter = IntToHexString(nID);
            SetLocalInt(GetModule(), POI_NEXT_NAME, nID + 1);
        }

        sResRef           = GetLocalString(oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_RESREF);
        sEnterText        = GetLocalString(oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_ENTER_TEXT);
        sExitText         = GetLocalString(oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_EXIT_TEXT);
        sTestFunction     = GetLocalString(oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_ENTER_FILTER);
        sActivateFunction = GetLocalString(oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_ACTIVATE_FUNCTION);
        sExitFunction     = GetLocalString(oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_EXIT_FUNCTION);
        nFlags            = GetLocalInt   (oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_FLAGS);
        fDistance         = GetLocalFloat (oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_DISTANCE);
        nCacheTest        = GetLocalInt   (oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_TEST_CACHE);
        nCacheNotify      = GetLocalInt   (oTarget, POI_EMITTER_PREFIX + sIndex + POI_EMITTER_NOTIFY_CACHE);

        // Normalize the values that have a non-zero default in ai_DefineEmitter
        nFlags    = ((nFlags == 0)      ? POI_EMIT_TO_PC : nFlags);
        fDistance = ((fDistance == 0.0) ? POI_SMALL      : fDistance);

        ai_DefineEmitter(sEmitter, sTestFunction, sActivateFunction,
                         sExitFunction, sResRef, sEnterText, sExitText, nFlags,
                         fDistance, nCacheTest, nCacheNotify);

        // Set the emitter on the object
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            ai_AddEmitterToCreature(oTarget, sEmitter);
        else
            ai_AddEmitterToLocation(GetLocation(oTarget), sEmitter);

        sIndex   = IntToString(++nIndex);
        sEmitter = GetLocalString(oTarget, POI_EMITTER_PREFIX + sIndex);
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *    Meme:  ai_poi_example (example)
 *  Author:  Michael A. Sinclair
 *    Date:  August, 2009
 * Purpose:  This is an example PoI that sends a message to any PC entering.
             This isn't a practical example of a PoI, since you're locked in to
             one message, but it lets you see how the functions are set up.
 -----------------------------------------------------------------------------*/

// This is called once. Its job is to declare the emitter.
void ai_poi_example_ini()
{
    ai_DebugStart("ai_poi_example event='init'", AI_DEBUG_TOOLKIT);

    ai_DefineEmitter(/* sName */ "example",
             /* sTestFunction */ "",
       /* sActivationFunction */ "",
             /* sExitFunction */ "",
                   /* sResRef */ "",
                /* sEnterText */ "You feel a chill - all the hairs raise up on your neck.",
                 /* sExitText */ "You feel less disturbed.",
                    /* nFlags */ POI_EMIT_TO_PC,
                 /* fDistance */ POI_SMALL);

    ai_DebugEnd();
}

// This is called every time a new instance of this emitter is made. Its job is
// to create the emitter on the target (OBJECT_SELF).
void ai_poi_example_go()
{
    ai_DebugStart("ai_poi_example event='go'", AI_DEBUG_TOOLKIT);

    object oTarget  = OBJECT_SELF;
    string sEmitter = "example";

    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        ai_AddEmitterToCreature(oTarget, sEmitter);
    else
        ai_AddEmitterToLocation(GetLocation(oTarget), sEmitter);

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
        ai_LibraryImplements("ai_poi_auto",    AI_METHOD_INIT, 0x0100+0xff);
        ai_LibraryImplements("ai_poi_auto",    AI_METHOD_GO,   0x0100+0x01);

        ai_LibraryImplements("ai_poi_example", AI_METHOD_INIT, 0x0200+0xff);
        ai_LibraryImplements("ai_poi_example", AI_METHOD_GO,   0x0200+0x01);


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
                         case 0xff: ai_poi_auto_ini();   break;
                         case 0x01: ai_poi_auto_go();    break;
                     }   break;

        case 0x0200: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0xff: ai_poi_example_ini();   break;
                         case 0x01: ai_poi_example_go();    break;
                     }   break;
    }

    ai_DebugEnd();
}
