/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_outsidePos
Author: Whiztler
Script version: 1.01

File: fn_outsidePos.sqf
**********************************************************************************
Checks if a given position is outside by checking the z-axe for a 25 meter
visibility. If inside the roof will break visibility and the function will return
true.

INSTRUCTIONS:
Call from script on the server

REQUIRED PARAMETERS:
0: position - marker, object/unit, array [x,y,z]

OPTIONAL PARAMETERS:
n/a

EXAMPLE
_outside = [myObject] call ADF_fnc_outsidePos;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_outsidePos");

// Init
ADF__P1(_p);
ADF__CHKPOSA(_p);

private _r = lineIntersects [ATLToASL [_p select 0, _p select 1, 1], ATLToASL [_p select 0, _p select 1, 25]];
ADF__DBGVAR1("ADF Debug: ADF_fnc_outsidePos - Position inside: %1", _r);

_r
