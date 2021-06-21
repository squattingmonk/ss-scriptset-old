/*
Filename:           bd_respawntimer
System:             Bleeding and Death (timer script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 14, 2009
Summary:
Simulates blood loss for a dying player character.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "bd_i_main"

void main()
{
    object oPC = OBJECT_SELF;
    bd_DoRespawn(oPC);
}

