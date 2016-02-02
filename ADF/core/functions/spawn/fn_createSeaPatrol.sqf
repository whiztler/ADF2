/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016


Script: sea patrol script
Author: Whiztler
Script version: 1.00

Game type: N/A
File: ADF_fnc_seaPatrol.sqf
**********************************************************************************

This function creates crewed boats that go on a predefined patrol.

INSTRUCTIONS:

[
	Spawn position,		// E.g. getMarkerPos "Spawn" -or- Position Player
	Patrol position,		// E.g. getMarkerPos "Patrol" -or- Position Player
	side,				// west, east or independent
	Vessel,				// 1 - speedboat minigun
						// 2 - assault boat (RHIB)
	Gunners,				// TRUE - driver + gunners
						// FALSE  driver only
	radius,				// Number - Radius from the start position in which a waypoint is created
	waypoints,			// Number - Number of waypoint for the patrol
	waypoint type,			// String. Info: https://community.bistudio.com/wiki/Waypoint_types
	behaviour,			// String. Info: https://community.bistudio.com/wiki/setWaypointBehaviour
	combat mode,			// String. Info: https://community.bistudio.com/wiki/setWaypointCombatMode
	speed,				// String. Info: https://community.bistudio.com/wiki/waypointSpeed
	formation,			// String. Info: https://community.bistudio.com/wiki/waypointFormation
	completion radius		// Number. Info: https://community.bistudio.com/wiki/setWaypointCompletionRadius
] call ADF_fnc_createSeaPatrol;

Example for scripted groups:
[_spawnPos, PatrolPos, west, 1, FALSE, 300, 5, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5] call ADF_fnc_createSeaPatrol;
[getMarkerPos "myMarker", getMarkerPos "PatrolMarker", east, 2, FALSE, 500, 6, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5] call ADF_fnc_createSeaPatrol;

RETURNS:
Object
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_createSeaPatrol.sqf");

// Init
ADF__diagInit;
params [
	"_ps",
	"_pp",
	["_gs", [west, east, independent], [west]],
	["_gc", 1,[0]],
	["_gt", true, [true]],
	["_r", 1000,[0]],
	["_c", 4,[0]],
	["_t", ["MOVE", "DESTROY", "GETIN", "SAD", "JOIN", "LEADER", "GETOUT", "CYCLE", "LOAD", "UNLOAD", "TR UNLOAD", "HOLD", "SENTRY", "GUARD", "TALK", "SCRIPTED", "SUPPORT", "GETIN NEAREST", "DISMISS", "LOITER"], [""]],
	["_b", ["UNCHANGED", "CARELESS", "SAFE", "AWARE", "COMBAT", "STEALTH"], [""]],
	["_m", ["NO CHANGE", "BLUE", "GREEN", "WHITE", "YELLOW", "RED"], [""]],
	["_s", ["UNCHANGED", "LIMITED", "NORMAL", "FULL"], [""]],
	["_f", ["NO CHANGE", "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"], [""]],
	["_cr", 5,[0]]
];
private _vc	= "";
private _cc	= "";
if (_gc == 2) then {_gt = false};

ADF__CHKPOSA(_ps);
ADF__CHKPOSA(_pp);

if (_gs == west) then {
	if (_gc == 1) then {_vc = "B_Boat_Armed_01_minigun_F"} else {_vc = "B_Boat_Transport_01_F";};
	_cc = "B_Soldier_F";
};
if (_gs == east) then {
	if (_gc == 1) then {_vc = "O_Boat_Armed_01_hmg_F"} else {_vc = "O_Boat_Transport_01_F";};
	_cc = "O_Soldier_F";
};
if (_gs == independent) then {
	if (_gc == 1) then {_vc = "I_Boat_Armed_01_minigun_F"} else {_vc = "I_Boat_Transport_01_F";};
	_cc = "I_Soldier_F";
};

private _v = createVehicle [_vc, _ps, [], 0, "NONE"];

//Create the boat crew and assign to the position with the vessel
private _g	= createGroup _gs;
private _bc	= _g createUnit [_cc, _ps, [], 0, "CORPORAL"]; _bc moveInDriver _v;

if (_gt) then {
	_bc	= _g createUnit [_cc, _ps, [], 0, "SERGEANT"]; _bc moveInCommander _v;
	_bc	= _g createUnit [_cc, _ps, [], 0, "SOLDIER"]; _bc moveInGunner _v;
} else {
	ADF__PI;
	for "_i" from 1 to 3 do {
		_bc = _g createUnit [_cc, _ps, [], 0, "SOLDIER"]; _bc moveInCargo _v;
	};	
};

[_g, _pp, _r, _c, _t, _b, _m, _s , _f , _cr] call ADF_fnc_seaPatrol;
ADF__diagTime("ADF_fnc_createSeaPatrol");

_v
