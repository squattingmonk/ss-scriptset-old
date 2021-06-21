/*
Filename:           cs_i_constants
System:             Cut Scene System (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Mar. 04, 2008
Summary:
Cut Scene System constants definitions. This file holds the constants commonly
used throughout the core Cut Scene system.

This script is accessible from cs_i_main.

This is John Bye's Gestalt Cutscene System, modified for Shadows & Silver.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

const string CS_SCENE = "CS_SCENE";
const string CS_SCENE_ID = "CS_SCENE_ID";
const string CS_SCENE_CURRENT = "CS_SCENE_CURRENT";
const string CS_SCENE_PREFIX = "cs_scene";

const int CS_FADE_IN = 1;
const int CS_FADE_OUT = 2;
const int CS_FADE_CROSS = 3;

const int CS_ANIMATION_NONE = 999;
const int CS_NORMAL = ANIMATION_LOOPING_TALK_NORMAL;
const int CS_FORCEFUL = ANIMATION_LOOPING_TALK_FORCEFUL;
const int CS_LAUGHING = ANIMATION_LOOPING_TALK_LAUGHING;
const int CS_PLEADING = ANIMATION_LOOPING_TALK_PLEADING;

const int CS_INVENTORY_SLOT_BEST_MELEE = 999;
const int CS_INVENTORY_SLOT_BEST_RANGED = 998;
const int CS_INVENTORY_SLOT_BEST_ARMOUR = 997;
const int CS_INVENTORY_SLOT_NONE = 996;

const int CS_INSTANT = DURATION_TYPE_INSTANT;
const int CS_PERMANENT = DURATION_TYPE_PERMANENT;
const int CS_TEMPORARY = DURATION_TYPE_TEMPORARY;

const int CS_TRACK_CURRENT = 998;
const int CS_TRACK_ORIGINAL = 999;

const int CS_EFFECT_TYPE_CUTSCENE_EFFECTS = -1;

const int CS_NW_FLAG_AMBIENT_ANIMATIONS          = 0x00080000;
const int CS_NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS = 0x00200000;
const int CS_NW_FLAG_AMBIENT_ANIMATIONS_AVIAN    = 0x00800000;
