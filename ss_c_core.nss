/*
Filename:           ss_c_core
System:             Core (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Dec. 10, 2008
Summary:
Core configuration settings. This script contains user definable toggles and
settings for the core system.

This script is freely editable by the mod builder. It should not contain any
constants that should not be overridable by the user. Please put those in
ss_i_core.

All below constants may be overridden, but do not alter the names of the
constants.

This script is consumed by ss_i_core as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// If set to TRUE, core functions will generate debug messages. Turn off on mod
// release.
const int SS_DEBUG_MODE = TRUE;

// If set to TRUE, tag-based scripting will be enabled.
const int SS_ENABLE_TAGBASED_SCRIPTING = TRUE;

// If set to TRUE, the clock will be forced to update every
// SS_SAVE_CALENDAR_INTERVAL seconds. Only set this to TRUE if the clock is
// not updating due to lag.
const int SS_FORCE_CLOCK_UPDATE = FALSE;

// These are the times of dawn and dusk as set in module properties. Change if
// a setting other than the default of 6 and 18 are used.
const int SS_SERVER_DAWN_TIME = 6;
const int SS_SERVER_DUSK_TIME = 18;

// This is the interval in seconds to save the calendar in the database. This
// is also the interval used for updating the clock if SS_FORCE_CLOCK_UPDATE is
// set to TRUE. Set this to 0.0 to disable calendar saving (recommended for
// testing purposes).
// Default value: 6.0.
const float SS_SAVE_CALENDAR_INTERVAL = 6.0;

// This is the interval in seconds to export all characters. Recommended
// settings are from 30.0 (seconds) to 300.0 (five minutes) depending on server
// performance. Individual player exports also occur if this value is above 0
// whenever the player rests or levels up. To stop all character exports, set
// this value to 0.0 (recommended when testing on a local vault).
// Default value: 180.0 = 3 minutes between exports
const float SS_EXPORT_CHARACTERS_INTERVAL = 0.0;

// This is the maximum length a PC's name may be. This will prevent people from
// spamming the server with ultra-long character names.
const int SS_MAX_PC_NAME_LENGTH = 40;

// This toggles whether or not a PC's location will be saved on a timer.
const int SS_SAVE_PC_LOCATION = TRUE;

// This is number of seconds between each save of a PC's location. If
// SS_SAVE_PC_LOCATION is set to FALSE, this has no effect.
// Default value: 180.0 = 3 minutes between saves
const float SS_SAVE_PC_LOCATION_INTERVAL = 180.0;

// This is the amount of time to delay between a PC entering and when his jump
// to his saved location occuers.
const float SS_CLIENT_ENTER_JUMP_DELAY = 6.0;

// If set to TRUE, will strip the PC of all possessions on his first login.
const int SS_STRIP_ON_FIRST_LOGIN = FALSE;

// This is the tag of the waypoint a PC should be sent to if no saved location
// can be found for him. We'll assume it will be an OOC player lounge.
const string SS_PLAYER_LOUNGE = "ss_playerlounge";

// This is the welcome message that will be sent to all players and DMs that
// log into the module.
const string SS_TEXT_ON_LOGIN_MESSAGE = "Welcome to Shadows & Silver.";
