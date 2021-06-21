/*
Filename:           dlg_a_action_**
System:             Dynamic Dialog System (include script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       March 29, 2009
Summary:


Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "dlg_i_tools"

const int DLG_ACTION_NUMBER = 13;

void main()
{
    dlg_DoSelection(dlg_GetPCSpeaker(), DLG_ACTION_NUMBER - 1 );
}
