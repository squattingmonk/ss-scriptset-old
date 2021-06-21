/*
Filename:           g_flavortextoe
System:             Generic (hook-in script)
Author:             Sherincall
Date Created:       Sept. 21st, 2008
Summary:
Trigger or area OnEnter script. This script will display floating flavor text
over the entering PC.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:
*/

#include "g_i_generic"

void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsPC(oPC))
        return;

    object oObject = OBJECT_SELF;
    ss_ReadFlavorText(oObject, oPC);
}

