/*
Filename:           dlg_check_init
System:             Dynamic Dialog System (Hook-in script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:


// Original filename under Z-Dialog: zdlg_check_init
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

int StartingConditional()
{
    object oSpeaker = dlg_GetPCSpeaker();

    // Check to see if the conversation is done.
    int iState = GetLocalInt( oSpeaker, DLG_STATE );

    // This code is to show a final farewell, and have an "End Dialog" option like the normal conversations.
    if ( iState == DLG_STATE_ENDED )
    {
        string sFarewellMessage = GetLocalString( oSpeaker, DLG_FAREWELL );
        if (sFarewellMessage=="") return ( FALSE ); // Normal behavior.

        // This sets everything up for the final farewell and end dialog.
        SetLocalString( oSpeaker, DLG_PROMPT, sFarewellMessage );
        SetLocalString( oSpeaker, DLG_PAGE_NAME, "" );
        SetLocalString( oSpeaker, DLG_RESPONSE_LIST, "" );
        SetLocalInt( oSpeaker, DLG_HAS_END, FALSE );
        SetLocalInt( oSpeaker, DLG_HAS_RESET, FALSE );
    }

    // Initialize the page and possibly the entire conversation
    if ( iState != DLG_STATE_ENDED )
    {
        dlg_InitializePage( oSpeaker );
    }

    // Just for continue chains.
    dlg_SetupContinueChainedPrompt( oSpeaker );

    // Initialize the values from the dialog configuration
    SetCustomToken(DLG_BASE_TOKEN, GetLocalString(oSpeaker, DLG_PROMPT));

    return TRUE;
}
