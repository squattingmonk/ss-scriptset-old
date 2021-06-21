/*
Filename:           rest_trigexit
System:             Rest (trigger exit event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
Trigger OnExit script for the Rest system. This script unsets itself as a local
object on the exiting PC.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "rest_i_main"

void main()
{
    object oPC = GetExitingObject();
    DeleteLocalObject(oPC, REST_TRIGGER);
}
