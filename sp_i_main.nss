/*
Filename:           sp_i_main
System:             Spawn System (include script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       January 13, 2009
Summary:
Spawn system primary include script. This file holds the functions commonly used
throughout the Spawn system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

// Generic include script
#include "g_i_generic"

// Constants include script
#include "sp_i_constants"

// Configuration include script
#include "sp_c_main"


// -----------------------------------------------------------------------------
//                             Function Prototypes
// -----------------------------------------------------------------------------

// >----< sp_GetAreaSpawnPoint >----<
// <sp_i_main>
// Returns the area spawnpoint waypoint
object sp_GetAreaSpawnPoint(object oArea = OBJECT_SELF, int nNth = 0);

// >----< sp_GetUniqueSpawnPoint >----<
// <sp_i_main>
// Returns the area unique spawnpoint waypoint
object sp_GetUniqueSpawnPoint(object oArea = OBJECT_SELF, int nNth = 0);

// >----< sp_GetItemFromContainer >----<
// <sp_i_main>
// Returns a random item in the inventory of the container with tag of sTag
object sp_GetItemFromContainer(string sTag);

// >----< sp_SetRandomAbilities >----<
// <sp_i_main>
// Randomizes the abilities of oSpawnedCreature
// Original function by Olander and lord rosenkrantz
void sp_SetRandomAbilities(object oSpawnedCreature);

// >----< sp_SetEquipment >----<
// <sp_i_main>
// Gives the creature equipment based on the chests tag and probability
void sp_SetEquipment(object oSpawnedCreature, string sTag, int nChance);

// >----< sp_SetRandomHeadModel >----<
// <sp_i_main>
// Sets a random head model based on the NPC's gender and race.
void sp_SetRandomHeadModel(object oNPC = OBJECT_SELF);

// >----< sp_SetRandomName >----<
// <sp_i_main>
// Sets a random name based on the NPC's gender and race.
void sp_SetRandomName(object oNPC = OBJECT_SELF);

// >----< sp_SetRandomPhenotype >----<
// <sp_i_main>
// Sets a random phenotype for the NPC's. (Only Normal and Large are supported)
// nPercentFat - Chance to set a PHENOTYPE_BIG to the NPC. Defualt is 50%
void sp_SetRandomPhenotype(object oNPC = OBJECT_SELF, int nPercentFat = 50);

// >----< sp_SetRandomColor >----<
// <sp_i_main>
// Sets a random color for oNPC. Only colors that make sense are possible
// nColorChannel = COLOR_CHANNEL_*
void sp_SetRandomColor(int nColorChannel, object oNPC = OBJECT_SELF);

// >----< sp_SpawnCreature >----<
// <sp_i_main>
// Spawns a single creature, based on the spawnpoint
void sp_SpawnCreature(string sTemplate, object oSpawnPoint);

// >----< sp_DoAreaSpawns >----<
// <sp_i_main>
// Spawns creatures in an area
void sp_DoAreaSpawns(object oArea = OBJECT_SELF);

// >----< sp_DoAreaDeSpawns >----<
// <sp_i_main>
// DeSpawns creatures in an area
void sp_DoAreaDeSpawns(object oArea = OBJECT_SELF);


// -----------------------------------------------------------------------------
//                          Function Implementations
// -----------------------------------------------------------------------------

// >----< sp_GetAreaSpawnPoint >----<
// <sp_i_main>
// Returns the area spawnpoint waypoint
object sp_GetAreaSpawnPoint(object oArea = OBJECT_SELF, int nNth = 0)
{

        object oSpawnPoint = GetObjectByTag(SP_AREA_SPAWNPOINT, nNth);

        // Check if oSpawnPoint is in oArea
        location lLoc = GetLocation(oSpawnPoint);

        if (GetAreaFromLocation(lLoc) == oArea)
           return oSpawnPoint;

        else return OBJECT_INVALID;


}

// >----< sp_GetUniqueSpawnPoint >----<
// <sp_i_main>
// Returns the area unique spawnpoint waypoint
object sp_GetUniqueSpawnPoint(object oArea = OBJECT_SELF, int nNth = 0)
{
        object oSpawnPoint = GetObjectByTag(SP_UNIQUE_SPAWNPOINT, nNth);

        // Check if oSpawnPoint is in oArea
        location lLoc = GetLocation(oSpawnPoint);

        if (GetAreaFromLocation(lLoc) == oArea)
                  return oSpawnPoint;

        else  return OBJECT_INVALID;
}

// >----< sp_GetItemFromContainer >----<
// <sp_i_main>
// Returns a random item in the inventory of the container with tag of sTag
object sp_GetItemFromContainer(string sTag)
{
      object oContainer = GetObjectByTag(sTag);

      int nItems = ss_GetItemCount(oContainer);
      int i = ss_Random(nItems);

      object oItem = GetFirstItemInInventory(oContainer);
      while (i > 0)
      {
        oItem = GetNextItemInInventory(oContainer);
        i--;
      }

      return oItem;
}

// >----< sp_SetRandomAbilities >----<
// <sp_i_main>
// Randomizes the abilities of oSpawnedCreature
// Original function by Olander and lord rosenkrantz
void sp_SetRandomAbilities(object oSpawnedCreature)
{

    if(!SP_USE_STAT_RANDOMIZATION_SUBSYSTEM) return;

    //BonusMalus Effects
    effect eSpawnStrengthBonus;
    effect eSpawnStrengthMalus;
    effect eSpawnDexterityBonus;
    effect eSpawnDexterityMalus;
    effect eSpawnConstitutionBonus;
    effect eSpawnConstitutionMalus;
    effect eSpawnWisdomBonus;
    effect eSpawnWisdomMalus;
    effect eSpawnIntelligenceBonus;
    effect eSpawnIntelligenceMalus;
    effect eSpawnCharismaBonus;
    effect eSpawnCharismaMalus;
    effect eSpawnAttackBonus;
    effect eSpawnAttackMalus;
    effect eSpawnArmorClassBonus;
    effect eSpawnArmorClassMalus;
    effect eSpawnSavingThrowFortBonus;
    effect eSpawnSavingThrowFortMalus;
    effect eSpawnSavingThrowDexBonus;
    effect eSpawnSavingThrowDexMalus;
    effect eSpawnSavingThrowWillBonus;
    effect eSpawnSavingThrowWillMalus;
    effect eSpawnSkillDisciplineBonus;
    effect eSpawnSkillDisciplineMalus;
    effect eSpawnSkillSpotBonus;
    effect eSpawnSkillSpotMalus;
    effect eSpawnSkillListenBonus;
    effect eSpawnSkillListenMalus;
    effect eSpawnSkillConcentrationBonus;
    effect eSpawnSkillConcentrationMalus;
    effect eSpawnExtraAttackBonus;

  //For undead, elementals, planars, constructs, vermin racial types only
  effect eSpawnTurningResistenceBonus;
  effect eSpawnTurningResistenceMalus;

  //Final BonusMalus linked effects
  effect eBonusMalusLink;


    switch (d3())
    {
      case 1:
        eSpawnStrengthBonus = EffectAbilityIncrease(ABILITY_STRENGTH, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 2:
        eSpawnStrengthMalus = EffectAbilityDecrease(ABILITY_STRENGTH, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnDexterityBonus = EffectAbilityIncrease(ABILITY_DEXTERITY, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 2:
        eSpawnDexterityMalus = EffectAbilityDecrease(ABILITY_DEXTERITY, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnConstitutionBonus = EffectAbilityIncrease(ABILITY_CONSTITUTION, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 2:
        eSpawnConstitutionMalus = EffectAbilityDecrease(ABILITY_CONSTITUTION, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnWisdomBonus = EffectAbilityIncrease(ABILITY_WISDOM, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 2:
        eSpawnWisdomMalus = EffectAbilityDecrease(ABILITY_WISDOM, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnIntelligenceBonus = EffectAbilityIncrease(ABILITY_INTELLIGENCE, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 2:
        eSpawnIntelligenceMalus = EffectAbilityDecrease(ABILITY_INTELLIGENCE, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnCharismaBonus = EffectAbilityIncrease(ABILITY_CHARISMA, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 2:
        eSpawnCharismaMalus = EffectAbilityDecrease(ABILITY_CHARISMA, ss_Random(SP_STAT_RANDOMIZATION_OFFSET)+1);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnAttackBonus = EffectAttackIncrease(ATTACK_BONUS_MISC, ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1);
        break;
      case 2:
        eSpawnAttackMalus = EffectAttackDecrease(ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1, ATTACK_BONUS_MISC);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnArmorClassBonus = EffectACIncrease(ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
        break;
      case 2:
        eSpawnArmorClassMalus = EffectACDecrease(ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnSavingThrowFortBonus = EffectSavingThrowIncrease(SAVING_THROW_FORT, ss_Random(SP_STAT_RANDOMIZATION_OFFSET+1)+1, SAVING_THROW_ALL);
        break;
      case 2:
        eSpawnSavingThrowFortMalus = EffectSavingThrowDecrease(SAVING_THROW_FORT, ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1, SAVING_THROW_ALL);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnSavingThrowDexBonus = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, ss_Random(SP_STAT_RANDOMIZATION_OFFSET+1)+1, SAVING_THROW_ALL);
        break;
      case 2:
        eSpawnSavingThrowDexMalus = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1, SAVING_THROW_ALL);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnSavingThrowWillBonus = EffectSavingThrowIncrease(SAVING_THROW_WILL, ss_Random(SP_STAT_RANDOMIZATION_OFFSET+1)+1, SAVING_THROW_ALL);
        break;
      case 2:
        eSpawnSavingThrowWillMalus = EffectSavingThrowDecrease(SAVING_THROW_WILL, ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1, SAVING_THROW_ALL);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnSkillDisciplineBonus = EffectSkillIncrease(SKILL_DISCIPLINE, ss_Random(SP_STAT_RANDOMIZATION_OFFSET+1)+1);
        break;
      case 2:
        eSpawnSkillDisciplineMalus = EffectSkillDecrease(SKILL_DISCIPLINE, ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnSkillSpotBonus = EffectSkillIncrease(SKILL_SPOT, ss_Random(SP_STAT_RANDOMIZATION_OFFSET+1)+1);
        break;
      case 2:
        eSpawnSkillSpotMalus = EffectSkillDecrease(SKILL_SPOT, ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnSkillListenBonus = EffectSkillIncrease(SKILL_LISTEN, ss_Random(SP_STAT_RANDOMIZATION_OFFSET+1)+1);
        break;
      case 2:
        eSpawnSkillListenMalus = EffectSkillDecrease(SKILL_LISTEN, ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1);
        break;
      case 3:
        break;
    }

    switch (d3())
    {
      case 1:
        eSpawnSkillConcentrationBonus = EffectSkillIncrease(SKILL_CONCENTRATION, ss_Random(SP_STAT_RANDOMIZATION_OFFSET+1)+1);
        break;
      case 2:
        eSpawnSkillConcentrationMalus = EffectSkillDecrease(SKILL_CONCENTRATION, ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1);
        break;
      case 3:
        break;
    }

    //Creature has a slight chance to get an extra attack per round
    switch (d10())
    {
      case 10:
        eSpawnExtraAttackBonus = EffectModifyAttacks(1);
        break;
        default:
        break;
    }

    /*
    Racial types that are subjected to turn undead ability type
    receive a random bonus or malus to their ability to resist it
    */
    if ((GetRacialType(oSpawnedCreature) == RACIAL_TYPE_CONSTRUCT)
      || (GetRacialType(oSpawnedCreature) == RACIAL_TYPE_ELEMENTAL)
      || (GetRacialType(oSpawnedCreature) == RACIAL_TYPE_OUTSIDER)
      || (GetRacialType(oSpawnedCreature) == RACIAL_TYPE_UNDEAD)
      || (GetRacialType(oSpawnedCreature) == RACIAL_TYPE_VERMIN))
    {
      switch (d3())
      {
        case 1:
          eSpawnTurningResistenceBonus = EffectTurnResistanceIncrease(ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1);
          break;
        case 2:
          eSpawnTurningResistenceMalus = EffectTurnResistanceDecrease(ss_Random(SP_STAT_RANDOMIZATION_OFFSET-1)+1);
          break;
        case 3:
          break;
      }
    }


  //Link Effects
  eBonusMalusLink = EffectLinkEffects(eSpawnStrengthBonus, eSpawnStrengthMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnDexterityBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnDexterityMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnConstitutionBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnConstitutionMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnWisdomBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnWisdomMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnIntelligenceBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnIntelligenceMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnCharismaBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnCharismaMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnAttackBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnAttackMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnArmorClassBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnArmorClassMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSavingThrowFortBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSavingThrowFortMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSavingThrowDexBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSavingThrowDexMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSavingThrowWillBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSavingThrowWillMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSkillDisciplineBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSkillDisciplineMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSkillSpotBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSkillSpotMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSkillListenBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSkillListenMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSkillConcentrationBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnSkillConcentrationMalus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnTurningResistenceBonus);
  eBonusMalusLink = EffectLinkEffects(eBonusMalusLink, eSpawnTurningResistenceMalus);

  //Makes effects non dispellable
  eBonusMalusLink = SupernaturalEffect(eBonusMalusLink);

  //Apply Effects on Creature
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusMalusLink, oSpawnedCreature);
}



// >----< sp_SetEquipment >----<
// <sp_i_main>
// Gives the creature equipment based on the chests tag and probability
void sp_SetEquipment(object oSpawnedCreature, string sTag, int nChance)
{
   while (ss_Random(100)+1 <= nChance)
   {
     object oItem = sp_GetItemFromContainer(sTag);
     oItem = CopyItem(oItem, oSpawnedCreature, TRUE);

     int nSlot = ss_GetItemEquipSlot(oItem);
     if (nSlot != -1) AssignCommand(oSpawnedCreature, ActionEquipItem(oItem, nSlot));
     nChance -= 100;
   }

}


// >----< sp_SetRandomHeadModel >----<
// <sp_i_main>
// Sets a random head model based on the NPC's gender and race.
void sp_SetRandomHeadModel(object oNPC = OBJECT_SELF)
{
    int nRace = GetRacialType(oNPC);
    int nGender = GetGender(oNPC);
    int nModel;

    switch(nGender)
    {
        case GENDER_MALE:

            switch(nRace)
            {
                case RACIAL_TYPE_DWARF:    nModel = ss_Random(SP_HEADMODEL_MAX_MALE_DWARF) + 1;     break;
                case RACIAL_TYPE_ELF:      nModel = ss_Random(SP_HEADMODEL_MAX_MALE_ELF) + 1;       break;
                case RACIAL_TYPE_GNOME:    nModel = ss_Random(SP_HEADMODEL_MAX_MALE_GNOME) + 1;     break;
                case RACIAL_TYPE_HALFELF:  nModel = ss_Random(SP_HEADMODEL_MAX_MALE_HALFELF) + 1;   break;
                case RACIAL_TYPE_HALFLING: nModel = ss_Random(SP_HEADMODEL_MAX_MALE_HALFLING) + 1;  break;
                case RACIAL_TYPE_HALFORC:  nModel = ss_Random(SP_HEADMODEL_MAX_MALE_HALFORC) + 1;   break;
                case RACIAL_TYPE_HUMAN:    nModel = ss_Random(SP_HEADMODEL_MAX_MALE_HUMAN) + 1;     break;
             }   // End nRace switch


        break;  // nGender break


        case GENDER_FEMALE:

            switch(nRace)
            {
                case RACIAL_TYPE_DWARF:    nModel = ss_Random(SP_HEADMODEL_MAX_FEMALE_DWARF) + 1;    break;
                case RACIAL_TYPE_ELF:      nModel = ss_Random(SP_HEADMODEL_MAX_FEMALE_ELF) + 1;      break;
                case RACIAL_TYPE_GNOME:    nModel = ss_Random(SP_HEADMODEL_MAX_FEMALE_GNOME) + 1;    break;
                case RACIAL_TYPE_HALFELF:  nModel = ss_Random(SP_HEADMODEL_MAX_FEMALE_HALFELF) + 1;  break;
                case RACIAL_TYPE_HALFLING: nModel = ss_Random(SP_HEADMODEL_MAX_FEMALE_HALFLING) + 1; break;
                case RACIAL_TYPE_HALFORC:  nModel = ss_Random(SP_HEADMODEL_MAX_FEMALE_HALFORC) + 1;  break;
                case RACIAL_TYPE_HUMAN:    nModel = ss_Random(SP_HEADMODEL_MAX_FEMALE_HUMAN) + 1;    break;
             }   // End nRace switch

        break;  // nGender break
    }     // End nGender switch

    SetCreatureBodyPart(CREATURE_PART_HEAD, nModel, oNPC);

}


// >----< sp_SetRandomName >----<
// <sp_i_main>
// Sets a random name based on the NPC's gender and race.
void sp_SetRandomName(object oNPC = OBJECT_SELF)
{
    int nRace = GetRacialType(oNPC);
    int nGender = GetGender(oNPC);
    int nFirstName;
    int nLastName;

    switch(nGender)
    {
        case GENDER_MALE:

            switch(nRace)
            {
                case RACIAL_TYPE_DWARF:    nFirstName = NAME_FIRST_DWARF_MALE;    nLastName = NAME_LAST_DWARF;    break;
                case RACIAL_TYPE_ELF:      nFirstName = NAME_FIRST_ELF_MALE;      nLastName = NAME_LAST_ELF;      break;
                case RACIAL_TYPE_GNOME:    nFirstName = NAME_FIRST_GNOME_MALE;    nLastName = NAME_LAST_GNOME;    break;
                case RACIAL_TYPE_HALFELF:  nFirstName = NAME_FIRST_HALFELF_MALE;  nLastName = NAME_LAST_HALFELF;  break;
                case RACIAL_TYPE_HALFLING: nFirstName = NAME_FIRST_HALFLING_MALE; nLastName = NAME_LAST_HALFLING; break;
                case RACIAL_TYPE_HALFORC:  nFirstName = NAME_FIRST_HALFORC_MALE;  nLastName = NAME_LAST_HALFORC;  break;
                case RACIAL_TYPE_HUMAN:    nFirstName = NAME_FIRST_HUMAN_MALE;    nLastName = NAME_LAST_HUMAN;    break;
            }   // End nRace switch

        break;  // nGender break

        case GENDER_FEMALE:

            switch(nRace)
            {
                case RACIAL_TYPE_DWARF:    nFirstName = NAME_FIRST_DWARF_FEMALE;    nLastName = NAME_LAST_DWARF;    break;
                case RACIAL_TYPE_ELF:      nFirstName = NAME_FIRST_ELF_FEMALE;      nLastName = NAME_LAST_ELF;      break;
                case RACIAL_TYPE_GNOME:    nFirstName = NAME_FIRST_GNOME_FEMALE;    nLastName = NAME_LAST_GNOME;    break;
                case RACIAL_TYPE_HALFELF:  nFirstName = NAME_FIRST_HALFELF_FEMALE;  nLastName = NAME_LAST_HALFELF;  break;
                case RACIAL_TYPE_HALFLING: nFirstName = NAME_FIRST_HALFLING_FEMALE; nLastName = NAME_LAST_HALFLING; break;
                case RACIAL_TYPE_HALFORC:  nFirstName = NAME_FIRST_HALFORC_FEMALE;  nLastName = NAME_LAST_HALFORC;  break;
                case RACIAL_TYPE_HUMAN:    nFirstName = NAME_FIRST_HUMAN_FEMALE;    nLastName = NAME_LAST_HUMAN;    break;
            }   // End nRace switch

        break;  // nGender break

    }   // End nGender switch

    string sName = RandomName(nFirstName) + " " + RandomName(nLastName);

    if (sName == " ") return;
    SetName(oNPC, sName);

}


// >----< sp_SetRandomPhenotype >----<
// <sp_i_main>
// Sets a random phenotype for the NPC's. (Only Normal and Large are supported)
// nPercentFat - Chance to set a PHENOTYPE_BIG to the NPC. Defualt is 50%
void sp_SetRandomPhenotype(object oNPC = OBJECT_SELF, int nPercentFat = 50)
{
    // PHENOTYPE_NORMAL = 1;
    // PHENOTYPE_BIG    = 2;
    int nPhenotype;

    if (d100() > nPercentFat)
        nPhenotype = 1;
    else
        nPhenotype = 2;

    SetPhenoType(nPhenotype, oNPC);
}



// >----< sp_SetRandomColor >----<
// <sp_i_main>
// Sets a random color for oNPC. Only colors that make sense are possible
// nColorChannel = COLOR_CHANNEL_*
void sp_SetRandomColor(int nColorChannel, object oNPC = OBJECT_SELF)
{
    int nColorValue;

    switch(nColorChannel)
    {
        case COLOR_CHANNEL_HAIR:
            nColorValue = d20();
            switch(nColorValue)
            {
                case 15: nColorValue = 166; break;
                case 16: nColorValue = 167; break;
                case 17: nColorValue = 124; break;
                case 18: nColorValue = 31;  break;
                case 19: nColorValue = 47;  break;
                case 20: nColorValue = 0;   break;
            }
            break;

        case COLOR_CHANNEL_SKIN:
            nColorValue = d6();
            switch(nColorValue)
            {
                case 5: nColorValue = 12; break;
                case 6: nColorValue = 0;  break;
            }
            break;

            case COLOR_CHANNEL_TATTOO_1: nColorValue = Random(176); break;
            case COLOR_CHANNEL_TATTOO_2: nColorValue = Random(176); break;
      }

      SetColor(oNPC, nColorChannel, nColorValue);
}


// >----< sp_SpawnCreature >----<
// <sp_i_main>
// Spawns a single creature, based on the spawnpoint
void sp_SpawnCreature(string sTemplate, object oSpawnPoint)
{
     int bUnique = TRUE;
     if (GetTag(oSpawnPoint) != SP_UNIQUE_SPAWNPOINT) bUnique = FALSE;

     object oArea = GetArea(oSpawnPoint);
     // Get a random location somewhere in the area.
     location lLoc;
     if (bUnique) lLoc = GetLocation(oSpawnPoint);
     else lLoc = ss_GetRandomLocation(oArea);

     // Create the creature
     object oSpawnedCreature = CreateObject(OBJECT_TYPE_CREATURE, sTemplate, lLoc);
     if (oSpawnedCreature == OBJECT_INVALID)
     {
        string sError = SP_ERROR_INVALID_CREATURE_SPAWN + "Area: " + GetTag(oArea);
        if (bUnique) sError += " (Unique Creature)";
        else sError += " {Area Spawn Creature)";
        ss_SendMessageToTeam(sError, COLOR_BUG);
     }



     if (bUnique) SetLocalInt(oSpawnedCreature, SP_CREATURE_IS_UNIQUE, TRUE);
     else SetLocalInt(oSpawnedCreature, SP_CREATURE_IS_AREASPAWN, TRUE);


     // Stats Randomization Subsystem
     sp_SetRandomAbilities(oSpawnedCreature);

     // NPC Random Appearances Subsystem
     if (SP_USE_NRA_SUBSYSTEM)
     {
     // Only run NPC random appearance functions if it makes sense:
     switch(GetAppearanceType(oSpawnedCreature))
     {
      case APPEARANCE_TYPE_ELF:
      case APPEARANCE_TYPE_DWARF:
      case APPEARANCE_TYPE_GNOME:
      case APPEARANCE_TYPE_HALF_ELF:
      case APPEARANCE_TYPE_HALF_ORC:
      case APPEARANCE_TYPE_HALFLING:
      case APPEARANCE_TYPE_HUMAN:
            // No random appearances for unique NPCs
            if (bUnique) break;
            sp_SetRandomHeadModel(oSpawnedCreature);
            sp_SetRandomName(oSpawnedCreature);
            sp_SetRandomPhenotype(oSpawnedCreature);
            sp_SetRandomColor(COLOR_CHANNEL_HAIR, oSpawnedCreature);
            sp_SetRandomColor(COLOR_CHANNEL_SKIN, oSpawnedCreature);
            break;

      default: break;
     }
     }


     // Random Equipment Subsystem
     if (SP_USE_RANDOM_EQUIPMENT_SUBSYSTEM)
     {
     int i=1;
     string sChestTag = GetLocalString(oSpawnPoint, SP_EQUIPMENT_CHEST_TAG + IntToString(i));
     int nChestProbability = GetLocalInt(oSpawnPoint, SP_EQUIPMENT_CHEST_PROBABILITY + IntToString(i));

     while (sChestTag != "")
     {
        sp_SetEquipment(oSpawnedCreature, sChestTag, nChestProbability);
        i++;
        sChestTag = GetLocalString(oSpawnPoint, SP_EQUIPMENT_CHEST_TAG + IntToString(i));
        nChestProbability = GetLocalInt(oSpawnPoint, SP_EQUIPMENT_CHEST_PROBABILITY + IntToString(i));
     }
     }


}


// >----< sp_DoAreaSpawns >----<
// <sp_i_main>
// Spawns creatures in an area
void sp_DoAreaSpawns(object oArea = OBJECT_SELF)
{

     // Time spawns..
     int nHour = GetTimeHour();
     // Area spawns
     int nNth = 0;
     object oAreaSpawnPoint = sp_GetAreaSpawnPoint(oArea, nNth);

     while (oAreaSpawnPoint != OBJECT_INVALID)
     {

      if ((GetLocalInt(oAreaSpawnPoint, SP_SPAWN_ACTIVE_START_HOUR) <= nHour) && (GetLocalInt(oAreaSpawnPoint, SP_SPAWN_ACTIVE_STOP_HOUR) >= nHour))
      {
      int i=1;

      string sTemplate = GetLocalString(oAreaSpawnPoint, SP_CREATURE_RESREF + IntToString(i));
      int nProbability = GetLocalInt(oAreaSpawnPoint, SP_CREATURE_PROBABILITY + IntToString(i));

      while (sTemplate != "")
      {
        while (ss_Random(100)+1 <= nProbability)
        {   sp_SpawnCreature(sTemplate, oAreaSpawnPoint);
            nProbability -= 100;
        }
        i++;
        sTemplate = GetLocalString(oAreaSpawnPoint, SP_CREATURE_RESREF + IntToString(i));
        nProbability = GetLocalInt(oAreaSpawnPoint, SP_CREATURE_PROBABILITY + IntToString(i));
      }
      }
      nNth++;
      oAreaSpawnPoint = sp_GetAreaSpawnPoint(oArea, nNth);
     }


     // Unique spawns
     nNth = 0;
     object oUniqueSpawnPoint = sp_GetUniqueSpawnPoint(oArea, nNth);
     while (oUniqueSpawnPoint != OBJECT_INVALID)
     {
      if ((GetLocalInt(oAreaSpawnPoint, SP_SPAWN_ACTIVE_START_HOUR) <= nHour) && (GetLocalInt(oAreaSpawnPoint, SP_SPAWN_ACTIVE_STOP_HOUR) >= nHour))
      {
        string sTemplate = GetLocalString(oUniqueSpawnPoint, SP_CREATURE_RESREF);
        int nProbability = GetLocalInt(oUniqueSpawnPoint, SP_CREATURE_PROBABILITY);

        if (ss_Random(100)+1 <= nProbability)
            sp_SpawnCreature(sTemplate, oUniqueSpawnPoint);
      }
        nNth++;
        oUniqueSpawnPoint = sp_GetUniqueSpawnPoint(oArea, nNth);
     }

     SetLocalInt(oArea, SP_AREA_SPAWNS_ACTIVE, TRUE);
     SetLocalInt(oArea, SP_AREA_SPAWNING_IN_PROGRESS, TRUE);
     DelayCommand(6.0f, SetLocalInt(oArea, SP_AREA_SPAWNING_IN_PROGRESS, FALSE));
}


// >----< sp_DoAreaDeSpawns >----<
// <sp_i_main>
// DeSpawns creatures in an area
void sp_DoAreaDeSpawns(object oArea = OBJECT_SELF)
{

     object oSpawnedCreature = GetFirstInPersistentObject(oArea);
     float fDelay = 0.1f;
     while (oSpawnedCreature != OBJECT_INVALID)
     {
       if(!GetLocalInt(oSpawnedCreature, SP_CREATURE_NO_DESPAWN))
          DestroyObject(oSpawnedCreature, fDelay);
       oSpawnedCreature = GetNextInPersistentObject(oArea);
       fDelay += 0.1f;
     }

     SetLocalInt(oArea, SP_AREA_SPAWNS_ACTIVE, FALSE);

}

// void main() { }
