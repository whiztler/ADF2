/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_outsidePosUnit
Author: Whiztler
Script version: 1.01

File: fn_outsidePosUnit.sqf
**********************************************************************************
Checks if a unit is outside by checking the z-axe for a 25 meter visibility.
If inside the roof will break visibility and the function will return
true.

INSTRUCTIONS:
Call from script on the server

REQUIRED PARAMETERS:
0: AI unit or player

OPTIONAL PARAMETERS:
n/a

EXAMPLE
_outside = [player] call ADF_fnc_outsidePosUnit;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_outsidePosUnit");

// Init
ADF__P1(_u);

private _r = lineIntersects [eyePos _u, (eyePos _u) vectorAdd [0, 0, 25]];
ADF__DBGVAR1("ADF Debug: ADF_fnc_outsidePosUnitUnit - Position inside: %1", _r);

_r
