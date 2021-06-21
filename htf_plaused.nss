/*
Filename:           htf_plaused
System:             Hunger, Thirst, & Fatigue (placeable used event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
Placeable OnUsed script for the HTF system. This script should be attached to a
placeable that acts as a source of food or drink.

Make this placeable a useable, non-container and assign variables to it in the
same way that you would assign variables to an htf_fooditem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// HTF system include script.
#include "htf_i_main"

void main()
{
    object oPC = GetLastUsedBy();
    object oItem = OBJECT_SELF;
    SendMessageToPC(oPC, HTF_TEXT_TAKE_A_DRINK);
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
    htf_ConsumeFoodItem(oPC, oItem);
}
