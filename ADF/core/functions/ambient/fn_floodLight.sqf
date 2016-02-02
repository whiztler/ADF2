/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_floodLight
Author: Whiztler
Script version: 1.01

File: fn_ambientLight.sqf
**********************************************************************************
Creates a floodlight attached to a position or an object. Adds additional light
source to the floodlight

INSTRUCTIONS:
Place an object or game logic on the map and put the following
in the init:
0 = [this, 0.2, 1] call ADF_fnc_floodLight;

REQUIRED PARAMETERS:
0. Object - the object that the floodlight is attached to
1. Number - Light brightness. 0.2 for dim light and 1.0 for very bright light 
2. Number - Altitude light position offset from the object (in meters)

OPTIONAL PARAMETERS:
3. Number - X-axe offset (meters) (default: 0)
4. Number - Y-axe offset (meters) (default: 0)

RETURNS:
Object (floodlight object)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_floodLight");

// Init
params [["_o", objNull, [objNull]], ["_h", 0.2, [0]], ["_a", 0, [0]], ["_px", 0, [0]], ["_py", 0, [0]]];
private _z = [_px, _py, _a];

private _f = "Land_floodLight_F" createVehicleLocal (getPosASL _o);
_f attachTo [_o, [0, -0.2, _a]];
_f setVectorDirAndUp [[1, 0, 0],[0, -0.9, 0]];

private _l = "#lightpoint" createVehicleLocal (getPosASL _f);
_l setLightBrightness _b;
_l setLightAmbient [0, 0, 0];
_l setLightColor [1.0, 1.0, 1.0];
_l lightAttachObject [_f, _z];

_f