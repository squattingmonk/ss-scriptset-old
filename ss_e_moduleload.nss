/*
Filename:           ss_e_moduleload
System:             Core (event hook-in script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Dec. 21, 2008
Summary:
OnModuleLoad event hook-in script. Place this script on the OnModuleLoad event
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
    ss_InitializeDatabase();
    ss_CreateGlobalDataPoint();
    ss_RestoreSavedCalendar();
    ss_SaveServerStartTime();
    ss_StartDayClockTimers();
    ss_StartCharExportTimer();
    ss_SetColorTokens();
    SetModuleOverrideSpellscript(SS_SPELLHOOK_EVENT_SCRIPT);
    ss_RunGlobalEventScripts(SS_MODULE_EVENT_ON_MODULE_LOAD);
}
