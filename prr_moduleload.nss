/*
Filename:           prr_moduleload
System:             Persistent Reputation and Reaction (module load event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 02, 2009
Summary:
OnModuleLoad script for the PRR system. This script will load all inter-faction
reputation changes.

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
    prr_LoadFactionReputations();
}
