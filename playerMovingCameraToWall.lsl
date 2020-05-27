//All Rights Reserved Christopher Topalian Copyright 2020

CameraLookingDown()
{
    rotation sitRot = llEuler2Rot(<0, 0, 0> * DEG_TO_RAD);
    llSitTarget(<0, 0, 0.2>, sitRot);
    llSetCameraEyeOffset(<-7, 0, 0>);
    llSetCameraAtOffset(<0, 0, 1>);
}

integer on = TRUE;
vector pos;
float speed = 0.1;
key person;
key playerTexture = "84c36d64-89d8-c08a-5fbd-d4c59ae39674";

default
{
    state_entry()
    {
        llSetTexture(playerTexture, 4);
        CameraLookingDown();     
        pos = llGetPos();
        llSetText("Touch to activate ", <0,1,0>, 1);
    }

    on_rez(integer param)
    {
        llSetTexture(playerTexture, 4);
        pos = llGetPos();
    }
     
    touch_start(integer x)
    {
        llSetText(" ", <0,1,0>, 1);
        if (on == TRUE)
        {
            llRequestPermissions(llDetectedKey(0),PERMISSION_TAKE_CONTROLS);
            on = FALSE;
        }
        else if (on == FALSE)
        {
            llSetText("Touch to activate ", <0,1,0>, 1);
            llSetPos(pos);   
            llReleaseControls();
            on = TRUE;
        }
    }
    
    run_time_permissions(integer perm)
    {
        integer controls = CONTROL_FWD | CONTROL_BACK |
                CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_UP | CONTROL_DOWN; 
      
        if (perm & PERMISSION_TAKE_CONTROLS) 
        {
            llTakeControls(controls, TRUE, FALSE);
        }
    }

    control(key id, integer level, integer edge)
    {
        integer button = level;

        if (button & CONTROL_FWD)        
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POSITION, llGetLocalPos() + <0,0,speed>,  PRIM_TEXTURE, 4, playerTexture, <1,1,0>, <0,0,0>, -300 ]);
       }
       
       if (button & CONTROL_BACK)          
       {
            llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POSITION, llGetLocalPos() + <0,0,-speed>, PRIM_TEXTURE, 4, playerTexture, <1,1,0>, <0,0,0>, 300 ]);
       }
       
        if (button & CONTROL_ROT_LEFT)         
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POSITION, llGetLocalPos() + <0,speed,0>, PRIM_TEXTURE, 4, playerTexture, <1,1,0>, <0,0,0>, PI ]);
        }
        
        if (button & CONTROL_ROT_RIGHT)          
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POSITION, llGetLocalPos() + <0,-speed,0>, PRIM_TEXTURE, 4, playerTexture, <1,1,0>, <0,0,0>, 0 ]);
        }
    }
    
    changed(integer change)
    {   
        if (change & CHANGED_LINK)
        {
            person = llAvatarOnSitTarget();
            if(person != NULL_KEY)
            {
                llSetText(" ", <0,1,0>, 1);
                on = TRUE; 
                llRequestPermissions(person, PERMISSION_TAKE_CONTROLS);     
                on = FALSE;
            }  
            else if (person == NULL_KEY) 
            {
                llSetText("Touch to activate ", <0,1,0>, 1);
                on = FALSE;
                llSetPos(pos);   
                llReleaseControls();
                on = TRUE;
            }
        }
    }
}
