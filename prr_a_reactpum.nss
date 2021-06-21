/*
Filename:           prr_a_reactpum
System:             Personal Reputation and Reaction (conversation action)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Nov. 28, 2007
Summary:
Increases the reaction of the NPC to the PC's party by the mid amount in prr_c_main.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "prr_i_main"

void main()
{
    object oPC = GetPCSpeaker();
    prr_AdjustPartyExternalReputation(OBJECT_SELF, oPC, PRR_SHIFT_MID);
}
