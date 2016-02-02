/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_logGroup
Author: Whiztler
Script version: 1.01

File: fn_logGroup.sqf
**********************************************************************************
The spawnGroup funtion is a relay function. The meta relay is to store groups
into a list (array). The array can be used to track/manipulate groups.

INSTRUCTIONS:
Call the function after each created group (e.g. with BIS_fnc_spawnGroup).
Run the function on mission start to initialize and add editor place groups to the
arrays. The following arrays will be created:

- ADF_groupsWest
- ADF_groupsEast
- ADF_groupsIndep

the function does not track civilian groups

REQUIRED PARAMETERS:
0. Group

OPTIONAL PARAMETERS:
n/a

EXAMPLE
[_grp] call ADF_fnc_logGroup;

RETURNS:
Bool(success Flag)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_logGroup");

// Init
params [["_g", grpNull, [grpNull]]];
if (_g == grpNull) exitWith {ADF__LOGERR("ADF ERROR: ADF_fnc_logGroup - Group does not exist."); false};

// First run initialization
if (isNil "ADF_groupsInit") exitWith {
	ADF_groupsInit	= true;
	ADF_groupsWest	= [];
	ADF_groupsEast	= [];
	ADF_groupsIndep	= [];
	
	{
		if (side _x == west) then {ADF_groupsWest pushBackUnique _x};
		if (side _x == east) then {ADF_groupsEast pushBackUnique _x};
		if (side _x == independent) then {ADF_groupsIndep pushBackUnique _x};		
		if (side _x == civilian) then {};		
	} forEach allGroups;
	
	// Loop through all groups every 5 seconds to check for empty groups
	[] spawn {
		waitUntil {
			{
				if (count (units _x) == 0) then {
					switch (side _x) do {
						case west		: {ADF_groupsWest = ADF_groupsWest - [_x];};
						case east		: {ADF_groupsEast = ADF_groupsEast - [_x]};
						case independent	: {ADF_groupsIndep = ADF_groupsIndep - [_x]};
						default			: {};
					};
				};
			} forEach allGroups;
			sleep 5;
			false
		};
	};
};

switch (side _g) do {
	case west		: {ADF_groupsWest pushBackUnique _g};
	case east		: {ADF_groupsEast pushBackUnique _g};
	case independent	: {ADF_groupsIndep pushBackUnique _g};
};

true


