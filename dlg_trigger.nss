/*
Filename:           dlg_trigger
System:             Dynamic Dialog System (Hook-in script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:

A zone's onEnter conversation starter. It uses the zone's properties for
parameters. This will reference the dialog script in variables.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "dlg_i_tools"

void main()
{
    object oPlayer = GetEnteringObject( );
    object oZone = OBJECT_SELF;

    if (GetIsPC(oPlayer) == FALSE) return;

    // Get dialog script name from item.
    string sScript = GetLocalString(oZone, DLG_VARIABLE_SCRIPTNAME);
    if (sScript == "") return;

    // Gets extra parameters from item.
    int iMakeprivate = GetLocalInt(oZone, DLG_VARIABLE_MAKEPRIVATE);
    int iNoHello = GetLocalInt(oZone, DLG_VARIABLE_NOHELLO);
    int iNoZoom = GetLocalInt(oZone, DLG_VARIABLE_NOZOOM);

    // Start the dialog between the zone and the player
    dlg_Start(oPlayer, oZone, sScript, iMakeprivate, iNoHello, iNoZoom);
}
