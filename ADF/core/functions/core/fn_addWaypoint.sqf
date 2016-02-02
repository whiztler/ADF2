/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_addWaypoint
Author: Whiztler
Script version: 1.01

File: fn_addWaypoint.sqf
**********************************************************************************
This function is used by various scripts and functions to create random waypoints.
It can also be used to add manual waypoints

INSTRUCTIONS:
Call from script on the server

REQUIRED PARAMETERS:
0. Group - Existing group that gets the waypoints assigned
1. Array - Position [X,Y,Z] 
2. Number - Radius in meters

OPTIONAL PARAMETERS:
3. String - Waypoint type. Info: https://community.bistudio.com/wiki/Waypoint_types
4. String - Waypoint behavior. Info: https://community.bistudio.com/wiki/setWaypointBehaviour
5. String - Combat mode. Info: https://community.bistudio.com/wiki/setWaypointCombatMode
6. String - Travel speed. Info: https://community.bistudio.com/wiki/waypointSpeed
7. String - Formation. Info: https://community.bistudio.com/wiki/waypointFormation
8. Number - Completion radius. Info: https://community.bistudio.com/wiki/setWaypointCompletionRadius
9. String - "foot", "road", "air", "sea". The type of group/vehicle to create the waypoint(s) for.
10. Bool - Search buildings (only for "foot" patrols):
			- true: search buildings
			- false: Do not search buildings (default)


EXAMPLE
[_aiGroup, getMarkerPos "patrol", 500, "MOVE", "COMBAT", "LIMITED", "COLUMN", 15, false] call ADF_fnc_addWaypoint;

RETURNS:
Array (Waypoint)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_addWaypoint");

// init	
params [
	["_g", grpNull, [grpNull]],
	["_p", [0,0,0], [[]], [3]],
	["_r", 250,[0]],
	["_t", ["MOVE", "DESTROY", "GETIN", "SAD", "JOIN", "LEADER", "GETOUT", "CYCLE", "LOAD", "UNLOAD", "TR UNLOAD", "HOLD", "SENTRY", "GUARD", "TALK", "SCRIPTED", "SUPPORT", "GETIN NEAREST", "DISMISS", "LOITER"], [""]],
	["_b", ["UNCHANGED", "CARELESS", "SAFE", "AWARE", "COMBAT", "STEALTH"], [""]],
	["_m", ["NO CHANGE", "BLUE", "GREEN", "WHITE", "YELLOW", "RED"], [""]],
	["_s", ["UNCHANGED", "LIMITED", "NORMAL", "FULL"], [""]],
	["_f", ["NO CHANGE", "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"], [""]],
	["_cr", 5,[0]], 
	["_w", ["foot", "road", "air", "sea"], [""]],
	["_sb", false, [true]]
];
private _d = random 360;

ADF__DBGVAR1("ADF Debug: ADF_fnc_addWaypoint - WP radius: %1", _r);
ADF__PI;

switch _w do {
	case "foot"	: {
		for "_i" from 1 to 3 do {
			private _k = [_p, _r, _d] call ADF_fnc_randomPos;				
			if !(surfaceIsWater _k) exitWith {_p = _k};
			_r = _r + 25;
		};		
	};
	case "road"	: {
		private _rx = _r / _c; // radius divided by number of waypoints
		private _rd = [];
		ADF__DBGVAR3("ADF Debug: ADF_fnc_addRoadWaypoint - WP radius: %1 (%2 / %3)", _rx, _r, _c);

		// Find road position within the parameters (near to the random position)
		for "_i" from 1 to 4 do {
			private _k = [_p, _r, random 360] call ADF_fnc_randomPos;
			_rd = [_k, _rx] call ADF_fnc_roadPos;		
			if (isOnRoad _rd) exitWith {_p = _rd};
			_rx = _rx + 250;
			if (_i == 3) then {_rx = _rx + 500};
			if (_i == 4) then {_p = [_p, _r, (random 180) + (random 180)] call ADF_fnc_randomPosMax;};
		};
	};
	case "air"	: {
		_p = [_p, _r, ((random 180) + (random 180))] call ADF_fnc_randomPos;	
	};
	case "sea"	: {
		for "_i" from 1 to 10 do {
			private _k = [_p, _r, random 360] call ADF_fnc_randomPos;	
			private _d = _k getTerrainHeightASL select 2;
			if (surfaceIsWater _k && _d > -5) exitWith {_p = _k};
			_r = _r + 50;
		};			
	};
};

// Create the waypoint
private _wp = _g addWaypoint [_p, 0];
_wp setWaypointType _t;
_wp setWaypointBehaviour _b;
_wp setWaypointCombatMode _m;
_wp setWaypointSpeed _s;
_wp setWaypointFormation _f;
_wp setWaypointCompletionRadius _cr;
if (_sb) then {_wp setWaypointStatements ["TRUE", "this spawn ADF_fnc_searchBuilding"]};	

// return the waypoint
_wp 
