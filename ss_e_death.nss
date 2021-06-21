/*
Filename:           ss_e_death
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7th, 2008
Summary:
OnPlayerDeath event hook-in script. Place this script on the OnPlayerDeath event
under Module Properties.

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
    object oPC = GetLastPlayerDied();
    object oKiller = GetLastHostileActor(oPC);

    SetLocalLocation(oPC, SS_LOCATION_LAST_DIED, GetLocation(oPC));
    ss_SetDatabaseInt(SS_PLAYER_STATE, SS_PLAYER_STATE_DEAD, oPC);
    ss_RemoveEffects(oPC);

    string sDeathLog = GetName(oPC) + "_" + GetPCPlayerName(oPC)
                       + SS_TEXT_PLAYER_HAS_DIED + GetName(oKiller);

    if (GetIsPC(oKiller))
        sDeathLog += "_" + GetName(oKiller) + "_" + GetPCPlayerName(oKiller);

    sDeathLog += SS_TEXT_PLAYER_HAS_DIED2 + GetName(GetArea(oPC));
    WriteTimestampedLogEntry(sDeathLog);
    SendMessageToAllDMs(sDeathLog);

    SendMessageToPC(oPC, SS_TEXT_YOU_HAVE_DIED);

    ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_PLAYER_DEATH);
}
