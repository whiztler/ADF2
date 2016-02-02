/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_countUnits
Author: Whiztler
Script version: 1.01

File: fn_countUnits.sqf
**********************************************************************************
Counts units per side as stored in the ADF_groupsXXX array.

INSTRUCTIONS:
Call from script on the server
The function does count civilian units

REQUIRED PARAMETERS:
0. Side - west, east, independent

OPTIONAL PARAMETERS:
n/a

EXAMPLE
[west] call ADF_fnc_countUnits;

RETURNS:
Number (unit count)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_countUnits");

// Init
params [["_s", [west, east, independent], [east]]];
if (isNil "ADF_groupsWest") exitWith {ADF__LOGERR("ADF ERROR: ADF_fnc_countUnits - array does not exist. Execute fn_logGroup.sqf first."); 0};
private _c = 0;

switch _s do {
	case west		: {{_c = _c + (count _x)} forEach ADF_groupsWest};
	case east		: {{_c = _c + (count _x)} forEach ADF_groupsEast};
	case independent	: {{_c = _c + (count _x)} forEach ADF_groupsIndep};
};

_c


