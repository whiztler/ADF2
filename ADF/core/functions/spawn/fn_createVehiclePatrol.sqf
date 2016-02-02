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
This function creates crewes a vehcile and sends the vehicle out on patrol.

INSTRUCTIONS:
[side, "vehicleClass", "SpawnMarker", "PatrolMarker", 800, 5, "MOVE", "SAFE", "RED", "LIMITED", 25] call ADF_fnc_createVehiclePatrol;
For example:
[independent, "I_G_Offroad_01_F", "mSpawn", "mPatrol", 800, 5, "MOVE", "SAFE", "RED", "LIMITED", 25] call ADF_fnc_createVehiclePatrol;

Notes
The function looks for roads. If no nearby road is found a waypoint is created
in the 'field'. Make sure the initial position is close to roads (or on a road)
and roads are within the radius. Keep the radius below 1500 else the script
might take a long time to search for suitable locations.

Returns
Vehicle object
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_vehiclePatrol.sqf");

ADF__diagInit;

// Init
params [
	["_gs", [west, east, independent], [east]],
	["_vc", "", [""]],
	"_ps",
	"_pp",
	["_r", 750,[0]],
	["_c", 4, [0]],
	["_t", ["MOVE", "DESTROY", "GETIN", "SAD", "JOIN", "LEADER", "GETOUT", "CYCLE", "LOAD", "UNLOAD", "TR UNLOAD", "HOLD", "SENTRY", "GUARD", "TALK", "SCRIPTED", "SUPPORT", "GETIN NEAREST", "DISMISS", "LOITER"], [""]],
	["_b", ["UNCHANGED", "CARELESS", "SAFE", "AWARE", "COMBAT", "STEALTH"], [""]],
	["_m", ["NO CHANGE", "BLUE", "GREEN", "WHITE", "YELLOW", "RED"], [""]],
	["_s", ["UNCHANGED", "LIMITED", "NORMAL", "FULL"], [""]],
	["_cr", 25,[0]]
];	

//Create the vehicle
private _g 	= createGroup _gs;
private _vd	= if (typeName _ps == "STRING") then {markerDir _ps} else {random 360};
ADF__CHKPOSA(_ps);

private _v = [_ps, _vd, _vc, _g] call BIS_fnc_spawnVehicle;

[_g, _pp, _r, _c, _t, _b, _m, _s, _cr, "car", false] call ADF_fnc_vehiclePatrol;

ADF__diagTime("ADF_fnc_createVehiclePatrol");

_v

