/*
Filename:           ss_e_rest
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnPlayerRest event hook-in script. Place this script on the OnPlayerRest event
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
    object oPC = GetLastPCRested();

    if (SS_EXPORT_CHARACTERS_INTERVAL > 0.0)
        ExportSingleCharacter(oPC);

    int i;
    int bSkipDialog;
    int bMenuOptionsAvailable;
    int nRestEventType = GetLastRestEventType();
    switch (nRestEventType)
    {
        case REST_EVENTTYPE_REST_STARTED:
            ss_SetAllowRest(oPC, TRUE);
            ss_SetAllowSpellRecovery(oPC, TRUE);
            ss_SetAllowFeatRecovery(oPC, TRUE);
            ss_SetPostRestHealAmount(oPC, GetMaxHitPoints(oPC));
            DeleteLocalInt(oPC, SS_REST_MENU_INDEX);
            for (i = 1; i <= 5; i++) //Wipe out existing Rest Menu options
            {
                DeleteLocalString(oPC, SS_REST_MENU_ITEM_TEXT + IntToString(i));
                DeleteLocalString(oPC, SS_REST_MENU_ACTION_SCRIPT + IntToString(i));
            }
            ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_PLAYER_REST_STARTED);

            bMenuOptionsAvailable = GetLocalInt(oPC, SS_REST_MENU_INDEX);
            bSkipDialog = GetLocalInt(oPC, SS_SKIP_REST_DIALOG);
            if (!bMenuOptionsAvailable)
            {
                if (ss_GetAllowRest(oPC) && !bSkipDialog)
                {
                    ss_AddRestMenuItem(oPC, SS_TEXT_REST_MENU_DEFAULT);
                    ss_OpenRestDialog(oPC);
                }
                else
                {
                    SetLocalInt(oPC, SS_SKIP_CANCEL_REST, TRUE);
                    AssignCommand(oPC, ClearAllActions());
                    SendMessageToPC(oPC, SS_TEXT_REST_NOT_ALLOWED_HERE);
                }
            }
            else if (!bSkipDialog)
                ss_OpenRestDialog(oPC);

            DeleteLocalInt(oPC, SS_SKIP_REST_DIALOG);
            break;
        case REST_EVENTTYPE_REST_CANCELLED:
            if (!GetLocalInt(oPC, SS_SKIP_CANCEL_REST))
                ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_PLAYER_REST_CANCELLED);
            DeleteLocalInt(oPC, SS_SKIP_CANCEL_REST);
            break;
        case REST_EVENTTYPE_REST_FINISHED:
            ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_PLAYER_REST_FINISHED);
            break;
    }
}
