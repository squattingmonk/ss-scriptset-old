/*
Filename:           prr_a_greet
System:             Personal Reputation and Reaction (conversation action)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Nov. 23, 2007
Summary:
Notes that the PC has greeted the NPC so he will recognize him persistently.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "prr_i_main"

void main()
{
    object oPC  = GetPCSpeaker();
    string sTag = GetTag(OBJECT_SELF);
    ss_SetDatabaseInt(PRR_GREET_PREFIX + sTag, TRUE, oPC);
}

