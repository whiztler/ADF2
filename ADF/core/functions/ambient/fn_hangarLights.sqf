/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_hangarLights
Author: Whiztler
Script version: 1.01

File: fn_hangarLights.sqf
**********************************************************************************
This function creates 3 lights inside a ARMA3 tented aircraft Hangar.

INSTRUCTIONS:
Place a Tent Hangar ("Land_TentHangar_V1_F") on the map and put the following in
the init:
[this] call ADF_fnc_hangarLights;

REQUIRED PARAMETERS:
0. Object (Tent Hangar)

OPTIONAL PARAMETERS:
n/a

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_hangarLights");

// Init
ADF__P1(_o);
ADF__PI;
diag_log str _o;
private _p = getPosASL _o;
private _z = 0;

for "_i" from 1 to 3 do {
	switch _i do {
		case 1: {_z = 0};
		case 2: {_z = 5};
		case 3: {_z = -5};
	};
	
	private _f = "Land_floodLight_F" createVehicle _p;
	_f attachTo [_o, [0, _z, 4.4]];
	_f setVectorDirAndUp [[-1,0,0],[0,1,0]];
	private _y = getPosASL _f;
	
	private _s = createVehicle ["#lightpoint", _y, [], 0, "CAN_COLLIDE"];
	_s setLightBrightness 0.9;
	_s setLightAmbient [1.0, 1.0, 0.5];
	_s setLightColor [1.0, 1.0, 1.0];
	_s setLightUseFlare true;;
	_s setPosASL [_y select 0, _y select 1, (_y select 2) - 0.3];
};

true