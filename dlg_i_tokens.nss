/*
Filename:           dlg_i_tokens
System:             Dynamic Dialog System (include script)
Author:             Greyhawk0
Date Created:       Unknown
Summary:

This file includes the dialog tokens used in conversation.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/




////////////////////////////
// ********************** \\
//  Functions Prototypes  \\
// ********************** \\
////////////////////////////






// >----< dlg_TokenDayNight >----<
// <dlg_i_tokens>
// Token for Day/Night.
string dlg_TokenDayNight(int bLower = TRUE);

// >----< dlg_TokenQuarterDay >----<
// <dlg_i_tokens>
// Token for morning, afternoon, evening, night.
string dlg_TokenQuarterDay(int bLower = TRUE);

// >----< dlg_TokenYear >----<
// <dlg_i_tokens>
// Token for year.
string dlg_TokenYear();

// >----< dlg_TokenMonth >----<
// <dlg_i_tokens>
// Token for month.
string dlg_TokenMonth();

// >----< dlg_TokenDay >----<
// <dlg_i_tokens>
// Token for day.
string dlg_TokenDay();

// >----< dlg_TokenPlayerName >----<
// <dlg_i_tokens>
// Token for player name.
string dlg_TokenPlayerName(object oTarget);

// >----< dlg_TokenFullName >----<
// <dlg_i_tokens>
// Token for full name.
string dlg_TokenFullName(object oTarget);

// >----< dlg_TokenFirstName >----<
// <dlg_i_tokens>
// Token for first name. Returns the first word of oTarget's name
string dlg_TokenFirstName(object oTarget);

// >----< dlg_TokenLastName >----<
// <dlg_i_tokens>
// Token for last name. Returns the last word of oTarget's name
string dlg_TokenLastName(object oTarget);

// >----< dlg_TokenTime >----<
// <dlg_i_tokens>
// Token for time. bMilitaryTime == 0-23, otherwise 1-12 with am/pm tag.
string dlg_TokenTime(int bMilitaryTime = FALSE, int bAM_PM = TRUE);

// >----< dlg_TokenBitchBastard >----<
// <dlg_i_tokens>
// Token for Bitch/Bastard curse.
string dlg_TokenBitchBastard(object oTarget, int bLower = TRUE);

// >----< dlg_TokenBoyGirl >----<
// <dlg_i_tokens>
// Token for Boy/Girl.
string dlg_TokenBoyGirl(object oTarget, int bLower = TRUE);

// >----< dlg_TokenSirMadam >----<
// <dlg_i_tokens>
// Token for Sir/Madam.
string dlg_TokenSirMadam(object oTarget, int bLower = TRUE);

// >----< dlg_TokenManWoman >----<
// <dlg_i_tokens>
// Token for Man/Woman.
string dlg_TokenManWoman(object oTarget, int bLower = TRUE);

// >----< dlg_TokenClass >----<
// <dlg_i_tokens>
// Gives the name of the class, plural if specified. Uses the highest leveled class.
string dlg_TokenClass(object oTarget, int bPlural = FALSE, int bLower = TRUE);

// >----< dlg_TokenDiety >----<
// <dlg_i_tokens>
// Grabs the diety.
string dlg_TokenDiety(object oTarget);

// >----< dlg_TokenGoodEvil >----<
// <dlg_i_tokens>
//  Grabs whether the object is good, evil, or neutral in that respect.
string dlg_TokenGoodEvil(object oTarget, int bLower = TRUE);

// >----< dlg_TokenLawfulChaotic >----<
// <dlg_i_tokens>
//  Grabs whether the object is lawful, chaotic, or neutral in that respect.
string dlg_TokenLawfulChaotic(object oTarget, int bLower = TRUE);

// >----< dlg_TokenAlignment >----<
// <dlg_i_tokens>
// Returns the alignment of the object. bLower1 is first word and bLower2 is second word.
string dlgTokenAlignment(object oTarget, int bLower1 = TRUE, int bLower2 = TRUE);

// >----< dlg_TokenBrotherSister >----<
// <dlg_i_tokens>
// Token for Brother/Sister.
string dlg_TokenBrotherSister(object oTarget, int bLower = TRUE);

// >----< dlg_TokenHeShe >----<
// <dlg_i_tokens>
// Token for He/She.
string dlg_TokenHeShe(object oTarget, int bLower = TRUE);

// >----< dlg_TokenHisHers >----<
// <dlg_i_tokens>
// Token for His/Hers.
string dlg_TokenHisHers(object oTarget, int bLower = TRUE);

// >----< dlg_TokenHimHer >----<
// <dlg_i_tokens>
// Token for Him/Her.
string dlg_TokenHimHer(object oTarget, int bLower = TRUE);

// >----< dlg_TokenHimHers >----<
// <dlg_i_tokens>
// Token for Him/Hers.
string dlg_TokenHimHers(object oTarget, int bLower = TRUE);

// >----< dlg_TokenLadLass >----<
// <dlg_i_tokens>
// Token for Lad/Lass.
string dlg_TokenLadLass(object oTarget, int bLower = TRUE);

// >----< dlg_TokenLordLady >----<
// <dlg_i_tokens>
// Token for Lord/Lady.
string dlg_TokenLordLady(object oTarget, int bLower = TRUE);

// >----< dlg_TokenMaleFemale >----<
// <dlg_i_tokens>
// Token for Male/Female.
string dlg_TokenMaleFemale(object oTarget, int bLower = TRUE);

// >----< dlg_TokenMaleFemale >----<
// <dlg_i_tokens>
// Token for Male/Female.
string dlg_TokenMaleFemale(object oTarget, int bLower = TRUE);

// >----< dlg_TokenMasterMistress >----<
// <dlg_i_tokens>
// Token for Master/Mistress.
string dlg_TokenMasterMistress(object oTarget, int bLower = TRUE);

// >----< dlg_TokenMisterMissus >----<
// <dlg_i_tokens>
// Token for Mister/Missus.
string dlg_TokenMisterMissus(object oTarget, int bLower = TRUE);

// >----< dlg_TokenLevel >----<
// <dlg_i_tokens>
// Token for target's level.
string dlg_TokenLevel(object oTarget);

// >----< dlg_TokenRace >----<
// <dlg_i_tokens>
// Token for target's race.
string dlg_TokenRace(object oTarget, int bPlural = FALSE, int bLower = TRUE);

// >----< dlg_TokenSubRace >----<
// <dlg_i_tokens>
// Token for target's subrace.
string dlg_TokenSubRace(object oTarget);






////////////////////////////////
// ************************** \\
//  Functions Implementation  \\
// ************************** \\
////////////////////////////////






string dlg_TokenDayNight(int bLower = TRUE)
{
    if (GetIsDay() == TRUE)
    {
        if (bLower) return "day";
        else return "Day";
    }
    else
    {
        if (bLower) return "night";
        else return "Night";
    }
}


string dlg_TokenQuarterDay(int bLower = TRUE)
{
    int iHour = GetTimeHour();
    if (iHour < 6)          // 12:00am - 5:59am  night
    {
        if (bLower) return "night";
        else return "Night";
    }
    else if (iHour < 12)    // 6:00am  - 11:59am morning
    {
        if (bLower) return "morning";
        else return "Morning";
    }
    else if (iHour <= 18)   // 12:00pm - 5:59pm  afternoon
    {
        if (bLower) return "afternoon";
        else return "Afternoon";
    }
    else                    // 6:00pm  - 11:59pm evening
    {
        if (bLower) return "evening";
        else return "Evening";
    }
}



string dlg_TokenYear()
{
    return ( IntToString( GetCalendarYear() ) );
}



string dlg_TokenMonth()
{
    return ( IntToString( GetCalendarMonth() ) );
}


string dlg_TokenDay()
{
    return ( IntToString( GetCalendarDay() ) );
}


string dlg_TokenPlayerName(object oTarget)
{
    return ( GetPCPlayerName(oTarget) );
}


string dlg_TokenFullName(object oTarget)
{
    return ( GetName(oTarget) );
}


string dlg_TokenFirstName(object oTarget)
{
    string sName =  GetName(oTarget);

    int iPos = FindSubString(sName, " ");

    sName = GetSubString(sName, 0, iPos);

    return ( sName );
}


string dlg_TokenLastName(object oTarget)
{
    string sName =  GetName(oTarget);

    int iPos = FindSubString(sName, " ");

    sName = GetSubString(sName, iPos + 1, GetStringLength(sName) - iPos);

    return ( sName );
}



string dlg_TokenTime(int bMilitaryTime = FALSE, int bAM_PM = TRUE)
{
    int iHour = GetTimeHour();
    int iMinutes = GetTimeMinute();
    int iSeconds = GetTimeSecond();

    if (bMilitaryTime)
    {
        return ( IntToString(iHour) + ":" + IntToString(iMinutes) + ":" + IntToString(iSeconds) );
    }
    else
    {
        string sTime;
        string sAM;
        if (iHour < 12)//am
        {
            if (iHour == 0) sTime = "12";
            sTime = ( IntToString(iHour) );
            sAM = "AM";
        }
        else
        {
            if (iHour == 12) sTime = "12";
            sTime = ( IntToString(iHour-12) );
            sAM = "PM";
        }

        sTime += ( ":" + IntToString(iMinutes) + ":" + IntToString(iSeconds) );
        if (bAM_PM) sTime += sAM;

        return sTime;
    }
}


string dlg_TokenBitchBastard(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "bastard";
        else return "Bastard";
    }
    else
    {
        if (bLower) return "bitch";
        else return "Bitch";
    }
}


string dlg_TokenBoyGirl(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "boy";
        else return "Boy";
    }
    else
    {
        if (bLower) return "girl";
        else return "Girl";
    }
}


string dlg_TokenSirMadam(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "sir";
        else return "Sir";
    }
    else
    {
        if (bLower) return "madam";
        else return "Madam";
    }
}


string dlg_TokenManWoman(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "man";
        else return "Man";
    }
    else
    {
        if (bLower) return "woman";
        else return "Woman";
    }
}


string dlg_TokenClass(object oTarget, int bPlural = FALSE, int bLower = TRUE)
{
    int iLevel1 = GetLevelByClass(GetClassByPosition(1, oTarget), oTarget);
    int iLevel2 = GetLevelByClass(GetClassByPosition(2, oTarget), oTarget);
    int iLevel3 = GetLevelByClass(GetClassByPosition(3, oTarget), oTarget);
    int iBiggestClass;

    if (iLevel1 > iLevel2)
    {
        if (iLevel1 > iLevel3) iBiggestClass = GetClassByPosition(1, oTarget);
        else iBiggestClass = GetClassByPosition(3, oTarget);
    }
    else
    {
        if (iLevel2 > iLevel3) iBiggestClass = GetClassByPosition(2, oTarget);
        else iBiggestClass = GetClassByPosition(3, oTarget);
    }

    string sClassref;

    if (bPlural==TRUE) sClassref = Get2DAString( "classes", "Plural", iBiggestClass );
    else if (bLower==TRUE) sClassref = Get2DAString( "classes", "Lower", iBiggestClass );
    else sClassref = Get2DAString( "classes", "Name", iBiggestClass );

    string sClassname = GetStringByStrRef( StringToInt( sClassref ), GetGender( oTarget ) );

    if (bPlural && bLower) return ( GetStringLowerCase( sClassname ) );

    return ( sClassname );
}


string dlg_TokenDiety(object oTarget)
{
    return ( GetDeity( oTarget ) );
}


string dlg_TokenGoodEvil(object oTarget, int bLower = TRUE)
{
    int iAlign = GetAlignmentGoodEvil(oTarget);
    if (iAlign == ALIGNMENT_GOOD)
    {
        if (bLower) return "good";
        else return "Good";
    }
    else if (iAlign == ALIGNMENT_EVIL)
    {
        if (bLower) return "evil";
        else return "Evil";
    }
    else
    {
        if (bLower) return "neutral";
        else return "Neutral";
    }
}


string dlg_TokenLawfulChaotic(object oTarget, int bLower = TRUE)
{
    int iAlign = GetAlignmentLawChaos(oTarget);
    if (iAlign == ALIGNMENT_LAWFUL)
    {
        if (bLower) return "lawful";
        else return "Lawful";
    }
    else if (iAlign == ALIGNMENT_CHAOTIC)
    {
        if (bLower) return "chaotic";
        else return "Chaotic";
    }
    else
    {
        if (bLower) return "neutral";
        else return "Neutral";
    }
}



string dlgTokenAlignment(object oTarget, int bLower1 = TRUE, int bLower2 = TRUE)
{
    string sFirst = dlg_TokenGoodEvil(oTarget, bLower1);
    string sSecond = dlg_TokenLawfulChaotic(oTarget, bLower2);

    if (sFirst == "neutral" || sFirst == "Neutral")
    {
        if (sSecond == "neutral" || sSecond == "Neutral")
        {
            return ( ( bLower1?"t":"T" ) + "rue " + ( bLower2?"n":"N" ) + "eutral" );
        }
    }

    return ( sFirst + sSecond );
}



string dlg_TokenBrotherSister(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "brother";
        else return "Brother";
    }
    else
    {
        if (bLower) return "sister";
        else return "Sister";
    }
}


string dlg_TokenHeShe(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "he";
        else return "He";
    }
    else
    {
        if (bLower) return "she";
        else return "She";
    }
}



string dlg_TokenHisHers(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "his";
        else return "His";
    }
    else
    {
        if (bLower) return "hers";
        else return "Hers";
    }
}


string dlg_TokenHimHer(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "him";
        else return "Him";
    }
    else
    {
        if (bLower) return "her";
        else return "Her";
    }
}


string dlg_TokenHimHers(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "him";
        else return "Him";
    }
    else
    {
        if (bLower) return "hers";
        else return "Hers";
    }
}


string dlg_TokenLadLass(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "lad";
        else return "Lad";
    }
    else
    {
        if (bLower) return "lass";
        else return "Lass";
    }
}


string dlg_TokenLordLady(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "lord";
        else return "Lord";
    }
    else
    {
        if (bLower) return "lady";
        else return "Lady";
    }
}


string dlg_TokenMaleFemale(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "male";
        else return "Male";
    }
    else
    {
        if (bLower) return "female";
        else return "Female";
    }
}


string dlg_TokenMasterMistress(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "master";
        else return "Master";
    }
    else
    {
        if (bLower) return "mistress";
        else return "Mistress";
    }
}


string dlg_TokenMisterMissus(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "mister";
        else return "Mister";
    }
    else
    {
        if (bLower) return "missus";
        else return "Missus";
    }
}



string dlg_TokenLevel(object oTarget)
{
    int iLevel = GetLevelByPosition(1, oTarget);
    iLevel += GetLevelByPosition(2, oTarget);
    iLevel += GetLevelByPosition(3, oTarget);
    return ( IntToString(iLevel) );
}


string dlg_TokenRace(object oTarget, int bPlural = FALSE, int bLower = TRUE)
{
    int iRace = GetRacialType(oTarget);

    string sRaceref;

    if (bPlural==TRUE) sRaceref = Get2DAString( "racialtypes", "NamePlural", iRace );
    else if (bLower==TRUE) sRaceref = Get2DAString( "racialtypes", "ConverNameLower", iRace );
    else sRaceref = Get2DAString( "racialtypes", "ConverName", iRace );

    string sRacename = GetStringByStrRef( StringToInt( sRaceref ), GetGender( oTarget ) );

    if (bPlural && bLower) return ( GetStringLowerCase( sRacename ) );

    return ( sRacename );
}


string dlg_TokenSubRace(object oTarget)
{
    return ( GetSubRace(oTarget) );
}

