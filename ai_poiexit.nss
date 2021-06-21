/*
Filename:           ai_poiexit
System:             Memetic AI (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       July 28, 2009
Summary:
Point of Interest Emitter Exit event hook-in script for the Memetic AI system.
This is called when a creature leaves the vicinity of a location or creature
that has an area of effect emitter, created by calls to ai_DefineEmitter() and
ai_AddEmitterTo*(). It handles optional exit notification to the creature
walking away from the PoI.

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
    ai_DebugStart("ExitEmitterArea", AI_DEBUG_TOOLKIT);

    object oModule   = GetModule();
    object oEmitter  = GetAreaOfEffectCreator();
    object oCreature = GetExitingObject();
    string sName, sFunction;
    int i;

    for (i = ai_GetStringCount(oEmitter, POI_EMITTER) - 1; i >= 0; i--)
    {
        sName = ai_GetStringByIndex(oEmitter, i, POI_EMITTER);

        ai_PrintString("Looking at emitter " + sName);
        ai_RemoveObjectRef(oEmitter, oCreature, sName);

        if (GetLocalInt(oCreature, POI_EMITTER+sName))
        {
            string sExitText = GetLocalString(oModule, POI_EMITTER_PREFIX + sName + POI_EMITTER_EXIT_TEXT);
            ai_PrintString("sExitText is "+sExitText);

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
                DelayCommand(0.0, Action(ai_CallFunction(sFunction, oCreature, OBJECT_SELF)));
            }

            // Clean up the variable we stuck on the player.
            DeleteLocalInt(oCreature, POI_EMITTER + sName);
        }
    }

    ai_DebugEnd();
}
