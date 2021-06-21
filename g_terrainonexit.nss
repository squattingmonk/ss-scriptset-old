/*
Filename:           g_terrainonexit
System:             Generic (hook-in script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       February 05, 2009
Summary:
Trigger OnExit script. This script will remove terrain effects of the exiting
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
    object oCreature = GetExitingObject();
    if (GetIsDM(oCreature) || (!GetIsPC(oCreature) && SS_TERRAIN_TRIGGER_PC_ONLY))
        return;

    object oTrigger = OBJECT_SELF;
    effect eEffect = GetFirstEffect(oCreature);
    while (GetEffectCreator(eEffect) != oTrigger)
        eEffect = GetNextEffect(oCreature);

    RemoveEffect(oCreature, eEffect);

    if(GetIsPC(oCreature))
        ss_FloatingColorText(SS_TEXT_TERRAIN_TRIGGER_EXIT, oCreature, FALSE, COLOR_INFO);
}


