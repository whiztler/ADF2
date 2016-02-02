/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_countGroups
Author: Whiztler
Script version: 1.01

File: fn_countGroups.sqf
**********************************************************************************
Counts groups per side as stored in the ADF_groupsXXX array.

INSTRUCTIONS:
Call from script on the server
The function does count civilian groups

REQUIRED PARAMETERS:
0. Side - west, east, independent

OPTIONAL PARAMETERS:
n/a

EXAMPLE
[west] call ADF_fnc_countGroups;

RETURNS:
Number (group count)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_countGroups");

// Init
params [["_s", [west, east, independent], [east]]];
if (isNil "ADF_groupsWest") exitWith {ADF__LOGERR("ADF ERROR: ADF_fnc_countGroups - array does not exist. Execute fn_logGroup first. "); 0};

private _c = switch _s do {
	case west		: {count ADF_groupsWest};
	case east		: {count ADF_groupsEast};
	case independent	: {count ADF_groupsIndep};
};

_c


