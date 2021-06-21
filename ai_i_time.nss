/*
Filename:           ai_i_time
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 24, 2009
Summary:
Memetic AI include script. This file holds time handling functions commonly used
throughout the Memetic AI system. This script is consumed as an include
directive by ai_i_main.

These functions were originally designed by Lucullo for MemeticAI.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ----- Date ------------------------------------------------------------------

// ---< ai_GetCurrentDate >---
// ---< ai_i_time >---
// Returns the current date in Date format.
int ai_GetCurrentDate();

// ---< ai_DateYMD >---
// ---< ai_i_time >---
// Return a Date in the YMD format.
int ai_DateYMD(int nYear, int nMonth, int nDay);

// ---< ai_DateMDY >---
// ---< ai_i_time >---
// Return a Date in the MDY format.
int ai_DateMDY(int nMonth, int nDay, int nYear);

// ---< ai_DateDMY >---
// ---< ai_i_time >---
// Return a Date in the DMY format.
int ai_DateDMY(int nDay, int nMonth, int nYear);

// ---< ai_GetYear >---
// ---< ai_i_time >---
// Extract the Year from a Date.
int ai_GetYear(int nDate);

// ---< ai_GetMonth >---
// ---< ai_i_time >---
// Extract the Month from a Date.
int ai_GetMonth(int nDate);

// ---< ai_GetDay >---
// ---< ai_i_time >---
// Extract the Day from a Date.
int ai_GetDay(int nDate);

// ---< ai_Days >---
// ---< ai_i_time >---
// Build DateInterval from Days.
int ai_Days(int nValue);

// ---< ai_Months >---
// ---< ai_i_time >---
// Build DateInterval from Months.
int ai_Months(int nValue);

// ---< ai_Years >---
// ---< ai_i_time >---
// Build DateInterval from Years.
int ai_Years(int nValue);

// ----- True Time -------------------------------------------------------------


// ---< ai_GetCurrentTime >---
// ---< ai_i_time >---
// Get current TOD in TrueTime format.
int ai_GetCurrentTime();

// ---< ai_Time >---
// ---< ai_i_time >---
// Build a TrueTime TOD.
int ai_Time(int nHour, int nMinute, int nSecond);

// ---< ai_GetHour >---
// ---< ai_i_time >---
// Extract the Hour from a TrueTime TOD.
int ai_GetHour(int nTime);

// ---< ai_GetMinute >---
// ---< ai_i_time >---
// Extract the Minute from a TrueTime TOD.
int ai_GetMinute(int nTime);

// ---< ai_GetSecond >---
// ---< ai_i_time >---
// Extract the Second from a TrueTime TOD.
int ai_GetSecond(int nTime);

// ---< ai_Seconds >---
// ---< ai_i_time >---
// Build TrueTime Interval from Seconds.
int ai_Seconds(int nValue);

// ---< ai_Minutes >---
// ---< ai_i_time >---
// Build TrueTime Interval from Minutes.
int ai_Minutes(int nValue);

// ---< ai_Hours >---
// ---< ai_i_time >---
// Build TrueTime Interval from Hours.
int ai_Hours(int nValue);

// ---< ai_Interval >---
// ---< ai_i_time >---
// Compute a TrueTime Interval as difference between 2 TODs (and optionally Dates)
// If one or both Dates are 0 then nTimeEnd is always considered after nTimeStart
// adding a 24h interval if needed (roll around-the-clock)
// Note: by specifying the dates it is possible to get a negative interval
int ai_Interval(int nTimeStart, int nTimeEnd, int nDateStart=0, int nDateEnd=0);


// ----- Game Time -------------------------------------------------------------

// ---< ai_GetCurrentGameTime >---
// ---< ai_i_time >---
// Get current TOD in GameTime format.
float ai_GetCurrentGameTime();

// ---< ai_GameTime >---
// ---< ai_i_time >---
// Build a GameTime TOD.
float ai_GameTime(int nHour, int nMinute, int nSecond, int nMillisecond=0);

// ---< ai_GetGameHour >---
// ---< ai_i_time >---
// Extract the Hour from a GameTime TOD.
int ai_GetGameHour(float fGameTime);

// ---< ai_GetGameMinute >---
// ---< ai_i_time >---
// Extract the Minute from a GameTime TOD.
int ai_GetGameMinute(float fGameTime);

// ---< ai_GetGameSecond >---
// ---< ai_i_time >---
// Extract the Second from a GameTime TOD.
int ai_GetGameSecond(float fGameTime);

// ---< ai_GetGameMillisecond >---
// ---< ai_i_time >---
// Extract the Millisecond from a GameTime TOD.
int ai_GetGameMillisecond(float fGameTime);

// ---< ai_GameMilliseconds >---
// ---< ai_i_time >---
// Build GameTime Interval from Milliseconds.
float ai_GameMilliseconds(int nValue);

// ---< ai_GameSeconds >---
// ---< ai_i_time >---
// Build GameTime Interval from Seconds.
float ai_GameSeconds(int nValue);

// ---< ai_GameMinutes >---
// ---< ai_i_time >---
// Build GameTime Interval from Minutes.
float ai_GameMinutes(int nValue);

// ---< ai_GameHours >---
// ---< ai_i_time >---
// Build GameTime Interval from Hours.
float ai_GameHours(int nValue);

// ---< ai_GameInterval >---
// ---< ai_i_time >---
// Compute a GameTime Interval as difference between 2 TODs (and optionally Dates)
// If one or both Dates are 0 then fGameTimeEnd is always considered after
// fGameTimeStart, adding a 24th interval if needed (roll around-the-clock)
// Note: by specifying the dates it is possible to get a negative interval.
float ai_GameInterval(float fGameTimeStart, float fGameTimeEnd, int nDateStart=0, int nDateEnd=0);


// ----- Mapping ---------------------------------------------------------------

// ---< ai_TimeToGameTime >---
// ---< ai_i_time >---
// Transform a TrueTime into a GameTime.
float ai_TimeToGameTime(int nTime);

// ---< ai_GameTimeToTime >---
// ---< ai_i_time >---
// Transform a GameTime into a TrueTime.
int ai_GameTimeToTime(float fGameTime);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

// ----- Date ------------------------------------------------------------------

int ai_GetCurrentDate()
{
    return ai_DateYMD(GetCalendarYear(), GetCalendarMonth(), GetCalendarDay());
}

int ai_DateYMD(int nYear, int nMonth, int nDay)
{
    nMonth = (nMonth < 1) ? 1 : ((nMonth >    12)  ?    12 : nMonth);
    nDay   = (nDay   < 1) ? 1 : ((nDay   >    28)  ?    28 : nDay);
    nYear  = (nYear  < 0) ? 0 : nYear;
    int    nValue  =  nYear                * 12;   // months
           nValue  = (nValue + nMonth - 1) * 28;   // days
    return nValue  = (nValue + nDay - 1);
}

int ai_DateMDY(int nMonth, int nDay, int nYear)
{
    return ai_DateYMD(nYear, nMonth, nDay);
}

int ai_DateDMY(int nDay, int nMonth, int nYear)
{
    return ai_DateYMD(nYear, nMonth, nDay);
}

int ai_GetYear(int nDate)  {return nDate / 336;}
int ai_GetMonth(int nDate) {return ((nDate / 28) % 12) + 1;}
int ai_GetDay(int nDate)   {return (nDate % 28) + 1;}

int ai_Days(int nValue)    {return nValue;}
int ai_Months(int nValue)  {return nValue *  28;}
int ai_Years(int nValue)   {return nValue * 336;}  // 28 * 12


// ----- True Time -------------------------------------------------------------

int ai_GetCurrentTime()
{
   return ai_GameTimeToTime(ai_GetCurrentGameTime());
}

int ai_Time(int nHour, int nMinute, int nSecond)
{
    nHour      = (nHour < 0)   ? 0 : nHour;
    nMinute    = (nMinute < 0) ? 0 : nMinute;
    nSecond    = (nSecond < 0) ? 0 : nSecond;
    return ((nHour * 3600) + (nMinute * 60) + nSecond) % 86400;  // 3600 * 24
}

int ai_GetHour(int nTime)   {return nTime / 3600;}
int ai_GetMinute(int nTime) {return (nTime / 60) % 60;}
int ai_GetSecond(int nTime) {return nTime  % 60;}

int ai_Seconds(int nValue)  {return nValue        ;}
int ai_Minutes(int nValue)  {return nValue  *   60;}
int ai_Hours(int nValue)    {return nValue  * 3600;}

int ai_Interval(int nTimeStart, int nTimeEnd, int nDateStart=0, int nDateEnd=0)
{
    int nResult = nTimeEnd - nTimeStart;
    if (nDateStart && nDateEnd)                      // both dates given
        nResult += (nDateEnd - nDateStart) * 86400;  // add n days
    else if (nResult < 1)
        nResult += 86400;                            // add one day
    return nResult;
}

// ----- Game Time -------------------------------------------------------------

float ai_GetCurrentGameTime()
{
 return ((GetTimeHour()   * HoursToSeconds(1)) +
         (GetTimeMinute() * 60) +
          GetTimeSecond() +
         (IntToFloat(GetTimeMillisecond()) / 1000));
}

float ai_GameTime(int nHour, int nMinute, int nSecond, int nMillisecond=0)
{
 nHour      = (nHour < 0)   ? 0 : nHour;
 nMinute    = (nMinute < 0) ? 0 : nMinute;
 nSecond    = (nSecond < 0) ? 0 : nSecond;
 return ((nHour   * HoursToSeconds(1)) +
         (nMinute * 60) +
          nSecond +
         (IntToFloat(nMillisecond) / 1000));
}

int ai_GetGameHour(float fGameTime)
{
    return FloatToInt(fGameTime / HoursToSeconds(1));
}

int ai_GetGameMinute(float fGameTime)
{
    return (FloatToInt(fGameTime) / 60) % (FloatToInt(HoursToSeconds(1)) / 60);
}

int ai_GetGameSecond(float fGameTime)
{
    return FloatToInt(fGameTime)  % 60;
}

int ai_GetGameMillisecond(float fGameTime)
{
    return FloatToInt(fGameTime * 1000)  % 1000;
}

float ai_GameMilliseconds(int nValue)
{
    return IntToFloat(nValue) / 1000;
}

float ai_GameSeconds(int nValue)
{
    return IntToFloat(nValue);
}

float ai_GameMinutes(int nValue)
{
    return IntToFloat(nValue) * 60.0f;
}

float ai_GameHours(int nValue)
{
    return HoursToSeconds(nValue);
}

float ai_GameInterval(float fGameTimeStart, float fGameTimeEnd, int nDateStart=0, int nDateEnd=0)
{
    float fResult = fGameTimeEnd - fGameTimeStart;
    if (nDateStart && nDateEnd)                                 // both dates given
        fResult += ai_GameHours((nDateEnd - nDateStart) * 24);  // add n days
    else if (fResult <= 0.0f )
        fResult += ai_GameHours(24);                            // add one day
    return fResult;
}


// ----- Mapping ---------------------------------------------------------------

float ai_TimeToGameTime(int nTime)
{
    return (nTime * HoursToSeconds(1)) / 3600;
}

int ai_GameTimeToTime(float fGameTime)
{
    return FloatToInt(fGameTime * 3600 / HoursToSeconds(1));
}


// void main(){}
