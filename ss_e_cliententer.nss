/*
Filename:           ss_e_cliententer
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Dec. 11, 2008
Summary:
OnClientEnter event hook-in script. Place this script on the OnClientEnter event
under Module Properties.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Core system include script.
#include "ss_i_core"

void main()
{
    object oPC = GetEnteringObject();
    int bIsPC = GetIsPC(oPC);
    int bIsDM = GetIsDM(oPC);

    if (bIsPC || bIsDM)
    {
        if (GetStringLength(GetName(oPC)) > SS_MAX_PC_NAME_LENGTH)
        {
            SetLocalInt(oPC, SS_LOGIN_BOOT, TRUE);
            ss_BootPC(oPC, SS_TEXT_ERROR_PC_NAME_TOO_LONG);
            return;
        }

        // Add other checks here later

        ss_CreatePlayerDataItem(oPC);
        SendMessageToPC(oPC, SS_TEXT_ON_LOGIN_MESSAGE);
    }

    if (bIsPC)
    {
        int nPlayerCount = ss_GetGlobalInt(SS_PLAYER_COUNT);
        ss_SetGlobalInt(SS_PLAYER_COUNT, nPlayerCount + 1);
        ss_SetPCID(oPC);
        ss_InitializePC(oPC);
        ss_SetPCLoggedIn(oPC, TRUE);
    }

    ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_CLIENT_ENTER);
}
