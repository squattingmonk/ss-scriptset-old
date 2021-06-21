/*
Filename:           prr_s_dmtpcnext
System:             Persistent Reputation & Reaction (prr_dmtool starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool starting conditional script that checks for another NPC target.

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
    object oNext = ss_GetPC(nTarget + 1);

    if (GetIsObjectValid(oNext))
    {
        SetLocalInt(oDM, PRR_DM_TOOL_NEXT_TARGET, nTarget + 1);
        SetLocalObject(oDM, PRR_DM_TOOL_NEXT_TARGET, oNext);
        return TRUE;
    }

    DeleteLocalInt(oDM, PRR_DM_TOOL_NEXT_TARGET);
    DeleteLocalObject(oDM, PRR_DM_TOOL_NEXT_TARGET);
    return FALSE;
}

