/*
Filename:           xp_areaenter
System:             Experience (area enter event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Apr. 29, 2008
Summary:
Area OnEnter script for the experience system. This script will award discovery
XP to a player when he enters the area for the first time.

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
    if (XP_MODIFIER_TYPE_DISCOVERY <= 0.0 )
        return;

    object oPC = GetEnteringObject();
    object oArea = OBJECT_SELF;

    if (!GetIsPC(oPC) || GetLocalInt(oArea, XP_NO_XP))
        return;

    string sTag = GetTag(oArea);

    if (!ss_GetDatabaseInt(XP_AREA_EXPLORED_PREFIX + sTag, oPC))
    {
        xp_AwardDiscoveryXP(oPC, oArea);
        SendMessageToPC(oPC, XP_TEXT_DISCOVERED_NEW_AREA);
        ss_SetDatabaseInt(XP_AREA_EXPLORED_PREFIX + sTag, 1, oPC);
    }
}
