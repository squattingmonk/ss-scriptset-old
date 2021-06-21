/*
Filename:           prr_s_dmtpcprev
System:             Persistent Reputation & Reaction (prr_dmtool starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool starting conditional script that checks for a previous PC target.

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
    int nTarget = GetLocalInt(oDM, PRR_DM_TOOL_CURRENT_TARGET);
    object oPrevious = ss_GetPC(nTarget - 1);

    if (GetIsObjectValid(oPrevious))
    {
        SetLocalInt(oDM, PRR_DM_TOOL_PREVIOUS_TARGET, nTarget - 1);
        SetLocalObject(oDM, PRR_DM_TOOL_PREVIOUS_TARGET, oPrevious);
        return TRUE;
    }

    DeleteLocalInt(oDM, PRR_DM_TOOL_PREVIOUS_TARGET);
    DeleteLocalObject(oDM, PRR_DM_TOOL_PREVIOUS_TARGET);
    return FALSE;
}
