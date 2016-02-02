/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: foot patrol script
Author: Whiztler
Script version: 1.09

File: ADF_fnc_footPatrol.sqf
**********************************************************************************
This is an infantry foot patrol function for pre-existing (editor placed or
scripted) groups

INSTRUCTIONS:
[
	group,				// Group name - Name of the group.
	position,				// Array or Position - E.g. getMarkerPos "Spawn" -or- Position Player
	radius,				// Number - Radius from the start position in which a waypoint is created
	waypoints,			// Number - Number of waypoint for the patrol
	waypoint type,			// String. Info: https://community.bistudio.com/wiki/Waypoint_types
	behaviour,			// String. Info: https://community.bistudio.com/wiki/setWaypointBehaviour
	combat mode,			// String. Info: https://community.bistudio.com/wiki/setWaypointCombatMode
	speed,				// String. Info: https://community.bistudio.com/wiki/waypointSpeed
	formation,			// String. Info: https://community.bistudio.com/wiki/waypointFormation
	completion radius		// Number. Info: https://community.bistudio.com/wiki/setWaypointCompletionRadius
	Search buildings		// TRUE / FALSE: search buildings within a 50 meter radius upon waypoint completion. Default = false
] call ADF_fnc_footPatrol;

Example for a scripted group:
[_myGroup, _patrolPosition, 300, 3, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5, true] call ADF_fnc_footPatrol;
[_myGroup, getMarkerPos "PatrolMarker", 500, 4, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5, false] call ADF_fnc_footPatrol;

Example for editor placed group:
[group this, position this, 300, 3, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5, false] call ADF_fnc_footPatrol;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_footPatrol.sqf");

params [
	"_g",
	"_p",
	["_r", 250, [0]],
	["_c", 4, [0]],
	["_t", ["MOVE", "DESTROY", "GETIN", "SAD", "JOIN", "LEADER", "GETOUT", "CYCLE", "LOAD", "UNLOAD", "TR UNLOAD", "HOLD", "SENTRY", "GUARD", "TALK", "SCRIPTED", "SUPPORT", "GETIN NEAREST", "DISMISS", "LOITER"], [""]],
	["_b", ["UNCHANGED", "CARELESS", "SAFE", "AWARE", "COMBAT", "STEALTH"], [""]],
	["_m", ["NO CHANGE", "BLUE", "GREEN", "WHITE", "YELLOW", "RED"], [""]],
	["_s", ["UNCHANGED", "LIMITED", "NORMAL", "FULL"], [""]],
	["_f", ["NO CHANGE", "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"], [""]],
	["_cr", 5, [0]],
	["_sb", false, [false]]
];
ADF__PI;

ADF__CHKPOS(_p);
_a = [_g, _p, _r, _t, _b, _m, _s, _f, _cr, "foot", _sb];

// Loop through the number of waypoints needed
for "_i" from 0 to (_c - 1) do {_a call ADF_fnc_addWaypoint};

// Add a cycle waypoint
private _cx =+ _a;
_cx set [3, "CYCLE"];
_cx call ADF_fnc_addWaypoint;

// Remove the spawn/start waypoint
deleteWaypoint ((waypoints _g) select 0);

true



