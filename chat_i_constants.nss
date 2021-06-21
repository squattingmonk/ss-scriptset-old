/*
Filename:           chat_i_constants
System:             Chat System (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 14, 2009
Summary:
Chat System constants definition script. This file contains the constants
commonly used in the chat system. This script is consumed by chat_i_main as an
include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// General constants
const string CHAT_DATABASE = "CHAT";

// Tag of the data vault object
const string CHAT_DATA_VAULT_TAG    =   "CHAT_DATA_VAULT";

// Local variable names
const string CHAT_LAST_MESSAGE = "CHAT_LAST_MESSAGE";

// Text strings
const string CHAT_TEXT_NO_MESSAGES = "No offline messages for ";
const string CHAT_TEXT_OFFLINE_MESSAGING_IS_DISABLED = "Offline messaging is disabled.";
const string CHAT_TEXT_MESSAGE_SENDING_FAILED_PLAYER_OR_PC = "Message sending failed. Write 'pl' to send to a Player, or 'pc' to send to a Character.";
const string CHAT_TEXT_MESSAGE_SENDING_FAILED_NO_QUOTES = "Message sending failed. Write player/character name in quotes.";
const string CHAT_TEXT_MESSAGE_SENDING_FAILED_NO_MESSAGE = "Message sending failed. No message found.";
