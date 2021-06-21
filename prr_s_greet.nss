/*
Filename:           prr_s_greet
System:             Personal Reputation and Reaction (starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Nov. 23, 2007
Summary:
A starting conditional that returns TRUE if the PC hasn't greeted the NPC. Place
in the "Text Appears When" box for a greeting that assumes the PC has not met
the NPC.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "prr_i_main"

int StartingConditional()
{
    string sTag   = GetTag(OBJECT_SELF);
    object oPC    = GetPCSpeaker();
    int bDidGreet = ss_GetDatabaseInt(PRR_GREET_PREFIX + sTag, oPC);

    if (bDidGreet)
        return FALSE;
    return TRUE;
}

