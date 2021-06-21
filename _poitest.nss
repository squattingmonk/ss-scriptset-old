#include "ai_i_main"

void main()
{
    ai_DebugStart("LeverActivated");

    object   oPoI      = GetWaypointByTag("POI_ONE");
    location lLocation = GetLocation(oPoI);
    object   oLever    = OBJECT_SELF;
    object   oEmitter  = GetLocalObject(oLever, "Emitter");
    string   sName     = GetName(oLever);
    int      isOn      = GetLocalInt(oLever, "IsOn");

    // Basic lever code. I would have thought Bioware would have provided
    // some function like IsObjectActivated() and ActivateObject(). Guess not.
    if (!isOn)
    {

        PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );
        isOn = 1;
        SetLocalInt(oLever, "IsOn", isOn);
    }
    else
    {
        PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );
        isOn = 0;
        SetLocalInt(oLever, "IsOn", isOn);
    }

    ai_PrintString("Activating Lever One isOn = " + IntToString(isOn));

    // Turn it on - this is how you make an emitter.
    // Everything else is just junk to handle a switch.
    if (isOn)
    {
        ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_FNF_SUNBEAM), lLocation);

        // Step 1: Just emit an enter and exit notification.
        // ai_DefineEmitter(sName, sTestFunction, sActivationFunction, sExitFunction, sResRef, sEnterText = "", string sExitText = "", int nFlags = 0x08 /* POI_EMIT_TO_PC */, float fDistance = 10.0, int fCacheTest = 0, int fCacheNotify = 0, int iSignal = 0, string sChannel = "")
        ai_DefineEmitter("Chill", "", "", "", "", "You feel a chill - all the hairs raise up on your neck.", "You feel less disturbed.", POI_EMIT_TO_PC, POI_SMALL);

        // Step 2: Add the emitter at the location
        oEmitter = ai_AddEmitterToLocation(lLocation, "Chill");

        // Just store the emitter so we can remove it later.
        SetLocalObject(oLever, "Emitter", oEmitter);
    }
    // Turn it off.
    else
    {
        ai_PrintString("Removing emitter");
        ai_PrintString("Emitter tag is +"+GetTag(oEmitter));
        ai_RemoveEmitter(oEmitter, "Chill");
    }

    ai_DebugEnd("LeverActivated");
}

