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

File: ADF_fnc_createFootPatrol.sqf
**********************************************************************************
This is an infantry foot patrol function for pre-existing (editor placed or
scripted) groups

INSTRUCTIONS:
[
	position,			// Marker, Object or Trigger. E.g.. getMarkerPos "Spawn" -or- "SpawnPos" -or- MyObject
	side,				// west, east or independent
	group size,			// 2 (sentry), 4 (fireteam), 8 squad
	weapons squad,		// TRUE or FALSE
	radius,				// Number - Radius from the start position in which a waypoint is created
	waypoints,			// Number - Number of waypoint for the patrol
	waypoint type,			// String. Info: https://community.bistudio.com/wiki/Waypoint_types
	behaviour,			// String. Info: https://community.bistudio.com/wiki/setWaypointBehaviour
	combat mode,			// String. Info: https://community.bistudio.com/wiki/setWaypointCombatMode
	speed,				// String. Info: https://community.bistudio.com/wiki/waypointSpeed
	formation,			// String. Info: https://community.bistudio.com/wiki/waypointFormation
	completion radius		// Number. Info: https://community.bistudio.com/wiki/setWaypointCompletionRadius
	Search buildings		// TRUE / FALSE: search buildings within a 50 meter radius upon waypoint completion. Default = false
] call ADF_fnc_createFootPatrol;

EXAMPLES:
[_spawnPos, west, 6, FALSE, 300, 5, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5, TRUE] call ADF_fnc_createFootPatrol;
[getMarkerPos "myMarker", east, 8, TRUE, 500, 6, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5, FALSE] call ADF_fnc_createFootPatrol;

RETURNS:
Group
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_footPatrol.sqf");

// Init
ADF__diagInit;
params [
	"_p",
	["_gs", [west, east, independent], [west]],
	["_gc", 5,[0]],
	["_gw", FALSE, [FALSE]],
	["_r", 250,[0]],
	["_c", 4,[0]],
	["_t", ["MOVE", "DESTROY", "GETIN", "SAD", "JOIN", "LEADER", "GETOUT", "CYCLE", "LOAD", "UNLOAD", "TR UNLOAD", "HOLD", "SENTRY", "GUARD", "TALK", "SCRIPTED", "SUPPORT", "GETIN NEAREST", "DISMISS", "LOITER"], [""]],
	["_b", ["UNCHANGED", "CARELESS", "SAFE", "AWARE", "COMBAT", "STEALTH"], [""]],
	["_m", ["NO CHANGE", "BLUE", "GREEN", "WHITE", "YELLOW", "RED"], [""]],
	["_s", ["UNCHANGED", "LIMITED", "NORMAL", "FULL"], [""]],
	["_f", ["NO CHANGE", "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"], [""]],
	["_cr", 5,[0]],
	["_sb", false, [false]]
];

ADF__CHKPOS(_p);

private _gID		= "";
private _gSide	= "";
private _gFact	= "";

// check group size/type
private _gSize = switch (_gc) do {
	case 1;
	case 2: {"InfSentry"};
	case 3;
	case 4;
	case 5: {"InfTeam"};
	case 6;
	case 7;
	case 8: {if (_gw) then {"InfSquad_Weapons"} else {"InfSquad"}};		
	default {"InfTeam"};
};

switch (_gs) do {
	case west:		{_gSide = "west"; _gFact = "BLU_F"; _gID = "BUS_"};
	case east: 		{_gSide = "east"; _gFact = "OPF_F"; _gID = "OIA_"};
	case independent:	{_gSide = "INDEP"; _gFact = "IND_F"; _gID = "HAF_"};
};

private _gStr = _gID + _gSize;

//Create the group
private _g = [_p, _gs, (configFile >> "CfgGroups" >> _gSide >> _gFact >> "Infantry" >> _gStr)] call BIS_fnc_spawnGroup;

[_g, _p, _r, _c, _t, _b, _m, _s, _f, _cr, _sb] call ADF_fnc_footPatrol;
ADF__diagTime("ADF_fnc_createFootPatrol");

_g	
