/*
Filename:           prr_s_dmtflist1
System:             Persistent Reputation & Reaction (prr_dmtool starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool starting conditional script listing the NPC's faction's reaction to
other factions.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "prr_i_main"

int StartingConditional()
{
    int nIndex;
    object oNPC = prr_GetFactionFocus(OBJECT_SELF);
    object oFocus = GetObjectByTag(PRR_FACTION_FOCUS, nIndex);
    string sList = "How my faction (" + prr_GetFaction(oNPC) + ") feels about other factions:";

    while (GetIsObjectValid(oFocus))
    {
        if (oFocus != oNPC)
            sList += "\n" + prr_GetFaction(oFocus) + ": " + IntToString(prr_GetExternalReputation(oNPC, oFocus));

        nIndex++;
        oFocus = GetObjectByTag(PRR_FACTION_FOCUS, nIndex);
    }

    SetCustomToken(PRR_TOKEN_DM_TOOL, sList);
    return TRUE;
}

