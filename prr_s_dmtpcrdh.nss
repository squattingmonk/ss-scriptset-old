/*
Filename:           prr_s_dmtpcrdh
System:             Persistent Reputation & Reaction (prr_dmtool starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool starting conditional script that determines whether the PC's
reputation with the NPC can be adjusted by the high amount set in prr_c_main.

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

    if ((nReputation - PRR_SHIFT_HIGH) < PRR_REPUTATION_MIN)
        return FALSE;

    SetCustomToken(PRR_TOKEN_DM_TOOL_REPUTATION_HIGH, IntToString(PRR_SHIFT_HIGH));
    return TRUE;
}

