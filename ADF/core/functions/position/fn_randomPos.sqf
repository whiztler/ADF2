/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_randomPos
Author: Whiztler
Script version: 1.01

File: fn_randomPos.sqf
**********************************************************************************
Returns a random position within a given radius

INSTRUCTIONS:
Call from script on the server

REQUIRED PARAMETERS:
0. Position - marker / object / vehicle / group (center position).
1. Number - radius in meters.

OPTIONAL PARAMETERS:
n/a

EXAMPLE:
_randomPos = ["myMarker", 500, random 360] call ADF_fnc_randomPos;

RETURNS:
Array (position x,y,z)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_randomPos");

// Init
params ["_p", ["_r", 0, [0]]];

ADF__CHKPOSA(_p);	

// Create random position from centre & radius
private _pX = (_p select 0) + (_r - (random (1.5 *_r)));
private _pY = (_p select 1) + (_r - (random (1.5 *_r)));

if (ADF_debug) then {
	diag_log format ["ADF Debug: ADF_fnc_randomPos - Position: [%1,%2, 0]", _pX, _pY];
	private _m = createMarker [format ["m_%1%2", round _pX, round _pY], [_pX, _pY, 0]];
	_m setMarkerSize [.7, .7];
	_m setMarkerShape "ICON";
	_m setMarkerType "hd_dot";
	_m setMarkerColor "ColorYellow";
};

// Return position
[_pX, _pY, 0]
