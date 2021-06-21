/*
Filename:           chat_playerchat
System:             Chat (hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 14th, 200
Summary:
OnPlayerChat hook-in script for chat system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:
*/

#include "chat_i_main"

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();
    int nTalkVolume = GetPCChatVolume();

    if (nTalkVolume == TALKVOLUME_PARTY && CHAT_DISABLE_PARTY_CHAT)
    {
        // Execute debugging code, and then abort
        return;
    }

    chat_SetLastChatMessage(sMessage, oPC);
    chat_DoOfflineMessages(oPC, sMessage, nTalkVolume);
    chat_DoLogMessages(oPC, sMessage, nTalkVolume);
}
