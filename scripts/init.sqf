/********************************************************************************
ADF - ARMA Mission Development Framework

User/custom mssion scrtips

--1--  CODE / SCRIPTS THAT NEEDS TO RUN ON ONLY PLAYERS
Here you'll place the code/scripts that need to run on local players. Such as
loadout scripts, insignia, etc.

--2--  CODE / SCRIPTS THAT NEEDS TO RUN ON THE (DEDICATED) SERVER
Here you'll place the code/scripts that need to be executed only by the server.
Such as spawning AI's/vehicles/objects. 

--3--  CODE / SCRIPTS THAT NEEDS TO RUN ON THE HEADLESS CLIENT
If your server has an headless client than you can place code/scripts
such as spawning units/vehicles/etc in this section.

--4--  CODE / SCRIPTS THAT NEEDS TO RUN ON THE SERVER -OR- HEADLESS
       CLIENT (auto detect)
The ADF framework auto detects the presence of a headless client. When using
if (ADF_HC_execute) the mission will execute the code/scripts on the headless
client (when active) or the server (when no headless client is active).

--5--  CODE / SCRIPTS THAT NEEDS TO RUN ON ALL CLIENTS
Some code/scripts need to be executed on the server AND on player/headless 
clients. Put code/scripts thsat needs to tun on all connected entities here.

************************************************************************************************/

#include "..\ADF\ADF_macros.hpp"
#include "ADF_missionMacros.hpp"

//###########################################################################
//  --1--  CODE / SCRIPTS THAT NEEDS TO RUN ON ONLY PLAYERS
//###########################################################################

if (hasInterface) then {
	// insert code/script here
};


//###########################################################################
//  --2--  CODE / SCRIPTS THAT NEEDS TO RUN ON THE (DEDICATED) SERVER
//###########################################################################

if (isServer) then {
	// insert code/script here
};


//###########################################################################
//  --3--  CODE / SCRIPTS THAT NEEDS TO RUN ON THE HEADLESS CLIENT(S)
//###########################################################################

if (ADF_isHC) then {
	// insert code/script here
};


//###########################################################################
//  --4--  CODE / SCRIPTS THAT NEEDS TO RUN ON THE SERVER -OR- HEADLESS
//         CLIENT(S) (auto detect)
//###########################################################################

if (ADF_HC_execute) then {
	// insert code/script here
};


//###########################################################################
// --5--  CODE / SCRIPTS THAT NEEDS TO RUN ON ALL CLIENTS
//###########################################################################

// insert code/script here
