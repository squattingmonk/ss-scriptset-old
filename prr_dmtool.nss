/*
Filename:           prr_dmtool
System:             Persistent Reputation and Reaction (item script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 2, 2009
Summary:
This script fires whenever the PRR dm wand is activated.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "prr_i_main"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oDM = GetItemActivator();
        if (GetIsDM(oDM))
        {
            object oTarget = GetItemActivatedTarget();
            if (GetIsObjectValid(oTarget) && !GetIsPC(oTarget))
                AssignCommand(oDM, ActionStartConversation(oTarget, PRR_DM_TOOL_DIALOG, TRUE, FALSE));
            else
                SendMessageToPC(oDM, PRR_TEXT_DM_TOOL_TARGET_INVALID);
        }
    }
}

