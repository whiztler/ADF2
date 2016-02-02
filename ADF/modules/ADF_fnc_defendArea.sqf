/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Defend area script
Author: Whiztler
Script version: 1.32

File: ADF_fnc_defendArea.sqf
**********************************************************************************
This is a defend/garrison script based on CBA_fnc_taskDefend by Rommel. The script
garrisons units in empty buildings, static weapons and vehicle turrets. Units that
have not been garrisoned will go on patrol in the assigned (radius) area.

CONFIG:

In your script add:
[
	group,				// Group name - Name of the group.
	position,				// Position Array, marker or object - E.g. "MyMarker" -or- Object
	radius				// Number - Radius from the start position in which a waypoint is created
] call ADF_fnc_defendArea;

Example for scripted groups:
[_grp, MyObject, 100] call ADF_fnc_defendArea;
[_grp, getMarkerPos "PatrolMarker", 75] call ADF_fnc_defendArea;

Notes
Run on server only!

Lock (all) the vehicle to prevent AI's from populating the turret/static weapon.
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_defendArea.sqf");

ADF_debug_bPos = false; // enable to test building positions (yellow sphere ingame and yellow dot on the map)


ADF_fnc_getTurrets = {
	/**********************************************************************
	The getTurrets function is called by the defendArea function. It creates
	and populates an array of empty unlocked static weapons and vehicles with 
	empty turrets.
	If you have vehciles on the map you DO NOT want to be populated by AI's,
	then 'LOCK' the vehicle (not player lock!)
	***********************************************************************/
	// init
	params [["_p", [0, 0, 0], [[]], [3]],["_r", 10,[0]]];
	private _t = [];
	private _a = [];	
	
	// Create array of empty static turrets
	{_t append (_p nearEntities [[_x], _r])} forEach ["TANK", "APC", "CAR", "StaticWeapon"];
	// Remove already populated turrest from the array
	{if ((_x emptyPositions "gunner") > 0 && ((count crew _x) == 0 && (locked _x) != 2)) then {_a append [_x]}} forEach _t;
	ADF__DBGVAR1("ADF Debug: ADF_fnc_defendArea - Turrets array: %1",_a);

	// return turrets array
	_a
};

ADF_fnc_setGarrison = {
	/**********************************************************************
	The setGarrison function is executed by the defendArea function for
	units that have been assigned a position within a building.
	It makes the unit move (walk/run) to the position. Once at the position
	the unit will be disabled to move untill a thread has been detected.
	**********************************************************************/
	// init
	ADF__diagInit;
	params ["_u", ["_p", [0, 0, 0], [[]], [3]], ["_b", objNull, [objNull]]];
	
	// Move the unit inside the predefined building position. Give the unit 60 secs to reach its position.	
	private _t = time;
	_u doMove _p;
	sleep 5;
	waitUntil {unitReady _u || (time == _t + 60)};
	
	// Set unit just in case the building or building position is bugged
	_u allowDamage false; _u setPosATL [_p select 0, _p select 1, ( _p select 2) + .15]; _u allowDamage true;
	
	// Attempt to make the unit face outside 
	private _d = (([_u, _b] call BIS_fnc_dirTo) - 180);
	 if (_d < 0) then {_d = _d + 360};
	_u setFormDir _d;
	ADF__SVAR(_u,ADF_garrSetDir,_d);
	if !([_u] call ADF_fnc_outsidePosUnit) then {_u setUnitPos "MIDDLE"} else {_u setUnitPos "_UP"};

	_u disableAI "move";
	doStop _u;
	
	//_u setVariable ["ADF_garrSetBuilding", [true, _p]];
	
	ADF__diagTime("ADF_fnc_setGarrison");
	waitUntil {sleep 1 + (random 1); !(unitReady _u)};
	_u enableAI "move";
};

ADF_fnc_setTurretGunner = {
	/**********************************************************************
	The setTurretGunner function is executed by the defendArea function for
	units that have been assigned to a static weapon or a turret in an empty
	vehicle. The skill set of turret units is increased to make them more
	responsive to threads.
	If you have vehciles on the map you DO NOT want to be populated by AI's,
	then 'LOCK' the vehicle (not player lock!)
	***********************************************************************/
	// init
	params ["_u"];
	
	// Increase gunner skill so they are more responsive to approaching enemies
	_u setSkill ["spotDistance",.7 + (random .3)];
	_u setSkill ["spotTime",.7 + (random .3)];
	_u setSkill ["aimingAccuracy",.4 + (random .3)];
	_u setSkill ["aimingSpeed",.4 + (random .3)];
	_u setCombatMode "YELLOW";

	true
};

ADF_fnc_defendAreaPatrol = {
	/**********************************************************************
	The defendAreaPatrol function is executed by the defendArea function for
	units that cannot be garrisoned (no buildings, or no positions left).
	The remaining units are grouped in a new group and send out to patrol
	the area. Same radius as the garrison area radius.
	***********************************************************************/
	// Init
	ADF__diagInit;
	ADF__P4(_i,_g,_p,_r);
	private _u	= units _g;
	private _a	= [];
	
	ADF__DBGVAR1("ADF Debug: ADF_fnc_defendAreaPatrol - Group units: %1",_u);
	
	// Check if the unit is garrisoned
	{
		if !(ADF__GVAR(_x,ADF_garrSet,true)) then {
			_a append [_x];
			ADF__DBGVAR2("ADF Debug: ADF_fnc_defendAreaPatrol - Unit: %1 -- ADF_garrSet: %2",_x, ADF__GVAR(_x,ADF_garrSet,true));
		}
	} forEach _u;	
	
	ADF__DBGVAR3("ADF Debug: ADF_fnc_defendAreaPatrol - # garrisoned units: %1 -- # patrol units: %2 -- Patrol units: %3",_i,count _a,_a);
	
	// Create a new group for not-garrisoned units 
	private _gt = createGroup (side _g);
	{[_x] joinSilent _gt} forEach _a;
	
	if (_r < 75) then {_r = 75};
	[_gt, _p, _r, 4, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5] call ADF_fnc_footPatrol;
	ADF__SVAR(_gt,ADF_hc_garrison_ADF,false);
	_gt enableAttack true;
	
	ADF__diagTime("ADF_fnc_defendAreaPatrol");
};

ADF_fnc_defendArea = {
	/**********************************************************************
	This is the main function which is called by scripts.	
	**********************************************************************/
	// init
	ADF__diagInit;
	params ["_g", "_p", ["_r", 10, [0]]];
	private _a 	= [];
	private _u	= units _g;
	private _c	= count _u;
	private _i	= 0;
	private _l	= 0;	
	
	// Check the position (marker, array, etc.)
	ADF__CHKPOSA(_p);
	// Populate an array with suitable garrison buildings
	private _bs	= [_p, _r] call ADF_fnc_buildingPositions;
	// Populate an array with turret positions (statics and empty vehicles)
	private _t	= [_p, _r] call ADF_fnc_getTurrets;

	if (ADF_debug) then {
		diag_log format ["ADF Debug: ADF_fnc_defendArea - Group: %1 -- # units: %2", _g, _c];
		diag_log format ["ADF Debug: ADF_fnc_defendArea - Turrets found: %1", (count _t)];
	};
	
	_g enableAttack false;

	// Modified CBA_fnc_taskDefend by Rommel et all	
	{		
		// init
		private _ct	= (count _t) - 1;
		_l = _l + 1;
		ADF__SVAR(_x,ADF_garrSet,false);
		
		// Populate static weapons and vehicles with turrets first
		if ((_ct > -1) && (_x != leader _g)) then {
			_x assignAsGunner (_t select _ct);
			_x moveInGunner (_t select _ct);
			[_x] call ADF_fnc_setTurretGunner;
			_t resize _ct;

			ADF__SVAR(_x,ADF_garrSet,true);
			_i = _i + 1;
		// All turrets populated, populate building positions
		} else {
			if (count _bs > 0) then {
				private _bp = [];
				
				private _b = _bs call BIS_fnc_selectRandom;
				private _p = ADF__GVAR(_b,ADF_garrPos,[]);
				
				// Create a spread when the nr of buildings > number of units
				if ((count _bs) >= _c) then {_bs = _bs - [_b]};
				
				if ((count _p) > 0) then {
				
					// In case there are multiple building positions within the bui;ding, check for high altitude positions for rooftop placement
					if ((count _p) > 1) then {
						// 60 percent change for rooftops / toop floor
						if ((random 1) > 0.4) then {
							private _ap 	= [_p, ADF_fnc_altitudeDescending] call ADF_fnc_positionArraySort;
							_bp	= _ap select 0;							
						} else {
							_bp = _p call BIS_fnc_selectRandom;
						};
					} else {
						_bp = _p select 0;
					};

					// Remove the populated position from the array
					_p	= _p - [_bp];
					
					// Check if there are positions left within the building else remove the building from the buildings array. Set the building varaibles accordingly.
					if ((count _p) == 0) then {
						_bs = _bs - [_b];
						ADF__SVAR(_b,ADF_garrPos,[]);
						ADF__SVAR(_b,ADF_garrPosAvail,false);
					} else {
						ADF__SVAR(_b,ADF_garrPos,_p);
					};
					
					// Unit now has a random position within a random building. Pass it the the setGarrison function so thsat the unit will move into the selected position.
					[_x, _bp, _b] spawn ADF_fnc_setGarrison;
					
					// Set the ADF_garrSet for the unit and add his position to an array that is used for headless client management.
					ADF__SVAR(_x,ADF_garrSet,true);
					_a append [[_x, _bp]];
					ADF__DBGVAR1("ADF Debug: ADF_fnc_defendArea - Unit garrisson array: %1",_a);
					_i = _i + 1;
				
				} else {ADF__DBGVAR2("ADF Debug: ADF_fnc_defendArea - No positions found for unit %1 (nr. %2)",_x,_l)};
			};
		};
	} forEach _u;
	
	// Clean up the building variables
	[_bs] spawn {
		sleep 30; // wait 1/2 min before removing the stored building positions as other groups might occupy the same building.
		ADF__P1(_bs);
		{ADF__SVAR(_x,ADF_garrPos,nil)} forEach _bs;		
	};

	// Set HC loadbalancing variables if a HC is active
	if (ADF_HC_connected) then {
		ADF__SVAR(_g,ADF_hc_garrison_ADF,true);
		ADF__SVAR(_g,ADF_hc_garrisonArr,_a);
		ADF__DBGVAR2("ADF Debug: ADF_fnc_defendArea - ADF_hc_garrisonArr set for group: %1 -- array: %2",_g,_a);
	};

	// Non garrisoned units patrol the area	
	waitUntil {_c == _l};
	if (_i < _c) then {[_i, _g, _p, _r] spawn ADF_fnc_defendAreaPatrol};

	ADF__diagTime("ADF_fnc_defendArea");
	
	true
};

ADF_fnc_defendArea_HC = {
	/**********************************************************************
	The defendArea_HC function is used by HC's with the loadBalancer active.
	Without this function, garrisoned units would regroup on their leader
	after group ownership transfer (server to HC).
	The function is executed once the HC has ownership of the group. It 
	re-applies garrison positions for each units within the group.
	***********************************************************************/
	// init
	ADF__diagInit;
	ADF__P2(_g,_a);
	ADF__PI;
	
	private _c = count _a;
	if (_c == 0) exitWith {ADF__DBGVAR2("ADF Debug: ADF_fnc_defendArea_HC - Passed array: %1 seems to be empty (%2)",_a,_c)};
	_g enableAttack false;	
	
	ADF__DBGVAR3("ADF Debug: ADF_fnc_defendArea_HC - group: %1 -- array count: %2 -- array: %3",_g,_c,_a);
	
	// reapply garrison position for each unit
	for "_i" from 0 to (_c - 1) do {
		private _u	= (_a select _i) select 0;
		private _up	= (_a select _i) select 1;
		
		_u setPosATL [_up select 0, _up select 1, ( _up select 2) + .15]; // Direct placement without movement.
		ADF__DBGVAR2("ADF Debug: ADF_fnc_defendArea_HC - SetPosATL for unit: %1 -- position: %2",_u,_up);
		_u disableAI "move";
		if ((_up select 2) > 4) then {_u setUnitPos "MIDDLE"} else {_u setUnitPos "_UP"};
		_u setDir (ADF__GVAR(_u,ADF_garrSetDir,(random 360)));		
		doStop _u;
		
		[_u] spawn {
			params ["_u"];
			waitUntil {sleep 1 + (random 1); !(unitReady _u)};
			_u enableAI "move";
		};
	};
	
	ADF__diagTime("ADF_fnc_objectMarker");
};