/*
Filename:           htf_i_constants
System:             Hunger, Thirst, & Fatigue (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
HTF system constants definition script. This file contains the constants
commonly used in the HTF system. This script is consumed by htf_i_main as an
include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


const string HTF_TIMER_SCRIPT       = "htf_timer";
const string HTF_DRUNK_TIMER_SCRIPT = "htf_drunktimer";
const string HTF_INFO_BAR           = "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||";

// Local variables
const string HTF_IS_THIRSTY  = "HTF_IS_THIRSTY";
const string HTF_IS_HUNGRY   = "HTF_IS_HUNGRY";
const string HTF_IS_FATIGUED = "HTF_IS_FATIGUED";

const string HTF_CURRENT_THIRST  = "HTF_CURRENT_THIRST";
const string HTF_CURRENT_HUNGER  = "HTF_CURRENT_HUNGER";
const string HTF_CURRENT_FATIGUE = "HTF_CURRENT_FATIGUE";
const string HTF_CURRENT_ALCOHOL = "HTF_CURRENT_ALCOHOL";

const string HTF_THIRST_SAVE_COUNT   = "HTF_THIRST_SAVE_COUNT";
const string HTF_HUNGER_SAVE_COUNT   = "HTF_HUNGER_SAVE_COUNT";
const string HTF_FATIGUE_SAVE_COUNT  = "HTF_FATIGUE_SAVE_COUNT";
const string HTF_FATIGUE_HOUR_COUNT  = "HTF_FATIGUE_HOUR_COUNT";
const string HTF_THIRST_VALUE  = "HTF_THIRST_VALUE";
const string HTF_HUNGER_VALUE  = "HTF_HUNGER_VALUE";
const string HTF_FATIGUE_VALUE = "HTF_FATIGUE_VALUE";
const string HTF_ALCOHOL_VALUE = "HTF_ALCOHOL_VALUE";

const string HTF_DELAY = "HTF_DELAY";
const string HTF_POISON = "HTF_POISON";
const string HTF_DISEASE = "HTF_DISEASE";
const string HTF_SLEEP = "HTF_SLEEP";
const string HTF_HPBONUS = "HTF_HPBONUS";
const string HTF_FEEDBACK = "HTF_FEEDBACK";

const string HTF_SUPPRESS_INFO_BARS = "HTF_SUPPRESS_INFO_BARS";
const string HTF_DISABLE_FATIGUE_GAIN = "HTF_DISABLE_FATIGUE_GAIN";

const string HTF_TRIGGER = "HTF_TRIGGER";
const string HTF_DRUNK_TIMERID = "HTF_DRUNK_TIMERID";
const string HTF_FATIGUE_EFFECTS = "HTF_FATIGUE_EFFECTS";
const string HTF_MAX_CHARGES = "HTF_MAX_CHARGES";
const string HTF_CURRENT_CHARGES = "HTF_CURRENT_CHARGES";
const string HTF_CANTEEN_SOURCE = "HTF_CANTEEN_SOURCE";

const string HTF_QUICK_REST_FATIGUE_COST = "HTF_QUICK_REST_FATIGUE_COST";
const string HTF_QUICK_REST_SCRIPT = "htf_quickrest";

// Text strings
const string HTF_TEXT_HUNGER = "Hunger: ";
const string HTF_TEXT_THIRST = "Thirst:    ";
const string HTF_TEXT_FATIGUE = "Fatigue: ";

const string HTF_TEXT_HUNGER_SAVE = "Fortitude save vs. hunger effects";
const string HTF_TEXT_THIRST_SAVE = "Fortitude save vs. thirst effects";
const string HTF_TEXT_FATIGUE_SAVE = "Fortitude save vs. fatigue effects";

const string HTF_TEXT_ALCOHOL_STUMBLES = "*stumbles about in a drunken stupor*";
const string HTF_TEXT_ALCOHOL_BELCHES = "*belches loudly*";
const string HTF_TEXT_ALCOHOL_HICCUPS = "*hiccups*";
const string HTF_TEXT_ALCOHOL_PASSED_OUT = "*passes out*";
const string HTF_TEXT_ALCOHOL_FALLS_DOWN = "*wobbles about, then falls down*";
const string HTF_TEXT_ALCOHOL_DRY_HEAVES = "*dry heaves*";

const string HTF_TEXT_CANTEEN_EMPTY = "This is empty. You will have to fill it someplace.";
const string HTF_TEXT_FILL_CANTEEN = "You fill the "; //+ GetName(oCanteen)
const string HTF_TEXT_EMPTY_CANTEEN = "You empty out the "; //GetName(oCanteen)
const string HTF_TEXT_NO_PLACE_TO_FILL = "There is no place to fill this in the immediate area.";
const string HTF_TEXT_TAKE_A_DRINK = "You take a drink.";
const string HTF_TEXT_NOT_THIRSTY = "Your thirst has been quenched.";
const string HTF_TEXT_NOT_HUNGRY = "Your hunger has been satiated.";

const string HTF_TEXT_QUICK_REST = "Rest for a few minutes.";
