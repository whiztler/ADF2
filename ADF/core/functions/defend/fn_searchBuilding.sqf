/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Group functions
Author: Whiztler
Script version: 1.00

File: ADF_fnc_searchBuilding.sqf
**********************************************************************************
This function can be used for a group leader to search a building close to him.
The function is also used by ADF_fnc_foorPatrol. The group leader dearches a 
closeby building (50 meter radius). After searching the group continues with their
directives (e.g. waypoints, patrol, etc)


INSTRUCTIONS:
Example for a scripted group:
[_grp] call ADF_fnc_searchBuilding;

Example for editor placed group (leader):
[this] call ADF_fnc_searchBuilding;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_group.sqf");


ADF__P1(_a);
ADF__PI;

// init
private _g = group _a;
_g lockwp true;
private _l = leader _g;
private _p = getPosASL _l;
private _s = 60; // maximum search time in seconds
private _d = 50; // maximum distance unit to building to search

if !(local _g) exitWith {ADF__DBGVAR2("ADF Debug: ADF_fnc_searchBuilding - Group %1 -- Ownership changed. Current owner ID: %2 [EXITING]",  _g, groupOwner _g)};
ADF__DBGVAR3("ADF Debug: ADF_fnc_searchBuilding - starting. Time: %1 (search timer: %2 seconds) -- Max. search distance: %3 meters", time, _s, _d);

// Check the closest building and verify that the diatance group leader, building is less than 50 meters
private _b = nearestBuilding _p;
if ((isNil "_b") || (_b == objNull) || ((_p distance (getPosASL _b)) > _d)) exitWith {
	_g lockwp false;
	ADF__DBGVAR5("ADF Debug: ADF_fnc_searchBuilding - No results for group: %1 -- Building: %2 (distance: %4) -- Position group loader: %3", _g, _b, _p, round (_l distance _b));
};

// Get the building positions within the building
private _bp = [_b, 5] call BIS_fnc_buildingPositions;
_bc = (count _bp);
ADF__DBGVAR5("ADF Debug: ADF_fnc_searchBuilding - Group: %1 -- Building: %2 (distance: %5) -- Positions: %3 (max: %4)", _g, _b, count _bp, _bc, round (_l distance _b));

// Order the leader to search max 4 of the building positions within the building.
for "_i" from 0 to _bc do {
	private _z = time + _s;
	if !(local _g) exitWith {ADF__DBGVAR2("ADF Debug: ADF_fnc_searchBuilding - Group %1 -- Ownership changed. Current owner ID: %2 [EXITING]", _g, groupOwner _g)};
	ADF__DBGVAR2("ADF Debug: ADF_fnc_searchBuilding - Time: %1 (max time: %2)", time, _z);
	if (_i == _bc) exitWith {ADF__DBGVAR2("ADF Debug: ADF_fnc_searchBuilding - Group: %1 -- Last position reached. Position: %2", _g, _i); _g lockwp false};
	_l commandMove (_b buildingPos _i);
	ADF__DBGVAR1("ADF Debug: ADF_fnc_searchBuilding - SEARCHING Position: %1", _i);
	if (time > _z) exitWith {ADF__DBGVAR4("ADF Debug: ADF_fnc_searchBuilding - Group: %1 -- Search timer (%2 seconds) ran out: %3 seconds. Time: %4", _g, _s, time - _z, time); _g lockwp false};
	waitUntil {sleep 1; unitready _l || !(local _g) || !alive _l};
	ADF__DBGVAR2("ADF Debug: ADF_fnc_searchBuilding - Finished Searching Position: %1 -- Time: %2", _i, time);
};

true
