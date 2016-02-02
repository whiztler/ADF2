/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_setGroupID
Author: Whiztler
Script version: 1.01

File: fn_setGroupID.sqf
**********************************************************************************
INSTRUCTIONS:
Applies a custom group ID (Call sign). Call from script on the server

REQUIRED PARAMETERS:
0. Group
1. String: GroupID

OPTIONAL PARAMETERS:
n/a

EXAMPLE
[_myGroup, "SEAL-6"] call ADF_fnc_setGroupID;

RETURNS:
GroupID
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_setGroupID");
	
params [["_g", grpNull, [grpNull]], ["_c", "", [""]]];

if (count _g > 0) then {
	_g = call compile format ["%1", _g];
	_g setGroupId [format ["%1", _c]];
};

_c	


	