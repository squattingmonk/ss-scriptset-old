/*
Filename:           prr_s_dmtpclistf
System:             Persistent Reputation & Reaction (prr_dmtool starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool starting conditional script listing the NPC's faction's reaction to
all PCs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "prr_i_main"

int StartingConditional()
{
    object oNPC = prr_GetFactionFocus(OBJECT_SELF);
    object oPC = GetFirstPC();
    string sList = "How my faction (" + prr_GetFaction(oNPC) + ") feels about each PC:";

    while (GetIsObjectValid(oPC))
    {
        sList += "\n" + GetName(oPC) + ": " +
                 IntToString(prr_GetExternalReputation(oNPC, oPC));
        oPC = GetNextPC();
    }

    SetCustomToken(PRR_TOKEN_DM_TOOL, sList);
    return TRUE;
}

