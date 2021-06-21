/*
Filename:           pqj_i_main
System:             Persistent Quests and Journals (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 18, 2009
Summary:
Peristent Quests and Journals system primary include script. This file holds the
functions commonly used throughout the PQJ system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Core include script
#include "ss_i_core"

// PQJ configuration script
#include "pqj_i_plotids"

/******************************************************************************/
/*                                 Constants                                  */
/******************************************************************************/

const string PQJ_PREFIX = "PQJ_";


/******************************************************************************/
/*                            Function Prototypes                             */
/******************************************************************************/

// ---< pqj_GetQuestState >---
// ---< pqj_i_main >---
// Returns the state of oPC's quest sPlotID.
int pqj_GetQuestState(string sPlotID, object oPC);

// ---< pqj_AddJournalQuestEntry >---
// ---< pqj_i_main >---
// Stores oPC's quest entry for sPlotID at nState in the database.
// Optional Parameters:
// - bAllPartyMembers: if TRUE, adds the entry for everyone in oPC's party
// - bAllPlayers: if TRUE, adds the entry for everyone in the module
// - bAllowOverrideHigher: if TRUE, this adds the entry even if the PC is listed
//   in the database as having advanced the quest farther than this point.
// Note: If sPlotID is not a valid plotID, pqj_RebuildJournalQuestEntries will
// create blank entries in the player's journal. To avoid this, always use one
// of the journal entry constants in pqj_i_plotids instead of a string literal.
// When creating a quest that will be added via pqj_AddJournalQuestEntry, always
// make an entry for it in pqj_i_plotids.
void pqj_AddJournalQuestEntry(string sPlotID, int nState, object oPC, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE, int bAllowOverrideHigher=FALSE);

// ---< pqj_RemoveJournalQuestEntry >---
// ---< pqj_i_main >---
// Removess oPC's quest entry for sPlotID from the database.
// Optional Parameters:
// - bAllPartyMembers: if TRUE, removes the entry for everyone in oPC's party
// - bAllPlayers: if TRUE, removes the entry for everyone in the module
void pqj_RemoveJournalQuestEntry(string sPlotID, object oPC, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE);

// ---< pqj_RebuildJournalQuestEntries >---
// ---< pqj_i_main >---
// Rebuilds all of oPC's journal entries using those in the database. If oPC has
// advanced any quests and the change has not registered in the database, this
// will overwrite the advanced quests.
// Call this OnClientEnter.
void pqj_RebuildJournalQuestEntries(object oPC);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

// ---< pqj_GetQuestState >---
// ---< pqj_i_main >---
// Returns the state of oPC's quest sPlotID.
int pqj_GetQuestState(string sPlotID, object oPC)
{
    return ss_GetDatabaseInt(PQJ_PREFIX + sPlotID, oPC);
}

// ---< pqj_AddJournalQuestEntry >---
// ---< pqj_i_main >---
// Stores oPC's quest entry for sPlotID at nState in the database.
// Optional Parameters:
// - bAllPartyMembers: if TRUE, adds the entry for everyone in oPC's party
// - bAllPlayers: if TRUE, adds the entry for everyone in the module
// - bAllowOverrideHigher: if TRUE, this adds the entry even if the PC is listed
//   in the database as having advanced the quest farther than this point.
// Note: If sPlotID is not a valid plotID, pqj_RebuildJournalQuestEntries will
// create blank entries in the player's journal. To avoid this, always use one
// of the journal entry constants in pqj_i_plotids instead of a string literal.
// When creating a quest that will be added via pqj_AddJournalQuestEntry, always
// make an entry for it in pqj_i_plotids.
void pqj_AddJournalQuestEntry(string sPlotID, int nState, object oPC, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE, int bAllowOverrideHigher=FALSE)
{
    if (!GetIsPC(oPC))
        return;

    AddJournalQuestEntry(sPlotID, nState, oPC, bAllPartyMembers, bAllPlayers, bAllowOverrideHigher);
    string sVarName = PQJ_PREFIX + sPlotID;
    if (bAllPlayers)
    {
        oPC = GetFirstPC();
        while (GetIsObjectValid(oPC))
        {
            if (bAllowOverrideHigher)
                ss_SetDatabaseInt(sVarName, nState, oPC);
            else if (nState > ss_GetDatabaseInt(sVarName, oPC))
                ss_SetDatabaseInt(sVarName, nState, oPC);

            oPC = GetNextPC();
        }
    }
    else if (bAllPartyMembers)
    {
        object oPartyMember = GetFirstFactionMember(oPC, TRUE);
        while (GetIsObjectValid(oPartyMember))
        {
            if (bAllowOverrideHigher)
                ss_SetDatabaseInt(sVarName, nState, oPC);
            else if (nState > ss_GetDatabaseInt(sVarName, oPC))
                ss_SetDatabaseInt(sVarName, nState, oPC);

            oPartyMember = GetNextFactionMember(oPC, TRUE);
        }
    }
    else
    {
        if (bAllowOverrideHigher)
            ss_SetDatabaseInt(sVarName, nState, oPC);
        else if (nState > ss_GetDatabaseInt(sVarName, oPC))
            ss_SetDatabaseInt(sVarName, nState, oPC);
    }
}

// ---< pqj_RemoveJournalQuestEntry >---
// ---< pqj_i_main >---
// Removes oPC's quest entry for sPlotID from the database.
// Optional Parameters:
// - bAllPartyMembers: if TRUE, removes the entry for everyone in oPC's party
// - bAllPlayers: if TRUE, removes the entry for everyone in the module
void pqj_RemoveJournalQuestEntry(string sPlotID, object oPC, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE)
{
    string sVarName = PQJ_PREFIX + sPlotID;
    RemoveJournalQuestEntry(sPlotID, oPC, bAllPartyMembers, bAllPlayers);

    if(bAllPlayers)
    {
        oPC = GetFirstPC();
        while(GetIsObjectValid(oPC))
        {
            ss_DeleteDatabaseVariable(sVarName, oPC);
            oPC = GetNextPC();
        }
    }
    else if(bAllPartyMembers)
    {
        object oPartyMember = GetFirstFactionMember(oPC, TRUE);
        while (GetIsObjectValid(oPartyMember))
        {
            ss_DeleteDatabaseVariable(sVarName, oPC);
            oPartyMember = GetNextFactionMember(oPC, TRUE);
        }
    }
    else
        ss_DeleteDatabaseVariable(sVarName, oPC);
}

// ---< pqj_RebuildJournalQuestEntries >---
// ---< pqj_i_main >---
// Rebuilds all of oPC's journal entries using those in the database. If oPC has
// advanced any quests and the change has not registered in the database, this
// will overwrite the advanced quests.
// Call this OnClientEnter.
void pqj_RebuildJournalQuestEntries(object oPC)
{
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    string sSQL = "SELECT VarName, Value FROM pcdata WHERE VarName LIKE '"
                  + PQJ_PREFIX + "%' AND PCID='" + sPCID + "'";

    SQLExecDirect(sSQL);
    while(SQLFetch() == SQL_SUCCESS)
    {
        string sVarName = SQLGetData(1);
        string sState   = SQLGetData(2);
        int    nLength  = GetStringLength(sVarName);

        sVarName = GetStringRight(sVarName, nLength - 4);
        AddJournalQuestEntry(sVarName, StringToInt(sState), oPC, FALSE, FALSE, TRUE);
    }
}
