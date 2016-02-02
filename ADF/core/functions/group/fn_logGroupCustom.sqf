/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_logGroupCustom
Author: Whiztler
Script version: 1.01

File: fn_logGroupCustom.sqf
**********************************************************************************
Function to log groups into an array of your choice.

INSTRUCTIONS:
Call the function after each created group (e.g. with BIS_fnc_spawnGroup).
Run the function on mission start to initialize and add editor place groups to the
arrays. 
the function does not track civilian groups

REQUIRED PARAMETERS:
0. Group
1. String - Name of the array. E.g. "AO_Kavala_east"

OPTIONAL PARAMETERS:
n/a

EXAMPLE
[_grp, "AO_Kavala_east"] call ADF_fnc_logGroupCustom;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_logGroupCustom");

// Init
params [["_g", grpNull, [grpNull]], ["_a", "dummyArrForCheck", [""]]];
if (_a isEqualTo "dummyArrForCheck") exitWith {ADF__LOGERR("ADF ERROR: ADF_fnc_logGroupCustom - No valid array provided."); 0};
ADF__CCFVAR(_n,_a);

// First run initialization
if (isNil "ADF_groupsInitCustom") exitWith {
	ADF_groupsInitCustom	= true;
	_n = [];
	
	// Loop through all groups every 5 seconds to check for empty groups
	[_n] spawn {
		params ["_n"];
				
		waitUntil {
			{
				if (_x in _n) then {
					if (count (units _x) == 0 || _x == grpNull) then {_n = _n - [_x]};
				};
			} forEach allGroups;			
			sleep 5;
			false
		};
	};
	
	true
};

switch (side _g) do {
	case west		: {ADF_groupsWest pushBackUnique _g};
	case east		: {ADF_groupsEast pushBackUnique _g};
	case independent	: {ADF_groupsIndep pushBackUnique _g};
	default {};
};

true
