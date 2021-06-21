/*
Filename:           ss_s_pcmenuroot
System:             Core (ss_pcmenu root starting conditional)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 20th, 2009
Summary:
Starting conditional script fired for the root node when the player menu
conversation is opened.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "ss_i_core"

int StartingConditional()
{
    SetCustomToken(SS_PLAYER_MENU_TOKEN, SS_TEXT_PLAYER_MENU_ROOT_NODE);
    SetCustomToken(SS_PLAYER_MENU_TOKEN - 1, SS_TEXT_PLAYER_MENU_CANCEL);
    SetLocalInt(GetPCSpeaker(), SS_CURRENT_TOKEN_INDEX, 1);
    return TRUE;
}

