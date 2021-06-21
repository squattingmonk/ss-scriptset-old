/*
Filename:           chat_i_main
System:             Chat (include script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       July 17, 2008
Summary:
Chat system primary include script. This file holds the functions commonly used
by the chat system.

The scripts contained herein are those included in Sherincall's SHC ruleset,
customized for compatibility with Shadows & Silver's needs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Core include script
#include "g_i_generic"

// Chat configuration script
#include "chat_c_main"

// Chat constants deifnition script
#include "chat_i_constants"



// DataVault global
object oDataVault = GetObjectByTag(CHAT_DATA_VAULT_TAG);







/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// >----< chat_SetLastChatMessage >----<
// <chat_i_main>
// Saves oPC's last message.
void chat_SetLastChatMessage(string sMessage, object oPC = OBJECT_SELF);

// >----< chat_GetLastChatMessage >----<
// <chat_i_main>
// Returns the last chat message of oPC.
string chat_GetLastChatMessage(object oPC=OBJECT_SELF);

// >----< chat_SendMessageToOfflinePC >----<
// <chat_i_main>
// Sends the message to the offline PC.
void chat_SendMessageToOfflinePC(string sMessage, string sCharacterName);

// >----< SendMessageToOfflinePlayer >----<
// <chat_i_main>
// Sends the message to the offline Player.
void chat_SendMessageToOfflinePlayer(string sMessage, string sPlayerName);

// >----< chat_ShowOfflineMessages >----<
// <chat_i_main>
// Shows the offline messages sent to the oPC, and the playername
void chat_ShowOfflineMessages(object oPC);

// >----< chat_DoOfflineMessages >----<
// <chat_i_main>
// Main function for offline messaging system.
void chat_DoOfflineMessages(object oPC, string sMessage, int nTalkVolume);

// >----< chat_DoLogMessages >----<
// <chat_i_main>
// Creates a log output if the message starts with "/log"
void chat_DoLogMessages(object oPC, string sMessage, int nTalkVolume);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

void chat_SetLastChatMessage(string sMessage, object oPC = OBJECT_SELF)
{
    SetLocalString(oPC, CHAT_LAST_MESSAGE, sMessage);
}

string chat_GetLastChatMessage(object oPC = OBJECT_SELF)
{
    return GetLocalString(oPC, CHAT_LAST_MESSAGE);
}

void chat_SendMessageToOfflinePC(string sMessage, string sCharacterName)
{
     int i = 0;

     // Cycle through old messages until an unoccupied index is found
     string sOldMessage = ss_GetDatabaseString(sCharacterName + IntToString(i), oDataVault);

     // string sOldMessage = NBDE_GetCampaignString(CHAT_DATABASE, sCharacterName + IntToString(i));

     while (sOldMessage != "")
     {
        i++;
        sOldMessage = ss_GetDatabaseString(sCharacterName + IntToString(i), oDataVault);
     // sOldMessage = NBDE_GetCampaignString(CHAT_DATABASE, sCharacterName + IntToString(i));
     }

     // Set the new message to the unoccupied index
     ss_SetDatabaseString(sCharacterName + IntToString(i), sMessage, oDataVault);

     // NBDE_SetCampaignString(CHAT_DATABASE, sCharacterName + IntToString(i), sMessage);
     // NBDE_FlushCampaignDatabase(CHAT_DATABASE);
}

void chat_SendMessageToOfflinePlayer(string sMessage, string sPlayerName)
{
     int i = 0;

     // Cycle through old messages until an unoccupied index is found
     string sOldMessage = ss_GetDatabaseString(sPlayerName + IntToString(i), oDataVault);

     // string sOldMessage = NBDE_GetCampaignString(CHAT_DATABASE, sPlayerName + IntToString(i));
     while (sOldMessage != "")
     {
        i++;
        sOldMessage = ss_GetDatabaseString(sPlayerName + IntToString(i), oDataVault);
     // sOldMessage = NBDE_GetCampaignString(CHAT_DATABASE, sPlayerName + IntToString(i));
     }

     // Set the new message to the unoccupied index
     ss_SetDatabaseString(sPlayerName + IntToString(i), sMessage, oDataVault);

     // NBDE_SetCampaignString(CHAT_DATABASE, sPlayerName + IntToString(i), sMessage);
     // NBDE_FlushCampaignDatabase(CHAT_DATABASE);
}

void chat_ShowOfflineMessages(object oPC)
{
    string sCharacterName = GetName(oPC);
    string sPlayerName    = GetPCPlayerName(oPC);

    int i = 0;
    string sMessage = ss_GetDatabaseString(sCharacterName + IntToString(i), oDataVault);

    // string sMessage = NBDE_GetCampaignString(CHAT_DATABASE, sCharacterName + IntToString(i));

    if (sMessage == "")
        sMessage = COLOR_INFO + CHAT_TEXT_NO_MESSAGES + COLOR_END + COLOR_DIVINE + sCharacterName + COLOR_END;

    while (sMessage != "")
    {
        // Delete the old message, send it to PC, and get the next one
        ss_DeleteDatabaseVariable(sPlayerName + IntToString(i), oDataVault);
        // NBDE_DeleteCampaignString(CHAT_DATABASE, sCharacterName + IntToString(i));
        SendMessageToPC(oPC, sMessage);
        i++;
        sMessage = ss_GetDatabaseString(sCharacterName + IntToString(i), oDataVault);
        // sMessage = NBDE_GetCampaignString(CHAT_DATABASE, sCharacterName + IntToString(i));
    }


    // Refresh values of i.
    i = 0;

    sMessage = ss_GetDatabaseString(sPlayerName + IntToString(i), oDataVault);
    // sMessage = NBDE_GetCampaignString(CHAT_DATABASE, sPlayerName + IntToString(i));


    if (sMessage == "")
        sMessage = COLOR_INFO + CHAT_TEXT_NO_MESSAGES + COLOR_END + COLOR_DIVINE + sPlayerName + COLOR_END;

    while (sMessage != "")
    {
        // Delete the old message, send it to PC, and get the next one
        ss_DeleteDatabaseVariable(sPlayerName + IntToString(i), oDataVault);
        // NBDE_DeleteCampaignString(CHAT_DATABASE, sPlayerName + IntToString(i));
        SendMessageToPC(oPC, sMessage);
        i++;
        sMessage = ss_GetDatabaseString(sPlayerName + IntToString(i), oDataVault);
        // sMessage = NBDE_GetCampaignString(CHAT_DATABASE, sPlayerName + IntToString(i));
    }

    // NBDE_FlushCampaignDatabase(CHAT_DATABASE);
}

void chat_DoOfflineMessages(object oPC, string sMessage, int nTalkVolume)
{
    // End function if offline messaging is disabled
    if (CHAT_USE_OFFLINE_MESSAGING == FALSE)
    {
        SendMessageToPC(oPC, COLOR_FAIL + CHAT_TEXT_OFFLINE_MESSAGING_IS_DISABLED + COLOR_END);
        return;
    }

    int bPC; // Used to determine whether the message is meant for a character or a player.
    int nLength = GetStringLength(sMessage);

    // If no specific TalkVolume is specified, assign the default value.
    if (CHAT_OFFLINE_MESSAGING_TALKVOLUME == -1)
       nTalkVolume = CHAT_OFFLINE_MESSAGING_TALKVOLUME;

    // End function if TalkVolume is wrong
    if (nTalkVolume != CHAT_OFFLINE_MESSAGING_TALKVOLUME)
       return;

    // End function if the start isn't right.
    if (GetStringLeft(sMessage, 4) != "/msg")
        return;

    // Check whether the message is meant for a character or a player.
    if (GetSubString(sMessage, 5, 2) == "pl")
        bPC = FALSE;
    else if (GetSubString(sMessage, 5, 2) == "pc")
        bPC = TRUE;
    else
    {
        SendMessageToPC(oPC, COLOR_FAIL + CHAT_TEXT_MESSAGE_SENDING_FAILED_PLAYER_OR_PC + COLOR_END);
        return;
    }

    // Check whether the receiver's name is in quotes
    if (GetSubString(sMessage, 8, 1) != QUOTE)
    {
        SendMessageToPC(oPC, COLOR_FAIL + CHAT_TEXT_MESSAGE_SENDING_FAILED_NO_QUOTES + COLOR_END);
        return;
    }

    // Get the receiver PC/Player
    string sSendTo = GetSubString(sMessage, 9, nLength - 8);
    sSendTo = StringParse(sSendTo, QUOTE);

    // Let the player know he put in incorrect parameters.
    if (sSendTo == GetStringRight(sMessage, nLength - 8))
    {
        SendMessageToPC(oPC, COLOR_FAIL + CHAT_TEXT_MESSAGE_SENDING_FAILED_NO_QUOTES + COLOR_END);
        return;
    }

    int nMsgLength = nLength - GetStringLength(sSendTo) - 10;
    sMessage = GetStringRight(sMessage, nMsgLength);

    if (sMessage == "")
    {
        SendMessageToPC(oPC, COLOR_FAIL + CHAT_TEXT_MESSAGE_SENDING_FAILED_NO_MESSAGE + COLOR_END);
        return;
    }

    // Use chat_SendMessageToOffline* functions to send the actual message.
    if (bPC)
    {
        sMessage = COLOR_ORANGE + "From: " + COLOR_END + COLOR_DIVINE + GetName(oPC) + COLOR_END
                   + COLOR_ORANGE + " | To: "+ COLOR_END + COLOR_DIVINE + sSendTo + COLOR_END
                   + COLOR_BLUE_LIGHT + "   Message: " + sMessage + COLOR_END;
        chat_SendMessageToOfflinePC(sMessage, sSendTo);
    }
    else
    {
        sMessage = COLOR_ORANGE + "From: " + COLOR_END + COLOR_DIVINE + GetPCPlayerName(oPC) + COLOR_END
                   + COLOR_ORANGE + " | To: " + COLOR_END + COLOR_DIVINE + sSendTo + COLOR_END
                   + COLOR_BLUE_LIGHT + "   Message: " + sMessage + COLOR_END;
        chat_SendMessageToOfflinePlayer(sMessage, sSendTo);
    }

    // Send the PC a copy of the message he just sent.
    SendMessageToPC(oPC, sMessage);

    // Remove the actual message in the chatbox, so others can't hear.
    SetPCChatMessage();
}



// >----< chat_DoLogMessages >----<
// <chat_i_main>
// Creates a log output if the message starts with "/log"
void chat_DoLogMessages(object oPC, string sMessage, int nTalkVolume)
{
    if (ss_GetIsTeamMember(oPC) == FALSE && CHAT_LOG_MESSAGE_TEAM_ONLY == TRUE) return;

    // If no specific TalkVolume is specified, assign the default value.
    if (CHAT_LOG_MESSAGE_TALKVOLUME == -1)
       nTalkVolume = CHAT_LOG_MESSAGE_TALKVOLUME;

    // End function if TalkVolume is wrong
    if (nTalkVolume != CHAT_LOG_MESSAGE_TALKVOLUME)
       return;

    if (GetStringLeft(sMessage, 4) != "/log")
        return;


    int nLength = GetStringLength(sMessage);
    sMessage = GetStringRight(sMessage, nLength - 5);

    WriteTimestampedLogEntry("["+GetPCPlayerName(oPC)+"] " + sMessage);
}









//void main() {TRUE;}
