/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_getRelPos
Author: Whiztler
Script version: 1.01

File: fn_getRelPos.sqf
**********************************************************************************
Returns a relative position. 

INSTRUCTIONS:
n/a

REQUIRED PARAMETERS:
0. Position - marker / object / vehicle / group
1. Number - distance in meters

OPTIONAL PARAMETERS:
2. Number - Azimuth (0-360)
3. Number - Z-axe, altitude offset

EXAMPLE:
_rePos = [unit, 10, 45, 0] call ADF_fnc_getRelPos;	

RETURNS:
Array (position x,y,z)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_getRelPos");

// init
params ["_p", ["_d", 15, [0]], ["_r", 0, [0]], ["_z",-1, [0]]];

private _a = [(_p select 0) + sin _d * _r, (_p select 1) + cos _d * _r, _z];
ADF__DBGVAR2("ADF Debug: ADF_fnc_getRelPos - Position: [%1,%2, 0]",, _pX, _pY);

_a