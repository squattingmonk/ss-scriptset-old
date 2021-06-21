/*
Filename:           chat_c_main
System:             Chat (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7, 2009
Summary:
Chat configuration settings. This script contains user definable toggles and
settings for the chat system.

This script is freely editable by developers. It should not contain any
constants that should not be overridable by other builders. Please put those in
chat_i_main.

All below constants may be overridden, but do not alter the names of the
constants.

This script is consumed by chat_i_main as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Setting this to TRUE will disable party chat. Party chat is used for
// In Game configuration and debuging.
const int CHAT_DISABLE_PARTY_CHAT = TRUE;

// Enable / Disable offline messaging system
const int CHAT_USE_OFFLINE_MESSAGING = TRUE;

// This is the TalkVolume (TALKVOLUME_* constant) used to send offline messages.
// TALKVOLUME_TELL is not supported. -1 means any (except tell).
const int CHAT_OFFLINE_MESSAGING_TALKVOLUME = -1;

// If set to TRUE, this will show all offline messages to the player when they
// log in. Change to FALSE if you wish to show them in another fashion.
const int CHAT_SHOW_OFFLINE_MESSAGES_ON_LOGIN = TRUE;

// This is the TalkVolume (TALKVOLUME_* constant) used to create a log output.
// TALKVOLUME_TELL is not supported. -1 means any (except tell).
const int CHAT_LOG_MESSAGE_TALKVOLUME = -1;

// Setting this to TRUE means only team members can create log outputs.
const int CHAT_LOG_MESSAGE_TEAM_ONLY = FALSE;

