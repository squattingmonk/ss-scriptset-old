/*
Filename:           g_speakstring
System:             Generic (Hook-in script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       March 13, 2009
Summary:

This script, when executed (however) will make the owner speak a random string
from his local variables list.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "g_i_generic"


void main()
{
       object oSelf = OBJECT_SELF;
       int i = 1;
       while (GetLocalString(oSelf, SS_SPEAK_STRING+IntToString(i)) != "") i++;

       string sSpeak = GetLocalString(oSelf, SS_SPEAK_STRING + IntToString(ss_Random(i)+1));

       string sRGB = GetLocalString(oSelf, SS_SPEAK_STRING_COLOR);
       if(sRGB != "") sSpeak = StringToRGBString(sSpeak, sRGB);

       SpeakString(sSpeak);
}
