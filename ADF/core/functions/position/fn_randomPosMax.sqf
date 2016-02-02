/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_randomPosMax
Author: Whiztler
Script version: 1.01

File: fn_randomPosMax.sqf
**********************************************************************************
Returns a random position on the far end of the radius.

INSTRUCTIONS:
Call from script on the server

REQUIRED PARAMETERS:
0. Position - marker / object / vehicle / group (center position).
1. Number - radius in meters.

OPTIONAL PARAMETERS:
2. Number - direction (0-360). Default is random 360

EXAMPLE:
_maxPos = ["myMarker", 500, random 360] call ADF_fnc_randomPosMax;

RETURNS:
Array (position [x,y,z])
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_randomPosMax");

// Init
params ["_p", ["_r", 0, [0]], ["_a", -1, [0]]];

ADF__CHKPOSA(_p);
private _d = if (_a == -1) then {random 360} else {_a};

// Create random position from centre & radius
private _pX = (_p select 0) + (_r * sin _d);
private _pY = (_p select 1) + (_r * cos _d);

if (ADF_debug) then {
	diag_log format ["ADF Debug: ADF_fnc_randomPos - Position: [%1,%2, 0]", _pX, _pY];
	private _m = createMarker [format ["m_%1%2", round _pX, round _pY], [_pX, _pY, 0]];
	_m setMarkerSize [.7, .7];
	_m setMarkerShape "ICON";
	_m setMarkerType "hd_dot";
	_m setMarkerColor "ColorGreen";
};

// Return position
[_pX, _pY, 0]
