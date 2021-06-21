/*
Filename:           prr_a_dmtpcdel
System:             Persistent Reputation & Reaction (prr_dmtool conversation action)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Feb. 4th, 2009
Summary:
PRR DM Tool action script that deletes the current NPC target.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "prr_i_main"

void main()
{
    object oDM = OBJECT_SELF;
    DeleteLocalObject(oDM, PRR_DM_TOOL_CURRENT_TARGET);
    DeleteLocalObject(oDM, PRR_DM_TOOL_NEXT_TARGET);
    DeleteLocalObject(oDM, PRR_DM_TOOL_PREVIOUS_TARGET);
}

