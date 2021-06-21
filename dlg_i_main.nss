/*
Filename:           dlg_i_main
System:             Dynamic Dialog System (include script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:

Copyright 2005-2006 by Greyhawk0

 Special thanks to Z-Dialog creator Paul Speed.

  This is the standard interface for dealing with ZZ-Dialog. Originally a
 wrapper for Z-Dialog, it has grown and became fully autonomous (as far as
 the end-user is concerned).

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "dlg_i_tools"
#include "g_i_generic"
#include "dlg_c_main"




//
//     TODO: Clean up this mess. S&S Style function prototypes, optimize, rename variables, etc..
//




////////////////////////////
// ********************** \\
//    Shared Variables    \\
// ********************** \\
////////////////////////////
object oCurrentSpeaker;
object oCurrentSpeakee;
string sCurrentSelection;
int iCurrentSelection;






//  These are functions that should be implemented in a dialog script file. This
// is my form of a callback and makes it simplier to process events.
void dlg_OnInit( );                       // Called at initialization
void dlg_OnPageInit( string sPage );      // Called at page initialization
void dlg_OnSelection( string sPage );     // Called a user-defined selection
void dlg_OnReset( string sPage );         // Called at reset selection
void dlg_OnAbort( string sPage );         // Called at 'ESC'
void dlg_OnEnd( string sPage );           // Called at proper exit
void dlg_OnContinue( string sPage, int iContinuePage ); // Called each continue page



// Gets the talking player.
object dlg_GetSpeakingPC( );
object dlg_GetSpeakingPC( )
{
    return oCurrentSpeaker;
}

// Sets the new current dialog handler script for the current conversation.
// This allows on the fly conversation changes and linking.  This must
// be called within a conversation related event.
void dlg_ChangeDlgScript( object oSpeaker, string sNewScriptName );
void dlg_ChangeDlgScript( object oSpeaker, string sNewScriptName )
{
    SetLocalString( oCurrentSpeaker, DLG_CURRENT_SCRIPT, sNewScriptName );
}

// Ends the dialog, but only within an event, like onSelection or onReset.
void dlg_EndDialog();
void dlg_EndDialog()
{
    SetLocalInt( oCurrentSpeaker, DLG_STATE, DLG_STATE_ENDED );
}

//  Adds an page of dialog to the continue chain's queued dialog list! Returns
// it's index number.
int dlg_AddContinueChainMsg( string sContinueList, string sContinueMsg );
int dlg_AddContinueChainMsg( string sContinueList, string sContinueMsg )
{
    int iIndex = ss_GetElementCount( sContinueList, oCurrentSpeaker );
    return ( ss_AddStringElement( sContinueMsg ,
                               sContinueList,
                               oCurrentSpeaker ) );
}

//  Gets the current continue page. Only valid during a continue chain.
// (-1 is last page or no continue page)
int dlg_GetCurrentContinuePage( )
{
    return ( GetLocalInt( oCurrentSpeaker, DLG_CONTINUE_PAGE ) );
}

// Sets up the continue chain, and passes in the queued dialog's list name.
void dlg_SetupContinueChain( string sContinueList );
void dlg_SetupContinueChain( string sContinueList )
{
    SetLocalString( oCurrentSpeaker, DLG_CONTINUE_LIST, sContinueList );
    SetLocalInt( oCurrentSpeaker, DLG_CONTINUE_PAGE, 0 );
    SetLocalInt( oCurrentSpeaker, DLG_CONTINUE_MODE, TRUE );
}

// Clears a continue chain's queued dialog's list.
void dlg_ClearContinueList( string sContinueList );
void dlg_ClearContinueList( string sContinueList )
{
    ss_DeleteList( sContinueList, oCurrentSpeaker );
}

// Sets the player's local integer to an integer.
void dlg_SetPlayerDataInt( string sName, int iValue );
void dlg_SetPlayerDataInt( string sName, int iValue )
{
    SetLocalInt( oCurrentSpeaker, sName, iValue );
}

// Gets the player's local integer.
int dlg_GetPlayerDataInt( string sName );
int dlg_GetPlayerDataInt( string sName )
{
    return ( GetLocalInt( oCurrentSpeaker, sName ) );
}

// Delete's the player's local integer.
void dlg_ClearPlayerDataInt( string sName );
void dlg_ClearPlayerDataInt( string sName )
{
    DeleteLocalInt( oCurrentSpeaker, sName );
}

// Sets the player's local integer to a string.
void dlg_SetPlayerDataString( string sName, string sValue );
void dlg_SetPlayerDataString( string sName, string sValue )
{
    SetLocalString( oCurrentSpeaker, sName, sValue );
}

// Gets the player's local string.
string dlg_GetPlayerDataString( string sName );
string dlg_GetPlayerDataString( string sName )
{
    return ( GetLocalString( oCurrentSpeaker, sName ) );
}

// Delete's the player's local string.
void dlg_ClearPlayerDataString( string sName );
void dlg_ClearPlayerDataString( string sName )
{
    DeleteLocalString( oCurrentSpeaker, sName );
}

// Sets the player's local integer to a float.
void dlg_SetPlayerDataFloat( string sName, float fValue );
void dlg_SetPlayerDataFloat( string sName, float fValue )
{
    SetLocalFloat( oCurrentSpeaker, sName, fValue );
}

// Gets the player's local float.
float dlg_GetPlayerDataFloat( string sName );
float dlg_GetPlayerDataFloat( string sName )
{
    return ( GetLocalFloat( oCurrentSpeaker, sName ) );
}

// Delete's the player's local float.
void dlg_ClearPlayerDataFloat( string sName );
void dlg_ClearPlayerDataFloat( string sName )
{
    DeleteLocalFloat( oCurrentSpeaker, sName );
}

// Sets the player's local integer to a location.
void dlg_SetPlayerDataLocation( string sName, location lValue );
void dlg_SetPlayerDataLocation( string sName, location lValue )
{
    SetLocalLocation( oCurrentSpeaker, sName, lValue );
}

// Gets the player's local location.
location dlg_GetPlayerDataLocation( string sName );
location dlg_GetPlayerDataLocation( string sName )
{
    return ( GetLocalLocation( oCurrentSpeaker, sName ) );
}

// Delete's the player's local location.
void dlg_ClearPlayerDataLocation( string sName );
void dlg_ClearPlayerDataLocation( string sName )
{
    DeleteLocalLocation( oCurrentSpeaker, sName );
}

// Sets the player's local integer to an object.
void dlg_SetPlayerDataObject( string sName, object oValue );
void dlg_SetPlayerDataObject( string sName, object oValue )
{
    SetLocalObject( oCurrentSpeaker, sName, oValue );
}

// Gets the player's local object.
object dlg_GetPlayerDataObject( string sName );
object dlg_GetPlayerDataObject( string sName )
{
    return ( GetLocalObject( oCurrentSpeaker, sName ) );
}

// Delete's the player's local object.
void dlg_ClearPlayerDataObject( string sName );
void dlg_ClearPlayerDataObject( string sName )
{
    DeleteLocalObject( oCurrentSpeaker, sName );
}

//  Makes it so that on large response lists, the page number won't reset
// automatically. onPageInit only!
void dlg_ActivatePreservePageNumberOnSelection( );
void dlg_ActivatePreservePageNumberOnSelection( )
{
    SetLocalInt( oCurrentSpeaker, DLG_NORESETPAGEONSELECTION, TRUE );
}

//  Makes it so that on large response lists, the page number will reset
// automatically. onPageInit only!
void dlg_DeactivatePreservePageNumberOnSelection( );
void dlg_DeactivatePreservePageNumberOnSelection( )
{
    SetLocalInt( oCurrentSpeaker, DLG_NORESETPAGEONSELECTION, FALSE );
}

// This will reset the page #. This is required to have it reset if
//      dlg_ActivatePreservePageNumberOnSelection is in effect.
void dlg_ResetPageNumber( );
void dlg_ResetPageNumber( )
{
    SetLocalInt( oCurrentSpeaker, DLG_CURRENTPAGE_STARTINDEX, 0 );
}

// Sets the list that has all the responses. onPageInit only!
void dlg_SetActiveResponseList( string sResponseList );
void dlg_SetActiveResponseList( string sResponseList )
{
    SetLocalString( oCurrentSpeaker, DLG_RESPONSE_LIST, sResponseList );
}

//  Clears the named list's contents. NOTE: This will not dereference the named
// list for responses! You must either change the list referenced with
// dlg_SetActiveResponseList() or repopulate the list with dlg_AddResponse*().
//
void dlg_ClearResponseList( string sResponseList );
void dlg_ClearResponseList( string sResponseList )
{
    ss_DeleteList( sResponseList, oCurrentSpeaker );
}

// Adds a response, in the form of talking, to the response list.
//      Returns index to action. onInit or onPageInit only!
int dlg_AddResponseTalk( string sResponseList, string sResponse, string sTxtColor = DLG_DEFAULT_TXT_TALK_COLOR );
int dlg_AddResponseTalk( string sResponseList, string sResponse, string sTxtColor = DLG_DEFAULT_TXT_TALK_COLOR )
{
    int iIndex = ss_GetElementCount( sResponseList, oCurrentSpeaker );
    ss_AddStringElement( ss_GetStringColored( sResponse, sTxtColor ),
                      sResponseList,
                      oCurrentSpeaker );
    return ( iIndex );
}

// Adds a response, in the form of an action, to the response list.
//      Returns index to action. onInit or onPageInit only!
int dlg_AddResponseAction( string sResponseList, string sResponse, string sTxtColor = DLG_DEFAULT_TXT_ACTION_COLOR );
int dlg_AddResponseAction( string sResponseList, string sResponse, string sTxtColor = DLG_DEFAULT_TXT_ACTION_COLOR )
{
    int iIndex = ss_GetElementCount( sResponseList, oCurrentSpeaker );
    ss_AddStringElement( ss_GetStringColored( sResponse, sTxtColor ),
                      sResponseList,
                      oCurrentSpeaker );
    return ( iIndex );
}

// Adds a response with no coloring or nothing.
//      Returns index to action. onInit or onPageInit only!
int dlg_AddResponse( string sResponseList, string sResponse );
int dlg_AddResponse( string sResponseList, string sResponse )
{
    int iIndex = ss_GetElementCount( sResponseList, oCurrentSpeaker );
    ss_AddStringElement( sResponse,
                      sResponseList,
                      oCurrentSpeaker );
    return ( iIndex );
}

// Gets the index of the selected response.
//      onSelection event only!
int dlg_GetSelectionIndex( );
int dlg_GetSelectionIndex( )
{
    return ( iCurrentSelection );
}

// Gets the name of the selected response.
//      onSelection event only!
string dlg_GetSelectionName( );
string dlg_GetSelectionName( )
{
    return ( sCurrentSelection );
}

// Checks if the index of the selected response matches the parameter.
//      onSelection event only!
int dlg_IsSelectionEqualToIndex( int iIndex );
int dlg_IsSelectionEqualToIndex( int iIndex )
{
    return ( iCurrentSelection == iIndex );
}

// Checks if the name of the selected response matches the parameter.
//      onSelection event only!
int dlg_IsSelectionEqualToName( string sTest );
int dlg_IsSelectionEqualToName( string sTest )
{
    if ( GetStringLength( sCurrentSelection ) == GetStringLength( sTest ) )
    {
        if ( FindSubString ( sCurrentSelection, sTest ) == 0 ) return ( TRUE );
    }
    return ( FALSE );
}

// Sets what this object is currently saying. onInit and onPageInit only!
void dlg_SetPrompt( string sPrompt );
void dlg_SetPrompt( string sPrompt )
{
    SetLocalString( oCurrentSpeaker, DLG_PROMPT, sPrompt );
}

// Changes the page. Will trigger "OnPageInit" later. Use during OnSelection or
// OnInit only!!!
void dlg_ChangePage( string sNewPage );
void dlg_ChangePage( string sNewPage )
{
    SetLocalString( oCurrentSpeaker, DLG_PAGE_NAME, sNewPage );
}

// Changes the automated "Next" response's label. onInit or onPageInit only!
void dlg_ChangeLabelNext( string sNewLabel = DLG_DEFAULTLABEL_NEXT, string sTxtColor = DLG_DEFAULT_TXT_NEXT_COLOR );
void dlg_ChangeLabelNext( string sNewLabel = DLG_DEFAULTLABEL_NEXT, string sTxtColor = DLG_DEFAULT_TXT_NEXT_COLOR )
{
    SetLocalString( oCurrentSpeaker, DLG_LABEL_NEXT, ss_GetStringColored( sNewLabel, sTxtColor ) );
}

//  Changes the automated "Previous Page" response's label. onInit or onPageInit
// only!
void dlg_ChangeLabelPrevious( string sNewLabel = DLG_DEFAULTLABEL_PREV, string sTxtColor = DLG_DEFAULT_TXT_PREVIOUS_COLOR );
void dlg_ChangeLabelPrevious( string sNewLabel = DLG_DEFAULTLABEL_PREV, string sTxtColor = DLG_DEFAULT_TXT_PREVIOUS_COLOR )
{
    SetLocalString( oCurrentSpeaker, DLG_LABEL_PREVIOUS, ss_GetStringColored( sNewLabel, sTxtColor ) );
}

//  Changes the automated "Continue" response's label. onInit, onPageInit, or
// onContinue only!
void dlg_ChangeLabelContinue( string sNewLabel = DLG_DEFAULTLABEL_CONTINUE, string sTxtColor = DLG_DEFAULT_TXT_CONTINUE_COLOR );
void dlg_ChangeLabelContinue( string sNewLabel = DLG_DEFAULTLABEL_CONTINUE, string sTxtColor = DLG_DEFAULT_TXT_CONTINUE_COLOR )
{
    SetLocalString( oCurrentSpeaker, DLG_LABEL_CONTINUE, ss_GetStringColored( sNewLabel, sTxtColor ) );
}

// Activates the automated "Reset" response. onInit, onContinue, or onPageInit
//      only!
void dlg_ActivateResetResponse( string sNewLabel = DLG_DEFAULTLABEL_RESET, string sTxtColor = DLG_DEFAULT_TXT_RESET_COLOR );
void dlg_ActivateResetResponse( string sNewLabel = DLG_DEFAULTLABEL_RESET, string sTxtColor = DLG_DEFAULT_TXT_RESET_COLOR )
{
    SetLocalString( oCurrentSpeaker, DLG_LABEL_RESET, ss_GetStringColored( sNewLabel, sTxtColor ) );
    SetLocalInt( oCurrentSpeaker, DLG_HAS_RESET, TRUE );
}

// Deactivates the automated "Reset" response. onInit, onContinue, or onPageInit
//      only!
void dlg_DeactivateResetResponse( );
void dlg_DeactivateResetResponse( )
{
    SetLocalInt( oCurrentSpeaker, DLG_HAS_RESET, FALSE );
}

// Activates the automated "End" response. onInit, onContinue, or onPageInit
//      only!
void dlg_ActivateEndResponse( string sNewLabel = DLG_DEFAULTLABEL_END, string sTxtColor = DLG_DEFAULT_TXT_END_COLOR );
void dlg_ActivateEndResponse( string sNewLabel = DLG_DEFAULTLABEL_END, string sTxtColor = DLG_DEFAULT_TXT_END_COLOR )
{
    SetLocalString( oCurrentSpeaker, DLG_LABEL_END, ss_GetStringColored( sNewLabel, sTxtColor ) );
    SetLocalInt( oCurrentSpeaker, DLG_HAS_END, TRUE );
}

// Deactivates the automated "End" response. onInit, onContinue, or onPageInit
//      only!
void dlg_DeactivateEndResponse( );
void dlg_DeactivateEndResponse( )
{
    SetLocalInt( oCurrentSpeaker, DLG_HAS_END, FALSE );
}

//  Sets the maximum number of responses to be displayed. The limit is 5-15.
void dlg_SetMaximumResponses(int iMaximumResponses = DLG_DEFAULT_MAX_RESPONSES);
void dlg_SetMaximumResponses(int iMaximumResponses = DLG_DEFAULT_MAX_RESPONSES)
{
    if (iMaximumResponses<5) iMaximumResponses=5;
    if (iMaximumResponses>15) iMaximumResponses=15;
    SetLocalInt( oCurrentSpeaker, DLG_CURRENT_MAX_RESPONSES, iMaximumResponses );
}

//  Sets an farewell message after the conversation is ended in a
// non-interrupted or non-aborted fasion.
void dlg_SetFarewell(string sFarewellMessage);
void dlg_SetFarewell(string sFarewellMessage)
{
    SetLocalString(oCurrentSpeaker, DLG_FAREWELL, sFarewellMessage);
}

//  Retrieves the NPC that the ghost is possessing. If call on non-ghost, this
// will return OBJECT_INVALID. Otherwise the NPC will be returned.
object dlg_GetGhostPossessor();
object dlg_GetGhostPossessor()
{
    return ( GetLocalObject( OBJECT_SELF, DLG_GHOSTPOSSESSOR ) );
}

//  This changes the current speakee. In reality we are only talking to a ghost,
// who is a copy of the original NPC.
// Requires 1.67! The NPC should have the OnConversation script set to
// "zdlg_ghostconver", and the dialog used, "zdlg_converse*" for example, to
// be blank. This requires that you enable the setname and set portrait commands
// which I wasn't privy to.
void dlg_ChangeSpeakee(object oNewSpeakee);
void dlg_ChangeSpeakee(object oNewSpeakee)
{
    if (GetLocalInt( OBJECT_SELF, DLG_GHOST ) == TRUE)
    {
        // Find the guy.
        if (GetIsObjectValid(oNewSpeakee)==FALSE) return;

        // Make the ghost look like the tagged object.
        SetName(OBJECT_SELF, GetName(oNewSpeakee) );
        SetPortraitId(OBJECT_SELF, GetPortraitId(oNewSpeakee));

        // Make PC face the new guy and new guy to face PC.
        ActionJumpToLocation(GetLocation(oNewSpeakee));
        AssignCommand( oNewSpeakee, SetFacingPoint(GetPosition(oCurrentSpeaker)));
        AssignCommand( oCurrentSpeaker, SetFacingPoint(GetPosition(oNewSpeakee)));

        // We have to pause because it takes time to switch name and portrait.
        AssignCommand( oCurrentSpeaker, ActionPauseConversation());
        AssignCommand( oCurrentSpeaker, DelayCommand(0.5, ActionResumeConversation()));

        // Update which object is possessed.
        SetLocalObject( OBJECT_SELF, DLG_GHOSTPOSSESSOR, oNewSpeakee );
    }
}

//  This changes the current speakee. In reality we are only talking to a ghost,
// who is a copy of the original NPC. This uses a tag to grab both the name and
// portrait of the object, then is applied to the ghost. THIS IS NOT TESTED!
// Requires 1.67! The NPC should have the OnConversation script set to
// "zdlg_ghostconver", and the dialog used, "zdlg_converse*" for example, to
// be blank. This requires that you enable the setname and set portrait commands
// which I wasn't privy to. NOTE: Make object parameter version.
void dlg_ChangeSpeakeeByTag(string sTag);
void dlg_ChangeSpeakeeByTag(string sTag)
{
    dlg_ChangeSpeakee( GetObjectByTag( sTag ) );
}

// Sets the speakee's local integer to an integer.
void dlg_SetSpeakeeDataInt( string sName, int iValue );
void dlg_SetSpeakeeDataInt( string sName, int iValue )
{
    SetLocalInt( oCurrentSpeakee, sName, iValue );
}

// Gets the speakee's local integer.
int dlg_GetSpeakeeDataInt( string sName );
int dlg_GetSpeakeeDataInt( string sName )
{
    return ( GetLocalInt( oCurrentSpeakee, sName ) );
}

// Delete's the speakee's local integer.
void dlg_ClearSpeakeeDataInt( string sName );
void dlg_ClearSpeakeeDataInt( string sName )
{
    DeleteLocalInt( oCurrentSpeakee, sName );
}

// Sets the speakee's local integer to a string.
void dlg_SetSpeakeeDataString( string sName, string sValue );
void dlg_SetSpeakeeDataString( string sName, string sValue )
{
    SetLocalString( oCurrentSpeakee, sName, sValue );
}

// Gets the speakee's local string.
string dlg_GetSpeakeeDataString( string sName );
string dlg_GetSpeakeeDataString( string sName )
{
    return ( GetLocalString( oCurrentSpeakee, sName ) );
}

// Delete's the speakee's local string.
void dlg_ClearSpeakeeDataString( string sName );
void dlg_ClearSpeakeeDataString( string sName )
{
    DeleteLocalString( oCurrentSpeakee, sName );
}

// Sets the speakee's local integer to a float.
void dlg_SetSpeakeeDataFloat( string sName, float fValue );
void dlg_SetSpeakeeDataFloat( string sName, float fValue )
{
    SetLocalFloat( oCurrentSpeakee, sName, fValue );
}

// Gets the speakee's local float.
float dlg_GetSpeakeeDataFloat( string sName );
float dlg_GetSpeakeeDataFloat( string sName )
{
    return ( GetLocalFloat( oCurrentSpeakee, sName ) );
}

// Delete's the speakee's local float.
void dlg_ClearSpeakeeDataFloat( string sName );
void dlg_ClearSpeakeeDataFloat( string sName )
{
    DeleteLocalFloat( oCurrentSpeakee, sName );
}

// Sets the speakee's local integer to a location.
void dlg_SetSpeakeeDataLocation( string sName, location lValue );
void dlg_SetSpeakeeDataLocation( string sName, location lValue )
{
    SetLocalLocation( oCurrentSpeakee, sName, lValue );
}

// Gets the speakee's local location.
location dlg_GetSpeakeeDataLocation( string sName );
location dlg_GetSpeakeeDataLocation( string sName )
{
    return ( GetLocalLocation( oCurrentSpeakee, sName ) );
}

// Delete's the speakee's local location.
void dlg_ClearSpeakeeDataLocation( string sName );
void dlg_ClearSpeakeeDataLocation( string sName )
{
    DeleteLocalLocation( oCurrentSpeakee, sName );
}

// Sets the speakee's local integer to an object.
void dlg_SetSpeakeeDataObject( string sName, object oValue );
void dlg_SetSpeakeeDataObject( string sName, object oValue )
{
    SetLocalObject( oCurrentSpeakee, sName, oValue );
}

// Gets the speakee's local object.
object dlg_GetSpeakeeDataObject( string sName );
object dlg_GetSpeakeeDataObject( string sName )
{
    return ( GetLocalObject( oCurrentSpeakee, sName ) );
}

// Delete's the speakee's local object.
void dlg_ClearSpeakeeDataObject( string sName );
void dlg_ClearSpeakeeDataObject( string sName )
{
    DeleteLocalObject( oCurrentSpeakee, sName );
}

//  Processes an event. This should only be called once during the script and
// should really be the only thing in a dialog file's main().
void dlg_OnMessage();
void dlg_OnMessage()
{
    oCurrentSpeaker = dlg_GetPCSpeaker();
    oCurrentSpeakee = dlg_GetObjSpeakee(oCurrentSpeaker);

    int iEvent = GetLocalInt( oCurrentSpeaker, DLG_EVENT_TYPE );

    switch( iEvent )
    {
    case DLG_EVENT_INIT:
        // Setup defaults.
        dlg_ChangeLabelNext( );
        dlg_ChangeLabelPrevious( );
        dlg_ChangeLabelContinue( );
        dlg_ActivateEndResponse( );
        dlg_DeactivatePreservePageNumberOnSelection( );
        dlg_SetMaximumResponses( );
        SetLocalInt( oCurrentSpeaker, DLG_CONTINUE_PAGE, -1 );

        dlg_OnInit( );

        break;
    case DLG_EVENT_PAGE_INIT:
        dlg_OnPageInit( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );
        break;
    case DLG_EVENT_SELECTION:
    {
        iCurrentSelection = GetLocalInt( oCurrentSpeaker, DLG_SELECTION );

        string s = dlg_GetResponse( oCurrentSpeaker, iCurrentSelection );
        sCurrentSelection = GetSubString( s, 6, GetStringLength( s ) - 10 );

        dlg_OnSelection( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );

        break;
    }
    case DLG_EVENT_ABORT:
        dlg_OnAbort( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );
        break;
    case DLG_EVENT_END:
        dlg_OnEnd( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );
        break;
    case DLG_EVENT_RESET:
        dlg_OnReset( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );
        break;
    case DLG_EVENT_CONTINUE:
       dlg_OnContinue( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ),
                    GetLocalInt( oCurrentSpeaker, DLG_CONTINUE_PAGE ) );
        break;
    }

    oCurrentSpeaker = OBJECT_INVALID;
    oCurrentSpeakee = OBJECT_INVALID;
}
