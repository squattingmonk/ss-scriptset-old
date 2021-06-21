/*
Filename:           ss_i_core
System:             Core (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Dec. 11, 2008
Summary:
Core system include script. This file holds the functions commonly used
throughout the core system.

The scripts contained herein are based on those included in Edward Beck's HCR2
core system and Sherincall's SHC ruleset, customized for compatibility with
Shadows & Silver's needs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Flagsets system include script
#include "ss_i_flagsets"

// X2 Switches
#include "x2_inc_switches"

//------------------------------------------------------------------------------
//                             Function Prototypes
//------------------------------------------------------------------------------

// >----< ss_Debug >----<
// <ss_i_core>
// Sends a debug message to oPC
void ss_Debug(string sMessage, object oDebugger = OBJECT_INVALID);

// ---< ss_RunGlobalEventScripts >---
// ---< ss_i_core >---
// Runs all scripts of type sEventType in order of the index set in the
// variables on the global data point. When calling this function, sEventType
// should be one of the SS_*_EVENT_* constants defined in ss_i_core.
// Original function by Edward Beck
void ss_RunGlobalEventScripts(string sEventType);

// ---< ss_RunEventScripts >---
// ---< ss_i_core >---
// Runs all scripts of type sEventType in order of the index set in the
// variables on the object. When calling this function, sEventType should be one
// of the SS_*_EVENT_* constants defined in ss_i_core. This function will run
// local scripts first and then global scripts. To prevent global scripts from
// running on the object, assign it the int variable NoGlobal_* (where * equals
// the event name referenced by sEventType) with a value of 1.
void ss_RunEventScripts(string sEventType);

// ---< ss_GetLastEvent >---
// ---< ss_i_core >---
// Returns the last event that executed on oObject. Note that this only returns
// a useful value for events calling event scripts (_e_). This is mostly used by
// hook libraries.
string ss_GetLastEvent(object oObject = OBJECT_SELF);

// ---< ss_GetSecondsSinceServerStart >---
// ---< ss_i_core >---
// Returns the number of seconds that have elapsed since the server started.
// Original function by Edward Beck
int ss_GetSecondsSinceServerStart();

// ---< ss_CreateTimer >---
// ---< ss_i_core >---
// Creates a timer and returns an integer representing its unique ID.
// - oScriptObject: the object sScriptName will run on.
// - sScriptName: the script that will fire when the set time has elapsed
// - fInterval: the number of seconds that must elapse before sScriptName is executed
// - Note: save the returned timerID somewhere so that it can be accessed and used to
//   stop, start or kill the timer later. If oScriptObject has become invalid or if
//   oScriptObject was a PC and that PC has logged off, then instead of executing the
//   timer script, it will kill the timer instead. After a timer is created you will
//   need to start it to get it to run. You cannot create a timer on an invalid
//   oScriptObject or with a non-positive interval value.
//   A returned timerID of 0 means the timer was not created.
int ss_CreateTimer(object oScriptObject, string sScriptName, float fInterval);

// ---< ss_StopTimer >---
// ---< ss_i_core >---
// Suspends execution of the timer script associated with the value of nTimerID.
// This does not kill the timer, only stops its script from being executed.
void ss_StopTimer(int nTimerID);

// ---< ss_KillTimer >---
// ---< ss_i_core >---
// Kills the timer associated with the value of nTimerID. This results in all
// information abut the given timer ID being deleted. Since the information is
// gone, the script associated with that timer ID will not get executed again.
// There is a delay built into this; when the next interval for the given timer
// ID elapses, that is when the timer is killed rather than the timer's script
// being executed.
void ss_KillTimer(int nTimerID);

// ---< ss_TimerElapsed >---
// ---< ss_i_core >---
// Runs when the timer associated with nTimerID elapses, either executing the
// timer script or (if the timer object is invalid) killing the timer.
void ss_TimerElapsed(int nTimerID);

// ---< ss_StartTimer >---
// ---< ss_i_core >---
// Starts a timer, executing its script immediately, and again each interval
// period unless it is stopped or killed.
void ss_StartTimer(int nTimerID);

// ---< ss_RunElapsedTimers >---
// ---< ss_i_core >---
// Runs all the timers scheduled for the next heartbeat.
void ss_RunElapsedTimers();

// ---< ss_RunTagBasedScript >---
// ---< ss_i_core >---
// Runs the tag-based script for oItem and nEventType. If oItem is a generic
// resource, its tag is converted into a generic script by replacing the ss_
// prefix with g_. Returns 1 if the event should end after calling the script.
int ss_RunTagBasedScript(object oItem, int nEventType);

// ---< ss_RestoreSavedCalendar >---
// ---< ss_i_core >---
// Sets the current game date and time to the date and time values last saved in
// the external database.
void ss_RestoreSavedCalendar();

// ---< ss_SaveCurrentCalendar >---
// ---< ss_i_core >---
// Saves the current in game month, day, year, hour and minute to the database.
void ss_SaveCurrentCalendar();

// ---< ss_SaveServerStartTime >---
// ---< ss_i_core >---
// Saves the current date and time as the server start time. Used in calculating
// the elapsed time passed for timers and various other effects. Call this after
// the game date and time has been restored with ss_RestoreSavedCalendar.
void ss_SaveServerStartTime();

// ---< ss_StartDayClockTimers >---
// ---< ss_i_core >---
// Starts timers to detect when dawn and dusk arrive. Call this after
// the server start time has been saved with ss_SaveServerstartTime.
void ss_StartDayClockTimers();

// ---< ss_BootPC >---
// ---< ss_i_core >---
// Sends sMessage to oPC and all DMs letting them know why oPC is being booted,
// then boots oPC after fDelay seconds.
// Original function by Edward Beck
void ss_BootPC(object oPC, string sMessage = "", float fDelay = 6.0);

// ---< ss_CreatePlayerDataItem >---
// ---< ss_i_core >---
// Creates a player data item on oPC if he doens't already have one.
// Original function by Edward Beck
void ss_CreatePlayerDataItem(object oPC);

// ---< ss_SetPCID >---
// ---< ss_i_core >---
// Sets a PCID on oPC if he doesn't have a valid one. If oPC does have a PCID,
// but it's not associated with him, it will reset his PCID and issue a warning
// to let the admins know about possible exploits.
// Original function by Edward Beck
void ss_SetPCID(object oPC);

// ---< ss_InitializePC >---
// ---< ss_i_core >---
// Performs important set up functions on the PC. On first login, will give the
// player a data item, register him in the database, and strip him if necessary.
// If oPC is a DM, this function will give him DM tools.
// Original function by Edward Beck
void ss_InitializePC(object oPC);

// ---< ss_RemoveEffects >---
// ---< ss_i_core >---
// Removes all effects from object oPC. If oPC in invalid, this does nothing.
// Original function by Edward Beck
void ss_RemoveEffects(object oPC);

// ---< ss_GetAllowRest >---
// ---< ss_i_core >---
// Gets whether oPC is allowed to rest.
// Original function by Edward Beck
int ss_GetAllowRest(object oPC);

// ---< ss_SetAllowRest >---
// ---< ss_i_core >---
// Sets whether oPC is allowed to rest to bAllowRest.
// Original function by Edward Beck
void ss_SetAllowRest(object oPC, int bAllowRest);

// ---< ss_GetAllowFeatRecovery >---
// ---< ss_i_core >---
// Returns whether oPC is allowed to recover featss on rest.
// Original function by Edward Beck
int ss_GetAllowFeatRecovery(object oPC);

// ---< ss_GetAllowSpellRecovery >---
// ---< ss_i_core >---
// Returns whether oPC is allowed to recover spells on rest.
// Original function by Edward Beck
int ss_GetAllowSpellRecovery(object oPC);

// ---< ss_SetAllowFeatRecovery >---
// ---< ss_i_core >---
// Sets whether oPC is allowed to recover feats on rest.
// Original function by Edward Beck
void ss_SetAllowFeatRecovery(object oPC, int bAllowRecovery);

// ---< ss_SetAllowSpellRecovery >---
// ---< ss_i_core >---
// Sets whether oPC is allowed to recover spells on rest.
// Original function by Edward Beck
void ss_SetAllowSpellRecovery(object oPC, int bAllowRecovery);

// ---< ss_GetPostRestHealAmount >---
// ---< ss_i_core >---
// Returns the amount oPC is supposed to heal on rest.
// Original function by Edward Beck
int ss_GetPostRestHealAmount(object oPC);

// ---< ss_SetPostRestHealAmount >---
// ---< ss_i_core >---
// Sets the amount oPC is supposed to heal on rest to nAmount.
// Original function by Edward Beck
void ss_SetPostRestHealAmount(object oPC, int nAmount);

// ---< ss_AddRestMenuItem >---
// ---< ss_i_core >---
// Adds an item called sMenuText to oPC's rest menu which fires sActionScript.
// Original function by Edward Beck
void ss_AddRestMenuItem(object oPC, string sMenuText, string sActionScript = SS_REST_MENU_DEFAULT_ACTION_SCRIPT);

// ---< ss_SetAllowRest >---
// ---< ss_i_core >---
// Opens the rest dialog for oPC.
// Original function by Edward Beck
void ss_OpenRestDialog(object oPC);

// ---< ss_SaveAvailableFeats >---
// ---< ss_i_core >---
// Saves oPC's available feats.
// Original function by Edward Beck
void ss_SaveAvailableFeats(object oPC);

// ---< ss_SaveAvailableSpells >---
// ---< ss_i_core >---
// Saves oPC's available spells.
// Original function by Edward Beck
void ss_SaveAvailableSpells(object oPC);

// ---< ss_LimitPostRestHeal >---
// ---< ss_i_core >---
// Resets oPC's hit points so he only heals nPostRestHealAmount after resting.
// Original function by Edward Beck
void ss_LimitPostRestHeal(object oPC, int nPostRestHealAmount);

// ---< ss_MakePCRest >---
// ---< ss_i_core >---
// Makes oPC rest, skipping the rest dialog.
// Original function by Edward Beck
void ss_MakePCRest(object oPC);

// ---< ss_SetAvailableFeatsToSavedValues >---
// ---< ss_i_core >---
// Returns oPC's available feats to the ones available before resting.
// Original function by Edward Beck
void ss_SetAvailableFeatsToSavedValues(object oPC);

// ---< ss_SetAvailableSpellsToSavedValues >---
// ---< ss_i_core >---
// Returns oPC's available spells to the ones available before resting.
// Original function by Edward Beck
void ss_SetAvailableSpellsToSavedValues(object oPC);

// >----< ss_SetIntPCID >----<
// <ss_i_core>
// Set the PC unique identifier
// HCR2 PC unique ID is a HexString. This is a plain integer.
void ss_SetIntPCID(object oPC);

// >----< ss_GetIntPCID >----<
// <ss_i_core>
// Returns the oPC's unique identifier number
// HCR2 PC unique ID is a HexString. This is a plain integer.
int ss_GetIntPCID(object oPC);


//------------------------------------------------------------------------------
//                          Function Implementations
//------------------------------------------------------------------------------

// Begin general functions
void ss_Debug(string sMessage, object oDebugger = OBJECT_INVALID)
{
    if(!SS_DEBUG_MODE)
        return;
    if (oDebugger == OBJECT_INVALID)
        oDebugger = GetFirstPC();
    ss_FloatingColorText(sMessage, oDebugger, FALSE, COLOR_DEBUG);
    WriteTimestampedLogEntry(sMessage);
}

void ss_RunAutoHook(object oObject = OBJECT_SELF)
{
    int nIndex = 1;
    string sScriptName = GetLocalString(oObject, SS_PSEUDO_EVENT_ON_HOOK + IntToString(nIndex));

    while (sScriptName != "")
    {
        ExecuteScript(sScriptName, oObject);
        sScriptName = GetLocalString(oObject, SS_PSEUDO_EVENT_ON_HOOK + IntToString(++nIndex));
    }
}

void ss_RunGlobalEventScripts(string sEventType)
{
    object oObject = OBJECT_SELF;
    object oDatapoint = ss_GetGlobalDataPoint();

    // Run the auto-hook.
    // Set the last event called so we can retrieve it from hook libraries.
    SetLocalString(oObject, SS_LAST_EVENT, sEventType);
    if (!GetLocalInt(oObject, SS_NO_AUTO_HOOK_SCRIPTS + sEventType))
        ss_RunAutoHook(oDatapoint);

    // Now, run our global hooks.
    int nIndex = 1;
    string sScriptName = GetLocalString(oDatapoint, sEventType + IntToString(nIndex));

    while (sScriptName != "")
    {
        ExecuteScript(sScriptName, oObject);
        nIndex++;
        sScriptName = GetLocalString(oDatapoint, sEventType + IntToString(nIndex));
    }
}

void ss_RunEventScripts(string sEventType)
{
    object oObject = OBJECT_SELF;

    // Run the auto-hook.
    // Set the last event called so we can retrieve it from hook libraries.
    SetLocalString(oObject, SS_LAST_EVENT, sEventType);
    if (!GetLocalInt(oObject, SS_NO_AUTO_HOOK_SCRIPTS + sEventType))
        ss_RunAutoHook(oObject);

    // Run the local hooks.
    int nIndex = 1;
    string sScriptName = GetLocalString(oObject, sEventType + IntToString(nIndex));
    while (sScriptName != "")
    {
        ExecuteScript(sScriptName, oObject);
        nIndex++;
        sScriptName = GetLocalString(oObject, sEventType + IntToString(nIndex));
    }

    // Finally, run the global hooks.
    if (!GetLocalInt(oObject, SS_NO_GLOBAL_EVENT_SCRIPTS + sEventType))
        ss_RunGlobalEventScripts(sEventType);
}

string ss_GetLastEvent(object oObject = OBJECT_SELF)
{
    return GetLocalString(oObject, SS_LAST_EVENT);
}

int ss_GetSecondsSinceServerStart()
{
    // Get start date and time
    object oData    = ss_GetGlobalDataPoint();
    int nStartTime  = GetLocalGroupFlagValue(oData, SS_SERVER_START_TIME, ALLGROUPS);
    int nStartYear  = GetGroupFlagValue(nStartTime, SS_SERVER_START_YEAR);
    int nStartMonth = GetGroupFlagValue(nStartTime, SS_SERVER_START_MONTH);
    int nStartDay   = GetGroupFlagValue(nStartTime, SS_SERVER_START_DAY);
    int nStartHour  = GetGroupFlagValue(nStartTime, SS_SERVER_START_HOUR);

    /* Old implementation
    int nStartYear  = ss_GetGlobalInt(SS_SERVER_START_YEAR);
    int nStartMonth = ss_GetGlobalInt(SS_SERVER_START_MONTH);
    int nStartDay   = ss_GetGlobalInt(SS_SERVER_START_DAY);
    int nStartHour  = ss_GetGlobalInt(SS_SERVER_START_HOUR);
    */

    // Get current date and time
    int nCurrentYear  = GetCalendarYear();
    int nCurrentMonth = GetCalendarMonth();
    int nCurrentDay   = GetCalendarDay();
    int nCurrentHour  = GetTimeHour();
    int nCurrentMin   = GetTimeMinute();
    int nCurrentSec   = GetTimeSecond();

    // Get the real time to game Time Conversion Factor (TCF)
    int nTCF = FloatToInt(HoursToSeconds(1));

    // Calculate difference between now and then
    int nElapsed = nCurrentYear - nStartYear;                        // years
    nElapsed = (nElapsed * 12) + (nCurrentMonth - nStartMonth);      // to months
    nElapsed = (nElapsed * 28) + (nCurrentDay - nStartDay);          // to days
    nElapsed = (nElapsed * 24) + (nCurrentHour - nStartHour);        // to hours
    nElapsed = (nElapsed * nTCF) + (nCurrentMin * 60) + nCurrentSec; // to seconds

    // return the total
    return nElapsed;
}

int ss_CreateTimer(object oScriptObject, string sScriptName, float fInterval)
{
    if (!GetIsObjectValid(oScriptObject))
    {
        string sMessage  = "Warning cannot create " + sScriptName + " timer on invalid script object.";
        SendMessageToAllDMs(sMessage);
        WriteTimestampedLogEntry(sMessage);
        return 0;
    }
    if (fInterval <= 0.0)
    {
        string sMessage  = "Warning cannot create " + sScriptName + " timer with interval of " + FloatToString(fInterval);
        SendMessageToAllDMs(sMessage);
        WriteTimestampedLogEntry(sMessage);
        return 0;
    }

    int nTimerID = ss_GetGlobalInt(SS_NEXT_TIMER_ID) + 1;
    ss_SetGlobalInt(SS_NEXT_TIMER_ID, nTimerID + 1);

    if (GetIsPC(oScriptObject))
        SetLocalInt(oScriptObject, SS_TIMER_OBJECT_IS_PC, TRUE);

    ss_SetGlobalString(SS_TIMER_SCRIPT + IntToString(nTimerID), sScriptName);
    ss_SetGlobalObject(SS_TIMER_OBJECT + IntToString(nTimerID), oScriptObject);
    ss_SetGlobalFloat(SS_TIMER_INTERVAL + IntToString(nTimerID), fInterval);

    return nTimerID;
}

void ss_StopTimer(int nTimerID)
{
    object oTimerObject = ss_GetGlobalObject(SS_TIMER_OBJECT + IntToString(nTimerID));
    DeleteLocalInt(oTimerObject, SS_TIMER_IS_RUNNING + IntToString(nTimerID));
}

void ss_KillTimer(int nTimerID)
{
    ss_DeleteGlobalString(SS_TIMER_SCRIPT + IntToString(nTimerID));
    ss_DeleteGlobalObject(SS_TIMER_OBJECT + IntToString(nTimerID));
    ss_DeleteGlobalFloat(SS_TIMER_INTERVAL + IntToString(nTimerID));
}

void ss_TimerElapsed(int nTimerID)
{
    string sTimerID = IntToString(nTimerID);
    string sTimerScript = ss_GetGlobalString(SS_TIMER_SCRIPT + sTimerID);
    object oTimerObject = ss_GetGlobalObject(SS_TIMER_OBJECT + sTimerID);
    float fTimerInterval = ss_GetGlobalFloat(SS_TIMER_INTERVAL + sTimerID);

    if (GetIsObjectValid(oTimerObject) && fTimerInterval > 0.0)
    {
        if (!GetLocalInt(oTimerObject, SS_TIMER_IS_RUNNING + sTimerID))
            return;

        if (GetLocalInt(oTimerObject, SS_TIMER_OBJECT_IS_PC) && !GetIsPC(oTimerObject))
        {
            ss_KillTimer(nTimerID);
            return;
        }

        ExecuteScript(sTimerScript, oTimerObject);

        string sTimestamp = IntToString(ss_GetSecondsSinceServerStart() + FloatToInt(fTimerInterval));
        int nIndex = 1;
        int nStored = ss_GetGlobalInt(SS_TIMESTAMP + sTimestamp + "_" + IntToString(nIndex));
        while (nStored != 0)
        {
            nStored = ss_GetGlobalInt(SS_TIMESTAMP + sTimestamp + "_" + IntToString(++nIndex));
        }

        ss_SetGlobalInt(SS_TIMESTAMP + sTimestamp + "_" + IntToString(nIndex), nTimerID);
    }
    else
        ss_KillTimer(nTimerID);
}

void ss_StartTimer(int nTimerID)
{
    string sTimerID = IntToString(nTimerID);
    object oTimerObject = ss_GetGlobalObject(SS_TIMER_OBJECT + sTimerID);
    SetLocalInt(oTimerObject, SS_TIMER_IS_RUNNING + sTimerID, 1);
    ss_TimerElapsed(nTimerID);
}

void ss_RunElapsedTimers()
{
    int nCurrentTimestamp = ss_GetSecondsSinceServerStart();
    int i;

    for (i = 0; i < 6; i++)
    {
        int nIndex = 1;
        int nTimerID = ss_GetGlobalInt(SS_TIMESTAMP + IntToString(nCurrentTimestamp + i) + "_" + IntToString(nIndex));

        while (nTimerID != 0)
        {
            string sTimerID = IntToString(nTimerID);
            object oTimerObject = ss_GetGlobalObject(SS_TIMER_OBJECT + sTimerID);
            float fDelay = ss_GetGlobalFloat(SS_TIMER_INTERVAL + sTimerID);
            fDelay = (fDelay - FloatToInt(fDelay)) + i;
            DelayCommand(fDelay, ss_TimerElapsed(nTimerID));
            ss_DeleteGlobalInt(SS_TIMESTAMP + IntToString(nCurrentTimestamp + i) + "_" + IntToString(nIndex));
        }

        nTimerID = ss_GetGlobalInt(SS_TIMESTAMP + IntToString(nCurrentTimestamp + i) + "_" + IntToString(++nIndex));
    }
}

int ss_RunTagBasedScript(object oItem, int nEventType)
{
    string sScript = GetTag(oItem);
    string sPrefix = GetStringLeft(sScript, 3);

    if (sPrefix == "ss_" && sScript != SS_PLAYER_DATA_ITEM)
        sScript = StringReplace(sScript, sPrefix, "g_");

    SetUserDefinedItemEventNumber(nEventType);
    return ExecuteScriptAndReturnInt(sScript, OBJECT_SELF);
}

// End general functions

// Begin module load functions
void ss_RestoreSavedCalendar()
{
    int nTime   = GetPersistentGroupFlagValue(SS_CURRENT_TIME, ALLGROUPS);
    int nYear   = GetGroupFlagValue(nTime, SS_CURRENT_YEAR);
    int nMonth  = GetGroupFlagValue(nTime, SS_CURRENT_MONTH);
    int nDay    = GetGroupFlagValue(nTime, SS_CURRENT_DAY);
    int nHour   = GetGroupFlagValue(nTime, SS_CURRENT_HOUR);

    /* Old version using separate database calls
    int nMinute = ss_GetDatabaseInt(SS_CURRENT_MINUTE);
    int nHour   = ss_GetDatabaseInt(SS_CURRENT_HOUR);
    int nDay    = ss_GetDatabaseInt(SS_CURRENT_DAY);
    int nMonth  = ss_GetDatabaseInt(SS_CURRENT_MONTH);
    int nYear   = ss_GetDatabaseInt(SS_CURRENT_YEAR);
    */

    if (nYear)
    {
        SetTime(nHour, 0, 0, 0);
        SetCalendar(nYear, nMonth, nDay);
    }
}

void ss_SaveServerStartTime()
{
    int nTime = NOFLAGS;

    nTime = SetGroupFlagValue(nTime, SS_SERVER_START_YEAR, GetCalendarYear());
    nTime = SetGroupFlagValue(nTime, SS_SERVER_START_MONTH, GetCalendarMonth());
    nTime = SetGroupFlagValue(nTime, SS_SERVER_START_HOUR, GetCalendarDay());
    nTime = SetGroupFlagValue(nTime, SS_SERVER_START_DAY, GetTimeHour());
    SetLocalGroupFlagValue(ss_GetGlobalDataPoint(), SS_SERVER_START_TIME, ALLGROUPS, nTime);

    /* Old implementation
    ss_SetGlobalInt(SS_SERVER_START_HOUR, GetTimeHour());
    ss_SetGlobalInt(SS_SERVER_START_DAY, GetCalendarDay());
    ss_SetGlobalInt(SS_SERVER_START_MONTH, GetCalendarMonth());
    ss_SetGlobalInt(SS_SERVER_START_YEAR, GetCalendarYear());
    */
}

void ss_StartDayClockTimers()
{
    int nCurrentHour = GetTimeHour();
    int nDawnTimer = ss_CreateTimer(GetModule(), SS_ON_DAWN_SCRIPT, HoursToSeconds(24));
    int nDuskTimer = ss_CreateTimer(GetModule(), SS_ON_DUSK_SCRIPT, HoursToSeconds(24));
    float fSecondsToDawn = HoursToSeconds(SS_SERVER_DAWN_TIME + (24 - nCurrentHour));
    float fSecondsToDusk = HoursToSeconds(SS_SERVER_DUSK_TIME + (24 - nCurrentHour));

    DelayCommand(fSecondsToDawn, ss_StartTimer(nDawnTimer));
    DelayCommand(fSecondsToDusk, ss_StartTimer(nDuskTimer));
}

void ss_StartCharExportTimer()
{
    if (SS_EXPORT_CHARACTERS_INTERVAL > 0.0)
    {
        int nTimerID = ss_CreateTimer(GetModule(), SS_EXPORT_CHAR_TIMER_SCRIPT, SS_EXPORT_CHARACTERS_INTERVAL);
        ss_StartTimer(nTimerID);
    }
}

void ss_AddPlayerMenuItem(string sMenuText, string sDialogResRef)
{
     if (sMenuText == "")
        return;
    int nIndex = ss_GetGlobalInt(SS_PLAYER_MENU_INDEX) + 1;
    if (nIndex <= 5)
    {
        ss_SetGlobalInt(SS_PLAYER_MENU_INDEX, nIndex);
        ss_SetGlobalString(SS_PLAYER_MENU_ITEM_TEXT + IntToString(nIndex), sMenuText);
        ss_SetGlobalString(SS_DIALOG_RESREF + IntToString(nIndex), sDialogResRef);
    }
    else
        WriteTimestampedLogEntry("Player Data Menu Item: " + sMenuText + " exceeded maximum allowed.");
}
// End module load functions


// Begin client enter functions
void ss_BootPC(object oPC, string sMessage = "", float fDelay = 6.0)
{
    string sPCMessage = SS_TEXT_BOOT_PC + sMessage;
    string sDMMessage = GetPCPlayerName(oPC) + "_" + GetName(oPC) + SS_TEXT_BOOT_DM + sMessage;

    SendMessageToPC(oPC, sPCMessage);
    SendMessageToAllDMs(sDMMessage);
    WriteTimestampedLogEntry(sDMMessage);
    BootPC(oPC);
}

void ss_CreatePlayerDataItem(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;

    object oData = GetItemPossessedBy(oPC, SS_PLAYER_DATA_ITEM);
    if (!GetIsObjectValid(oData))
    {
        oData = CreateItemOnObject(SS_PLAYER_DATA_ITEM, oPC);
        if (!GetIsObjectValid(oData))
            ss_Debug(SS_TEXT_ERROR_PLAYER_DATA_ITEM_NOT_CREATED, oPC);
        else
            ss_Debug(SS_TEXT_PLAYER_DATA_ITEM_CREATED, oPC);
    }
}

// >----< Internal function for ss_SetPCID >----<
// <ss_i_core>
string ss_GetNewPCID()
{
    int nNextPCID = ss_GetDatabaseInt(SS_NEXT_PCID);
    string sPCID  = IntToHexString(nNextPCID);

    ss_SetDatabaseInt(SS_NEXT_PCID, ++nNextPCID);
    return sPCID;
}

// >----< Internal function for ss_SetPCID >----<
// <ss_i_core>
void ss_RegisterPlayer(object oPC)
{
    string sPlayer = GetPCPlayerName(oPC);
    string sCDKey = GetPCPublicCDKey(oPC);
    string sIPAddress = GetPCIPAddress(oPC);
    string sSQL = "SELECT * FROM players WHERE Player='" + sPlayer
                  + "' AND CDKey='" + sCDKey + "' AND IPAddress='" + sIPAddress + "'";

    SQLExecDirect(sSQL);
    if (SQLFetch() == SQL_SUCCESS)
        return;

    sSQL = "INSERT INTO players (Player, CDKey, IPAddress) VALUES('" + sPlayer
           + "', '" + sCDKey + "', '" + sIPAddress + "')";
    SQLExecDirect(sSQL);
}

// >----< Internal function for ss_SetPCID >----<
// <ss_i_core>
void ss_RegisterCharacter(object oPC)
{
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    string sName = GetName(oPC);
    string sPlayer = GetPCPlayerName(oPC);
    string sSQL = "REPLACE INTO characters (PCID, Name, Player) Values('"
                  + sPCID + "', '" + sName + "', '" + sPlayer + "')";
    SQLExecDirect(sSQL);
}

// >----< Internal function for ss_SetPCID >----<
// <ss_i_core>
string ss_GetPlayerNameByPCID(object oPC)
{
    string sReturn;
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    string sSQL = "SELECT Player FROM characters WHERE PCID='" + sPCID + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch())
        sReturn = SQLGetData(1);

    return sReturn;
}

// >----< Internal function for ss_SetPCID >----<
// <ss_i_core>
string ss_GetCharacterNameByPCID(object oPC)
{
    string sReturn;
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    string sSQL = "SELECT Name FROM characters WHERE PCID='" + sPCID + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch())
        sReturn = SQLGetData(1);

    return sReturn;
}

void ss_SetPCID(object oPC)
{
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);

    if (sPCID == "")
    {
        sPCID = ss_GetNewPCID();
        ss_SetPlayerString(oPC, SS_PCID, sPCID);
        ss_RegisterPlayer(oPC);
        ss_RegisterCharacter(oPC);
    }
    else
    {
        string sName = GetName(oPC);
        string sPlayer = GetPCPlayerName(oPC);
        string sSavedName = ss_GetCharacterNameByPCID(oPC);
        string sSavedPlayer = ss_GetPlayerNameByPCID(oPC);

        if (sName != sSavedName || sPlayer != sSavedPlayer)
        {
            string sMessage = sName + "_" + sPlayer + SS_TEXT_WARNING_INVALID_PCID
                              + sSavedName + "_" + sSavedPlayer + SS_TEXT_WARNING_ASSIGNING_NEW_PCID;
            SendMessageToPC(oPC, ss_GetStringColored(sMessage, COLOR_ATTENTION));
            SendMessageToAllDMs(ss_GetStringColored(sMessage, COLOR_ATTENTION));
            WriteTimestampedLogEntry(sMessage);
            sPCID = ss_GetNewPCID();
            ss_SetPlayerString(oPC, SS_PCID, sPCID);
            ss_RegisterPlayer(oPC);
            ss_RegisterCharacter(oPC);
        }
    }


    // [Sherincall] Hook for Integer PC IDs
    if (ss_GetIntPCID(oPC) == 0)
        ss_SetIntPCID(oPC);
}

// >----< Internal function for ss_InitializePC >----<
// <ss_i_core>
void ss_StripOnFirstLogin()
{

}

// >----< Internal function for ss_InitializePC >----<
// <ss_i_core>
void ss_SendPCToSavedLocation(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    int bLoggedInThisReset = ss_GetGlobalInt(sPCID + SS_HAS_LOGGED_IN);
    if (!bLoggedInThisReset && SS_SAVE_PC_LOCATION)
    {
        location lTarget = ss_GetDatabaseLocation(SS_PLAYER_LOCATION, oPC);
        object oArea = GetAreaFromLocation(lTarget);

        if (GetIsObjectValid(oArea))
            SendMessageToPC(oPC, SS_TEXT_SENDING_TO_SAVED_LOCATION);
        else
        {
            lTarget = GetLocation(GetWaypointByTag(SS_PLAYER_LOUNGE));
            SendMessageToPC(oPC, SS_TEXT_NO_SAVED_LOCATION_FOUND);
        }

        DelayCommand(SS_CLIENT_ENTER_JUMP_DELAY, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
    }
}

// >----< Internal function for ss_InitializePC >----<
// <ss_i_core>
void ss_SetPlayerHitPointsToSavedValue(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    int nCurrentHP = GetCurrentHitPoints(oPC);
    int nSavedHP = GetLocalInt(oPC, SS_PLAYER_HP);
    int nDamage = nCurrentHP - nSavedHP;
    if (nDamage < nCurrentHP && nDamage > 0)
    {
        effect eDamage = EffectDamage(nDamage);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
    }
}

void ss_InitializePC(object oPC)
{
    // Fix some exploits
    SetPlotFlag(oPC, FALSE);
    SetImmortal(oPC, FALSE);

    // If the player is supposed to be dead, kill him and abort
    if (ss_GetDatabaseInt(SS_PLAYER_STATE, oPC) != SS_PLAYER_STATE_ALIVE)
    {
        DelayCommand(SS_CLIENT_ENTER_JUMP_DELAY, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC));
        return;
    }

    // If we are stripping the PC, do so
    if (SS_STRIP_ON_FIRST_LOGIN)
        ss_StripOnFirstLogin();

    // Set the PC's hit points to their saved value
    int nHitPoints = GetLocalInt(oPC, SS_PLAYER_HP);
    if (nHitPoints < GetMaxHitPoints(oPC) && nHitPoints > 0)
        ss_SetPlayerHitPointsToSavedValue(oPC);

    // If the PC is polymorphed, remove its effects
    if (GetRacialType(oPC) > 6)
    {
        effect eEffect = GetFirstEffect(oPC);
        while (GetEffectType(eEffect)!= EFFECT_TYPE_INVALIDEFFECT)
        {
            if (GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH || GetEffectType(eEffect) == EFFECT_TYPE_TEMPORARY_HITPOINTS)
                RemoveEffect(oPC, eEffect);
            eEffect = GetNextEffect(oPC);
        }
    }

    // Send the PC to his saved location and mark him as logging in this reset
    ss_SendPCToSavedLocation(oPC);

    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    ss_SetGlobalInt(sPCID + SS_HAS_LOGGED_IN, TRUE);

    // If saving PC locations, start the save location timer
    if (SS_SAVE_PC_LOCATION)
    {
        int nTimerID = ss_CreateTimer(oPC, SS_SAVE_LOCATION_SCRIPT, SS_SAVE_PC_LOCATION_INTERVAL);
        ss_StartTimer(nTimerID);
    }
}

void ss_SetPCLoggedIn(object oPC, int bLoggedIn)
{
    string sPCID = ss_GetPlayerString(oPC, SS_PCID);
    string sSQL = "UPDATE characters SET Online=" + IntToString(bLoggedIn) + " WHERE PCID='" + sPCID + "'";
    SQLExecDirect(sSQL);
}
// End client enter functions

// Begin client leave functions
void ss_SaveHitPoints(object oPC)
{
    int nHitPoints = GetCurrentHitPoints(oPC);
    SetLocalInt(oPC, SS_PLAYER_HP, nHitPoints);
}
// End client leave functions

// Begin heartbeat functions
void ss_SaveCurrentCalendar()
{
    int nTime = NOFLAGS;

    nTime = SetGroupFlagValue(nTime, SS_CURRENT_YEAR, GetCalendarYear());
    nTime = SetGroupFlagValue(nTime, SS_CURRENT_MONTH, GetCalendarMonth());
    nTime = SetGroupFlagValue(nTime, SS_CURRENT_HOUR, GetCalendarDay());
    nTime = SetGroupFlagValue(nTime, SS_CURRENT_DAY, GetTimeHour());
    SetPersistentGroupFlagValue(SS_CURRENT_TIME, ALLGROUPS, nTime);

    /* Old implementation
    int nMinute = GetTimeMinute();
    int nHour   = GetTimeHour();
    int nDay    = GetCalendarDay();
    int nMonth  = GetCalendarMonth();
    int nYear   = GetCalendarYear();

    ss_SetDatabaseInt(SS_CURRENT_MINUTE, nMinute);
    ss_SetDatabaseInt(SS_CURRENT_HOUR, nHour);
    ss_SetDatabaseInt(SS_CURRENT_DAY, nDay);
    ss_SetDatabaseInt(SS_CURRENT_MONTH, nMonth);
    ss_SetDatabaseInt(SS_CURRENT_YEAR, nYear);
    */
}

void ss_SavePCLocation(object oPC)
{
    location lLocation = GetLocation(oPC);
    ss_SetDatabaseLocation(SS_PLAYER_LOCATION, lLocation, oPC);
}

// End heartbeat functions

// Begin player death functions
void ss_RemoveEffects(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;

    effect eEffect = GetFirstEffect(oPC);
    while (GetEffectType(eEffect) != EFFECT_TYPE_INVALIDEFFECT)
    {
        RemoveEffect(oPC, eEffect);
        eEffect = GetNextEffect(oPC);
    }
}
// End player death functions

// Begin player rest functions
int ss_GetAllowRest(object oPC)
{
    return GetLocalInt(oPC, SS_ALLOW_REST);
}

void ss_SetAllowRest(object oPC, int bAllowRest)
{
    SetLocalInt(oPC, SS_ALLOW_REST, bAllowRest);
}

int ss_GetAllowFeatRecovery(object oPC)
{
    return GetLocalInt(oPC, SS_ALLOW_FEAT_RECOVERY);
}

int ss_GetAllowSpellRecovery(object oPC)
{
    return GetLocalInt(oPC, SS_ALLOW_SPELL_RECOVERY);
}

void ss_SetAllowFeatRecovery(object oPC, int bAllowRecovery)
{
    SetLocalInt(oPC, SS_ALLOW_FEAT_RECOVERY, bAllowRecovery);
}

void ss_SetAllowSpellRecovery(object oPC, int bAllowRecovery)
{
    SetLocalInt(oPC, SS_ALLOW_SPELL_RECOVERY, bAllowRecovery);
}

int ss_GetPostRestHealAmount(object oPC)
{
    return GetLocalInt(oPC, SS_POST_REST_HEAL_AMOUNT);
}

void ss_SetPostRestHealAmount(object oPC, int nAmount)
{
    SetLocalInt(oPC, SS_POST_REST_HEAL_AMOUNT, nAmount);
}

void ss_AddRestMenuItem(object oPC, string sMenuText, string sActionScript = SS_REST_MENU_DEFAULT_ACTION_SCRIPT)
{
    if (sMenuText == "")
        return;
    int nIndex = GetLocalInt(oPC, SS_REST_MENU_INDEX) + 1;
    if (nIndex <= 5)
    {
        SetLocalInt(oPC, SS_REST_MENU_INDEX, nIndex);
        SetLocalString(oPC, SS_REST_MENU_ITEM_TEXT + IntToString(nIndex), sMenuText);
        SetLocalString(oPC, SS_REST_MENU_ACTION_SCRIPT + IntToString(nIndex), sActionScript);
    }
    else
        WriteTimestampedLogEntry("Rest Menu item: " + sMenuText + " exceeded maximum allowed.");
}

void ss_OpenRestDialog(object oPC)
{
    SetLocalInt(oPC, SS_SKIP_CANCEL_REST, TRUE);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionStartConversation(oPC, SS_REST_MENU_DIALOG, TRUE, FALSE));
}

int ss_GetFeatUsesRemaining(object oPC, int nFeat, int nMaxUses)
{
    int nCount = 0;
    int i;
    for (i = 0; i <= nMaxUses; i++)
    {
        int bHasFeat = GetHasFeat(nFeat, oPC);
        if (bHasFeat)
        {
            nCount += 1;
            DecrementRemainingFeatUses(oPC, nFeat);
        }
        else
            break;
    }
    if (nCount == nMaxUses+1)
        nCount = -1;
    for (i = 0; i < nCount; i++)
    {
        IncrementRemainingFeatUses(oPC, nFeat);
    }
    return nCount;
}

string ss_AppendToFeatTrack(string sFeatTrack, object oPC, int nFeat, int nMaxUses)
{
    int nFeatUses = ss_GetFeatUsesRemaining(oPC, nFeat, nMaxUses);
    if (nFeatUses > -1)
        return sFeatTrack + IntToString(nFeat) + ":" + IntToString(nFeatUses) + "|";
    return sFeatTrack;
}

void ss_SaveAvailableFeats(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    int i;
    string sFeatTrack = "X";
    for (i = 1; i <= 3; i++)
    {
        int nClass = GetClassByPosition(i, oPC);
        switch (nClass)
        {
            case CLASS_TYPE_BARBARIAN:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_BARBARIAN_RAGE, 11);
                break;
            case CLASS_TYPE_BARD:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_BARD_SONGS, 44);
                break;
            case CLASS_TYPE_CLERIC:
            {
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TURN_UNDEAD, 24);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEATH_DOMAIN_POWER, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PROTECTION_DOMAIN_POWER, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_STRENGTH_DOMAIN_POWER, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TRICKERY_DOMAIN_POWER, 1);
                break;
            }
            case CLASS_TYPE_DRUID:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ANIMAL_COMPANION, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_WILD_SHAPE, 6);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ELEMENTAL_SHAPE, 4);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_WILD_SHAPE_DRAGON, 3);
                break;
            case CLASS_TYPE_MONK:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_STUNNING_FIST, 43);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EMPTY_BODY, 2);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_QUIVERING_PALM, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_WHOLENESS_OF_BODY, 1);
                break;
            case CLASS_TYPE_PALADIN:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TURN_UNDEAD, 24);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_LAY_ON_HANDS, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_REMOVE_DISEASE, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SMITE_EVIL, 3);
                break;
            case CLASS_TYPE_RANGER:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ANIMAL_COMPANION, 1);
                break;
            case CLASS_TYPE_ROGUE:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEFENSIVE_ROLL, 1);
                break;
            case CLASS_TYPE_SORCERER:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_FAMILIAR, 1);
                break;
            case CLASS_TYPE_WIZARD:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_FAMILIAR, 1);
                break;
            case CLASS_TYPE_ARCANE_ARCHER:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_IMBUE_ARROW, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_HAIL_OF_ARROWS, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_ARROW_OF_DEATH, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_SEEKER_ARROW_1, 2);
                break;
            case CLASS_TYPE_ASSASSIN:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_DARKNESS, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_INVISIBILITY_1, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_INVISIBILITY_2, 1);
                break;
            case CLASS_TYPE_BLACKGUARD:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TURN_UNDEAD, 24);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SMITE_GOOD, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_DARK_BLESSING, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_BULLS_STRENGTH, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_SERIOUS_WOUNDS, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_CRITICAL_WOUNDS, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_CONTAGION, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_LIGHT_WOUNDS, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_MODERATE_WOUNDS, 1);
                break;
            case CLASS_TYPE_HARPER:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_CATS_GRACE, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_EAGLES_SPLENDOR, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_INVISIBILITY, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_SLEEP, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_CRAFT_HARPER_ITEM, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TYMORAS_SMILE, 1);
                break;
            case CLASS_TYPE_SHADOWDANCER:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_SHADOW, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SHADOW_DAZE, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SHADOW_EVADE, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEFENSIVE_ROLL, 1);
                break;
            case CLASS_TYPE_PALEMASTER:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ANIMATE_DEAD, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_UNDEAD, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_UNDEAD_GRAFT_1, 9);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_GREATER_UNDEAD, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEATHLESS_MASTER_TOUCH, 3);
                break;
            case CLASS_TYPE_DRAGON_DISCIPLE:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DRAGON_DIS_BREATH, 1);
                break;
            case CLASS_TYPE_SHIFTER:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_1, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_2, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_3, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_4, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HUMANOID_SHAPE, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_CONSTRUCT_SHAPE, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_OUTSIDER_SHAPE, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_WILD_SHAPE_UNDEAD, 3);
                break;
            case CLASS_TYPE_DIVINE_CHAMPION:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_LAY_ON_HANDS, 1);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SMITE_EVIL, 3);
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DIVINE_WRATH, 1);
                break;
            case CLASS_TYPE_WEAPON_MASTER:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_KI_DAMAGE, 30);
                break;
            case CLASS_TYPE_DWARVEN_DEFENDER:
                sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE, 20);
                break;
        }
    }
    if (GetHitDice(oPC) > 20)
    {
        sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_DRAGON_KNIGHT, 1);
        sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_HELLBALL, 1);
        sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_MAGE_ARMOUR, 1);
        sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_MUMMY_DUST, 1);
        sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_RUIN, 1);
        sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_EPIC_WARDING, 1);
        sFeatTrack = ss_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_BLINDING_SPEED, 1);
    }
    SetLocalString(oPC, SS_FEAT_TRACK, sFeatTrack);
}

void ss_SaveAvailableSpells(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    string sSpelltrack = "X";
    int nSpellID;
    for (nSpellID = 0; nSpellID < 550; nSpellID++) {
        int nSpellsRemaining = GetHasSpell(nSpellID, oPC);
        if(nSpellsRemaining > 0)
            sSpelltrack = sSpelltrack + IntToString(nSpellID) + ":" + IntToString(nSpellsRemaining) + "|";
    }
    SetLocalString(oPC, SS_SPELL_TRACK, sSpelltrack);
}

void ss_MakePCRest(object oPC)
{
    SetLocalInt(oPC, SS_SKIP_REST_DIALOG, TRUE);
    ss_SaveHitPoints(oPC);
    ss_SaveAvailableFeats(oPC);
    ss_SaveAvailableSpells(oPC);
    DelayCommand(2.0, AssignCommand(oPC, ActionRest(TRUE)));
}

void ss_LimitPostRestHeal(object oPC, int nPostRestHealAmount)
{
    int nSavedHP = GetLocalInt(oPC, SS_PLAYER_HP);
    int nCurrentHP = GetCurrentHitPoints(oPC);
    if (nSavedHP + nPostRestHealAmount < nCurrentHP)
    {
        int nDamage = nCurrentHP - (nSavedHP + nPostRestHealAmount);
        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
    }
}

void ss_SetFeatsRemaining(object oPC, int nFeat, int nUses)
{
    int i;
    for (i = 0; i < 50; i++)
    {
        int bHasFeat = GetHasFeat(nFeat, oPC);
        if (bHasFeat)
            DecrementRemainingFeatUses(oPC, nFeat);
        else
            break;
    }
    if (i < 50)
    {
        for (i = 0; i < nUses; i++)
            IncrementRemainingFeatUses(oPC, nFeat);
    }
}

void ss_SetAvailableFeatsToSavedValues(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    string sFeatTrack = GetLocalString(oPC, SS_FEAT_TRACK);
    if (sFeatTrack == "")
        return;
    sFeatTrack = GetStringRight(sFeatTrack, GetStringLength(sFeatTrack) - 1);
    while (sFeatTrack != "")
    {
        int nDivIndex = FindSubString(sFeatTrack, "|");
        int nValIndex = FindSubString(sFeatTrack, ":");
        int nFeat = StringToInt(GetStringLeft(sFeatTrack, nValIndex));
        int nUses = StringToInt(GetSubString(sFeatTrack,  nValIndex + 1, nDivIndex - nValIndex - 1));
        ss_SetFeatsRemaining(oPC, nFeat, nUses);
        sFeatTrack = GetStringRight(sFeatTrack, GetStringLength(sFeatTrack) - nDivIndex - 1);
    }
}

void ss_SetAvailableSpellsToSavedValues(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    string sSpelltrack = GetLocalString(oPC, SS_SPELL_TRACK);
    if (sSpelltrack == "")
        return;

    int nSpellID;
    for(nSpellID = 0; nSpellID < 550; nSpellID++)
    {
        int nSpellsRemaining = GetHasSpell(nSpellID, oPC);
        if (nSpellsRemaining > 0)
        {
            int nIndex = FindSubString(sSpelltrack, IntToString(nSpellID)+":");
            if (nIndex == -1)
            {
                //decrement spells that the player has, but were not known to have been set on
                //their last log out.
                while (nSpellsRemaining > 0) {
                    DecrementRemainingSpellUses(oPC, nSpellID);
                    nSpellsRemaining--;
                }
            }
            else //the PC has a spell that is being tracked.
            {   //get the saved remaining spells, and decrement them to the correct value.
                string sSavedSpellsRemaining = GetSubString(sSpelltrack, nIndex + GetStringLength(IntToString(nSpellID)) + 1, 1);
                int nSpellsToDecrement = nSpellsRemaining - StringToInt(sSavedSpellsRemaining);
                while (nSpellsToDecrement > 0) {
                    DecrementRemainingSpellUses(oPC, nSpellID);
                    nSpellsToDecrement--;
                }
            }
        }
    }
}
// End player rest functions


// >----< ss_SetIntPCID >----<
// <ss_i_core>
// Set the PC unique identifier
// HCR2 PC unique ID is a HexString. This is a plain integer.
void ss_SetIntPCID(object oPC)
{
    int i=1;

    while (ss_GetDatabaseInt(IntToString(i)) != 0) i++;

    ss_SetDatabaseInt(IntToString(i), i);
    ss_SetDatabaseInt("ss_nPCID", i, oPC);
}

// >----< ss_GetIntPCID >----<
// <ss_i_core>
// Returns the oPC's unique identifier number
// HCR2 PC unique ID is a HexString. This is a plain integer.
int ss_GetIntPCID(object oPC)
{
    return ss_GetDatabaseInt("ss_nPCID", oPC);
}
// void main() {}
