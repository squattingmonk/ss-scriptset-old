/*
Filename:           dlg_check_**
System:             Dynamic Dialog System (starting conditional)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       March 29, 2009
Summary:

Generic StartingConditional for the Dynamic Dialog System

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "dlg_i_tools"

const int DLG_CHECK_NUMBER = 10;

int StartingConditional()
{
    object oSpeaker = dlg_GetPCSpeaker();
    return(dlg_SetupDlgResponse(DLG_CHECK_NUMBER - 1, oSpeaker));
}
