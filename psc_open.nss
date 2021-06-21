/*
Filename:           psc_open
System:             Persistent Storage Chest (hook-in script)
Author:             Sherincall
Date Created:       Nov. 4th, 2008
Summary:
OnOpen script for Persistent Storage Chest (PSC) system.
Initializes the chest if it is opened for the first time this reboot.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:
*/

#include "psc_i_main"


void main()
{
    object oContainer = OBJECT_SELF;

    if (!GetLocalInt(oContainer, PSC_INITIALIZED))
        psc_InitializeContainer(oContainer);
}
