/*
Filename:           prr_s_dmtpclist
System:             Persistent Reputation & Reaction (prr_dmtool starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool starting conditional script listing the NPC's reaction to all PCs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "prr_i_main"

int StartingConditional()
{
    string sList = "How each I feel about each PC:";
    object oNPC = OBJECT_SELF;
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        sList += "\n" + GetName(oPC) + ": " +
                    IntToString(prr_GetExternalReputation(oNPC, oPC) +
                    GetReputation(oNPC, oPC));
        oPC = GetNextPC();
    }

    SetCustomToken(PRR_TOKEN_DM_TOOL, sList);
    return TRUE;
}

