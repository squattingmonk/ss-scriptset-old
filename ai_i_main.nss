/*
Filename:           ai_i_main
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 1, 2009
Summary:
Memetic AI primary include script. This file holds the functions commonly used
throughout the Memetic AI system.

The scripts herein are heavily based on Memetic AI by William Bull. All credit
goes to him. Without his genius this system would never be possible.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_event"
#include "ai_i_time"
#include "ai_i_response"
#include "ai_i_landmarks"
#include "ai_i_poi"


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ----- General Meme Functions ------------------------------------------------

// ---< ai_CreateMeme >---
// ---< ai_i_main >---
// Creates and returns an instance of a behavior defined in a file or library.
// You can attach variables to this meme object. When the meme runs, it accesses
// this data through the use of the global variable MEME_SELF.
// Required parameters:
// - sName: The name of the meme, for example "wait". A meme with this name
//   would be defined in a library or in the script "ai_m_wait".
// Optional Parameters:
// - nPriority: The importance of this behavior. Only the highest priority meme
//   will run at any given moment.
//   Possible values:
//   - AI_PRIORITY_LOW, AI_PRIORITY_MEDIUM, AI_PRIORITY_HIGH, and
//     AI_PRIORITY_VERYHIGH: Distinct priority bands. The most common values.
//   - AI_PRIORITY_NONE: Makes this a dormant meme. It will never execute unless
//     its priority is changed.
//   - AI_PRIORITY_DEFAULT: Allows the meme to pick a priority that makes sense
//     (usually AI_PRIORITY_MEDIUM with a modifier of 0).
//   Default value: AI_PRIORITY_LOW
// - nModifier: The value within a priority band, a number from -100 to 100.
//   Default value 0
// - nFlags: These control if the behavior of meme through its lifecycle. Some
//   memes will automatically turn their own flags on or off on creation. You
//   can mask flags together: AI_MEME_RESUME | AI_MEME_REPEAT.
//   Possible values:
//   - AI_MEME_RESUME: Makes the meme resume if it is interrupted.
//   - AI_MEME_REPEAT: Makes the meme loop. Some memes *must* loop to work (such
//     as a WalkWayPoints meme).
//   - AI_MEME_INSTANT: Only creates this meme if there are no existing memes of
//     a higher priority.
//   - AI_MEME_IMMEDIATE: Creates the meme without interrupting the current one.
//   - AI_MEME_CHILDREN: Allows multiple children to run, regardless of their
//     return results. Normally, only one successful child meme runs. All other
//     children are destroyed once a child ends without returning FALSE via a
//     call to ai_SetMemeResult(). The system assumes the child meme succeeds if
//     the meme ends without calling ai_SetMemeResult(FALSE).
//   Default value: AI_MEME_RESUME.
// - oParent: Either a generator or another meme.
object ai_CreateMeme(string sName, int nPriority = AI_PRIORITY_LOW, int nModifier = 0, int nFlags = AI_MEME_RESUME, object oParent = OBJECT_INVALID);

// ---< ai_SetMemeResult >---
// ---< ai_i_main >---
// Defines whether the meme completed successfully. For example, if the meme
// represents going somewhere, this function should be called if for some reason
// it cannot get there. This result will be used to evaluate child memes (these
// are memes which are created with a parent meme parameter). If the meme
// succeeds, the other child memes may be destroyed if this is called with a
// result of TRUE.
// NOTE: If this function is not called, the system assumes the meme succeeded.
// At this time you really only need to call ai_SetMemeResult(FALSE);
void ai_SetMemeResult(int bResult, object oMeme = OBJECT_INVALID);

// ---< ai_GetMemeResult >---
// ---< ai_i_main >---
// This tells you if the child meme has succeeded or failed. If the meme
// does not set a result via ai_SetMemeResult then the child is assumed to
// have succeeded.
int ai_GetMemeResult(object oMeme = OBJECT_INVALID);

// ---< ai_SetPriority >---
// ---< ai_i_main >---
// Sets the priority of an existing memetic object. This can include memes,
// generators, and events. In fact, any object that has an ObjectRef list named
// ChildMeme.
// Required parameters:
// - oTarget: The meme to be adjusted.
// - nPriority: The importance of this behavior: AI_PRIORITY_NONE,
//   AI_PRIORITY_LOW, AI_PRIORITY_MEDIUM, AI_PRIORITY_HIGH, AI_PRIORITY_VERYHIGH
// Optional parameters:
// - nModifier: A value within a priority band, a number from -100 to 100.
// - bPropogate: A boolean to signify that the value set on oTarget should also
//   be set on all the memes refered to in the ChildMeme object ref list. For
//   example, a generator that creates a set of memes and is associated with
//   those memes can have its default priority changed. This could cause those
//   previously created memes' priorities to change as well.
// Note: You must call ai_UpdateActions() after calling this function. This will
// cause any meme priority changes to take effect.
void ai_SetPriority(object oTarget, int nPriority, int nModifier = 0, int bPropogate = FALSE);

// ---< ai_GetPriority >---
// ---< ai_i_main >---
// Returns the internal priority of oMeme. This works on memes, generators, and
// events that have been created with a priority.
int ai_GetPriority(object oMeme);

// ---< ai_GetModifier >---
// ---< ai_i_main >---
// Returns the internal priority of oMeme. This works on memes, generators, and
// events that have been created with a priority.
int ai_GetModifier(object oMeme);

// ---< ai_DestroyMeme >---
// ---< ai_i_main >---
// Destroys oMeme and selects the next meme to be activated.
// You may need to call ai_UpdateActions() to cause the scheduled meme to execute.
void ai_DestroyMeme(object oMeme);

// ---< ai_DestroyChildMemes >---
// ---< ai_i_main >---
// Destroys the child memes that belong this parent. If this meme is suspended
// because of those child memes, you should call ai_ResumeMeme(), which calls
// this function automatically. This function does not notify the children with
// _end or _brk callbacks, it does not call ai_UpdateActions() or
// ai_ComputeBestMeme().
void ai_DestroyChildMemes(object oParent, int nResumeParent = TRUE);

// ---< ai_GetActiveMeme >---
// ---< ai_i_main >---
// Returns the currently running meme.
object ai_GetActiveMeme();

// ---< ai_GetPendingMeme >---
// ---< ai_i_main >---
// Returns a meme that is scheduled to preempt the current active meme. This is
// the meme that will run as soon as ai_UpdateActions() is called. It was chosen
// by the internal function, ai_ComputeBestMeme().
object ai_GetPendingMeme();

// ---< ai_GetMeme >---
// ---< ai_i_main >---
// Returns a meme on the current NPC with a given name and priority.
// Optional paramters (use as many as you need to limit the selection)
// - sName: A meme name, like "attack"
// - nIndex: A zero-based index into the list of matches
// - nPriority: The priority of the meme. AI_PRIORITY_DEFAULT is any priority.
object ai_GetMeme(string sName = "", int nIndex = 0, int nPriority = AI_PRIORITY_DEFAULT);

// ----- Generator Functions ---------------------------------------------------

// ---< ai_GetParentGenerator >---
// ---< ai_i_main >---
// If oMeme was created by a generator and the generator is associated to it,
// returns that generator.
object ai_GetParentGenerator(object oMeme);

// ---< ai_GetParentMeme >---
// ---< ai_i_main >---
// If oMeme was created as a child of another meme, returns that parent meme.
object ai_GetParentMeme(object oMeme);

// ---< ai_RestartMeme >---
// ---< ai_i_main >---
// Clears the action queue, interrupts the meme with a _brk call, then
// reinitializes it with an _ini call and restarts with a _go call.
// bCallInit: A TRUE or FALSE flag which causes _ini to be called.
void ai_RestartMeme(object oMeme, int bCallInit = FALSE, float fDelay = 0.0);

// ---< ai_StopMeme >---
// ---< ai_i_main >---
// Clears the action queue, interrupts the meme with a _brk call, then ends it
// naturally. If the meme is AI_MEME_REPEAT it will likely start over; if not,
// it will be destroyed and a the next meme will execute.
void ai_StopMeme(object oMeme, float fDelay = 0.0);

// ---< ai_CreateGenerator >---
// ---< ai_i_main >---
// Creates a specific generator to respond to NWN callbacks to generate memetic
// objects and signals. The generator is not immediately started. You may need
// to configure the generator's behavior by setting variables on the object
// which this function returns. You will need to start the generator by calling
// ai_StartGenerator().
// Parameters:
// - sName: The string name of the generator. This must match with a name of a
//   generator script (i.e. ai_g_attack) or a generator name in a library.
// - nPriority: The priority to be passed to memes this generator creates.
// - nModifier: The modifier to be passed to memes this generator creates.
// - nFlags: There are no officially supported generator flags at this time.
object ai_CreateGenerator(string sName, int nPriority = AI_PRIORITY_DEFAULT, int nModifier = 0, int nFlags = NOFLAGS);

// ---< ai_StartGenerator >---
// ---< ai_i_main >---
// Starts the generator and starts processing NWN callbacks. Each generator may
// be attached to many NWN callbacks. Once started, a generator may respond to
// these callbacks by creating a variety of memetic objects or communicate via
// memetic signals.
void ai_StartGenerator(object oGenerator);

// ---< ai_StopGenerator >---
// ---< ai_i_main >---
// Stops the generator, optionally removing the memetic objects the generator
// has created. Each generator may be attached to many NWN callbacks. Once
// started, a generator may respond to these callbacks by creating a variety of
// memetic objects or communicate via memetic signals. You can attach variables
// to this generator object. When the generator runs, it can access this data
// through the use of the global variable MEME_SELF.
// Parameters:
// - oGenerator: an active generator that will be stopped.
// - nRemoveChildren: a set of flags to signify which child objects to destroy:
//   - AI_TYPE_MEME: remove all memes, including sequences which have been started
//   - AI_TYPE_SEQUENCE: remove all sequences registered to this generator
void ai_StopGenerator(object oGenerator, int nRemoveChildren = AI_TYPE_MEME);

// ---< ai_DestroyGenerator >---
// ---< ai_i_main >---
// Destroys a generator. Each generator may be attached to many NWN callbacks.
// Once started, a generator may respond to these callbacks by creating a
// variety of memetic objects or communicate via memetic signals. This function
// can automatically destroy the sequences and memes created by the generater.
// Paramters:
// - oGenerator: an active generator that will be stopped.
// - nRemoveChildren: a set of flags to signify which child objects to destroy:
//   - AI_TYPE_MEME: if the meme is interrupted, auto resume the behavior,
//     otherwise destroy it.
//   - AI_TYPE_SEQUENCE: this causes the meme to loop; some memes *must* loop to
//     work, like walkwp
void ai_DestroyGenerator(object oGenerator, int nRemoveChildren = 0x011 /*AI_TYPE_MEME | AI_TYPE_SEQUENCE*/);

// ---< ai_GetGenerator >---
// ---< ai_i_main >---
// Returns a generator with the given name or by count. You can provide as many
// or as few of these parameters as you like.
// Optional parameters:
// - sName: The name of the generator, like "combat".
// - nIndex: The 0-based index of the generator, if there are more than one with
// the same name.
object ai_GetGenerator(string sName = "", int nIndex = 0);

// ---< ai_GetChildMeme >---
// ---< ai_i_main >---
// Returns the nIndex meme that was created by the given generator or meme.
// Returns OBJECT_INVALID if none exist.
// Paramters:
// - oTarget: the generator or meme that may have an associated child meme.
// - nIndex: the 0-based index of memes it has created.
object ai_GetChildMeme(object oTarget, int nIndex = 0);

// ---< ai_SuspendMeme >---
// ---< ai_i_main >---
// Suspends an active meme, optionally calling the _brk callback. This causes
// the toolkit to start the next highest priority meme.
// Parameters:
// - oMeme: The meme to be suspended.
// - bCallBrk: whether the _brk script should be called.
void ai_SuspendMeme(object oMeme, int bCallBrk = TRUE);

// ---< ai_ResumeMeme >---
// ---< ai_i_main >---
// Resumes a suspended meme; causes it to be prioritized and potentially activated.
// A meme with children cannot be resumed.
void ai_ResumeMeme(object oMeme, int bUpdateActions = TRUE);

// ---< ai_IsMemeSuspended >---
// ---< ai_i_main >---
// Returns TRUE if oMeme is currently suspended.
int ai_IsMemeSuspended(object oMeme);

// ---< ai_CreateSequence >---
// ---< ai_i_main >---
// Creates a named sequence which can be reused by calling ai_StartSequence().
// Creating a sequence is only the first step - see: ai_CreateSequenceMeme().
// A sequence encapsulates a collection of memes. It operates on each meme and
// possibly changes its priority based on the active meme. For an overview on
// sequences refer to the User's Guide.
// Required Parameters:
// - sName: The name of the sequence. You make this up arbitrarily. It doesn't
//   correspond to any script name; it's so you can access your sequences later.
// Optional Parameters:
// - nPriority: The importance of this behavior: AI_PRIORITY_DEFAULT,
//   AI_PRIORITY_HIGH, AI_PRIORITY_LOW, AI_PRIORITY_MEDIUM, AI_PRIORITY_HIGH
//   or AI_PRIORITY_VERYHIGH.
//   Using AI_PRIORITY_DEFAULT will cause the sequence to change its priority to
//   match the meme at each step.
// - nModifier: The value within a priority band, a number from -100 to 100.
// - nFlags: These control if the behavior of a meme through its lifecycle. Some
//   memes will automatically turn on or off flags their own flags once created.
//   Note: AI_MEME_RESUME and AI_MEME_REPEAT are not used in sequences.
//   Possible values:
//   - AI_SEQUENCE_REPEAT: This the sequences version of AI_MEME_REPEAT. You
//     should never clear the AI_MEME_REPEAT flag on a sequence -- clear the
//     AI_SEQUENCE_REPEAT flag if you want to stop the sequence from repeating.
//   - AI_SEQUENCE_RESUME_FIRST: This allows the sequence to resume after being
//     preempted by another meme. The sequence will restart at the first meme.
//     If a meme in the sequence has the AI_MEME_CHECKPOINT flag and it is
//     executed, the sequence will resume at this meme.
//   - AI_SEQUENCE_RESUME_LAST: This allows the sequence to resume after being
//     preempted by another meme. The sequence will restart at the last
//     completed meme. If a meme in the sequence has the AI_MEME_CHECKPOINT flag
//     and it is executed, the sequence will resume at this meme.
//   - AI_MEME_INSTANT: Do not create this meme if there are existing higher
//     priority memes.
//   - AI_MEME_IMMEDIATE: Create this meme but don't interrupt the current meme.
//   - AI_MEME_CHILDREN: Allow multiple children to run, regardless of their
//     return result. Normally, only one successful child runs. All other
//     children are destroyed once a child ends without returning FALSE via a
//     call to ai_SetMemeResult(). If the meme ends without calling
//     ai_SetMemeResult(FALSE) the toolkit assumes the child meme succeeds.
//   - You can mask flags together, for example: AI_MEME_RESUME | AI_MEME_REPEAT
// - oGenerator: the generator object that created this sequence.
object ai_CreateSequence(string sName, int nPriority = AI_PRIORITY_DEFAULT, int nModifier = 0, int nFlags = 0x005 /*AI_SEQUENCE_REPEAT | AI_SEQUENCE_RESUME_LAST*/, object oGenerator = OBJECT_INVALID);

// ---< ai_CreateSequenceMeme >---
// ---< ai_i_main >---
// Create a behavior that is defined in a file or library that will be used in a
// sequence. The primary difference between this and ai_CreateMeme is the new
// flag, AI_MEME_CHECKPOINT, described below.
// Required Parameters:
// - oSequence: The sequence this meme will belong to.
// - sName: The name of the meme, for example "m_wait" (This must correspond to
//   a meme script or meme name in a library.)
// Optional parameters:
// - nPriority: The importance of this behavior: AI_PRIORITY_DEFAULT,
//   AI_PRIORITY_HIGH, AI_PRIORITY_LOW, AI_PRIORITY_MEDIUM, AI_PRIORITY_HIGH
//   or AI_PRIORITY_VERYHIGH.
//   The highest priority meme at a given moment will actually run.
// - nModifier: The value within a priority band, a number from -100 to 100.
// - nFlags: These control if the behavior of a meme through its lifecycle. Some
//   memes will automatically turn on or off flags their own flags once created.
//   Possible values:
//   - AI_MEME_CHECKPOINT: If this meme is part of a sequence, when the sequence
//     resumes, restart at this point. If this meme is not part of a sequence,
//     this flag does nothing.
//   - AI_MEME_RESUME: If the meme is interrupted, auto resume the behavior.
//     Otherwise destroy it.
//   - AI_MEME_REPEAT: Causes the meme to loop. Some memes *must* loop to work
//     like m_walkwp.
//   - AI_MEME_INSTANT: Do not create this meme if there are existing higher
//     priority memes.
//   - AI_MEME_IMMEDIATE: Create this meme but don't interrupt the current meme.
//   - AI_MEME_CHILDREN: Allow multiple children to run, regardless of their
//     return result. Normally, only one successful child to runs. All other
//     children are destroyed once a child ends without returning FALSE via a
//     call to ai_SetMemeResult(). If the meme ends without calling
//     ai_SetMemeResult(FALSE) the toolkit assumes the child meme succeeds.
//   - You can mask flags together, for example: AI_MEME_RESUME | AI_MEME_REPEAT
// Returns an object representing a sequence. Treat this like a template that
// can be started and stopped over and over again.
object ai_CreateSequenceMeme(object oSequence, string sName, int nPriority = 2, int nModifier = 0, int nFlags = 0x10 /*AI_MEME_RESUME*/);

// ---< ai_StartSequence >---
// ---< ai_i_main >---
// Causes a sequence to run. Only one instance of the sequence may be running
// at a given time -- don't call this function twice. Returns a meme that
// represents the sequence. The priority of the meme was defined by the
// parameters used in the call to ai_CreateSequence(). This object is a real
// meme that can be reprioritized, destroyed, etc.
object ai_StartSequence(object oSequence);

// ---< ai_StopSequence >---
// ---< ai_i_main >---
// Causes the sequence to stop executing, destroying the meme. The memes inside
// the sequence are not destroyed.
void ai_StopSequence(object oSequenceMeme);

// ---< ai_DestroySequence >---
// ---< ai_i_main >---
// Destroys the sequence. If this sequence is started, it will be stopped before
// it's destroyed.
void ai_DestroySequence(object oSequence);

// ---< ai_GetSequence >---
// ---< ai_i_main >---
// Returns a sequence with a given name. This is a sequence created by the NPC.
// The name must match the string passed to ai_CreateSequence(). This name
// doesn't correspond to any script - it's just a name you make up.
object ai_GetSequence(string sName = "");

// ---< ai_CreateEvent >---
// ---< ai_i_main >---
// This creates an object that recieves and handles events. These are usually
// named e_<myeventname>. It will not execute its code until you attach a
// trigger to the event with ai_AddTrigger*() functions. After the triggers are
// added the event should be started with a call to ai_StartEvent().
//
// You can attach variables to this event object. When the event runs, it can
// access this data through the use of the global variable MEME_SELF.
// Parameters:
// - sName: This is a name that matches a script like e_observe, or is properly
//   registered in a script library.
// - nFlags: These flags will determine when the event will be destroyed or
//   scheduled. Eventually this will be AI_EVENT_REPEAT. For now only
//   AI_EVENT_PERSISTANT is supported.
//object ai_CreateEvent(string sName, int nFlag = 0x400 /* AI_EVENT_REPEAT */);

// ---< ai_ExecuteGenerators >---
// ---< ai_i_main >---
// This is an internal function to the MemeticAI Toolkit.
void ai_ExecuteGenerators(string sSuffix);

// ---< ai_ComputeBestMeme >---
// ---< ai_i_main >---
// This is an internal function to the MemeticAI Toolkit.
void ai_ComputeBestMeme(object oMeme = OBJECT_INVALID);

// ---< ai_UpdateActions >---
// ---< ai_i_main >---
// Causes the highest priority meme to become active. This is the primary
// function for starting the memetic behavior of an NPC. Normally this is used
// in an OnSpawn script for the creature after a series of memes or generators
// have been created. Multiple calls to this function will not break the flow of
// the normal behavior.
//
// Generator scripts (g_) do not normally need to call this function. It is
// called immediately after all generators are executed.
//
// This function should be called after a meme is reprioritized.
void ai_UpdateActions();

// ---< ai_RestartSystem >---
// ---< ai_i_main >---
// This is called to jump start a stalled memetic NPC. This usually happens if
// a script calls ClearAllActions. It will also cancel any current conversation
// because it calls ClearAllActions and restarts the active meme.
void ai_RestartSystem();

// ---< ai_PauseSystem >---
// ---< ai_i_main >---
// This causes the NPC to stop behaving memetically.
void ai_PauseSystem();

// ---< ai_HasScheduledMeme >---
// ---< ai_i_main >---
// This is an internal function to the MemeticAI Toolkit.
//
// Returns whether there is a meme with *at least* the given priority and
// modifier. It's used to see if memes with the AI_MEME_INSTANT flag should run.
//
// An optional object may be passed to tell the test function to skip a meme.
// This is used when child memes are created with AI_MEME_INSTANT. The parent
// meme is being suspended, but is still active while the child is being
// created. This parameter allows the function to overlook the value of the
// given meme and compare all other memes.
//
// - nPriority: this is the priority to compare it against, like
//   AI_PRIORITY_LOW, AI_PRIORITY_HIGH, etc.
// - nModifier: this is the modifier from -100 to +100
// - oExcludeMeme: this is the meme to overlook -- used to pass up memes that
//   are being suspended.
int ai_HasScheduledMeme(int nPriority, int nModifier, object oExcludeMeme=OBJECT_INVALID);

// ---< ai_DoNPCSetUp >---
// ---< ai_i_main >---
// Loads any classes, memes, or generators defined in the NPC's variables.
void ai_DoNPCSetUp(int bAutoLoadClasses = TRUE, int bUpdateActions = TRUE);

/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

// ------ Generator Functions---------------------------------------------------

object ai_CreateGenerator(string sName, int nPriority = AI_PRIORITY_DEFAULT, int nModifier = 0, int nFlags = NOFLAGS)
{
    ai_DebugStart("ai_CreateGenerator name='"+sName+"' priority='"+IntToString(nPriority)+"' modifier = '"+IntToString(nModifier)+"'", AI_DEBUG_TOOLKIT);

    if (!GetIsObjectValid(NPC_SELF))
        ai_InitializeNPC();

    object oBag = GetLocalObject(NPC_SELF, AI_GENERATOR_BAG);
    object oGenerator = _MakeObject(oBag, sName, AI_TYPE_GENERATOR);

    // Inherit the class of the context that's creating this generator.
    SetLocalString(oGenerator, AI_ACTIVE_CLASS, GetLocalString(MEME_SELF, AI_ACTIVE_CLASS));

    SetLocalInt(oGenerator, AI_MEME_PRIORITY, nPriority);
    SetLocalInt(oGenerator, AI_MEME_MODIFIER, nModifier);
    SetLocalInt(oGenerator, AI_MEME_FLAGS,    nFlags);

    ai_ExecuteScript(sName, AI_METHOD_INIT, OBJECT_SELF, oGenerator);

    ai_DebugEnd();
    return oGenerator;
}

void ai_StartGenerator(object oGenerator)
{
    ai_DebugStart("ai_StartGenerator name = '" + _GetName(oGenerator) + "'", AI_DEBUG_TOOLKIT);

    SetLocalInt(oGenerator, AI_MEME_ACTIVE, 1);

    ai_DebugEnd();
}

void ai_StopGenerator(object oGenerator, int nRemoveChildren = AI_TYPE_MEME)
{
    ai_DebugStart("ai_StopGenerator name = '" + _GetName(oGenerator)+"'", AI_DEBUG_TOOLKIT);
    SetLocalInt(oGenerator, AI_MEME_ACTIVE, 0);
    int i, nCount;
    object oMeme;

    if (GetIsFlagSet(nRemoveChildren, AI_TYPE_MEME))
    {
        nCount = ai_GetObjectCount(oGenerator, AI_CHILD_MEME);
        ai_PrintString("Destroying the memes created by this generator.");
        for (i = nCount - 1; i >= 0; i--)
        {
            oMeme = ai_GetObjectByIndex(oGenerator, i, AI_CHILD_MEME);
            ai_DestroyMeme(oMeme);
        }
    }
    if (GetIsFlagSet(nRemoveChildren, AI_TYPE_SEQUENCE))
    {
        nCount = ai_GetObjectCount(oGenerator, AI_CHILD_SEQUENCE);
        ai_PrintString("Destroying the sequence templates created by this generator.");
        for (i = nCount - 1; i >= 0; i--)
        {
            oMeme = ai_GetObjectByIndex(oGenerator, i, AI_CHILD_SEQUENCE);
            ai_DestroySequence(oMeme);
        }
    }
    ai_DebugEnd();
}

void ai_DestroyGenerator(object oGenerator, int nRemoveChildren = 0x011 /*AI_TYPE_MEME | AI_TYPE_SEQUENCE*/)
{
    ai_DebugStart("ai_DestroyGenerator name = '"+ _GetName(oGenerator)+"'", AI_DEBUG_TOOLKIT);

    if (!GetIsObjectValid(NPC_SELF))
        ai_InitializeNPC();

    int i, nCount;
    object oMeme, oBag = GetLocalObject(NPC_SELF, AI_GENERATOR_BAG);

    if (nRemoveChildren)
    {
        if (GetIsFlagSet(nRemoveChildren, AI_TYPE_MEME))
        {
            ai_PrintString("Destroying the memes created by this generator.");
            nCount = ai_GetObjectCount(oGenerator, AI_CHILD_MEME);
            for (i=0; i < nCount; i++)
            {
                oMeme = ai_GetObjectByIndex(oGenerator, i, AI_CHILD_MEME);
                ai_DestroyMeme(oMeme);
            }
        }
        if (GetIsFlagSet(nRemoveChildren, AI_TYPE_SEQUENCE))
        {
            nCount = ai_GetObjectCount(oGenerator, AI_SEQUENCE_MEME);
            ai_PrintString("Destroying the sequence templates created by this generator.");
            for (i=0; i < nCount; i++)
            {
                oMeme = ai_GetObjectByIndex(oGenerator, i, AI_SEQUENCE_MEME);
                ai_DestroyMeme(oMeme);
            }
        }
    }
    else
    {
        ai_PrintString("Diassociating this generator from the memes it created.");
        for (i = 0; i < nCount; i++)
        {
            oMeme = ai_GetObjectByIndex(oGenerator, i, AI_CHILD_MEME);
            DeleteLocalObject(oMeme, AI_MEME_GENERATOR);
        }
    }

    _RemoveObject(oBag, oGenerator);
    ai_DebugEnd();
}

object ai_GetGenerator(string sName = "", int nIndex = 0)
{
    ai_DebugStart("ai_GetGenerator name = '"+sName+"' Nth = '"+IntToString(nIndex)+"'", AI_DEBUG_TOOLKIT);

    if (!GetIsObjectValid(NPC_SELF))
        ai_InitializeNPC();

    int i, nCount;
    object oGenerator, oMeme, oBag = GetLocalObject(NPC_SELF, AI_GENERATOR_BAG);

    while (TRUE)
    {
        oMeme = ai_GetObjectByIndex(oBag, i, AI_MEME);
        if (sName == "" || _GetName(oMeme) == sName)
        {
            if (nCount == nIndex)
            {
                ai_DebugEnd();
                return oMeme;
            }
            nCount++;
        }
        if (!GetIsObjectValid(oMeme)) break;
        i++;
    }

    ai_DebugEnd();
    return OBJECT_INVALID;
}

object ai_GetChildMeme(object oTarget, int nIndex = 0)
{
    ai_DebugStart("ai_GetChildMeme name = '"+_GetName(oTarget)+"' Nth = '"+IntToString(nIndex)+"'", AI_DEBUG_TOOLKIT);

    object oMeme;
    int i, nCount = 0;

    while(TRUE)
    {
        oMeme = ai_GetObjectByIndex(oTarget, i, AI_CHILD_MEME);
        if (nCount == nIndex)
        {
            ai_DebugEnd();
            return oMeme;
        }
        nCount++;
        if (!GetIsObjectValid(oMeme)) break;
        i++;
    }

    ai_DebugEnd();
    return OBJECT_INVALID;
}

// ----- Memes Functions -------------------------------------------------------

// Private prototype
void _MemeDone(object oActiveMeme, int nRunInstance);

void ai_SuspendMeme(object oMeme, int bCallBrk = TRUE)
{
    ai_DebugStart("ai_SuspendMeme meme='"+_GetName(oMeme)+"'", AI_DEBUG_TOOLKIT);

    // Only suspend an active meme.
    if (GetLocalInt(oMeme, AI_MEME_SUSPENDED))
    {
        ai_DebugEnd();
        return;
    }

    SetLocalInt(oMeme, AI_MEME_SUSPENDED, 1);

    int nPriority = GetLocalInt(oMeme, AI_MEME_PRIORITY);
    object oPriorityBag = GetLocalObject(NPC_SELF, AI_MEME_PRIORITY_BAG + IntToString(nPriority));
    object oSuspendBag = GetLocalObject(NPC_SELF, AI_SUSPEND_BAG);

    _MoveObject(oPriorityBag, oMeme, oSuspendBag);

    if (GetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME) == oMeme)
    {
        ai_PrintString("Suspending the active meme.");
        ClearAllActions();

        if (bCallBrk)
        {
            ai_ExecuteScript(_GetName(oMeme), AI_METHOD_BREAK, OBJECT_SELF, oMeme);

            if (!GetLocalInt(oMeme, AI_MEME_SUSPENDED))
            {
                int nRunInstance = GetLocalInt(oMeme, AI_MEME_RUN_COUNT);
                nRunInstance++;
                SetLocalInt(oMeme, AI_MEME_RUN_COUNT, nRunInstance);
                ActionDoCommand(ActionDoCommand(_MemeDone(oMeme, nRunInstance)));
                ai_DebugEnd();
                return;
            }
        }

        // If there is only one meme on the NPC and it suspends, there will
        // not be any other meme to be active when ComputeBestMeme is called.
        // ActiveMeme should be cleared to prevent this situation.
        SetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME, OBJECT_INVALID);
    }

    // ai_ComputeBestMeme(oMeme);
    ai_ComputeBestMeme(OBJECT_INVALID); // Changed to invalid, the suspended one should never run again
    ai_UpdateActions();

    ai_DebugEnd();
}

// This function is fairly equivalent to repriotizing a meme; it places
// the meme into the appropriate bag and computes the best meme
void ai_ResumeMeme(object oMeme, int bUpdateActions = TRUE)
{
    // Only resume a suspended meme.
    if (!GetLocalInt(oMeme, AI_MEME_SUSPENDED))
        return;

    // Don't forget, there is a Parent
    ai_DebugStart("ai_ResumeMeme", AI_DEBUG_TOOLKIT);

    SetLocalInt(oMeme, AI_MEME_SUSPENDED, 0);

    int    nPriority    = GetLocalInt(oMeme, AI_MEME_PRIORITY);
    object oPriorityBag = GetLocalObject(NPC_SELF, AI_MEME_PRIORITY_BAG + IntToString(nPriority));
    object oSuspendBag  = GetLocalObject(NPC_SELF, AI_SUSPEND_BAG);
    _MoveObject(oSuspendBag, oMeme, oPriorityBag);

    ai_ComputeBestMeme(oMeme);

    // Make update actions optional. If more than one meme gets resumed at a
    // time, performance reasons you have to call it manually then.
    // ai_UpdateActions();
    if (bUpdateActions)
        ai_UpdateActions();

    ai_DebugEnd();
}

int ai_IsMemeSuspended(object oMeme)
{
    return GetLocalInt(oMeme, AI_MEME_SUSPENDED);
}

object ai_CreateMeme(string sName, int nPriority = AI_PRIORITY_LOW, int nModifier = 0, int nFlags = AI_MEME_RESUME, object oParent = OBJECT_INVALID)
{
    ai_DebugStart("ai_CreateMeme name = '"+sName+"' priority = '"+IntToString(nPriority)+"' modifier = '"+IntToString(nModifier)+"'", AI_DEBUG_TOOLKIT);

    object oPriorityBag, oMeme;
    int nParentType = GetLocalInt(oParent, AI_MEME_TYPE);

    if (!GetIsObjectValid(NPC_SELF))
        ai_InitializeNPC();
    if (!GetIsObjectValid(NPC_SELF))
        ai_PrintString("Assert: This is not possible");

    // If you pass AI_PRIORITY_DEFAULT you will copy the priority of the parent
    if (GetIsObjectValid(oParent) && nPriority == AI_PRIORITY_DEFAULT)
    {
        nPriority = GetLocalInt(oParent, AI_MEME_PRIORITY);
        nModifier = GetLocalInt(oParent, AI_MEME_MODIFIER);
    }

    // Adjust the modifier to match the class bias
    string sActiveClass;
    if (oParent == OBJECT_INVALID)
        sActiveClass = GetLocalString(MEME_SELF, AI_ACTIVE_CLASS);
    else
        sActiveClass = GetLocalString(oParent, AI_ACTIVE_CLASS);
    if (!(GetIsFlagSet(nFlags, AI_MEME_NO_BIAS)))
        nModifier += GetLocalInt(NPC_SELF, "AI_MEME_"+sActiveClass+"_BIAS");

    // Ensure the modifier is within bounds
    if (nModifier < -100) nModifier = -100;
    else if (nModifier > 100) nModifier = 100;

    if (nPriority == AI_PRIORITY_DEFAULT)
        nPriority = AI_PRIORITY_MEDIUM;

    if (GetIsFlagSet(nFlags, AI_MEME_INSTANT) && (ai_HasScheduledMeme(nPriority, nModifier, oParent)))
    {
        ai_PrintString("Another meme is higher than you, this meme won't get created.");
        ai_DebugEnd();
        return OBJECT_INVALID;
    }

    // Get the bag which represents the priority slot
    oPriorityBag = GetLocalObject(NPC_SELF, AI_MEME_PRIORITY_BAG + IntToString(nPriority));
    if (!GetIsObjectValid(oPriorityBag))
        ai_PrintString("Assert: cannot find priority bag.");

    // Create a meme at the given priority slot
    if (sName == "ai_m_sequence")
        oMeme = _MakeObject(oPriorityBag, sName, AI_TYPE_SEQUENCE_REF);
    else
        oMeme = _MakeObject(oPriorityBag, sName, AI_TYPE_MEME);
    if (!GetIsObjectValid(oMeme))
        ai_PrintString("Assert: did not make meme.");

    // Inherit the class of the context that's creating this generator.
    SetLocalString(oMeme, AI_ACTIVE_CLASS, GetLocalString(MEME_SELF, AI_ACTIVE_CLASS));

    if (oParent != OBJECT_INVALID)
    {
        // If this is the first child meme, clear the stale result value.
        if (ai_GetObjectCount(oParent, AI_CHILD_MEME) == 0)
            SetLocalInt(oParent, AI_MEME_RESULT, 0);

        if ((nParentType == AI_TYPE_GENERATOR)  || (nParentType == AI_TYPE_EVENT))
        {
            ai_AddObjectRef(oParent, oMeme, AI_CHILD_MEME);
            SetLocalObject(oMeme, AI_MEME_GENERATOR, oParent);
        }
        // If the parent is a meme -- or a sequence meme
        // Child memes always suspend their parent, until all children are destroyed.
        else if ((nParentType == AI_TYPE_MEME) || (nParentType == AI_TYPE_SEQUENCE_REF))
        {
            ai_AddObjectRef(oParent, oMeme, AI_CHILD_MEME);
            SetLocalObject(oMeme, AI_MEME_PARENT, oParent);

            // Immediately stop the parent, do not call its _brk callback.
            // There is no real reason why I don't call _brk -- it's left here as an
            // option to toggle back, if the it turns out that it makes more sense.
            ai_SuspendMeme(oParent, FALSE);
        }
    }
    SetLocalInt(oMeme, AI_MEME_PRIORITY, nPriority);
    SetLocalInt(oMeme, AI_MEME_MODIFIER, nModifier);
    SetLocalInt(oMeme, AI_MEME_FLAGS, nFlags);

    ai_ExecuteScript(sName, AI_METHOD_INIT, OBJECT_SELF, oMeme);
    ai_PrintString("Executing " + sName + AI_METHOD_INIT);

    ai_ComputeBestMeme(oMeme);

    ai_DebugEnd();
    return oMeme;
}

int ai_GetPriority(object oMeme)
{
    return GetLocalInt(oMeme, AI_MEME_PRIORITY);
}

int ai_GetModifier(object oMeme)
{
    return GetLocalInt(oMeme, AI_MEME_MODIFIER);
}

// Private prototype
void _DestroyMeme(object oMeme, int bCallEndScript = TRUE, int bComputeBestMeme = TRUE, int bDestroySiblings = TRUE, int bRestartParent = TRUE);

// It's important to realize that the parameters this passes to _MeDestroyMeme
// cause this function is bypass normal meme-notifcationst that they're ended
void ai_DestroyChildMemes(object oParent, int bResumeParent = TRUE)
{
    ai_DebugStart("ai_DestroyChildMemes name = '" + _GetName(oParent) + "'", AI_DEBUG_TOOLKIT);
    ai_PrintString("This meme succeeded, we don't need its siblings.", AI_DEBUG_TOOLKIT);
    int nCount = ai_GetObjectCount(oParent, AI_CHILD_MEME);
    object oSibling;
    while (nCount)
    {
        oSibling = ai_GetObjectByIndex(oParent, 0, AI_CHILD_MEME);
        ai_RemoveObjectByIndex(oParent, 0, AI_CHILD_MEME);
        _DestroyMeme(oSibling, 0, 0, 0, bResumeParent);
        nCount--;
    }
    ai_DebugEnd();
}

void _DestroyMeme(object oMeme, int bCallEndScript = TRUE, int bComputeBestMeme = TRUE, int bDestroySiblings = TRUE, int bRestartParent = TRUE)
{
    ai_DebugStart("ai_DestroyMeme name = '" + _GetName(oMeme) + "'", AI_DEBUG_TOOLKIT);

    int nPriority = GetLocalInt(oMeme, AI_MEME_PRIORITY);
    object oPriorityBag = GetLocalObject(NPC_SELF, AI_MEME_PRIORITY_BAG + IntToString(nPriority));

    if (bCallEndScript)
    {
        ai_PrintString("Running destructor script for meme, " + _GetName(oMeme) + ".");
        ai_ExecuteScript(_GetName(oMeme), AI_METHOD_END, OBJECT_SELF, oMeme);
    }

    // Object is not actually destroyed until after this script runs.
    // Note this is an oddity of NWScript -- more than likely to allow for
    // visual animations and sloppy code -- whatever gets a product out the
    // door and on the shelves, right?
    _RemoveObject(oPriorityBag, oMeme);

    // If there is a parent, possibly resume the suspended parent
    object oParent = GetLocalObject(oMeme, AI_MEME_PARENT);
    if (GetIsObjectValid(oParent))
    {
        ai_PrintString("This meme is a child!");
        // Evaluate and use AI_MEME_RESULT
        ai_RemoveObjectRef(oParent, oMeme, AI_CHILD_MEME);

        // If there are no more children, this meme can be resume.
        if (ai_GetObjectCount(oParent, AI_CHILD_MEME) == 0 && bRestartParent)
        {
            ai_PrintString("That was the last child, resuming the parent " + _GetName(oParent));
            // No more children, let them run.
            ai_ResumeMeme(oParent, FALSE);
        }
        else
        {
            ai_PrintString("This meme has siblings...");

            // If AI_MEME_CHILDREN is set, then we don't care about the return
            // result. Otherwise, destroy the children when one succeeds.
            if (ai_GetMemeFlag(oMeme, AI_MEME_CHILDREN) == 0)
            {
                // Ok, in this case, 0 is pass, 1 is fail.
                // This logic is reversed because we want memes to succeed by
                // default. So 0 is the default value of a NWScript variable.
                // You must explicitly call ai_SetMemeResult(FALSE) to fail and
                // let a meme's siblings execute.
                if ((GetLocalInt(oParent, AI_MEME_RESULT) == 0) && bDestroySiblings)
                {
                    // Note: This code is also done in ai_DestroyChildMemes();
                    ai_DestroyChildMemes(oParent);
                    ai_ResumeMeme(oParent, FALSE);
                }
                else ai_PrintString("This meme didn't succeed. One of the other siblings will get its chance.");
            }
            else ai_PrintString("I'm supposed to play nice and let my siblings go.");
        }
    }

    // If there is a generator, possibly detach from the generator's list
    object oGenerator = GetLocalObject(oMeme, AI_MEME_GENERATOR);
    if (GetIsObjectValid(oGenerator))
        ai_RemoveObjectRef(oGenerator, oMeme, AI_CHILD_MEME);

    SetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME, OBJECT_INVALID);
    SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, OBJECT_INVALID);

    if (bComputeBestMeme)
        ai_ComputeBestMeme();

    ai_DebugEnd();
}

void ai_DestroyMeme(object oMeme)
{
    _DestroyMeme(oMeme);
}

object ai_GetActiveMeme()
{
    return GetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME);
}

object ai_GetPendingMeme()
{
    return GetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME);
}

object ai_GetMeme(string sName = "", int nIndex = 0, int nPriority = AI_PRIORITY_DEFAULT)
{
    ai_DebugStart("ai_GetMeme name = '"+sName+"' Nth = '"+IntToString(nIndex)+"'", AI_DEBUG_UTILITY);

    object oBag, oMeme;
    int i, j, nNth, nCount;

    for (i = AI_PRIORITY_VERYHIGH; i >= AI_PRIORITY_NONE; i--)
    {
        if (nPriority == 0 || nPriority == i)
        {
            oBag = GetLocalObject(NPC_SELF, AI_MEME_PRIORITY_BAG + IntToString(i));

            nCount = ai_GetObjectCount(oBag);
            oMeme = ai_GetObjectByIndex(oBag, 0);
            for (j = 0; j < nCount; j++)
            {
                ai_PrintString("Looking at '"+_GetName(oMeme)+"' meme, number "+IntToString(j)+" in Priority Bag"+IntToString(i)+".");
                if (sName == "" || _GetName(oMeme) == sName)
                {
                    if (nNth == nIndex)
                    {
                        ai_DebugEnd();
                        return oMeme;
                    }
                    nNth++;
                }
                oMeme = ai_GetObjectByIndex(oBag, j);
            }
        }
    }

    ai_DebugEnd();
    return OBJECT_INVALID;
}

void _MemeDone(object oActiveMeme, int nRunInstance)
{
    if (!GetIsObjectValid(oActiveMeme))
        return;

    string sName = _GetName(oActiveMeme);
    ai_DebugStart("_MemeDone meme = '"+sName+"' run='"+IntToString(nRunInstance)+"'", AI_DEBUG_TOOLKIT);

    if ((oActiveMeme != GetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME)) || (nRunInstance != GetLocalInt(oActiveMeme, AI_MEME_RUN_COUNT)))
    {
        ai_PrintString("We have been overrun!");
        ai_DebugEnd();
        return;
    }

    // Since we are not a main script, reload register for safety
    NPC_SELF = GetLocalObject(OBJECT_SELF, AI_NPC_SELF);

    // The meme can't be done if it is paused.
    if (GetLocalInt(NPC_SELF, AI_MEME_PAUSED))
    {
        ai_PrintString("NPC is paused");
        ai_DebugEnd();
        return;
    }

    ai_PrintString("Notifying meme it has completed.");
    ai_ExecuteScript(sName, AI_METHOD_END, OBJECT_SELF, oActiveMeme);

/*
    if (ai_GetMemeFlag(oActiveMeme, AI_MEME_REPEAT))
    {
        if (GetIsObjectValid(GetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME)))
            ai_UpdateActions();
        else
        {
            ai_ExecuteScript(sName, AI_METHOD_GO, OBJECT_SELF, oActiveMeme);
            nRunInstance ++;
            SetLocalInt(oActiveMeme, AI_MEME_RUN_COUNT, nRunInstance);
            ai_PrintString("Meme = "+sName+" next run ="+IntToString(nRunInstance));
            ActionDoCommand(ActionDoCommand(DelayCommand(0.0, _MemeDone(oActiveMeme, nRunInstance))));
        }
        ai_DebugEnd();
        return;
    }
*/

    // Fix for suspended meme
    if (ai_GetMemeFlag(oActiveMeme, AI_MEME_REPEAT))
    {
        if (ai_IsMemeSuspended(oActiveMeme) ||                  // Maybe meme got suspended in _end
            ai_GetPriority(oActiveMeme) == AI_PRIORITY_NONE ||  // Maybe meme lost its priority in _end
            GetIsObjectValid(GetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME)))
        {
            ai_UpdateActions();
        }
        else
        {
            ai_ExecuteScript(sName, AI_METHOD_GO, OBJECT_SELF, oActiveMeme);
            nRunInstance++;
            SetLocalInt(oActiveMeme, AI_MEME_RUN_COUNT, nRunInstance);
            ai_PrintString("Meme = "+sName+" next run ="+IntToString(nRunInstance), AI_DEBUG_TOOLKIT);
            ActionDoCommand(ActionDoCommand(_MemeDone(oActiveMeme, nRunInstance)));
        }
        ai_DebugEnd();
        return;
    }

    ai_PrintString("Meme completed, destroying.");
    _DestroyMeme(oActiveMeme, 0); // Internal version doesn't call _end script.

    ai_UpdateActions();

    ai_DebugEnd();
    return;
}

void _RestartMeme(object oMeme, int bCallInit, int nTimeStamp)
{
    if (nTimeStamp)
        if (GetLocalInt(oMeme, AI_MEME_TIMESTAMP) != nTimeStamp)
            return;

    int nTimeStamp = GetLocalInt(oMeme, AI_MEME_TIMESTAMP) + 1;
    SetLocalInt(oMeme, AI_MEME_TIMESTAMP, nTimeStamp);

    if (GetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME) == oMeme)
    {
        ClearAllActions();
        ai_ExecuteScript(_GetName(oMeme), AI_METHOD_BREAK, OBJECT_SELF, oMeme);

        if (bCallInit)
            ai_ExecuteScript(_GetName(oMeme), AI_METHOD_INIT, OBJECT_SELF, oMeme);
        ai_ExecuteScript(_GetName(oMeme), AI_METHOD_GO, OBJECT_SELF, oMeme);
    }
}

void ai_RestartMeme(object oMeme, int bCallInit = FALSE, float fDelay = 0.0)
{
    ai_DebugStart("ai_RestartMeme name='" + _GetName(oMeme) + "'", AI_DEBUG_UTILITY);

    if (fDelay > 0.0)
    {
        int nTimeStamp = GetLocalInt(oMeme, AI_MEME_TIMESTAMP) + 1;
        SetLocalInt(oMeme, AI_MEME_TIMESTAMP, nTimeStamp);
        DelayCommand(fDelay, _RestartMeme(oMeme, bCallInit, nTimeStamp));
    }
    else
        _RestartMeme(oMeme, bCallInit, 0);

    ai_DebugEnd();
}


void _StopMeme(object oMeme, int nTimeStamp)
{
    if (nTimeStamp)
        if (GetLocalInt(oMeme, AI_MEME_TIMESTAMP) != nTimeStamp)
            return;

    int nTimeStamp = GetLocalInt(oMeme, AI_MEME_TIMESTAMP) + 1;
    SetLocalInt(oMeme, AI_MEME_TIMESTAMP, nTimeStamp);

    ai_DestroyChildMemes(oMeme, FALSE);

    if (GetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME) == oMeme)
    {
        ClearAllActions();
        ai_ExecuteScript(_GetName(oMeme), AI_METHOD_BREAK, OBJECT_SELF, oMeme);
        int nRunCount = GetLocalInt(oMeme, AI_MEME_RUN_COUNT) + 1;
        SetLocalInt(oMeme, AI_MEME_RUN_COUNT, nRunCount);
        _MemeDone(oMeme, nRunCount);
    }
}

void ai_StopMeme(object oMeme, float fDelay = 0.0)
{
    ai_DebugStart("ai_StopMeme name='"+_GetName(oMeme)+"'", AI_DEBUG_UTILITY);

    if (fDelay > 0.0)
    {
        int nTimeStamp = GetLocalInt(oMeme, AI_MEME_TIMESTAMP) + 1;
        SetLocalInt(oMeme, AI_MEME_TIMESTAMP, nTimeStamp);
        DelayCommand(fDelay, _StopMeme(oMeme, nTimeStamp));
    }
    else
        _StopMeme(oMeme, 0);

    ai_DebugEnd();
}

object ai_GetParentGenerator(object oMeme)
{
    ai_DebugStart("ai_GetParentGenerator", AI_DEBUG_UTILITY);
    ai_DebugEnd();

    return GetLocalObject(oMeme, AI_MEME_GENERATOR);
}

object ai_GetParentMeme(object oMeme)
{
    ai_DebugStart("ai_GetParentMeme", AI_DEBUG_UTILITY);
    ai_DebugEnd();

    return GetLocalObject(oMeme, AI_MEME_PARENT);
}

int ai_GetMemeResult(object oMeme = OBJECT_INVALID)
{
    if (oMeme == OBJECT_INVALID)
        oMeme = GetLocalObject(OBJECT_SELF, AI_MEME_SELF);
    // NOTICE -- I set 0 as TRUE, 1 as FALSE
    // Why? This allows me to have a default value of 0 as a success.
    return (!GetLocalInt(oMeme, AI_MEME_RESULT));
}

void ai_SetMemeResult(int bResult, object oMeme = OBJECT_INVALID)
{
    if (oMeme == OBJECT_INVALID)
        oMeme = GetLocalObject (OBJECT_SELF, AI_MEME_SELF);
    object oParent = ai_GetParentMeme(oMeme);
    // NOTICE -- I set 0 as TRUE, 1 as FALSE
    // Why? This allows me to have a default value of 0 as a success.
    SetLocalInt(oParent, AI_MEME_RESULT, !bResult);
}

void ai_SetPriority(object oTarget, int nPriority, int nModifier = 0, int bPropogate = FALSE)
{
    ai_DebugStart("ai_SetPriority name = '" + _GetName(oTarget) + "' priority = '"+IntToString(nPriority)+"' modifier = '"+IntToString(nModifier)+"'", AI_DEBUG_TOOLKIT);

    object oMeme;
    int i, nCount;

    // Changing the priority of a suspended meme is easy.
    if (GetLocalInt(oTarget, AI_MEME_SUSPENDED))
    {
        SetLocalInt(oTarget, AI_MEME_PRIORITY, nPriority);
        SetLocalInt(oTarget, AI_MEME_MODIFIER, nModifier);
    }
    else
    {
        int nOldPriority = GetLocalInt(oTarget, AI_MEME_PRIORITY);
        if (nOldPriority != nPriority)
        {
            object oBag = GetLocalObject(NPC_SELF, AI_MEME_PRIORITY_BAG + IntToString(nOldPriority));
            object oNewBag = GetLocalObject(NPC_SELF, AI_MEME_PRIORITY_BAG + IntToString(nPriority));
            SetLocalInt(oTarget, AI_MEME_PRIORITY, nPriority);
            if (!GetIsObjectValid(NPC_SELF)) ai_PrintString("ASSERT: NPC_SELF is invalid!");
            if (!GetIsObjectValid(oBag))     ai_PrintString("ASSERT: Bag (" + IntToString(nOldPriority)+") is invalid!");
            if (!GetIsObjectValid(oNewBag))  ai_PrintString("ASSERT: New bag (" + IntToString(nPriority)+") is invalid!");
            if (!GetIsObjectValid(oTarget))  ai_PrintString("ASSERT: meme is invalid!");

            _MoveObject(oBag, oTarget, oNewBag);
//            if (oActive  == oTarget)
//                SetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME, OBJECT_INVALID);
//            if (oPending == oTarget)
//                SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, OBJECT_INVALID);
        }
        SetLocalInt(oTarget, AI_MEME_MODIFIER, nModifier);
    }

    if (bPropogate)
    {
        object oActive  = GetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME);
        object oPending = GetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME);

        nCount = ai_GetObjectCount(oTarget, AI_CHILD_MEME);
        for (i = 0; i < nCount; i++)
        {
            oMeme = ai_GetObjectByIndex(oTarget, i, AI_CHILD_MEME);
            ai_PrintString("Propogating priority change to meme "+IntToString(i)+" ("+_GetName(oMeme)+").");
            ai_SetPriority(oMeme, nPriority, nModifier, bPropogate);
        }
    }

    ai_ComputeBestMeme(oMeme);
    ai_DebugEnd();
}

// ----- Sequences -------------------------------------------------------------

object ai_CreateSequence(string sName, int nPriority = AI_PRIORITY_DEFAULT, int nModifier = 0, int nFlags = 0x005 /*AI_SEQUENCE_REPEAT | AI_SEQUENCE_RESUME_LAST*/, object oGenerator = OBJECT_INVALID)
{
    ai_DebugStart("ai_CreateSequence name='"+sName+"' priority='"+IntToString(nPriority)+"' modifier = '"+IntToString(nModifier)+"'", AI_DEBUG_TOOLKIT);

    if (!GetIsObjectValid(NPC_SELF))
        ai_InitializeNPC();

    object oSequence = GetLocalObject(NPC_SELF, AI_MEME_SEQUENCE + sName);
    if (GetIsObjectValid(oSequence))
    {
        ai_PrintString("Sequence already exists!");
        ai_DebugEnd();
        return OBJECT_INVALID;
    }

    oSequence = _MakeObject(NPC_SELF, sName, AI_TYPE_SEQUENCE);
    SetLocalObject(NPC_SELF, AI_MEME_SEQUENCE + "_" + sName, oSequence);

    // Get the active class
    string sActiveClass;
    if (oGenerator == OBJECT_INVALID)
        sActiveClass = GetLocalString(MEME_SELF, AI_ACTIVE_CLASS);
    else
        sActiveClass = GetLocalString(oGenerator, AI_ACTIVE_CLASS);

    // Inherit the class of the context that's creating this generator.
    SetLocalString(oSequence, AI_ACTIVE_CLASS, sActiveClass);

    // Adopt the priority of the generator if it is passed.
    if (GetIsObjectValid(oGenerator))
    {
        ai_AddObjectRef(oGenerator, oSequence, AI_CHILD_SEQUENCE);
        SetLocalInt(oSequence, AI_MEME_PRIORITY, GetLocalInt(oGenerator, AI_MEME_PRIORITY));
        SetLocalInt(oSequence, AI_MEME_MODIFIER, GetLocalInt(oGenerator, AI_MEME_MODIFIER));
        SetLocalObject(oSequence, AI_MEME_GENERATOR, oGenerator);
    }
    else
    {
        SetLocalInt(oSequence, AI_MEME_PRIORITY, nPriority);
        SetLocalInt(oSequence, AI_MEME_MODIFIER, nModifier);
    }

    // If the AI_MEME_REPEAT flag was set, replace it with AI_SEQUENCE_REPEAT
    if (GetIsFlagSet(nFlags, AI_MEME_REPEAT))
        SetFlag(nFlags, AI_SEQUENCE_REPEAT);

    SetFlag(nFlags, AI_MEME_REPEAT);

    if (GetIsFlagSet(nFlags, AI_SEQUENCE_RESUME_FIRST | AI_SEQUENCE_RESUME_LAST))
        SetFlag(nFlags, AI_MEME_RESUME);

    SetLocalInt(oSequence, AI_MEME_FLAGS, nFlags);

    ai_DebugEnd();
    return oSequence;
}

object ai_CreateSequenceMeme(object oSequence,  string sName, int nPriority = AI_PRIORITY_LOW, int nModifier = 0, int nFlags = 0x10)
{
    ai_DebugStart("ai_CreateSequenceMeme name = '"+sName+"' priority = '"+IntToString(nPriority)+"' modifier = '"+IntToString(nModifier)+"'", AI_DEBUG_TOOLKIT);

    object oMeme;

    if (!GetIsObjectValid(oSequence))
    {
        ai_PrintString("No valid sequence given!");
        ai_DebugEnd();
        return OBJECT_INVALID;
    }

    if (!GetIsObjectValid(NPC_SELF))
        ai_InitializeNPC();

    // If the priority is default, try to inherit the parent's priority
    if (nPriority == AI_PRIORITY_DEFAULT)
    {
        nPriority = GetLocalInt(oSequence, AI_MEME_PRIORITY);
        if (nPriority)
            nModifier = GetLocalInt(oSequence, AI_MEME_MODIFIER);
        else
        {
            nPriority = AI_PRIORITY_MEDIUM;
            nModifier = 0;
        }
    }

    // Adjust the modifier to match the class bais
    string sActiveClass = GetLocalString(oSequence, AI_ACTIVE_CLASS);
    if (sActiveClass == "")
        sActiveClass = GetLocalString(MEME_SELF, AI_ACTIVE_CLASS);
    if (!(GetIsFlagSet(nFlags, AI_MEME_NO_BIAS)))
        nModifier += GetLocalInt(NPC_SELF, "AI_MEME_"+sActiveClass+"_BIAS");

    // Normalize modifier
    if (nModifier < -100) nModifier = -100;
    else if (nModifier > 100) nModifier = 100;

    oMeme = _MakeObject(oSequence, sName, AI_TYPE_MEME);

    // Store the ActiveClass
    SetLocalString(oMeme, AI_ACTIVE_CLASS, sActiveClass);

    SetLocalInt(oMeme, AI_MEME_PRIORITY, nPriority);
    SetLocalInt(oMeme, AI_MEME_MODIFIER, nModifier);
    SetLocalInt(oMeme, AI_MEME_FLAGS, nFlags);
    SetLocalObject(oMeme, AI_MEME_SEQUENCE, oSequence);

    ai_DebugEnd();
    return oMeme;
}

object ai_StartSequence(object oSequence)
{
    ai_DebugStart("ai_StartSequence", AI_DEBUG_TOOLKIT);

    object oSeqRef = GetLocalObject(oSequence, AI_MEME_SEQUENCE_REF);
    if (GetIsObjectValid(oSeqRef))
    {
        ai_PrintString("Sequence already running!");
        ai_DebugEnd();
        return oSeqRef;
    }

    oSeqRef = ai_CreateMeme("ai_m_sequence",
                            GetLocalInt(oSequence, AI_MEME_PRIORITY),
                            GetLocalInt(oSequence, AI_MEME_MODIFIER),
                            GetLocalInt(oSequence, AI_MEME_FLAGS),
                            GetLocalObject(oSequence, AI_MEME_GENERATOR));

    SetLocalObject(oSeqRef, AI_MEME_SEQUENCE_NAME, GetLocalObject(oSequence, AI_NAME));
    SetLocalObject(oSeqRef, AI_MEME_SEQUENCE, oSequence);
    SetLocalObject(oSequence, AI_MEME_SEQUENCE_REF, oSeqRef);

    ai_DebugEnd();
    return oSeqRef;
}

void ai_StopSequence(object oTarget)
{
    ai_DebugStart("ai_StopSequence", AI_DEBUG_UTILITY);

    object oObject;
    int nType = GetLocalInt(oTarget, AI_MEME_TYPE);

    if (nType == AI_TYPE_SEQUENCE)
    {
        oObject = GetLocalObject(oTarget, AI_MEME_SEQUENCE_REF);
        if (GetIsObjectValid(oObject))
        {
            DeleteLocalObject(oTarget, AI_MEME_SEQUENCE_REF);
            ai_DestroyMeme(oObject);
        }
    }
    else if (nType == AI_TYPE_SEQUENCE_REF)
    {
        oObject = GetLocalObject(oTarget, AI_MEME_SEQUENCE);
        DeleteLocalObject(oObject, AI_MEME_SEQUENCE_REF);
        ai_DestroyMeme(oTarget);
    }

    ai_DebugEnd();
}

void ai_DestroySequence(object oTarget)
{
    ai_DebugStart("ai_DestroySequence", AI_DEBUG_UTILITY);

    object oSequence, oSequenceRef, oObject;
    int i, nType = GetLocalInt(oTarget, AI_MEME_TYPE);
    if (nType == AI_TYPE_SEQUENCE)
    {
        oSequence = oTarget;
        oSequenceRef = GetLocalObject(oTarget, AI_MEME_SEQUENCE_REF);
    }
    else if (nType == AI_TYPE_SEQUENCE_REF)
    {
        oSequenceRef = oTarget;
        oSequence = GetLocalObject(oTarget, AI_MEME_SEQUENCE);
    }
    else
    {
        ai_DebugEnd();
        return;
    }

    ai_DestroyMeme(oSequenceRef);

    object oGenerator = GetLocalObject(oSequence, AI_MEME_GENERATOR);
    if (GetIsObjectValid(oGenerator))
        ai_RemoveObjectRef(oGenerator, oSequence, AI_CHILD_SEQUENCE);

    for (i = ai_GetObjectCount(oSequence) - 1; i >= 0; i--)
    {
        oObject = ai_GetObjectByIndex(oSequence, i);
        DestroyObject(oObject);
    }

    DestroyObject(oSequence);
    ai_DebugEnd();
}

object ai_GetSequence(string sName = "")
{
    ai_DebugStart("ai_GetSequence", AI_DEBUG_UTILITY);
    ai_DebugEnd();

    return GetLocalObject(NPC_SELF, AI_MEME_SEQUENCE + "_" + sName);
}


// ----- Core Toolkit ----------------------------------------------------------
void ai_ExecuteGenerators(string sSuffix)
{
    if (!GetIsObjectValid(NPC_SELF))
    {
        PrintString("<Assert>This NPC has attempted to prematurely execute generators.</Assert>");
        return;
    }

    ai_DebugStart("ai_ExecuteGenerators suffix = '"+sSuffix+"'", AI_DEBUG_TOOLKIT);

    if (GetLocalInt(NPC_SELF, AI_MEME_PAUSED))
    {
        ai_PrintString("Will not execute generators, the system is paused.");
        ai_DebugEnd();
        return;
    }

    object oGenerator, oBag = GetLocalObject(NPC_SELF, AI_GENERATOR_BAG);
    int i, nCount;

    nCount = ai_GetObjectCount(oBag);
    for (i = 0; i < nCount; i++)
    {
        oGenerator = ai_GetObjectByIndex(oBag, i);
        if (GetLocalInt(oGenerator, AI_MEME_ACTIVE))
        {
            ai_PrintString("Starting generator "+_GetName(oGenerator)+".");
            ai_ExecuteScript(_GetName(oGenerator), sSuffix, OBJECT_SELF, oGenerator);
        }

        if (GetIsFlagSet(GetLocalInt(oGenerator, AI_MEME_FLAGS), AI_GENERATOR_SINGLEUSE))
            ai_DestroyGenerator(oGenerator, 0);
    }
    ai_DebugEnd();
}


void ai_ComputeBestMeme(object oMeme)
{
    ai_DebugStart("ai_ComputeBestMeme name = '"+_GetName(oMeme)+"'", AI_DEBUG_TOOLKIT);

    object oBag;
    object oPending = GetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME);
    object oActive  = GetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME);
    int nPriority, mPriority, pPriority, nModifier, pModifier, i, j;
    string sName; // Only used for debugging.

    // -1. Dead simplest case first.
    // Side Effect: If !GetIsObjectValid(oMeme), then GetLocalInt(oMeme, AI_MEME_PRIORITY) == 0 != AI_PRIORITY_NONE
    if (GetLocalInt(oMeme, AI_MEME_PRIORITY) == AI_PRIORITY_NONE)
    {
        if ((oMeme != oActive) && (oMeme != oPending))
        {
            // Not Active nor Pending, just ignore it
            ai_PrintString("No priority meme is ignored.");
            ai_DebugEnd();
            return;
        }

        // Is Active or Pending, completely recompute pending meme
    }
    else
    {
        // 0. Simplest case first.
        if (!GetIsObjectValid(oPending) && !GetIsObjectValid(oActive) && GetIsObjectValid(oMeme))
        {
            ai_PrintString("Pending meme is now " + _GetName(oMeme)+".");
            SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, oMeme);

            ai_DebugEnd();
            return;
        }

        // 0.1
        if (GetIsObjectValid(oMeme))
        {
            if (!GetIsObjectValid(oPending))
            {
                // 1. Check for case where a recently modified meme beats active meme
                if (oMeme != oActive)
                {
                    ai_PrintString("Checking to see if meme is better than active meme (" + _GetName(oActive) + ").");

                    nPriority = GetLocalInt(oActive, AI_MEME_PRIORITY);
                    mPriority = GetLocalInt(oMeme, AI_MEME_PRIORITY);
                    if (nPriority < mPriority)
                    {
                        ai_PrintString("1. Pending meme is now "+_GetName(oMeme)+".");
                        SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, oMeme);
                    }
                    else if (nPriority == mPriority)
                    {
                        if (GetLocalInt(oActive, AI_MEME_MODIFIER) < GetLocalInt(oMeme, AI_MEME_MODIFIER))
                        {
                            ai_PrintString("2. Pending meme is now " + _GetName(oMeme) + ".");
                            SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, oMeme);
                        }
                    }

                    ai_DebugEnd();
                    return;
                }
            }
            else
            {
                // 2. Check optimized case where a recently modified meme beats highest pending meme.
                if (oMeme != oPending)
                {
                    ai_PrintString("Checking to see if meme is better than pending meme (" + _GetName(oPending) + ").");

                    nPriority = GetLocalInt(oPending, AI_MEME_PRIORITY);
                    mPriority = GetLocalInt(oMeme, AI_MEME_PRIORITY);
                    if (nPriority < mPriority)
                    {
                        ai_PrintString("3. Pending meme is now " + _GetName(oMeme) + ".");
                        SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, oMeme);
                    }
                    else
                    {
                        nModifier = GetLocalInt(oPending, AI_MEME_MODIFIER);
                        if ((nPriority == mPriority) && (nModifier < GetLocalInt(oMeme, AI_MEME_MODIFIER)))
                        {
                            ai_PrintString("4. Pending meme is now " + _GetName(oMeme) + ".");
                            SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, oMeme);
                        }
                    }

                    ai_DebugEnd();
                    return;
                }
            }
        }
    }

    // 3. Find the highest priority meme. (ignoring bag AI_PRIORITY_NONE.)
    oPending = OBJECT_INVALID;
    for (i = AI_PRIORITY_VERYHIGH; i > AI_PRIORITY_NONE; i--)
    {
       j = 0;
       ai_PrintString("Looking in band " + IntToString(i) + " for next best meme.");
       oBag = GetLocalObject(NPC_SELF, AI_MEME_PRIORITY_BAG + IntToString(i));

       while(TRUE)
       {
            oMeme = ai_GetObjectByIndex(oBag, j);
            if (!GetIsObjectValid(oMeme))
                break;

            // Debug
            sName = _GetName(oMeme);
            if (sName == "ai_m_sequence")
                sName = GetLocalString(oMeme, AI_SEQUENCE_NAME);
            ai_PrintString("Evaluating meme '" + sName + "'.");
            // End Debug

            nPriority = GetLocalInt(oMeme, AI_MEME_PRIORITY);
            nModifier = GetLocalInt(oMeme, AI_MEME_MODIFIER);
            if (!GetIsObjectValid(oPending)
                || (nPriority > pPriority)
                || (nPriority == pPriority && nModifier > pModifier))
            {
                pPriority = nPriority;
                pModifier = nModifier;
                oPending = oMeme;
            }
            j++;
        }
        if (GetIsObjectValid(oPending)) break;
    }

    if (GetIsObjectValid(oPending))
        ai_PrintString("5. Pending meme is now " + _GetName(oPending)+".");

    if (oPending != oActive)
        SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, oPending);
    else
        SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, OBJECT_INVALID);


    ai_DebugEnd();
}

void _Tickle(object oActiveMeme)
{
    ai_DebugStart("JumpStartingNPC", AI_DEBUG_TOOLKIT);
    int nRunCount = GetLocalInt(oActiveMeme, AI_MEME_RUN_COUNT) + 1;
    SetLocalInt(oActiveMeme, AI_MEME_RUN_COUNT, nRunCount);
    ai_PrintString("Meme = "+_GetName(oActiveMeme) + " next run =" + IntToString(nRunCount));
    ActionDoCommand(ActionDoCommand(DelayCommand(0.0, _MemeDone(oActiveMeme, nRunCount))));
    DeleteLocalInt(OBJECT_SELF, AI_SCHEDULED_FOR_TICKLE);
    ai_DebugEnd();
}

// Private Prototype
void _UpdateActions();

void ai_UpdateActions()
{
    if (GetLocalInt(NPC_SELF, AI_MEME_PAUSED) || GetLocalInt(NPC_SELF, AI_UPDATE_SCHEDULED))
        return;

    SetLocalInt(NPC_SELF, AI_UPDATE_SCHEDULED, 1);

    // Toy with these see the performance difference. You might see a stuttered
    // NPC but have a less laggy system with the first one.
    DelayCommand(0.1, _UpdateActions());
    //DelayCommand(0.0, _UpdateActions());

}

void _UpdateActions()
{
    ai_DebugStart("ai_UpdateActions", AI_DEBUG_TOOLKIT);

    DeleteLocalInt(NPC_SELF, AI_UPDATE_SCHEDULED);

    if (!GetIsObjectValid(NPC_SELF))
    {
        ai_PrintString("Error: attempting to update actions on a non-memetic NPC.");
        ai_DebugEnd();
        return;
    }

    // I'm paused or the DM is using me.
    if (GetLocalInt(NPC_SELF, AI_MEME_PAUSED))
    {
        ai_PrintString("Will not update actions, the system is paused.");
        ai_DebugEnd();
        return;
    }

    object oActiveMeme  = GetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME);
    object oPendingMeme = GetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME);

    if (!GetIsObjectValid(oActiveMeme) && !GetIsObjectValid(oPendingMeme))
        ClearAllActions();

    if (!GetIsObjectValid(oPendingMeme))
    {
        if (GetLocalInt(oActiveMeme, AI_MEME_PRIORITY) != AI_PRIORITY_NONE)
        {
            ai_PrintString("No pending memes, the currently active behavior is fine. ("+_GetName(oActiveMeme)+")");
/*
            // Experimental tickle code causes the NPC to be kickstarted if
            // someone has cleared our action queue -- like the game engine
            if (GetCurrentAction() == ACTION_INVALID && oActiveMeme != OBJECT_INVALID)
            {
                if (!GetLocalInt(OBJECT_SELF, AI_SCHEDULED_FOR_TICKLE))
                {
                    SetLocalInt(OBJECT_SELF, AI_SCHEDULED_FOR_TICKLE, 1);
                    ai_PrintString("NPC is stalled, restarting. Something cleared by Action Queue.");
                    DelayCommand(0.0, _Tickle(oActiveMeme));
                }
                ai_DebugEnd();
                return;
            }
*/
            ai_DebugEnd();
            return;
        }
    }

    ClearAllActions();

    if (GetIsObjectValid(oActiveMeme))
    {
        ai_PrintString("Stopping active meme, "+_GetName(oActiveMeme)+".");

        // AI_MEME_INSTANT means that this meme shouldn't cause the interruption
        // of the current meme but it will get a chance to run (seamlessly) and
        // if a AI_MEME_IMMEDIATE meme is created, it can be scheduled even
        // though a AI_MEME_INSTANT meme is active. AI_MEME_INSTANT is a short
        // duration interruption meme.

        if (!ai_GetMemeFlag(oPendingMeme, AI_MEME_IMMEDIATE))
        {
            ai_ExecuteScript(_GetName(oActiveMeme), AI_METHOD_BREAK, OBJECT_SELF, oActiveMeme);
            if (!ai_GetMemeFlag(oActiveMeme, AI_MEME_RESUME))
            {
                ai_PrintString("Destroying active meme, "+_GetName(oActiveMeme)+".");
                ai_DestroyMeme(oActiveMeme);
            }
            else
                ai_PrintString("The active meme, " + _GetName(oActiveMeme)+" is resumeable, it isn't being destroyed.");
        }
    }

    SetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME, oPendingMeme);
    SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, OBJECT_INVALID);

    ai_PrintString("Starting new active meme, " + _GetName(oPendingMeme)+".");
    ai_ExecuteScript(_GetName(oPendingMeme), AI_METHOD_GO, OBJECT_SELF, oPendingMeme);

    int nRunCount = GetLocalInt(oPendingMeme, AI_MEME_RUN_COUNT) + 1;
    SetLocalInt(oPendingMeme, AI_MEME_RUN_COUNT, nRunCount);
    ai_PrintString("Meme = "+_GetName(oPendingMeme)+" next run ="+IntToString(nRunCount));
    ActionDoCommand(ActionDoCommand(DelayCommand(0.0, _MemeDone(oPendingMeme, nRunCount))));

    ai_DebugEnd();
}

void ai_RestartSystem()
{
    ai_DebugStart("ai_RestartSystem", AI_DEBUG_TOOLKIT);
    object oPendingMeme = GetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME);
    object oActiveMeme  = GetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME);

    ClearAllActions();
    if (oPendingMeme == OBJECT_INVALID)
    {
        SetLocalObject(NPC_SELF, AI_MEME_PENDING_MEME, oActiveMeme);
        SetLocalObject(NPC_SELF, AI_MEME_ACTIVE_MEME, OBJECT_INVALID);
    }

    ai_UpdateActions();
    ai_DebugEnd();
}

void ai_PauseSystem()
{
    ai_DebugStart("ai_PauseSystem", AI_DEBUG_TOOLKIT);

    SetLocalInt(NPC_SELF, AI_MEME_PAUSED, TRUE);
    ClearAllActions();

    ai_DebugEnd();
}

void ai_ResumeSystem()
{
    ai_DebugStart("ai_ResumeSystem", AI_DEBUG_TOOLKIT);

    DeleteLocalInt(NPC_SELF, AI_MEME_PAUSED);
    ai_RestartSystem();

    ai_DebugEnd();
}

int ai_HasScheduledMeme(int nPriority, int nModifier, object oExcludeMeme = OBJECT_INVALID)
{
    ai_DebugStart("ai_HasScheduledMeme", AI_DEBUG_TOOLKIT);

    object oBag, oMeme;
    int i, nCount;

    for (i = nPriority + 1; i <= AI_PRIORITY_VERYHIGH; i++)
    {
        oBag  = GetLocalObject(NPC_SELF, AI_PRIORITY_BAG + "_" +IntToString(i));
        switch (ai_GetObjectCount(oBag))
        {
            case 0:
                break;
            case 1:
                oBag = GetLocalObject(NPC_SELF, AI_MEME_PRIORITY_BAG + IntToString(nPriority));
                if (ai_GetObjectByIndex(oBag, 0) == oExcludeMeme)
                break;
            default:
                ai_DebugEnd();
                return 1;
        }
    }

    oBag  = GetLocalObject(NPC_SELF, AI_PRIORITY_BAG + "_" + IntToString(nPriority));
    nCount = ai_GetObjectCount(oBag);

    for (i = 0; i < nCount; i++)
    {
        oMeme = ai_GetObjectByIndex(oBag, i);
        if (GetIsObjectValid(oMeme) && oMeme != oExcludeMeme)
        {
            if (GetLocalInt(oMeme, AI_MEME_MODIFIER) >= nModifier)
            {
                ai_PrintString("Meme is: " + _GetName(ai_GetObjectByIndex(oBag, 0)));
                ai_DebugEnd();
                return FALSE;
            }
        }
    }

    ai_DebugEnd();
    return FALSE;
}

/*------------------------------------------------------------------------------
 *    Meme:  ai_m_sequence
 *  Author:  William Bull
 *    Date:  July, 2002
 *   Notes:  This is an internal meme that should never be used directly.
 *           Please refer to the sequence API in the online documentation.
 *------------------------------------------------------------------------------*/
void ai_m_sequence_ini()
{
    ai_DebugStart("Sequence event = 'Init'", AI_DEBUG_TOOLKIT);

    SetLocalInt(MEME_SELF, AI_MEME_CURRENT_INDEX, 0);
    // If this is set here, the sequence will always re-init the memes in
    // the sequence. This may not be the best thing if the sequence is a
    // singleton. MEME_SELF is the sequence_ref, not the sequence. The ref
    // may go away after the sequence runs its course -- since the memes are
    // not re-inited on ai_m_sequence_end, the sequence may have stale data
    // in the memes.
    SetLocalInt(MEME_SELF, AI_MEME_INIT_SEQUENCE, 1);

    ai_DebugEnd();
}

void ai_m_sequence_go()
{
    ai_DebugStart("Sequence event = 'Go'", AI_DEBUG_TOOLKIT);

    object oSequence = GetLocalObject(MEME_SELF, AI_MEME_SEQUENCE);
    int    nIndex    = GetLocalInt(MEME_SELF, AI_MEME_CURRENT_INDEX);
    object oMeme     = ai_GetObjectByIndex(oSequence, nIndex);
    int    nFlags    = GetLocalInt(MEME_SELF, AI_MEME_FLAGS);
    int    nCount, i;
    object oTemp;

    if ((nIndex == 0) && (GetLocalInt(MEME_SELF, AI_MEME_INIT_SEQUENCE) > 0))
    {
        // This is the first time this has run...
        nCount = ai_GetObjectCount(oSequence);
        for (i = 0; i < nCount; i++)
        {
            oTemp = ai_GetObjectByIndex(oSequence, i);
            // Here is where I should check to see if the meme has a special
            // flag for seq_no_init. I'm not sure if I want this flag yet, but
            // this is where it should go. Meme _ini is also called during
            // construction of the memes.
            // Note: if this is a repeating meme, AI_MEME_INIT_SEQUENCE will be
            // 2, if this is the first time it's being inited, it will be 1.
            // This might be useful if I want a flag which doesn't reset a meme
            // on sequence repeats, but does on the sequence init.
            ai_ExecuteScript(_GetName(oTemp), AI_METHOD_INIT, OBJECT_SELF, oTemp);
        }
        // Rememeber this is the first time this has run...
        SetLocalInt(MEME_SELF, AI_MEME_INIT_SEQUENCE, 0);
    }

    if (!GetIsObjectValid(oMeme))
    {
        SetLocalInt(MEME_SELF, AI_MEME_CURRENT_INDEX, 0);
        SetLocalInt(MEME_SELF, AI_MEME_RESTART_INDEX, 0);
        if (!GetIsFlagSet(nFlags, AI_SEQUENCE_REPEAT))
            ClearLocalFlag(MEME_SELF, AI_MEME_FLAGS, AI_MEME_REPEAT);

        ai_DebugEnd();
        return;
    }

    ai_ExecuteScript(_GetName(oMeme), AI_METHOD_GO, OBJECT_SELF, oMeme);

    ai_DebugEnd();
}

void ai_m_sequence_brk()
{
    ai_DebugStart("Sequence event = 'Interrupted'", AI_DEBUG_TOOLKIT);

    object oSequence = GetLocalObject(MEME_SELF, AI_MEME_SEQUENCE);
    int    nIndex    = GetLocalInt(MEME_SELF, AI_MEME_CURRENT_INDEX);
    object oMeme     = ai_GetObjectByIndex(oSequence, nIndex);
    ai_ExecuteScript(_GetName(oMeme), AI_METHOD_BREAK, OBJECT_SELF, oMeme);
    SetLocalInt(MEME_SELF, AI_MEME_CURRENT_INDEX, GetLocalInt(MEME_SELF, AI_MEME_RESTART_INDEX));

    ai_DebugEnd();
}

/* Private Meme */

// This is accessed by the ai_library script -- the library of memetic objects.
// It is hidden here to avoid being mixed up with common memes. It's really
// only interesting for people who tracking a bug, or are masochistic workaholics.

void ai_m_sequence_end()
{
    ai_DebugStart("Sequence event = 'Step Taken'", AI_DEBUG_TOOLKIT);

    object oSequence = GetLocalObject(MEME_SELF, AI_MEME_SEQUENCE);
    int    nIndex    = GetLocalInt(MEME_SELF, AI_MEME_CURRENT_INDEX);
    object oMeme     = ai_GetObjectByIndex(oSequence, nIndex);
    int    nFlags    = GetLocalInt(MEME_SELF, AI_MEME_FLAGS);
    int    mFlags    = GetLocalInt(oMeme, AI_MEME_FLAGS);
    object oNextMeme = ai_GetObjectByIndex(oSequence, nIndex + 1);

    ai_ExecuteScript(_GetName(oMeme), AI_METHOD_END, OBJECT_SELF, oMeme);

    // Deal with repeating memes in the sequence
    if (ai_GetMemeFlag(oMeme, AI_MEME_REPEAT))
    {
        // Do Nothing
    }
    // are we done? should we reset to repeat, or stop
    else if (!GetIsObjectValid(oNextMeme))
    {
        SetLocalInt(MEME_SELF, AI_MEME_CURRENT_INDEX, 0);
        SetLocalInt(MEME_SELF, AI_MEME_RESTART_INDEX, 0);
        // This could have a sequence flag which says whether or not the sequence
        // should reset the memes -- probably the flag should be added to the
        // memes and the check should be in the ai_m_sequence_go area.
        SetLocalInt(MEME_SELF, AI_MEME_INIT_SEQUENCE, 2);
        if (!GetIsFlagSet(nFlags, AI_SEQUENCE_REPEAT))
        {
            ai_PrintString("Sequence complete.");
            ClearLocalFlag(MEME_SELF, AI_MEME_FLAGS, AI_MEME_REPEAT);
        }
        // otherwise we are repeating should we take the prio of the first item?
        else if (GetLocalInt(oSequence, AI_MEME_PRIORITY) == AI_PRIORITY_DEFAULT)
        {
            oNextMeme = ai_GetObjectByIndex(oSequence, 0);
            ai_PrintString("1. First Meme in sequence has prio of " + IntToString(GetLocalInt(oNextMeme, AI_MEME_PRIORITY))+"and modifier of " + IntToString(GetLocalInt(oNextMeme, AI_MEME_MODIFIER))+".");
            ai_SetPriority(MEME_SELF, GetLocalInt(oMeme, AI_MEME_PRIORITY), GetLocalInt(oNextMeme, AI_MEME_MODIFIER));
        }
    }
    // otherwise we're advancing and care about next meme.
    else
    {
        // Is the meme a checkpoint? If so notate it -- or if AI_SEQUENCE_RESUME_LAST
        if (GetIsFlagSet(mFlags, AI_MEME_CHECKPOINT) || GetIsFlagSet(nFlags, AI_SEQUENCE_RESUME_LAST))
        {
            ai_PrintString("Setting RestartIndex to " + IntToString(nIndex + 1)+".");
            SetLocalInt(MEME_SELF, AI_MEME_RESTART_INDEX, nIndex + 1);
        }

        // Advance the current index
        SetLocalInt(MEME_SELF, AI_MEME_CURRENT_INDEX, nIndex + 1);

        // Should I adopt the priority of the next meme? If so, reprioritize.
        if (GetLocalInt(oSequence, AI_MEME_PRIORITY) == AI_PRIORITY_DEFAULT)
        {
            ai_PrintString("2. Next Meme in sequence has priority of "+IntToString(GetLocalInt(oNextMeme, AI_MEME_PRIORITY))+"and modifier of "+IntToString(GetLocalInt(oNextMeme, AI_MEME_MODIFIER))+".");
            ai_SetPriority(MEME_SELF, GetLocalInt(oNextMeme, AI_MEME_PRIORITY), GetLocalInt(oNextMeme, AI_MEME_MODIFIER));
        }
    }

    ai_DebugEnd();
}

void ai_DoNPCSetUp(int bAutoLoadClasses = TRUE, int bUpdateActions = TRUE)
{
    // Initialize the NPC
    NPC_SELF = ai_InitializeNPC();

    object oObject, oSelf = OBJECT_SELF;
    int nIndex, nPriority, nModifier, nFlags;
    string sIndex, sMeme, sGenerator, sClasses = GetLocalString(oSelf, AI_NPC_CLASS);

    // This allows us to keep the NPC from being assigned a class if the builder
    // doesn't want it to have one.
    if (bAutoLoadClasses && sClasses == "")
        sClasses = AI_DEFAULT_CLASSES;

    ai_InstanceOf(NPC_SELF, sClasses);

    // Loop through the custom generators.
    sIndex = IntToString(++nIndex);
    sGenerator = GetLocalString(oSelf, AI_NPC_GENERATOR + sIndex);
    while (sGenerator != "")
    {
        nPriority = GetLocalInt(oSelf, AI_NPC_GENERATOR + sIndex + AI_NPC_PRIORITY);
        nModifier = GetLocalInt(oSelf, AI_NPC_GENERATOR + sIndex + AI_NPC_MODIFIER);
        nFlags    = GetLocalInt(oSelf, AI_NPC_GENERATOR + sIndex + AI_NPC_FLAGS);
        oObject   = ai_CreateGenerator(sGenerator, nPriority, nModifier, nFlags);
        ai_StartGenerator(oObject);
        sIndex     = IntToString(++nIndex);
        sGenerator = GetLocalString(oSelf, AI_NPC_GENERATOR + sIndex);
    }

    // Loop through the custom memes.
    nIndex = 0;
    sIndex = IntToString(++nIndex);
    sMeme  = GetLocalString(oSelf, AI_NPC_MEME + sIndex);
    while (sMeme != "")
    {
        nPriority = GetLocalInt(oSelf, AI_NPC_MEME + sIndex + AI_NPC_PRIORITY);
        nModifier = GetLocalInt(oSelf, AI_NPC_MEME + sIndex + AI_NPC_MODIFIER);
        nFlags    = GetLocalInt(oSelf, AI_NPC_MEME + sIndex + AI_NPC_FLAGS);
        oObject   = ai_CreateMeme(sMeme, nPriority, nModifier, nFlags);
        sIndex    = IntToString(++nIndex);
        sMeme     = GetLocalString(oSelf, AI_NPC_MEME + sIndex);
    }

    if (bUpdateActions)
        ai_UpdateActions();

    // TODO: Add support for events, sequences, and passing variables to memes.
}

/*
    Variables:

    OBJECT_SELF Specific
        MEME_NPCSelf      -- The memetic store for hold all the data
        MEME_ObjectSelf   -- The currently active memetic object

    NPC_SELF Specific
        MEME_GeneratorBag
        MEME_PrioBag1...5
        MEME_EventBag
        MEME_Sequence_<SequenceName>
        MEME_ActiveMeme
        MEME_PendingMeme

    Meme Specific:
        Name
        MEME_Type
        MEME_Priority
        MEME_Modifier
        MEME_Flags
        MEME_Event
        MEME_Generator
        MEME_Sequence
        MEME_Parent
        MEME_Generator
        Meme_Count_Meme
        MEME_ChildMeme1, MEME_ChildMeme2, ...

    Generator Secific:
        Name
        MEME_Type
        MEME_Priority
        MEME_Modifier
        MEME_ChildMeme (Memes which it has created)
        MEME_Flags
        MEME_Event
        MEME_Count_Meme
        MEME_Meme1, MEME_Meme2, ...
        Meme_Count_Meme
        MEME_ChildMeme1, MEME_ChildMeme2, ...

    Sequence Specific:
        Name
        MEME_Type
        MEME_Priority
        MEME_Modifier
        MEME_Flags
        MEME_Event
        MEME_Generator
        MEME_SequenceRef

    Sequence Ref Specific:
        Name = i_sequence
        MEME_SequenceName
        MEME_Sequence
        MEME_CurrentIndex
        MEME_RestartIndex

    Event Specific
        Name
        MEME_Type
        MEME_Active
        MEME_Flags

        MEME_Count_Meme
        MEME_Meme1, MEME_Meme2, ...

        MEME_HasEventTrigger
        MEME_Count_Event
        MEME_Event1, MEME_Event2, ...
        MEME_EventDelay1, MEME_EventDelay2, ...

        MEME_HasGlobalSignalTrigger
        MEME_Count_GlobalSignal
        MEME_GlobalSignal1, MEME_GlobalSignal2, ...
        MEME_GlobalSignalDelay1, MEME_GlobalSignalDelay2, ...

        MEME_HasSignalTrigger
        MEME_IntCount_Signal
        MEME_Signal1, MEME_Signal2, ...
        MEME_SignalDelay1, MEME_SignalDelay2, ...

        MEME_HasTimeTrigger
        MEME_TimeIndex
        MEME_TimeDelay
        MEME_TimeDelayType

    Module Specific
        int    MEME_HasBroadcastListeners <-- Not used?
        int    MEME_Count_<Channel>Listener
        object MEME_<Channel>Listener1, MEME_<Channel>Listener2, ...

    Meme Script:

        _go   You are started or restarted
        _end  You are have run to completion
        _brk  You have been interrupted
*/

// void main() {}
