/*
Filename:           prr_s_dmtpc
System:             Persistent Reputation & Reaction (prr_dmtool starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool starting conditional script that tells how the NPC feels about the
PC target.

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
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, PRR_DM_TOOL_CURRENT_TARGET);
    if (!GetIsObjectValid(oPC))
    {
        oPC = GetFirstPC();
        while (GetIsDM(oPC))
            oPC = GetNextPC();

        if (!GetIsObjectValid(oPC))
        {
            DeleteLocalObject(oDM, PRR_DM_TOOL_CURRENT_TARGET);
            return FALSE;
        }

        SetLocalObject(oDM, PRR_DM_TOOL_CURRENT_TARGET, oPC);
    }

    int nReputation = prr_GetExternalReputation(oNPC, oPC) + GetReputation(oNPC, oPC);
    string sMessage = "How I feel about " + GetName(oPC) + ": " + IntToString(nReputation);

    SetLocalInt(oDM, PRR_DM_TOOL_REPUTATION, nReputation);
    SetCustomToken(PRR_TOKEN_DM_TOOL, sMessage);
    return TRUE;
}

