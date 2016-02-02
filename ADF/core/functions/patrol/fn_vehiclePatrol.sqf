/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: (Create) Vehicle patrol script
Author: Whiztler
Script version: 1.04

Game type: N/A
File: ADF_fnc_vehiclePatrol.sqf
**********************************************************************************
This is a vehicle patrol function for pre-spawned/editor placed (crewed) vehciles.

INSTRUCTIONS:

in the init of the vehicle:
[
	group,				// Group name - Name of the group.
	position,				// Array or Position - E.g. getMarkerPos "Spawn" -or- Position Player
	radius,				// Number - Radius from the start position in which a waypoint is created
	waypoints,			// Number - Number of waypoint for the patrol
	waypoint type,			// String. Info: https://community.bistudio.com/wiki/Waypoint_types
	behaviour,			// String. Info: https://community.bistudio.com/wiki/setWaypointBehaviour
	combat mode,			// String. Info: https://community.bistudio.com/wiki/setWaypointCombatMode
	speed,				// String. Info: https://community.bistudio.com/wiki/waypointSpeed
	completion radius		// Number. Info: https://community.bistudio.com/wiki/setWaypointCompletionRadius
] call ADF_fnc_vehiclePatrol;

Example for scripted vehicles:
[_grp, _myPosition, 800, 5, "MOVE", "SAFE", "RED", "LIMITED", 25] call ADF_fnc_vehiclePatrol;
[_c, "PatrolMarker", 1000, 6, "MOVE", "SAFE", "RED", "LIMITED", 25] call ADF_fnc_vehiclePatrol;

Example for editor placed crewed vehicles:
[group this, position this, 800, 5, "MOVE", "SAFE", "RED", "LIMITED", 25] call ADF_fnc_vehiclePatrol;

Returns
Bool

Notes
The function looks for roads. If no nearby road is found a waypoint is created
in the 'field'. Make sure the initial position is close to roads (or on a road)
and roads are within the radius. Keep the radius below 1500 else the script
might take a long time to search for suitable locations.
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_vehiclePatrol.sqf");

ADF__diagInit;
// Init
params [
	"_g",
	"_p",
	["_r", 750,[0]],
	["_c", 4, [0]],
	["_t", ["MOVE", "DESTROY", "GETIN", "SAD", "JOIN", "LEADER", "GETOUT", "CYCLE", "LOAD", "UNLOAD", "TR UNLOAD", "HOLD", "SENTRY", "GUARD", "TALK", "SCRIPTED", "SUPPORT", "GETIN NEAREST", "DISMISS", "LOITER"], [""]],
	["_b", ["UNCHANGED", "CARELESS", "SAFE", "AWARE", "COMBAT", "STEALTH"], [""]],
	["_m", ["NO CHANGE", "BLUE", "GREEN", "WHITE", "YELLOW", "RED"], [""]],
	["_s", ["UNCHANGED", "LIMITED", "NORMAL", "FULL"], [""]],
	["_cr", 25,[0]]
];
ADF__PI;

ADF__CHKPOSA(_p);

private _a = [_g, _p, _r, _t, _b, _m, _s, "COLUMN", _cr, "road", false];
// Loop through the number of waypoints needed
for "_i" from 0 to (_c - 1) do {_a call ADF_fnc_addWaypoint};

// Add a cycle waypoint
private _cycle =+ _a;
_cycle set [4, "CYCLE"];
_cycle call ADF_fnc_addWaypoint;

// Remove the spawn/start waypoint
deleteWaypoint ((waypoints _g) select 0);

ADF__diagTime("ADF_fnc_vehiclePatrol");

true
