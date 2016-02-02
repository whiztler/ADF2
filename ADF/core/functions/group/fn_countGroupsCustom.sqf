/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_countGroupsCustom
Author: Whiztler
Script version: 1.01

File: fn_countGroupsCustom.sqf
**********************************************************************************
Counts groups per side as stored in a previously defined array of your choice. 

INSTRUCTIONS:
Call from script on the server
The function does count civilian groups

REQUIRED PARAMETERS:
1. String - Existing array. E.g. "AO_Kavala"
0. Side - west, east, independent

OPTIONAL PARAMETERS:
n/a

EXAMPLE
["AO_Kavala", west] call ADF_fnc_countGroupsCustom;

RETURNS:
Number (group count)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_countGroupsCustom");

// Init
params [["_a", "", [""]], ["_s", [west, east, independent], [east]]];
if (_a == "" || isNil _a) exitWith {ADF__LOGERR("ADF ERROR: ADF_fnc_countGroups - array does not exist. Execute ADF_fnc_logGroupCustom first. "); 0};

ADF__CCFVAR(_n,_a);
private _c = switch _s do {
	case west		: {count _n};
	case east		: {count _n};
	case independent	: {count _n};
};

_c


