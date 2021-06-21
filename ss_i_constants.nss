/*
Filename:           ss_i_constants
System:             Core (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Dec. 15, 2008
Summary:
Core system constants definition script. This file holds the constants commonly
used throughout the core system. This script is consumed by ss_i_locals as an
include directive

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


// Blueprints
const string SS_GLOBAL_DATA_POINT  = "ss_datapoint";
const string SS_PLAYER_DATA_ITEM   = "ss_dataitem";
const string SS_PLAYER_MENU_DIALOG = "ss_pcmenu";
const string SS_REST_MENU_DIALOG   = "ss_restmenu";

// Local variable names
const string SS_PCID               = "SS_PCID";
const string SS_LOGIN_BOOT         = "SS_LOGIN_BOOT";
const string SS_PLAYER_COUNT       = "SS_PLAYER_COUNT";
const string SS_LOCATION_LAST_DIED = "SS_LOCATION_LAST_DIED";
const string SS_PLAYERS_IN_MODULE  = "SS_PLAYERS_IN_MODULE";
const string SS_PLAYERS_IN_AREA    = "SS_PLAYERS_IN_AREA";
const string SS_PLAYERS_IN_TRIGGER = "SS_PLAYERS_IN_TRIGGER";

const string SS_PLAYER_DATA_ITEM_TARGET_OBJECT   = "SS_PLAYER_DATA_ITEM_TARGET_OBJECT";
const string SS_PLAYER_DATA_ITEM_TARGET_LOCATION = "SS_PLAYER_DATA_ITEM_TARGET_LOCATION";

const string SS_PLAYER_MENU_INDEX     = "SS_PLAYER_MENU_INDEX";
const string SS_PLAYER_MENU_ITEM_TEXT = "SS_PLAYER_MENU_ITEM_TEXT";
const string SS_DIALOG_RESREF         = "SS_DIALOG_RESREF";
const string SS_CURRENT_TOKEN_INDEX   = "SS_CURRENT_TOKEN_INDEX";
const int    SS_PLAYER_MENU_TOKEN     = 30001;

const string SS_REST_MENU_INDEX                 = "SS_REST_MENU_INDEX";
const string SS_REST_MENU_ITEM_TEXT             = "SS_REST_MENU_ITEM_TEXT";
const string SS_REST_MENU_ACTION_SCRIPT         = "SS_PLAYER_REST_MENU_ACTION_SCRIPT";
const string SS_REST_MENU_DEFAULT_ACTION_SCRIPT = "ss_makepcrest";
const int    SS_REST_MENU_TOKEN                 = 30101;

const string SS_PLAYER_HP             = "SS_PLAYER_HP";
const string SS_ALLOW_REST            = "SS_ALLOW_REST";
const string SS_ALLOW_FEAT_RECOVERY   = "SS_ALLOW_FEAT_RECOVERY";
const string SS_ALLOW_SPELL_RECOVERY  = "SS_ALLOW_SPELL_RECOVERY";
const string SS_POST_REST_HEAL_AMOUNT = "SS_POST_REST_HEAL_AMOUNT";
const string SS_FEAT_TRACK            = "SS_FEAT_TRACK";
const string SS_SPELL_TRACK           = "SS_SPELL_TRACK";
const string SS_SKIP_CANCEL_REST      = "SS_SKIP_CANCEL_REST";
const string SS_SKIP_REST_DIALOG      = "SS_SKIP_REST_DIALOG";

const string SS_TIMESTAMP          = "SS_TIMESTAMP_";
const string SS_TIMER_SCRIPT       = "SS_TIMER_SCRIPT";
const string SS_TIMER_OBJECT       = "SS_TIMER_OBJECT";
const string SS_TIMER_INTERVAL     = "SS_TIMER_INTERVAL";
const string SS_TIMER_OBJECT_IS_PC = "SS_TIMER_OBJECT_IS_PC";
const string SS_TIMER_IS_RUNNING   = "SS_TIMER_IS_RUNNING";
const string SS_NEXT_TIMER_ID      = "SS_NEXT_TIMER_ID";

const string SS_LAST_EVENT = "SS_LAST_EVENT";

// Database variable names
const string SS_NEXT_PCID       = "SS_NEXT_PCID";
const string SS_PLAYER_LOCATION = "SS_PLAYER_LOCATION";
const string SS_PLAYER_STATE    = "SS_PLAYER_STATE";
const string SS_CHARACTER_NAME  = "SS_CHARACTER_NAME";
const string SS_PLAYER_NAME     = "SS_PLAYER_NAME";

// Affixes
const string SS_NO_GLOBAL_EVENT_SCRIPTS = "NoGlobal_";
const string SS_NO_AUTO_HOOK_SCRIPTS    = "NoAutoHook_";
const string SS_HAS_LOGGED_IN           = "_HAS_LOGGED_IN";
const string SS_PLAYER_HP_PREFIX        = "_PLAYER_HP";

// Player states
const int SS_PLAYER_STATE_ALIVE  = 0;
const int SS_PLAYER_STATE_STABLE = 1;
const int SS_PLAYER_STATE_DYING  = 2;
const int SS_PLAYER_STATE_DEAD   = 3;

// Timer scripts
const string SS_EXPORT_CHAR_TIMER_SCRIPT = "ss_exportchars";
const string SS_SAVE_LOCATION_SCRIPT     = "ss_savelocation";
const string SS_SAVE_CALENDAR_SCRIPT     = "ss_savecalendar";

// Pseudo-Event Scripts
const string SS_SPELLHOOK_EVENT_SCRIPT   = "ss_e_spellhook";
const string SS_ON_DAWN_SCRIPT           = "ss_ondawn";
const string SS_ON_DUSK_SCRIPT           = "ss_ondusk";

// Pseudo events
const string SS_PSEUDO_EVENT_ON_HOOK             = "AutoHook";
const string SS_PSEUDO_EVENT_ON_DAWN             = "OnDawn";
const string SS_PSEUDO_EVENT_ON_DUSK             = "OnDusk";
const string SS_PSEUDO_EVENT_ON_SPELLHOOK        = "OnSpellHook";
const string SS_PSEUDO_EVENT_ON_PLAYER_HEARTBEAT = "OnPlayerHeartBeat";

// Module Events
const string SS_MODULE_EVENT_ON_ACQUIRE_ITEM          = "OnAcquireItem";
const string SS_MODULE_EVENT_ON_ACTIVATE_ITEM         = "OnActivateItem";
const string SS_MODULE_EVENT_ON_CLIENT_ENTER          = "OnClientEnter";
const string SS_MODULE_EVENT_ON_CLIENT_LEAVE          = "OnClientLeave";
const string SS_MODULE_EVENT_ON_CUTSCENE_ABORT        = "OnCutSceneAbort";
const string SS_MODULE_EVENT_ON_HEARTBEAT             = "OnHeartBeat";
const string SS_MODULE_EVENT_ON_MODULE_LOAD           = "OnModuleLoad";
const string SS_MODULE_EVENT_ON_PLAYER_CHAT           = "OnPlayerChat";
const string SS_MODULE_EVENT_ON_PLAYER_DEATH          = "OnPlayerDeath";
const string SS_MODULE_EVENT_ON_PLAYER_DYING          = "OnPlayerDying";
const string SS_MODULE_EVENT_ON_PLAYER_EQUIP_ITEM     = "OnPlayerEquipItem";
const string SS_MODULE_EVENT_ON_PLAYER_LEVEL_UP       = "OnPlayerLevelUp";
const string SS_MODULE_EVENT_ON_PLAYER_RESPAWN        = "OnPlayerReSpawn";
const string SS_MODULE_EVENT_ON_PLAYER_REST_STARTED   = "OnPlayerRestStarted";
const string SS_MODULE_EVENT_ON_PLAYER_REST_CANCELLED = "OnPlayerRestCancelled";
const string SS_MODULE_EVENT_ON_PLAYER_REST_FINISHED  = "OnPlayerRestFinished";
const string SS_MODULE_EVENT_ON_PLAYER_UNEQUIP_ITEM   = "OnPlayerUnEquipItem";
const string SS_MODULE_EVENT_ON_UNACQUIRE_ITEM        = "OnUnAcquireItem";
const string SS_MODULE_EVENT_ON_USER_DEFINED          = "OnUserDefined";

// Area Events
const string SS_AREA_EVENT_ON_ENTER        = "OnAreaEnter";
const string SS_AREA_EVENT_ON_EXIT         = "OnAreaExit";
const string SS_AREA_EVENT_ON_HEARTBEAT    = "OnAreaHeartBeat";
const string SS_AREA_EVENT_ON_USER_DEFINED = "OnAreaUserDefined";

// Creature Events
const string SS_CREATURE_EVENT_ON_BLOCKED            = "OnCreatureBlocked";
const string SS_CREATURE_EVENT_ON_COMBAT_ROUND_END   = "OnCreatureCombatRoundEnd";
const string SS_CREATURE_EVENT_ON_CONVERSATION       = "OnCreatureConversation";
const string SS_CREATURE_EVENT_ON_CONVERSATION_ABORT = "OnCreatureConversationAbort";
const string SS_CREATURE_EVENT_ON_CONVERSATION_END   = "OnCreatureConversationEnd";
const string SS_CREATURE_EVENT_ON_DAMAGED            = "OnCreatureDamaged";
const string SS_CREATURE_EVENT_ON_DEATH              = "OnCreatureDeath";
const string SS_CREATURE_EVENT_ON_DISTURBED          = "OnCreatureDisturbed";
const string SS_CREATURE_EVENT_ON_HEARTBEAT          = "OnCreatureHeartBeat";
const string SS_CREATURE_EVENT_ON_PERCEPTION         = "OnCreaturePerception";
const string SS_CREATURE_EVENT_ON_PHYSICAL_ATTACKED  = "OnCreaturePhysicalAttacked";
const string SS_CREATURE_EVENT_ON_RESTED             = "OnCreatureRested";
const string SS_CREATURE_EVENT_ON_SPAWN              = "OnCreatureSpawn";
const string SS_CREATURE_EVENT_ON_SPELL_CAST_AT      = "OnCreatureSpellCastAt";
const string SS_CREATURE_EVENT_ON_USER_DEFINED       = "OnCreatureUserDefined";

// Door Events
const string SS_DOOR_EVENT_ON_AREA_TRANSITION_CLICK = "OnDoorAreaTransitionClick";
const string SS_DOOR_EVENT_ON_CLOSE                 = "OnDoorClose";
const string SS_DOOR_EVENT_ON_DAMAGED               = "OnDoorDamaged";
const string SS_DOOR_EVENT_ON_DEATH                 = "OnDoorDeath";
const string SS_DOOR_EVENT_ON_FAIL_TO_OPEN          = "OnDoorFailToOpen";
const string SS_DOOR_EVENT_ON_HEARTBEAT             = "OnDoorHeartBeat";
const string SS_DOOR_EVENT_ON_LOCK                  = "OnDoorLock";
const string SS_DOOR_EVENT_ON_PHYSICAL_ATTACKED     = "OnDoorPhysicalAttacked";
const string SS_DOOR_EVENT_ON_OPEN                  = "OnDoorOpen";
const string SS_DOOR_EVENT_ON_SPELL_CAST_AT         = "OnDoorSpellCastAt";
const string SS_DOOR_EVENT_ON_UNLOCK                = "OnDoorUnLock";
const string SS_DOOR_EVENT_ON_USER_DEFINED          = "OnDoorUserDefined";

// Encounter Events
const string SS_ENCOUNTER_EVENT_ON_ENTER        = "OnEncounterEnter";
const string SS_ENCOUNTER_EVENT_ON_EXHAUSTED    = "OnEncounterExhausted";
const string SS_ENCOUNTER_EVENT_ON_EXIT         = "OnEncounterExit";
const string SS_ENCOUNTER_EVENT_ON_HEARTBEAT    = "OnEncounterHeartBeat";
const string SS_ENCOUNTER_EVENT_ON_USER_DEFINED = "OnEncounterUserDefined";

// Placeable Events
const string SS_PLACEABLE_EVENT_ON_CLICK             = "OnPlaceableClick";
const string SS_PLACEABLE_EVENT_ON_CLOSE             = "OnPlaceableClose";
const string SS_PLACEABLE_EVENT_ON_DAMAGED           = "OnPlaceableDamaged";
const string SS_PLACEABLE_EVENT_ON_DEATH             = "OnPlaceableDeath";
const string SS_PLACEABLE_EVENT_ON_HEARTBEAT         = "OnPlaceableHeartBeat";
const string SS_PLACEABLE_EVENT_ON_DISTURBED         = "OnPlaceableDisturbed";
const string SS_PLACEABLE_EVENT_ON_LOCK              = "OnPlaceableLock";
const string SS_PLACEABLE_EVENT_ON_PHYSICAL_ATTACKED = "OnPlaceablePhysicalAttacked";
const string SS_PLACEABLE_EVENT_ON_OPEN              = "OnPlaceableOpen";
const string SS_PLACEABLE_EVENT_ON_SPELL_CAST_AT     = "OnPlaceableSpellCastAt";
const string SS_PLACEABLE_EVENT_ON_UNLOCK            = "OnPlaceableUnLock";
const string SS_PLACEABLE_EVENT_ON_USED              = "OnPlaceableUsed";
const string SS_PLACEABLE_EVENT_ON_USER_DEFINED      = "OnPlaceableUserDefined";

// Store Events
const string SS_STORE_EVENT_ON_OPEN  = "OnStoreOpen";
const string SS_STORE_EVENT_ON_CLOSE = "OnStoreClose";

// Trap Events
const string SS_TRAP_EVENT_ON_DISARM    = "OnTrapDisarm";
const string SS_TRAP_EVENT_ON_TRIGGERED = "OnTrapTriggered";

// Trigger Events
const string SS_TRIGGER_EVENT_ON_AREA_TRANSITION_CLICK = "OnTriggerAreaTransitionClick";
const string SS_TRIGGER_EVENT_ON_CLICK                 = "OnTriggerClick";
const string SS_TRIGGER_EVENT_ON_ENTER                 = "OnTriggerEnter";
const string SS_TRIGGER_EVENT_ON_EXIT                  = "OnTriggerExit";
const string SS_TRIGGER_EVENT_ON_HEARTBEAT             = "OnTriggerHeartBeat";
const string SS_TRIGGER_EVENT_ON_USER_DEFINED          = "OnTriggerUserDefined";

// Text Strings
const string SS_TEXT_BOOT_PC = "You have been booted. ";
const string SS_TEXT_BOOT_DM = " has been booted. ";
const string SS_TEXT_SENDING_TO_SAVED_LOCATION = "Sending you to your last saved location...";
const string SS_TEXT_NO_SAVED_LOCATION_FOUND = "No saved location found. Sending you to the default starting location...";
const string SS_TEXT_PLAYER_HAS_DIED = " was killed by ";
const string SS_TEXT_PLAYER_HAS_DIED2 = "in area ";
const string SS_TEXT_YOU_HAVE_DIED = "You have died.";
const string SS_TEXT_PLAYER_DATA_ITEM_CREATED = "Successfully created player data item.";
const string SS_TEXT_REST_NOT_ALLOWED_HERE = "You may not rest here.";
const string SS_TEXT_PLAYER_MENU_ROOT_NODE = "Welcome to the player menu. What would you like to do?";
const string SS_TEXT_PLAYER_MENU_CANCEL = "Cancel";
const string SS_TEXT_REST_MENU_ROOT_NODE = "What would you like to do?";
const string SS_TEXT_REST_MENU_DEFAULT = "Rest for eight hours.";
const string SS_TEXT_REST_MENU_CANCEL = "Cancel";
const string SS_TEXT_CANNOT_USE_ON_TARGET = "You cannot use that item on that.";

// Error Messages
const string SS_TEXT_ERROR_PC_NAME_TOO_LONG = "Error: Character name is too long.";
const string SS_TEXT_ERROR_PLAYER_DATA_ITEM_NOT_CREATED = "Error: Player data item not created.";

// Warnings
const string SS_TEXT_WARNING_INVALID_PCID = " logged in with a PCID belonging to ";
const string SS_TEXT_WARNING_ASSIGNING_NEW_PCID = ". Assigning new PCID...";

// SQL Return Values
const int SQL_SUCCESS = 1;
const int SQL_ERROR   = 0;

// SQL NWNX Flags
const string SQL_NWNX        = "NWNX";
const string SQL_SPACER      = "NWNX!ODBC!SPACER";
const string SQL_EXEC        = "NWNX!ODBC!EXEC";
const string SQL_FETCH       = "NWNX!ODBC!FETCH";
const string SQL_SCORCO      = "NWNX!ODBC!SETSCORCOSQL";
const string SQL_CURRENT_ROW = "NWNX_ODBC_CurrentRow";
const string SQL_AREA        = "#AREA#";
const string SQL_ORIENTATION = "#ORIENTATION#";
const string SQL_VECTOR_X    = "#POSITION_X#";
const string SQL_VECTOR_Y    = "#POSITION_Y#";
const string SQL_VECTOR_Z    = "#POSITION_Z#";
const string SQL_VECTOR_END  = "#END#";

const string SQL_TABLE_PWDATA       = "pwdata";
const string SQL_TABLE_PCDATA       = "pcdata";
const string SQL_TABLE_PLAYERS      = "players";
const string SQL_TABLE_CHARACTERS   = "characters";
const string SQL_TABLE_PWOBJECTDATA = "pwobjectdata";
const string SQL_TABLE_PCOBJECTDATA = "pcobjectdata";

// SQL Query Strings
const string SQL_SELECT_COUNT            = "SELECT count(*) FROM ";
const string SQL_SHOW_DATABASES          = "SHOW DATABASES";
const string SQL_CREATE_TABLE_PWDATA     = "CREATE TABLE pwdata (Tag varchar(64) NOT NULL default '', VarName varchar(64) NOT NULL default '', Value varchar(255) NOT NULL default '', TimeStamp timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, PRIMARY KEY (VarName, Tag))";
const string SQL_CREATE_TABLE_PCDATA     = "CREATE TABLE pcdata (PCID varchar(10) NOT NULL default '0', VarName varchar(64) NOT NULL default '', Value varchar(255) NOT NULL default '', TimeStamp timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, PRIMARY KEY (VarName, PCID))";
const string SQL_CREATE_TABLE_PLAYERS    = "CREATE TABLE players (Player varchar(64) NOT NULL default '', CDKey varchar(20) NOT NULL default '', IPAddress varchar(32) NOT NULL default '', Ban tinyint(1) NOT NULL default '0', TimeStamp timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, PRIMARY KEY (Player, CDKey, IPAddress))";
const string SQL_CREATE_TABLE_CHARACTERS = "CREATE TABLE characters (PCID varchar(10) NOT NULL default '0', Name char(64) NOT NULL default '', Player char(64) NOT NULL default '', Online tinyint(1) NOT NULL default '0', TimeStamp timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, PRIMARY KEY (Name, Player))";
const string SQL_CREATE_TABLE_PWOBJECTDATA = "CREATE TABLE pwobjectdata (Tag varchar(64) NOT NULL default '', VarName varchar(64) NOT NULL default '', Value BLOB, TimeStamp timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, PRIMARY KEY (VarName, Tag))";
const string SQL_CREATE_TABLE_PCOBJECTDATA = "CREATE TABLE pcobjectdata (PCID varchar(10) NOT NULL default '0', VarName varchar(64) NOT NULL default '', Value BLOB, TimeStamp timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, PRIMARY KEY (VarName, PCID))";

// SQL Error Messages
const string SQL_ERROR_COULD_NOT_CONNECT = "Error: Could not connect to the MySQL database.";
const string SQL_ERROR_COULD_NOT_CREATE_TABLE = "ERROR: Could not create table '";

// SHC String Manipulation
const string NEW_LINE  = "\n";
const string COLOR_END = "</c>";

// COLOR_TOKEN by rdjparadis. Used to generate colors from RGB values. NEVER modify this string.
const string COLOR_TOKEN = "                  ##################$%&'()*+,-./0123456789:;;==?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[[]^_`abcdefghijklmnopqrstuvwxyz{|}~~ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü°°¢£§•¶ß®©™´¨¨ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛˛";

// Color constants. In format <cRGB> where RGB are ALT codes (0-0255) for colors
const string COLOR_BLACK        = "<c   >";
const string COLOR_BLUE         = "<cÑÜÏ>";
const string COLOR_BLUE_DARK    = "<c74∞>";
const string COLOR_BLUE_LIGHT   = "<c≥Û˛>";    // Cyan
const string COLOR_BROWN        = "<cúR0>";
const string COLOR_BROWN_LIGHT  = "<c–ÅK>";
const string COLOR_DIVINE       = "<c˛Ï⁄>";
const string COLOR_GOLD         = "<c˝’ >";
const string COLOR_GRAY         = "<c|||>";
const string COLOR_GRAY_DARK    = "<cZZZ>";
const string COLOR_GRAY_LIGHT   = "<c¥¥¥>";
const string COLOR_GREEN        = "<c=…=>";
const string COLOR_GREEN_DARK   = "<c d >";
const string COLOR_GREEN_LIGHT  = "<c|˝ >";
const string COLOR_ORANGE       = "<c˛§ >";
const string COLOR_ORANGE_DARK  = "<c˛| >";
const string COLOR_ORANGE_LIGHT = "<c˛∏ >";
const string COLOR_RED          = "<c˛(;>";
const string COLOR_RED_DARK     = "<cú99>";
const string COLOR_RED_LIGHT    = "<c˙aU>";
const string COLOR_PINK         = "<c˙k∞>";
const string COLOR_PURPLE       = "<cñ2»>";
const string COLOR_TURQUOISE    = "<cK”Œ>";
const string COLOR_VIOLET       = "<cÈÑÁ>";
const string COLOR_VIOLET_LIGHT = "<cÛó¯>";
const string COLOR_VIOLET_DARK  = "<cƒ\ƒ>";
const string COLOR_WHITE        = "<c˛˛˛>";
const string COLOR_YELLOW       = "<c˛˛ >";
const string COLOR_YELLOW_DARK  = "<c–Œ >";
const string COLOR_YELLOW_LIGHT = "<c˛˛´>";

// Color codes by function
const string COLOR_DEFAULT   = COLOR_WHITE;
const string COLOR_ATTENTION = COLOR_ORANGE;
const string COLOR_BUG       = COLOR_RED_DARK;
const string COLOR_FAIL      = COLOR_RED;
const string COLOR_SUCCESS   = COLOR_GREEN_LIGHT;
const string COLOR_DEBUG     = COLOR_GRAY_LIGHT;
const string COLOR_INFO      = COLOR_BROWN_LIGHT;
const string COLOR_MAGIC     = COLOR_VIOLET;

// Predefined text icons
const string TEXT_LINE_MINUS      = "-------------------------------------------------";
const string TEXT_LINE_STARS      = "*************************************************";
const string TEXT_LINE_EQUAL      = "=================================================";
const string TEXT_LINE_PLUS       = "+++++++++++++++++++++++++++++++++++++++++++++++++";
const string TEXT_LINE_POUND      = "#################################################";
const string TEXT_LINE_WAVE       = "/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/";
const string TEXT_LINE_TILDE      = "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
const string TEXT_LINE_RIGHT      = ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
const string TEXT_LINE_LEFT       = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";
const string TEXT_LINE_UNDERSCORE = "_________________________________________________";

// NBDE database name
const string SS_CORE_DATABASE = "SS_CORE";

// Flagsets
const int FLAG1           = 0x00000001;
const int FLAG2           = 0x00000002;
const int FLAG3           = 0x00000004;
const int FLAG4           = 0x00000008;
const int FLAG5           = 0x00000010;
const int FLAG6           = 0x00000020;
const int FLAG7           = 0x00000040;
const int FLAG8           = 0x00000080;
const int FLAG9           = 0x00000100;
const int FLAG10          = 0x00000200;
const int FLAG11          = 0x00000400;
const int FLAG12          = 0x00000800;
const int FLAG13          = 0x00001000;
const int FLAG14          = 0x00002000;
const int FLAG15          = 0x00004000;
const int FLAG16          = 0x00008000;
const int FLAG17          = 0x00010000;
const int FLAG18          = 0x00020000;
const int FLAG19          = 0x00040000;
const int FLAG20          = 0x00080000;
const int FLAG21          = 0x00100000;
const int FLAG22          = 0x00200000;
const int FLAG23          = 0x00400000;
const int FLAG24          = 0x00800000;
const int FLAG25          = 0x01000000;
const int FLAG26          = 0x02000000;
const int FLAG27          = 0x04000000;
const int FLAG28          = 0x08000000;
const int FLAG29          = 0x10000000;
const int FLAG30          = 0x20000000;
const int FLAG31          = 0x40000000;
const int FLAG32          = 0x80000000;
const int ALLFLAGS        = 0xFFFFFFFF;
const int NOFLAGS         = 0x00000000;

const int TINYGROUP1      = 0x0000000F; // 4 Flags per group. 8 groups per flagset.
const int TINYGROUP2      = 0x000000F0; // Value range 0-15.
const int TINYGROUP3      = 0x00000F00;
const int TINYGROUP4      = 0x0000F000;
const int TINYGROUP5      = 0x000F0000;
const int TINYGROUP6      = 0x00F00000;
const int TINYGROUP7      = 0x0F000000;
const int TINYGROUP8      = 0xF0000000;
const int ALLTINYGROUPS   = 0xFFFFFFFF;

const int SMALLGROUP1     = 0x0000003F; // 6 Flags per group. 5 groups per flagset plus 1 extra group with only 2 flags.
const int SMALLGROUP2     = 0x00000FC0; // Value range 0-63.
const int SMALLGROUP3     = 0x0003F000;
const int SMALLGROUP4     = 0x00FC0000;
const int SMALLGROUP5     = 0x3F000000;
const int SMALLGROUPX     = 0xC0000000; // Special Group with only 2 flags. Value range 0-3.
const int ALLSMALLGROUPS  = 0x3FFFFFFF;

const int MEDIUMGROUP1    = 0x000000FF; // 8 Flags per group. 4 groups per flagset.
const int MEDIUMGROUP2    = 0x0000FF00; // Value range 0-255.
const int MEDIUMGROUP3    = 0x00FF0000;
const int MEDIUMGROUP4    = 0xFF000000;
const int ALLMEDIUMGROUPS = 0xFFFFFFFF;

const int LARGEGROUP1     = 0x000003FF; // 10 Flags per group. 3 groups per flagset plus 1 extra group with only 2 flags.
const int LARGEGROUP2     = 0x000FFC00; // Value range 0-1023
const int LARGEGROUP3     = 0x3FF00000;
const int LARGEGROUPX     = 0xC0000000; // Special Group with only 2 flags. Value range 0-3.
const int ALLLARGEGROUPS  = 0x3FFFFFFF;

const int HUGEGROUP1      = 0x0000FFFF; // 16 Flags per group. 2 groups per flagset.
const int HUGEGROUP2      = 0xFFFF0000; // Value range 0-65535
const int ALLHUGEGROUPS   = 0xFFFFFFFF;

const int ALLGROUPS       = 0xFFFFFFFF;
const int GROUPVALUE      = 0xFFFFFFFF;
const int NOGROUPS        = 0x00000000;

const string DECTOBINARY  = "0000000100100011010001010110011110001001101010111100110111101111";
const string FLAGS_SUFFIX = "";

// Core Flagsets
const string SS_CURRENT_TIME = "SS_CURRENT_TIME";
const int SS_CURRENT_YEAR    = HUGEGROUP1;
const int SS_CURRENT_MONTH   = TINYGROUP5;
const int SS_CURRENT_DAY     = 0x01F00000; // FLAG21 | FLAG22 | FLAG23 | FLAG24 | FLAG25
const int SS_CURRENT_HOUR    = 0x3E000000; // FLAG26 | FLAG27 | FLAG28 | FLAG29 | FLAG30

const string SS_SERVER_START_TIME = "SS_SERVER_START_TIME";
const int SS_SERVER_START_YEAR    = HUGEGROUP1;
const int SS_SERVER_START_MONTH   = TINYGROUP5;
const int SS_SERVER_START_DAY     = 0x01F00000; // FLAG21 | FLAG22 | FLAG23 | FLAG24 | FLAG25
const int SS_SERVER_START_HOUR    = 0x3E000000; // FLAG26 | FLAG27 | FLAG28 | FLAG29 | FLAG30
