/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_positionArraySort
Author: Ruebe. Adapted for ADF by whiztler
Script version: 1.01

File: fn_positionArraySort.sqf
**********************************************************************************
sorts an array of positions (z-axe, altitude).

INSTRUCTIONS:
Call from script on the server

REQUIRED PARAMETERS:
0: Array - array of positions
1: String - Sort function:
		- "_altitudeDescending" for decending 
		- "_altitudeAcending" for acending

OPTIONAL PARAMETERS:
N/a

EXAMPLE:
_sortedArray = [myArray, "_altitudeDescending"] call ADF_fnc_positionArraySort;	

RETURNS:
Sorted Array
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_position.sqf");

// Init
ADF__P2(_a,_f);
ADF__PI;

if ((count _a) == 0) exitWith {if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_positionArraySort - array seems to be empty: %1", _a]}};

_altitudeDescending = {
	private _r = -1 * (_this select 2);
	_r
};

_altitudeAcending = {
	private _r = (_this select 2);
	_r
};

for "_i" from 1 to ((count _a) - 1) do {
	private _k = _a select _i;
	private _j = 0;

	for [{_j = _i}, {_j > 0}, {_j = _j - 1}] do {
		if (((_a select (_j - 1)) call _f) < (_k call _f)) exitWith {};
		_a set [_j, (_a select (_j - 1))];
	};

	_a set [_j, _k];
};

_a


