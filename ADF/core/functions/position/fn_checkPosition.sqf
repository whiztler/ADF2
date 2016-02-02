/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_checkPosition
Author: Whiztler
Script version: 1.03

File: fn_checkPosition.sqf
**********************************************************************************
Checks the position of an object, unit, vehicle, marker, group and returns the
position as an array [X, Y, Z].

INSTRUCTIONS:
n/a

REQUIRED PARAMETERS:
0. Position - marker / object / vehicle / group / array [X, Y, Z]

OPTIONAL PARAMETERS:
n/a

EXAMPLE
_position = [group player] call ADF_fnc_checkPosition;

RETURNS:
Array (position x,y,z)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_checkPosition");

// init
ADF__P1(_p);
private ["_r"];

ADF__DBGVAR1("ADF Debug: ADF_fnc_checkPosition - pre-check position: %1",_p);
if (typeName _p == "STRING")	then {_r = getMarkerPos _p};		// Marker			
if (typeName _p == "OBJECT")	then {_r = getPosATL _p};			// object / vehicle / etc/
if (typeName _p == "ARRAY")	then {_r = _p};					// Position array
if (typeName _p == "GROUP")	then {_r = getPosATL (leader _p)};	// group - returns the position of the current group leader
if (_r isEqualTo [0,0,0]) exitWith {ADF__DBGLOGERR("ADF_fnc_checkPosition: position passed is [0,0,0] (lower edge of tha map)"); _r};

// Return the checked position: array [X, Y, Z]
_r


