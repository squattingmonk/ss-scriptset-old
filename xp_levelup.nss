/*
Filename:           xp_levelup
System:             Experience (player level up event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Apr. 29, 2008
Summary:
OnPlayerLevelUp script for the experience system. This script will set all
persistent XP modifiers on the player when he levels.

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
    xp_BuildXPModifiers(GetPCLevellingUp());
}
