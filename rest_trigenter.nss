/*
Filename:           rest_trigenter
System:             Rest (trigger enter event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
Trigger OnEnter script for the Rest system. This should be attached to a trigger
that defines an allowable resting zone.

Paint the trigger on the ground and assign variables to it as listed below:

Setting an integer variable named REST_IGNORE_MINIMUM_REST_TIME to 1 will cause
the minimum rest time restrictin to be ignored if a PC rests inside the trigger.

Set a string variable named REST_FEEDBACK to a text message that you want
displayed to the PC when he rests inside the trigger.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "rest_i_main"

void main()
{
    object oPC = GetEnteringObject();
    string sMessage = GetLocalString(OBJECT_SELF, REST_FEEDBACK);
    SetLocalObject(oPC, REST_TRIGGER, OBJECT_SELF);

    if (sMessage == "")
        sMessage = REST_TEXT_FEEDBACK;

    SendMessageToPC(oPC, sMessage);

}
