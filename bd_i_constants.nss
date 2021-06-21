/*
Filename:           bd_i_constants
System:             Bleeding and Death (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jan. 30, 2009
Summary:
Bleeding and Death system constants definition script. This file contains the
constants commonly used in the Bleeding and Death system. This script is
consumed by bd_i_main as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


const string BD_BLEED_TIMER_SCRIPT   = "bd_bleedtimer";
const string BD_RESPAWN_TIMER_SCRIPT = "bd_respawntimer";
const string BD_DEATH_WAYPOINT       = "bd_wp_death";

// Local variables
const string BD_LAST_HIT_POINTS    = "BD_LAST_HIT_POINTS";
const string BD_BLEED_TIMER_ID     = "BD_BLEED_TIMER_ID";
const string BD_RESPAWN_TIMER_ID   = "BD_RESPAWN_TIMER_ID";
const string BD_RESPAWN_TIMER_RUNS = "BD_RESPAWN_TIMER_RUNS";
const string BD_NEGATIVE_HP_LIMIT  = "BD_NEGATIVE_HP_LIMIT";
const string BD_PREVIOUS_MIRACULOUS_RECOVERIES = "BD_PREVIOUS_MIRACULOUS_RECOVERIES";

// Text strings
const string BD_TEXT_RECOVERED_FROM_DYING = "You have become revived and are no longer in danger of bleeding to death.";
const string BD_TEXT_WOUNDS_BLEED = "Your wounds continue to bleed. You get ever closer to death.";
const string BD_TEXT_DEATH_GUI_MESSAGE = "You can wait for help for up to ten minutes or put your life into fate's hands by clicking Respawn.";
const string BD_TEXT_MIRACULOUS_RECOVERY = "You have miraculously recovered from death!";
