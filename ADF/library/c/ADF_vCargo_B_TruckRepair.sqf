/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Vehicle Cargo Script (BLUEFOR) (BLUEFOR) - Repair Truck
Author: Whiztler
Script version: 2.0

Game type: n/a
File: ADF_vCargo_B_TruckRepair.sqf
**********************************************************************************
INSTRUCTIONS::

Paste below line in the INITIALIZATION box of the vehicle:
null = [this] execVM "Core\C\ADF_vCargo_B_TruckRepair.sqf";

You can comment out (//) lines of ammo you do not want to include
in the vehicle Cargo. 
*********************************************************************************/

// Init
if (!isServer) exitWith {};
params ["_v"];

waitUntil {time > 0};

// Settings 
[_v] call ADF_fnc_stripVehicle;

// Magazines primary weapon
if (ADF_mod_ACE3) then {
	_v addMagazineCargoGlobal ["ACE_30Rnd_65x39_caseless_mag_Tracer_Dim", 5];	
} else {
	_v addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 5]
};

// Demo/Explosives
_v addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 1];
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_Clacker", 2];
	_v addItemCargoGlobal ["ACE_wirecutter", 2];	
};	

// Grenades
_v addMagazineCargoGlobal ["HandGrenade", 5]; 	 
_v addMagazineCargoGlobal ["SmokeShell", 5]; 	 

// ACRE / TFAR and cTAB
if (ADF_mod_ACRE) then {
	_v addItemCargoGlobal ["ACRE_PRC343", 2];
	_v addItemCargoGlobal ["ACRE_PRC148", 1];
};
if (ADF_mod_TFAR) then {
	_v addItemCargoGlobal ["tf_anprc152", 2];
	//_v addItemCargoGlobal ["tf_rt1523g", 3];
	_v addBackpackCargoGlobal ["tf_rt1523g", 1];
};
if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_v addItemCargoGlobal ["ItemRadio", 2]};
/*if (ADF_mod_CTAB) then {
	_v addItemCargoGlobal ["ItemAndroid", 1];
	_v addItemCargoGlobal ["ItemcTabHCam", 2];
};*/

// ACE3 Specific	
if (ADF_mod_ACE3) then {_v addItemCargoGlobal ["ACE_EarPlugs", 5]};
if (ADF_mod_ACE3) then {_v addItemCargoGlobal ["ace_mapTools", 2]};	
if (ADF_mod_ACE3) then {_v addItemCargoGlobal ["ACE_CableTie", 5]}; // ACE3 094

// Medical Items
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_fieldDressing", 5];	
	_v addItemCargoGlobal ["ACE_morphine", 1];
	_v addItemCargoGlobal ["ACE_epinephrine", 1];	
} else {
	_v addItemCargoGlobal ["FirstAidKit", 5];	
};

// Misc items
_v addItemCargoGlobal ["ToolKit", 25];