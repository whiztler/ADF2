/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_countUnitsCustom
Author: Whiztler
Script version: 1.01

File: fn_countUnitsCustom.sqf
**********************************************************************************
Counts units per side as stored in a predefined array of your choice.

INSTRUCTIONS:
Call from script on the server
The function does count civilian units

REQUIRED PARAMETERS:
1. String - Existing array. E.g. "AO_Kavala"
1. Side - west, east, independent

OPTIONAL PARAMETERS:
n/a

EXAMPLE
["AO_Kavala", west] call ADF_fnc_countUnitsCustom;

RETURNS:
Number (unit count)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_countUnitsCustom");

// Init
params [["_a", "dummyArrForCheck", [""]], ["_s", [west, east, independent], [east]]];
if (_a isEqualTo "dummyArrForCheck") exitWith {ADF__LOGERR("ADF ERROR: ADF_fnc_countUnitsCustom - array does not exist. Execute ADF_fnc_logGroupCustom first."); 0};
private _c = 0;
ADF__CCFVAR(_n,_a);

switch _s do {
	case west		: {{_c = _c + (count _x)} forEach _n};
	case east		: {{_c = _c + (count _x)} forEach _n};
	case independent	: {{_c = _c + (count _x)} forEach _n};
};

_c


