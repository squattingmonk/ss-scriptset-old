/*
Filename:           dlg_i_tools
System:             Dynamic Dialog System (include script)
Author:             Greyhawk0 and pspeed
Date Created:       Unknown
Summary:

The scripts contained herein are based on those included in pspeed's Z-Dialog
and Greyhawk0's ZZ-Dialog, customized for compatibility with Shadows & Silver's needs.

 Original filename under Z-Dialog: zdlg_include_i
 Copyright (c) 2004 Paul Speed - BSD licensed.
 NWN Tools - http://nwntools.sf.net/

 Additions and changes from original copyright (c) 2005-2006 Greyhawk0


Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "ss_i_lists"
#include "g_i_generic"
#include "dlg_i_constants"



// SOURCE FILE CONVENTIONS - START
//
// "oThis" - The object (NPC, item, or placeable) that is being talked to by a
//      player's character ("oThis"). Should always be OBJECT_SELF within _this_
//      file and a dialog script file. Items are exceptioned.
//
// "oSpeaker" - The player's character who is talking to the current object
//      ("oThis"). Always use "GetPcDlgSpeaker()" to get the PC if not already
//      provided (and provide it to others as often as possible!).
//
// SOURCE FILE CONVENTIONS - END







////////////////////////////
// ********************** \\
//  Functions Prototypes  \\
// ********************** \\
////////////////////////////





// >----< dlg_IsTalkable >----<
// <dlg_i_tools>
// Returns TRUE if oThis can be talked to.
int dlg_IsTalkable(object oThis = OBJECT_SELF);

// >----< dlg_Start >----<
// <dlg_i_tools>
// Called to initiate a conversation programmatically between the dialog source
//      and the object to converse with.
//
// oSpeaker - This is the player's character that is starting a conversation.
//      This is important because we want the ability for many players to talk
//      to the same object.
// oThis - This is the object (NPC, item or placeable) that the player's
//      character is attempting to speak to.
// sDlgScript - This is the script file to use for the conversation. If left as
//      "" (the default), it will read the object's "dialog" parameter to
//      determine which script file to use.
// iMakePrivate - TRUE == don't let others hear the conversation.
//                FALSE == let other hear the conversation. (Default)
// iNoHello - TRUE == don't play the hello.
//            FALSE == play the hello. (Default)
// iNoZoom - TRUE == don't zoom in.
//         FALSE == zoom in towards the character during conversation. (Default)
void dlg_Start(object oSpeaker, object oThis = OBJECT_SELF, string sDlgScript = "", int iMakePrivate = 0, int iNoHello = 0, int iNoZoom = 0);

// >----< dlg_GetPCSpeaker >----<
// <dlg_i_tools>
// Returns the current PC speaker for this dialog.
// This has some enhanced features to work around bioware limitations with item dialogs.
object dlg_GetPCSpeaker();

// >----< dlg_GetObjSpeakee >----<
// <dlg_i_tools>
// Returns the current PC speakee for this dialog.
object dlg_GetObjSpeakee(object oSpeaker);

// >----< dlg_GetResponse >----<
// <dlg_i_tools>
// Returns the response string for the specified entry.
string dlg_GetResponse(object oSpeaker, int iIndex);

// >----< dlg_GetDlgResponseCount >----<
// <dlg_i_tools>
// Returns the number of responses that will be displayed
// in the dialog when talking to the specified speaker.
int dlg_GetDlgResponseCount(object oSpeaker);


// >----< dlg_GetType >----<
// <dlg_i_tools>
// Gets the type, "Next", "Previous", "Reset", or "End". (DLG_TYPE_*)
int dlg_GetType(object oSpeaker, int iResponseIndex, int iMaxResponses, int iFirstResponseIndex, int iResponseCount);

// >----< dlg_SendEvent >----<
// <dlg_i_tools>
// Sends the specified dialog event to the specified NPC using the current script handler.
// The selection parameter is used for select events.
// The speaker is provided for event specific paramaters to be stored onto.
void dlg_SendEvent(object oSpeaker, int iEventType, int iSelection = -1, object oThis = OBJECT_SELF);

// >----< dlg_SetupContinueChainedPrompt >----<
// <dlg_i_tools>
// Gets the next prompt in the continue chain setup.
void dlg_SetupContinueChainedPrompt(object oSpeaker);

// >----< dlg_SetupDlgResponse >----<
// <dlg_i_tools>
// Sets the token for the response string and returns true if there is a valid
// response entry for the specified num (ie. populates responses once piece at a time)
int dlg_SetupDlgResponse(int nResponseIndex, object oSpeaker);

// >----< dlg_CleanupDlg >----<
// <dlg_i_tools>
// Called to clean-up the current conversation related resources.
void dlg_CleanupDlg(object oSpeaker);

// >----< dlg_DoSelection >----<
// <dlg_i_tools>
// On Selection event. Check if we need to handle an automated response first,
//      but if not then pass it to the dialog script.
void dlg_DoSelection(object oSpeaker, int iSelection, object oThis = OBJECT_SELF);

// >----< dlg_InitializePage >----<
// <dlg_i_tools>
// Called by the dialog internals to initialize the page and possibly the conversation.
void dlg_InitializePage(object oSpeaker, object oThis = OBJECT_SELF);














////////////////////////////////
// ************************** \\
//  Functions Implementation  \\
// ************************** \\
////////////////////////////////








// >----< dlg_IsTalkable >----<
// <dlg_i_tools>
// Returns TRUE if oThis can be talked to.
int dlg_IsTalkable(object oThis = OBJECT_SELF)
{
    int iType = GetObjectType(oThis);

    if (iType == OBJECT_TYPE_CREATURE || iType == OBJECT_TYPE_PLACEABLE) return TRUE;
    if (GetLocalInt(OBJECT_SELF, DLG_GHOST)==TRUE) return TRUE;
    return FALSE;
}



// >----< dlg_Start >----<
// <dlg_i_tools>
// Called to initiate a conversation programmatically between the dialog source
//      and the object to converse with.
//
// oSpeaker - This is the player's character that is starting a conversation.
//      This is important because we want the ability for many players to talk
//      to the same object.
// oThis - This is the object (NPC, item or placeable) that the player's
//      character is attempting to speak to.
// sDlgScript - This is the script file to use for the conversation. If left as
//      "" (the default), it will read the object's "dialog" parameter to
//      determine which script file to use.
// iMakePrivate - TRUE == don't let others hear the conversation.
//                FALSE == let other hear the conversation. (Default)
// iNoHello - TRUE == don't play the hello.
//            FALSE == play the hello. (Default)
// iNoZoom - TRUE == don't zoom in.
//         FALSE == zoom in towards the character during conversation. (Default)
void dlg_Start(object oSpeaker, object oThis = OBJECT_SELF, string sDlgScript = "", int iMakePrivate = 0, int iNoHello = 0, int iNoZoom = 0)
{
    // Setup the conversation
    if(sDlgScript != "")
        SetLocalString(oSpeaker, DLG_CURRENT_SCRIPT, sDlgScript);



    string sDialogResRef = DLG_CONVERSATION;
    if(iNoZoom == 1) sDialogResRef = DLG_CONVERSATION_NO_ZOOM;

    // Objects that can't talk to the player, need the player to talk to him/herself.
    if(dlg_IsTalkable(oThis) == FALSE)
    {
        // We presume that only one player can talk to an item at a time...
        SetLocalObject(oThis, DLG_OBJECT_CONVERSER, oSpeaker);

        // We can't actually talk to items so we fudge it.
        SetLocalObject(oSpeaker, DLG_ITEM, oThis);
        oThis = oSpeaker;

        // Must tell the PC to talk to him/herself.
        AssignCommand(oSpeaker, ActionStartConversation(oSpeaker, sDialogResRef, iMakePrivate, !iNoHello));
        return;
    }

    AssignCommand(oSpeaker, ActionStartConversation(oThis, sDialogResRef, iMakePrivate, !iNoHello));
}

// >----< dlg_GetPCSpeaker >----<
// <dlg_i_tools>
// Returns the current PC speaker for this dialog.
// This has some enhanced features to work around bioware limitations with item dialogs.
object dlg_GetPCSpeaker()
{
    object oPC = GetPCSpeaker();
    if(oPC == OBJECT_INVALID)
    {
        // See if we're an item and if we're connected to a PC already.
        // Note: GetItemActivator won't work in multiplayer because other
        //       players will be trouncing on its state.
        oPC = GetLocalObject(OBJECT_SELF, DLG_OBJECT_CONVERSER);
    }
    if(oPC == OBJECT_INVALID)
    {
        ss_SendMessageToTeam(DLG_ERROR_NO_PC_SPEAKER, COLOR_BUG);
    }
    return (oPC);
}

// >----< dlg_GetObjSpeakee >----<
// <dlg_i_tools>
// Returns the current PC speakee for this dialog.
object dlg_GetObjSpeakee(object oSpeaker)
{
    object oSpeakee = GetLocalObject(oSpeaker, DLG_ITEM);
    if (oSpeakee == OBJECT_INVALID) oSpeakee = OBJECT_SELF;

    return (oSpeakee);
}

// >----< dlg_GetResponse >----<
// <dlg_i_tools>
// Returns the response string for the specified entry.
string dlg_GetResponse(object oSpeaker, int iIndex)
{
    string sList = GetLocalString(oSpeaker, DLG_RESPONSE_LIST);
    return (ss_GetStringElement(iIndex, sList, oSpeaker));
}

// >----< dlg_GetDlgResponseCount >----<
// <dlg_i_tools>
// Returns the number of responses that will be displayed
// in the dialog when talking to the specified speaker.
int dlg_GetDlgResponseCount( object oSpeaker )
{
    string sList = GetLocalString(oSpeaker, DLG_RESPONSE_LIST);
    return (ss_GetElementCount(sList, oSpeaker));
}


// >----< dlg_GetType >----<
// <dlg_i_tools>
// Gets the type, "Next", "Previous", "Reset", or "End". (DLG_TYPE_*)
int dlg_GetType(object oSpeaker, int iResponseIndex, int iMaxResponses, int iFirstResponseIndex, int iResponseCount)
{
    int iRemainingResponses = iResponseCount - iFirstResponseIndex;

    int hasNext = 0;
    int hasPrev = 0;
    int hasReset = GetLocalInt(oSpeaker, DLG_HAS_RESET);
    int hasEnd = GetLocalInt(oSpeaker, DLG_HAS_END);

    // Prev?
    if (iFirstResponseIndex !=0 ) hasPrev = 1;

    int iHeaderSize = hasReset + hasPrev + hasEnd;

    // Next?
    if ((iRemainingResponses + iHeaderSize) > iMaxResponses)
    {
        hasNext=1;
        ++iHeaderSize;
    }

    // Now we know the header's size, see if we need to use this index for
    //  our automated purpose.
    if(iResponseIndex >= (iMaxResponses - iHeaderSize))
    {
        int i;
        // Populate responses temporarily to find out who should be where.
        for (i = iMaxResponses - 1; i > (iMaxResponses -1 - iHeaderSize); i--)
        {
            if      (hasEnd   == 1) hasEnd = i;
            else if (hasReset == 1) hasReset = i;
            else if (hasNext  == 1) hasNext = i;
            else if (hasPrev  == 1) hasPrev = i;
            if (iResponseIndex == i) break;
        }
        // Find out who we are and return the type.
        if (hasEnd   == iResponseIndex) return DLG_TYPE_END;
        if (hasReset == iResponseIndex) return DLG_TYPE_RESET;
        if (hasPrev  == iResponseIndex) return DLG_TYPE_PREVIOUS;
        if (hasNext  == iResponseIndex) return DLG_TYPE_NEXT;
    }

    return DLG_TYPE_NONE;
}

// >----< dlg_SendEvent >----<
// <dlg_i_tools>
// Sends the specified dialog event to the specified NPC using the current script handler.
// The selection parameter is used for select events.
// The speaker is provided for event specific paramaters to be stored onto.
void dlg_SendEvent(object oSpeaker, int iEventType, int iSelection = -1, object oThis = OBJECT_SELF)
{
    // Get the dlg file's name.
    string sScriptName = GetLocalString(oSpeaker, DLG_CURRENT_SCRIPT);

    // This is to resolve the hack to allow talking to items in inventory.
    if(oThis == oSpeaker)  oThis = GetLocalObject(oSpeaker, DLG_ITEM);

    // This sets the values that are to be passed into the dlg file's main().
    SetLocalInt(oSpeaker, DLG_EVENT_TYPE, iEventType);
    if (iSelection >= 0) SetLocalInt(oSpeaker, DLG_SELECTION, iSelection);

    // Call dlg file's main.
    ExecuteScript(sScriptName, oThis);
}

// >----< dlg_SetupContinueChainedPrompt >----<
// <dlg_i_tools>
// Gets the next prompt in the continue chain setup.
void dlg_SetupContinueChainedPrompt(object oSpeaker)
{
    if (GetLocalInt(oSpeaker, DLG_CONTINUE_MODE) == TRUE)
    {
        // Put text on prompt.
        string sList = GetLocalString(oSpeaker, DLG_CONTINUE_LIST);
        int iPage = GetLocalInt(oSpeaker, DLG_CONTINUE_PAGE);

        string sText = ss_GetStringElement(iPage, sList, oSpeaker);

        SetLocalString(oSpeaker, DLG_PROMPT, sText);

        // Increment page counter.
        int nListSize = ss_GetElementCount(sList, oSpeaker);
        if ((iPage + 1) < nListSize) iPage++;
        else iPage = -1;

        SetLocalInt(oSpeaker, DLG_CONTINUE_PAGE, iPage);
    }
}

// >----< dlg_SetupDlgResponse >----<
// <dlg_i_tools>
// Sets the token for the response string and returns true if there is a valid
// response entry for the specified num (ie. populates responses once piece at a time)
int dlg_SetupDlgResponse(int nResponseIndex, object oSpeaker)
{
    int iFirstResponseIndex = GetLocalInt(oSpeaker, DLG_CURRENTPAGE_STARTINDEX);
    int iResponseCount = dlg_GetDlgResponseCount(oSpeaker);

    int iMaxResponses = GetLocalInt(oSpeaker, DLG_CURRENT_MAX_RESPONSES);
    int iMaxResponsesMinusOne = iMaxResponses-1;
    int iMaxResponsesMinusFour = iMaxResponses-4;

    int iHasReset = GetLocalInt( oSpeaker, DLG_HAS_RESET );
    int iHasEnd = GetLocalInt( oSpeaker, DLG_HAS_END );

    // START CONTINUE MODE INTERCEPTION
    if (GetLocalInt(oSpeaker, DLG_CONTINUE_MODE) == TRUE)
    {
        if (nResponseIndex == 0)
            // Send the event with the incremented page number.
            dlg_SendEvent(oSpeaker, DLG_EVENT_CONTINUE);


        // Check if we still need to show "Continue".
        if (GetLocalInt(oSpeaker, DLG_CONTINUE_PAGE) != -1)
        {
            // See if we make it blank or "continue".
            if (nResponseIndex == 0)
            {
                SetCustomToken(DLG_FIRST_TOKEN, GetLocalString(oSpeaker, DLG_LABEL_CONTINUE));

                return TRUE;
            }
            else
            {
                // Only return false if there are no auto adds.
                int nAutocount = (iHasEnd==TRUE)?iMaxResponsesMinusOne:iMaxResponses;
                if (iHasReset == TRUE) --nAutocount;
                if (nResponseIndex < nAutocount ) return FALSE;
            }
        }

        // No more continue then.
        else
        {
            SetLocalString(oSpeaker, DLG_CONTINUE_LIST, "");
            SetLocalInt(oSpeaker, DLG_CONTINUE_MODE, FALSE);
        }
    }
    // END CONTINUE MODE INTERCEPTION

    // iMaxResponses-4 is the lowest possible auto-generated selection.
    if (nResponseIndex >= iMaxResponsesMinusFour)
    {
        int nType = dlg_GetType(oSpeaker, nResponseIndex, iMaxResponses, iFirstResponseIndex, iResponseCount);

        switch (nType)
        {

        // We don't handle it!
        case DLG_TYPE_NONE:
            break;

        // Sets the response to the setting on "next's" label.
        case DLG_TYPE_NEXT:
            SetCustomToken(DLG_FIRST_TOKEN + nResponseIndex, GetLocalString(oSpeaker, DLG_LABEL_NEXT));
            return TRUE;

        // Sets the response to the setting on "prev's" label.
        case DLG_TYPE_PREVIOUS:
            SetCustomToken(DLG_FIRST_TOKEN + nResponseIndex, GetLocalString(oSpeaker, DLG_LABEL_PREVIOUS));
            return TRUE;

        // Sets the response to the setting on "reset's" label.
        case DLG_TYPE_RESET:
            SetCustomToken(DLG_FIRST_TOKEN + nResponseIndex, GetLocalString(oSpeaker, DLG_LABEL_RESET));
            return TRUE;

        // Sets the response to the setting on "end's" label.
        case DLG_TYPE_END:
            SetCustomToken(DLG_FIRST_TOKEN + nResponseIndex, GetLocalString(oSpeaker, DLG_LABEL_END));
            return TRUE;
        }
    }

    // Check if this response should actually exist.
    if( iFirstResponseIndex + nResponseIndex < iResponseCount )
    {
        // Grab the response from the user's list.
        string sResponse = dlg_GetResponse(oSpeaker, iFirstResponseIndex + nResponseIndex);

        // And set the response.
        SetCustomToken(DLG_FIRST_TOKEN + nResponseIndex, sResponse);
        return TRUE;
    }
    return FALSE;
}



// >----< dlg_CleanupDlg >----<
// <dlg_i_tools>
// Called to clean-up the current conversation related resources.
void dlg_CleanupDlg(object oSpeaker)
{
    DeleteLocalString(oSpeaker, DLG_CURRENT_SCRIPT);
    DeleteLocalString(oSpeaker, DLG_PROMPT);
    DeleteLocalString(oSpeaker, DLG_RESPONSE_LIST);
    DeleteLocalInt(oSpeaker, DLG_EVENT_TYPE);
    DeleteLocalInt(oSpeaker, DLG_SELECTION);
    DeleteLocalString(oSpeaker, DLG_PAGE_NAME);

    // See if the PC was associated with an item
    object oItem = GetLocalObject(oSpeaker, DLG_ITEM);
    DeleteLocalObject(oSpeaker, DLG_ITEM);
    if(oItem != OBJECT_INVALID)
    {
        DeleteLocalObject(oItem, DLG_OBJECT_CONVERSER);
    }

    object oSelf = OBJECT_SELF;

    DeleteLocalInt(oSpeaker, DLG_STATE);
    DeleteLocalInt(oSpeaker, DLG_LAST_PREVORNEXT);
    DeleteLocalInt(oSpeaker, DLG_CURRENTPAGE_STARTINDEX);
    DeleteLocalInt(oSpeaker, DLG_NORESETPAGEONSELECTION);
    DeleteLocalInt(oSpeaker,  DLG_CONTINUE_PAGE);
    DeleteLocalInt(oSpeaker,  DLG_CONTINUE_MODE);
    DeleteLocalString(oSpeaker, DLG_CONTINUE_LIST);
    DeleteLocalString(oSpeaker, DLG_FAREWELL);
    DeleteLocalInt(oSpeaker,  DLG_CURRENT_MAX_RESPONSES);
    DeleteLocalInt(oSpeaker, DLG_HAS_RESET);
    DeleteLocalInt(oSpeaker, DLG_HAS_END);

    DeleteLocalString(oSpeaker, DLG_LABEL_NEXT);
    DeleteLocalString(oSpeaker, DLG_LABEL_PREVIOUS);
    DeleteLocalString(oSpeaker, DLG_LABEL_RESET);
    DeleteLocalString(oSpeaker, DLG_LABEL_END);
    DeleteLocalString(oSpeaker, DLG_LABEL_CONTINUE);

    DeleteLocalObject(oSelf, DLG_GHOSTPOSSESSOR);

    if (GetLocalInt(oSelf, DLG_GHOST)==TRUE)
    {
        DeleteLocalInt(oSelf, DLG_GHOST);
        DestroyObject(oSelf);
    }
}

// >----< dlg_DoSelection >----<
// <dlg_i_tools>
// On Selection event. Check if we need to handle an automated response first,
//      but if not then pass it to the dialog script.
void dlg_DoSelection(object oSpeaker, int iSelection, object oThis = OBJECT_SELF)
{
    int iHeaderSize;

    int iMaxResponses = GetLocalInt( oSpeaker, DLG_CURRENT_MAX_RESPONSES );
    int iMaxResponsesMinusOne = iMaxResponses-1;
    int iMaxResponsesMinusFour = iMaxResponses-4;
    int iHasReset = GetLocalInt( oSpeaker, DLG_HAS_RESET )?1:0;
    int iHasEnd = GetLocalInt( oSpeaker, DLG_HAS_END )?1:0;

    // START CONTINUE MODE INTERCEPTION
    if (GetLocalInt(oSpeaker, DLG_CONTINUE_MODE) == TRUE )
    {
        int iCount = (iHasEnd==TRUE)?iMaxResponsesMinusOne:iMaxResponses;
        if (iHasReset == TRUE) --iCount;

        if (iSelection < iCount)
            return; // We know what had to be selected.
    }
    // END CONTINUE MODE INTERCEPTION

    // Grab first response on current page.
    int iStartIndex = GetLocalInt(oSpeaker, DLG_CURRENTPAGE_STARTINDEX);

    // Clear flag so that non-next/previous selections call page_init.
    SetLocalInt(oSpeaker, DLG_LAST_PREVORNEXT, FALSE);

    // iMaxResponses-4 is the lowest possible auto-generated selection.
    if (iSelection >= iMaxResponsesMinusFour)
    {
        int iFirstResponseIndex = GetLocalInt(oSpeaker, DLG_CURRENTPAGE_STARTINDEX);
        int iResponseCount = dlg_GetDlgResponseCount(oSpeaker);

        // See if this type is from an auto-generated selection, and what it is.
        int iType = dlg_GetType(oSpeaker, iSelection, iMaxResponses, iFirstResponseIndex, iResponseCount);

        // This will make sure that the page_init event is not executed on a
        //  previous or next selection.
        if (iType == DLG_TYPE_NEXT || iType == DLG_TYPE_PREVIOUS)
        {
            SetLocalInt(oSpeaker, DLG_LAST_PREVORNEXT, TRUE);
        }

        // Find out which selection is called, if any.
        switch (iType)
        {

        // Not auto-generated.
        case DLG_TYPE_NONE:

            break;

        // End the dialog (Autogenerated).
        case DLG_TYPE_END:

            SetLocalInt(oSpeaker, DLG_STATE, DLG_STATE_ENDED);
            return;

        // Go to next page of selections (Autogenerated).
        case DLG_TYPE_NEXT:

            // Add reset and end (where applicable) and "next".
            iHeaderSize = iHasReset + iHasEnd + 1; // Reset+End+Next

            // Add a previous selection if it exists.
            if (iStartIndex > 0) ++iHeaderSize;

            // Get the first response index for the next page and assign it.
            SetLocalInt(oSpeaker, DLG_CURRENTPAGE_STARTINDEX, iStartIndex + (iMaxResponses - iHeaderSize));

            return;

        // Go to previous page of selections (Autogenerated).
        case DLG_TYPE_PREVIOUS:

            // Add reset and end (where applicable) and "next".
            iHeaderSize = iHasReset + iHasEnd + 1; // Reset+End+Next

            // If we are on 3-n page, we know there is a "previous".
            if (iStartIndex != (iMaxResponses - iHeaderSize))
            {
                // Add "previous".
                ++iHeaderSize;
            }

            SetLocalInt(oSpeaker, DLG_CURRENTPAGE_STARTINDEX, iStartIndex - (iMaxResponses - iHeaderSize));

            return;

        // User-defined event, usually to reset or backup the conversation
        //  (Autogenerated).
        case DLG_TYPE_RESET:
            dlg_SendEvent(oSpeaker, DLG_EVENT_RESET);
            return;
        }
    }

    // Bring the selection value to page context.
    iSelection += iStartIndex;

    // Shoot off the event.
    dlg_SendEvent(oSpeaker, DLG_EVENT_SELECTION, iSelection, oThis);
}


// >----< dlg_InitializePage >----<
// <dlg_i_tools>
// Called by the dialog internals to initialize the page and possibly the conversation.
void dlg_InitializePage(object oSpeaker, object oThis = OBJECT_SELF)
{
    int iCurrentState = GetLocalInt(oSpeaker, DLG_STATE);
    string sScriptName = GetLocalString(oSpeaker, DLG_CURRENT_SCRIPT);

    // This is needed for item conversations.
    if(oThis == oSpeaker)
    {
        oThis = GetLocalObject(oSpeaker, DLG_ITEM);
    }

    //  Retrieve the script file if it hasn't already been retrieved
    // (NPCs don't use "dlg_Start()")
    if(sScriptName == "")
    {
        // Grab and assign it. We can change the script in the later.
        sScriptName = GetLocalString(oThis, DLG_VARIABLE_SCRIPTNAME);
        SetLocalString(oSpeaker, DLG_CURRENT_SCRIPT, sScriptName);

        // We need to set this since "_dlgStart()" didn't fire.
        iCurrentState = DLG_STATE_INIT;
    }

    // If we aren't initialized...
    if(iCurrentState == DLG_STATE_INIT)
    {
        // We need a maximum just in case.
        SetLocalInt(oSpeaker, DLG_CURRENT_MAX_RESPONSES, 15);

        // Send the init event.
        dlg_SendEvent(oSpeaker, DLG_EVENT_INIT, -1, oThis);

        // and we're off!
        SetLocalInt(oSpeaker, DLG_STATE, DLG_STATE_RUNNING);
    }

    // Send the page initialization event, if:
    // - We aren't using Next or Previous.
    // - We aren't using Continue. (OnContinue is instead)
    if ((GetLocalInt(oSpeaker, DLG_LAST_PREVORNEXT) == FALSE) &&
         (GetLocalInt(oSpeaker, DLG_CONTINUE_MODE) == FALSE))
    {
        // Reset the page count IF the flag to preserve it is set.
        if (GetLocalInt(oSpeaker, DLG_NORESETPAGEONSELECTION) == FALSE)
        {
            SetLocalInt(oSpeaker, DLG_CURRENTPAGE_STARTINDEX, 0);
        }

        // Send the page_init event.
        dlg_SendEvent(oSpeaker, DLG_EVENT_PAGE_INIT, -1, oThis);
    }
}


