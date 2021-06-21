/*
Filename:           dlg_ghostspeak
System:             Dynamic Dialog System (Hook-in script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:

This is an internal event to cause a recently created ghost to talk to the player.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "dlg_i_tools"

void main()
{
    object oPlayer = GetLocalObject(OBJECT_SELF, DLG_GHOSTTALKER);
    object oNPC = OBJECT_SELF;

    if (GetIsPC(oPlayer) == FALSE) return;

    SetCommandable(TRUE, oPlayer);
    DeleteLocalObject(OBJECT_SELF, DLG_GHOSTTALKER);
    ClearAllActions();

    // Get dialog script name from npc.
    string sScript = GetLocalString( oNPC, DLG_VARIABLE_SCRIPTNAME );
    if ( sScript == "" ) return;

    // Gets extra parameters from npc.
    int iMakeprivate = GetLocalInt( oNPC, DLG_VARIABLE_MAKEPRIVATE );
    int iNoHello = GetLocalInt( oNPC, DLG_VARIABLE_NOHELLO );
    int iNoZoom = GetLocalInt( oNPC, DLG_VARIABLE_NOZOOM );


    // Start the dialog between the npc and the player
    dlg_Start( oPlayer, oNPC, sScript, iMakeprivate, iNoHello, iNoZoom );

}
