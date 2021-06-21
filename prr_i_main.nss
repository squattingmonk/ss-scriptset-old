/*
Filename:           prr_i_main
System:             Persistent Reputation and Reaction (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Nov. 2, 2007
Summary:
Persistent Reputation and Reaction primary include script. This file holds the
functions commonly used throughout the PRR system.

The scripts contained herein are based on those included in the Personal
Reputation and Reaction system by Vendalus, customized for compatibility with
Shadows & Silver's needs and database system. Thanks to Vendalus for his hard
work on these functions.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Generic include script
#include "g_i_generic"

// Persistent Reputation and Reaction configuration script
#include "prr_c_main"

// Persistent Reputation and Reaction constants definitions script
#include "prr_i_constants"

#include "nw_i0_plot"


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// Returns oPC's reputation with oNPC from the external database.
// Optional parameters:
// - sSourceTag: an alternate tag to associate with the NPC in the database (default "")
// - sTargetTag: an alternate tag to associate with the PC in the database (default "")
int prr_GetExternalReputation(object oNPC, object oPC, string sSourceTag = "", string sTargetTag = "");

// Sets oPC's reputation with oNPC in the external database to nAmount.
// Optional parameters:
// - sSourceTag: an alternate tag to associate with the NPC in the database (default "")
// - sTargetTag: an alternate tag to associate with the PC in the database (default "")
void prr_SetExternalReputation(object oNPC, object oPC, int nAmount, string sSourceTag = "", string sTargetTag = "");

// Adjusts oPC's reputation with oNPC in the external database by nChange.
// Optional parameters:
// - sSourceTag: an alternate tag to associate with the NPC in the database (default "")
// - sTargetTag: an alternate tag to associate with the PC in the database (default "")
void prr_AdjustExternalReputation(object oNPC, object oPC, int nChange, string sSourceTag = "", string sTargetTag = "");

// Adjusts each of oPC's party members' reputation with oNPC by nChange. Meant
// to be used for when the party completes a quest that would make the NPC feel
// different about every member of the party.
// Optional parameters:
// - sSourceTag: an alternate tag to associate with the NPC in the database (default "")
// - sTargetTag: an alternate tag to associate with the PC in the database (default "")
void prr_AdjustPartyExternalReputation(object oNPC, object oPC, int nChange, string sSourceTag = "", string sTargetTag = "");

// Returns all the modifiers to oNPC's reaction to oPC.
int prr_GetReactionModifiers(object oNPC, object oPC);

// Returns oNPC's reaction to oPC, adding nOther to the amount.
int prr_GetReaction(object oNPC, object oPC);

// Returns the appropriate greeting specified on oNPC based on his reaction to
// oPC, substituting the default if no custom greeting exists.
string prr_GetGreeting(object oNPC, object oPC);

// Returns the appropriate helpfulness text specified on oNPC based on his
// reaction to oPC, substituting the default if no custom text exists.
string prr_GetHelpfulness(object oNPC, object oPC);

// Returns TRUE if oPC succeeds on a check of nSkill vs nDC against oNPC.
// Optional parameters:
// - nOther: An extra value to add to oNPC's reaction to oPC (default 0).
// - bUseReaction: if you want oNPC's reaction to affect nDC (default TRUE).
int prr_SkillCheck(object oNPC, object oPC, int nSkill, int nDC, int bUseReaction = PRR_USE_REACTIONS_IN_SKILL_ROLLS);

// Returns the faction focus of the same faction as oObject.
object prr_GetFactionFocus(object oObject);

// Returns the faction name of oObject. If oObject is invalid it returns "".
string prr_GetFaction(object oObject);

// Adjusts how oSourceFactionMember's faction feels about oTarget by nChange.
// To change a faction's reputation, use prr_AdjustFactionReputation instead.
void prr_AdjustReputation(object oSourceFactionMember, object oTarget, int nChange);

// Adjusts the reputations of members of oTarget's faction with
// oSourceFactionMember's faction. Useful for changing a whole party's
// reputation with a faction.
// To change one PC's reputation with a faction, use prr_AdjustReputation.
void prr_AdjustFactionReputation(object oSourceFactionMember, object oTarget, int nChange);

// Returns whether oTarget's reputation with oSourceFactionMember is initialized.
int prr_GetIsReputationInitialized(object oTarget, object oSourceFactionMember);

// Initializes the reputation of oTarget to oSourceFactionMember.
void prr_InitializeReputation(object oTarget, object oSourceFactionMember);

// Loads all inter-faction reputation changes from the database and initializes
// any new factions.
void prr_LoadFactionReputations();

// Loads all oPC's faction reputation changes from the database and initializes
// his reputation with any new factions.
void prr_LoadPCReputations(object oPC);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

int prr_GetExternalReputation(object oNPC, object oPC, string sSourceTag = "", string sTargetTag = "")
{
    if (sSourceTag != "")
        sSourceTag = "_" + sSourceTag;

    if (sTargetTag != "")
        sTargetTag = "_" + sTargetTag;

    return ss_GetDatabaseInt(PRR_REPUTATION_PREFIX + GetTag(oNPC) + sSourceTag + sTargetTag, oPC);
}

void prr_SetExternalReputation(object oNPC, object oPC, int nAmount, string sSourceTag = "", string sTargetTag = "")
{
    if (sSourceTag != "")
        sSourceTag = "_" + sSourceTag;

    if (sTargetTag != "")
        sTargetTag = "_" + sTargetTag;

    ss_SetDatabaseInt(PRR_REPUTATION_PREFIX + GetTag(oNPC) + sSourceTag + sTargetTag, nAmount, oPC);
}

void prr_AdjustExternalReputation(object oNPC, object oPC, int nChange, string sSourceTag = "", string sTargetTag = "")
{
    int nAmount = prr_GetExternalReputation(oNPC, oPC) + nChange;

    if (nAmount > PRR_REPUTATION_MAX)
        nAmount = PRR_REPUTATION_MAX;
    else if (nAmount < PRR_REPUTATION_MIN)
        nAmount = PRR_REPUTATION_MIN;

    prr_SetExternalReputation(oNPC, oPC, nAmount, sSourceTag, sTargetTag);
}

void prr_AdjustPartyExternalReputation(object oNPC, object oPC, int nChange, string sSourceTag = "", string sTargetTag = "")
{
    object oPartyMember = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oPartyMember))
    {
        prr_AdjustExternalReputation(oNPC, oPartyMember, nChange, sSourceTag, sTargetTag);
        oPartyMember = GetNextFactionMember(oPC);
    }
}

int prr_GetReactionModifiers(object oNPC, object oPC)
{
    int nModifier;

    if (PRR_USE_CHARISMA_MODIFIER)
    {
        int nCharisma = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        nModifier += nCharisma * PRR_CHARISMA_MODIFIER_TO_REACTION;
    }

    // Insert other modifiers here

    return nModifier;
}

int prr_GetReaction(object oNPC, object oPC)
{
    int nReputation = GetReputation(oNPC, oPC) + prr_GetExternalReputation(oNPC, oPC);
    int nModifiers  = prr_GetReactionModifiers(oNPC, oPC);
    return nReputation + nModifiers;
}

string prr_GetGreeting(object oNPC, object oPC)
{
    string sGreeting;
    int nReaction = prr_GetReaction(oNPC, oPC);

    if(nReaction >= PRR_REACTION_HIGH)
    {
        sGreeting = GetLocalString(oNPC, PRR_GREETING_HIGH);
        if (sGreeting == "")
            sGreeting = PRR_GREETING_DEFAULT_HIGH;
    }
    else if(nReaction >= PRR_REACTION_MID)
    {
        sGreeting = GetLocalString(oNPC, PRR_GREETING_MID);
        if (sGreeting == "")
            sGreeting = PRR_GREETING_DEFAULT_MID;
    }
    else if(nReaction >= PRR_REACTION_LOW)
    {
        sGreeting = GetLocalString(oNPC, PRR_GREETING_LOW);
        if (sGreeting == "")
            sGreeting = PRR_GREETING_DEFAULT_LOW;
    }
    else
    {
        sGreeting = GetLocalString(oNPC, PRR_GREETING);
        if (sGreeting == "")
            sGreeting = PRR_GREETING_DEFAULT;
    }

    return sGreeting;
}

string prr_GetHelpfulness(object oNPC, object oPC)
{
    string sHelpfulness;
    int nReaction = prr_GetReaction(oNPC, oPC);

    if(nReaction >= PRR_REACTION_HIGH)
    {
        sHelpfulness = GetLocalString(oNPC, PRR_HELPFULNESS_HIGH);
        if (sHelpfulness == "")
            sHelpfulness = PRR_HELPFULNESS_DEFAULT_HIGH;
    }
    else if(nReaction >= PRR_REACTION_MID)
    {
        sHelpfulness = GetLocalString(oNPC, PRR_HELPFULNESS_MID);
        if (sHelpfulness == "")
            sHelpfulness = PRR_HELPFULNESS_DEFAULT_MID;
    }
    else if(nReaction >= PRR_REACTION_LOW)
    {
        sHelpfulness = GetLocalString(oNPC, PRR_HELPFULNESS_LOW);
        if (sHelpfulness == "")
            sHelpfulness = PRR_HELPFULNESS_DEFAULT_LOW;
    }
    else
    {
        sHelpfulness = GetLocalString(oNPC, PRR_HELPFULNESS);
        if (sHelpfulness == "")
            sHelpfulness = PRR_HELPFULNESS_DEFAULT;
    }

    return sHelpfulness;
}

int prr_SkillCheck(object oNPC, object oPC, int nSkill, int nDC, int bUseReaction = PRR_USE_REACTIONS_IN_SKILL_ROLLS)
{
    if (bUseReaction)
        nDC = nDC + (prr_GetReaction(oNPC, oPC) - 50) / 2;

    int nCheck = ss_SkillCheck(nSkill, oPC, 0);

    return nCheck >= nDC;
}

// Begin faction functions
object prr_GetFactionFocus(object oObject)
{
    int nIndex;
    object oFactionFocus = GetObjectByTag(PRR_FACTION_FOCUS, nIndex);
    while (GetIsObjectValid(oFactionFocus))
    {
        if (GetFactionEqual(oFactionFocus, oObject))
            return oFactionFocus;

        nIndex++;
        oFactionFocus = GetObjectByTag(PRR_FACTION_FOCUS, nIndex);
    }
    return OBJECT_INVALID;
}

string prr_GetFaction(object oObject)
{
    if (!GetIsObjectValid(oObject))
        return "";

    if (GetTag(oObject) == PRR_FACTION_FOCUS)
        return GetLocalString(oObject, PRR_FACTION);

    oObject = prr_GetFactionFocus(oObject);
    return GetLocalString(oObject, PRR_FACTION);
}

void prr_AdjustReputation(object oSourceFactionMember, object oTarget, int nChange)
{
    if (GetIsPC(oSourceFactionMember))
        return;

    AdjustReputation(oTarget, oSourceFactionMember, nChange);
    prr_AdjustExternalReputation(oSourceFactionMember, oTarget, nChange);
}

void prr_AdjustFactionReputation(object oSourceFactionMember, object oTarget, int nChange)
{
    if(GetIsPC(oSourceFactionMember))
        return;

    if(GetIsPC(oTarget))
    {
        oTarget = GetFirstFactionMember(oTarget);
        while(GetIsObjectValid(oTarget))
        {
            prr_AdjustReputation(oSourceFactionMember, oTarget, nChange);
            oTarget = GetNextFactionMember(oTarget);
        }
    }
    else
    {
        AdjustFactionReputation(oTarget, oSourceFactionMember, nChange);
        prr_AdjustExternalReputation(oSourceFactionMember, oTarget, nChange, prr_GetFaction(oSourceFactionMember), prr_GetFaction(oTarget));
    }
}

int prr_GetIsReputationInitialized(object oTarget, object oSourceFactionMember)
{
    if (GetFactionEqual(oTarget, oSourceFactionMember))
        return TRUE;

    string sFaction = prr_GetFaction(oSourceFactionMember);
    string sFaction2 = prr_GetFaction(oTarget);

    if (ss_GetDatabaseInt(PRR_REPUTATION_INIT_PREFIX + sFaction + "_" + sFaction2))
        return TRUE;
    else
        return ss_GetDatabaseInt(PRR_REPUTATION_INIT_PREFIX + sFaction2 + "_" + sFaction);
}

void prr_InitializeReputation(object oTarget, object oSourceFactionMember)
{
    if (GetFactionEqual(oTarget, oSourceFactionMember))
        return;

    int    nAmount   = GetReputation(oSourceFactionMember, oTarget);
    string sFaction  = prr_GetFaction(oSourceFactionMember);
    string sFaction2 = prr_GetFaction(oTarget);
    prr_SetExternalReputation(oSourceFactionMember, oTarget, nAmount, sFaction, sFaction2);
    ss_SetDatabaseInt(PRR_REPUTATION_INIT_PREFIX + sFaction + "_" + sFaction2, 1);
    ss_SetDatabaseInt(PRR_REPUTATION_INIT_PREFIX + sFaction2 + "_" + sFaction, 1);
}

void prr_LoadFactionReputations()
{
    object oTargetFocus = GetObjectByTag(PRR_FACTION_FOCUS);
    object oSourceFocus;
    string sTargetFaction;
    string sSourceFaction;
    int    nCurrentRep;
    int    nStoredRep;
    int    nChange;
    int    nIndex;
    int    nIndex2;

    while(GetIsObjectValid(oTargetFocus))
    {
        nIndex2 = 0;
        sTargetFaction = prr_GetFaction(oTargetFocus);
        oSourceFocus   = GetObjectByTag(PRR_FACTION_FOCUS);
        while(GetIsObjectValid(oSourceFocus))
        {
            if(!GetFactionEqual(oTargetFocus, oSourceFocus))
            {
                if(prr_GetIsReputationInitialized(oTargetFocus, oSourceFocus))
                {
                    sSourceFaction = prr_GetFaction(oSourceFocus);
                    nCurrentRep = GetReputation(oSourceFocus, oTargetFocus);
                    nStoredRep = prr_GetExternalReputation(oSourceFocus, oTargetFocus, sSourceFaction, sTargetFaction);
                    nChange = nStoredRep - nCurrentRep;
                    AdjustReputation(oTargetFocus, oSourceFocus, nChange);
                }
                else
                    prr_InitializeReputation(oTargetFocus, oSourceFocus);
            }
            nIndex2++;
            oSourceFocus = GetObjectByTag(PRR_FACTION_FOCUS, nIndex2);
        }
        nIndex++;
        oTargetFocus = GetObjectByTag(PRR_FACTION_FOCUS, nIndex);
    }
}

void prr_LoadPCReputations(object oPC)
{
    object oSourceFocus = GetObjectByTag(PRR_FACTION_FOCUS);
    int    nCurrentRep;
    int    nStoredRep;
    int    nChange;
    int    nIndex;
    string sFaction;

    while(GetIsObjectValid(oSourceFocus))
    {
        if(prr_GetIsReputationInitialized(oPC, oSourceFocus))
        {
            sFaction = prr_GetFaction(oSourceFocus);
            nCurrentRep = GetReputation(oSourceFocus, oPC);
            nStoredRep = prr_GetExternalReputation(oSourceFocus, oPC, sFaction);
            nChange = nStoredRep - nCurrentRep;
            AdjustReputation(oPC, oSourceFocus, nChange);
        }
        else
            prr_InitializeReputation(oPC, oSourceFocus);

        nIndex++;
        oSourceFocus = GetObjectByTag(PRR_FACTION_FOCUS, nIndex);
    }
}
// End faction functions

// Begin DM Tool functions
int prr_DMToolMenuText()
{
    return TRUE;
}

int prr_DMToolMenuItem(int nItemNumber)
{
    return TRUE;
}

// End DM Tool functions

// void main(){}
