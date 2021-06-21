/*
Filename:           prr_s_gethelp
System:             Personal Reputation and Reaction (starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Nov. 23, 2007
Summary:
Gets the helpfulness of the NPC based on his reaction to the PC.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "prr_i_main"

int StartingConditional()
{
    object oNPC = OBJECT_SELF;
    object oPC = GetPCSpeaker();
    string sHelpfulness = prr_GetHelpfulness(oNPC, oPC);

    SetCustomToken(PRR_TOKEN_HELPFULNESS, sHelpfulness);
    return TRUE;
}

