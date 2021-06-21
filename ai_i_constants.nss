/*
Filename:           ai_i_constants
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 1, 2009
Summary:
Memetic AI constants definition script. This file contains the constants
commonly used in the Memetic AI system. This script is consumed by ai_c_main as
an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "g_i_generic"

// ----- Tags ------------------------------------------------------------------
const string AI_MEME_VAULT = "ai_vault";
const string AI_MEME_OBJECT = "ai_memeobject";

// ----- Debug Constants -------------------------------------------------------
const int AI_DEBUG_UTILITY = 0x1;
const int AI_DEBUG_TOOLKIT = 0x2;
const int AI_DEBUG_COREAI  = 0x4;
const int AI_DEBUG_USERAI  = 0x8;
const int AI_DEBUG_ALL     = 0xf;

const string AI_DEBUG_LEGAL_CHARACTERS = "0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ_-";
const string AI_DEBUGGING              = "AI_DEBUGGING";
const string AI_DEBUG_FLAG             = "AI_DEBUG_FLAG";
const string AI_DEBUG_TAG              = "AI_DEBUG_TAG_";
const string AI_DEBUG_TAG_NUMBER       = "AI_DEBUG_TAG_NUMBER";

// ----- Methods ---------------------------------------------------------------
const string AI_METHOD_LOAD  = "_load"; // Library load

const string AI_METHOD_BREAK = "_brk";  // Meme interrupt
const string AI_METHOD_END   = "_end";  // Meme finish
const string AI_METHOD_GO    = "_go";   // Meme start
const string AI_METHOD_INIT  = "_ini";  // Meme initialize

// ----- Temporary Variable VarNames -------------------------------------------
const string AI_TEMPORARY_TIMESTAMP = "AI_TEMPORARY_TIMESTAMP_";
const string AI_TEMPORARY_VARIABLE  = "AI_TEMPORARY_VARIABLE_";

// ----- Decaying Variable VarNames --------------------------------------------
const string AI_DECAYING_VARIABLE = "AI_DECAYING_VARIABLE_";
const string AI_DECAYING_START    = "AI_DECAYING_START_";
const string AI_DECAYING_SLOPE    = "AI_DECAYING_SLOPE_";

// ----- Variable Binding VarNames ---------------------------------------------
const string AI_BIND_OBJECT_SOURCE_OBJECT     = "AI_BIND_OBJECT_SOURCE_OBJECT";
const string AI_BIND_OBJECT_SOURCE_VARIABLE   = "AI_BIND_OBJECT_SOURCE_VARIABLE";
const string AI_BIND_OBJECT_TARGET_VARIABLE   = "AI_BIND_OBJECT_TARGET_VARIABLE";
const string AI_BIND_FLOAT_SOURCE_OBJECT      = "AI_BIND_FLOAT_SOURCE_OBJECT";
const string AI_BIND_FLOAT_SOURCE_VARIABLE    = "AI_BIND_FLOAT_SOURCE_VARIABLE";
const string AI_BIND_FLOAT_TARGET_VARIABLE    = "AI_BIND_FLOAT_TARGET_VARIABLE";
const string AI_BIND_INT_SOURCE_OBJECT        = "AI_BIND_INT_SOURCE_OBJECT";
const string AI_BIND_INT_SOURCE_VARIABLE      = "AI_BIND_INT_SOURCE_VARIABLE";
const string AI_BIND_INT_TARGET_VARIABLE      = "AI_BIND_INT_TARGET_VARIABLE";
const string AI_BIND_STRING_SOURCE_OBJECT     = "AI_BIND_STRING_SOURCE_OBJECT";
const string AI_BIND_STRING_SOURCE_VARIABLE   = "AI_BIND_STRING_SOURCE_VARIABLE";
const string AI_BIND_STRING_TARGET_VARIABLE   = "AI_BIND_STRING_TARGET_VARIABLE";
const string AI_BIND_LOCATION_SOURCE_OBJECT   = "AI_BIND_LOCATION_SOURCE_OBJECT";
const string AI_BIND_LOCATION_SOURCE_VARIABLE = "AI_BIND_LOCATION_SOURCE_VARIABLE";
const string AI_BIND_LOCATION_TARGET_VARIABLE = "AI_BIND_LOCATION_TARGET_VARIABLE";

// ----- Meme VarNames ---------------------------------------------------------
const string AI_MEME_TYPE      = "AI_MEME_TYPE";
const string AI_MEME_FLAGS     = "AI_MEME_FLAGS";
const string AI_MEME_RESULT    = "AI_MEME_RESULT";
const string AI_MEME_GENERATOR = "AI_MEME_GENERATOR";
const string AI_MEME_SEQUENCE  = "AI_MEME_SEQUENCE";
const string AI_MEME_PARENT    = "AI_MEME_PARENT";
const string AI_MEME_PAUSED    = "AI_MEME_PAUSED";
const string AI_MEME_PRIORITY  = "AI_MEME_PRIORITY";
const string AI_MEME_MODIFIER  = "AI_MEME_MODIFIER";
const string AI_MEME_PRIORITY_BAG = "AI_MEME_PRIORITY_BAG_";
const string AI_MEME_ACTIVE_MEME  = "AI_MEME_ACTIVE_MEME";
const string AI_MEME_PENDING_MEME = "AI_MEME_PENDING_MEME";
const string AI_MEME_RUN_COUNT    = "AI_MEME_RUN_COUNT";
const string AI_MEME_TIMESTAMP    = "AI_MEME_TIMESTAMP";
const string AI_MEME_SEQUENCE_REF = "AI_MEME_SEQUENCE_REF";
const string AI_MEME_SEQUENCE_NAME = "AI_MEME_SEQUENCE_NAME";
const string AI_MEME_EVENTS = "AI_MEME_EVENTS";
const string AI_MEME_OWNER = "AI_MEME_OWNER"; // Reference to the NPC self's NPC.

const string AI_MEME_CURRENT_INDEX = "AI_MEME_CURRENT_INDEX";
const string AI_MEME_RESTART_INDEX = "AI_MEME_RESTART_INDEX";
const string AI_MEME_INIT_SEQUENCE = "AI_MEME_INIT_SEQUENCE";

const string AI_MEME_ACTIVE = "AI_MEME_ACTIVE";
const string AI_MEME_SCRIPT = "AI_MEME_SCRIPT_";
const string AI_MEME_ENTRY = "AI_MEME_ENTRY_";
const string AI_MEME_LAST_EXECUTED = "AI_MEME_LAST_EXECUTED_";
const string AI_MEME_LAST_CALLED = "AI_MEME_LAST_CALLED_";
const string AI_MEME_LAST_METHOD = "AI_MEME_LAST_METHOD_";
const string AI_MEME_LAST_ENTRY_POINT = "AI_MEME_LAST_ENTRY_POINT";
const string AI_MEME_FUNCTION_ARGUMENT = "AI_MEME_FUNCTION_ARGUMENT";
const string AI_MEME_FUNCTION_RESULT = "AI_MEME_FUNCTION_RESULT";
const string AI_MEME_SUSPENDED = "AI_MEME_SUSPENDED";

// ----- Sequence VarNames -----------------------------------------------------
const string AI_SEQUENCE_NAME = "AI_SEQUENCE_NAME";

// ----- Class VarNames --------------------------------------------------------
const string AI_CLASS_RESREF     = "ai_class";
const string AI_CLASS            = "AI_CLASS_";
const string AI_CLASS_KEY_PREFIX = "AI_CLASS_KEY_";
const string AI_CLASS_NAME       = "AI_CLASS_NAME";
const string AI_CLASS_KEY        = "AI_CLASS_KEY";

const string AI_ACTIVE_CLASS     = "AI_ACTIVE_CLASS";

const string AI_MEME_PARENTS     = "AI_MEME_PARENTS";
const string AI_MEME_NEW_PARENTS = "AI_MEME_NEW_PARENTS";

// ----- Event VarNames --------------------------------------------------------
const string AI_EVENT_BAG = "AI_EVENT_BAG";
const string AI_COUNTER   = "AI_COUNTER";
const string AI_HAS_TIME_TRIGGER = "AI_HAS_TIME_TRIGGER";


// ----- General VarNames ------------------------------------------------------
const string AI_MEME_SELF = "AI_MEME_SELF";
const string AI_NPC_SELF    = "AI_NPC_SELF";
const string AI_KEY_COUNT   = "AI_KEY_COUNT";
const string AI_GENERATOR_BAG = "AI_GENERATOR_BAG";
const string AI_PRIORITY_BAG  = "AI_PRIORITY_BAG";
const string AI_SUSPEND_BAG   = "AI_SUSPEND_BAG";
const string AI_SCHEDULED_FOR_TICKLE = "AI_SCHEDULED_FOR_TICKLE";
const string AI_SEQUENCE_MEME = "AI_SEQUENCE_MEME";

const string AI_CHILD_MEME     = "AI_CHILD_MEME";
const string AI_CHILD_SEQUENCE = "AI_CHILD_SEQUENCE";

const string AI_UPDATE_SCHEDULED = "AI_UPDATE_SCHEDULED";

const string AI_MEME = "Meme";
const string AI_NAME = "Name";
const string AI_LIBRARY = "MemeticLibrary";

const string AI_NPC_CLASS     = "MemeticClass";
const string AI_NPC_GENERATOR = "MemeticGenerator";
const string AI_NPC_MEME      = "MemeticMeme";
const string AI_NPC_PRIORITY  = "_Priority";
const string AI_NPC_MODIFIER  = "_Modifier";
const string AI_NPC_FLAGS     = "_Flags";

// Response Tables
const string AI_RESPONSE        = "AI_RESP:";
const string AI_RESPONSE_TABLE  = "AI_RT_";
const string AI_RESPONSE_START  = "AI_RTS_";
const string AI_RESPONSE_END    = "AI_RTE_";
const string AI_RESPONSE_HIGH   = "AI_RTH_";
const string AI_RESPONSE_MEDIUM = "AI_RTM_";
const string AI_RESPONSE_LOW    = "AI_RTL_";

const string AI_LAST_RESPONSE       = "AI_LAST_RESPONSE";
const string AI_LAST_RESPONSE_BAND  = "AI_LAST_RESPONSE_BAND";
const string AI_LAST_RESPONSE_CLASS = "AI_LAST_RESPONSE_CLASS";

// Event Constants
const int AI_MEME_EVENT         = 0x001;
const int AI_GENERATOR_EVENT    = 0x002;
const int AI_ALL_TRIGGERS       = 9999999;

// General Sequence Constants
const int AI_SEQUENCE_REPEAT       = 0x001;
const int AI_SEQUENCE_RESUME_FIRST = 0x002;
const int AI_SEQUENCE_RESUME_LAST  = 0x004;
const int AI_SEQUENCE_INSTANT      = 0x040;
const int AI_SEQUENCE_IMMEDIATE    = 0x080;
const int AI_SEQUENCE_CHILDREN     = 0x800;

// General Meme Constants
const int AI_MEME_ONCE          = 0x0000; // Run this once, do nothing tricky.
const int AI_MEME_REPEAT        = 0x0008; // Restart this meme after all its actions complete.
const int AI_MEME_RESUME        = 0x0010; // Restart this meme if it's interrupted.
const int AI_MEME_CHECKPOINT    = 0x0020; // This is where a sequence should resume if interrupted.
const int AI_MEME_INSTANT       = 0x0040; // Only make this meme if it's the higest priority?
const int AI_MEME_IMMEDIATE     = 0x0080; // Should the meme run regardless of the current meme, w/o _brk?
const int AI_MEME_CHILDREN      = 0x0800;
const int AI_MEME_NO_BIAS       = 0x1000; // Should the modifier not be modified because of the class?


// ----- Message VarNames ------------------------------------------------------
const string AI_MESSAGE           = "AI_MESSAGE_";
const string AI_MESSAGE_CHANNEL   = "AI_MESSAGE_CHANNEL";
const string AI_MESSAGE_NAME      = "AI_MESSAGE_NAME";
const string AI_MESSAGE_RECEIVER  = "AI_MESSAGE_RECEIVE";
const string AI_MESSAGE_SENDER    = "AI_MESSAGE_SEND";

const string AI_MESSAGE_SUBSCRIBE = "AI_MESSAGE_SUBSCRIBE";
const string AI_MESSAGE_LAST_SENT = "AI_MESSAGE_LAST_SENT";

// ----- Scheduler VarNames ----------------------------------------------------
const string AI_SCHEDULE_COUNT           = "AI_SCHEDULE_COUNT";
const string AI_SCHEDULE_PREFIX          = "AI_SCHEDULE_";
const string AI_SCHEDULE_MOMENT_PREFIX   = "AI_SCHEDULE_MO_";
const string AI_SCHEDULE_REPEAT          = "_REPEAT";
const string AI_SCHEDULE_TYPE            = "_TYPE";
const string AI_SCHEDULE_NAME            = "_NAME";
const string AI_SCHEDULE_RELATIVE_MOMENT = "_RELMO";
const string AI_SCHEDULE_DELAY           = "_DELAY";
const string AI_SCHEDULE_TARGET          = "_TARGET";
const string AI_SCHEDULE_ARGUMENT        = "_ARGUMENT";
const string AI_SCHEDULE_GOOD            = "_GOOD";
const string AI_SCHEDULE_MESSAGE         = "_MESSAGE";
const string AI_SCHEDULE_CHANNEL         = "_CHANNEL";
const string AI_SCHEDULE_SENDER          = "_SENDER";

// ----- Meme Priorities -------------------------------------------------------
const int AI_PRIORITY_DEFAULT  = 0;
const int AI_PRIORITY_NONE     = 1;
const int AI_PRIORITY_LOW      = 2;
const int AI_PRIORITY_MEDIUM   = 3;
const int AI_PRIORITY_HIGH     = 4;
const int AI_PRIORITY_VERYHIGH = 5;

// ----- Generator Constants ---------------------------------------------------
const int AI_GENERATOR_SINGLEUSE = 1;

// ----- Variable Declaration Constants ----------------------------------------
const int AI_VAR_INHERIT        = 0x01;
//const int AI_VAR_INHERIT_COPY   = 0x02; (Not implemented)
//const int AI_VER_INHERIT_FORCE  = 0x04; (Not implemented)
//const int AI_VAR_PERSISTANT     = 0x08; (Not implemented)
//const int AI_VAR_EXPIRE         = 0x10; (Not implemented)


// ----- Time Constants --------------------------------------------------------
const int AI_TIME_ONE_MINUTE = 60;
const int AI_TIME_ONE_HOUR   = 3600;
const int AI_TIME_ONE_DAY    = 86400;

// ----- Globals ---------------------------------------------------------------
object NPC_SELF  = GetLocalObject(OBJECT_SELF, AI_NPC_SELF);
object MEME_SELF = GetLocalObject(OBJECT_SELF, AI_MEME_SELF);

object MEME_VAULT           = GetLocalObject(GetModule(), AI_MEME_VAULT);
string MEME_LIBRARY         = GetLocalString(MEME_VAULT, AI_MEME_LAST_EXECUTED);
string MEME_CALLED          = GetLocalString(MEME_VAULT, AI_MEME_LAST_CALLED);
string MEME_METHOD          = GetLocalString(MEME_VAULT, AI_MEME_LAST_METHOD);
int    MEME_ENTRYPOINT      = GetLocalInt(MEME_VAULT, AI_MEME_LAST_ENTRY_POINT);
int    MEME_DECLARE_LIBRARY = !MEME_ENTRYPOINT;
object MEME_ARGUMENT        = GetLocalObject(MEME_VAULT, AI_MEME_FUNCTION_ARGUMENT);

// ----- Signals ---------------------------------------------------------------
const int AI_SIGNAL_DEAD   = 691;
const int AI_SIGNAL_COMBAT = 699;
const int AI_SIGNAL_ALL    = 700;


// ----- Private ---------------------------------------------------------------
const int AI_TYPE_MEME             = 0x00001;
const int AI_TYPE_SEQUENCE_REF     = 0x00002;
const int AI_TYPE_GENERATOR        = 0x00004;
const int AI_TYPE_EVENT            = 0x00008;
const int AI_TYPE_SEQUENCE         = 0x00010;
const int AI_TYPE_MEME_BAG         = 0x00020;
const int AI_TYPE_GENERATOR_BAG    = 0x00040;
const int AI_TYPE_EVENT_BAG        = 0x00080;
const int AI_TYPE_SEQUENCE_BAG     = 0x00100;
const int AI_TYPE_PRIORITY_BAG     = 0x00200;
const int AI_TYPE_PRIORITY_BAG1    = 0x00400;
const int AI_TYPE_PRIORITY_BAG2    = 0x00800;
const int AI_TYPE_PRIORITY_BAG3    = 0x01000;
const int AI_TYPE_PRIORITY_BAG4    = 0x02000;
const int AI_TYPE_PRIORITY_BAG5    = 0x04000;
const int AI_TYPE_PRIORITY_SUSPEND = 0x08000;
const int AI_TYPE_CLASS            = 0x10000;
const int AI_TYPE_NPC_SELF         = 0x20000;


// ----- Datatypes -------------------------------------------------------------

struct message
{
    // Define the name of the message. Anonymous messages are ok, but are
    // only received by events that have subscribed to all messages.
    // Events subscribe to all messages by subscribing to the null string, "".
    string sMessageName;

    // Message Data
    string   sData;
    int      nData;
    float    fData;
    location lData;
    object   oData;

    // These are normally filled in for you. The assumption is that
    // messages will be resent by various senders to various receivers.
    // As a result, these are defined when the message is sent on a particular
    // channel, by a particular object to a particular object.
    object oSender;
    object oTarget;
    string sChannelName;
};


// ----- Landmark Constants ----------------------------------------------------
// Waypoint prefix
const string LM_LANDMARK_PREFIX      = "LM_"; // Local landmark prefix
const string LM_GATEWAY_PREFIX       = "GW_"; // Gateway prefix
const string LM_LOCAL_TRAIL_PREFIX   = "LT_"; // Local trail prefix
const string LM_GATEWAY_TRAIL_PREFIX = "GT_"; // Gateway trail prefix

// Synchronization counters
const string LM_PRESENT = "LM_PRESENT";
const string LM_BUSY    = "LM_BUSY";

// Module specific
const string LM_GATEWAYS = "LM_GATEWAYS"; // LM_GW
const string LM_GATEWAY  = "LM_GATEWAY";  // Gateway destination

const string LM_AREAS  = "LM_AREAS";
const string LM_AREA   = "LM_AREA_";

// Area specific
const string LM_LANDMARKS      = "LM_LANDMARKS";      // LM_LW
const string LM_LANDMARK_GATES = "LM_LANDMARK_GATES"; // LM_LWGate
const string LM_LANDMARK_GATE  = "LM_LANDMARK_GATE_"; // Gateway registration

const string LM_CHANGED  = "LM_CHANGED";

// Landmark specific
const string LM_GATE_TRAILS = "LM_GATE_TRAILS"; // LM_GWTrail

// Reachable landmarks / gateways
const string LM_TRAILS  = "LM_TRAILS"; // LM_LMTrail

const string LM_DEST      = "LM_DEST";      // LM_LMDest
const string LM_GATE_DEST = "LM_GATE_DEST"; // LM_LMGateDest

// Index to shortest route to a particular destination
const string LM_ROUTE_SHORTEST      = "LM_ROUTE_SHORTEST";      // LM_LMRouteShortest_
const string LM_GATE_ROUTE_SHORTEST = "LM_GATE_ROUTE_SHORTEST"; // LM_LMGateRouteShortest_

// Local landmark routing table
const string LM_ROUTE_TRAIL  = "LM_ROUTE_TRAIL_";  // LM_LWRouteTrail_
const string LM_ROUTE_PATH   = "LM_ROUTE_PATH_";   // LM_LWRoutePath_
const string LM_ROUTE_WEIGHT = "LM_ROUTE_WEIGHT_"; // LM_LWRouteWeight_

// Gateway routing table
const string LM_GATE_ROUTE_TRAIL  = "LM_GATE_ROUTE_TRAIL_";  // LM_LWGateRouteTrail_
const string LM_GATE_ROUTE_PATH   = "LM_GATE_ROUTE_PATH_";   // LM_LWGateRoutePath_
const string LM_GATE_ROUTE_WEIGHT = "LM_GATE_ROUTE_WEIGHT_"; // LM_LWGateRouteWeight_

// Trail specific
const string LM_FAR_AREA         = "LM_FAR_AREA";         // LM_FarArea
const string LM_LANDMARK_NEAR    = "LM_LANDMARK_NEAR";    // LM_LWNear
const string LM_LANDMARK_FAR     = "LM_LANDMARK_FAR";     // LM_LWFar
const string LM_TRAIL_NEAR       = "LM_TRAIL_NEAR";       // LM_TWNear
const string LM_TRAIL_FAR        = "LM_TRAIL_FAR";        // LM_TWFar
const string LM_WEIGHT_DIST      = "LM_WEIGHT_DIST";      // LM_WeightDist
const string LM_WEIGHT_GATE_DIST = "LM_WEIGHT_GATE_DIST"; // LM_WeightGateDist

// Misc
const int EnumerateLandmarksChunk     = 10;
const int EnumerateGatewaysChunk      = 10;
const int EnumerateTrailsChunk        = 1;
const int EnumerateGatewayTrailsChunk = 1;

const string LM_SHORTEST_PATH_INIT = "LM_SHORTEST_PATH_INIT";
const string LM_SHORTEST_PATH_DONE = "LM_SHORTEST_PATH_DONE";
const string LM_START              = "LM_START";
const string LM_END                = "LM_END";
const string LM_START_GATE         = "LM_START_GATE";
const string LM_END_GATE           = "LM_END_GATE";
const string LM_BEST_START_GATE    = "LM_BEST_START_GATE";
const string LM_BEST_END_GATE      = "LM_BEST_END_GATE";
const string LM_BEST_DISTANCE      = "LM_BEST_DISTANCE";

const string LM_WALK_SHORTEST_PATH_INIT = "LM_WALK_SHORTEST_PATH_INIT";
const string LM_WALK_SHORTEST_PATH_DONE = "LM_WALK_SHORTEST_PATH_DONE";

const string LM_CURRENT          = "LM_CURRENT";          // Waypoint we are headed to
const string LM_CURRENT_TRAIL    = "LM_CURRENT_TRAIL";    // Trail we are headed to
const string LM_CURRENT_LANDMARK = "LM_CURRENT_LANDMARK"; // Landmark we are headed to
const string LM_CURRENT_GATE     = "LM_CURRENT_GATE";     // Gateway or gateway landmark we are headed to

struct GatewayVect_s
{
    object  oGate;      // Local gateway
    object  oDestGate;  // Destination gateway
};

struct TrailVect_s
{
    object  oWaypoint;  // Next trail waypoint to head to
    object  oTrail;     // Trail endpoint we are headed to
    object  oLandmark;  // Landmark we are heading towards
    int     nDirection; // -1 go back, 0 there, 1 go forward
};


// ----- PoIs ------------------------------------------------------------------

const string POI_NEXT_NAME = "POI_NEXT_NAME";
const string POI_SCHEDULER = "POI_SCHEDULER";
const string POI_EMITTERS  = "POI_EMITTERS";
const string POI_EMITTER   = "POI_EMITTER";
const string POI_TARGET    = "POI_TARGET";
const string POI_TAGS      = "POI_TAGS";
const string POI_AOE       = "POI_AOE";

const string POI_RESREF = "poi_emitter";

const string POI_EMITTER_PAUSED = "POI_EMITTER_PAUSED";
const string POI_EMITTER_SELF   = "POI_EMITTER_SELF";
const string POI_EMITTER_OWNER  = "POI_EMITTER_OWNER";
const string POI_EMITTER_TARGET = "POI_EMITTER_TARGET";

const string POI_EMITTER_PREFIX            = "POI_EMITTER_";
const string POI_EMITTER_IN                = "POI_EMITTER_IN_";
const string POI_EMITTER_OUT               = "POI_EMITTER_OUT_";
const string POI_EMITTER_DISTANCE          = "_DISTANCE";
const string POI_EMITTER_RESREF            = "_RESREF";
const string POI_EMITTER_ENTER_TEST        = "_ENTER_TEST";
const string POI_EMITTER_ENTER_TEXT        = "_ENTER_TEXT";
const string POI_EMITTER_EXIT_TEST         = "_EXIT_TEST";
const string POI_EMITTER_EXIT_TEXT         = "_EXIT_TEXT";
const string POI_EMITTER_ENTER_FILTER      = "_ENTER_FILTER";
const string POI_EMITTER_ACTIVATE_FUNCTION = "_ACTIVATE_FUNCTION";
const string POI_EMITTER_EXIT_FUNCTION     = "_EXIT_FUNCTION";
const string POI_EMITTER_FLAGS             = "_FLAGS";
const string POI_EMITTER_TEST_CACHE        = "_TEST_CACHE";
const string POI_EMITTER_NOTIFY_CACHE      = "_NOTIFY_CACHE";

const float POI_LARGE = 10.0;
const float POI_SMALL = 5.0;

const int POI_FAILED = 2;
const int POI_PASSED = 1;

const int   POI_AOE_LARGE = AOE_PER_INVIS_SPHERE;
const int   POI_AOE_SMALL = 37;

// PoI Emitter Constants
const int POI_EMIT_TO_PC  = 0x01;
const int POI_EMIT_TO_DM  = 0x02; // This may not work; depending on if Bioware lets DM's trigger AoEs.
const int POI_EMIT_TO_NPC = 0x04;
const int POI_EMIT_TO_ALL = 0xff;

/*

// ----- Observer Meme ---------------------------------------------------------

const int SIGNAL_OBSERVER   = 0x02021; // Some arbitrary signal trigger.

const int NOTIFY_ARM        = 0x000001;
const int NOTIFY_DISARM     = 0x000002;
const int NOTIFY_APPEAR     = 0x000004;
const int NOTIFY_VANISH     = 0x000008;
const int NOTIFY_ATTACK     = 0x000010;
const int NOTIFY_DEFEND     = 0x000020;
const int NOTIFY_CAST_AT    = 0x000040; // Requires changes to all spell scipts.
const int NOTIFY_CAST_ON    = 0x000080; // Requires changes to all spell scipts.

const int NOTIFY_ENEMY      = 0x000100;
const int NOTIFY_FRIEND     = 0x000200;
const int NOTIFY_PC         = 0x000400;
const int NOTIFY_NPC        = 0x000800;
const int NOTIFY_DM         = 0x001000;

const int NOTIFY_DEAD       = 0x002000;
const int NOTIFY_ALIVE      = 0x004000;
const int NOTIFY_HEALTHY    = 0x008000;
const int NOTIFY_BRUISED    = 0x010000;
const int NOTIFY_WOUNDED    = 0x020000;
const int NOTIFY_HURT       = 0x040000;
const int NOTIFY_BADLYHURT  = 0x080000;
const int NOTIFY_NEARDEATH  = 0x100000;
const int NOTIFY_HEALTH_INC = 0x200000;
const int NOTIFY_HEALTH_DEC = 0x400000;

// ----- Core Meme Constants ---------------------------------------------------

// Response Tables
const string RESPONSE_START = "MEME_RTS_";
const string RESPONSE_END   = "MEME_RTE_";
const string RESPONSE_HIGH   = "MEME_RTH_";
const string RESPONSE_MEDIUM = "MEME_RTM_";
const string RESPONSE_LOW    = "MEME_RTL_";

// Event Constants
const int MEME_EVENT         = 0x001;
const int GENERATOR_EVENT    = 0x002;
const int ALL_TRIGGERS       = 9999999;

// General Sequence Constants
const int SEQ_REPEAT         = 0x001;
const int SEQ_RESUME_FIRST   = 0x002;
const int SEQ_RESUME_LAST    = 0x004;
const int SEQ_INSTANT        = 0x040;
const int SEQ_IMMEDIATE      = 0x080;
const int SEQ_CHILDREN       = 0x800;

// General Meme Constants
const int MEME_ONCE          = 0x0000; // Run this once, do nothing tricky.
const int MEME_REPEAT        = 0x0008; // Restart this meme after all its actions complete.
const int MEME_RESUME        = 0x0010; // Restart this meme if it's interrupted.
const int MEME_CHECKPOINT    = 0x0020; // This is where a sequence should resume if interrupted.
const int MEME_INSTANT       = 0x0040; // Only make this meme if it's the higest priority?
const int MEME_IMMEDIATE     = 0x0080; // Should the meme run regardless of the current meme, w/o _brk?

const int MEME_CHILDREN      = 0x0800;
const int MEME_NOBIAS        = 0x1000; // Should the modifier not be modified because of the class?


// Meme Priority Constants
const int PRIO_DEFAULT       = 0;
const int PRIO_NONE          = 1;
const int PRIO_LOW           = 2;
const int PRIO_MEDIUM        = 3;
const int PRIO_HIGH          = 4;
const int PRIO_VERYHIGH      = 5;

// Generator Constants
const int GEN_SINGLEUSE      = 1;
//const int GEN_PROPOGATE_PRIO = 0x100; (Not implemented)

const int TIME_ONE_MINUTE = 60;
const int TIME_ONE_HOUR   = 3600;
const int TIME_ONE_DAY    = 86400;

// Variable Declaration Constants

const int VAR_INHERIT        = 0x01;
//const int VAR_INHERIT_COPY   = 0x02; (Not implemented)
//const int VER_INHERIT_FORCE  = 0x04; (Not implemented)
//const int VAR_PERSISTANT     = 0x08; (Not implemented)
//const int VAR_EXPIRE         = 0x10; (Not implemented)

// ----- Private ---------------------------------------------------------------

object MEME_SELF          = GetLocalObject (OBJECT_SELF, "MEME_ObjectSelf");
object NPC_SELF           = GetLocalObject (OBJECT_SELF, "MEME_NPCSelf");
const int    TYPE_MEME          = 0x00001;
const int    TYPE_SEQ_REF       = 0x00002;
const int    TYPE_GENERATOR     = 0x00004;
const int    TYPE_EVENT         = 0x00008;
const int    TYPE_SEQUENCE      = 0x00010;
const int    TYPE_MEME_BAG      = 0x00020;
const int    TYPE_GENERATOR_BAG = 0x00040;
const int    TYPE_EVENT_BAG     = 0x00080;
const int    TYPE_SEQUENCE_BAG  = 0x00100;
const int    TYPE_PRIO_BAG      = 0x00200;
const int    TYPE_PRIO_BAG1     = 0x00400;
const int    TYPE_PRIO_BAG2     = 0x00800;
const int    TYPE_PRIO_BAG3     = 0x01000;
const int    TYPE_PRIO_BAG4     = 0x02000;
const int    TYPE_PRIO_BAG5     = 0x04000;
const int    TYPE_PRIO_SUSPEND  = 0x08000;
const int    TYPE_CLASS         = 0x10000;



// ----- EFFECTS ---------------------------------------------------------------

const int BLINDNESS = 32;
