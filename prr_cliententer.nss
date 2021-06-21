/*
Filename:           prr_cliententer
System:             Persistent Reputation and Reaction (client enter event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 02, 2009
Summary:
OnClientEnter script for the PRR system. This script will load all the player's
faction adjustments when he logs in.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// PRR system include script.
#include "prr_i_main"

void main()
{
    object oPC = GetEnteringObject();
    if (GetIsPC(oPC))
        prr_LoadPCReputations(oPC);
}
