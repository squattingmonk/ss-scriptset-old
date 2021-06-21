/*
Filename:           cs_begincsoe
System:             Cut Scene system (trigger event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 04, 2008
Summary:
Area or Trigger OnEnter script: This script begins the cut scene specified in
the callers's variable list.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "cs_i_main"

void main()
{
    object oPC = GetEnteringObject();
    if (GetIsPC(oPC))
    {
        int nScene = GetLocalInt(OBJECT_SELF, CS_SCENE);
        SetLocalInt(oPC, CS_SCENE_CURRENT, nScene);
        SetLocalInt(GetModule(), CS_SCENE_CURRENT, nScene);
        ExecuteScript(CS_SCENE_PREFIX + IntToString(nScene), oPC);
    }
}
