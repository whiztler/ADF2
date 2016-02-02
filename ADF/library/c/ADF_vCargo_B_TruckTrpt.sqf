/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Vehicle Cargo Script (BLUEFOR) (BLUEFOR) - Transport Truck
Author: Whiztler
Script version: 2.0

Game type: n/a
File: ADF_vCargo_B_TruckTrpt.sqf
**********************************************************************************
INSTRUCTIONS::

Paste below line in the INITIALIZATION box of the vehicle:
null = [this] execVM "Core\C\ADF_vCargo_B_TruckTrpt.sqf";

You can comment out (//) lines of ammo you do not want to include
in the vehicle Cargo. 
*********************************************************************************/

// Init
if (!isServer) exitWith {};
params ["_v"];

waitUntil {time > 0};

// Settings 
[_v] call ADF_fnc_stripVehicle;

// Primary weapon
_v addWeaponCargoGlobal ["arifle_MX_GL_F", 2]; // GL

if (ADF_mod_ACE3) then {
	_v addMagazineCargoGlobal ["ACE_30Rnd_65x39_caseless_mag_Tracer_Dim", 25];
} else {
	_v addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 25]
};

// Demo/Explosives
_v addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 5];

// GL Ammo
_v addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", 5];

// Grenades
_v addMagazineCargoGlobal ["HandGrenade", 5]; 	 
_v addMagazineCargoGlobal ["SmokeShell", 5]; 	 

// Medical Items
_v addItemCargoGlobal ["FirstAidKit", 5];

// Misc items
_v addItemCargoGlobal ["ToolKit", 2];
