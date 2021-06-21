/*
Filename:           xp_cliententer
System:             Experience (client enter event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Apr. 29, 2008
Summary:
OnClientEnter script for the experience system. This script will set all
persistent XP modifiers on the player when he logs in.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// XP system include script.
#include "xp_i_main"

void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsPC(oPC))
        return;
    if (!ss_GetDatabaseInt(XP_MODIFIERS_INITIALIZED, oPC))
        xp_BuildXPModifiers(oPC);
}
