/*
Filename:           prr_c_main
System:             Persistent Reputation and Reaction (configuration script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Nov. 2, 2007
Summary:
Persistent Reputation and Reaction configuration settings. This script contains
user-definable toggles and settings for the PRR system.

This script is freely editable by developers. It should not contain any
constants that should not be overridable by other builders. Please put those in
prr_i_constants.

All below constants may be overridden, but do not alter the names of the
constants.

This script is consumed by prr_i_main as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// The tag of the waypoint which will store important variables of the PRR
// system. Only change this if you are using a different waypoint than that
// included in the ERF.
// Default value: PRR_DATAPOINT
const string PRR_DATAPOINT = "PRR_DATAPOINT";

// Set to TRUE to enable the PC's charisma to affect the NPC's reaction to him.
const int PRR_USE_CHARISMA_MODIFIER = TRUE;

// A number by which the PC's Charisma modifier is multiplied when determining
// its effect on an NPC's reaction to him. Set this higher or lower the more or
// less effect you want Charisma to have on reaction (default 2).
const int PRR_CHARISMA_MODIFIER_TO_REACTION = 2;

// The DCs for skill checks of low, mid, and high skill checks.
const int PRR_DC_LOW  = 5;
const int PRR_DC_MID  = 15;
const int PRR_DC_HIGH = 25;

// The amounts of reaction shifts for low, mid, and high shifts.
const int PRR_SHIFT_LOW  = 5;
const int PRR_SHIFT_MID  = 15;
const int PRR_SHIFT_HIGH = 25;

// The minimum reaction level for low, mid, and high reactions.
const int PRR_REACTION_LOW  = 0;
const int PRR_REACTION_MID  = 30;
const int PRR_REACTION_HIGH = 90;

// The minimum and maximum amount a PC's reputation with an NPC can be. Setting
// the max amount > 100 and the low amount < 0 makes improving an NPC's reaction
// via conversation more effective than other methods.
const int PRR_REPUTATION_MAX = 150;
const int PRR_REPUTATION_MIN = -50;

// Whether the NPC's reaction toward the PC effects how hard social skills are
// to use. When set to TRUE, skill checks modify the DCs above to be easier when
// the NPC likes the PC and harder when he doesn't. Setting it to FALSE uses the
// static DCs set above with no modifications. This can be overridden on
// specific skill checks.
const int PRR_USE_REACTIONS_IN_SKILL_ROLLS = TRUE;

// The default greetings from NPCs to PCs they've met, organized by reaction.
// Set these to whatever you want NPCs who've not had special greetings defined
// to have.
const string PRR_GREETING_DEFAULT_HIGH = "Ah, welcome back, my friend.";
const string PRR_GREETING_DEFAULT_MID  = "Hello again.";
const string PRR_GREETING_DEFAULT_LOW  = "Oh, it's you again.";
const string PRR_GREETING_DEFAULT      = "Hey there.";

// The default statements from NPCs to PCs who ask for information, organized by
// reaction. Set these to whatever you want NPCs who've not had special
// statements defined to have.
const string PRR_HELPFULNESS_DEFAULT_HIGH = "I'll help however I can.";
const string PRR_HELPFULNESS_DEFAULT_MID  = "What is it?";
const string PRR_HELPFULNESS_DEFAULT_LOW  = "Bug off!";
const string PRR_HELPFULNESS_DEFAULT      = "What do you need?";

