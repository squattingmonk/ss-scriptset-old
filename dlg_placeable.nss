/*
Filename:           dlg_placeable
System:             Dynamic Dialog System (Hook-in script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:

A placeable's onUsed conversation starter. It uses placeable's properties for
parameters. This will reference a dialog script that is

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "dlg_i_tools"

void main()
{
    object oPlayer = GetLastUsedBy();
    object oPlaceable = OBJECT_SELF;

    if (GetIsPC(oPlayer) == FALSE)  return;

    // Get dialog script name from placeable.
    string sScript = GetLocalString(oPlaceable, DLG_VARIABLE_SCRIPTNAME);
    if (sScript == "") return;

    // Gets extra parameters from placeable.
    int iMakeprivate = GetLocalInt( oPlaceable, DLG_VARIABLE_MAKEPRIVATE );
    int iNoHello = GetLocalInt( oPlaceable, DLG_VARIABLE_NOHELLO );
    int iNoZoom = GetLocalInt( oPlaceable, DLG_VARIABLE_NOZOOM );

    // Start the dialog between the placeable and the player
    dlg_Start( oPlayer, oPlaceable, sScript, iMakeprivate, iNoHello, iNoZoom );
}
