/*
Filename:           ai_i_event
System:             Memetic AI (include script)
Author:             Michael A. Sinclair (Squatting Monk)
Date Created:       Jun. 19, 2009
Summary:
Memetic AI include script. This file holds class functions commonly used
throughout the Memetic AI system. These functions allow you to create Memetic
Event objects, a set of scripts (or functions in a library) that are executed
when a message is sent to an NPC or a channel that the event object is
subscribed to.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ai_i_class"


/******************************************************************************/
/*                             Function Prototypes                            */
/******************************************************************************/

// ---< ai_CreateEvent >---
// ---< ai_i_event >---
// Creates an event object, used to respond to a message.
// Messages have data that can be sent to one or many objects via a channel.
// You can define e_myevent_ini and e_myevent_go scripts or define them in a
// library. By calling ai_SubscribeMessage(), you can cause this code to execute
// when a particular message is sent to this object, or on a channel. Some
// events automatically subscribe to a channel in the _ini script. Many memetic
// objects, scripts, and things like Point of Interest emitters send event
// messages on standard channels. Refer to the documentation for each event and
// library to learn more.
object ai_CreateEvent(string sEventName, object oTarget = OBJECT_SELF);

// ---< ai_DestroyEvent >---
// ---< ai_i_event >---
// Destroys an event object, causing it to be unsubscribed from any channels and
// clean up any allocated memory.
void ai_DestroyEvent(object oEvent, object oTarget = OBJECT_SELF);

// ---< ai_ActivateEvent >---
// ---< ai_i_event >---
// Executes the event object, running ai_e_<event name>_go
void ai_ActivateEvent(object oEvent);

// ---< ai_GetEvent >---
// ---< ai_i_event >---
// Returns an event with the given name or by count. You can provide as many or
// as few of these parameters as you like to query the internal memetic store.
// If no name is provided, every event can be found.
object ai_GetEvent(string sName = "", int nIndex = 0, object oTarget = OBJECT_SELF);

// ---< ai_SubscribeMessage >---
// ---< ai_i_event >---
// Subcribes the event to a channel or particular message. When the channel name
// is empty, the event will be senstive to messages on the private channel. If
// the message name is empty, the event will be activated whenever any message
// is sent to the object that holds this event. If a message name and channel
// name are provided then the event will be activated when the particular
// message on the given channel is received. It is safe to call this function
// more than once on the event object.
void ai_SubscribeMessage(object oEvent, string sMessageName = "", string sChannelName  = "");

// ---< ai_UnsubscribeMessage >---
// ---< ai_i_event >---
// Stops an event from activating when a message on a channel is received. This
// must correspond to a message/channel combination that the even subscribed to.
// For example, if the event subscribed to all messages on a channel, you cannot
// unsubscribe to one particular message, only the whole channel. But if you
// subscribed to message "RedTeamStart" and "BlueTeamStart", you can unsubscribe
// to "RedTeamStart" and still respond to the "BlueTeamStart" message.
void ai_UnsubscribeMessage(object oEvent, string sMessageName = "", string sChannelName = "");

// --- Message Functions -------------------------------------------------------

// Messages are basic datastructures used to send information to one or many
// objects. They are received by Memetic Event objects and can be given to a
// scheduler for persistant, delayed, or recurring transmission.

// ---< ai_SendMessage >---
// ---< ai_i_event >---
// Sends a message to an NPC. It assumes the NPC has an event object created by
// ai_CreateEvent(), which may subscrib to the message by ai_SubscribeMessage().
// When the message is sent, the event object's code is executed (i.e.,
// ai_e_myeventname_go script).
// Paramters:
// - sMessage: This is a struct that contains the message information. When the
//   message is sent, the information will be added to the struct so that the
//   receiver will know who sent the message.
// - sChannel: This simulates receiving the message on a channel. This will NOT
//   send the message to everyone else on the channel; to do that, you would use
//   ai_BroadcastMessage().
// - oTarget: This is the object that should receive the event. If this object
//   is invalid, the message will be sent to yourself. When the message is
//   received, each event object that has subscribed to the message (or to all
//   messages) will be activated.
// - oSender: This is who sent the message.
void ai_SendMessage(struct message sMessage, string sChannel = "", object oTarget = OBJECT_SELF, object oSender = OBJECT_SELF);

// ---< ai_BroadcastMessage >---
// ---< ai_i_event >---
// Automatically calls ai_SendMessage() for each NPC that has an event that has
// subscribed to the given channel. This allows you to efficiently notify a
// group of NPCs about something. More importantly, it allows you to send
// messages out, without knowing about specific NPCs.
//
// For example, you could send a "CityMood" message to the "Town of Morville"
// channel. All NPCs could subscribe to this channel when they enter the town,
// and adjust their behavior according to the "CityMood". When they leave and go
// to the next town they can subscribe to that town's channel instead.
// Parameters:
// - sMessage: This is a struct that contains the message information. When the
//   message is sent, the information will be added to the struct so that the
//   receiver will know who sent the message. The channel is set in the message
//   struct to allow the event to know it came from a broadcast channel.
// - sChannel: This is the name of your broadcast channel. It will correspond to
//   the name of the channel passed as a parameter to ai_SubscribeMessage(). If
//   you pass "", then you will send the message to yourself.
void ai_BroadcastMessage(struct message sMessage, string sChannel);

// ---< ai_GetLastMessage >---
// ---< ai_i_event >---
// This is used by an event script to get the message structure
struct message ai_GetLastMessage();

// ---< ai_CreateMessage >---
// ---< ai_i_event >---
// This is a convenient way to make the message struct. It is for people who are
// unfamiliar with using structs and defining them. Keep in mind it is more
// efficient to use the NWScript notation for making a struct. This will
// automatically fill the location field with the location of OBJECT_SELF.
struct message ai_CreateMessage(string sName, string sData="", int nData=0, float fData=0.0, object oData=OBJECT_INVALID);

// --- Scheduler Functions -----------------------------------------------------

// The scheduler is an efficent system for running scripts, or sending messages
// at certain time or at regular intervals. The time can be based on game-time,
// real-time, or an offset of an abstract moment in time, like "Dawn" or "Noon".
// These moments can be defined as an offset from an earlier moments, or the
// current time. This unit of time is in seconds, not floats.

// ---< ai_ScheduleMoment >---
// ---< ai_i_event >---
// Defines an abstract moment in time. When it occurs, anything scheduled to
// occur based on that moment is scheduled. This means that you can adjust this
// moment at any time up until it happens.
//
// A moment with a 0 time is automatically activated and cannot be marked as
// repeat if there is no earlier moment.
// Parameters:
// - sMomentName: This is an arbitrary name of a moment in time, like "dawn" or
//   "lunchtime" or "end of chapter 2".
// - nTime: This is the amount of time before the moment occurs. Use the
//   function ai_Time() to define this value.
// - sEarlierMoment: This is the name of another moment that will trigger this
//   moment. For example, "dawn" may be 6 hours after "midnight".
// - bRepeat: This flag means that the moment should be rescheduled to occur
//   with the same time delay, triggered off the optional earlier moment. Thus,
//   you can easily set up daily events triggers X hours after "dawn".
int ai_ScheduleMoment(string sMomentName, int nTime=0, string sEarlierMoment="", int bRepeat=FALSE);

// ---< ai_ActivateMoment >---
// ---< ai_i_event >---
// Causes a moment to immediately occur, which may cause other scheduled things
// to happen.
// - sMomentName: This is an arbitrary string like "dawn" or "team 1 wins".
//   Nothing will happen unless something is scheduled using this name.
void ai_ActivateMoment(string sMomentName);

// ---< ai_AdjustSchedule >---
// ---< ai_i_event >---
// Changes when a previously scheduled moment, message, or function will occur.
// If you adjust a moment that has already occurred, all the items based on that
// moment will not be rescheduled. If this moment has not occurred all future
// events based on this moment will be adjusted accordingly. If you set the
// delay to 0, it will be suspended and will wait to be adjusted, later.
//
// For example, let's say that message "flee" is sent when moment "invaders
// arrive" happens. Furthermore, "invaders arrive" happens 10 minutes after
// "dawn". When the moment, "dawn" occurs, the moment "invaders arrive" is
// scheduled to occur. You can change the "invaders arrive" moment earlier to 3
// minutes from dawn. But if 5 minutes have passed, the "invaders arrive" moment
// will be missed and the "flee" message will not be sent.
void ai_AdjustSchedule(int nScheduledThing, int nTime, int bRepeat=TRUE);

// ---< ai_ScheduleMessage >---
// ---< ai_i_event >---
// Schedules a message to be sent at a particular time.
// You can specifiy an offset from an abstract moment in time or an offset from
// the current time. You can have the message repeat if you want it to be resent
// on a regular basis.
int ai_ScheduleMessage(struct message sData, object oTarget, string sChannel = "", int nTime=0, string sMoment="", int bRepeat=FALSE);

// ---< ai_ScheduleFunction >---
// ---< ai_i_event >---
// Schedules a script function defined in a library to be executed at a
// particular time. Functions may be executed by an object and can be passed an
// argument. At this time the return result from the function is ignored.
// You can specify an offset from an abstract moment in time or an offset from
// the current time. You can have the message repeat if you want it to be resent
// on a regular basis.
int ai_ScheduleFunction(object oTarget, string sFunction, object oArgument=OBJECT_INVALID, int nTime=0, string sMoment="", int bRepeat=FALSE);

// ---< ai_ScheduleScript >---
// ---< ai_i_event >---
// Schedules a script to be executed at a particular time by an object.
// You can specifiy an offset from an abstract moment in time or an offset from
// the current time. You can have the message repeat if you want it to be resent
// on a regular basis.
int ai_ScheduleScript(object oTarget, string sScript, int nTime=0, string sMoment="", int bRepeat=FALSE);

// ---< ai_Unschedule >---
// ---< ai_i_event >---
// Stops the event from being scheduled, all the data associated to it is
// cleared. If this thing is a moment, any currently scheduled (in-the-future)
// moments will not activate.
void ai_Unschedule(int nScheduledThing);

// ---< ai_ClearScheduledMoments >---
// ---< ai_i_event >---
// Stops any currently scheduled moments with this ID. For example if you
// schedule a moment, "BlueMonsterSpawn", in 10 minutes and call this function,
// the "BlueMonsterSpawn" moment and all of its related activities will fail
// to occur. Bear in mind that if you have ten "RandomForestSpawn" moments
// scheduled, NONE of these other moments will be invalidated. Only the one
// corresponding to this ID will be invalid.
void ai_ClearScheduledMoments(int nMomentID);

/******************************************************************************/
/*                          Function Implementations                          */
/******************************************************************************/

object ai_CreateEvent(string sEventName, object oTarget = OBJECT_SELF)
{
    ai_DebugStart("ai_CreateEvent", AI_DEBUG_TOOLKIT);

    object oResult, oEventBag, oSelf;

    // We create several invisible objects to hold local data for the event.
    // This allows us to efficiently clear up memory when the event is terminated.
    oSelf = GetLocalObject(oTarget, AI_NPC_SELF);
    if (oSelf == OBJECT_INVALID)
        oSelf = ai_InitializeNPC(oTarget);

    // The event bag holds these event objects.
    oEventBag = GetLocalObject(oSelf, AI_EVENT_BAG);
    if (!GetIsObjectValid(oEventBag))
        PrintString("<Assert>Failed to create event bag. This is a critical bug in ai_InitializeNPC().</Assert>");

    // Add the object to the bag
    oResult = _MakeObject(oEventBag, sEventName, AI_TYPE_EVENT);

    // Inherit the class of the context that's creating this generator.
    SetLocalString(oResult, AI_ACTIVE_CLASS, GetLocalString(MEME_SELF, AI_ACTIVE_CLASS));

    ai_ExecuteScript(sEventName, AI_METHOD_INIT, OBJECT_SELF, oResult);

    ai_DebugEnd();
    return oResult;
}

// The Event object has the string list, AI_MESSAGE_SUBSCRIBE which contains the
// names of all the channel and message lists on NPC_SELF that have a reference
// to this event. When the event is destroyed, the event is removed from each
// of these lists.
void ai_DestroyEvent(object oEvent, object oTarget = OBJECT_SELF)
{
    ai_DebugStart("ai_DestroyEvent", AI_DEBUG_TOOLKIT);

    string sSubscribeName;
    string sEventName = _GetName(oEvent);
    int i;
    for (i = ai_GetObjectCount(oEvent, AI_MESSAGE_SUBSCRIBE)-1; i >= 0; i--)
    {
        sSubscribeName = ai_GetStringByIndex(oEvent, i, AI_MESSAGE_SUBSCRIBE);
        ai_RemoveObjectRef(NPC_SELF, oEvent, sSubscribeName);
    }

    ai_ExecuteScript(sEventName,"_end", OBJECT_SELF, oEvent);
    DestroyObject(oEvent);

    ai_DebugEnd();
}

void ai_ActivateEvent(object oEvent)
{
    ai_DebugStart("ai_ActivateEvent oEvent='"+_GetName(oEvent)+"'", AI_DEBUG_UTILITY);

    if (GetIsObjectValid(oEvent))
        ai_ExecuteScript(_GetName(oEvent), AI_METHOD_GO, OBJECT_SELF, oEvent);

    ai_DebugEnd();
}

// You can pass NPC_SELF or OBJECT_SELF as oTarget -- either should work.
object ai_GetEvent(string sName = "", int nIndex = 0, object oTarget = OBJECT_SELF)
{
    ai_DebugStart("ai_GetEvent", AI_DEBUG_UTILITY);

    object oResult;
    object oEventBag = GetLocalObject(oTarget, AI_EVENT_BAG);

    if (!GetIsObjectValid(oEventBag))
    {
        // All memetic objects are hung off of a "self" object.
        // If there isn't one, this isn't a memetic object.
        oTarget = GetLocalObject(oTarget, AI_NPC_SELF);
        if (oTarget == OBJECT_INVALID)
        {
            ai_DebugEnd();
            return OBJECT_INVALID;
        }
        oEventBag = GetLocalObject(oTarget, AI_EVENT_BAG);
    }

    oResult = ai_GetObjectByName(oEventBag, sName, "", nIndex);

    ai_DebugEnd();
    return oResult;
}

/*
    This assumes the caller of the function owns the event object.
    This function may adds a reference to this object on the meme vault if it
    specifies a channel name. Then a messagename+channelname is stored in
    the subscription list. Then a messagename+channelname int is set to 1.
    When a message arrives if the messagename+channelname is set the event
    is activated. When the vault receives a channel broadcast, it processess
    two lists: the channel list (objects sensitive to all messages) and the
    channel+message list (objects senstive to this message on this channel.)
    Each NPC event on those lists will get the message delivered to it.
*/
void ai_SubscribeMessage(object oEvent, string sMessageName = "", string sChannelName  = "")
{
    ai_DebugStart("ai_SubscribeMessage sMessageName='"+sMessageName+"' sChannelName='"+sChannelName+"'");

    string sID = AI_MEME_EVENTS + "_M:"+sMessageName+"_C:"+sChannelName;
    // The NPC_SELF global represents the memetic NPC.
    ai_AddObjectRef(NPC_SELF, oEvent, sID, TRUE);

    // We store every subscription pair on the event; when the event is destroyed
    // we will use this list to remove the references from the NPC_SELF, when the
    // list count falls to 0 then we can unsubscribe from a channel, if necessary.
    ai_AddStringRef(oEvent, sID, AI_MESSAGE_SUBSCRIBE);

    // If a channel name is provided, this event must be added to a subscription
    // list on the vault. This way the vault can find us.
    if (sChannelName != "")
    {
        // First time subscription sign up for the channel.
        if (ai_GetObjectCount(NPC_SELF, sID) == 1)
            ai_AddObjectRef(ai_GetMemeVault(), NPC_SELF, sID);
    }

    ai_DebugEnd();
}

/*
    This assumes the caller of the function owns the event object.
    This does the inverse of ai_SubscribeMessage(). It removes the message and
    channel int on the event object and from its list and removes any entries
    from the vault's subscription lists.
*/
void ai_UnsubscribeMessage(object oEvent, string sMessageName = "", string sChannelName = "")
{
    ai_DebugStart("ai_UnsubscribeMessage");

    string sID = AI_MEME_EVENTS + "_M:"+sMessageName+"_C:"+sChannelName;
    ai_RemoveObjectRef(NPC_SELF, oEvent, sID);

    // If there are no more events sensitive to this channel...remove myself from the channel
    if (sChannelName != "")
        if (ai_GetObjectCount(NPC_SELF, sID) == 0)
            ai_RemoveObjectRef(ai_GetMemeVault(), NPC_SELF, sID);

    ai_DebugEnd();
}

// --- Message Implementation --------------------------------------------------

/*
    This actively sends a message to a particular object (NPC) that has an
    event handler. If the event is not sensitive to the message or channel
    specified in the message, then it is ignored. Otherwise, the message
    is set locally on the NPC and the event's _go script is executed.
*/
void ai_SendMessage(struct message sMessage, string sChannel="", object oTarget = OBJECT_SELF, object oSender = OBJECT_SELF)
{
    if (oTarget != OBJECT_SELF)
    {
        ai_DebugStart("ai_SendMessage to='"+_GetName(oTarget)+"' MessageName='"+sMessage.sMessageName+"'", AI_DEBUG_TOOLKIT);
        AssignCommand(oTarget, ai_SendMessage(sMessage, sChannel, oTarget, oSender));
        ai_DebugEnd();
        return;
    }

    ai_DebugStart("ReceivedMessage MessageName='"+sMessage.sMessageName+"'", AI_DEBUG_TOOLKIT);

    object oSelf;

    // When we're at this point, there needs to be a valid NPC_SELF.
    // NPC_SELF is where event subscription information is stored. If there isn't
    // an NPC_SELF then oTarget is not a memetic thing and cannot recieve events.

    if (GetLocalInt(OBJECT_SELF, AI_MEME_TYPE) == AI_TYPE_NPC_SELF)
    {
        NPC_SELF = OBJECT_SELF;
        oSelf    = ai_GetNPCSelfOwner(NPC_SELF);
    }
    else
    {
        // Note: If you ever do an AssignCommand of a Memetic Function, NPC_SELF will likely be invalid.
        //       This means that you need to change that memetic function to reset its NPC_SELF, like this:
        oSelf    = OBJECT_SELF;
        NPC_SELF = GetLocalObject(oSelf, AI_NPC_SELF);
    }

    if (NPC_SELF == OBJECT_INVALID)
    {
        ai_PrintString("NPC_SELF == OBJECT_INVALID");
        ai_DebugEnd();
        return;
    }

    // When the system is paused, messages are ignored.
    if (GetLocalInt(NPC_SELF, AI_MEME_PAUSED))
    {
        ai_PrintString(AI_MEME_PAUSED);
        ai_DebugEnd();
        return;
    }

    string sID = AI_MEME_EVENTS + "_M:"+sMessage.sMessageName+"_C:"+sChannel;
    int i;
    object oEvent;
    string sName;

    sMessage.oSender = oSender;
    sMessage.oTarget = oTarget;
    sMessage.sChannelName = sChannel;

    ai_SetLocalMessage(oSelf, AI_MESSAGE_LAST_SENT, sMessage);

    // Beware that if you have too many events on one NPC subscribed to the same
    // message, this may TMI. As a result, you may need to DelayCommand(0.0) on
    // this. I have avoided this because you *MAY* lose your message if another
    // message is backed up against this message. I won't know without further
    // testing. Hopefully we can live with this for a while.
    ai_PrintString("count: "+IntToString(ai_GetObjectCount(NPC_SELF, sID)));
    for (i = ai_GetObjectCount(NPC_SELF, sID)-1; i >= 0; i--)
    {
        oEvent = ai_GetObjectByIndex(NPC_SELF, i, sID);
        sName = _GetName(oEvent);

        ai_PrintString("Calling: " + sName + "_go");
        ai_ExecuteScript(sName, AI_METHOD_GO, oSelf, oEvent);
    }

    ai_DebugEnd();
}

/*
    This actively sends a message to a particular object (NPC) that has an
    event handler. If the event is not sensitive to the message or channel
    specified in the message, then it is ignored. Otherwise, the message
    is set locally on the NPC and the event's _go script is executed.
*/
void ai_BroadcastMessage(struct message sMessage, string sChannel)
{
    ai_DebugStart("ai_BroadcastMessage MessageName='"+sMessage.sMessageName+"'");

    if (sChannel == "")
        ai_SendMessage(sMessage);
    else
    {
        string sID = AI_MEME_EVENTS + "_M:"+sMessage.sMessageName+"_C:"+sChannel;
        int i;
        object oTarget;
        object oVault = ai_GetMemeVault();

        ai_PrintString("Broadcasting to " + IntToString(ai_GetObjectCount(oVault, sID)) + " targets");
        for (i = ai_GetObjectCount(oVault, sID)-1; i >= 0; i--)
        {
            oTarget = ai_GetObjectByIndex(oVault, i, sID);
            if (!GetIsObjectValid(oTarget))
                ai_RemoveObjectByIndex(oVault, i, sID);
            else
            {
                ai_PrintString("Broadcasting to '" + _GetName(oTarget) + "'");
                object oObject = OBJECT_SELF;
                AssignCommand(oTarget, ai_SendMessage(sMessage, sChannel, oTarget, oObject));
            }
        }
    }

    ai_DebugEnd();
}

struct message ai_GetLastMessage()
{
    return ai_GetLocalMessage(OBJECT_SELF, AI_MESSAGE_LAST_SENT);
}


struct message ai_CreateMessage(string sName, string sData="", int nData=0, float fData=0.0, object oData=OBJECT_INVALID)
{
    location lData=GetLocation(OBJECT_SELF);
    struct message sMessage;
    sMessage.sData = sData;
    sMessage.nData = nData;
    sMessage.fData = fData;
    sMessage.lData = lData;
    sMessage.oData = oData;
    sMessage.sChannelName = "";
    sMessage.sMessageName = sName;
    sMessage.oSender = OBJECT_INVALID;
    sMessage.oTarget = OBJECT_INVALID;
    return sMessage;
}

// --- Scheduler Implementation Functions --------------------------------------

// Initial draft of how this works. Some implementation differences may exist.
// Note: this is not a bulletproof scheduler, but it's enough to be useful for
//       a persistant world.
//
// Every schedulable thing gets a number. A count, MESch_C, is incremented with
// each call the schedule functions. Things can either be scheduled in absolute
// terms or terms of a relative moment. Either way, an entry is made, registering
// an int for the schedulable thing. This thing is either scheduled to activate
// by calling DelayCommand or is added to a list of things to be scheduled, based
// on another moment. Finally, if the thing being defined is a moment, the number
// of the moment is registered with its name MESch_MO_<Name>.
//
// When a schedulable thing is registered, a variety of variables may be stored
// on the vault based on its type, keyed off of its id.
//
// MESch_<N>_Repeat: A flag meaning that once this executes, reschedule it. This
//                   is ignored if Delay is 0.0.
// MESch_<N>_Type:   An int representing moment, message,
// MESch_<N>_Name:   This is either the name of the moment, the name of the script
//                   the name of the library function, or message to be called
// MESch_<N>_RelMo:  The relative moment.
// MESch_<N>_Delay:  Number of (float) seconds before this should be activated.
// MESch_<N>_Target: The OBJECT_SELF for functions, scripts, the sender of a message,
// MESch_<N>_Arg:    The argument to a library function.
// MeSch_<N>[]:      This is an object list of schedulable things that are relative to this moment.


void _CallFunction(string a, object b, object c)
{
    ai_CallFunction(a, b, c);
}

void _ActivateMoment(string sMomentName, int mID, string sID, int nGood)
{
    ai_DebugStart("_ActivateMoment sMomentName='"+sMomentName+"' mID='"+IntToString(mID)+"' sID='"+sID+"' nGood='"+IntToString(nGood)+"'", AI_DEBUG_UTILITY);

    if (nGood == GetLocalInt(ai_GetMemeVault(), sID + AI_SCHEDULE_GOOD))
        ai_ActivateMoment(sMomentName);

    ai_DebugEnd();
}

int ai_ScheduleMoment(string sMomentName, int nTime=0, string sEarlierMoment="", int bRepeat=FALSE)
{
    ai_DebugStart("ai_ScheduleMoment sMomentName='"+sMomentName+"'", AI_DEBUG_UTILITY);

    if (nTime == 0 && sEarlierMoment == "" && bRepeat == TRUE)
        bRepeat == FALSE;

    if (bRepeat == TRUE && sEarlierMoment == "")
        sEarlierMoment = sMomentName;

    object oVault = ai_GetMemeVault();
    float fDelay = IntToFloat(nTime);
    ai_PrintString("fDelay: " + FloatToString(fDelay));

    int mID = GetLocalInt(oVault, AI_SCHEDULE_MOMENT_PREFIX + sMomentName);
    if (!mID)
    {
        mID = GetLocalInt(oVault, AI_SCHEDULE_COUNT)+1;
        SetLocalInt(oVault, AI_SCHEDULE_COUNT, mID);
        SetLocalInt(oVault, AI_SCHEDULE_MOMENT_PREFIX + sMomentName, mID);
    }
    string sID = AI_SCHEDULE_PREFIX+IntToString(mID);
    ai_PrintString("sId: "+sID);

    SetLocalInt(oVault,    sID + AI_SCHEDULE_TYPE, 1); // Type 1 is moment
    SetLocalInt(oVault ,   sID + AI_SCHEDULE_GOOD, 1);
    SetLocalInt(oVault,    sID + AI_SCHEDULE_REPEAT, bRepeat);
    SetLocalString(oVault, sID + AI_SCHEDULE_NAME, sMomentName);
    SetLocalFloat(oVault,  sID + AI_SCHEDULE_DELAY, fDelay);
    SetLocalString(oVault, sID + AI_SCHEDULE_RELATIVE_MOMENT, sEarlierMoment);

    // Add this moment to the list of triggered relative things.
    int pID = GetLocalInt(oVault, AI_SCHEDULE_MOMENT_PREFIX+sEarlierMoment);
    if (pID)
        ai_AddIntRef(oVault, mID, AI_SCHEDULE_PREFIX + IntToString(pID));

    if (sEarlierMoment == "")
        DelayCommand(fDelay, _ActivateMoment(sMomentName, mID, sID, GetLocalInt(oVault, sID + AI_SCHEDULE_GOOD)));

    if ((sEarlierMoment == "") || (sEarlierMoment == sMomentName))
    {
        ai_PrintString("DelayCommand(" + FloatToString(fDelay)+ ", _ActivateMoment("+sMomentName+", "+IntToString(mID)+", "+sID+", "+IntToString(GetLocalInt(oVault, sID+AI_SCHEDULE_GOOD))+")");
        DelayCommand(fDelay, _ActivateMoment(sMomentName, mID, sID, GetLocalInt(oVault, sID+AI_SCHEDULE_GOOD)));
    }

    ai_DebugEnd();
    return mID;
}

void ai_ActivateMoment(string sMomentName)
{
    ai_DebugStart("ai_ActivateMoment sMomentName='"+sMomentName+"'", AI_DEBUG_UTILITY);

    object oVault = ai_GetMemeVault();

    // If this moment is valid it'll have a registered id.
    int mID = GetLocalInt(oVault, AI_SCHEDULE_MOMENT_PREFIX + sMomentName);
    // So its private prefix looks like:
    string sID = AI_SCHEDULE_PREFIX + IntToString(mID);
    ai_PrintString("sID: "+sID);

    int i;
    for (i = ai_GetIntCount(oVault, sID)-1; i >= 0; i--)
    {
        ai_PrintString("i: "+IntToString(i));
        int mChild = ai_GetIntByIndex(oVault, i, sID);
        string sChild = AI_SCHEDULE_PREFIX+IntToString(mChild);
        ai_PrintString("sChild: "+sChild);

        if (GetLocalInt(oVault, sChild + AI_SCHEDULE_GOOD) == 0)
            continue;

        float fDelay = GetLocalFloat(oVault, sChild + AI_SCHEDULE_DELAY);
        int bRepeat  = GetLocalInt(oVault, sChild + AI_SCHEDULE_REPEAT);
        int nType = GetLocalInt(oVault, sChild + AI_SCHEDULE_TYPE);

        string sName;
        struct message sMsg;
        string sChannel;
        object oTarget;
        object oSender;
        object oArg;
        int nGood;

        // do what this is
        switch (nType)
        {
            case 0:
                ai_PrintString("Case: Bad Type");
                break;
            case 1:
                // Moment
                ai_PrintString("Case: Moment");
                sName = GetLocalString(oVault, sChild + AI_SCHEDULE_NAME);
                nGood = GetLocalInt(oVault, sID + AI_SCHEDULE_GOOD);
                DelayCommand(fDelay, _ActivateMoment(sName, mChild, sChild, nGood));
                break;
            case 2:
                // Message
                ai_PrintString("Case: Message");
                sMsg = ai_GetLocalMessage(oVault,  sChild + AI_SCHEDULE_MESSAGE);
                sChannel = GetLocalString(oVault, sChild + AI_SCHEDULE_CHANNEL);
                oTarget = GetLocalObject(oVault,  sChild + AI_SCHEDULE_TARGET);
                oSender = GetLocalObject(oVault,  sChild + AI_SCHEDULE_SENDER);
                DelayCommand(fDelay, ai_SendMessage(sMsg, sChannel, oTarget, oSender));
                if (GetIsObjectValid(oTarget))
                    DelayCommand(fDelay, ai_SendMessage(sMsg, sChannel, oTarget, oSender));
                else
                    DelayCommand(fDelay, ai_BroadcastMessage(sMsg, sChannel));
                break;
            case 3:
                // Function
                ai_PrintString("Case: Function");
                oTarget = GetLocalObject(oVault, sID + AI_SCHEDULE_TARGET);
                oArg = GetLocalObject(oVault,    sID + AI_SCHEDULE_ARGUMENT);
                sName = GetLocalString(oVault,   sID + AI_SCHEDULE_NAME);
                DelayCommand(fDelay, _CallFunction(sName, oArg, oTarget));
                break;
            case 4:
                // Script
                sName = GetLocalString(oVault,   sID + AI_SCHEDULE_NAME);
                oTarget = GetLocalObject(oVault, sChild + AI_SCHEDULE_TARGET);
                DelayCommand(fDelay, ExecuteScript(sName,oTarget));
                break;
        }

        // if this is not a repeating event then make it invalid.
        if (!bRepeat)
        {
            ai_RemoveIntRef(oVault, i);
            // Scheduled things that are not moments and have just been activated
            // but are not marked as repeat are now destroyed. These are considered
            // transient (roughly atomic) operations.
            if (nType > 1)
            {
                ai_Unschedule(mChild);
                DeleteLocalInt(oVault, sChild + AI_SCHEDULE_GOOD);
            }
        }
    }

    ai_DebugEnd();
}

void ai_AdjustSchedule(int nScheduledThing, int nTime, int bRepeat=TRUE)
{
    object oVault = ai_GetMemeVault();
    string sID = IntToString(nScheduledThing);
    float fDelay = IntToFloat(nTime);
    if (GetLocalInt(oVault, AI_SCHEDULE_PREFIX + sID + AI_SCHEDULE_GOOD))
    {
        SetLocalFloat(oVault, AI_SCHEDULE_PREFIX + sID + AI_SCHEDULE_DELAY, fDelay);
        SetLocalInt(oVault, AI_SCHEDULE_PREFIX + sID + AI_SCHEDULE_REPEAT, bRepeat);
    }
}

int ai_ScheduleMessage(struct message sData, object oTarget, string sChannel = "", int nTime=0, string sMoment="", int bRepeat=FALSE)
{
    ai_DebugStart("ai_ScheduleMessage sMomentName='" + sData.sMessageName + "'");

    if (nTime == 0 && sMoment == "" && bRepeat == TRUE)
        bRepeat = FALSE;

    object oVault = ai_GetMemeVault();
    float fDelay = IntToFloat(nTime);

    // Get the id if the scheduled thing
    int pID;
    int mID = GetLocalInt(oVault, AI_SCHEDULE_COUNT)+1;
    SetLocalInt(oVault, AI_SCHEDULE_COUNT, mID);
    string sID = AI_SCHEDULE_PREFIX+IntToString(mID);

    SetLocalInt(oVault,       sID + AI_SCHEDULE_TYPE, 2); // Type 2 is ai_SendMessage
    SetLocalInt(oVault,       sID + AI_SCHEDULE_GOOD, 1);
    SetLocalInt(oVault,       sID + AI_SCHEDULE_REPEAT, bRepeat);
    SetLocalObject(oVault,    sID + AI_SCHEDULE_TARGET, oTarget);
    SetLocalFloat(oVault,     sID + AI_SCHEDULE_DELAY, fDelay);
    SetLocalString(oVault,    sID + AI_SCHEDULE_CHANNEL, sChannel);
    ai_SetLocalMessage(oVault, sID + AI_SCHEDULE_MESSAGE, sData);

    if (sMoment == "")
    {
        if (GetIsObjectValid(oTarget))
        {
            ai_PrintString("ai_SendMessage");
            DelayCommand(fDelay, ai_SendMessage(sData, sChannel, oTarget, OBJECT_SELF));
        }
        else
        {
            ai_PrintString("ai_BroadcastMessage");
            DelayCommand(fDelay, ai_BroadcastMessage(sData, sChannel));
        }
    }
    // Otherwise attach this message request to the moment
    else
    {
        pID = GetLocalInt(oVault, AI_SCHEDULE_MOMENT_PREFIX+sMoment);
        if (pID)
            ai_AddIntRef(oVault, mID, AI_SCHEDULE_PREFIX+IntToString(pID));
    }

    ai_DebugEnd();
    return mID;
}

int ai_ScheduleFunction(object oTarget, string sFunction, object oArgument=OBJECT_INVALID, int nTime=0, string sMoment="", int bRepeat=FALSE)
{
    if (nTime == 0 && sMoment == "" && bRepeat == TRUE)
        bRepeat = FALSE;

    object oVault = ai_GetMemeVault();
    float fDelay = IntToFloat(nTime);

    // Get the id if the scheduled thing
    int pID;
    int mID = GetLocalInt(oVault, AI_SCHEDULE_COUNT)+1;
    SetLocalInt(oVault, AI_SCHEDULE_COUNT, mID);
    string sID = AI_SCHEDULE_PREFIX+IntToString(mID);

    SetLocalInt(oVault,       sID + AI_SCHEDULE_TYPE,   3); // Type 3 is ai_CallFunction
    SetLocalInt(oVault,       sID + AI_SCHEDULE_GOOD, 1);
    SetLocalInt(oVault,       sID + AI_SCHEDULE_REPEAT, bRepeat);
    SetLocalObject(oVault,    sID + AI_SCHEDULE_TARGET, oTarget);
    SetLocalObject(oVault,    sID + AI_SCHEDULE_ARGUMENT,    oArgument);
    SetLocalString(oVault,    sID + AI_SCHEDULE_NAME,   sFunction);
    SetLocalFloat(oVault,     sID + AI_SCHEDULE_DELAY,  fDelay);

    if (sMoment == "")
        DelayCommand(fDelay, _CallFunction(sFunction, oArgument, oTarget));
    // Otherwise attach this message request to the moment
    else
    {
        pID = GetLocalInt(oVault, AI_SCHEDULE_MOMENT_PREFIX+sMoment);
        if (pID)
            ai_AddIntRef(oVault, mID, AI_SCHEDULE_PREFIX+IntToString(pID));
    }
    return mID;
}

int ai_ScheduleScript(object oTarget, string sScript, int nTime=0, string sMoment="", int bRepeat=FALSE)
{
    if (nTime == 0 && sMoment == "" && bRepeat == TRUE)
        bRepeat = FALSE;

    object oVault = ai_GetMemeVault();
    float fDelay = IntToFloat(nTime);

    // Get the id if the scheduled thing.
    int mID = GetLocalInt(oVault, AI_SCHEDULE_COUNT)+1;
    SetLocalInt(oVault, AI_SCHEDULE_COUNT, mID);
    string sID = AI_SCHEDULE_PREFIX+IntToString(mID);

    SetLocalInt(oVault,    sID + AI_SCHEDULE_TYPE, 4); // Type 4 is ExecuteScript
    SetLocalInt(oVault,    sID + AI_SCHEDULE_GOOD, 1);
    SetLocalInt(oVault,    sID + AI_SCHEDULE_REPEAT, bRepeat);
    SetLocalObject(oVault, sID + AI_SCHEDULE_TARGET, oTarget);
    SetLocalString(oVault, sID + AI_SCHEDULE_NAME, sScript);
    SetLocalFloat(oVault,  sID + AI_SCHEDULE_DELAY, fDelay);
    SetLocalString(oVault, sID + AI_SCHEDULE_RELATIVE_MOMENT, sMoment);

    // Add this moment to the list of triggered relative things.
    string sEarlierMoment = GetLocalString(oVault, sID + AI_SCHEDULE_RELATIVE_MOMENT);
    int pID = GetLocalInt(oVault, AI_SCHEDULE_MOMENT_PREFIX+sEarlierMoment);
    if (pID)
        ai_AddIntRef(oVault, mID, AI_SCHEDULE_PREFIX+IntToString(pID));

    if (sEarlierMoment == "")
        DelayCommand(fDelay, ExecuteScript(sScript,oTarget));
    return mID;
}

void ai_Unschedule(int nScheduledThing)
{
    object oVault = ai_GetMemeVault();
    string sID = AI_SCHEDULE_PREFIX+IntToString(nScheduledThing);

    // Increment the good count to prevent the execution of previously scheduled
    // moments, which are going to happen because of a call to DelayCommand().
    // Since we cannot cancel calls to DelayCommand() we create an incrementing
    // serial lock. This limits us to, like, four billion cancelled calls to a
    // given moment.
    SetLocalInt(oVault, sID + AI_SCHEDULE_GOOD, GetLocalInt(oVault, sID + AI_SCHEDULE_GOOD)+1);

    DeleteLocalInt(oVault,    sID + AI_SCHEDULE_TYPE);
    DeleteLocalInt(oVault,    sID + AI_SCHEDULE_REPEAT);
    DeleteLocalObject(oVault, sID + AI_SCHEDULE_TARGET);
    DeleteLocalObject(oVault, sID + AI_SCHEDULE_ARGUMENT);
    DeleteLocalString(oVault, sID + AI_SCHEDULE_NAME);
    DeleteLocalFloat(oVault,  sID + AI_SCHEDULE_DELAY);
    DeleteLocalString(oVault, sID + AI_SCHEDULE_RELATIVE_MOMENT);
    ai_DeleteLocalMessage(oVault, sID + AI_SCHEDULE_MESSAGE);
}

void ai_ClearScheduledMoments(int nMomentID)
{
    object oVault = ai_GetMemeVault();
    string sID = AI_SCHEDULE_PREFIX+IntToString(nMomentID);
    SetLocalInt(oVault, sID + AI_SCHEDULE_GOOD, GetLocalInt(oVault, sID + AI_SCHEDULE_GOOD)+1);
}

// void main() {}
