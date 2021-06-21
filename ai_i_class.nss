/*
Filename:           ai_i_class
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 18, 2009
Summary:
Memetic AI include script. This file holds class functions commonly used
throughout the Memetic AI system. These provide the ability to define a class
and an instance. When an object is declared an instance of a class, the class
constructor is run.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_util"


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ---< ai_DeclareResponseTable >---
// ---< ai_i_class >---
// Explicitly defines response table variables so that they may be inherited
// automatically, destroyed, or eventually saved to a database.
// This is generally used inside of a class constructor (_ini).
// Once a variable is declared on a class, all instances will share it. If this
// is used on an object that is an instance of a class, then this function will
// use its local, overriding value, shadowing the inherited value.
void ai_DeclareResponseTable(string sTable, object oTarget = OBJECT_INVALID);

// ---< ai_DeclareInt >---
// ---< ai_i_class >---
// Explicitly defines a variable so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
// These functions are generally used inside of a class constructor (_ini).
// Once a variable is declared on a class, all instances will share it.
// If this is used on an object that is an instance of a class, then this
// function will use its local, overriding value, shadowing the inherited value.
// Undeclaring is not supported at this time.
// Paramters:
// - sName: the name of the variable.
// - oTarget: the object which owns the variable. If the object is invalid, the
//   function will try to use the global MEME_SELF. This global is defined
//   inside of the class constructor _ini. It is generally assumed that the
//   object is either a class or an instance that wants to override an inherited
//   value.
// - nFlags: these control how the variable is used. At this time, these flags
//   are exclusive, or'ing ( A | B ) will not make sense.
//   - AI_VAR_INHERIT: this variable should be inherited by its children.
//   - AI_VAR_INHERIT_COPY: this variable should be copied to the instances, but
//     not shared. The variable will be automatically declared on the instance.
void ai_DeclareInt(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT);

// ---< ai_DeclareIntRef >---
// ---< ai_i_class >---
// Explicitly defines a variable so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
//
// For the full documentation, refer to ai_DeclareInt.
void ai_DeclareIntRef(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT);

// ---< ai_DeclareFloat >---
// ---< ai_i_class >---
// Explicitly defines a variable so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
//
// For the full documentation, refer to ai_DeclareInt.
void ai_DeclareFloat(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT);

// ---< ai_DeclareFloatRef >---
// ---< ai_i_class >---
// Explicitly defines a variable so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
//
// For the full documentation, refer to ai_DeclareInt.
void ai_DeclareFloatRef(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT);

// ---< ai_DeclareString >---
// ---< ai_i_class >---
// Explicitly defines a variable so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
//
// For the full documentation, refer to ai_DeclareInt.
void ai_DeclareString(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT);

// ---< ai_DeclareStringRef >---
// ---< ai_i_class >---
// Explicitly defines a variable so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
//
// For the full documentation, refer to ai_DeclareInt.
void ai_DeclareStringRef(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT);

// ---< ai_DeclareObject >---
// ---< ai_i_class >---
// Explicitly defines a variable so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
//
// For the full documentation, refer to ai_DeclareInt.
void ai_DeclareObject(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT);

// ---< ai_DeclareObjectRef >---
// ---< ai_i_class >---
// Explicitly defines a variable so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
//
// For the full documentation, refer to ai_DeclareInt.
void ai_DeclareObjectRef(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT);

// ---< ai_DeclareLocation >---
// ---< ai_i_class >---
// Explicitly defines a variable so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
//
// For the full documentation, refer to ai_DeclareInt.
void ai_DeclareLocation(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT);

// ---< ai_DeclareLocalMessage >---
// ---< ai_i_class >---
// Explicitly defines a message so that it may be inherited, automatically
// destroyed, or eventually saved to a database.
// This function is generally used inside of a class constructor (_ini)
// Once a variable is declared on a class, all instances will share it.
// If this is used on an object that is an instance of a class, this function
// will cause the object to use its local, overriding value, shadowing the
// inherited value.
void ai_DeclareLocalMessage(string sMessageName, object oTarget = OBJECT_INVALID);

// ---< ai_GetConfigString >---
// ---< ai_i_class >---
// Get Configuration String
// Get a string from an object and as a convience - get the value from the
// module if the string starts with an @ symbol. This allows NPC's to share
// strings and lists of strings by storing the actual value on the module
// and storing the name of module-variable on the NPC.
//
// If the index is passed, a space and a number is appended to the string.
//
// For example, you may have tables of names of areas, or spoken-strings that
// you want many NPC's to use. Instead of copying them onto every NPC you can
// add them, using the GUI toolset, to the module, once.
//
// If this function detects the @ symbol on the first item of a list, it will
// assume the rest of value is the name of the string shared on the module.
//
// NPC variables may be named things like: "Enemy Greeting 1"
// Additionally, users may set these variables on the module, and tell these
// functions to go look there for the values. For example:
//
// On the module: "MyVariable 1" = "Hello"
//                "MyVariable 2" = "Hi There!"
//                "MyVariable 3" = "Wow!"
//
// On the NPC:    "Friendly Greeting 1" = "@MyVariable"
//                "Friendly Greeting 2" = "ignored"
//                "Friendly Greeting 3" = "ignored"
//                 ...
//
// ai_GetConfigString("MT: Friendly Greeting", 2) returns "Hi There!".
// Notice that the final space and number are not part of the name.
string ai_GetConfigString(object oTarget, string sName, int nIndex = 0);

// ---< ai_InheritFrom >---
// ---< ai_i_class >---
// Causes the target object to inherit the variables declared by a parent. If
// the parent inherits, or is an instace of a class, the target does NOT inherit
// these variables -- only the ones explicitly declared on the parent with the
// ai_Declare*().
// Parameters:
// - oTarget: the object that wants to relegate control of some of it undeclared
//   variables (i.e., the child).
// - oParent: the object that has declared variables to be inherited (i.e., the
//   parent).
void ai_InheritFrom(object oTarget, object oParent);

// ---< ai_InstanceOf >---
// ---< ai_i_class >---
// This causes the target object to inherit the variables of the class that was
// created with a call to ai_RegisterClass(). A class instanciation script
// ai_c_<classname>+_go will be executed. In this script, the global MEME_SELF
// will be oTarget.
//
// This is used to allow a general class of objects to be constructed. The
// class's _go script is used to setup the instance's declared variables,
// default local values. If the target is a creature (or NPC_SELF) the class
// would use the _go script as an opportunity to add generators and event
// handlers on the NPC.
//
// The toolkit supports multiple inheritance. But to conserve memory, it is
// highly recommended that you call this function on an object, once, with
// a single comma-delimited list of class names. The system will merge the
// inheritance declaration tables into one efficient table for the combination
// of classes. For example, I you call f(a), f(b), f(c), f(d) you will have
// created the tables: a, b, c, d, ab, abc, abcd. The tables ab and abc would
// be unnecessary.
// Paramters:
// - oTarget: the object that wants to be an instance of the given class(es).
// - sClass: the name or comma-delimited list of names of classes.
//   - Example: "vermin, sorcerer,child_of_dark"
// - nBias: this is an amount that is added to the modifier parameter of any
//   calls to ai_CreateMeme by any objects created by this class. If you list a
//   number of classes, this bias increases for each class entry you list, one
//   point at a time. For example, if you call ai_InstanceOf(oSelf, "baker", 5);
//   then all memes created by the baker class or memes created by objects that
//   the baker class made, will have +5 added to their modifiers. If you call
//   ai_InstanceOf(oSelf, "generic, fighter"); then generic's memes get +0 and
//   fighter's memes get +1. Memes can be created with AI_MEME_NO_BIAS to avoid
//   this modifier.
void ai_InstanceOf(object oTarget, string sClass, int nBias = 0);

// ---< ai_GetClassByIndex >---
// ---< ai_i_class >---
// An object that is an instance of a class has a number of objects that it is
// associated to. This function gets the class object.
//
// This is not a function most people need to know about or use.
//
// - nIndex: Since an object can belong to more than one class, this is an index
// representing which class name you want. This is a 0-based index.
// - oObject: the NPC this is an instance of a class.
object ai_GetClassByIndex(int nIndex = 0, object oObject = OBJECT_SELF);

// ---< ai_GetClassCount >---
// ---< ai_i_class >---
// Returns the number of classes this NPC belongs to.
int ai_GetClassCount(object oObject = OBJECT_SELF);

// ---< ai_GetClassObject >---
// ---< ai_i_class >---
// Class objects are related to a set of objects that are an "instance" of a
// class -- see ai_InstanceOf() for more detail on this process.
// These "class objects" hold variables that are shared amongst the instances
// of the class when they are created. It is possible to adjust values on a
// class object and automatically impact all memebers of the class.
//
// Note: This is not a function most people need to know about or use.
// Additionally, the class object is not created until the first instance of the
// class is made.
//
// sClassName: This is the name of the class that you are looking for, like
// "generic" or "fighter" or "bartender".
object ai_GetClassObject(string sClassName);

// ---- INHERITED VARIABLE ACCESS FUNCTIONS-------------------------------------

// ---< ai_SetLocalInt >---
// ---< ai_i_class >---
// This sets an integer variable on an object. If the object inherits data from another
// object, or from a class, the value is stored locally, overriding the source of the inheritance.
void ai_SetLocalInt(object oObject, string sVarName, int nValue);

// ---< ai_SetLocalFloat >---
// ---< ai_i_class >---
// This sets a float variable on an object. If the object inherits data from another
// object, or from a class, the value is stored locally, overriding the source of the inheritance.
void ai_SetLocalFloat(object oObject, string sVarName, float fValue);

// ---< ai_SetLocalString >---
// ---< ai_i_class >---
// This sets a string variable on an object. If the object inherits data from another
// object, or from a class, the value is stored locally, overriding the source of the inheritance.
void ai_SetLocalString(object oObject, string sVarName, string sValue);

// ---< ai_SetLocalObject >---
// ---< ai_i_class >---
// This sets an object variable on an object. If the object inherits data from another
// object, or from a class, the value is stored locally, overriding the source of the inheritance.
void ai_SetLocalObject(object oObject, string sVarName, object oValue);

// ---< ai_SetLocalLocation >---
// ---< ai_i_class >---
// This sets a location variable on an object. If the object inherits data from another
// object, or from a class, the value is stored locally, overriding the source of the inheritance.
void ai_SetLocalLocation(object oObject, string sVarName, location lValue);

// ---< ai_SetLocalMessage >---
// ---< ai_i_class >---
// This sets a memetic message on an object. If the object inherits data from another
// object, or from a class, the value is stored locally, overriding the source of the inheritance.
void ai_SetLocalMessage(object oTarget, string sMessageName, struct message sMessage);

// ---< ai_GetLocalInt >---
// ---< ai_i_class >---
// This gets an integer variable from an object with a given name. If the object inherits
// data from another object or is an instance of a class, this function will get
// the value from source of the inheritance. Of course, if the value has been
// changed on this object, the overidden value is retrieved, instead.
int ai_GetLocalInt(object oObject, string sVarName);

// ---< ai_GetLocalFloat >---
// ---< ai_i_class >---
// This gets a float variable from an object with a given name. If the object inherits
// data from another object or is an instance of a class, this function will get
// the value from source of the inheritance. Of course, if the value has been
// changed on this object, the overidden value is retrieved, instead.
float ai_GetLocalFloat(object oObject, string sVarName);

// ---< ai_GetLocalString >---
// ---< ai_i_class >---
// This gets an string variable from an object with a given name. If the object inherits
// data from another object or is an instance of a class, this function will get
// the value from source of the inheritance. Of course, if the value has been
// changed on this object, the overidden value is retrieved, instead.
string ai_GetLocalString(object oObject, string sVarName);

// ---< ai_GetLocalObject >---
// ---< ai_i_class >---
// This gets an object variable from an object with a given name. If the object inherits
// data from another object or is an instance of a class, this function will get
// the value from source of the inheritance. Of course, if the value has been
// changed on this object, the overidden value is retrieved, instead.
object ai_GetLocalObject(object oObject, string sVarName);

// ---< ai_GetLocalLocation >---
// ---< ai_i_class >---
// This gets a location variable from an object with a given name. If the object inherits
// data from another object or is an instance of a class, this function will get
// the value from source of the inheritance. Of course, if the value has been
// changed on this object, the overidden value is retrieved, instead.
location ai_GetLocalLocation(object oObject, string sVarName);

// ---< ai_GetLocalMessage >---
// ---< ai_i_class >---
// This gets a memetic message from an object with a given name. If the object inherits
// data from another object or is an instance of a class, this function will get
// the value from source of the inheritance. Of course, if the value has been
// changed on this object, the overidden value is retrieved, instead.
struct message ai_GetLocalMessage(object oTarget, string sMessageName);

// ---< ai_DeleteLocalMessage >---
// ---< ai_i_class >---
// This deletes the memetic message datastructure from an object. It doesn't
// have anything to do with classes or inheritance. It just removes the
// variable like a call to DeleteLocalInt or DeleteLocalString.
void ai_DeleteLocalMessage(object oTarget, string sMessageName);

// ---- INHERITED VARIABLE ACCESS FUNCTIONS-------------------------------------

// ---< ai_MapInt >---
// ---< ai_i_class >---
// This causes  a variable on one object to be retrieved on another object with
// a different name. This is used so that meme/generator/event writers can
// talk about a local variable like "Flag" that may actually be on the NPC
// with a name like "MT: Do XYZ".
//
// This assumes that the object has ai_InheritsFrom() called. To get the value
// you must use ai_GetLocal*() not the Bioware GetLocal*().
void ai_MapInt(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID);

// ---< ai_MapIntRef >---
// ---< ai_i_class >---
// This causes  a variable on one object to be retrieved on another object with
// a different name. This is used so that meme/generator/event writers can
// talk about a local variable like "Flag" that may actually be on the NPC
// with a name like "MT: Do XYZ".
//
// This assumes that the object has ai_InheritsFrom() called. To get the value
// you must use ai_GetLocal*() not the Bioware GetLocal*().
void ai_MapIntRef(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID);

// ---< ai_MapFloat >---
// ---< ai_i_class >---
// This causes  a variable on one object to be retrieved on another object with
// a different name. This is used so that meme/generator/event writers can
// talk about a local variable like "Flag" that may actually be on the NPC
// with a name like "MT: Do XYZ".
//
// This assumes that the object has ai_InheritsFrom() called. To get the value
// you must use ai_GetLocal*() not the Bioware GetLocal*().
void ai_MapFloat(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID);

// ---< ai_MapFloatRef >---
// ---< ai_i_class >---
// This causes  a variable on one object to be retrieved on another object with
// a different name. This is used so that meme/generator/event writers can
// talk about a local variable like "Flag" that may actually be on the NPC
// with a name like "MT: Do XYZ".
//
// This assumes that the object has ai_InheritsFrom() called. To get the value
// you must use ai_GetLocal*() not the Bioware GetLocal*().
void ai_MapFloatRef(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID);

// ---< ai_MapString >---
// ---< ai_i_class >---
// This causes  a variable on one object to be retrieved on another object with
// a different name. This is used so that meme/generator/event writers can
// talk about a local variable like "Flag" that may actually be on the NPC
// with a name like "MT: Do XYZ".
//
// This assumes that the object has ai_InheritsFrom() called. To get the value
// you must use ai_GetLocal*() not the Bioware GetLocal*().
void ai_MapString(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID);

// ---< ai_MapStringRef >---
// ---< ai_i_class >---
// This causes  a variable on one object to be retrieved on another object with
// a different name. This is used so that meme/generator/event writers can
// talk about a local variable like "Flag" that may actually be on the NPC
// with a name like "MT: Do XYZ".
//
// This assumes that the object has ai_InheritsFrom() called. To get the value
// you must use ai_GetLocal*() not the Bioware GetLocal*().
void ai_MapStringRef(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID);

// ---< ai_MapObject >---
// ---< ai_i_class >---
// This causes  a variable on one object to be retrieved on another object with
// a different name. This is used so that meme/generator/event writers can
// talk about a local variable like "Flag" that may actually be on the NPC
// with a name like "MT: Do XYZ".
//
// This assumes that the object has ai_InheritsFrom() called. To get the value
// you must use ai_GetLocal*() not the Bioware GetLocal*().
void ai_MapObject(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID);

// ---< ai_MapObjectRef >---
// ---< ai_i_class >---
// This causes  a variable on one object to be retrieved on another object with
// a different name. This is used so that meme/generator/event writers can
// talk about a local variable like "Flag" that may actually be on the NPC
// with a name like "MT: Do XYZ".
//
// This assumes that the object has ai_InheritsFrom() called. To get the value
// you must use ai_GetLocal*() not the Bioware GetLocal*().
void ai_MapObjectRef(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID);

// ---< ai_MapLocation >---
// ---< ai_i_class >---
// This causes  a variable on one object to be retrieved on another object with
// a different name. This is used so that meme/generator/event writers can
// talk about a local variable like "Flag" that may actually be on the NPC
// with a name like "MT: Do XYZ".
//
// This assumes that the object has ai_InheritsFrom() called. To get the value
// you must use ai_GetLocal*() not the Bioware GetLocal*().
void ai_MapLocation(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID);


/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

// Variable declarations tables look like: DECL_<type>:<varname> where type is:
// I: Int,      IF: Int Flags,      IL: Int List,      ILF: Int List Flags
// O: Object,   OF: Object Flags,   OL: Object List,   OLF: Object List Flags
// S: String,   SF: String Flags,   SL: String List,   SLF: String List Flags
// F: Float,    FF: Float Flags,    FL: Float List,    FLF: Float List Flags
// L: Location, LF: Location Flags, LL: Location List, LLF: Location List Flags

void ai_DeclareInt(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    // This is the index to the declaration table. It's used to support multiple
    // inheritance. This table will be merged with other tables. Since BioWare
    // doesn't support intraspection, this also allows us to track the variables
    // we have on the object.
    if (GetIsFlagSet(nFlags, AI_VAR_INHERIT))
        ai_AddStringRef(oTarget, sName, "DECL_I*:");

    // This is the declaration table, used to find the owner
    SetLocalObject(oTarget, "DECL_I:"+sName, oTarget);
    SetLocalInt(oTarget, "DECL_IF:"+sName, nFlags);
}

void ai_DeclareIntRef(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    // This is the index to the declaration table. It's used to support multiple
    // inheritance. This table will be merged with other tables. Since BioWare
    // doesn't support intraspection, this also allows us to track the variables
    // we have on the object.
    if (GetIsFlagSet(nFlags, AI_VAR_INHERIT))
        ai_AddStringRef(oTarget, sName, "DECL_IL*:");

    // This is the declaration table, used to find the owner
    SetLocalObject(oTarget, "DECL_IL:"+sName, oTarget);
    SetLocalInt(oTarget, "DECL_ILF:"+sName, nFlags);
}

void ai_DeclareFloat(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    if (GetIsFlagSet(nFlags, AI_VAR_INHERIT))
        ai_AddStringRef(oTarget, sName, "DECL_F*:");

    SetLocalObject(oTarget, "DECL_F:"+sName, oTarget);
    SetLocalInt(oTarget, "DECL_FF:"+sName, nFlags);
}

void ai_DeclareFloatRef(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    if (GetIsFlagSet(nFlags, AI_VAR_INHERIT))
        ai_AddStringRef(oTarget, sName, "DECL_FL*:");

    SetLocalObject(oTarget, "DECL_FL:"+sName, oTarget);
    SetLocalInt(oTarget, "DECL_FLF:"+sName, nFlags);
}

void ai_DeclareString(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    if (GetIsFlagSet(nFlags, AI_VAR_INHERIT))
        ai_AddStringRef(oTarget, sName, "DECL_S*:");

    SetLocalObject(oTarget, "DECL_S:"+sName, oTarget);
    SetLocalInt(oTarget, "DECL_SF:"+sName, nFlags);
}

void ai_DeclareStringRef(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    if (GetIsFlagSet(nFlags, AI_VAR_INHERIT))
        ai_AddStringRef(oTarget, sName, "DECL_SL*:");

    SetLocalObject(oTarget, "DECL_SL:"+sName, oTarget);
    SetLocalInt(oTarget, "DECL_SLF:"+sName, nFlags);
}

void ai_DeclareObject(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    if (GetIsFlagSet(nFlags, AI_VAR_INHERIT))
        ai_AddStringRef(oTarget, sName, "DECL_O*:");

    SetLocalObject(oTarget, "DECL_O:"+sName, oTarget);
    SetLocalInt(oTarget, "DECL_OF:"+sName, nFlags);
}

void ai_DeclareObjectRef(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    if (GetIsFlagSet(nFlags, AI_VAR_INHERIT))
        ai_AddStringRef(oTarget, sName, "DECL_OL*");

    SetLocalObject(oTarget, "DECL_OL:"+sName, oTarget);
    SetLocalInt(oTarget, "DECL_OLF:"+sName, nFlags);
}

void ai_DeclareLocation(string sName, object oTarget = OBJECT_INVALID, int nFlags = AI_VAR_INHERIT)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    if (GetIsFlagSet(nFlags, AI_VAR_INHERIT))
        ai_AddStringRef(oTarget, sName, "DECL_L*");

    SetLocalObject(oTarget, "DECL_L:"+sName, oTarget);
    SetLocalInt(oTarget, "DECL_LF:"+sName, nFlags);
}

void ai_DeclareResponseTable(string sTable, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    // Declare start table
    string sFullTable = AI_RESPONSE_START + sTable;
    ai_DeclareStringRef(sFullTable, oTarget);

    // Declare end table
    sFullTable = AI_RESPONSE_END + sTable;
    ai_DeclareStringRef(sFullTable, oTarget);

    // Declare high priority response band
    sFullTable = AI_RESPONSE_HIGH + sTable;
    ai_DeclareStringRef(sFullTable, oTarget);
    ai_DeclareIntRef(sFullTable,oTarget);

    // Declare medium priority response band
    sFullTable = AI_RESPONSE_MEDIUM + sTable;
    ai_DeclareStringRef(sFullTable, oTarget);
    ai_DeclareIntRef(sFullTable,oTarget);

    // Declare low priority response band
    sFullTable = AI_RESPONSE_LOW + sTable;
    ai_DeclareStringRef(sFullTable, oTarget);
    ai_DeclareIntRef(sFullTable,oTarget);}

void ai_DeclareLocalMessage(string sMessageName, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    ai_DeclareString  (AI_MESSAGE+sMessageName, oTarget);
    ai_DeclareInt     (AI_MESSAGE+sMessageName, oTarget);
    ai_DeclareFloat   (AI_MESSAGE+sMessageName, oTarget);
    ai_DeclareLocation(AI_MESSAGE+sMessageName, oTarget);
    ai_DeclareObject  (AI_MESSAGE+sMessageName, oTarget);

    ai_DeclareString  (AI_MESSAGE+sMessageName, oTarget);
    ai_DeclareString  (AI_MESSAGE+sMessageName, oTarget);

    ai_DeclareObject  (AI_MESSAGE_SENDER+sMessageName, oTarget);
    ai_DeclareObject  (AI_MESSAGE_RECEIVER+sMessageName, oTarget);
}

// ---- MAPPING IMPLEMENTATION -------------------------------------------------

void ai_MapInt(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    SetLocalString(oTarget, "VMAP_I:"+sLocalVar, sInheritedVar);
}

void ai_MapIntRef(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    SetLocalString(oTarget, "VMAP_IL:"+sLocalVar, sInheritedVar);
}

void ai_MapFloat(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    SetLocalString(oTarget, "VMAP_F:"+sLocalVar, sInheritedVar);
}

void ai_MapFloatRef(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    SetLocalString(oTarget, "VMAP_FL:"+sLocalVar, sInheritedVar);
}

void ai_MapString(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    SetLocalString(oTarget, "VMAP_S:"+sLocalVar, sInheritedVar);
}

void ai_MapStringRef(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    SetLocalString(oTarget, "VMAP_SL:"+sLocalVar, sInheritedVar);
}

void ai_MapObject(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    SetLocalString(oTarget, "VMAP_O:"+sLocalVar, sInheritedVar);
}

void ai_MapObjectRef(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    SetLocalString(oTarget, "VMAP_OL:"+sLocalVar, sInheritedVar);
}

void ai_MapLocation(string sLocalVar, string sInheritedVar, object oTarget = OBJECT_INVALID)
{
    if (oTarget == OBJECT_INVALID) oTarget = MEME_SELF;
    if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;

    SetLocalString(oTarget, "VMAP_L:"+sLocalVar, sInheritedVar);
}

// ---- GET INHERITED IMPLEMENTATION -------------------------------------------

// Variable declarations tables look like: DECL_<type>:<varname> where type is:
// F: Float,    FF: Float Flags,    FL: Float List,    FLF: Float List Flags     F*: Float Declation Table     FL*: Float List Declaration Table
// O: Object,   OF: Object Flags,   OL: Object List,   OLF: Object List Flags    O*: Object Declation Table    OL*: Object List Declaration Table
// I: Int,      IF: Int Flags,      IL: Int List,      ILF: Int List Flags       I*: Int Declation Table       IL*: Int List Declaration Table
// L: Location, LF: Location Flags, LL: Location List, LLF: Location List Flags  L*: Location Declation Table  LL*: Location List Declaration Table
// S: String,   SF: String Flags,   SL: String List,   SLF: String List Flags    S*: String Declation Table    SL*: String List Declaration Table

int ai_GetLocalInt(object oObject, string sVarName)
{
    // 1. There will be a declaration entry if:
    //   * oObject is a class or merged class - merge class entries point to the
    //     owner class - order is dependent to solve collisions from multiple
    //     inheritance.
    //   * oObject is an instance with an overriding variable
    object oDeclarationTarget = GetLocalObject(oObject, "DECL_I:"+sVarName);
    if (oDeclarationTarget != OBJECT_INVALID)
        return GetLocalInt(oDeclarationTarget, sVarName);

    // 2. There will be a parent if:
    //   * This is a class that inherits a value from another class
    //   * This is an object which directly inherits from another object
    object oParent = GetLocalObject(oObject, AI_MEME_PARENT);
    if (oParent != OBJECT_INVALID)
    {
        // 2a. Is the variable name remapped to a new name on the parent object?
        string sMapName = GetLocalString(oObject, "VMAP_I:"+sVarName);
        if (sMapName != "")
            sVarName = sMapName;

        // Now this is expensive - but rarely occurs. I tried to avoid
        // walking an inheritance tree, wherever possible.
        return ai_GetLocalInt(oParent, sVarName);
    }

    // 3. Otherwise just return the usual value.
    return GetLocalInt(oObject, sVarName);
}

float ai_GetLocalFloat(object oObject, string sVarName)
{
    string sMapName;
    object oDeclarationTarget = GetLocalObject(oObject, "DECL_F:"+sVarName);
    if (oDeclarationTarget != OBJECT_INVALID)
        return GetLocalFloat(oDeclarationTarget, sVarName);

    object oParent = GetLocalObject(oObject, AI_MEME_PARENT);
    if (oParent != OBJECT_INVALID)
    {
        sMapName = GetLocalString(oObject, "VMAP_F:"+sVarName);
        if (sMapName != "")
            sVarName = sMapName;

        return ai_GetLocalFloat(oParent, sVarName);
    }

    return GetLocalFloat(oObject, sVarName);
}

string ai_GetLocalString(object oObject, string sVarName)
{
    string sMapName;
    object oDeclarationTarget = GetLocalObject(oObject, "DECL_S:"+sVarName);
    if (oDeclarationTarget != OBJECT_INVALID)
        return GetLocalString(oDeclarationTarget, sVarName);

    object oParent = GetLocalObject(oObject, AI_MEME_PARENT);
    if (oParent != OBJECT_INVALID)
    {
        sMapName = GetLocalString(oObject, "VMAP_S:"+sVarName);
        if (sMapName != "")
            sVarName = sMapName;

        return ai_GetLocalString(oParent, sVarName);
    }

    return GetLocalString(oObject, sVarName);
}

location ai_GetLocalLocation(object oObject, string sVarName)
{
    string sMapName;
    object oDeclarationTarget = GetLocalObject(oObject, "DECL_L:"+sVarName);
    if (oDeclarationTarget != OBJECT_INVALID)
        return GetLocalLocation(oDeclarationTarget, sVarName);

    object oParent = GetLocalObject(oObject, AI_MEME_PARENT);
    if (oParent != OBJECT_INVALID)
    {
        sMapName = GetLocalString(oObject, "VMAP_L:"+sVarName);
        if (sMapName != "")
            sVarName = sMapName;

        return ai_GetLocalLocation(oParent, sVarName);
    }

    return GetLocalLocation(oObject, sVarName);
}

object ai_GetLocalObject(object oObject, string sVarName)
{
    string sMapName;
    object oDeclarationTarget = GetLocalObject(oObject, "DECL_O:"+sVarName);
    if (oDeclarationTarget != OBJECT_INVALID)
        return GetLocalObject(oDeclarationTarget, sVarName);

    object oParent = GetLocalObject(oObject, AI_MEME_PARENT);
    if (oParent != OBJECT_INVALID)
    {
        sMapName = GetLocalString(oObject, "VMAP_O:"+sVarName);
        if (sMapName != "")
            sVarName = sMapName;

        return ai_GetLocalObject(oParent, sVarName);
    }

    return GetLocalObject(oObject, sVarName);
}

// Note: inheritance not supported.
struct message ai_GetLocalMessage(object oTarget, string sMessageName)
{
    struct message sMessage;
    sMessage.sData = ai_GetLocalString  (oTarget, AI_MESSAGE+sMessageName);
    sMessage.nData = ai_GetLocalInt     (oTarget, AI_MESSAGE+sMessageName);
    sMessage.fData = ai_GetLocalFloat   (oTarget, AI_MESSAGE+sMessageName);
    sMessage.lData = ai_GetLocalLocation(oTarget, AI_MESSAGE+sMessageName);
    sMessage.oData = ai_GetLocalObject  (oTarget, AI_MESSAGE+sMessageName);
    sMessage.oSender = ai_GetLocalObject(oTarget, AI_MESSAGE_SENDER+sMessageName);
    sMessage.oTarget = ai_GetLocalObject(oTarget, AI_MESSAGE_RECEIVER+sMessageName);
    sMessage.sChannelName = ai_GetLocalString(oTarget, AI_MESSAGE_CHANNEL+sMessageName);
    sMessage.sMessageName = ai_GetLocalString(oTarget, AI_MESSAGE_NAME+sMessageName);
    return sMessage;
}

void ai_SetLocalInt(object oTarget, string sVarName, int nValue)
{
    // Only bother with a delcaration entry if there is inheritance.
    if (GetLocalObject(oTarget, AI_MEME_PARENT) != OBJECT_INVALID)
        SetLocalObject(oTarget, "DECL_I:"+sVarName, oTarget);

    SetLocalInt(oTarget, sVarName, nValue);
}

void ai_SetLocalFloat(object oTarget, string sVarName, float fValue)
{
    // Only bother with a delcaration entry if there is inheritance.
    if (GetLocalObject(oTarget, AI_MEME_PARENT) != OBJECT_INVALID)
        SetLocalObject(oTarget, "DECL_F:"+sVarName, oTarget);

    SetLocalFloat(oTarget, sVarName, fValue);
}

void ai_SetLocalString(object oTarget, string sVarName, string sValue)
{
    // Only bother with a delcaration entry if there is inheritance.
    if (GetLocalObject(oTarget, AI_MEME_PARENT) != OBJECT_INVALID)
        SetLocalObject(oTarget, "DECL_S:"+sVarName, oTarget);

    SetLocalString(oTarget, sVarName, sValue);
}

void ai_SetLocalObject(object oTarget, string sVarName, object oValue)
{
    // Only bother with a delcaration entry if there is inheritance.
    if (GetLocalObject(oTarget, AI_MEME_PARENT) != OBJECT_INVALID)
        SetLocalObject(oTarget, "DECL_O:"+sVarName, oTarget);

    SetLocalObject(oTarget, sVarName, oValue);
}

void ai_SetLocalLocation(object oTarget, string sVarName, location lValue)
{
    // Only bother with a delcaration entry if there is inheritance.
    if (GetLocalObject(oTarget, AI_MEME_PARENT) != OBJECT_INVALID)
        SetLocalObject(oTarget, "DECL_L:"+sVarName, oTarget);

    SetLocalLocation(oTarget, sVarName, lValue);

}

// Note: inheritance not supported.
void ai_SetLocalMessage(object oTarget, string sMessageName, struct message sMessage)
{
    // First we store the five data fields, AI_MESSAGE is a prefix to avoid colliding
    // with other user variables or other data.
    ai_SetLocalString  (oTarget, AI_MESSAGE+sMessageName, sMessage.sData);
    ai_SetLocalInt     (oTarget, AI_MESSAGE+sMessageName, sMessage.nData);
    ai_SetLocalFloat   (oTarget, AI_MESSAGE+sMessageName, sMessage.fData);
    ai_SetLocalLocation(oTarget, AI_MESSAGE+sMessageName, sMessage.lData);
    ai_SetLocalObject  (oTarget, AI_MESSAGE+sMessageName, sMessage.oData);

    // Next we store the message routing information. Although these fields
    // are read only, I use this function internally and use these values.
    ai_SetLocalString  (oTarget, AI_MESSAGE_CHANNEL+sMessageName, sMessage.sChannelName);
    ai_SetLocalString  (oTarget, AI_MESSAGE_NAME+sMessageName, sMessage.sMessageName);

    // Finally we store the transient ownership object references
    ai_SetLocalObject  (oTarget, AI_MESSAGE_SENDER+sMessageName, sMessage.oSender);
    ai_SetLocalObject  (oTarget, AI_MESSAGE_RECEIVER+sMessageName, sMessage.oTarget);
}

// Note: inheritance not supported.
void ai_DeleteLocalMessage(object oTarget, string sMessageName)
{
    DeleteLocalString  (oTarget, AI_MESSAGE+sMessageName);
    DeleteLocalInt     (oTarget, AI_MESSAGE+sMessageName);
    DeleteLocalFloat   (oTarget, AI_MESSAGE+sMessageName);
    DeleteLocalLocation(oTarget, AI_MESSAGE+sMessageName);
    DeleteLocalObject  (oTarget, AI_MESSAGE+sMessageName);
    DeleteLocalString  (oTarget, AI_MESSAGE_CHANNEL+sMessageName);
    DeleteLocalString  (oTarget, AI_MESSAGE_NAME+sMessageName);
    DeleteLocalObject  (oTarget, AI_MESSAGE_SENDER+sMessageName);
    DeleteLocalObject  (oTarget, AI_MESSAGE_RECEIVER+sMessageName);
}

//-----------------------------------------------------------------------------

// For example:
// For example: ai_GetConfigString(OBJECT_SELF, "Home Areas", 1);
//   if Home Areas 1 is @Commoner Area

string ai_GetConfigString(object oTarget, string sName, int nIndex=0)
{
    string sSuffix  = "";
    string sSuffix2 = "";

    // Add the suffix like " 1" ... " 19".
    if (nIndex > 0)
    {
        // We check the first item in the list for the @ symbol
        sSuffix = " 1";
        sSuffix2 = " "+IntToString(nIndex);
    }
    string sName2 = sName + sSuffix;

    string sString = ai_GetLocalString(oTarget, sName2);
    if (GetStringLeft(sString, 1) == "@")
    {
        oTarget = GetModule();
        sName = GetStringRight(sString, GetStringLength(sString) - 1);
    }

    return GetLocalString(oTarget, sName + sSuffix2);
}

//------------------------------------------------------------------------------

object ai_GetClassByIndex(int nIndex = 0, object oObject = OBJECT_SELF)
{
    oObject = ai_GetNPCSelf(oObject);

    if (!GetIsObjectValid(oObject))
        return OBJECT_INVALID;

    string sClassName = ai_GetStringByIndex(oObject, nIndex, AI_MEME_PARENTS);
    return GetLocalObject(ai_GetMemeVault(), AI_CLASS + sClassName);
}

int ai_GetClassCount(object oObject = OBJECT_SELF)
{
    oObject = ai_GetNPCSelf(oObject);
    return ai_GetObjectCount(ai_GetMemeVault(), AI_MEME_PARENTS);
}

object ai_GetClassObject(string sClassName)
{
    return GetLocalObject(ai_GetMemeVault(), AI_CLASS + sClassName);
}

//------------------------------------------------------------------------------

// Create the relationship between child and parent
void ai_InheritFrom(object oTarget, object oParentClass)
{
    ai_DebugStart("ai_InheritFrom", AI_DEBUG_UTILITY);

    // Detach ourselves from any old classes - we do not track parents when
    // ai_InheritFrom is used. It's an anonymous inheritance.
    ai_DeleteStringRefs(oTarget, AI_MEME_PARENTS);

    // Overwrite any old inheritance
    SetLocalObject(oTarget, AI_MEME_PARENT, oParentClass);

    ai_DebugEnd();
}

//------------------------------------------------------------------------------

// This is an internal function used by ai_InstanceOf. Its job is to
// go to each variable in the given declaration table type and
// extract the variable name and have the new class mirror the class
// table.
void _CopyDeclTable(object oClass, object oNewClass, string sType)
{
    ai_DebugStart("_CopyDeclTable", AI_DEBUG_UTILITY);
    string sDecl = sType+"*:"; // I think this is right.
    sType = sType+":";
    string sVar;
    object oOwner;
    int nCount = ai_GetStringCount(oClass, sDecl);

    for (0; nCount > 0; nCount--)
    {
        sVar = ai_GetStringByIndex(oClass, nCount-1, sDecl);
        oOwner = GetLocalObject(oClass, sType+sVar);
        SetLocalObject(oNewClass, sType+sVar, oOwner);
    }
    ai_DebugEnd();
}

// Create an instance of a given class, we must support:
//
// ai_InstanceOf(oTarget, "class_base");
// ai_InstanceOf(oTarget, "pickle, earplug");  and then...
// ai_InstanceOf(oTarget, "xyzzy,schnatchzy-poo,BLEEM!!,vogon poetry,thing-your-aunt-gave-you, ");
//
// oTarget may be a class or a non-class.
void ai_InstanceOf(object oTarget, string sClass, int nBias=0)
{
    ai_DebugStart("ai_InstanceOf", AI_DEBUG_UTILITY);

    // 1. First we want to build a list of the requested classes
    ai_ExplodeList(oTarget, sClass, AI_MEME_NEW_PARENTS);

    // 2. Next we remove the classes we already belong to
    int count = ai_GetStringCount(oTarget, AI_MEME_PARENTS);
    int count2 = ai_GetStringCount(oTarget, AI_MEME_NEW_PARENTS);
    int count3;
    string sName, sNewName;
    object oVault = ai_GetMemeVault();

    ai_DebugStart("PruneList", AI_DEBUG_UTILITY);
    // Iterate through the short, new list.
    for (; count2 > 0; count2--)
    {
        // Get the name of the new class
        sNewName = ai_GetStringByIndex(oTarget, count2-1, AI_MEME_NEW_PARENTS);
        // Iterate through the potentailly longer old list.
        for (count3 = count; count3 > 0; count3--)
        {
            // Get the name of one of the current classes.
            sName = ai_GetStringByIndex(oTarget, count3-1, AI_MEME_PARENTS);
            // Do we already have it? if so, remove it from the new list
            if (sName == sNewName)
            {
                //ai_PrintString("Removing duplicate class entry, "+sNewName+".");
                ai_RemoveStringByIndex(oTarget, count2-1, AI_MEME_NEW_PARENTS);
            }
        }
    } // Now, we've removed all the classes that we already belong to, NewParents may be substantially shorter.

    // 3. Then we remove the classes that don't exist
    // (Incidently, the reason why I always count downwards is it allows me to
    // delete the entry. If I was going up I would have to shrink the count,
    // which is a hassle.)
    for (count = ai_GetStringCount(oTarget, AI_MEME_NEW_PARENTS); count > 0; count--)
    {
        sNewName = ai_GetStringByIndex(oTarget, count-1, AI_MEME_NEW_PARENTS);
        if (GetLocalObject(oVault, AI_CLASS+sNewName) == OBJECT_INVALID)
        {
            //ai_PrintString("I have never head of class, "+sNewName+".");
            //ai_PrintString("Did you forget to initialize a class library?");
            ai_RemoveStringByIndex(oTarget, count-1, AI_MEME_NEW_PARENTS);
        }
    } // Now we have a shorter list of new classes to be added

    ai_DebugEnd();

    count = ai_GetStringCount(oTarget, AI_MEME_NEW_PARENTS);
    if (count == 0)
    {
        ai_DeleteStringRefs(oTarget, AI_MEME_NEW_PARENTS);
        //ai_PrintString("Warning: This declaration has failed, I cannot find any classes you are requesting.");
        ai_DebugEnd();
        return;
    }


    // 4. Add these items to the Parents list
    ai_DebugStart("MergeList", AI_DEBUG_UTILITY);
    count = ai_GetStringCount(oTarget, AI_MEME_NEW_PARENTS);
    //ai_PrintString("There are "+IntToString(count)+" new classes being added.");
    for (0; count > 0; count--)
    {
        sNewName = ai_GetStringByIndex(oTarget, count-1, AI_MEME_NEW_PARENTS);
        //ai_PrintString("Adding "+sNewName+".");
        ai_AddStringRef(oTarget, sNewName, AI_MEME_PARENTS);
    }
    count = ai_GetStringCount(oTarget, AI_MEME_PARENTS);
    //ai_PrintString("This object now belongs to "+IntToString(count)+" classes.");

    // 5. Get the class key of the current Parent
    object oParent = GetLocalObject(oTarget, AI_MEME_PARENT);
    string sKey = GetLocalString(oParent, AI_CLASS_KEY);
    string sFullName = _GetName(oParent);

    // 6. Merge it with each of the new class keys
    string sNewKey;
    for (count; count > 0; count--)
    {
        sNewName = ai_GetStringByIndex(oTarget, count-1, AI_MEME_NEW_PARENTS);
        sFullName += "/"+sNewName;
        sNewKey  = GetLocalString(oVault, AI_CLASS_KEY_PREFIX+sNewName);
        sKey     = _KeyCombine(sNewKey, sKey);

        SetLocalInt(NPC_SELF, "AI_MEME_"+sNewName+"_BIAS", nBias++);
    }
    ai_DebugEnd();

    // 7. Does this new class key exist? Is this a newly discovered class combination? A new breed of NPC? Could it be??
    object oNewClass = GetLocalObject(oVault, AI_CLASS_KEY_PREFIX+sKey);
    object oClass, oOwner;

    if (oNewClass == OBJECT_INVALID)
    {
        ai_DebugStart("NewClass");
        ai_PrintString("I've never seen this combination of classes, let's set you up.");

        // 8. Create the new merged class
        oNewClass = CreateObject(OBJECT_TYPE_STORE, AI_MEME_VAULT, GetLocation(oVault), FALSE, "MemeticClassObject");

        if (!GetIsObjectValid(oNewClass))
            ai_PrintString("Error: Failed to create class object represeting merged class combination.");

        SetName(oNewClass, sFullName);

        // (There is no _ini to call, this is a combined class.)
        // (There are no names to be stored, only key referencing.)
        SetLocalString(oNewClass, AI_CLASS_KEY, sNewKey);
        SetLocalObject(oVault, AI_CLASS_KEY_PREFIX+sNewKey, oNewClass);

        // 9. Copy the declaration tables from each class, in order
        //   Now honestly, this is a potential area for TMI, this may need to be
        //   split out into asynchronous copy chunks. I would just separate this
        //   whole block into a function and call DelayCommand(0.0, x(a,b,c));
        count = ai_GetStringCount(oTarget, AI_MEME_PARENTS);
        //ai_PrintString("This object now belongs to "+IntToString(count)+" classes.");
        for (0; count > 0; count--)
        {
            sName = ai_GetStringByIndex(oTarget, count-1, AI_MEME_PARENTS);
            oClass = GetLocalObject(oVault, AI_CLASS+sName);
            //ai_PrintString("Merging the declaration tables from class "+sName+".");

            // Each class may have declared variables of nine types, we
            // must transfer those definitions to the merged class.
            // This process is done once to be able to efficiently look up
            // owners of variables with a nearly-direct access lookup -
            // O(1) vs. O(n) order of complexity when calling ai_Get*().
            ai_DebugStart("CopyAllDeclTables");

            _CopyDeclTable(oClass, oNewClass, "DECL_F");
            _CopyDeclTable(oClass, oNewClass, "DECL_FL");
            _CopyDeclTable(oClass, oNewClass, "DECL_O");
            _CopyDeclTable(oClass, oNewClass, "DECL_OL");
            _CopyDeclTable(oClass, oNewClass, "DECL_I");
            _CopyDeclTable(oClass, oNewClass, "DECL_IL");
            _CopyDeclTable(oClass, oNewClass, "DECL_L");
            //_CopyDeclTable(oClass, oNewClass, "DECL_L"); // Lists of locations are not supported yet
            _CopyDeclTable(oClass, oNewClass, "DECL_S");
            _CopyDeclTable(oClass, oNewClass, "DECL_SL");

            ai_DebugEnd();

            // Conceivably here is where we would also assess the flags to
            // optionally copy the value instead of inheriting the value.
        }
        ai_DebugEnd();
    }
    else
    {
        //ai_PrintString("Oh, I know what class this is.");
    }

    // 10. Set the Parent to be the new merged class object
    ai_DebugStart("ConnectToNewClass", AI_DEBUG_UTILITY);
    SetLocalObject(oTarget, AI_MEME_PARENT, oNewClass);
    if (!GetIsObjectValid(oNewClass))
    {
        //ai_PrintString("Error: Failed to create class object represeting merged class combination.");
    }
    //ai_PrintString("Now that I know about this class, I'll set your AI_MEME_PARENT to it. ("+_GetName(oTarget)+"->"+_GetName(oNewClass)+")", DEBUG_UTILITY);

    // 11. For each new class, MeExecuteScript() name_go
    count = ai_GetStringCount(oTarget, AI_MEME_NEW_PARENTS);
    //ai_PrintString("There are "+IntToString(count)+" classes to instantiate.", DEBUG_UTILITY);

    for (0; count > 0; count--)
    {
        sNewName = ai_GetStringByIndex(oTarget, count-1, AI_MEME_NEW_PARENTS); // Direct access for efficiency
        oNewClass = GetLocalObject(oVault, AI_CLASS+sNewName);
        DelayCommand(0.0, ai_ExecuteScript("ai_c_"+sNewName, AI_METHOD_GO, OBJECT_SELF, oNewClass));
    }

    // 12. Clean up that new parent list.
    ai_DeleteStringRefs(oTarget, AI_MEME_NEW_PARENTS);
    ai_DebugEnd();

    ai_DebugEnd();
}

/*  I support two forms of variable inheritance. This distinction is made to
 *  reduce memory consumption and increase the flexibility of the code.
 *
 *  First, an object may inherit variables from a named, shared, "class object".
 *  It will inherit all the variables on the class and the variables it inherits.
 *
 *  Alternatively, an object may inherit values from a "parent" non-class object.
 *  But this will only inherit the variables the parent has explicitly declared.
 *  If the parent inherits variables from another object, these will not be inherited.
 *
 *  Any object can have declared variables.
 *  Any object can inherit variables from parent objects.
 *  A class is an invisible object that is globally accessible by name.
 *  A class copies all the variable declarations
 *  An object inherits all the variables a class inherits -- but only a class.
 */


/*
 Class Variables
 ---------------
 1) Module Object

    int    MEME_KeyCount
    object MEME_CLASS_+<classname>

 2) Class (Parent) Objects

    string MEME_ActiveClass
    string MEME_ClassKey

 3) Inheriting (Child) Objects

    string  MEME_ActiveClass
    object  MEME_Parent

 4) Objects with Declared Variables

 5) NPC_SELF

    int MEME_+<class>+_Bias

*/

// void main(){}
