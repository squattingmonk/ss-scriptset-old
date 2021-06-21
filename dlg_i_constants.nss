/*
Filename:           dlg_i_constants
System:             Dynamic Dialog System (include script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       March 21, 2009
Summary:

This script contains the constants used throughout the Dynamic Dialog System

Copyright (c) 2004 Paul Speed - BSD licensed.
NWN Tools - http://nwntools.sf.net/
Additions and changes from original copyright (c) 2005-2006 Greyhawk0

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/



////////////////////////////
// ********************** \\
//  Constants Prototypes  \\
// ********************** \\
////////////////////////////


// DIALOG EVENTS
const int DLG_EVENT_INIT      = 0; // new dialog is started
const int DLG_EVENT_PAGE_INIT = 1; // new page is started
const int DLG_EVENT_SELECTION = 2; // response was selected
const int DLG_EVENT_ABORT     = 3; // dialog was aborted
const int DLG_EVENT_END       = 4; // dialog ended normally
const int DLG_EVENT_RESET     = 5; // dialog was reset
const int DLG_EVENT_CONTINUE  = 6; // dialog was continued

// DIALOG STATES
const int DLG_STATE_INIT = 0;      // Dialog is new and uninitialized
const int DLG_STATE_RUNNING = 1;   // Dialog is running normally
const int DLG_STATE_ENDED = 2;     // Dialog has ended

// Local variables on the speakee that are placed in toolkit.
const string DLG_VARIABLE_SCRIPTNAME  = "DLG_Script";           // STRING - The script filename
const string DLG_VARIABLE_MAKEPRIVATE = "DLG_Private";          // INT - Non-zero means private conversation
const string DLG_VARIABLE_NOHELLO     = "DLG_NoHello";          // INT - Non-zero means no hello
const string DLG_VARIABLE_NOZOOM      = "DLG_NoZoom";           // INT - Non-zero means don't zoom-in

const string DLG_CONVERSATION = "dlg_conversation";
const string DLG_CONVERSATION_NO_ZOOM = "dlg_conv_nozoom";



// Local String - Speaker - Holds script filename.
const string DLG_CURRENT_SCRIPT = "DLG_CurrentDialog";

// Local String - Speaker - Current speakee's dialog.
const string DLG_PROMPT = "DLG_Prompt";

// Local List   - Speaker - List of responses.
const string DLG_RESPONSE_LIST = "DLG_ResponseList";

// Local Int    - Speaker - Current DLG_EVENT_*.
const string DLG_EVENT_TYPE = "DLG_EventType";

// Local Int    - Speaker - Current selection OnSelection.
const string DLG_SELECTION = "DLG_EventSelection";

// Local String - Speaker - Current page name
const string DLG_PAGE_NAME = "DLG_PageName";

// Local Object - Speaker - Current item that is a speakee.
const string DLG_ITEM = "DLG_Item";

// Local Object - Speakee - Current PC that is speaking to the object (non-talkable).
const string DLG_OBJECT_CONVERSER = "DLG_Converser";

// Local Int    - Speaker - Current state of dialog.
const string DLG_STATE = "DLG_State";

// Local Int    - Speaker - Flag if the last selection was next or previous.
const string DLG_LAST_PREVORNEXT = "DLG_PrevorNext";

// Local Int    - Speaker - Current page's starting response index.
const string DLG_CURRENTPAGE_STARTINDEX = "DLG_CurrentPageStartIndex";

// Local Int    - Speaker - Flag that preserves the page on selection.
const string DLG_NORESETPAGEONSELECTION = "DLG_NoResetPageOnSelection";

// Local Int    - Speaker - Current page during continue chain.
const string DLG_CONTINUE_PAGE = "DLG_ContinuePage";

// Local Int    - Speaker - Flag that specifies if a continue chain is active.
const string DLG_CONTINUE_MODE = "DLG_ContinueMode";

// Local List   - Speaker - A list containing a list of dialog pages for continue chain.
const string DLG_CONTINUE_LIST = "DLG_ContinueList";

// Local String - Speaker - The final farewell dialog before the player clicks "End Dialog".
const string DLG_FAREWELL = "DLG_Farewell";

// Local Int    - Speaker - The maximum allowed responses to be shown.
const string DLG_CURRENT_MAX_RESPONSES = "DLG_MaxResponses";

// Local Int    - Speaker - Flag for if the "Reset" response should be shown.
const string DLG_HAS_RESET = "DLG_HasReset";

// Local Int    - Speaker - Flag for if the "End" response should be shown.
const string DLG_HAS_END = "DLG_HasEnd";

// Local String - Speaker - Name given to the "Next Page" response.
const string DLG_LABEL_NEXT = "DLG_LabelNext";

// Local String - Speaker - Name given to the "Previous Page" response.
const string DLG_LABEL_PREVIOUS = "DLG_LabelPrevious";

// Local String - Speaker - Name given to the "Reset" response.
const string DLG_LABEL_RESET = "DLG_LabelReset";

// Local String - Speaker - Name given to the "End" response.
const string DLG_LABEL_END = "DLG_LabelEnd";

// Local String - Speaker - Name given to the "Continue" response.
const string DLG_LABEL_CONTINUE = "DLG_LabelContinue";

// Local Int    - Speakee - A flag if the speakee is actually a ghost for 2-way conversations.
const string DLG_GHOST = "DLG_Ghost";

// Local Object - Speakee - The PC that the ghost is talking to.
const string DLG_GHOSTTALKER = "DLG_GhostTalker";

// Local Object - Speakee - The NPC that the ghost is possessing.
const string DLG_GHOSTPOSSESSOR = "DLG_GhostPossessor";

// TOKEN RESERVATIONS
const int DLG_BASE_TOKEN = 4200; // Prompt
const int DLG_FIRST_TOKEN = 4201; // Responses are +0 to +14

// "dlg_GetType()" possible return values
const int DLG_TYPE_NONE = 0;
const int DLG_TYPE_NEXT = 1;
const int DLG_TYPE_PREVIOUS = 2;
const int DLG_TYPE_RESET = 3;
const int DLG_TYPE_END = 4;

// Error messages
const string DLG_ERROR_NO_PC_SPEAKER = "[Dynamic Dialog System] Error - Can't retrieve PC Speaker";
