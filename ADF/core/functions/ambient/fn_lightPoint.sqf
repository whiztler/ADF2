/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_lightPoint
Author: Whiztler
Script version: 1.01

File: fn_lightPoint.sqf
**********************************************************************************
Creates a single lightpoint to light up objects (inside/outside).

INSTRUCTIONS:
Place an object or game logic on the map and put the following in the init:
0 = [this, 0.2, 1] call ADF_fnc_lightPoint;

REQUIRED PARAMETERS:
0. Object - the object that requires the light source
1. Number - Light brightness. 0.2 for dim light and 1.0 for very bright light 
2. Number - Altitude light position offset from the object (in meters)

OPTIONAL PARAMETERS:
3. Number - X-axe offset (meters) (default: 0)
4. Number - Y-axe offset (meters) (default: 0)

RETURNS:
Object (light source)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_lightPoint");

// Init
params [["_o", objNull, [objNull]], ["_h", 0.2, [0]], ["_a", 0, [0]], ["_px", 0, [0]], ["_py", 0, [0]]];
private _z = [_px, _py, _a];

private _l = "#lightpoint" createVehicleLocal (getPosASL _o);
_l setLightBrightness _h;
_l setLightAmbient [1.0, 1.0, 0.5];
_l setLightColor [1.0, 1.0, 1.0];
_l setLightUseFlare true;
_l lightAttachObject [_o, _z]; // attach the light to the object
if (px == 0 && py == 0) then {_l setPos [getPos _l select 0, getPos _l select 1, _a]};

_l