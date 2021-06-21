/*
Filename:           ai_generators
System:             Memetic AI (library script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 23, 2009
Summary:
Memetic AI library script. This library contains some sample generators. All of
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
#include "x0_i0_anims"

/*-----------------------------------------------------------------------------
 * Generator:  ai_g_goto
 *    Author:  William Bull
 *      Date:  September, 2002
 *   Purpose:  This is an example of a perception generator - it causes
 *             the NPC to go to something it sees and randomly say a string.
 *             It's currently hardcoded with debugging bear messages. This is
 *             not a practical generator - mostly used for examples.
 -----------------------------------------------------------------------------
 *    Timing:  OnPerception
 -----------------------------------------------------------------------------*/

void ai_g_goto_see()
{
    ai_DebugStart("Generator name='GoTo' timing='See'", AI_DEBUG_COREAI);
    string sSpeakTable = GetLocalString(MEME_SELF, "SpeakTable");
    int    nCount      = ai_GetStringCount(MEME_SELF, sSpeakTable);
    string sText       = ai_GetStringByIndex(MEME_SELF, Random(nCount), sSpeakTable);

    if (GetLocalObject(NPC_SELF, AI_MEME_PARENT) == OBJECT_INVALID)
        ai_PrintString("NPC_SELF is not inheriting.", AI_DEBUG_UTILITY);
    else
        ai_PrintString("NPC_SELF *is* inheriting.", AI_DEBUG_UTILITY);

    ai_PrintString("Got text "+sText+".");
    ai_PrintString("MEME_SELF name = '" + _GetName(MEME_SELF) + "'");

    object oSeen = GetLastPerceived();

    if (GetLocalInt(MEME_SELF, "TargetPC"))
    {
        if (!GetIsPC(oSeen))
        {
            ai_DebugEnd();
            return;
        }
    }

    // Don't go to something we've already gone to in the past six seconds.
    if (ai_GetTemporaryFlag(oSeen, "IveGoneToThis"))
    {
        ai_PrintString("I've seen this thing before.");
        ai_DebugEnd();
        return;
    }
    else
    {
        ai_PrintString("I've never seen you before...");
        ai_SetTemporaryFlag(oSeen, "IveGoneToThis", 1, 60);
    }

    // So what we do is store the "go" behavior on the generator.
    // This behavior takes a list of people to go to; we only add
    // the person on the list if they aren't already on it.
    object oMeme = GetLocalObject(MEME_SELF, "GoMeme");
    if (!GetIsObjectValid(oMeme))
    {
        if (GetLocalInt(MEME_SELF, "NoResume"))
            oMeme = ai_CreateMeme("ai_m_goto", AI_PRIORITY_DEFAULT, AI_PRIORITY_DEFAULT, 0, MEME_SELF);
        else
            oMeme = ai_CreateMeme("ai_m_goto", AI_PRIORITY_DEFAULT, AI_PRIORITY_DEFAULT, AI_MEME_RESUME | AI_MEME_REPEAT, MEME_SELF);

        SetLocalObject(MEME_SELF, "GoMeme", oMeme);
        SetLocalInt(oMeme, "Run", 1);
    }

    // If I'm not already going to the thing...add to the go list.
    if (ai_HasObjectRef(oMeme, oSeen, "Target") == -1)
    {
        ai_PrintString("Adding "+_GetName(oSeen));
        ai_AddObjectRef(oMeme, oSeen, "Target");
        ai_AddStringRef(oMeme, sText, "End");
    }

    /*
       This is what the "bears example" used to say,
       this should be moved into their spawn script,
       referencing the generator, not the meme:

    ai_AddStringRef(oMeme, "Oh that's interesting...");
    ai_AddStringRef(oMeme, "Well, what have we here...");
    ai_AddStringRef(oMeme, "Are you a tastey tid bit?");
    ai_AddStringRef(oMeme, "Ah something for the tummy...");
    ai_AddStringRef(oMeme, "Have I see you before?");
    ai_AddStringRef(oMeme, "If I were a dog, I'd sniff your butt.");
    ai_AddStringRef(oMeme, "I'm strangely drawn to you.");
    ai_AddStringRef(oMeme, "I can see you better up close...");
    ai_AddStringRef(oMeme, "Stand still I'll check you out.");
    ai_AddStringRef(oMeme, "My bear eyes bare down on you.");
    ai_AddStringRef(oMeme, "Bears like to inspect things like you.");
    ai_AddStringRef(oMeme, "Lemme get a closer look...");
    ai_AddStringRef(oMeme, "I have to look at you again...");
    ai_AddStringRef(oMeme, "How many times am I going to have to look at you?");
    ai_AddStringRef(oMeme, "Stay close so I don't forget I saw you.");
    ai_AddStringRef(oMeme, "Ho hum, here I come.");
    ai_AddStringRef(oMeme, "Be right there, then I'll keep walking.");
    ai_AddStringRef(oMeme, "Checkin' you out...");
    ai_AddStringRef(oMeme, "Do all bears check things out like us?");
    ai_AddStringRef(oMeme, "Whew all this new stuff to see.");
    ai_AddStringRef(oMeme, "Wish I could remember if I saw you before...");
    ai_AddStringRef(oMeme, "Hmm...what's that?");
    ai_AddStringRef(oMeme, "Walk walk walk, that's my life...that and berries.");
    ai_AddStringRef(oMeme, "*snort*");
    ai_AddStringRef(oMeme, "*sniff*");
    ai_AddStringRef(oMeme, "*snarl*");
    */

    ai_DebugEnd();
}


/*-----------------------------------------------------------------------------
 * Generator:  ai_g_combat
 *    Author:  William Bull
 *      Date:  September, 2002
 *   Purpose:  This is a trivial sample of an attack response generator.
 *             It sends some hardcoded signals; has been replaced by
 *             lib_combat. It's to be used for demonstration purposes only.
 -----------------------------------------------------------------------------
 *    Timing:  OnAttack, OnPerception
 *   Message:  Publicly Sends:  "Combat/Attacked"
 *             Publicly Sends:  "Combat/See Enemy"
 -----------------------------------------------------------------------------*/

void ai_g_combat_atk()
{
    ai_DebugStart("Generator name='Combat' timing='Attacked'", AI_DEBUG_COREAI);

    struct message stMsg;
    object oSeen = GetLastAttacker();
    if (GetIsEnemy(oSeen))
    {
        stMsg.sMessageName = "Combat/Attacked";
        stMsg.oData = oSeen;
        ai_SendMessage(stMsg);
    }

    ai_DebugEnd();
}

void ai_g_combat_see()
{
    ai_DebugStart("Generator name='Combat' timing='See'", AI_DEBUG_COREAI);

    struct message stMsg;
    object oSeen = GetLastPerceived();

    if (GetIsEnemy(oSeen))
    {
        ai_PrintString("I see an enemy.");
        stMsg.sMessageName = "Combat/See Enemy";
        stMsg.oData = oSeen;
        ai_SendMessage(stMsg);
    }
    else
        ai_PrintString("I see something, but it's not an enemy.");

    ai_DebugEnd();
}


/*-----------------------------------------------------------------------------
 *  Generator:  ai_g_converse_optimized (Start a conversation)
 *     Author:  William Bull
 *       Date:  September, 2002
 *    Purpose:  This is an experimental efficient conversation generator.
 *              It disables the NPC's memetic behavior and manually causes
 *              a conversation to start. You still have to
 *---------------------------------------------------------------------------*/

void ai_g_converse_optimized_tlk()
{
    object oSpeaker = GetLastSpeaker();

    if (!GetIsPC(oSpeaker) && !GetIsDM(oSpeaker))
        return;

    ai_DebugStart("Generator name='Optimized Converse' timing='Talk'");

    string sBusy = ai_GetConfigString(OBJECT_SELF, "ME: Talk Interrupted");
    if (sBusy == "")
        sBusy = "I'm too busy to talk at the moment.";

    if ((ai_GetPriority(ai_GetActiveMeme()) * 100) + ai_GetModifier(ai_GetActiveMeme()) > 350)
    {
        ai_PrintString(sBusy);
        ai_DebugEnd();
        return;
    }

    ClearAllActions();

    string sFriendly = ai_GetConfigString(OBJECT_SELF, "MT: Dialog Friendly");
    string sNeutral  = ai_GetConfigString(OBJECT_SELF, "MT: Dialog Neutral");
    string sEnemy    = ai_GetConfigString(OBJECT_SELF, "MT: Dialog Enemy");
    string sResRef   = ai_GetLocalString(MEME_SELF,  "sResRef");

    // If we're not already talking to someone...perhaps we should.
    if (!IsInConversation(OBJECT_SELF))
    {
        // Let's find out who the speaker is, and select the
        // right dialog.
        if (GetIsEnemy(OBJECT_SELF, oSpeaker) && sEnemy != "")
        {
            if (sEnemy != "None")
                sResRef = sEnemy;
            else
            {
                ai_DebugEnd();
                return;
            }
        }
        else if (!GetIsFriend(OBJECT_SELF, oSpeaker))
        {
            if (sNeutral != "None")
                sResRef = sNeutral;
            else
            {
                ai_DebugEnd();
                return;
            }
        }
        else
        {
            if (sFriendly != "None")
                sResRef = sFriendly;
            else
            {
                ai_DebugEnd();
                return;
            }
        }

        // Do the converations
        ActionStartConversation(oSpeaker, sResRef);

        if (ai_GetConfigString(OBJECT_SELF, "MT: Talk Animated") == "True")
        {
            int nHD = GetHitDice(OBJECT_SELF) - GetHitDice(oSpeaker);
            // Bioware function, found in x0_i0_anims
            AnimActionPlayRandomTalkAnimation(nHD);
        }
        else
            ActionWait(9999.9);

        SetLocalObject(MEME_SELF, "Speaker", GetLastSpeaker());
    }
    else
    {
        if (GetPCSpeaker() != GetLocalObject(MEME_SELF, "Speaker"))
            SpeakString(sBusy);
    }

    ai_DebugEnd();
}


/*-----------------------------------------------------------------------------
 *  Generator:  ai_g_converse (Start a conversation)
 *     Author:  William Bull
 *       Date:  September, 2002
 *    Purpose:  This causes a conversation to start. It reads variables from
 *              the NPC to see what conversation it should start.
 -----------------------------------------------------------------------------
 *    Timing:  Conversation
 *-----------------------------------------------------------------------------
 *  String "Busy":    This is what is said when the NPC is busy.
 *  float  "Timeout": The maximum time they'll talk to the PC.
 *  String "Timeout": The message they say when the time expires.
 *  String "ResRef":  The name of the converation dialog. If none is provided,
 *                    it will use the default one.
 *  int "Private":    The conversation is private.
 -----------------------------------------------------------------------------*/

// Incidently this entire thing could be optimized to just clear all actions,
// handle the dialog, and do an ai_UpdateActions() when the conversation is
// done. And have nothing to do with memes. If you wanted to be nice you
// could even just check the priority of the active meme and see if it's
// at a certain level. The only possible benefit here is that we've developed
// a meme for talking that is useful at different times. But player-engaged
// dialogs might just be better off done by disabling and enabling the memetic
// toolkit, rather than going through all this bloody rigamorole. I mean we
// have to be honest -- just because we built a giant machine to drive through
// cities and crush down buildings doesn't mean we need to use it to get from
// out front porch to the park on the other side of town.  -w. bull
void ai_g_converse_tlk()
{
    object oSpeaker = GetLastSpeaker();
    if (!GetIsPC(oSpeaker) && !GetIsDM(oSpeaker))
        return;

    ai_DebugStart("Generator name='Converse' timing='Talk'", AI_DEBUG_COREAI);

    string sBusy    = GetLocalString(MEME_SELF, "Busy");
    object oMeme    = GetLocalObject(MEME_SELF, "Meme");
    string sTimeout = GetLocalString(MEME_SELF, "Timeout");
    float  fTimeout = GetLocalFloat (MEME_SELF, "Timeout");
    int    bPrivate = GetLocalInt   (MEME_SELF, "Private");
    string sResRef  = GetLocalString(MEME_SELF, "ResRef");

    string sFriendly = ai_GetConfigString(OBJECT_SELF, "MT: Dialog Friendly");
    string sNeutral  = ai_GetConfigString(OBJECT_SELF, "MT: Dialog Neutral");
    string sEnemy    = ai_GetConfigString(OBJECT_SELF, "MT: Dialog Enemy");

    // If we're not already talking to someone...perhaps we should.
    if (oMeme == OBJECT_INVALID)
    {
        if (sResRef == "")
        {
            // Let's find out who the speaker is, and select the
            // right dialog.
            if (GetIsEnemy(OBJECT_SELF, oSpeaker) && sEnemy != "")
            {
                if (sEnemy != "None")
                    sResRef = sEnemy;
                else ai_DebugEnd();
            }
            else if (!GetIsFriend(OBJECT_SELF, oSpeaker))
            {
                if (sNeutral != "None")
                    sResRef = sNeutral;
                else ai_DebugEnd();
            }
            else
            {
                if (sFriendly != "None")
                    sResRef = sFriendly;
                else ai_DebugEnd();
            }
        }

        oMeme = ai_CreateMeme("ai_m_converse", AI_PRIORITY_MEDIUM, 30, AI_MEME_INSTANT, MEME_SELF);
        SetLocalObject(MEME_SELF, "Meme", oMeme);
        ai_PrintString("The speaker is " + GetName(GetLastSpeaker())+".");
        SetLocalObject(oMeme, "Speaker", GetLastSpeaker());
        if (sTimeout != "")
            SetLocalString(oMeme, "Timeout", sTimeout);
        if (fTimeout != 0.0)
            SetLocalFloat(oMeme, "Timeout", fTimeout);
        SetLocalString(oMeme, "ResRef", sResRef);
        SetLocalInt(oMeme, "Private", bPrivate);
    }
    else
    {
        if (GetPCSpeaker() != GetLocalObject(oMeme, "Speaker"))
        {
            if (sBusy == "")
                sBusy = "One moment, I'm busy right now.";
            SpeakString(sBusy);
        }
    }
    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *  Generator:  ai_g_converse (Start a conversation)
 *     Author:  William Bull
 *       Date:  September, 2002
 *    Purpose:  This causes a conversation to start
 -----------------------------------------------------------------------------
 *    Timing:  Aborted Conversation
 -----------------------------------------------------------------------------*/

void ai_g_converse_abt()
{
    ai_DebugStart("Generator name='Converse' timing='DialogAborted'", AI_DEBUG_COREAI);

    object oActive = ai_GetActiveMeme();

    if (GetLocalString(oActive, "Name") == "ai_m_converse")
    {
        // If the conversation was created by the generator, disassociate it.
        if (oActive == GetLocalObject(MEME_SELF, "Meme"))
            DeleteLocalObject(MEME_SELF, "Meme");

        ai_DestroyMeme(oActive);
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 *  Generator:  g_converse (Start a conversation)
 *     Author:  William Bull
 *       Date:  September, 2002
 *    Purpose:  This causes a conversation to start
 -----------------------------------------------------------------------------
 *    Timing:  Successfully Ended Conversation
 -----------------------------------------------------------------------------*/

void ai_g_converse_bye()
{
    ai_DebugStart("Generator name='Converse' timing='DialogEnded'", AI_DEBUG_COREAI);

    object oActive = ai_GetActiveMeme();

    if (GetLocalString(oActive, "Name") == "ai_m_converse")
    {
        // If the conversation was created by the generator, disassociate it.
        if (oActive == GetLocalObject(MEME_SELF, "Meme"))
            DeleteLocalObject(MEME_SELF, "Meme");

        ai_DestroyMeme(oActive);
    }

    ai_DebugEnd();
}

/*-----------------------------------------------------------------------------
 * Generator:  ai_g_door
 *    Author:  Joel Martin (a.k.a. Garad Moonbeam)
 *      Date:  April, 2003
 *   Purpose:  This generator will try to solve the problem of being blocked by
 *             a door.  Possible solutions are:
 *                  OpenDoor
 *
 -----------------------------------------------------------------------------
 *    Timing:  Intialize, OnBlocked
 -----------------------------------------------------------------------------*/
void ai_g_door_ini()
{
    ai_DebugStart("Generator name='ai_g_door' timing='Initialize'", AI_DEBUG_COREAI);

    int nINT = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE);

    if (!GetLocalInt(MEME_SELF, "PreferOpen"))
        SetLocalInt(MEME_SELF, "PreferOpen", - nINT);
    if (!GetLocalInt(MEME_SELF, "PreferUnlock"))
        SetLocalInt(MEME_SELF, "PreferUnlock", nINT);
    if (!GetLocalInt(MEME_SELF, "PreferDisable"))
        SetLocalInt(MEME_SELF, "PreferDisable", nINT + GetSkillRank(SKILL_DISABLE_TRAP, OBJECT_SELF));
    if (!GetLocalInt(MEME_SELF, "PreferKnock"))
        SetLocalInt(MEME_SELF, "PreferKnock", nINT);
    if (!GetLocalInt(MEME_SELF, "PreferBash"))
        SetLocalInt(MEME_SELF, "PreferBash", - nINT);

    if (!GetLocalInt(MEME_SELF, "DO_PLOT"))
        SetLocalInt(MEME_SELF, "DO_PLOT", FALSE);

    if (!GetLocalInt(MEME_SELF, "bAutoDetect"))
        SetLocalInt(MEME_SELF, "bAutoDetect", FALSE);

    if (!GetLocalInt(MEME_SELF, "bAutoDisable"))
        SetLocalInt(MEME_SELF, "bAutoDisable", FALSE);

    if (!GetLocalInt(MEME_SELF, "Disable_Confidence"))
        SetLocalInt(MEME_SELF, "Disable_Confidence", 10);

    ai_DebugEnd();
}

void ai_g_door_blk()
{
    object oBlocking = GetBlockingDoor();

    if (GetObjectType(oBlocking) != OBJECT_TYPE_DOOR)
        return;

    ai_DebugStart("Generator name='ai_g_door' timing='Blocked'", AI_DEBUG_COREAI);

    ai_PrintString("Being blocked by " + GetTag(oBlocking));

    // Check to see if this NPC can open plot doors.
    if (GetPlotFlag(oBlocking) && !GetLocalInt(MEME_SELF, "DO_PLOT"))
    {
        ai_PrintString("Not allowed to deal with plot doors");
        ai_DebugEnd();
        return;
    }

    object oActive    = ai_GetActiveMeme();
    int    bIsLocked  = GetLocked(oBlocking);
    int    bIsTrapped = GetIsTrapped(oBlocking);
    int    bDetected  = FALSE;


    // By default we would try to open it
    object oSolution = ai_CreateMeme("ai_m_opendoor", AI_PRIORITY_MEDIUM, GetLocalInt(MEME_SELF, "PreferOpen"), 0, oActive);
    SetLocalObject(oSolution, "Door", oBlocking);
    ai_PrintString("Created solution meme: ai_m_opendoor");

    // Try to unlock if its locked
    if(bIsLocked)
    {
        ai_PrintString("Door is locked.");

        // Check if you have the key to this door
        string sKeyTag = GetLockKeyTag(oBlocking);
        object oKey    = GetItemPossessedBy(OBJECT_SELF, sKeyTag);

        if (GetIsDoorActionPossible(oBlocking, DOOR_ACTION_UNLOCK) || GetIsObjectValid(oKey))
        {
            oSolution = ai_CreateMeme("ai_m_unlockdoor", AI_PRIORITY_MEDIUM, GetLocalInt(MEME_SELF, "PreferUnlock"), 0, oActive);
            SetLocalObject(oSolution, "Door", oBlocking);
            ai_PrintString("Created solution meme: ai_m_unlockdoor");

            if(GetIsObjectValid(oKey))
            {
                ai_PrintString("Setting bHadKey=TRUE for ai_m_unlockdoor");
                SetLocalInt(oSolution, "bHasKey", TRUE);
            }

            string sStrref;
            int nStringCount;
            for (nStringCount=0; nStringCount < ai_GetStringCount(MEME_SELF, "SuccessString"); nStringCount++)
            {
                sStrref = ai_GetStringByIndex(MEME_SELF, nStringCount, "SuccessString");
                ai_AddStringRef(oSolution, sStrref, "SuccessString");
            }
            for (nStringCount=0; nStringCount < ai_GetStringCount(MEME_SELF, "FailureString"); nStringCount++)
            {
                sStrref = ai_GetStringByIndex(MEME_SELF, nStringCount, "FailureString");
                ai_AddStringRef(oSolution, sStrref, "FailureString");
            }
        }
        else
            ai_PrintString("DOOR_ACTION_UNLOCK not possible.");

        // Also check if we can cast knock at it
        if(GetIsDoorActionPossible(oBlocking, DOOR_ACTION_KNOCK))
        {
            oSolution = ai_CreateMeme("ai_m_knockdoor", AI_PRIORITY_MEDIUM, GetLocalInt(MEME_SELF, "PreferKnock"), 0, oActive);
            SetLocalObject(oSolution, "Door", oBlocking);
            ai_PrintString("Created solution meme: ai_m_knockdoor");
        }
        else
            ai_PrintString("DOOR_ACTION_KNOCK not possible");

        // Also could bash it
        ai_PrintString("It locked... me bash!");

        // Actually want to create a sequence of EquipBestWeapon->Attack
        object oSequence = ai_CreateSequence("ai_m_bashdoor", AI_PRIORITY_DEFAULT, GetLocalInt(MEME_SELF, "PreferBash"), 0, oActive);
        oSolution = ai_CreateSequenceMeme(oSequence, "ai_m_equipappropriate", AI_PRIORITY_MEDIUM, GetLocalInt(MEME_SELF, "PreferBash"), 0);
        SetLocalObject(oSolution, "Target", oBlocking);
        oSolution = ai_CreateSequenceMeme(oSequence, "ai_m_attack", AI_PRIORITY_MEDIUM, GetLocalInt(MEME_SELF, "PreferBash"), 0);
        SetLocalObject(oSolution, "Enemy", oBlocking);
        ai_StartSequence(oSequence);
        ai_PrintString("Created solution meme sequence: ai_m_bashdoor");
    }

    // Check if the door is trapped
    if(bIsTrapped)
    {
        ai_PrintString("Door is trapped!");

        // If its one of ours, leave it be
        if(GetIsFriend(oBlocking))
        {
            ai_PrintString("Door has friendly trap, don't disarm it.");
            ai_DebugEnd();
            return;
        }

        if(GetLocalInt(MEME_SELF, "bAutoDetect"))
            bDetected = TRUE;
        else
        {
            // We're not auto-detecting, so roll our skillcheck
            SetLocalObject(NPC_SELF, "Trap", oBlocking);
            object oResult = ai_CallFunction("SkillCheck_DetectTrap", OBJECT_SELF);
            bDetected = GetLocalInt(oResult, "SC_RESULT");
            DeleteLocalInt(oResult, "SC_RESULT");
            DeleteLocalObject(NPC_SELF, "Trap");
        }

        if (bDetected)
        {
            ai_PrintString("Trap detected by " + _GetName(NPC_SELF));

            // We've detected the trap. Now see if we can disarm it.
            int nDisableDC = GetTrapDisarmDC(oBlocking);
            int nSkillDisable = GetSkillRank(SKILL_SEARCH, OBJECT_SELF);

            if (((nSkillDisable + GetLocalInt(MEME_SELF, "Disable_Confidence")) >= nDisableDC) || GetLocalInt(MEME_SELF, "bAutoDisable"))
            {
                oSolution = ai_CreateMeme("ai_m_disabletrap", AI_PRIORITY_MEDIUM, GetLocalInt(MEME_SELF, "PreferDisable"), 0, oActive);
                SetLocalObject(oSolution, "Trap", oBlocking);
                ai_PrintString("Created solution meme: ai_m_disabletrap");

                string sStrref;
                int nStringCount;
                for(nStringCount=0; nStringCount < ai_GetStringCount(MEME_SELF, "SuccessString"); nStringCount++)
                {
                    sStrref = ai_GetStringByIndex(MEME_SELF, nStringCount, "SuccessString");
                    ai_AddStringRef(oSolution, sStrref, "SuccessString");
                }
                for(nStringCount=0; nStringCount < ai_GetStringCount(MEME_SELF, "FailureString"); nStringCount++)
                {
                    sStrref = ai_GetStringByIndex(MEME_SELF, nStringCount, "FailureString");
                    ai_AddStringRef(oSolution, sStrref, "FailureString");
                }
            }
            else
                ai_PrintString("Trap difficulty exceeds confidence level, aborting disable attempt.");
        }
        else
            ai_PrintString("Trap not detected.");
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
 *   file and editing "cb_mod_onload" to register the name of your new library.
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
        ai_LibraryImplements("ai_g_combat",   "_atk", 0x0100+0x01);
        ai_LibraryImplements("ai_g_combat",   "_see", 0x0100+0x02);

        ai_LibraryImplements("ai_g_goto",     "_see", 0x0200+0x01);

        ai_LibraryImplements("ai_g_converse", "_tlk", 0x0300+0x01);
        ai_LibraryImplements("ai_g_converse", "_bye", 0x0300+0x02);
        ai_LibraryImplements("ai_g_converse", "_abt", 0x0300+0x03);

        ai_LibraryImplements("ai_g_door",     "_ini", 0x0400+0x01);
        ai_LibraryImplements("ai_g_door",     "_blk", 0x0400+0x02);

        //ai_LibraryImplements("<name>",        "_atk", 0x??00+0x01);
        //ai_LibraryImplements("<name>",        "_blk", 0x??00+0x02);
        //ai_LibraryImplements("<name>",        "_end", 0x??00+0x03);
        //ai_LibraryImplements("<name>",        "_tlk", 0x??00+0x04);
        //ai_LibraryImplements("<name>",        "_dmg", 0x??00+0x05);
        //ai_LibraryImplements("<name>",        "_dth", 0x??00+0x06);
        //ai_LibraryImplements("<name>",        "_inv", 0x??00+0x07);
        //ai_LibraryImplements("<name>",        "_hbt", 0x??00+0x08);
        //ai_LibraryImplements("<name>",        "_see", 0x??00+0x09);
        //ai_LibraryImplements("<name>",        "_van", 0x??00+0x0a);
        //ai_LibraryImplements("<name>",        "_hea", 0x??00+0x0b);
        //ai_LibraryImplements("<name>",        "_ina", 0x??00+0x0c);
        //ai_LibraryImplements("<name>",        "_per", 0x??00+0x0d);
        //ai_LibraryImplements("<name>",        "_rst", 0x??00+0x0e);
        //ai_LibraryImplements("<name>",        "_mgk", 0x??00+0x0f);
        //ai_LibraryImplements("<name>",        "_ini", 0x??00+0xff);

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

    ai_PrintString("MEME_ENTRYPOINT == "+IntToHexString(MEME_ENTRYPOINT), AI_DEBUG_UTILITY);
    switch (MEME_ENTRYPOINT & 0xff00)
    {
        case 0x0100: switch (MEME_ENTRYPOINT  & 0x00ff)
                     {
                         case 0x01: ai_g_combat_atk();   break;
                         case 0x02: ai_g_combat_see();   break;
                     }   break;

        case 0x0200: switch (MEME_ENTRYPOINT  & 0x00ff)
                     {
                         case 0x01: ai_g_goto_see();     break;
                     }   break;

        case 0x0300: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_g_converse_tlk();   break;
                         case 0x02: ai_g_converse_bye();   break;
                         case 0x03: ai_g_converse_abt();   break;
                     }   break;

        case 0x0400: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: ai_g_door_ini();   break;
                         case 0x02: ai_g_door_blk();   break;
                     }   break;

        /*
        case 0x??00: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0x01: <name>_atk();     break; // Attacked
                         case 0x02: <name>_blk();     break; // Blocked by a door
                         case 0x03: <name>_end();     break; // Combat round ended
                         case 0x04: <name>_tlk();     break; // Conversation starts or speech is heard
                         case 0x05: <name>_dmg();     break; // Damaged
                         case 0x06: <name>_dth();     break; // Death
                         case 0x07: <name>_inv();     break; // Inventory disturbed
                         case 0x08: <name>_hbt();     break; // Heartbeat
                         case 0x09: <name>_see();     break; // Perception (Sight)
                         case 0x0a: <name>_van();     break; // Perception (Disappeared - Vanished)
                         case 0x0b: <name>_hea();     break; // Perception (Heard)
                         case 0x0c: <name>_ina();     break; // Perception (Disappeared - Inaudible)
                         case 0x0d: <name>_per();     break; // Bulk Perception (Coming Soon)
                         case 0x0e: <name>_rst();     break; // Rest
                         case 0x0f: <name>_mgk();     break; // Spell target
                         case 0xff: <name>_ini();     break; // Initializer
                     }   break;
        */
    }

    ai_DebugEnd();
}
