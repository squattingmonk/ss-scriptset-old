/*
Filename:           default
System:             Core (event hook-in script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       March 13, 2009
Summary:

OnPlayerHeartBeat event script. While this event does not officially exist,
default.nss script is executed on every PC every 6 seconds and can be used as such.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Core system include script.
#include "ss_i_core"

void main()
{
     ss_RunGlobalEventScripts(SS_PSEUDO_EVENT_ON_PLAYER_HEARTBEAT);
}
