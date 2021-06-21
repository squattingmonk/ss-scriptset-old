/*
Filename:           htf_triggerenter
System:             Hunger, Thirst, & Fatigue (trigger enter event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
Trigger OnEnter script for the HTF system. This script should be attached to a
trigger that acts as a canteen source of food or drink.

Paint the trigger on the ground and assign variables to it in the same way that
you would assign variables to an htf_fooditem.

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
    object oPC = GetEnteringObject();
    SetLocalObject(oPC, HTF_TRIGGER, OBJECT_SELF);
}
