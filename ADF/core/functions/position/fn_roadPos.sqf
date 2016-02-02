/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_roadPos
Author: Whiztler
Script version: 1.01

File: fn_roadPos.sqf
**********************************************************************************
Searches for road positions with in a given radius. Returns a position on a road
if succesful.

INSTRUCTIONS:
Call from script on the server
The function does count civilian groups

REQUIRED PARAMETERS:
0. Position - marker / object / vehicle / group (center position).
1. Number - radius in meters.

OPTIONAL PARAMETERS:
n/a

EXAMPLE:
_roadPos = ["myMarker", 500] call ADF_fnc_roadPos;	

RETURNS:
Array (position x,y,z)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_roadPos");

// Init
params ["_p", ["_r", 0, [0]]];

ADF__CHKPOSA(_p);

// Check nearby raods from passed position
private _rd		= _p nearRoads _r;
private _c		= count _rd;
private _return	= [];

// if road position found, use it else use original position
if (_c > 0) then {_return = getPos (_rd select 0);} else {_return = _p};
if (ADF_debug) then {
	diag_log format ["ADF Debug: ADF_fnc_roadPos - Position: %1", _return];
	private _m = createMarker [format ["m_%1%2", round (_return select 0), round (_return select 1)], _return];
	_m setMarkerSize [.7, .7];
	_m setMarkerShape "ICON";
	_m setMarkerType "hd_dot";
	_m setMarkerColor "ColorYellow";	
};

// return the position
_return
