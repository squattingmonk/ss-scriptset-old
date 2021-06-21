/*
Filename:           ss_e_credlgabort
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       June 22, 2009
Summary:
OnConversationAbort creature event hook-in script. Place this script on the
OnConversationAbort event in the Conversation properties.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Core system include script.
#include "ss_i_core"

void main()
{
    ss_RunEventScripts(SS_CREATURE_EVENT_ON_CONVERSATION_ABORT);
}
