/*
Filename:           ss_i_text
System:             Core (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Dec. 16, 2008
Summary:
Core system text manipulation script. This file holds string manipulation
functions commonly used throughout the core system. This script is accessible
from ss_i_debug.

The scripts contained herein are those included in Sherincall's SHC ruleset,
customized for compatibility with Shadows & Silver's needs.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Constants definition script
#include "ss_i_constants"

// Core configuration file
#include "ss_c_core"

// String manipulation library
#include "x3_inc_string"

/******************************************************************************/
/*                              Global Variables                              */
/******************************************************************************/

// Quotes (") and other special characters cannot be used in NWScript so this is
// a workaround
string QUOTE = GetSubString(GetStringByStrRef(470), 13, 1);


/******************************************************************************/
/*                            Function Prototypes                             */
/******************************************************************************/

// >----< ss_GetStringColored >----<
// <ss_i_text>
// Returns sString colored in sColor
// Use COLOR_* constants
string ss_GetStringColored(string sString, string sColor);

// >----< ss_GetColorCode >----<
// <ss_i_text>
// Returns the proper color code string (<cRGB>) based on RGB values
// Function by rdjparadis
string ss_GetColorCode(int nRed=255, int nGreen=255, int nBlue=255);

// >----< ss_GetStringColoredRGB >----<
// <ss_i_text>
// Returns sString colored, by RGB values
// Function by rdjparadis
string ss_GetStringColoredRGB(string sString, int nRed=255, int nGreen=255, int nBlue=255);

// >----< ss_SpeakColorString >----<
// <ss_i_text>
// Like SpeakString, but uses colors (COLOR_*)
void ss_SpeakColorString(string sString, int nTalkVolume=TALKVOLUME_TALK, string sColor = COLOR_DEFAULT);

// >----< ss_FloatingColorText >----<
// <ss_i_text>
// Like FloatingTextStringOnCreature, but uses colors (COLOR_*)
void ss_FloatingColorText(string sStringToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE, string sColor = COLOR_DEFAULT);

// >----< ss_SetColorTokens >----<
// <ss_i_text>
// Loads the custom color tokens (37060-37100)
void ss_SetColorTokens();

// >----< ss_IntToWord >----<
// <ss_i_text>
// Converts nNumber to a word string (example: Twelve)
string ss_IntToWord(int nNumber, int bCapitalize=FALSE);

// >----< ss_GetStringByStrRef >----<
// <ss_i_text>
// Will by default get a custom TLK string with a relative StrRef of nStrRef
string ss_GetStringByStrRef(int nStrRef, int bCustomTLK = TRUE, int nGender=GENDER_MALE);





/******************************************************************************/
/*                           Function Implementation                          */
/******************************************************************************/

string ss_GetStringColored(string sString, string sColor)
{
    return sColor + sString + COLOR_END;
}

string ss_GetColorCode(int nRed=255, int nGreen=255, int nBlue=255)
{
    return "<c" + GetSubString(COLOR_TOKEN, nRed, 1) + GetSubString(COLOR_TOKEN, nGreen, 1) + GetSubString(COLOR_TOKEN, nBlue, 1) + ">";
}

string ss_GetStringColoredRGB(string sString, int nRed=255, int nGreen=255, int nBlue=255)
{
    return "<c" + GetSubString(COLOR_TOKEN, nRed, 1) + GetSubString(COLOR_TOKEN, nGreen, 1) + GetSubString(COLOR_TOKEN, nBlue, 1) + ">" + sString + "</c>";
}

void ss_SpeakColorString(string sString, int nTalkVolume=TALKVOLUME_TALK, string sColor = COLOR_DEFAULT)
{
     if (sColor != COLOR_DEFAULT) sString = sColor + sString + COLOR_END;
     SpeakString(sString, nTalkVolume);
}

void ss_FloatingColorText(string sStringToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE, string sColor = COLOR_DEFAULT)
{
         if (sColor != COLOR_DEFAULT) sStringToDisplay = sColor+sStringToDisplay+COLOR_END;
         FloatingTextStringOnCreature(sStringToDisplay, oCreatureToFloatAbove, bBroadcastToFaction);
}

void ss_SetColorTokens()
{
     SetCustomToken(37068, COLOR_WHITE);
     SetCustomToken(37069, COLOR_YELLOW);
     SetCustomToken(37070, COLOR_YELLOW_LIGHT);
     SetCustomToken(37071, COLOR_YELLOW_DARK);
     SetCustomToken(37072, COLOR_RED);
     SetCustomToken(37073, COLOR_RED_LIGHT);
     SetCustomToken(37074, COLOR_RED_DARK);
     SetCustomToken(37075, COLOR_PINK);
     SetCustomToken(37076, COLOR_ORANGE);
     SetCustomToken(37077, COLOR_ORANGE_DARK);
     SetCustomToken(37078, COLOR_ORANGE_LIGHT);
     SetCustomToken(37079, COLOR_GREEN);
     SetCustomToken(37080, COLOR_GREEN_DARK);
     SetCustomToken(37081, COLOR_GREEN_LIGHT);
     SetCustomToken(37082, COLOR_PURPLE);
     SetCustomToken(37083, COLOR_TURQUOISE);
     SetCustomToken(37084, COLOR_VIOLET);
     SetCustomToken(37085, COLOR_VIOLET_DARK);
     SetCustomToken(37086, COLOR_VIOLET_LIGHT);
     SetCustomToken(37087, COLOR_GRAY);
     SetCustomToken(37088, COLOR_GRAY_DARK);
     SetCustomToken(37089, COLOR_GRAY_LIGHT);
     SetCustomToken(37090, COLOR_BLUE);
     SetCustomToken(37091, COLOR_BLUE_LIGHT);
     SetCustomToken(37092, COLOR_BLUE_DARK);
     SetCustomToken(37093, COLOR_BLACK);
     SetCustomToken(37094, COLOR_GOLD);
     SetCustomToken(37095, COLOR_DIVINE);
     SetCustomToken(37096, COLOR_ATTENTION);
     SetCustomToken(37097, COLOR_FAIL);
     SetCustomToken(37098, COLOR_SUCCESS);
     SetCustomToken(37099, COLOR_BUG);
     SetCustomToken(37100, COLOR_END);
}

// >----< Internal function for ss_IntToWord >----<
// <ss_i_text>
string ss_CurrentTeensToString(int nCurrentNumber)
{
    string sCurNum;
    switch(nCurrentNumber) {
     case 1: sCurNum = "eleven"; break;
     case 2: sCurNum = "twelve"; break;
     case 3: sCurNum = "thirteen"; break;
     case 4: sCurNum = "fourteen"; break;
     case 5: sCurNum = "fifteen"; break;
     case 6: sCurNum = "sixteen"; break;
     case 7: sCurNum = "seventeen"; break;
     case 8: sCurNum = "eighteen"; break;
     case 9: sCurNum = "nineteen"; break;
     case 0: sCurNum = "ten"; break;
    }
    return sCurNum;
}

// >----< Internal function for ss_IntToWord >----<
// <ss_i_text>
string ss_CurrentTensToString(int nCurrentNumber)
{
    string sCurNum;
    switch(nCurrentNumber) {
     case 1: sCurNum = "0"; break;
     case 2: sCurNum = "twenty"; break;
     case 3: sCurNum = "thirty"; break;
     case 4: sCurNum = "fourty"; break;
     case 5: sCurNum = "fifty"; break;
     case 6: sCurNum = "sixty"; break;
     case 7: sCurNum = "seventy"; break;
     case 8: sCurNum = "eighty"; break;
     case 9: sCurNum = "ninety"; break;
     case 0: sCurNum = ""; break;
    }
    return sCurNum;
}

// >----< Internal function for ss_IntToWord >----<
// <ss_i_text>
string ss_CurrentOnesToString(int nCurrentNumber)
{
    string sCurNum;
    switch(nCurrentNumber) {
     case 1: sCurNum = "one"; break;
     case 2: sCurNum = "two"; break;
     case 3: sCurNum = "three"; break;
     case 4: sCurNum = "four"; break;
     case 5: sCurNum = "five"; break;
     case 6: sCurNum = "six"; break;
     case 7: sCurNum = "seven"; break;
     case 8: sCurNum = "eight"; break;
     case 9: sCurNum = "nine"; break;
     case 0: sCurNum = ""; break;
    }
    return sCurNum;
}

string ss_IntToWord(int nNumber, int bCapitalize=FALSE)
{
    //Declare Variables
    string sWord, sTemp, sNumber, sCurNum;
    int bTeen, bFirst, nLength;
    //Check for special case '0'
    if (!nNumber && bCapitalize) {
        sWord = "Zero";
        return sWord;
    }
    if (!nNumber)  {
        sWord = "zero";
        return sWord;
    }
    bFirst = TRUE;
    // Get absolute value of nNumber and begin construction loop
    nNumber = abs(nNumber);
    sNumber = IntToString(nNumber);
    nLength = GetStringLength(sNumber);
    sCurNum = GetStringLeft(sNumber, 1);
    while (nLength != 0)  {
        switch(nLength) {
        case 5: // Ten thousands place
            sTemp = ss_CurrentTensToString(StringToInt(sCurNum));
            if (sTemp == "0") bTeen = TRUE;
            else {
                sWord = sWord + " " + sTemp;
                bFirst = FALSE; }
            break;
        case 4: // Thousands place
            sTemp = ss_CurrentOnesToString(StringToInt(sCurNum));
            if (bTeen) {
                bTeen = FALSE;
                sTemp = ss_CurrentTeensToString(StringToInt(sCurNum));
                sWord = sTemp + " thousand"; }
            else if (sTemp == "")
                sWord = sWord + " thousand";
            else {
                if (bFirst) sWord = sTemp + " thousand";
                else sWord = sWord + "-" + sTemp + " thousand"; }
            bFirst = FALSE;
            break;
        case 3: // Hundreds place
            sTemp = ss_CurrentOnesToString(StringToInt(sCurNum));
            if (bFirst) sWord = sTemp + " hundred";
            else if (sTemp == "") sWord = sWord;
            else sWord = sWord + " " + sTemp + " hundred";
            bFirst = FALSE;
            break;
        case 2: // Tens place
            sTemp = ss_CurrentTensToString(StringToInt(sCurNum));
            if (sTemp == "0")  bTeen = TRUE;
            else if (sTemp == "") sWord = sWord;
            else sWord = sWord + " " + sTemp;
            bFirst = FALSE;
            break;
        case 1: // Ones place
            sTemp = ss_CurrentOnesToString(StringToInt(sCurNum));
            if (bTeen) {
                sTemp = ss_CurrentTeensToString(StringToInt(sCurNum));
                sWord = sWord + sTemp; }
            else if (sTemp == "") sWord = sWord;
            else if(sWord != "") {
                if (bFirst) sWord = sWord + " and " + sTemp;
                else sWord = sWord + "-" + sTemp; }
            else sWord = sTemp;
            break;
        }
        nLength = nLength - 1;
        sNumber = GetStringRight(sNumber, nLength);
        sCurNum = GetStringLeft(sNumber, 1);
    }
    if (bCapitalize) // Capitalize the first letter
    {
        int nLen = GetStringLength(sWord);
        string sCapLetter =GetStringLeft(sWord, 1);
        sWord = GetStringRight(sWord, nLen -1);
        sWord = GetStringUpperCase(sCapLetter) + sWord;
    }
    return sWord;
}

string ss_GetStringByStrRef(int nStrRef, int bCustomTLK = TRUE, int nGender=GENDER_MALE)
{
   if (bCustomTLK) nStrRef += 16777216;
   return GetStringByStrRef(nStrRef, nGender);
}
