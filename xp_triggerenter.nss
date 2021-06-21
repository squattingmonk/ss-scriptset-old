/*
Filename:           xp_triggerenter
System:             Experience (trigger enter event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       May. 13, 2008
Summary:
Trigger OnEnter script for the experience system. This script will award
discovery XP to a player when he enters the trigger for the first time.

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

    string sTag = GetTag(OBJECT_SELF);

    if (!ss_GetDatabaseInt(XP_TRIGGER_EXPLORED_PREFIX + sTag, oPC))
    {
        xp_AwardDiscoveryXP(oPC);
        SendMessageToPC(oPC, XP_TEXT_DISCOVERED_SOMETHING_NEW);
        ss_SetDatabaseInt(XP_TRIGGER_EXPLORED_PREFIX + sTag, 1, oPC);
    }
}
