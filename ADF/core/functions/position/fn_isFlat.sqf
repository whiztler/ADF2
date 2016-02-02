/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_isFlat
Author: Whiztler
Script version: 1.01

File: fn_isFlat.sqf
**********************************************************************************
Checks if a passed position is on flat ground.
Info: https://en.wikipedia.org/wiki/Normal_(geometry)

INSTRUCTIONS:
Call from script on the server

REQUIRED PARAMETERS:
0. Position - marker / object / vehicle / group

OPTIONAL PARAMETERS:
n/a

EXAMPLE
_isFlat = ["myMarker"] call ADF_fnc_isFlat;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_isFlat");

// init
ADF__P1(_p);

ADF__CHKPOSA(_p);	
private _s	= surfaceNormal _p;
private _r	= if (((_s select 2) * 1000) > 995) then {true} else {false};
ADF__DBGVAR1("ADF Debug: ADF_fnc_isFlat - Flat Position Z-axe: %1", _s select 2);

_r
