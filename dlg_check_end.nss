/*
Filename:           dlg_check_end
System:             Dynamic Dialog System (Hook-in script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:

This is the End Dialog option for the final farewell.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "dlg_i_tools"

int StartingConditional()
{
    object oSpeaker = dlg_GetPCSpeaker();

    string sPageName = GetLocalString( oSpeaker, DLG_PAGE_NAME );
    if (sPageName=="") return ( TRUE );

    return ( FALSE );
}
