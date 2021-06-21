/*
Filename:           ss_e_credlgend
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       June 22, 2009
Summary:
OnConversationEnd creature event hook-in script. Place this script on the
OnConversationEnd event in the Conversation properties.

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
    ss_RunEventScripts(SS_CREATURE_EVENT_ON_CONVERSATION_END);
}
