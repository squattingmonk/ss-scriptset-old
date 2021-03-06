/*
Filename:           dlg_ghostconv
System:             Dynamic Dialog System (Hook-in script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:

 This is an OnConversation event for NPCs who support 2+ way conversations.
This creates a copy, or ghost, or the original NPC. This ghost will then be
later changed into various NPCs via dlg_ChangeSpeakee().

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "dlg_i_tools"

const float fGhostTalkDelay = 0.5;

void main()
{
    // Run default code first, should handle custom ones too.
    ExecuteScript("NW_C2_DEFAULT4", OBJECT_SELF);

    object oPlayer = GetLastSpeaker();
    object oNPC = OBJECT_SELF;

    if (GetIsPC(oPlayer) == FALSE) return;
    if (GetLocalInt( oNPC, DLG_GHOST ) == TRUE ) return;


    // Get dialog script name from NPC.
    string sScript = GetLocalString( oNPC, DLG_VARIABLE_SCRIPTNAME );
    if ( sScript == "" ) return;

    // Create the ghost copy and hide it.
    object oGhost = CopyObject(oNPC, GetLocation(oNPC), OBJECT_INVALID, GetTag(oNPC)+"ghost");
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oGhost);
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oGhost);
    SetPlotFlag(oGhost, TRUE);

    AssignCommand(oGhost, ActionJumpToLocation(GetLocation(oNPC)));

    // Remember the ghost for cleanup.
    SetLocalInt( oGhost, DLG_GHOST, TRUE );

    // New object needs to know the script name and other variables.
    SetLocalString(oGhost, DLG_VARIABLE_SCRIPTNAME, sScript);
    SetLocalInt(oGhost, DLG_VARIABLE_MAKEPRIVATE, GetLocalInt(oNPC, DLG_VARIABLE_MAKEPRIVATE));
    SetLocalInt(oGhost, DLG_VARIABLE_NOHELLO, GetLocalInt(oNPC, DLG_VARIABLE_NOHELLO));
    SetLocalInt(oGhost, DLG_VARIABLE_NOZOOM, GetLocalInt(oNPC, DLG_VARIABLE_NOZOOM));

    SetLocalObject(oGhost, DLG_GHOSTTALKER, oPlayer);
    SetLocalObject(oGhost, DLG_GHOSTPOSSESSOR, OBJECT_SELF);

    SetCommandable(FALSE, oPlayer);

    DelayCommand(fGhostTalkDelay, ExecuteScript("dlg_ghostspeak", oGhost));
}

