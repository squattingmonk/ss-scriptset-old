/*
Filename:           ai_classes
System:             Memetic AI (library script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 23, 2009
Summary:
Memetic AI library script. This library contains the classes for constructing
NPCs. Each class consists of an _ini function where variables are declared and a
_go function executed when each instance is created. Do NOT create objects in
_ini. This is called when the class is first used. The _go function's job is to
create events, memes, and generators to be added to the NPC.

At the end of this library you will find a main() function. This contains the
code that registers and runs the classes in this library. Read the instructions
to add your own classes to this library or to a new library.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_main"

// ---- Begin Generic Class ----------------------------------------------------

// This is called once. Its job is to declare every variable that is shared by
// all instances of this class. Then class variables can be set on the class
// object via the global variable, MEME_SELF.
// As a result, if X is declared here, when an NPC tries to read X from
// its NPC_SELF, it will transparently get the X from this class object.
void ai_c_generic_ini()
{
    ai_DebugStart("Initialize class='"+MEME_CALLED+"'", AI_DEBUG_TOOLKIT);

    // All NPCs have some basic ambient actions
    ai_DeclareResponseTable("Generic Idle Table", MEME_SELF);
    ai_AddResponse(MEME_SELF, "Generic Idle Table", "DoRandomWalk",  40, AI_RESPONSE_HIGH);
    ai_AddResponse(MEME_SELF, "Generic Idle Table", "DoSit",         40, AI_RESPONSE_MEDIUM);
    ai_AddResponse(MEME_SELF, "Generic Idle Table", "DoNothing",    100, AI_RESPONSE_LOW);
    ai_AddResponse(MEME_SELF, "Generic Idle Table", "DoNothing",    100, AI_RESPONSE_END);

    ai_SetActiveResponseTable("Idle", "Generic Idle Table");

    ai_DebugEnd();
}

// This is called every time a new instance of this class is made. Its job is
// to create the memetic objects on the creature.
void ai_c_generic_go()
{
    ai_DebugStart("Instanciate class='"+MEME_CALLED+"'", AI_DEBUG_COREAI);

    SetAILevel(OBJECT_SELF, AI_LEVEL_LOW);

/*    object oGenerator = ai_CreateGenerator("ai_g_door");
    ai_StartGenerator(oGenerator);

    oGenerator = ai_CreateGenerator("ai_g_cleanup");
    ai_StartGenerator(oGenerator);

    oGenerator = ai_CreateGenerator("ai_g_converse");
    ai_StartGenerator(oGenerator);

    ai_CreateMeme("ai_m_wander", AI_PRIORITY_LOW, -100, AI_MEME_REPEAT | AI_MEME_RESUME);
    ai_UpdateActions();

*/

    ai_CreateMeme("ai_m_idle", AI_PRIORITY_LOW, -100, AI_MEME_REPEAT | AI_MEME_RESUME);
    ai_UpdateActions();

    ai_DebugEnd();
}


// ---- Greeter Class ----------------------------------------------------------
void ai_c_greeter_ini()
{
    ai_DebugStart("Initialize class='"+MEME_CALLED+"'", AI_DEBUG_COREAI);

    ai_DebugEnd();
}

void ai_c_greeter_go()
{
    ai_DebugStart("Instanciate class='"+MEME_CALLED+"'", AI_DEBUG_COREAI);

    object oGenerator = ai_CreateGenerator("ai_g_goto", AI_PRIORITY_MEDIUM, 20);
    SetLocalString(oGenerator, "SpeakTable", "GreetingText");
    ai_DeclareStringRef("GreetingText", oGenerator);
    ai_AddStringRef(oGenerator, "Hello!", "GreetingText");
    ai_AddStringRef(oGenerator, "Good Day!", "GreetingText");
    ai_StartGenerator(oGenerator);
    ai_UpdateActions();

    ai_DebugEnd();
}


// ---- Walker Class -----------------------------------------------------------

void ai_c_walker_go()
{
    object oWP = ai_CreateMeme("ai_m_walkwp", AI_PRIORITY_LOW, 0, AI_MEME_RESUME | AI_MEME_REPEAT);
}


// ---- Combat Classes ---------------------------------------------------------

/*
   The default combat library comes equipped with a number of standard
   types of responses which may be useful during combat. A combat class
   defines a table that has one of these entries and a percentage chance
   that the response will occur. It is highly recommended that the last
   response in the table will have a 100% chance of occurring.

   You can create new responses by writing a function and declaring it in
   a library. Then add the name of the function to the table. Done.

   DoFastBuffs                 DoSpellHeal                 DoSpellDirect
   DoTouch                     DoAttackRanged              DoAttackMelee
   DoEvacAOE                   DoRegroup                   DoDefendSelf
   DoDefendSingle              DoEnhanceSingle             DoSpellHelp
   DoSpellRaise                DoSpellBreach               DoSpellArea
   DoSpellSummon               DoFeatEnhance               DoAvoidMelee
   DoTimeStop                  DoVision                    DoBreathWeapon
   DoTurning                   DoHealSelf                  DoSpellGroupEnhance
   DoDispelPersAOE             DoDispelSingle              DoDismissal
   DoSpellGroupHeal            DoEnhanceSelf
*/

//---- Animal Combat Behavior --------------------------------------------------
//
// Vermin are simple mindless attacking creatures. They are easy to scare and
// quick to bite.

// 1. Everything we do here will be done once for the class. Anything stored on
//    MEME_SELF will be shared by every NPC because MEME_SELF is the class object.
void ai_c_combat_vermin_ini()
{
    // This says that the NPC will inherit this variable -- it is the table
    // that defines the combat behaviors.
    ai_DeclareResponseTable("combat", MEME_SELF);

    // This is the combat behavior table.
    ai_AddResponse(MEME_SELF, "combat", "DoAvoidMelee",        40);
    ai_AddResponse(MEME_SELF, "combat", "DoRegroup",           30);
    ai_AddResponse(MEME_SELF, "combat", "DoDefendSingle",      30);
    ai_AddResponse(MEME_SELF, "combat", "DoAttackMelee",      100);

}

// 2. Now everything that happens here is run once for every NPC.
void ai_c_combat_vermin_go()
{
    object oCombat = ai_CreateGenerator("ai_g_combatai", AI_PRIORITY_HIGH);
    ai_StartGenerator(oCombat);
}

//---- Animal Combat Behavior --------------------------------------------------
//
// This is an example of an adaptive combat table. It uses a function to switch
// the combat meme's table.
//
// During combat, animals have two distinct combat behaviors: evasive and
// defensive. At the outset, they are cautious, avoid melee, and will constantly
// attempt to regroup. But if their numbers are sufficient, or if they are
// damaged, they become defensive. When they are defensive they will lash out
// and attack.


// 1. Everything we do here will be done once for the class. Anything stored on
//    MEME_SELF will be shared by every NPC because MEME_SELF is the class object.
void ai_c_combat_animal_ini()
{
    // This says that the NPC will inherit this variable -- it is the table
    // that defines the combat behaviors.
    ai_DeclareResponseTable("combat", MEME_SELF);

    // This is the first, default, combat behavior.
    ai_AddResponse(MEME_SELF, "combat", "BecomeDefensive",     60); // This function checks to see if it should get aggressive
    ai_AddResponse(MEME_SELF, "combat", "DoRegroup",           30);
    ai_AddResponse(MEME_SELF, "combat", "DoDefendSingle",      30); // It will go to the aid of another
    ai_AddResponse(MEME_SELF, "combat", "DoAttackMelee",       30);
    ai_AddResponse(MEME_SELF, "combat", "DoAvoidMelee",       100);

    // This is the second combat behavior. Look at the function BecomeDefensive
    // in ai_functions to see how this table becomes active. When combat is
    // over, the creature will revert to the "combat" table.
    ai_DeclareResponseTable("defensive", MEME_SELF);
    ai_AddResponse(MEME_SELF, "defensive", "DoRegroup",           30);
    ai_AddResponse(MEME_SELF, "defensive", "DoAttackMelee",      100);
}

// 2. Now everything that happens here is run once for every NPC.
void ai_c_combat_animal_go()
{
    object oCombat = ai_CreateGenerator("ai_g_combatai", AI_PRIORITY_HIGH);
    ai_StartGenerator(oCombat);

}

//---- Cleric Combat Behavior --------------------------------------------------

// 1. Everything we do here will be done once for the class. Anything stored on
//    MEME_SELF will be shared by every NPC because MEME_SELF is the class object.
void ai_c_combat_cleric_ini()
{
    // This says that the NPC will inherit this variable -- it is the table
    // that defines the combat behaviors.
    ai_DeclareResponseTable("combat", MEME_SELF);

    // Set up the combat response table; the order determines which
    // actions are tried first. The number is the percentage chance it may
    // succeed. Not every action will succeed. These strings correspond to
    // the name of a function declared in a library.
    ai_AddResponse(MEME_SELF, "combat", "DoHealSelf",         100);
    ai_AddResponse(MEME_SELF, "combat", "DoRegroup",           50);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellSummon",       60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellRaise",        60);
    ai_AddResponse(MEME_SELF, "combat", "DoGroupHeal",         60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellHeal",         60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellHelp",         60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellVisual",       60);
    ai_AddResponse(MEME_SELF, "combat", "DoDefendSingle",      60);
    ai_AddResponse(MEME_SELF, "combat", "DoDefendSelf",        60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellGroupEnhance", 60);
    ai_AddResponse(MEME_SELF, "combat", "DoEnhanceSingle",     60);
    ai_AddResponse(MEME_SELF, "combat", "DoEnhanceSelf",       60);
    ai_AddResponse(MEME_SELF, "combat", "DoFeatEnhance",       60);
    ai_AddResponse(MEME_SELF, "combat", "DoDispelSingle",      60);
    ai_AddResponse(MEME_SELF, "combat", "DoDispelPersAOE",     40);
    ai_AddResponse(MEME_SELF, "combat", "DoDismissal",         40);
    ai_AddResponse(MEME_SELF, "combat", "DoTurning",           60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellBreach",       50);
    ai_AddResponse(MEME_SELF, "combat", "DoTimeStop",          40);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellArea",         60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellDirect",       60);
    ai_AddResponse(MEME_SELF, "combat", "DoTouch",             60);
    ai_AddResponse(MEME_SELF, "combat", "DoEvacAOE",           50);
    ai_AddResponse(MEME_SELF, "combat", "DoAttackRanged",     100);
    ai_AddResponse(MEME_SELF, "combat", "DoAvoidMelee",        60);
    ai_AddResponse(MEME_SELF, "combat", "DoAttackMelee",      100);
}

// 2. Now everything that happens here is run once for every NPC.
void ai_c_combat_cleric_go()
{
    object oCombat = ai_CreateGenerator("ai_g_combatai", AI_PRIORITY_HIGH);

    SetLocalInt(NPC_SELF, "#FASTBUFFER", 1 );

    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "BC_DEAD", AI_SIGNAL_DEAD);
    SetListenPattern(OBJECT_SELF, "BC_FIGHTING", AI_SIGNAL_COMBAT);

    ai_StartGenerator(oCombat);
}

//---- Fighter Combat Behavior -------------------------------------------------

// 1. Everything we do here will be done once for the class. Anything stored on
//    MEME_SELF will be shared by every NPC because MEME_SELF is the class object.
void ai_c_combat_fighter_ini()
{
    // This says that the NPC will inherit this variable -- it is the table
    // that defines the combat behaviors.
    ai_DeclareResponseTable("combat", MEME_SELF);

    // Set up the combat response table; the order determines which
    // actions are tried first. The number is the percentage chance it may
    // succeed. Not every action will succeed. These strings correspond to
    // the name of a function declared in a library.
    ai_AddResponse(MEME_SELF, "combat", "DoHealSelf",    100);
    ai_AddResponse(MEME_SELF, "combat", "DoRegroup",      40);
    ai_AddResponse(MEME_SELF, "combat", "DoFeatEnhance",  60);
    ai_AddResponse(MEME_SELF, "combat", "DoEvacAOE",      60);
    ai_AddResponse(MEME_SELF, "combat", "DoAttackRanged", 60);
    ai_AddResponse(MEME_SELF, "combat", "DoAttackMelee", 100);
}

// 2. Now everything that happens here is run once for every NPC.
void ai_c_combat_fighter_go()
{
    object oCombat = ai_CreateGenerator("ai_g_combatai", AI_PRIORITY_HIGH);

    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "BC_DEAD", AI_SIGNAL_DEAD);
    SetListenPattern(OBJECT_SELF, "BC_FIGHTING", AI_SIGNAL_COMBAT);

    ai_StartGenerator(oCombat);
}


//---- Mage Combat Behavior ----------------------------------------------------

// 1. Everything we do here will be done once for the class. Anything stored on
//    MEME_SELF will be shared by every NPC because MEME_SELF is the class object.
void ai_c_combat_mage_ini()
{
    // This says that the NPC will inherit this variable -- it is the table
    // that defines the combat behaviors.
    ai_DeclareResponseTable("combat", MEME_SELF);

    // Set up the combat response table; the order determines which
    // actions are tried first. The number is the percentage chance it may
    // succeed. Not every action will succeed. These strings correspond to
    // the name of a function declared in a library.
    ai_AddResponse(MEME_SELF, "combat", "DoHealSelf",         100);
    ai_AddResponse(MEME_SELF, "combat", "DoAvoidMelee",        60);
    ai_AddResponse(MEME_SELF, "combat", "DoRegroup",           40);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellRaise",        60);
    ai_AddResponse(MEME_SELF, "combat", "DoGroupHeal",         60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellHeal",         60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellHelp",         60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellVisual",       60);
    ai_AddResponse(MEME_SELF, "combat", "DoDefendSingle",      60);
    ai_AddResponse(MEME_SELF, "combat", "DoDefendSelf",        60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellGroupEnhance", 60);
    ai_AddResponse(MEME_SELF, "combat", "DoEnhanceSingle",     60);
    ai_AddResponse(MEME_SELF, "combat", "DoEnhanceSelf",       60);
    ai_AddResponse(MEME_SELF, "combat", "DoFeatEnhance",       60);
    ai_AddResponse(MEME_SELF, "combat", "DoDispelSingle",      40);
    ai_AddResponse(MEME_SELF, "combat", "DoDispelPersAOE",     40);
    ai_AddResponse(MEME_SELF, "combat", "DoDismissal",         40);
    ai_AddResponse(MEME_SELF, "combat", "DoTurning",           60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellBreach",       50);
    ai_AddResponse(MEME_SELF, "combat", "DoTimeStop",          40);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellArea",         60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellDirect",       60);
    ai_AddResponse(MEME_SELF, "combat", "DoTouch",             60);
    ai_AddResponse(MEME_SELF, "combat", "DoSpellSummon",       75);
    ai_AddResponse(MEME_SELF, "combat", "DoEvacAOE",           40);
    ai_AddResponse(MEME_SELF, "combat", "DoAttackRanged",     100);
    ai_AddResponse(MEME_SELF, "combat", "DoAttackMelee",      100);
}

// 2. Now everything that happens here is run once for every NPC.
void ai_c_combat_mage_go()
{
    object oCombat = ai_CreateGenerator("ai_g_combatai", AI_PRIORITY_HIGH);

    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "BC_DEAD", AI_SIGNAL_DEAD);
    SetListenPattern(OBJECT_SELF, "BC_FIGHTING", AI_SIGNAL_COMBAT);

    SetLocalInt(NPC_SELF, "#FASTBUFFER", 1 );

    ai_StartGenerator(oCombat);
}


//---- Mage Combat Behavior ----------------------------------------------------

// 1. Everything we do here will be done once for the class. Anything stored on
//    MEME_SELF will be shared by every NPC because MEME_SELF is the class object.
void ai_c_combat_archer_ini()
{
    // This says that the NPC will inherit this variable -- it is the table
    // that defines the combat behaviors.
    ai_DeclareResponseTable("combat", MEME_SELF);

    // Set up the combat response table; the order determines which
    // actions are tried first. The number is the percentage chance it may
    // succeed. Not every action will succeed. These strings correspond to
    // the name of a function declared in a library.
    ai_AddResponse(MEME_SELF, "combat", "DoHealSelf",       100);
    ai_AddResponse(MEME_SELF, "combat", "DoRegroup",         30);
    ai_AddResponse(MEME_SELF, "combat", "DoFeatEnhance",     60);
    ai_AddResponse(MEME_SELF, "combat", "DoEvacAOE",         60);
    ai_AddResponse(MEME_SELF, "combat", "DoAvoidMelee",      25);
    ai_AddResponse(MEME_SELF, "combat", "DoAttackRanged",   100);
    ai_AddResponse(MEME_SELF, "combat", "DoAttackMelee",    100);
}

// 2. Now everything that happens here is run once for every NPC.
void ai_c_combat_archer_go()
{
    object oCombat = ai_CreateGenerator("ai_g_combatai", AI_PRIORITY_HIGH);

    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "BC_DEAD", AI_SIGNAL_DEAD);
    SetListenPattern(OBJECT_SELF, "BC_FIGHTING", AI_SIGNAL_COMBAT);

    ai_StartGenerator(oCombat);
}


/*------------------------------------------------------------------------------
 *   Script: Library Initialization and Scheduling
 *
 *   This main() defines this script as a library. The following two steps
 *   handle registration and execution of the scripts inside this library. It
 *   is assumed that a call to ai_LoadLibrary() has occured in the ModuleLoad
 *   callback. This lets the ai_ExecuteScript() function know how to find the
 *   functions in this library. You can create your own library by copying this
 *   file and editing the ai_hooks to register the name of your new library.
 ------------------------------------------------------------------------------*/

void main()
{
    ai_DebugStart("Library name='" + MEME_LIBRARY + "'");

    //  Step 1: Library Setup
    //
    //  This is run once to bind your scripts to a unique number.
    //  The number is composed of a top half - for the "class" and lower half
    //  for the specific "method". If you are adding your own scripts, copy
    //  the example, make sure to change the first number. Then edit the
    //  switch statement following this if statement.

    if (MEME_DECLARE_LIBRARY)
    {
        // Register the class
        ai_RegisterClass("generic");
        // Note: All classes must have the prefix "ai_c_". This is automatically
        //       added so that users can refer to a "dockworker" not
        //       "ai_c_dockworker". ai_InstanceOf() and ai_RegisterClass()
        //       append "ai_c_" to the class name.
        ai_LibraryImplements("ai_c_generic",        AI_METHOD_INIT, 0x0100+0xff);
        ai_LibraryImplements("ai_c_generic",        AI_METHOD_GO,   0x0100+0x01);

        ai_RegisterClass("greeter");
        ai_LibraryImplements("ai_c_greeter",        AI_METHOD_INIT, 0x0200+0xff);
        ai_LibraryImplements("ai_c_greeter",        AI_METHOD_GO,   0x0200+0x01);

        ai_RegisterClass("combat_archer");
        ai_LibraryImplements("ai_c_combat_archer",  AI_METHOD_INIT, 0x0300+0xff);
        ai_LibraryImplements("ai_c_combat_archer",  AI_METHOD_GO,   0x0300+0x01);

        ai_RegisterClass("combat_mage");
        ai_LibraryImplements("ai_c_combat_mage",    AI_METHOD_INIT, 0x0400+0xff);
        ai_LibraryImplements("ai_c_combat_mage",    AI_METHOD_GO,   0x0400+0x01);

        ai_RegisterClass("combat_fighter");
        ai_LibraryImplements("ai_c_combat_fighter", AI_METHOD_INIT, 0x0500+0xff);
        ai_LibraryImplements("ai_c_combat_fighter", AI_METHOD_GO,   0x0500+0x01);

        ai_RegisterClass("combat_cleric");
        ai_LibraryImplements("ai_c_combat_cleric",  AI_METHOD_INIT, 0x0600+0xff);
        ai_LibraryImplements("ai_c_combat_cleric",  AI_METHOD_GO,   0x0600+0x01);

        ai_RegisterClass("walker");
        ai_LibraryImplements("ai_c_walker",         AI_METHOD_GO,   0x0700);

        ai_RegisterClass("combat_vermin");
        ai_LibraryImplements("ai_c_combat_vermin",  AI_METHOD_INIT, 0x0800+0xff);
        ai_LibraryImplements("ai_c_combat_vermin",  AI_METHOD_GO,   0x0800+0x01);

        ai_RegisterClass("combat_animal");
        ai_LibraryImplements("ai_c_combat_animal",  AI_METHOD_INIT, 0x0900+0xff);
        ai_LibraryImplements("ai_c_combat_animal",  AI_METHOD_GO,   0x0900+0x01);

        ai_DebugEnd();
        return;
    }

    //  Step 2: Library Dispatcher
    //
    //  These switch statements are what decide to run your scripts, based
    //  on the numbers you provided in Step 1. Notice that you only need
    //  an inner switch statement if you exported more than one method
    //  (like go and end). Also notice that the value used by the case statement
    //  is the two numbers added up.

    switch (MEME_ENTRYPOINT & 0xff00)
    {
        // A: Call the class members
        case 0x0100: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0xff: ai_c_generic_ini();   break;
                         case 0x01: ai_c_generic_go();    break;
                     }   break;

        case 0x0200: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0xff: ai_c_greeter_ini();   break;
                         case 0x01: ai_c_greeter_go();    break;
                     }   break;

        case 0x0300: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0xff: ai_c_combat_archer_ini(); break;
                         case 0x01: ai_c_combat_archer_go();  break;
                     }   break;

        case 0x0400: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0xff: ai_c_combat_mage_ini(); break;
                         case 0x01: ai_c_combat_mage_go();  break;
                     }   break;

        case 0x0500: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0xff: ai_c_combat_fighter_ini(); break;
                         case 0x01: ai_c_combat_fighter_go();  break;
                     }   break;

        case 0x0600: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0xff: ai_c_combat_cleric_ini(); break;
                         case 0x01: ai_c_combat_cleric_go();  break;
                     }   break;

        case 0x0700: ai_c_walker_go(); break;

        case 0x0800: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0xff: ai_c_combat_vermin_ini(); break;
                         case 0x01: ai_c_combat_vermin_go();  break;
                     }   break;

        case 0x0900: switch (MEME_ENTRYPOINT & 0x00ff)
                     {
                         case 0xff: ai_c_combat_animal_ini(); break;
                         case 0x01: ai_c_combat_animal_go();  break;
                     }   break;
    }

    ai_DebugEnd();
}
