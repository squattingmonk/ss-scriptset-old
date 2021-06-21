/*
Filename:           cs_csabort
System:             Cut Scene System (cutscene abort event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 04, 2008
Summary:
This script handles abort sequences for each of the cut scenes.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "cs_i_main"

/********************************************/
/* Intro Cut Scenes                         */
/********************************************/

void main()
{
    object oPC = GetLastPCToCancelCutscene();
    int nScene = GetLocalInt(oPC, CS_SCENE_CURRENT);

    if (!nScene)
        return;

    DeleteLocalInt(GetModule(), CS_SCENE_CURRENT);
    switch (nScene)
    {
        default: cs_StopCutscene (0.0, oPC); break;
    }
}
