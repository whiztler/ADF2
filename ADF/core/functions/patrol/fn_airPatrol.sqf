/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: air patrol script
Author: Whiztler
Script version: 1.10

File: ADF_fnc_airPatrol.sqf
**********************************************************************************
This is an patrol function for aircraft. You can use it on pre-existing groups
or the function can create the group for you as well

INSTRUCTIONS:
load the function on mission start (e.g. in Scr\init.sqf):
call compile preprocessFileLineNumbers "ADF\modules\ADF_fnc_airPatrol.sqf";

*** PATROL ONLY ***

Config:
[
	group,				// Group name - Name of the group.
	position,				// Marker or Trigger Placed on water!
	radius,				// Number - Radius from the start position in which a waypoint is created
	Altitude,				// At which altitude should the aircraft patrol (above groud/sea level in meters)
	waypoints,			// Number - Number of waypoint for the patrol
	waypoint type,			// String. Info: https://community.bistudio.com/wiki/Waypoint_types
	behaviour,			// String. Info: https://community.bistudio.com/wiki/setWaypointBehaviour
	combat mode,			// String. Info: https://community.bistudio.com/wiki/setWaypointCombatMode
	speed,				// String. Info: https://community.bistudio.com/wiki/waypointSpeed
	formation,			// String. Info: https://community.bistudio.com/wiki/waypointFormation
	completion radius		// Number. Info: https://community.bistudio.com/wiki/setWaypointCompletionRadius
] call ADF_fnc_airPatrol;

Example for scripted air patrol`:
[_grp, _Position, 1000, 100, 5, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 250] call ADF_fnc_airPatrol;
[_grp, getMarkerPos "PatrolMarker", 1000, 100, 6, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 250] call ADF_fnc_airPatrol;

Example for editor placed (crewed) air vehicles:
[group this, position this, 1000, 100, 5, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 250] call ADF_fnc_airPatrol;
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_airPatrol.sqf");

params [
	"_g",
	"_p",
	["_r", 2500, [0]],
	["_h" , 100, [0]],
	["_c", 4, [0]],
	["_t", ["MOVE", "DESTROY", "GETIN", "SAD", "JOIN", "LEADER", "GETOUT", "CYCLE", "LOAD", "UNLOAD", "TR UNLOAD", "HOLD", "SENTRY", "GUARD", "TALK", "SCRIPTED", "SUPPORT", "GETIN NEAREST", "DISMISS", "LOITER"], [""]],
	["_b", ["UNCHANGED", "CARELESS", "SAFE", "AWARE", "COMBAT", "STEALTH"], [""]],
	["_m", ["NO CHANGE", "BLUE", "GREEN", "WHITE", "YELLOW", "RED"], [""]],
	["_s", ["UNCHANGED", "LIMITED", "NORMAL", "FULL"], [""]],
	["_f", ["NO CHANGE", "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"], [""]],
	["_cr", 250, [0]]
];
ADF__PI;

ADF__CHKPOSA(_p);
private _a = [_g, _p, _r, _t, _b, _m, _s, _f, _cr, "air", false];

// Loop through the number of waypoints needed
for "_i" from 0 to (_c - 1) do {_a call ADF_fnc_addWaypoint};

// Add a cycle waypoint
private _cx =+ _a;
_cx set [3, "CYCLE"];
_cx call ADF_fnc_addWaypoint;

// Remove the spawn/start waypoint
deleteWaypoint ((waypoints _g) select 0);

// Set the patrol altitude
private _gl = leader _g;
(vehicle _gl) flyInHeight _h;

true