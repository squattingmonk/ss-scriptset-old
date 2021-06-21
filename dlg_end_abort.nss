/*
Filename:           dlg_end_abort
System:             Dynamic Dialog System (Hook-in script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:

Abort conversation event script

// Original filename under Z-Dialog: zdlg_end_abort
// Copyright (c) 2004 Paul Speed - BSD licensed.
//  NWN Tools - http://nwntools.sf.net/
//
// Additions and changes from original copyright (c) 2005-2006 Greyhawk0

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "dlg_i_tools"

void main()
{
    object oSpeaker = dlg_GetPCSpeaker();
    dlg_SendEvent( oSpeaker, DLG_EVENT_ABORT );
    dlg_CleanupDlg( oSpeaker );
}
