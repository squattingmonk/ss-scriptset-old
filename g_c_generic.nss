/*
Filename:           g_c_generic
System:             Generic (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 7, 2009
Summary:
Generic configuration settings. This script contains user definable toggles and
settings for the generic system.

This script is freely editable by developers. It should not contain any
constants that should not be overridable by other builders. Please put those in
g_i_constants.

All below constants may be overridden, but do not alter the names of the
constants.

This script is consumed by g_i_generic as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


// if TRUE, 2DA reads will be cached, so reading them next time will be a lot faster.
const int SS_CACHE_ALL_2DA_READS = TRUE;

// If set to TRUE custom 2DA reads will be bypassed.
// The engine has a built-in caching system, and we're yet to test if our scripted
// one will make it faster or slower.
const int SS_USE_ENGINE_2DA_READS_ONLY = FALSE;

/******************************************************************************/
/*                              Terrain Triggers                              */
/******************************************************************************/

// If set to true only PCs will get bonus/penalties for the terrain triggers.
const int SS_TERRAIN_TRIGGER_PC_ONLY = FALSE;

// Text to send to the player when they enter a terrain trigger.
// Blank string ("") means no message.
const string SS_TEXT_TERRAIN_TRIGGER_ENTER = "Entering special terrain. Effects applied.";

// Text to send to the player when they exit a terrain trigger.
// Blank string ("") means no message.
const string SS_TEXT_TERRAIN_TRIGGER_EXIT = "Exiting special terrain. Effects removed.";
