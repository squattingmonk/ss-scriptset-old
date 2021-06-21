/*
Filename:           ss_s_restroot
System:             Core (rest dialog starting conditional script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 20, 2009
Summary:
This is attached the starting conditional for the ss_restmenu dialog. It is run
on the first node and always returns TRUE. It sets some custom tokens to their
default value which represent the text to be displayed on the root dialog and on
the last "Cancel" option. It also initilizes the token index counter to 1.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "ss_i_core"

int StartingConditional()
{
    SetCustomToken(SS_REST_MENU_TOKEN, SS_TEXT_REST_MENU_ROOT_NODE);
    SetCustomToken(SS_REST_MENU_TOKEN - 1, SS_TEXT_REST_MENU_CANCEL);
    SetLocalInt(GetPCSpeaker(), SS_CURRENT_TOKEN_INDEX, 1);
    return TRUE;
}

