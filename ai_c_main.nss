/*
Filename:           ai_c_main
System:             Memetic AI (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 1, 2009
Summary:
Memetic AI system configuration settings. This script contains user-definable
toggles and settings for the Memetic AI system.

This script is freely editable by developers. It should not contain any
constants that should not be overridable by other builders. Please put those in
ai_i_constants.

All below constants may be overridden, but do not alter the names of the
constants.

This script is consumed by ai_i_debug as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_constants"

// ----- Debugging -------------------------------------------------------------

// This is the global on/off switch for debugging. If set to TRUE, memetic
// functions will generate debug messages in the log file. To view the XML log
// in Internet Explorer or an equivalent XML viewer, remove the BioWare text at
// the top and bottom of the log, add <Log> to the start and </Log> to the end
// of your log file, and change the extension to .xml. Also, ensure that your
// server options are set not to log or profile scripts, as that causes errors
// when viewing the log.
const int AI_DEBUG_MODE = TRUE;

// This is the level of debug messages to generate. Setting it to a less
// inclusive value will help to reduce the number of debug calls and limit the
// log messages to the information you're looking for.
// Possible values:
// - AI_DEBUG_ALL:     debugs all functions.
// - AI_DEBUG_UTILITY: debugs low-level utility functions.
// - AI_DEBUG_TOOLKIT: debugs mid-level functions (ai_CreateMeme, etc.).
// - AI_DEBUG_COREAI:  debugs high level functions (memes, generators, etc.).
// - AI_DEBUG_USERAI:  debugs anything with no defined level (usually errors).
const int AI_DEBUG_LEVEL = AI_DEBUG_ALL;

// If set to TRUE, all objects will generate debug messages. After things are
// running smoothly, set this to FALSE and call ai_StartDebugging() on objects
// you want to debug (or set an int with varname AI_DEBUGGING on the object in
// the toolset). This will reduce the number of log writes and speed up the AI.
const int AI_DEBUG_ALL_OBJECTS = TRUE;

// ----- NPC Profiles ----------------------------------------------------------

// This controls the default class memetic NPCs are assigned to. An NPC with no
// assigned classes will take this class instead. To let multiple classes be
// assigned by default, enter them as a comma-separated values list (e.g.,
// "generic, walker, muffin_man", etc.). If listing multiple classes, put the
// ones whose memes should have the least priority first.
const string AI_DEFAULT_CLASSES = "generic";

// ----- PoI Emitters ----------------------------------------------------------

// These two variables allow you to add a list of tags that will automatically
// have PoI emitters placed on them. The first variable is a list of tags, while
// the second is a list of emitter names. When the module loads, all objects
// with tags listed in AI_POI_TAGS will be given an emitter of the equivalent
// name listed in AI_POI_EMITTERS. Enter these lists as a comma-separated values
// list. For example, if you had the variables set up like so:
//     const string AI_POI_TAGS     = "ai_autopoi, poi_test";
//     const string AI_POI_EMITTERS = "auto,       example";
// ...then all objects with the tag ai_autopoi would be given the emitter called
// auto and all objects with the tag poi_test would be given the emitter with
// the name example.
// Note: Any emitters listed must be defined in the library ai_poiemitters,
// otherwise they will not function.
const string AI_POI_TAGS     = "ai_autopoi, poi_test";
const string AI_POI_EMITTERS = "auto,       example";

