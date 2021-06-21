/*
Filename:           prr_a_dmtpcnext
System:             Persistent Reputation & Reaction (prr_dmtool conversation action)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool action script that gets the next PC target.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "prr_i_main"

void main()
{
    object oDM = GetPCSpeaker();
    int nTarget = GetLocalInt(oDM, PRR_DM_TOOL_NEXT_TARGET);
    object oTarget = GetLocalObject(oDM, PRR_DM_TOOL_NEXT_TARGET);
    SetLocalInt(oDM, PRR_DM_TOOL_CURRENT_TARGET, nTarget);
    SetLocalObject(oDM, PRR_DM_TOOL_CURRENT_TARGET, oTarget);
}

