/*
Filename:           dlg_item
System:             Dynamic Dialog System (Hook-in script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:

An item's onActivation conversation starter. It uses the item's properties for
parameters. This references a dialog script that is specified as an item's property.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "dlg_i_tools"

// Note: OBJECT_SELF is neither the item nor the player!
void main()
{
    object oPlayer = GetItemActivator();
    object oItem = GetItemActivated();

    if ( GetIsPC(oPlayer) == FALSE || GetIsObjectValid(oItem) == FALSE ) return;

    // Get dialog script name from item.
    string sScript = GetLocalString(oItem, DLG_VARIABLE_SCRIPTNAME);
    if ( sScript == "" ) return;

    // Gets extra parameters from item.
    int iMakeprivate = GetLocalInt( oItem, DLG_VARIABLE_MAKEPRIVATE );
    int iNoHello = GetLocalInt( oItem, DLG_VARIABLE_NOHELLO );
    int iNoZoom = GetLocalInt( oItem, DLG_VARIABLE_NOZOOM );

    // Start the dialog between the item and the player
    dlg_Start( oPlayer, oItem, sScript, iMakeprivate, iNoHello, iNoZoom );
}
