/*
Filename:           bd_respawn
System:             Bleeding and Death (player respawn event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 11, 2009
Summary:
OnPlayerRespawn script for the Bleeding and Death system. It pops up the death
GUI.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "bd_i_main"

void main()
{
    object oPC = GetLastRespawnButtonPresser();
    bd_DoRespawn(oPC);
}
