/*
Filename:           chat_cliententer
System:             Chat (hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 14th, 200
Summary:
OnClientEnter hook-in script for chat system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:
*/

#include "chat_i_main"

void main()
{
    if (!CHAT_USE_OFFLINE_MESSAGING)
        return;

    object oPC = GetEnteringObject();

    if (GetIsPC(oPC) || GetIsDM(oPC))
        chat_ShowOfflineMessages(oPC);
}
