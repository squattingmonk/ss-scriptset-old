/*
Filename:           pqj_cliententer
System:             Persistent Quests and Journals (client enter event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Apr. 29, 2008
Summary:
OnClientEnter script for the PQJ system. This script will rebuild the player's
journal entries from the database when he logs in.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// PQJ system include script.
#include "pqj_i_main"

void main()
{
    object oPC = GetEnteringObject();
    if (GetIsPC(oPC))
    {
        pqj_RebuildJournalQuestEntries(oPC);
        // Add startup journal entries here, e.g.:
        // pqj_AddJournalQuestEntry(PQJ_PLOTID_TEST, 1, oPC, FALSE);
    }
}
