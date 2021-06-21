/*
Filename:           prr_s_dmtflist2
System:             Persistent Reputation & Reaction (prr_dmtool starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool starting conditional script listing the other factions' reaction to
the  NPC's faction.

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
    string sList = "How other factions feel about my faction (" + prr_GetFaction(oNPC) + "):";

    while (GetIsObjectValid(oFocus))
    {
        if (oFocus != oNPC)
            sList += "\n" + prr_GetFaction(oFocus) + ": " + IntToString(prr_GetExternalReputation(oFocus, oNPC));

        nIndex++;
        oFocus = GetObjectByTag(PRR_FACTION_FOCUS, nIndex);
    }

    SetCustomToken(PRR_TOKEN_DM_TOOL, sList);
    return TRUE;
}

