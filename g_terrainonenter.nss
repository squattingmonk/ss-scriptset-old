/*
Filename:           g_terrainonenter
System:             Generic (hook-in script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       February 05, 2009
Summary:
Trigger OnEnter script. This script will apply terrain effects to the entering
creature.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:
*/

#include "g_i_generic"

void main()
{
    object oCreature = GetEnteringObject();
    if (GetIsDM(oCreature) || (!GetIsPC(oCreature) && SS_TERRAIN_TRIGGER_PC_ONLY))
        return;

    object oTrigger = OBJECT_SELF;
    effect eEffect = ss_GetTerrainEffect(oTrigger);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oCreature);
    if(GetIsPC(oCreature))
        ss_FloatingColorText(SS_TEXT_TERRAIN_TRIGGER_ENTER, oCreature, FALSE, COLOR_INFO);
}
