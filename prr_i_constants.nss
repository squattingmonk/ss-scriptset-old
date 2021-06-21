/*
Filename:           prr_i_constants
System:             Persistent Reputation and Reaction (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Nov. 2, 2007
Summary:
Persistent Reputation and Reaction system constants definition script. This file
contains the constants commonly used in the PRR system. This script is consumed
by prr_i_main as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

const string PRR_ADD_ON_PREFIX     = "PRRAddOn";
const string PRR_REPUTATION_PREFIX = "PRR_REPUTATION_";
const string PRR_GREET_PREFIX      = "PRR_GREET_";
const string PRR_PERSONAL_PREFIX   = "PRR_PERSONAL_";
const string PRR_BLUFF_PREFIX      = "PRR_BLUFF_";
const string PRR_INTIMIDATE_PREFIX = "PRR_INTIMIDATE_";
const string PRR_PERFORM_PREFIX    = "PRR_PERFORM_";
const string PRR_PERSUADE_PREFIX   = "PRR_PERSUADE_";
const string PRR_TAUNT_PREFIX      = "PRR_TAUNT_";
const string PRR_IDLE_PREFIX       = "PRR_IDLE_";

const string PRR_GREETING_HIGH = "PRR_GREETING_HIGH";
const string PRR_GREETING_MID  = "PRR_GREETING_MID";
const string PRR_GREETING_LOW  = "PRR_GREETING_LOW";
const string PRR_GREETING      = "PRR_GREETING";

const string PRR_HELPFULNESS_HIGH = "PRR_HELPFULNESS_HIGH";
const string PRR_HELPFULNESS_MID  = "PRR_HELPFULNESS_MID";
const string PRR_HELPFULNESS_LOW  = "PRR_HELPFULNESS_LOW";
const string PRR_HELPFULNESS      = "PRR_HELPFULNESS";

const int PRR_TOKEN_HELPFULNESS = 40000;
const int PRR_TOKEN_GREETING    = 40001;
const int PRR_TOKEN_RUMOR       = 40002;

const string PRR_FACTION                = "PRR_FACTION";
const string PRR_FACTION_FOCUS          = "PRR_FACTION_FOCUS";
const string PRR_REPUTATION_INIT_PREFIX = "PRR_REPUTATION_INIT_";

const string PRR_DM_TOOL_CURRENT_TARGET = "PRR_DM_TOOL_CURRENT_TARGET";
const string PRR_DM_TOOL_PREVIOUS_TARGET = "PRR_DM_TOOL_PREVIOUS_TARGET";
const string PRR_DM_TOOL_NEXT_TARGET = "PRR_DM_TOOL_NEXT_TARGET";
const string PRR_DM_TOOL_NPC     = "PRR_DM_TOOL_NPC";
const string PRR_DM_TOOL_REPUTATION = "PRR_DM_TOOL_REPUTATION";
const string PRR_DM_TOOL_DIALOG  = "prr_dmtool";

const int PRR_TOKEN_DM_TOOL = 40100;
const int PRR_TOKEN_DM_TOOL_NPC    = 40101;
const int PRR_TOKEN_DM_TOOL_REPUTATION = 40102;
const int PRR_TOKEN_DM_TOOL_REPUTATION_LOW = 40103;
const int PRR_TOKEN_DM_TOOL_REPUTATION_MID = 40104;
const int PRR_TOKEN_DM_TOOL_REPUTATION_HIGH = 40105;
const int PRR_TOKEN_DM_TOOL_REPUTATION_EXTREME = 40106;

const string PRR_TEXT_DM_TOOL_TARGET_INVALID = "Error: invalid target.";

