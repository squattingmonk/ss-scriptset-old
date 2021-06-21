/*
Filename:           ss_s_restmenu
System:             Core (rest dialog starting conditional script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 20, 2009
Summary:
Starting conditional script fired for each menu item node when the rest menu
dialog is opened.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ss_i_core"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nTokenIndex = GetLocalInt(oPC, SS_CURRENT_TOKEN_INDEX);
    string sMenuText = GetLocalString(oPC, SS_REST_MENU_ITEM_TEXT + IntToString(nTokenIndex));
    SetLocalInt(oPC, SS_CURRENT_TOKEN_INDEX, nTokenIndex + 1);
    if (sMenuText == "")
        return FALSE;
    SetCustomToken(SS_REST_MENU_TOKEN + nTokenIndex, sMenuText);
    return TRUE;
}

