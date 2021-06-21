/*
Filename:           prr_s_dmtpcrum
System:             Persistent Reputation & Reaction (prr_dmtool starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool starting conditional script that determines whether the PC's
reputation with the NPC can be adjusted by the mid amount set in prr_c_main.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "prr_i_main"

int StartingConditional()
{
    object oDM = GetPCSpeaker();
    int nReputation = GetLocalInt(oDM, PRR_DM_TOOL_REPUTATION);

    if ((PRR_SHIFT_MID + nReputation) > PRR_REPUTATION_MAX)
        return FALSE;

    SetCustomToken(PRR_TOKEN_DM_TOOL_REPUTATION_MID, IntToString(PRR_SHIFT_MID));
    return TRUE;
}

