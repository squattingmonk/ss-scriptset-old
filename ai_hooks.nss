/*
Filename:           ai_hooks
System:             Memetic AI (event hook-in script library)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       June 18, 2009
Summary:
Creature event hook-in script library for the Memetic AI system. Handles
generators for each of the creature events.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "ai_i_main"

void main()
{
    string sEventType = ss_GetLastEvent();

    // Simplest case first.
    if (sEventType == "")
        return;

    string sMethod;

    // Let's check the events starting with heartbeat since it fires most often,
    // then move to those that have a chance of aborting the script. We'll set
    // the method and execute it at the end.
    if (sEventType == SS_CREATURE_EVENT_ON_HEARTBEAT) sMethod = "_hbt";
    else if (sEventType == SS_CREATURE_EVENT_ON_PERCEPTION)
    {
        if (!GetIsObjectValid(GetLastPerceived()))
        {
           ai_PrintString("OnPerception, but Invalid object", AI_DEBUG_COREAI);
           return;
        }

        // Separate generators for each type of perception. We could
        // possibly add more later on.

        if      (GetLastPerceptionSeen())      sMethod = "_see";
        else if (GetLastPerceptionVanished())  sMethod = "_van";
        else if (GetLastPerceptionHeard())     sMethod = "_hea";
        else if (GetLastPerceptionInaudible()) sMethod = "_ina";
        else                                   sMethod = "_per";
    }
    else if (sEventType == SS_CREATURE_EVENT_ON_CONVERSATION)
    {
        if (!GetIsObjectValid(GetLastSpeaker()))
            return;

        sMethod = "_tlk";
    }
    else if (sEventType == SS_CREATURE_EVENT_ON_PHYSICAL_ATTACKED)
    {
        if (!GetIsObjectValid(GetLastAttacker()))
            return;

        sMethod = "_atk";
    }
    else if (sEventType == SS_CREATURE_EVENT_ON_BLOCKED)            sMethod = "_blk";
    else if (sEventType == SS_CREATURE_EVENT_ON_COMBAT_ROUND_END)   sMethod = "_end";
    else if (sEventType == SS_CREATURE_EVENT_ON_CONVERSATION_ABORT) sMethod = "_abt";
    else if (sEventType == SS_CREATURE_EVENT_ON_CONVERSATION_END)   sMethod = "_bye";
    else if (sEventType == SS_CREATURE_EVENT_ON_DAMAGED)            sMethod = "_dmg";
    else if (sEventType == SS_CREATURE_EVENT_ON_DEATH)              sMethod = "_dth";
    else if (sEventType == SS_CREATURE_EVENT_ON_DISTURBED)          sMethod = "_inv";
    else if (sEventType == SS_CREATURE_EVENT_ON_RESTED)             sMethod = "_rst";
    else if (sEventType == SS_CREATURE_EVENT_ON_SPELL_CAST_AT)      sMethod = "_mgk";
    else if (sEventType == SS_CREATURE_EVENT_ON_SPAWN)
    {
        object oSelf = OBJECT_SELF;
        ai_DebugStart("Spawn name='" + _GetName(oSelf) + "'", AI_DEBUG_UTILITY);

        ai_DoNPCSetUp();

        //NPC_SELF = ai_InitializeNPC();

        //object oLandmark = GetWaypointByTag("LM_01");
        //object oMeme     = ai_CreateMeme("ai_m_gotolandmark");
        //SetLocalObject(oMeme, "AI_LM_DESTINATION", oLandmark);

        ai_UpdateActions();

        ai_DebugEnd();
        return;
    }
    else if (sEventType == SS_CREATURE_EVENT_ON_USER_DEFINED)
    {   // This doesn't fire often, so it's near the end.
        switch (GetUserDefinedEventNumber())
        {
        //    case EVENT_*:
        //        ai_ExecuteGenerators("*");
        //        ai_UpdateActions();
        //        break;
        }
        return;
    }
    else if (sEventType == SS_MODULE_EVENT_ON_MODULE_LOAD)
    {   // Run at the end since it only fires once during the module.
        ai_StartDebugging();
        ai_DebugStart("ModuleLoad", AI_DEBUG_UTILITY);

        ai_CreateMemeVault();

        // Asynchronus to avoid TMI.
        DelayCommand(0.0, ai_LoadLibrary("ai_memes"));
        DelayCommand(0.0, ai_LoadLibrary("ai_generators"));
        DelayCommand(0.0, ai_LoadLibrary("ai_events"));
        DelayCommand(0.0, ai_LoadLibrary("ai_classes"));
        DelayCommand(0.0, ai_LoadLibrary("ai_landmarks"));
        DelayCommand(0.0, ai_LoadLibrary("ai_functions"));
        DelayCommand(0.0, ai_LoadLibrary("ai_poiemitters"));

        // Auto-add emitters to objects.
        DelayCommand(0.0, ai_InitializeEmitters());

        // Build the landmark routing table structures.
        DelayCommand(0.0, ai_ProcessLandmarks());

        // Asynchronus to fire after libraries load.
        DelayCommand(0.01, ai_DebugEnd());
        return;
    }
    else
    {
        // Final case. All other events did not apply.
        return;
    }

    // Run our generators and update actions.
    ai_ExecuteGenerators(sMethod);
    ai_UpdateActions();
}

