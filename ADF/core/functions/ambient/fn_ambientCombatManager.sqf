/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Ambient Combat Manager
Author: Whiztler
Script version: 1.12

Game type: N/A
File: ADF_fnc_ambientCombatManager.sqf
**********************************************************************************
This script creates ambient combat in a predefined area. The area
can be defined by a marker, an object, position array, etc.

The script has the following options:
- Ambient artillery/grenade explosions
- Ambient vehicle explosions
- Ambient small arms fire
- side selection enemy (west, east, independent)
- Intensity (from 1 to 10). 10 is very intensense and most resource heavy
- Duration. Can be set to run from anywhere from 1 minute to several hours
- Cancel function. Run ADF_cancel_ACM = true on the server to cancel ACM.
- Server FPS sentative. When the server FPS drops below 20, ACM will pause.

Small arms fire units is not visible so make sure the center position + radius
is not too close to players.

INSTRUCTIONS:
Place a marker or object on the map that represents the center of the ACM
radius.

CONFIG:
[
	"mACM",		// Marker (string), Object or array [x,y,z] -- The center of the position where ACM is active 
	750,			// Number -- Radius around the postion
	120,			// Number -- Time in MINUTES that ACM will be active on the position. You can have multiple ACM's with diffrent positions / times
	true,		// true/false -- True for ambient artillery/40 mike
	true,		// true/false -- True for ambient vehicle explosions
	true,		// true/false -- True for ambient small armas fire.
	east,		// east/west/independent -- Side of Opfor
	2,			// Number -- Intensity, 10 for maximum, 1 for minimum.
	250			// Number -- Min distance from player in meters.
] spawn ADF_fnc_ambientCombatManager;

EXAMPLE:
Example with a marker and 500 meter radius, 15 minutes:
["ACM_marker", 500, 15, true, true, true, east, 3, 150] spawn ADF_fnc_ambientCombatManager;

Example around position player and 800 meter radius, 25 minutes:
[position player, 800, 25, true, true, true, east, 3, 150] spawn ADF_fnc_ambientCombatManager;
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"


_ACM_explosion = {
	params [["_p", [0, 0, 0], [[]], [3]]];
	
	private _bc = ["Bo_GBU12_LGB", "M_Mo_82mm_AT_LG", "R_80mm_HE", "G_40mm_HE", "HelicopterExploBig"] call BIS_fnc_selectRandom;
	private _b = createVehicle [_bc, [_p select 0, _p select 1, (_p select 2) + 3], [], 0, "NONE"];
	
	if (ADF_debug) then {
		private _m = createMarker [["p_%1%2", round (random 500), round (_p select 1)], _p];
		_m setMarkerSize [.7, .7];
		_m setMarkerShape "ICON";
		_m setMarkerType "hd_dot";
		_m setMarkerColor "ColorYellow";
		diag_log format ["ADF Debug: _ACM_explosion - explosion created at position: %1", _p];
	};
	
	true
};

private _ACM_createAgent = {
	// init
	ADF__P1(_s);
	private _a	= "";
	private _uc	= "";
	
		// Check side
	switch _s do {
		case east		: {_a = "200Rnd_65x39_belt_Tracer_Green"; _uc = "o_soldier_f"};
		case west		: {_a = "200Rnd_65x39_belt_Tracer_Red"; _uc = "b_soldier_f"};
		case independent	: {_a = "200Rnd_65x39_belt_Tracer_Yellow"; _uc = "i_soldier_f"};
		default {_a = "200Rnd_65x39_belt_Tracer_Green"; _uc = "o_soldier_f"};
	};
	
	// Create the agent
	private _u = createAgent [_uc, [0, 0, 0], [], 0, "NONE"];	
	_u allowDamage false;
	_u setCaptive true;
	_u hideObject true;	

	// FSM aspects
	_u disableAI "anim";
	_u disableAI "move";
	_u disableAI "target";
	_u disableAI "autotarget";
	_u setBehaviour "careless";
	_u setCombatMode "blue";
	
	// Disarm and arm the agent
	removeAllWeapons _u;
	private _w = "FakeWeapon_moduleTracers_F";
	_u addMagazine _a;
	_u addWeapon _w;
	_u selectWeapon _w;
	_u switchMove "amovpercmstpsraswrfldnon";
	
	// Disable HC Loadbalacing and Caching
	private _g = group _u;
	_g setVariable ["ADF_noHC_transfer", true];
	_g setVariable ["zbe_cacheDisabled", true];
	
	_u
};


private _ACM_smallArms = {
	// init
	params ["_u", ["_p", [0, 0, 0], [[]], [3]]];

	_u setPosATL _p;
	
	if (ADF_debug) then {
		private _m = createMarker [["p_%1%2", round (random 500), round (_p select 1)], _p];
		_m setMarkerSize [.7, .7];
		_m setMarkerShape "ICON";
		_m setMarkerType "hd_dot";
		_m setMarkerColor "ColorWhite";
		diag_log format ["ADF Debug: _ACM_smallArms - small arms agent at position: %1", _p];
	};		
	
	_u setVehicleAmmo 1;
	
	// Smoke and flare effects
	if ((random 1) > 0.80) then {
		(["SmokeShell", "SmokeShellRed", "SmokeShellGreen"] call BIS_fnc_selectRandom) createVehicle _p;
	};
	if ((date select 3 >= 19) && (date select 3 < 4.5)) then {
		if ((random 1) > 0.90) then {
			private _f = (["F_40mm_Red", "F_40mm_White", "F_40mm_Green"] call BIS_fnc_selectRandom) createVehicle [_p select 0, _p select 1, (_p select 2) + 180];
			_f setVelocity [0, 0, -6.2];
		};
	};
	
	private _s = 0.05 + random 0.1;
	private _d = -5 + random 10;
	private _a = 30 + random 60;
	
	_u setDir (random 360);		
	[_u, _a, 0] call BIS_fnc_setPitchBank;
	
	sleep 0.1;
	
	_time = time + 0.1 + random 0.9;
	
	while {time < _time} do {
		_u forceWeaponFire [primaryWeapon _u, "MANUAL"];
		sleep _s;
		_u setDir (direction _u + _d);
		[_u, _a, 0] call BIS_fnc_setPitchBank;
		if (random 1 > 0.95) then {sleep (2 * _s)};
	};
	
	true
};


	
private _ACM_vehicle = {
	params [["_p", [0, 0, 0], [[]], [3]], ["_r", 750, [0]]];
	
	_p = [_p, _r] call ADF_fnc_roadPos;
	
	private _vc = ["O_MRAP_02_F", "O_Truck_02_covered_F", "O_MBT_02_arty_F", "O_APC_Tracked_02_cannon_F"] call BIS_fnc_selectRandom;
	private _v = createVehicle [_vc, _p, [], 0, "CAN COLLIDE"];	
	_v setDamage 1;
	
	if (ADF_debug) then {
		private _m = createMarker [format ["p_%1%2", round (random 500), round (_p select 1)], _p];
		_m setMarkerSize [.7, .7];
		_m setMarkerShape "ICON";
		_m setMarkerType "hd_dot";
		_m setMarkerColor "ColorRed";
		diag_log format ["ADF Debug: _ACM_vehicle - vehicle created at position: %1", _p];
	};
	
	sleep 60;
	deleteVehicle _v;
	
	true
};	
	
// init
params [
	"_p", 
	["_r", 10, [0]],
	["_t", 20, [0]],
	["_b", true, [true]],
	["_v", true, [true]],
	["_s", true, [true]],
	["_f", east, [east]],
	["_y", 2, [0]],
	["_d", 150, [0]]
];
ADF_cancel_ACM	= false;
private _w		= 2;
private _u		= objNull;
diag_log format ["ADF RPT: Starting ADF_fnc_ACM. Params: %1, %2, %3, %4, %5, %6, %7, %8, %9", _p, _r, _t, _b, _v, _s, _f, _y, _d];

// Check the position (marker, array, etc.)
ADF__CHKPOS(_p);
// convert minutes to seconds
_t = _t * 60;

// Cycle time
if (_t < 6) then {
	_w = (_y / 10) + 1.3;		
} else {
	_w = (_y / 10) + 2;
};	

// Intensity	
_y = 1 - (_y / 10);
if (_y < 0.1) then {_y = 0.1};
if (_y > 0.8) then {_y = 0.8};	

// Create agent for small arms function
if (_s) then {_u = [_f] call _ACM_createAgent};

if (ADF_debug) then {
	private _m = createMarker [["m_%1%2", round (random 999), round (random 999)], _p];
	_m setMarkerSize [_r, _r];
	_m setMarkerShape "ELLIPSE";
	_m setMarkerBrush "Solid";
	_m setMarkerColor "ColorGreen";
};	

for "_i" from _t to 0 step -1 do {
	private _dt 		= diag_tickTime;
	private _c		= random 1;
	private _fps		= 0;

	// Select a random position within the pre-defined radius
	private _a	= [_p, _r, random 360] call ADF_fnc_randomPos;
	
	// Check FPS in multiplayer
	if (isMultiplayer) then {_fps = diag_fps} else {_fps = 25};
	
	// No effects when FPS drops below 20
	if (_fps > 20) then {
		// Check if no players are near
		if ({alive _x && _a distance _x < _d} count allPlayers == 0) then {
			// Select a random effect
			if (_b && _c > 0.5 && (random 1) > _y) then {[_a] call _ACM_explosion};
			if (_v && _c < 0.5 && ((random 1) > (_y + 0.1))) then {[_a, _r] spawn _ACM_vehicle};
			if (_s && ((random 1) > (_y - 0.1))) then {[_u, _a] call _ACM_smallArms};
		};
	} else {
		_w = 5; // FPS below 20. Sleep 5 seconds.
	};
	
	if (ADF_debug) then {
		hintSilent format ["ACM Timer: %1 left (FPS: %2)", [((_i) / 60) + .01, "HH:MM"] call BIS_fnc_timeToString, _fps];
		diag_log format ["ADF Debug: ADF_fnc_ACM - Cycle diag: %1", diag_tickTime - _n];			
	};
	ADF__diagTime("ADF_fnc_ACM cycle");
	
	// Cancel function for scripts. To cancel ACM: ADF_cancel_ACM = true; // (server)
	if (ADF_cancel_ACM) exitWith {ADF__DBGVAR1("ADF Debug: ADF Debug: ADF_fnc_ACM - ACM cancelled at cycle %1", _i)};
	
	sleep _w;
};

// Delete the small arms agent if small arms was activated.
if (_s) then {deleteVehicle _u; deleteGroup (group _u); _u = nil};
ADF__RPTLOG("ADF RPT: ADF RPT: ADF_fnc_ACM finished.");

true
