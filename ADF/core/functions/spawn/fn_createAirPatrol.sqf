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
This functions creates a crewed aircraft and assigns the crew with a designated
patrol area.

INSTRUCTIONS:

[
	Spawn position,		// E.g. getMarkerPos "Spawn" -or- Position Player
	Patrol position,		// E.g. getMarkerPos "Patrol" -or- Position Player
	side,				// west, east or independent
	Aircraft,				// Number:
						// 1 - Unarmed transport helicopter
						// 2 - Armed transport helicopter
						// 3 - Attack helicopter
						// 4 - Fighter jet
						// 5 - UAV
	radius,				// Number - Radius from the start position in which a waypoint is created
	Altitude,				// Number - At which altitude should the aircraft patrol (above groud/sea level in meters)	
	waypoints,			// Number - Number of waypoint for the patrol
	waypoint type,			// String. Info: https://community.bistudio.com/wiki/Waypoint_types
	behaviour,			// String. Info: https://community.bistudio.com/wiki/setWaypointBehaviour
	combat mode,			// String. Info: https://community.bistudio.com/wiki/setWaypointCombatMode
	speed,				// String. Info: https://community.bistudio.com/wiki/waypointSpeed
	formation,			// String. Info: https://community.bistudio.com/wiki/waypointFormation
	completion radius		// Number. Info: https://community.bistudio.com/wiki/setWaypointCompletionRadius
] call ADF_fnc_createAirPatrol;

Example for scripted spawn:
[_spawnPos, _patrolPos, west, 1, 2500, 100, 5, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 250] call ADF_fnc_createAirPatrol;
[getMarkerPos "myMarker", getMarkerPos "PatrolMarker", east, 2, 3500, 50, 6, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 250] call ADF_fnc_createAirPatrol;
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_airPatrol.sqf");

// Init
ADF__diagInit;
params [
	"_ps",
	"_pp",
	["_gs", [west, east, independent], [west]],
	["_gc", 1, [0]],
	["_r", 2500, [0]],
	["_h", 100, [0]],		
	["_c", 4, [0]],
	["_t", ["MOVE", "DESTROY", "GETIN", "SAD", "JOIN", "LEADER", "GETOUT", "CYCLE", "LOAD", "UNLOAD", "TR UNLOAD", "HOLD", "SENTRY", "GUARD", "TALK", "SCRIPTED", "SUPPORT", "GETIN NEAREST", "DISMISS", "LOITER"], [""]],
	["_b", ["UNCHANGED", "CARELESS", "SAFE", "AWARE", "COMBAT", "STEALTH"], [""]],
	["_m", ["NO CHANGE", "BLUE", "GREEN", "WHITE", "YELLOW", "RED"], [""]],
	["_s", ["UNCHANGED", "LIMITED", "NORMAL", "FULL"], [""]],
	["_f", ["NO CHANGE", "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"], [""]],
	["_cr", 5, [0]]
];
private _vc = "";

ADF__CHKPOSA(_ps);

if (_gs == west) then {
	switch (_gc) do {
		case 1: {_vc = ["B_Heli_Light_01_F", "B_Heli_Transport_03_unarmed_F", "B_Heli_Transport_03_unarmed_green_F"] call BIS_fnc_selectRandom};
		case 2: {_vc = ["B_Heli_Transport_01_F", "B_Heli_Transport_01_camo_F", "B_Heli_Transport_03_F", "B_Heli_Transport_03_black_F"] call BIS_fnc_selectRandom};
		case 3: {_vc = ["B_Heli_Attack_01_F", "B_Heli_Light_01_armed_F"] call BIS_fnc_selectRandom};
		case 4: {_vc = "B_Plane_CAS_01_F"};
		case 5: {_vc = "B_UAV_02_CAS_F"};
	}
};
if (_gs == east) then {
	switch (_gc) do {		
		case 1: {_vc = ["O_Heli_Light_02_unarmed_F", "O_Heli_Transport_04_F", "O_Heli_Transport_04_ammo_F", "O_Heli_Transport_04_bench_F", "O_Heli_Transport_04_box_F", "O_Heli_Transport_04_covered_F", "O_Heli_Transport_04_fuel_F", "O_Heli_Transport_04_medevac_F", "O_Heli_Transport_04_repair_F", "O_Heli_Transport_04_black_F"] call BIS_fnc_selectRandom};
		case 2: {_vc = ["O_Heli_Light_02_F", "O_Heli_Light_02_v2_F"] call BIS_fnc_selectRandom};
		case 3: {_vc = ["O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F"] call BIS_fnc_selectRandom};
		case 4: {_vc = "O_Plane_CAS_02_F"};
		case 5: {_vc = "O_UAV_02_CAS_F"};
	};
};
if (_gs == independent) then {
	switch (_gc) do {
		case 1: {_vc = ["I_Heli_light_03_unarmed_F", "I_Heli_Transport_02_F"] call BIS_fnc_selectRandom};
		case 2: {_vc = "I_Heli_light_03_F"};
		case 3: {_vc = "I_Heli_light_03_F"};
		case 4: {_vc = ["I_Plane_Fighter_03_CAS_F", "I_Plane_Fighter_03_AA_F"] call BIS_fnc_selectRandom};
		case 5: {_vc = "I_UAV_02_CAS_F"};
	};
};

private _g = createGroup _gs;
private _v = [_ps, (random 360), _vc, _g] call BIS_fnc_spawnVehicle;
(_v select 0) setPosATL [_ps select 0, _ps select 1, _h];

[_g, _pp, _r, _h, _c, _t, _b, _m, _s , _f , _cr] call ADF_fnc_airPatrol;
ADF__diagTime("ADF_fnc_createAirPatrol");

true	
